## Fastcgi_cache start

    set $no_cache 0;

    # POST requests and urls with a query string should always go to PHP
    if ($request_method = POST) {
	set $no_cache 1;
    }

    if ($query_string != "") {
	set $no_cache 1;
    }

    # Dont cache uris containing the following segments
    if ($request_uri ~* "(/wp-admin/|/xmlrpc.php|/wp-(app|cron|login|register|mail).php|wp-.*.php|/feed/|index.php|wp-comments-popup.php|wp-links-opml.php|wp-locations.php|sitemap(_index)?.xml|[a-z0-9_-]+-sitemap([0-9]+)?.xml)") {
	set $no_cache 1;
    }

    # Dont use the cache for logged in users or recent commenters
    if ($http_cookie ~* "comment_author|wordpress_[a-f0-9]+|wp-postpass|wordpress_no_cache|wordpress_logged_in") {
	set $no_cache 1;
    }

    fastcgi_cache_bypass $no_cache;
    fastcgi_no_cache $no_cache;

    fastcgi_cache_lock on;
    fastcgi_cache_lock_timeout 5s;

    # !! IMPORTANT! Watch the cache name defined in /etc/nginx/nginx.conf !!
    fastcgi_cache  WP;

    fastcgi_cache_min_uses 2;

    fastcgi_cache_valid 200 202 301 302 304 1m;

    # Cache key format, may need modifications, eg. for Woocommerce
    fastcgi_cache_key "$scheme$request_method$host$request_uri";

    # The rest
    fastcgi_cache_use_stale error timeout invalid_header http_500;
    fastcgi_ignore_headers Cache-Control Expires Set-Cookie;

## Fastcgi cache end
