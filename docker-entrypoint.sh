#!/bin/bash
set -e

# Publish vendor assets (SendPortal)
php artisan vendor:publish --provider="Sendportal\Base\SendportalBaseServiceProvider" --tag=sendportal-assets --force

# Run migrations
php artisan migrate --force

# Clear and cache config
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Set proper permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Start Apache
exec apache2-foreground

