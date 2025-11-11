<?php

namespace App\Http\Controllers;

use App\Models\ClientContact;
use App\Models\Client;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class ClientContactController extends Controller
{
    /**
     * Display a listing of the contacts.
     */
    public function index(Request $request)
    {
        $query = ClientContact::query();
        
        if ($request->has('client_id')) {
            $query->where('client_id', $request->client_id);
        }
        
        if ($request->has('search')) {
            $search = $request->input('search');
            $query->where(function($q) use ($search) {
                $q->where('first_name', 'like', "%{$search}%")
                  ->orWhere('last_name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%");
            });
        }
        
        $perPage = $request->input('per_page', 15);
        
        $contacts = $query->orderByDesc('is_responsable')->orderBy('id', 'desc')->paginate($perPage);

        return response()->json($contacts);
    }

   
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'client_id' => 'required|exists:client,id',
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'email' => 'required|email|max:255|unique:client_contact,email', 
            'phone' => 'nullable|string|max:20|regex:/^\+?[0-9\s\-]{7,20}$/',
            'user_id' => 'required|exists:users,id',
            'fonction' => 'nullable|string|max:100',
            'is_responsable' => 'boolean',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $validated = $validator->validated();
        $isPrimary = !empty($validated['is_responsable']);

        if ($isPrimary) {
            ClientContact::where('client_id', $validated['client_id'])
                ->where('is_responsable', true)
                ->update(['is_responsable' => false]);
        }

        $validated['is_responsable'] = $isPrimary;

        try {
            $contact = ClientContact::create($validated);

            $client = Client::find($validated['client_id']);
            if ($client && !$client->contact_principal && $isPrimary) {
                $client->contact_principal = $contact->id;
                $client->save();
            }

            return response()->json([
                'success' => true,
                'contact' => $contact,
                'message' => 'Contact created successfully.'
            ], 201);
        } catch (QueryException $e) {
            if ($e->errorInfo[1] == 1062) {
                return response()->json([
                    'success' => false,
                    'errors' => [
                        'email' => ['A contact with this email already exists.']
                    ],
                    'message' => 'A contact with this email already exists.'
                ], 422);
            }

            Log::error("Error creating contact: {$e->getMessage()}");
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while creating the contact.'
            ], 500);
        }
    }

   
    public function show($id)
    {
        $contact = ClientContact::findOrFail($id);
        return response()->json($contact);
    }

   
    public function update(Request $request, $id)
    {
        $contact = ClientContact::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'client_id' => 'sometimes|required|exists:client,id',
            'first_name' => 'sometimes|required|string|max:255',
            'last_name' => 'sometimes|required|string|max:255',
            'email' => 'sometimes|required|email|max:255|unique:client_contact,email,' . $id,
            'phone' => 'nullable|string|max:20',
            'user_id' => 'sometimes|required|exists:users,id',
            'fonction' => 'nullable|string|max:100',
            'is_responsable' => 'sometimes|boolean',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $validated = $validator->validated();

        if (isset($validated['is_responsable']) && $validated['is_responsable'] && !$contact->is_responsable) {
            ClientContact::where('client_id', $contact->client_id)
                ->where('id', '!=', $contact->id)
                ->where('is_responsable', true)
                ->update(['is_responsable' => false]);

            $client = Client::find($contact->client_id);
            if ($client && !$client->contact_principal) {
                $client->contact_principal = $contact->id;
                $client->save();
            }
        }

        try {
            $contact->update($validated);
            
            return response()->json([
                'success' => true,
                'contact' => $contact,
                'message' => 'Contact updated successfully.'
            ]);
        } catch (QueryException $e) {
            if ($e->errorInfo[1] == 1062) {
                return response()->json([
                    'success' => false,
                    'errors' => [
                        'email' => ['A contact with this email already exists.']
                    ],
                    'message' => 'A contact with this email already exists.'
                ], 422);
            }

            Log::error("Error updating contact: {$e->getMessage()}");
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while updating the contact.'
            ], 500);
        }
    }

 
    public function destroy($id)
    {
        $contact = ClientContact::findOrFail($id);

        $client = Client::where('contact_principal', $contact->id)->first();
        if ($client) {
            $client->contact_principal = null;
            $client->save();
        }

        $contact->delete();
        return response()->json(null, 204);
    }


    public function toggleResponsible(Request $request, $id)
    {
        $contact = ClientContact::findOrFail($id);

        $validated = $request->validate([
            'is_responsable' => 'required|boolean',
        ]);

        if ($validated['is_responsable']) {
            ClientContact::where('client_id', $contact->client_id)
                ->where('id', '!=', $contact->id)
                ->where('is_responsable', true)
                ->update(['is_responsable' => false]);

            $client = Client::find($contact->client_id);
            if (!$client->contact_principal) {
                $client->contact_principal = $contact->id;
                $client->save();
            }
        }

        $contact->is_responsable = $validated['is_responsable'];
        $contact->save();

        return response()->json([
            'success' => true,
            'message' => 'Contact responsibility status updated successfully',
            'is_responsable' => $contact->is_responsable
        ]);
    }

 
    public function setPrincipal($id)
    {
        $contact = ClientContact::findOrFail($id);

        $client = Client::findOrFail($contact->client_id);
        $client->contact_principal = $contact->id;
        $client->save();

        return response()->json([
            'success' => true,
            'message' => 'Contact set as principal successfully'
        ]);
    }
}
