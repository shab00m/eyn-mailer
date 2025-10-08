#!/bin/bash
set -e

echo "Running database migrations..."
php artisan migrate --force || echo "Migrations failed or already applied"

echo "Seeding admin user..."
php artisan db:seed --class=AdminSeeder --force || echo "Seeder failed or already applied"

echo "Starting PHP server..."
php -d display_errors=On -d display_startup_errors=On -S 0.0.0.0:$PORT -t public server.php

