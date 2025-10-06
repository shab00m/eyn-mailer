#!/bin/bash
set -e

echo "==> Publishing SendPortal assets..."
php artisan vendor:publish --provider="Sendportal\Base\SendportalBaseServiceProvider" --tag=sendportal-assets --force

echo "==> Publishing SendPortal migrations..."
php artisan vendor:publish --provider="Sendportal\Base\SendportalBaseServiceProvider" --tag=sendportal-migrations --force

echo "==> Publishing SendPortal config..."
php artisan vendor:publish --provider="Sendportal\Base\SendportalBaseServiceProvider" --tag=sendportal-config --force

echo "==> Checking database connection..."
php artisan db:show || echo "Warning: Database connection issue detected"

echo "==> Running migrations..."
php artisan migrate --force || echo "Warning: Migrations failed or already applied"

echo "==> Seeding admin user..."
php artisan db:seed --class=AdminSeeder --force || echo "Warning: Seeder failed or already applied"

echo "==> Clearing cache..."
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Set proper permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Start Apache
exec apache2-foreground

