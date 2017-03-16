
location / {
    try_files $uri $uri/ /index.php?$args;
}


location ~ .php$ {

    try_files $uri /index.php;

    fastcgi_pass   unix:/var/run/php-wp.domain.com.sock;

    # Include caching rules
    include templates/php-wp-cache-wp.domain.com;

    fastcgi_index  index.php;

    fastcgi_intercept_errors on; # remove after testing

    include fastcgi_params;
    fastcgi_param       SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    fastcgi_ignore_client_abort     off;
    fastcgi_buffer_size 64K;
    fastcgi_buffers 16 64k;
}


# This works ONLY if Nginx built with cache purge module compiled
location ~ /purge(/.*) {
	# Watch cache name defined in /etc/nginx/nginx.conf!!
        fastcgi_cache_purge WP "$scheme$request_method$host$1";
    }

# A bit of security
location ~* ^/(\.htaccess|xmlrpc\.php)$ {
    return 404;
}