<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class ClientContact extends Model
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens, SoftDeletes;


    protected $table = 'client_contact';

    protected $fillable = [
        'client_id',
        'first_name',
        'last_name',
        'email',
        'phone',
        'user_id',
        'fonction',
        'is_responsable'
    ];

    protected $casts = [
        'is_responsable' => 'boolean'
    ];

    /**
     * Get the client that owns the contact
     */
    public function client()
    {
        return $this->belongsTo(Client::class);
    }

    /**
     * Get the user that created or manages the contact
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Check if this contact is the client's principal contact
     */
    public function isPrincipal()
    {
        return $this->client && $this->client->contact_principal === $this->id;
    }


}
