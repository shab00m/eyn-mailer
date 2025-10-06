#!/bin/bash
set -e

echo "==> Publishing SendPortal assets..."
php artisan vendor:publish --provider="Sendportal\Base\SendportalBaseServiceProvider" --tag=sendportal-assets --force

echo "==> Publishing SendPortal migrations..."
php artisan vendor:publish --provider="Sendportal\Base\SendportalBaseServiceProvider" --tag=sendportal-migrations --force

echo "==> Publishing SendPortal config..."
php artisan vendor:publish --provider="Sendportal\Base\SendportalBaseServiceProvider" --tag=sendportal-config --force

echo "==> Environment Check..."
echo "DATABASE_URL is set: ${DATABASE_URL:+YES}"
echo "DB_CONNECTION: ${DB_CONNECTION:-not set}"

echo "==> Testing database connection..."
if php artisan db:show; then
    echo "Database connection successful!"
else
    echo "ERROR: Cannot connect to database. Please check DATABASE_URL environment variable."
    echo "Will continue but migrations will fail..."
fi

echo "==> Running migrations..."
if php artisan migrate --force; then
    echo "Migrations completed successfully!"
else
    echo "ERROR: Migrations failed. Check database connection and credentials."
    exit 1
fi

echo "==> Seeding admin user..."
if php artisan db:seed --class=AdminSeeder --force; then
    echo "Admin user seeded successfully!"
else
    echo "WARNING: Seeder failed (may already be seeded)"
fi

echo "==> Clearing cache..."
php artisan config:clear
php artisan route:clear
php artisan view:clear

echo "==> Startup complete!"

# Set proper permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Start Apache
exec apache2-foreground

