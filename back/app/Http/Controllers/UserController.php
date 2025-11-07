<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    /**
     * Display a listing of users.
     */
    public function index()
    {
        $users = User::all();
        return response()->json($users);
    }

    /**
     * Store a newly created user.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'first_name' => 'required|string|max:255',
            'last_name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'phone' => 'sometimes|string|max:20',
            'password' => 'required|string|min:8',
            'role' => 'required|string',
            'is_active' => 'sometimes|boolean',
            'avatar' => 'sometimes|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $userData = [
            'first_name' => $request->first_name,
            'last_name' => $request->last_name,
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
            'role' => $request->role,
            'is_active' => $request->has('is_active') ? $request->is_active : 1,
        ];

        // Handle avatar upload if present
        if ($request->hasFile('avatar')) {
            // Create avatars directory if it doesn't exist
            $avatarPath = public_path('assets/avatars');
            if (!file_exists($avatarPath)) {
                mkdir($avatarPath, 0755, true);
            }

            // Generate avatar name
            $avatarName = time() . '_' . uniqid() . '.' . $request->avatar->extension();

            // Move the uploaded file
            $request->file('avatar')->move($avatarPath, $avatarName);

            // Add avatar path to user data
            $userData['avatar'] = '/assets/avatars/' . $avatarName;
        }

        $user = User::create($userData);

        return response()->json($user, 201);
    }

    /**
     * Display the specified user.
     */
    public function show(string $id)
    {
        $user = User::findOrFail($id);
        return response()->json($user);
    }

    /**
     * Show the form for editing the specified user.
     */
    public function toggleActive(Request $request, string $id)
    {
        try {
            $user = User::findOrFail($id);

            // Common names are 'is_active', 'active', or 'status'
            if (isset($user->is_active)) {
                $user->is_active = !$user->is_active;
            } else if (isset($user->active)) {
                $user->active = !$user->active;
            } else if (isset($user->status)) {
                $user->status = $user->status === 'active' ? 'inactive' : 'active';
            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Could not determine active field on user model'
                ], 400);
            }

            $user->save();

            return response()->json([
                'success' => true,
                'message' => 'User active status toggled successfully',
                'user' => $user,
                'is_active' => isset($user->is_active) ? $user->is_active :
                            (isset($user->active) ? $user->active :
                            ($user->status === 'active'))
            ]);
        } catch (\Exception $e) {
            // Add detailed error logging
            \Log::error('Error toggling user status: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Failed to toggle user status: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update the specified user.
     */
    public function update(Request $request, string $id)
    {
        $user = User::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'first_name' => 'sometimes|string|max:255',
            'last_name' => 'sometimes|string|max:255',
            'email' => 'sometimes|string|email|max:255|unique:users,email,'.$id,
            'phone' => 'sometimes|string|max:20',
            'password' => 'sometimes|string|min:8',
            'role' => 'sometimes|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        if ($request->has('first_name')) {
            $user->first_name = $request->first_name;
        }

        if ($request->has('last_name')) {
            $user->last_name = $request->last_name;
        }

        if ($request->has('email')) {
            $user->email = $request->email;
        }

        if ($request->has('password')) {
            $user->password = Hash::make($request->password);
        }
        if ($request->has('phone')) {
            $user->phone = $request->phone;
        }
        if ($request->has('role')) {
            $user->role = $request->role;
        }
        if ($request->has('avatar')) {
            $user->avatar = $request->avatar;
        }

        $user->save();

        return response()->json($user);
    }

    /**
     * Remove the specified user.
     */
    public function destroy(string $id, Request $request)
    {
        // Get the current authenticated user
        $currentUser = $request->user();

        // Check if the user is trying to delete themselves
        if ($currentUser->id == $id) {
            return response()->json([
                'success' => false,
                'message' => 'You cannot delete your own account.'
            ], 403); // Return forbidden status code
        }

        $user = User::findOrFail($id);



        // If all checks pass, proceed with deletion
        $user->delete();

        return response()->json([
            'success' => true,
            'message' => 'User deleted successfully'
        ], 200);
    }

    /**
     * avatar upload for the specified user.
     */
    public function uploadAvatar(Request $request, string $id)
    {
        $user = User::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'avatar' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Create avatars directory if it doesn't exist
        $avatarPath = public_path('assets/avatars');
        if (!file_exists($avatarPath)) {
            mkdir($avatarPath, 0755, true);
        }

        // Delete old avatar if exists
        if ($user->avatar && file_exists(public_path(ltrim($user->avatar, '/')))) {
            unlink(public_path(ltrim($user->avatar, '/')));
        }

        // Generate avatar name
        $avatarName = $id . '_' . time() . '.' . $request->avatar->extension();

        // Move the uploaded file to assets directory
        $request->file('avatar')->move($avatarPath, $avatarName);

        // Update user record with avatar path
        $user->avatar = '/assets/avatars/' . $avatarName;
        $user->save();

        return response()->json([
            'success' => true,
            'avatar' => $user->avatar,
            'message' => 'Avatar uploaded successfully'
        ]);
    }
    /**
     * Remove the avatar for the specified user.
     */
    public function removeAvatar(string $id)
    {
        $user = User::findOrFail($id);

        // Check if user has an avatar
        if (!$user->avatar) {
            return response()->json([
                'message' => 'User does not have an avatar'
            ], 400);
        }

        // Delete avatar file if exists
        $avatarPath = public_path(ltrim($user->avatar, '/'));
        if (file_exists($avatarPath)) {
            unlink($avatarPath);
        }

        // Clear avatar path from user record
        $user->avatar = null;
        $user->save();

        return response()->json([
            'success' => true,
            'message' => 'Avatar removed successfully'
        ]);
    }
}
