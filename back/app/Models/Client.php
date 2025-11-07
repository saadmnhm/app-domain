<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\SoftDeletes;

class Client extends Model
{

    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens, SoftDeletes;

    protected $table = 'client';

    protected $fillable = [
        'categories_id',
        'domain_id',
        'raison_sociale',
        'email',
        'phone',
        'website',
        'user_id',
        'ice',
        'if',
        'patente',
        'cnss',
        'contact_principal',
        'date_integration',
    ];

    protected $casts = [
        'date_integration' => 'datetime',
    ];

    public function category()
    {
        return $this->belongsTo(Category::class, 'categories_id')->withTrashed();
    }
        public function domain()
    {
        return $this->belongsTo(Domain::class, 'domain_id')->withTrashed();
    }

}
