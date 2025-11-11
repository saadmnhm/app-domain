<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('notifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('title');
            $table->text('subtitle')->nullable();
            $table->string('type')->nullable(); // 'info', 'success', 'warning', 'error'
            $table->string('icon')->nullable();
            $table->string('color')->nullable();
            $table->boolean('is_seen')->default(false);
            $table->json('data')->nullable(); // Additional data
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('notifications');
    }
};