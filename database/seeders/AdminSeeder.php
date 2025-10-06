<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Models\User;
use App\Models\Workspace;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    /**
     * Seed the application's database with an initial admin and workspace.
     */
    public function run(): void
    {
        $adminEmail = 'tobias.sjobom@gmail.com';
        $adminPassword = 'password';

        $user = User::firstOrCreate(
            ['email' => $adminEmail],
            [
                'name' => 'Admin',
                'password' => Hash::make($adminPassword),
                'email_verified_at' => now(),
                'locale' => 'en',
            ]
        );

        // Ensure password and verification are set even if the user existed
        $user->forceFill([
            'password' => Hash::make($adminPassword),
            'email_verified_at' => now(),
        ])->save();

        $workspace = Workspace::firstOrCreate(
            ['name' => 'Innovative Tools'],
            ['owner_id' => $user->id]
        );

        if (! $workspace->owner_id) {
            $workspace->owner_id = $user->id;
            $workspace->save();
        }

        // Attach user to workspace as owner if not already attached
        if (! $user->workspaces()->where('workspace_id', $workspace->id)->exists()) {
            $user->workspaces()->attach($workspace->id, ['role' => Workspace::ROLE_OWNER]);
        }

        if (! $user->current_workspace_id) {
            $user->current_workspace_id = $workspace->id;
            $user->save();
        }
    }
}


