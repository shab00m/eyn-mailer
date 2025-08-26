<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminUpdateSeeder extends Seeder
{
    public function run(): void
    {
        $oldEmail = 'tobias.sjobom@gmail.com';
        $newEmail = 'marketing@4starelectronics.com';
        $newPassword = '2TR8b7D46vd';

        $user = User::where('email', $oldEmail)->first();
        if (! $user) {
            $user = User::where('email', $newEmail)->first();
        }

        if (! $user) {
            return; // No-op if user not found
        }

        $user->forceFill([
            'email' => $newEmail,
            'password' => Hash::make($newPassword),
            'email_verified_at' => now(),
        ])->save();
    }
}
