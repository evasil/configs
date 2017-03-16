### HTTP section with redirect to HTTPS

server {
    include /etc/nginx/templates/ip6_1_80;
    include /etc/nginx/templates/ip4_1_80;
    server_name wp.domain.com www.wp.domain.com static.wp.domain.com;

    # force https-redirects
    if ($scheme = http) {
        return 301 https://$host$request_uri;
    }

} # close server

### HTTPS section with main rules

server {

    include /etc/nginx/templates/ip6_1_443;
    include /etc/nginx/templates/ip4_1_443;

    server_name wp.domain.com www.wp.domain.com static.wp.domain.com;

    ## SSL block

    ssl on;
    ssl_certificate /opt/dehydrated/certs/wp.domain.com/fullchain.pem;
    ssl_certificate_key /opt/dehydrated/certs/wp.domain.com/privkey.pem;

    ssl_stapling on;
    ssl_stapling_verify on;
    ssl_trusted_certificate /opt/dehydrated/certs/wp.domain.com/chain.pem;
    resolver 8.8.8.8 8.8.4.4;
    resolver_timeout 3s;

    add_header Strict-Transport-Security "max-age=31536000;";

    # Certificate pinning, see decription in /opt/dehydrated/hook.sh
    include /opt/dehydrated/certs/wp.domain.com/hpkp.txt;

    ## End of SSL block

    access_log off;
    error_log /var/log/nginx/wp.domain.com.err.log warn;

    root /srv/www/wp.domain.com/;

include templates/0_le;

include templates/0_cloudflare;

include templates/0_frames;

include templates/0_scanners;

include templates/0_gzip;

include templates/0_static-default;

# Domain specific WP PHP config
include templates/php-wp-wp.domain.com;

# Typicla WP rules, not PHP related
include templates/wp-default;

} # close server


## non-existing subdomains
server {

include /etc/nginx/templates/ip6_1_80;
include /etc/nginx/templates/ip6_1_443;
include /etc/nginx/templates/ip4_1_80;
include /etc/nginx/templates/ip4_1_443;


server_name *.wp.domain.com;

return 444;

} # close server
