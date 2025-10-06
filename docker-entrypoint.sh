#!/bin/bash
set -e

# Publish vendor assets (SendPortal)
php artisan vendor:publish --provider="Sendportal\Base\SendportalBaseServiceProvider" --tag=sendportal-assets --force

# Run migrations (skip if database not available)
php artisan migrate --force 2>/dev/null || echo "Skipping migrations - database not available or already migrated"

# Clear and cache config
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Set proper permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Start Apache
exec apache2-foreground

