
        fastcgi_cache_bypass $no_cache;
        fastcgi_no_cache $no_cache;
	fastcgi_cache  KVS;
	fastcgi_cache_lock on;
	fastcgi_cache_lock_timeout 5s;
	fastcgi_cache_min_uses 2;
	fastcgi_cache_valid 200 202 301 302 304 14m;

	#Формат ключа кеша - по этому ключу nginx находит правильную страничку
	fastcgi_cache_key "$ajaxed|$myref|$myarg|$scheme|$request_method|$host|$request_uri";
#	fastcgi_cache_key "$http_referer|$scheme|$request_method|$host|$request_uri";
#	fastcgi_cache_key "$http_referer|$request_method|$http_if_modified_since|$http_if_none_match|$host|$request_uri";
	# Остальные параметры кэша
	fastcgi_cache_use_stale error timeout http_500;
	fastcgi_ignore_headers Cache-Control Expires Set-Cookie;
	add_header X-F-Cache $upstream_cache_status;

