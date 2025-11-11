<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class ClientHistory extends Model {

    protected $table = 'client_histories';

    protected $fillable = ['
    client_id',
    'type',
    'description',
    'payload',
    'user_id'
];

    
    protected $casts = [
        'payload' => 'array'
    ];
}