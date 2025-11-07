<?php

namespace App\Models;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class Domain extends Model
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens, SoftDeletes;
    protected $table = 'domaine_dactivites';

    protected $fillable = [
        'label',
        'description',
        'icon',
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function clients()
    {
        return $this->hasMany(Client::class, 'domain_id');
    }
}
