
### HTTP server config with auto redirect to HTTPS

server {

    server_name monit.kvs.domain.com;

    error_log /var/log/nginx/monit.kvs.domain.com.error info;

    include templates/ip4_1_80;

    # Letsencrypt alias config for acme-challenges
    include templates/0_le;

    return 301 https://$server_name$request_uri;

} # close server


### HTTPS server config

server {

    server_name monit.kvs.domain.com;

    error_log	/var/log/nginx/monit.kvs.domain.com.error.log warn;

    include templates/ip4_1_443;

    charset utf-8;

    ## SSL Section

    ssl on;

    # Certificate and key paths to Letsencrypt generated ones
    ssl_certificate /opt/dehydrated/certs/monit.kvs.domain.com/fullchain.pem;
    ssl_certificate_key /opt/dehydrated/certs/monit.kvs.domain.com/privkey.pem;
    ssl_trusted_certificate /opt/dehydrated/certs/monit.kvs.domain.com/chain.pem;

    ssl_stapling on;
    ssl_stapling_verify on;

    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 15s;

    # Uncomment if HSTS needed
    #add_header Strict-Transport-Security "max-age=31536000; includeSubdomains;";

    # Letsencrypt alias for acme-challenges
    include templates/0_le;

    # Proxy rules to MMonit internal Web GUI
    location / {
        proxy_pass http://127.0.0.1:2812;
    #   proxy_set_header Host $host;
    #   proxy_set_header X-Real-IP $remote_addr;
    #   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    #    proxy_set_header X-Forwarded-Proto https;
    }

}  # close server

