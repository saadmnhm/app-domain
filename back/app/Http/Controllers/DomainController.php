<?php

namespace App\Http\Controllers;
use App\Models\Domain;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class DomainController extends Controller
{
    public function index(Request $request)
    {
        $query = Domain::query();

        if ($request->has('withTrashed') && $request->withTrashed) {
            $query->withTrashed();
        }

        $query->withCount('clients');
        

        if ($request->has('search')) {
            $search = $request->input('search');
            $query->where('label', 'like', "%{$search}%");
        }
        
        $perPage = $request->input('per_page', 15);
        
        $domains = $query->paginate($perPage);
        
        return response()->json($domains);
    }

    public function store(Request $request)
    {
        // Validate request with icon (optional)
        $validator = Validator::make($request->all(), [
            'label' => 'required|string|max:255|unique:domaine_dactivites,label',
            'description' => 'nullable|string|max:1000',
            'is_active' => 'sometimes|boolean',
            'icon' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Handle icon upload if present
        $iconPath = null;
        if ($request->hasFile('icon')) {
            $iconDir = public_path('assets/icons');
            if (!file_exists($iconDir)) {
                mkdir($iconDir, 0755, true);
            }

            $iconName = uniqid() . '_' . time() . '.' . $request->icon->extension();
            $request->file('icon')->move($iconDir, $iconName);
            $iconPath = '/assets/icons/' . $iconName;
        }

        try {
            // Create the domain
            $domain = Domain::create([
                'label' => $request->label,
                'description' => $request->description,
                'is_active' => $request->is_active ?? true,
                'icon' => $iconPath,
            ]);

            return response()->json([
                'success' => true,
                'domain' => $domain,
                'message' => 'Domain created successfully.'
            ], 201);
        } catch (QueryException $e) {
            // Clean up uploaded icon if domain creation fails
            if ($iconPath && file_exists(public_path(ltrim($iconPath, '/')))) {
                unlink(public_path(ltrim($iconPath, '/')));
            }

            if ($e->errorInfo[1] == 1062) {
                return response()->json([
                    'success' => false,
                    'errors' => [
                        'label' => ['A domain with this name already exists.']
                    ],
                    'message' => 'A domain with this name already exists.'
                ], 422);
            }

            Log::error("Error creating domain: {$e->getMessage()}");
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while creating the domain.'
            ], 500);
        }
    }

    public function show($id)
    {
        $domain = Domain::findOrFail($id);
        return response()->json($domain);
    }

    public function update(Request $request, $id)
    {
        $domain = Domain::findOrFail($id);

        // Validate request with unique check excluding current domain
        $validator = Validator::make($request->all(), [
            'label' => 'required|string|max:255|unique:domaine_dactivites,label,' . $id,
            'description' => 'nullable|string|max:1000',
            'is_active' => 'sometimes|boolean',
            'icon' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Handle icon upload if present
        $iconPath = $domain->icon; // Keep existing icon by default
        if ($request->hasFile('icon')) {
            $iconDir = public_path('assets/icons');
            if (!file_exists($iconDir)) {
                mkdir($iconDir, 0755, true);
            }

            // Delete old icon if exists
            if ($domain->icon && file_exists(public_path(ltrim($domain->icon, '/')))) {
                unlink(public_path(ltrim($domain->icon, '/')));
            }

            $iconName = $id . '_' . time() . '.' . $request->icon->extension();
            $request->file('icon')->move($iconDir, $iconName);
            $iconPath = '/assets/icons/' . $iconName;
        }

        try {
            // Update the domain
            $domain->update([
                'label' => $request->label,
                'description' => $request->description,
                'is_active' => $request->is_active ?? $domain->is_active,
                'icon' => $iconPath,
            ]);

            return response()->json([
                'success' => true,
                'domain' => $domain,
                'message' => 'Domain updated successfully.'
            ]);
        } catch (QueryException $e) {
            // Clean up uploaded icon if update fails
            if ($request->hasFile('icon') && $iconPath && file_exists(public_path(ltrim($iconPath, '/')))) {
                unlink(public_path(ltrim($iconPath, '/')));
            }

            if ($e->errorInfo[1] == 1062) {
                return response()->json([
                    'success' => false,
                    'errors' => [
                        'label' => ['A domain with this name already exists.']
                    ],
                    'message' => 'A domain with this name already exists.'
                ], 422);
            }

            Log::error("Error updating domain: {$e->getMessage()}");
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while updating the domain.'
            ], 500);
        }
    }


    public function destroy($id)
    {
        $domain = Domain::findOrFail($id);

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

        $iconPath = public_path('assets/icons');
        if (!file_exists($iconPath)) {
            mkdir($iconPath, 0755, true);
        }

        if ($domain->icon && file_exists(public_path(ltrim($domain->icon, '/')))) {
            unlink(public_path(ltrim($domain->icon, '/')));
        }

        $iconName = $id . '_' . time() . '.' . $request->icon->extension();

        $request->file('icon')->move($iconPath, $iconName);

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

        if (!$domain->icon) {
            return response()->json([
                'message' => 'Domain does not have an icon'
            ], 400);
        }

        $iconPath = public_path(ltrim($domain->icon, '/'));
        if (file_exists($iconPath)) {
            unlink($iconPath);
        }

        $domain->icon = null;
        $domain->save();

        return response()->json([
            'success' => true,
            'message' => 'Icon removed successfully'
        ]);
    }
}
