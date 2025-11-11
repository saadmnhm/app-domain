<?php

namespace App\Http\Controllers;
use App\Models\Category;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class CategoryController extends Controller
{
    public function index(Request $request)
    {
        $query = Category::query();

        if ($request->has('withTrashed') && $request->withTrashed) {
            $query->withTrashed();
        }

        $query->withCount('clients');


        if ($request->has('search')) {
            $search = $request->input('search');
            $query->where('label', 'like', "%{$search}%");
        }
        
        $perPage = $request->input('per_page', 15);
        
        $categories = $query->paginate($perPage);
        
        return response()->json($categories);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'label' => 'required|string|max:255|unique:clientcategories,label',
            'description' => 'nullable|string|max:1000',
            'is_active' => 'sometimes|boolean',
            'icon' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

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
            $category = Category::create([
                'label' => $request->label,
                'description' => $request->description,
                'is_active' => $request->is_active ?? true,
                'icon' => $iconPath,
            ]);

            return response()->json([
                'success' => true,
                'category' => $category,
                'message' => 'Category created successfully.'
            ], 201);
        } catch (QueryException $e) {
            if ($iconPath && file_exists(public_path(ltrim($iconPath, '/')))) {
                unlink(public_path(ltrim($iconPath, '/')));
            }

            if ($e->errorInfo[1] == 1062) {
                return response()->json([
                    'success' => false,
                    'errors' => [
                        'label' => ['A category with this name already exists.']
                    ],
                    'message' => 'A category with this name already exists.'
                ], 422);
            }

            Log::error("Error creating category: {$e->getMessage()}");
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while creating the category.'
            ], 500);
        }
    }

    public function show($id)
    {
        $category = Category::findOrFail($id);
        return response()->json($category);
    }

    public function update(Request $request, $id)
    {
        $category = Category::findOrFail($id);

        // Validate request with unique check excluding current category
        $validator = Validator::make($request->all(), [
            'label' => 'required|string|max:255|unique:clientcategories,label,' . $id,
            'description' => 'nullable|string|max:1000',
            'is_active' => 'sometimes|boolean',
            'icon' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Handle icon upload if present
        $iconPath = $category->icon; // Keep existing icon by default
        if ($request->hasFile('icon')) {
            $iconDir = public_path('assets/icons');
            if (!file_exists($iconDir)) {
                mkdir($iconDir, 0755, true);
            }

            // Delete old icon if exists
            if ($category->icon && file_exists(public_path(ltrim($category->icon, '/')))) {
                unlink(public_path(ltrim($category->icon, '/')));
            }

            $iconName = $id . '_' . time() . '.' . $request->icon->extension();
            $request->file('icon')->move($iconDir, $iconName);
            $iconPath = '/assets/icons/' . $iconName;
        }

        try {
            // Update the category
            $category->update([
                'label' => $request->label,
                'description' => $request->description,
                'is_active' => $request->is_active ?? $category->is_active,
                'icon' => $iconPath,
            ]);

            return response()->json([
                'success' => true,
                'category' => $category,
                'message' => 'Category updated successfully.'
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
                        'label' => ['A category with this name already exists.']
                    ],
                    'message' => 'A category with this name already exists.'
                ], 422);
            }

            Log::error("Error updating category: {$e->getMessage()}");
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while updating the category.'
            ], 500);
        }
    }

    public function destroy($id)
    {
        $category = Category::findOrFail($id);

        if ($category->clients()->count() > 0) {
            return response()->json([
                'success' => false,
                'message' => 'Cannot delete category: it is used by one or more clients.'
            ], 409);
        }

        $category->delete();
        return response()->json(null, 204);
    }

    public function uploadIcon(Request $request, string $id)
    {
        $category = Category::findOrFail($id);

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

        if ($category->icon && file_exists(public_path(ltrim($category->icon, '/')))) {
            unlink(public_path(ltrim($category->icon, '/')));
        }

        $iconName = $id . '_' . time() . '.' . $request->icon->extension();

        $request->file('icon')->move($iconPath, $iconName);

        $category->icon = '/assets/icons/' . $iconName;
        $category->save();

        return response()->json([
            'success' => true,
            'icon' => $category->icon,
            'message' => 'Icon uploaded successfully'
        ]);
    }

    public function removeIcon(string $id)
    {
        $category = Category::findOrFail($id);

        if (!$category->icon) {
            return response()->json([
                'message' => 'Category does not have an icon'
            ], 400);
        }

        $iconPath = public_path(ltrim($category->icon, '/'));
        if (file_exists($iconPath)) {
            unlink($iconPath);
        }

        $category->icon = null;
        $category->save();

        return response()->json([
            'success' => true,
            'message' => 'Icon removed successfully'
        ]);
    }

    public function toggleActive(Request $request, string $id)
    {
        $category = Category::findOrFail($id);

        $validated = $request->validate([
            'is_active' => 'required|boolean',
        ]);

        $category->is_active = $validated['is_active'];
        $category->save();

        return response()->json([
            'success' => true,
            'message' => 'Category status updated successfully',
            'is_active' => $category->is_active
        ]);
    }
}
