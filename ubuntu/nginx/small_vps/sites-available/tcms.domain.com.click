
### HTTP Server config with redirect WW to non-WWW

server {

    server_name www.tcms.domain.com;
    return 301 $scheme://tcms.domain.com$request_uri;

    error_log /var/log/nginx/www.tcms.domain.com.error info;

    include templates/ip4_1_80;

} # close server


### HTTP server config for non-WWW

server {

    server_name tcms.domain.com;

    error_log	/var/log/nginx/tcms.domain.com.error.log warn;

    root /srv/www/tcms.domain.com/;

    index index.html index.php;

    charset utf-8;


    ## 403 to 404 redirect to fool idiots
    error_page 404 =  @cust404;

    location @cust404 {
            return 301 /404.html;
    }
    ## End of redirect

    ## Includes

    # Rules to prevent XSS and other injections
    include templates/0_frames;

    # Rules to stop some scanners
    include templates/0_scanners;

    # Country based ban config
    include templates/0_geo_ban;

    # Default listen on 1st IP and port 80
    include templates/ip4_1_80;

    # PageSpeed domain related config
    include templates/ps-tcms.domain.com;

    # Typical TCMS rewrites
    include templates/tcms-rewrites;

    # Typical TCMS security
    include templates/tcms-security;

    # TCMS PHP domain related config
    include templates/php-tcms-tcms.domain.com;

    # Univeresal rules for static files
    include templates/0_static-default;

}  # close server

### Addon server for static subdomains s1...s8

server {

    charset utf-8;

    include /etc/nginx/templates/ip4_1_80;

    server_name "~^s\w{1}\.tcms.domain.com$";

    root /srv/www/tcms.domain.com/;

    index	404.html;

    access_log off;
    error_log /var/log/nginx/tcms.domain.com-static.log error;

    include templates/ps-tcms.domain.com;

    # Typical TCMS static files rewrites
    include templates/tcms-rewrites-static;

    # Static files rules for cookieless domains
    include templates/0_static-nocookie;

} # close server
