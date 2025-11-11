<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class UserController extends Controller
{
    /**
     * Display a listing of users.
     */
    public function index(Request $request)
    {
        $perPage = $request->input('per_page', 15);
        
        $query = User::select(['id', 'first_name', 'last_name', 'email', 'phone', 'role', 'is_active', 'avatar', 'created_at'])
            ->orderBy('id', 'desc');
        
        //  Add search if provided
        if ($request->has('search')) {
            $search = $request->input('search');
            $query->where(function($q) use ($search) {
                $q->where('first_name', 'like', "%{$search}%")
                  ->orWhere('last_name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%");
            });
        }
        
        $users = $query->paginate($perPage);
        
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
            'email' => 'required|string|email|max:255|unique:users,email',
            'phone' => 'nullable|string|max:20',
            'password' => 'nullable|string|min:8',
            'role' => 'required|string',
            'is_active' => 'nullable|in:0,1,true,false',
            'avatar' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $data = $validator->validated();

        if (!empty($data['password'])) {
            $data['password'] = Hash::make($data['password']);
        } else {
            unset($data['password']);
        }
        
        $data['is_active'] = isset($data['is_active']) ? (bool)$data['is_active'] : false;

        // Handle avatar upload if present
        $avatarPath = null;
        if ($request->hasFile('avatar')) {
            $avatarDir = public_path('assets/avatars');
            if (!file_exists($avatarDir)) {
                mkdir($avatarDir, 0755, true);
            }

            $avatarName = time() . '_' . uniqid() . '.' . $request->avatar->extension();
            $request->file('avatar')->move($avatarDir, $avatarName);
            $avatarPath = '/assets/avatars/' . $avatarName;
            $data['avatar'] = $avatarPath;
        }

        try {
            $user = User::create($data);

            return response()->json([
                'success' => true,
                'user' => $user,
                'message' => 'User created successfully.'
            ], 201);
        } catch (QueryException $e) {
            // Clean up uploaded avatar if user creation fails
            if ($avatarPath && file_exists(public_path(ltrim($avatarPath, '/')))) {
                unlink(public_path(ltrim($avatarPath, '/')));
            }

            if ($e->errorInfo[1] == 1062) {
                return response()->json([
                    'success' => false,
                    'errors' => [
                        'email' => ['A user with this email already exists.']
                    ],
                    'message' => 'A user with this email already exists.'
                ], 422);
            }

            Log::error("Error creating user: {$e->getMessage()}");
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while creating the user.'
            ], 500);
        }
    }

    /**
     * Display the specified user.
     */
    public function show(string $id)
    {
        $user = User::findOrFail($id);

        return response()->json(array_merge(
            $user->toArray(),
            ['has_password' => !empty($user->password)]
        ));
    }

    /**
     * Show the form for editing the specified user.
     */
    public function toggleActive(Request $request, string $id)
    {
        try {
            $user = User::findOrFail($id);

            $willBeActive = !(bool)($user->is_active ?? $user->active ?? ($user->status === 'active' ?? false));

            if ($willBeActive && empty($user->password)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot activate user without a password. Please set a password first.',
                    'is_active' => (isset($user->is_active) ? $user->is_active : 0),
                ], 400);
            }

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
            'first_name' => 'sometimes|required|string|max:255',
            'last_name' => 'sometimes|required|string|max:255',
            'email' => 'sometimes|required|string|email|max:255|unique:users,email,'.$id,
            'phone' => 'nullable|string|max:20',
            'password' => 'sometimes|nullable|string|min:8',
            'role' => 'sometimes|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $data = $validator->validated();

        if (!empty($data['password'])) {
            $data['password'] = Hash::make($data['password']);
        } else {
            unset($data['password']);
        }

        try {
            $user->fill($data);
            $user->save();

            return response()->json([
                'success' => true,
                'user' => $user,
                'message' => 'User updated successfully.'
            ]);
        } catch (QueryException $e) {
            if ($e->errorInfo[1] == 1062) {
                return response()->json([
                    'success' => false,
                    'errors' => [
                        'email' => ['A user with this email already exists.']
                    ],
                    'message' => 'A user with this email already exists.'
                ], 422);
            }

            Log::error("Error updating user: {$e->getMessage()}");
            return response()->json([
                'success' => false,
                'message' => 'An error occurred while updating the user.'
            ], 500);
        }
    }

    public function updatePassword(Request $request, string $id)
    {
        $user = User::findOrFail($id);

        $validator = Validator::make($request->all(), [
            'newPassword' => 'sometimes|required_with:newPassword|string|min:8',
            'password' => 'sometimes|required_with:password|string|min:8',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $plain = $request->input('newPassword', $request->input('password'));
        if (!$plain) {
            return response()->json(['message' => 'No password provided'], 400);
        }

        $user->password = Hash::make($plain);
        $user->save();

        return response()->json(['message' => 'Password updated successfully'], 200);
    }

    /**
     * Remove the specified user.
     */
    public function destroy(string $id, Request $request)
    {
        $currentUser = $request->user();

        if ($currentUser->id == $id) {
            return response()->json([
                'success' => false,
                'message' => 'You cannot delete your own account.'
            ], 403); 
        }

        $user = User::findOrFail($id);



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

        $avatarPath = public_path('assets/avatars');
        if (!file_exists($avatarPath)) {
            mkdir($avatarPath, 0755, true);
        }

        if ($user->avatar && file_exists(public_path(ltrim($user->avatar, '/')))) {
            unlink(public_path(ltrim($user->avatar, '/')));
        }

        $avatarName = $id . '_' . time() . '.' . $request->avatar->extension();

        $request->file('avatar')->move($avatarPath, $avatarName);

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
