<?php

namespace App\Http\Controllers;
use App\Models\Domain;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class DomainController extends Controller
{
    public function index(Request $request)
    {
        $query = Domain::query();

        if ($request->has('withTrashed') && $request->withTrashed) {
            $query->withTrashed();
        }

        $domains = $query->withCount('clients')->get();
        return response()->json($domains);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'label' => 'required|string|max:255',
            'description' => 'nullable|string|max:1000',
        ]);

        $domainData = $validated;

        // Handle icon upload if present
        if ($request->hasFile('icon')) {
            // Create icons directory if it doesn't exist
            $iconPath = public_path('assets/icons');
            if (!file_exists($iconPath)) {
                mkdir($iconPath, 0755, true);
            }

            // Generate icon name
            $iconName = time() . '_' . uniqid() . '.' . $request->icon->extension();

            // Move the uploaded file
            $request->file('icon')->move($iconPath, $iconName);

            // Add icon path to category data
            $domainData['icon'] = '/assets/icons/' . $iconName;
        }

        $domain = Domain::create($domainData);
        return response()->json($domain, 201);
    }

    public function show($id)
    {
        $domain = Domain::findOrFail($id);
        return response()->json($domain);
    }

    public function update(Request $request, $id)
    {
        $domain = Domain::findOrFail($id);

        $validated = $request->validate([
            'label' => 'string|max:255' . $domain->id,
            'description' => 'nullable|string|max:1000',
        ]);

        $domainData = $validated;

        // Handle icon upload if present
        if ($request->hasFile('icon')) {
            // Create icons directory if it doesn't exist
            $iconPath = public_path('assets/icons');
            if (!file_exists($iconPath)) {
                mkdir($iconPath, 0755, true);
            }

            // Delete old icon if exists
            if ($domain->icon && file_exists(public_path(ltrim($domain->icon, '/')))) {
                unlink(public_path(ltrim($domain->icon, '/')));
            }

            // Generate icon name
            $iconName = $id . '_' . time() . '.' . $request->icon->extension();

            // Move the uploaded file
            $request->file('icon')->move($iconPath, $iconName);

            // Add icon path to domain data
            $domainData['icon'] = '/assets/icons/' . $iconName;
        }

        $domain->update($domainData);
        return response()->json($domain);
    }

    public function destroy($id)
    {
        $domain = Domain::findOrFail($id);

        // Check if any clients are using this domain
        if ($domain->clients()->count() > 0) {
            return response()->json([
                'success' => false,
                'message' => 'Cannot delete domain: it is used by one or more clients.'
            ], 409);
        }

        $domain->delete();
        return response()->json(null, 204);
    }

    public function uploadIcon(Request $request, string $id)
    {
        $domain = Domain::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'icon' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Create icons directory if it doesn't exist
        $iconPath = public_path('assets/icons');
        if (!file_exists($iconPath)) {
            mkdir($iconPath, 0755, true);
        }

        // Delete old icon if exists
        if ($domain->icon && file_exists(public_path(ltrim($domain->icon, '/')))) {
            unlink(public_path(ltrim($domain->icon, '/')));
        }

        // Generate icon name
        $iconName = $id . '_' . time() . '.' . $request->icon->extension();

        // Move the uploaded file to assets directory
        $request->file('icon')->move($iconPath, $iconName);

        // Update domain record with icon path
        $domain->icon = '/assets/icons/' . $iconName;
        $domain->save();

        return response()->json([
            'success' => true,
            'icon' => $domain->icon,
            'message' => 'Icon uploaded successfully'
        ]);
    }

    public function removeIcon(string $id)
    {
        $domain = Domain::findOrFail($id);

        // Check if domain has an icon
        if (!$domain->icon) {
            return response()->json([
                'message' => 'Domain does not have an icon'
            ], 400);
        }

        // Delete icon file if exists
        $iconPath = public_path(ltrim($domain->icon, '/'));
        if (file_exists($iconPath)) {
            unlink($iconPath);
        }

        // Clear icon path from domain record
        $domain->icon = null;
        $domain->save();

        return response()->json([
            'success' => true,
            'message' => 'Icon removed successfully'
        ]);
    }

}
