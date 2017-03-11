pagespeed on;

#pagespeed RewriteLevel PassThrough;
pagespeed RewriteLevel CoreFilters;

pagespeed InPlaceResourceOptimization off;

##pagespeed FetchHttps enable;

pagespeed FileCachePath "/var/run/nginx_pagespeed_tcms.domain.com/";
pagespeed FileCacheSizeKb 16000;
pagespeed FileCacheCleanIntervalMs   3600000;
#pagespeed EnableFilters rewrite_domains;

pagespeed Domain http://tcms.domain.com;
pagespeed Domain http://*tcms.domain.com;

pagespeed Domain http://bnrs.it;
pagespeed Domain http://istri.it;

# Files location
pagespeed LoadFromFile "http://tcms.domain.com/" "/srv/www/tcms.domain.com/";
pagespeed LoadFromFile "http://*tcms.domain.com/" "/srv/www/tcms.domain.com/";
pagespeed LoadFromFileRuleMatch Disallow \.php$;

#HTML rules
pagespeed EnableFilters collapse_whitespace;
pagespeed EnableFilters insert_dns_prefetch;
#pagespeed EnableFilters extend_cache;

# CSS Rules
pagespeed EnableFilters combine_css;
pagespeed EnableFilters inline_css;
pagespeed EnableFilters inline_google_font_css;
pagespeed EnableFilters move_css_to_head;
pagespeed EnableFilters rewrite_css;

# JS Rules
pagespeed DisableFilters combine_javascript;
pagespeed DisableFilters rewrite_javascript;
#pagespeed EnableFilters make_google_analytics_async;
#pagespeed EnableFilters canonicalize_javascript_libraries;
#pagespeed EnableFilters defer_javascript;
pagespeed DisableFilters inline_javascript;

# Images Rules
pagespeed UrlValuedAttribute img data-orig image;
pagespeed EnableFilters rewrite_images;
pagespeed EnableFilters inline_images;
#pagespeed EnableFilters recompress_png;
pagespeed EnableFilters recompress_jpeg;
#pagespeed EnableFilters resize_rendered_image_dimensions;
pagespeed EnableFilters convert_jpeg_to_progressive;
pagespeed EnableFilters strip_image_color_profile;
pagespeed EnableFilters strip_image_meta_data;
pagespeed JpegRecompressionQuality 91;
pagespeed ImageRecompressionQuality 91;
pagespeed ImageInlineMaxBytes 2048;