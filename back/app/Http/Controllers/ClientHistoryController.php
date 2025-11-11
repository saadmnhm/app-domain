<?php
namespace App\Http\Controllers;
use App\Models\ClientHistory;
use App\Models\ClientContact;
use Illuminate\Http\Request;

class ClientHistoryController extends Controller {
  public function index(Request $request, $clientId) {
    return ClientHistory::where('client_id', $clientId)->orderByDesc('created_at')->get();
  }
  public function store(Request $request, $clientId) {
    $data = $request->validate([
      'type' => 'required|string',
      'description' => 'nullable|string',
      'payload' => 'nullable|array',
    ]);
    $data['client_id'] = $clientId;
    $data['user_id'] = $request->user()?->id;
    $history = ClientHistory::create($data);
    return response()->json($history, 201);
  }
  public function storeContact(Request $request) {
    $validated = $request->validate([
      'client_id' => 'required|exists:clients,id',
      'first_name' => 'required|string',
      'last_name' => 'required|string',
      'email' => 'nullable|email',
      'phone' => 'nullable|string',
    ]);

    $contact = ClientContact::create($validated);

    ClientHistory::create([
      'client_id' => $validated['client_id'],
      'type' => 'contact_added',
      'description' => "Contact {$contact->first_name} {$contact->last_name} added",
      'payload' => $contact->toArray(),
      'user_id' => $request->user()?->id,
    ]);

    return response()->json($contact, 201);
  }
}