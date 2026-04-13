FROM php:8.1-apache

# Install extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Enable rewrite
RUN a2enmod rewrite

# Set correct document root
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Update Apache config
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copy files
COPY . /var/www/html/

# FIX PERMISSIONS 🔥 (this is the main fix)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/data \
    && chmod -R 777 /var/www/html/custom

EXPOSE 80
