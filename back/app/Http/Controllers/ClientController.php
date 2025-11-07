<?php

namespace App\Http\Controllers;

use App\Models\Client;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class ClientController extends Controller
{
    /**
     * Display a listing of clients.
     */
public function index()
{
    $clients = Client::with('category', 'domain')
        ->orderBy('id', 'desc') 
        ->get();

    return response()->json($clients);
}

    /**
     * Store a newly created client.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'categories_id' => 'required|exists:clientcategories,id',
            'domain_id' => 'required|exists:domaine_dactivites,id',
            'raison_sociale' => 'required|string|max:255',
            'email' => 'required|email|max:255|unique:client',
            'phone' => 'nullable|string|max:20',
            'website' => 'nullable|string|max:255',
            'user_id' => 'required|exists:users,id',
            'ice' => 'nullable|string|max:50',
            'if' => 'nullable|string|max:50',
            'patente' => 'nullable|string|max:50',
            'cnss' => 'nullable|string|max:50',
            'contact_principal' => 'nullable|integer',
            'date_integration' => 'nullable|date',
        ]);

        $client = Client::create($validated);
        return response()->json($client, 201);
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

        $validated = $request->validate([
            'categories_id' => 'sometimes|required|exists:clientcategories,id',
            'domain_id' => 'sometimes|required|exists:domaine_dactivites,id',
            'raison_sociale' => [
                'sometimes',
                'required',
                'string',
                'max:255',
            ],
            'email' => [
                'sometimes',
                'required',
                'email',
                'max:255',
                Rule::unique('client')->ignore($client->id)
            ],
            'phone' => 'nullable|string|max:20',
            'website' => 'nullable|string|max:255',
            'user_id' => 'sometimes|required|exists:users,id',
            'ice' => 'nullable|string|max:50',
            'if' => 'nullable|string|max:50',
            'patente' => 'nullable|string|max:50',
            'cnss' => 'nullable|string|max:50',
            'contact_principal' => 'nullable|integer',
            'date_integration' => 'nullable|date',
        ]);

        $client->update($validated);
        return response()->json($client);
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

        // Search by raison_sociale
        if ($request->has('raison_sociale')) {
            $query->where('raison_sociale', 'like', '%' . $request->raison_sociale . '%');
        }

        // Search by email
        if ($request->has('email')) {
            $query->where('email', 'like', '%' . $request->email . '%');
        }

        // Filter by category
        if ($request->has('category_id')) {
            $query->where('categories_id', $request->category_id);
        }

        // Filter by domain
        if ($request->has('domain_id')) {
            $query->where('domain_id', $request->domain_id);
        }

        // Filter by active status if you have one
        if ($request->has('is_active')) {
            $query->where('is_active', $request->is_active);
        }

        // Get paginated results
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

        // Verify the contact belongs to this client
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
