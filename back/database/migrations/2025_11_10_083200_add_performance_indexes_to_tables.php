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
        // Add indexes to client table for better join performance
        Schema::table('client', function (Blueprint $table) {
            $table->index('categories_id', 'idx_client_categories_id');
            $table->index('domain_id', 'idx_client_domain_id');
            $table->index('user_id', 'idx_client_user_id');
            $table->index('email', 'idx_client_email');
            $table->index('raison_sociale', 'idx_client_raison_sociale');
            $table->index('deleted_at', 'idx_client_deleted_at');
        });

        // Add indexes to users table
        Schema::table('users', function (Blueprint $table) {
            $table->index('email', 'idx_users_email');
            $table->index('role', 'idx_users_role');
            $table->index('is_active', 'idx_users_is_active');
            $table->index('deleted_at', 'idx_users_deleted_at');
        });

        // Add indexes to clientcategories table
        Schema::table('clientcategories', function (Blueprint $table) {
            $table->index('label', 'idx_categories_label');
            $table->index('is_active', 'idx_categories_is_active');
            $table->index('deleted_at', 'idx_categories_deleted_at');
        });

        // Add indexes to domaine_dactivites table
        Schema::table('domaine_dactivites', function (Blueprint $table) {
            $table->index('label', 'idx_domains_label');
            $table->index('deleted_at', 'idx_domains_deleted_at');
        });

        // Add indexes to client_contact table if it exists
        if (Schema::hasTable('client_contact')) {
            Schema::table('client_contact', function (Blueprint $table) {
                $table->index('client_id', 'idx_contact_client_id');
                $table->index('user_id', 'idx_contact_user_id');
                $table->index('email', 'idx_contact_email');
                $table->index('is_responsable', 'idx_contact_is_responsable');
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('client', function (Blueprint $table) {
            $table->dropIndex('idx_client_categories_id');
            $table->dropIndex('idx_client_domain_id');
            $table->dropIndex('idx_client_user_id');
            $table->dropIndex('idx_client_email');
            $table->dropIndex('idx_client_raison_sociale');
            $table->dropIndex('idx_client_deleted_at');
        });

        Schema::table('users', function (Blueprint $table) {
            $table->dropIndex('idx_users_email');
            $table->dropIndex('idx_users_role');
            $table->dropIndex('idx_users_is_active');
            $table->dropIndex('idx_users_deleted_at');
        });

        Schema::table('clientcategories', function (Blueprint $table) {
            $table->dropIndex('idx_categories_label');
            $table->dropIndex('idx_categories_is_active');
            $table->dropIndex('idx_categories_deleted_at');
        });

        Schema::table('domaine_dactivites', function (Blueprint $table) {
            $table->dropIndex('idx_domains_label');
            $table->dropIndex('idx_domains_deleted_at');
        });

        if (Schema::hasTable('client_contact')) {
            Schema::table('client_contact', function (Blueprint $table) {
                $table->dropIndex('idx_contact_client_id');
                $table->dropIndex('idx_contact_user_id');
                $table->dropIndex('idx_contact_email');
                $table->dropIndex('idx_contact_is_responsable');
            });
        }
    }
};
