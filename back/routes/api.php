<?php

use App\Actions\SamplePermissionApi;
use App\Actions\SampleRoleApi;
use App\Actions\SampleUserApi;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Apps\api\ContactController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\DomainController;
use App\Http\Controllers\ClientController;
use App\Http\Controllers\ClientContactController;
use App\Http\Controllers\ClientHistoryController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('/login', [AuthController::class, 'login']);


Route::middleware('auth:sanctum')->group(function () {
    

    Route::post('/logout', [AuthController::class, 'logout']);

    // User management
    Route::apiResource('users', UserController::class);
    
    Route::post('users/{id}/avatar', [UserController::class, 'uploadAvatar']);
    
    Route::delete('users/{id}/avatar', [UserController::class, 'removeAvatar']);
    
    Route::post('users/{id}/toggle-active', [UserController::class, 'toggleActive'])->name('toggle.active');
    
    Route::put('users/{id}/password', [UserController::class, 'updatePassword']);

    Route::get('/user', [AuthController::class, 'user']);

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

    Route::prefix('notifications')->group(function () {
        Route::get('/', [NotificationController::class, 'index']);
        Route::post('/mark-read', [NotificationController::class, 'markAsRead']);
        Route::post('/mark-unread', [NotificationController::class, 'markAsUnread']);
        Route::delete('/{id}', [NotificationController::class, 'delete']);
    });

      Route::get('/clients/{client}/history', [ClientHistoryController::class, 'index']);
     Route::post('/clients/{client}/history', [ClientHistoryController::class, 'store']);

});

    




