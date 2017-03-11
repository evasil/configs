### WWW redirect to non-WWW

server {

    server_name www.kvs.domain.com;
    return 301 $scheme://kvs.domain.com$request_uri;
    error_log /var/log/nginx/www.kvs.domain.com.error info;

    include templates/ip4_1_80;

} # close server


### Main non-WWW config

server {

    server_name kvs.domain.com;

    error_log	/var/log/nginx/kvs.domain.com.error.log warn;

    include templates/0_geo_ban;

    include templates/ip4_1_80;

    root /srv/www/kvs.domain.com/;

    index index.php;

    charset utf-8;

    ## Trick to fool idiots, 403 -> 404
    error_page 404 =  @cust404;

    location @cust404 {
            return 301 /404.html;
    }
    ## End of trick

    # Prevent XSS and other injections
    include templates/0_frames;

    include templates/0_scanners;

    # Uncomment if access log needed
    #access_log /var/log/nginx/kvs.domain.com.access.log scripts;

    # PageSpeed module
    include templates/ps-kvs.domain.com;

    # Universal KVS rewrites
    include templates/kvs-rewrites;

    # Universal basic KVS security
    include templates/kvs-security;

    # Universal KVS PHP rules
    include templates/php-kvs-kvs.domain.com;

    # Universal static files rules
    include templates/0_static-default;

}  # close server

### Addon config for static files subdomains s1...s8

server {

    charset utf-8;

    include /etc/nginx/templates/ip4_1_80;

    # Cool regex to cover subdomains
    server_name "~^s\w{1}\.kvs.domain.com$";

    root /srv/www/kvs.domain.com/;

    # It is only for images, videos, CSS, JS and fonts
    index	404.html;

    access_log off;
    error_log /var/log/nginx/kvs.domain.com-static.log error;


    include templates/ps-kvs.domain.com;
    
    include templates/kvs-rewrites-static;
    include templates/0_static-nocookie;

    # Remove if no module "headers-more-nginx-module" installed
    # See https://github.com/openresty/headers-more-nginx-module
    more_clear_headers 'Set-Cookie' 'Cookie';

    location / {
        access_log off;
        expires    max;
        add_header Cache-Control public;
        fastcgi_hide_header Set-Cookie;
    }

} # close server
