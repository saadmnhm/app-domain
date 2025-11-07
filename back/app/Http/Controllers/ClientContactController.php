<?php

namespace App\Http\Controllers;

use App\Models\ClientContact;
use App\Models\Client;
use Illuminate\Http\Request;

class ClientContactController extends Controller
{
    /**
     * Display a listing of the contacts.
     */
    public function index(Request $request)
    {
        // Allow filtering by client_id
        if ($request->has('client_id')) {
            $contacts = ClientContact::where('client_id', $request->client_id)->get();
        } else {
            $contacts = ClientContact::all();
        }

        return response()->json($contacts);
    }

    /**
     * Store a newly created contact.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'client_id' => 'required|exists:client,id',
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'email' => 'required|email|max:255',
            'phone' => 'nullable|string|max:20',
            'user_id' => 'required|exists:users,id',
            'fonction' => 'nullable|string|max:100',
            'is_responsable' => 'boolean',
        ]);

        if ($validated['is_responsable']) {
            ClientContact::where('client_id', $validated['client_id'])
                ->where('is_responsable', true)
                ->update(['is_responsable' => false]);
        }

        $contact = ClientContact::create($validated);

        $client = Client::find($validated['client_id']);
        if (!$client->contact_principal && $validated['is_responsable']) {
            $client->contact_principal = $contact->id;
            $client->save();
        }

        return response()->json($contact, 201);
    }

    /**
     * Display the specified contact.
     */
    public function show($id)
    {
        $contact = ClientContact::findOrFail($id);
        return response()->json($contact);
    }

    /**
     * Update the specified contact.
     */
    public function update(Request $request, $id)
    {
        $contact = ClientContact::findOrFail($id);

        $validated = $request->validate([
            'client_id' => 'sometimes|required|exists:client,id',
            'first_name' => 'sometimes|required|string|max:255',
            'last_name' => 'sometimes|required|string|max:255',
            'email' => [
                'sometimes',
                'required',
                'email',
                'max:255',
            ],
            'phone' => 'nullable|string|max:20',
            'user_id' => 'sometimes|required|exists:users,id',
            'fonction' => 'nullable|string|max:100',
            'is_responsable' => 'sometimes|boolean',
        ]);

        // Handle is_responsable changes
        if (isset($validated['is_responsable']) && $validated['is_responsable'] && !$contact->is_responsable) {
            // If becoming responsible, unmark other contacts for this client
            ClientContact::where('client_id', $contact->client_id)
                ->where('id', '!=', $contact->id)
                ->where('is_responsable', true)
                ->update(['is_responsable' => false]);

            // Also update client's principal contact if not already set
            $client = Client::find($contact->client_id);
            if (!$client->contact_principal) {
                $client->contact_principal = $contact->id;
                $client->save();
            }
        }

        $contact->update($validated);
        return response()->json($contact);
    }

    /**
     * Remove the specified contact.
     */
    public function destroy($id)
    {
        $contact = ClientContact::findOrFail($id);

        // If this contact is the principal contact for the client, clear that relationship
        $client = Client::where('contact_principal', $contact->id)->first();
        if ($client) {
            $client->contact_principal = null;
            $client->save();
        }

        $contact->delete();
        return response()->json(null, 204);
    }

    /**
     * Toggle responsible status for a contact.
     */
    public function toggleResponsible(Request $request, $id)
    {
        $contact = ClientContact::findOrFail($id);

        $validated = $request->validate([
            'is_responsable' => 'required|boolean',
        ]);

        // If being marked as responsible, unmark other contacts
        if ($validated['is_responsable']) {
            ClientContact::where('client_id', $contact->client_id)
                ->where('id', '!=', $contact->id)
                ->where('is_responsable', true)
                ->update(['is_responsable' => false]);

            // Update client's principal contact if it wasn't set
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

    /**
     * Set contact as principal for the client
     */
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
