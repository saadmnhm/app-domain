<?php

namespace App\Http\Controllers;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CategoryController extends Controller
{
    public function index(Request $request)
    {
        $query = Category::query();

        // Include soft-deleted categories if requested
        if ($request->has('withTrashed') && $request->withTrashed) {
            $query->withTrashed();
        }

        $categories = $query->withCount('clients')->get();
        return response()->json($categories);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'label' => 'required|string|max:255|unique:clientcategories,label,',
            'description' => 'nullable|string|max:1000',
            'is_active' => 'sometimes|boolean',
        ]);

        $categoryData = $validated;

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
            $categoryData['icon'] = '/assets/icons/' . $iconName;
        }

        $category = Category::create($categoryData);
        return response()->json($category, 201);
    }

    public function show($id)
    {
        $category = Category::findOrFail($id);
        return response()->json($category);
    }

    public function update(Request $request, $id)
    {
        $category = Category::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'label' => 'required|string|max:255|unique:clientcategories,label,' . $id,
            'description' => 'nullable|string|max:1000',
            'is_active' => 'sometimes|boolean',
            'icon' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:800',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $categoryData = $request->only(['label', 'description', 'is_active']);

        // Handle icon upload if present
        if ($request->hasFile('icon')) {
            // Create icons directory if it doesn't exist
            $iconPath = public_path('assets/icons');
            if (!file_exists($iconPath)) {
                mkdir($iconPath, 0755, true);
            }

            // Delete old icon if exists
            if ($category->icon && file_exists(public_path(ltrim($category->icon, '/')))) {
                unlink(public_path(ltrim($category->icon, '/')));
            }

            // Generate icon name and store file
            $iconName = $id . '_' . time() . '.' . $request->icon->extension();
            $request->file('icon')->move($iconPath, $iconName);

            // Add icon path to category data
            $categoryData['icon'] = '/assets/icons/' . $iconName;
        }

        $category->update($categoryData);

        return response()->json($category);
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

        // Create icons directory if it doesn't exist
        $iconPath = public_path('assets/icons');
        if (!file_exists($iconPath)) {
            mkdir($iconPath, 0755, true);
        }

        // Delete old icon if exists
        if ($category->icon && file_exists(public_path(ltrim($category->icon, '/')))) {
            unlink(public_path(ltrim($category->icon, '/')));
        }

        // Generate icon name
        $iconName = $id . '_' . time() . '.' . $request->icon->extension();

        // Move the uploaded file to assets directory
        $request->file('icon')->move($iconPath, $iconName);

        // Update category record with icon path
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

        // Check if category has an icon
        if (!$category->icon) {
            return response()->json([
                'message' => 'Category does not have an icon'
            ], 400);
        }

        // Delete icon file if exists
        $iconPath = public_path(ltrim($category->icon, '/'));
        if (file_exists($iconPath)) {
            unlink($iconPath);
        }

        // Clear icon path from category record
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
