<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('client', function (Blueprint $table) {
            $table->id();
            $table->foreignId('categories_id')->constrained('clientcategories')->onDelete('cascade');
            $table->string('raison_sociale')->unique();
            $table->string('email')->unique();
            $table->string('phone')->nullable();
            $table->string('website')->nullable();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('ice')->nullable();
            $table->string('patente')->nullable();
            $table->string('cnss')->nullable();
            $table->unsignedBigInteger('contact_principal')->nullable();
            $table->date('date_integration')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('client');
    }
};
