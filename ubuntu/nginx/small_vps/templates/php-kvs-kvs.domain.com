location ~* \.(php)$ {

# FastCGI domain related caching rules
include templates/php-kvs-cache-kvs.domain.com;

fastcgi_pass   unix:/var/run/php-kvs.domain.com.sock;
fastcgi_index  index.php;

#fastcgi_intercept_errors on; # for testing only
include fastcgi_params;
fastcgi_param       SCRIPT_FILENAME  $document_root$fastcgi_script_name;

# Enable in certain bugs
#fastcgi_param SCRIPT_FILENAME $request_filename;


fastcgi_param HTTP_X_FORWARDED_FOR '';
fastcgi_param HTTP_X_FORWARDED_PROTO '';
fastcgi_ignore_client_abort     off;
fastcgi_buffer_size 32K;
fastcgi_buffers 84 32k;

fastcgi_hide_header X-Forwarded-For;
fastcgi_hide_header HTTP_FORWARDED_FOR;
fastcgi_hide_header HTTP_X_FORWARDED_FOR;
fastcgi_hide_header HTTP_X_FORWARDED_PROTO;
}