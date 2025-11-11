<?php

namespace App\Http\Controllers;

use App\Models\Client;
use App\Models\Notification;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class ClientController extends Controller
{
    /**
     * Display a listing of clients.
     */
public function index(Request $request)
{
    $perPage = $request->input('per_page', 15);
    $page = $request->input('page', 1);
    
    $query = Client::with(['category:id,label,icon', 'domain:id,label,icon'])
        ->orderBy('id', 'desc');
    
    if ($request->has('search')) {
        $search = $request->input('search');
        $query->where(function($q) use ($search) {
            $q->where('raison_sociale', 'like', "%{$search}%")
              ->orWhere('email', 'like', "%{$search}%");
        });
    }
    
    $clients = $query->paginate($perPage);

    return response()->json($clients);
}

    /**
     * Store a newly created client.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'categories_id' => 'required|exists:clientcategories,id',
            'domain_id' => 'required|exists:domaine_dactivites,id',
            'raison_sociale' => 'required|string|max:255',
            'email' => 'required|email|max:255|unique:client,email',
            'phone' => 'nullable|string|max:20',
            'website' => 'nullable|string|max:255',
            'user_id' => 'required|exists:users,id',
            'ice' => 'nullable|string|max:50',
            'if' => 'nullable|string|max:50',
            'patente' => 'nullable|string|max:50',
            'cnss' => 'nullable|string|max:50',
            'contact_principal' => 'nullable|integer',
            'date_integration' => 'required|date',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $client = Client::create($validator->validated());
            
            return response()->json([
                'success' => true,
                'client' => $client,
                'message' => 'Client created successfully.'
            ], 201);
        } catch (QueryException $e) {
            if ($e->errorInfo[1] == 1062) {
                $message = 'A client with this information already exists.';
                $field = 'email';
                
                if (str_contains($e->getMessage(), 'email')) {
                    $message = 'A client with this email already exists.';
                    $field = 'email';
                } elseif (str_contains($e->getMessage(), 'raison_sociale')) {
                    $message = 'A client with this company name already exists.';
                    $field = 'raison_sociale';
                }

                return response()->json([
                    'success' => false,
                    'errors' => [
                        $field => [$message]
                    ],
                    'message' => $message
                ], 422);
            }

            Log::error("Error creating client: {$e->getMessage()}");
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while creating the client.'
            ], 500);
        }
    }

    /**
     * Display the specified client.
     */
    public function show($id)
    {
        $client = Client::with('category', 'domain')->findOrFail($id);
        return response()->json($client);
    }

    /**
     * Update the specified client.
     */
    public function update(Request $request, $id)
    {
        $client = Client::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'categories_id' => 'sometimes|required|exists:clientcategories,id',
            'domain_id' => 'sometimes|required|exists:domaine_dactivites,id',
            'raison_sociale' => 'sometimes|required|string|max:255',
            'email' => 'sometimes|required|email|max:255|unique:client,email,' . $id,
            'phone' => 'nullable|string|max:20',
            'website' => 'nullable|string|max:255',
            'user_id' => 'sometimes|required|exists:users,id',
            'ice' => 'nullable|string|max:50',
            'if' => 'nullable|string|max:50',
            'patente' => 'nullable|string|max:50',
            'cnss' => 'nullable|string|max:50',
            'contact_principal' => 'nullable|integer',
            'date_integration' => 'required|date',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $client->update($validator->validated());
            
            return response()->json([
                'success' => true,
                'client' => $client,
                'message' => 'Client updated successfully.'
            ]);
        } catch (QueryException $e) {
            if ($e->errorInfo[1] == 1062) {
                $message = 'A client with this information already exists.';
                $field = 'email';
                
                if (str_contains($e->getMessage(), 'email')) {
                    $message = 'A client with this email already exists.';
                    $field = 'email';
                } elseif (str_contains($e->getMessage(), 'raison_sociale')) {
                    $message = 'A client with this company name already exists.';
                    $field = 'raison_sociale';
                }

                return response()->json([
                    'success' => false,
                    'errors' => [
                        $field => [$message]
                    ],
                    'message' => $message
                ], 422);
            }

            Log::error("Error updating client: {$e->getMessage()}");
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while updating the client.'
            ], 500);
        }
    }

    /**
     * Remove the specified client.
     */
    public function destroy($id)
    {
        $client = Client::findOrFail($id);
        $client->delete();
        return response()->json(null, 204);
    }

    /**
     * Search for clients
     */
    public function search(Request $request)
    {
        $query = Client::query();

        if ($request->has('raison_sociale')) {
            $query->where('raison_sociale', 'like', '%' . $request->raison_sociale . '%');
        }

        if ($request->has('email')) {
            $query->where('email', 'like', '%' . $request->email . '%');
        }

        if ($request->has('category_id')) {
            $query->where('categories_id', $request->category_id);
        }

        if ($request->has('domain_id')) {
            $query->where('domain_id', $request->domain_id);
        }

        if ($request->has('is_active')) {
            $query->where('is_active', $request->is_active);
        }

        $perPage = $request->per_page ?? 10;
        $clients = $query->with('category')->paginate($perPage);

        return response()->json($clients);
    }

    /**
     * Get client contacts
     */
    public function getContacts($id)
    {
        $client = Client::findOrFail($id);
        $contacts = $client->contacts;

        return response()->json($contacts);
    }

    /**
     * Set principal contact for client
     */
    public function setPrincipalContact(Request $request, $id)
    {
        $client = Client::findOrFail($id);

        $validated = $request->validate([
            'contact_id' => 'required|exists:client_contact,id',
        ]);

        $contactExists = $client->contacts()
            ->where('id', $validated['contact_id'])
            ->exists();

        if (!$contactExists) {
            return response()->json([
                'message' => 'This contact does not belong to the client'
            ], 400);
        }

        $client->contact_principal = $validated['contact_id'];
        $client->save();

        return response()->json([
            'success' => true,
            'message' => 'Principal contact updated successfully',
            'contact_principal' => $client->contact_principal
        ]);
    }
    /**
     * Get related projects for a client
     */
    public function getProjects($id)
    {
        $client = Client::findOrFail($id);
        $projects = $client->projects;

        return response()->json($projects);
    }

    /**
     * Get related invoices for a client
     */
    public function getInvoices($id)
    {
        $client = Client::findOrFail($id);
        $invoices = $client->invoices;

        return response()->json($invoices);
    }
}
