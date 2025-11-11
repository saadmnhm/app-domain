<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class ClientControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_authenticated_user_can_list_clients()
    {
        $user = User::factory()->create();
        $clients = Client::factory()->count(3)->create();

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/clients');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'raison_sociale', 'email', 'category', 'domain']
                ],
                'links',
                'meta'
            ]);
    }

    public function test_unauthenticated_user_cannot_access_clients()
    {
        $response = $this->getJson('/api/clients');
        $response->assertUnauthorized();
    }

    public function test_user_cannot_create_client_with_invalid_data()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->postJson('/api/clients', [
                'raison_sociale' => '', 
                'email' => 'not-an-email', 
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors(['raison_sociale', 'email']);
    }
}
