location ~* \.(php)$ {

    include templates/php-tcms-cache-tcms.domain.com;

    fastcgi_pass   unix:/var/run/php-tcms.domain.com.sock;
    fastcgi_index  index.php;

    fastcgi_intercept_errors on; # remove after testing perios ended
    include fastcgi_params;
    fastcgi_param       SCRIPT_FILENAME  $document_root$fastcgi_script_name;

    fastcgi_ignore_client_abort     off;
    fastcgi_buffer_size 32K;
    fastcgi_buffers 84 32k;


    # Workaround to fix TCMS behind proxy issues
    fastcgi_param HTTP_X_FORWARDED_FOR '';
    fastcgi_param HTTP_X_FORWARDED_PROTO '';

    fastcgi_hide_header X-Forwarded-For;
    fastcgi_hide_header HTTP_FORWARDED_FOR;
    fastcgi_hide_header HTTP_X_FORWARDED_FOR;
    fastcgi_hide_header HTTP_X_FORWARDED_PROTO;
}