<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\ClientContactController;
use App\Http\Controllers\DomainController;
use App\Http\Controllers\ClientController;

// Public routes - no authentication required
Route::post('/login', [AuthController::class, 'login']);

// Protected routes - require authentication

Route::middleware('auth:sanctum')->group(function () {

    // User authentication

    Route::get('/user', [AuthController::class, 'user']);

    Route::post('/logout', [AuthController::class, 'logout']);

    // crud vue user
    Route::post('users/{id}/avatar', [UserController::class, 'uploadAvatar']);

    Route::delete('users/{id}/avatar', [UserController::class, 'removeAvatar']);

    Route::post('users/{id}/toggle-active', [UserController::class, 'toggleActive'])->name('toggle.active');

    // User management

    Route::apiResource('users', UserController::class);

    // Category management

    Route::apiResource('categories', CategoryController::class);

    Route::delete('categories/{id}/icon', [CategoryController::class, 'removeIcon']);

    // Domain management

    Route::apiResource('domains', DomainController::class);

    Route::delete('domains/{id}/icon', [DomainController::class, 'removeIcon']);

    // Client management

    Route::apiResource('clients', ClientController::class);

    // Client Contact management

    Route::apiResource('client-contacts', ClientContactController::class);

});
