### WWW redirect to non-WWW

server {

    server_name www.cunty.click;
    return 301 $scheme://cunty.click$request_uri;
    error_log /var/log/nginx/www.cunty.click.error info;

    include templates/ip4_1_80;

} # close server


### Main non-WWW config

server {

    server_name cunty.click;

    error_log	/var/log/nginx/cunty.click.error.log warn;

    include templates/0_geo_ban;

    include templates/ip4_1_80;

    root /srv/www/cunty.click/;

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
    #access_log /var/log/nginx/cunty.click.access.log scripts;

    # PageSpeed module
    include templates/ps-cunty.click;

    # Universal KVS rewrites
    include templates/kvs-rewrites;

    # Universal basic KVS security
    include templates/kvs-security;

    # Universal KVS PHP rules
    include templates/php-kvs-cunty.click;

    # Universal static files rules
    include templates/0_static-default;

}  # close server

### Addon config for static files subdomains s1...s8

server {

    charset utf-8;

    include /etc/nginx/templates/ip4_1_80;

    # Cool regex to cover subdomains
    server_name "~^s\w{1}\.cunty.click$";

    root /srv/www/cunty.click/;

    # It is only for images, videos, CSS, JS and fonts
    index	404.html;

    access_log off;
    error_log /var/log/nginx/cunty.click-static.log error;


    include templates/ps-cunty.click;
    
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
