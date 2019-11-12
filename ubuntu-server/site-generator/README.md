# Site generator for Nginx + PHP-FPM + Dehydrated Letsencrypt SSL

**Please note:** Nginx, PHP-FPM and Dehydrated ***MUST*** be preinstalled and pre-configured.

***WARNING***: Script is still in BETA. Use carefully. Always make a backup of config files before using.

## FILES
### Scripts:
* **generate-scj-cf.sh** - Script to generate pre-configured `SmartCJ` configs, domains are **proxied** via `CloudFlare` (so no A record is checking)

### Data file:
**dataset.txt** - CSV style text structured file. Quotes and special lines beginning with `domain.com`.
`Tags` are for SEO rewrites. File structure with example:

Domain|SmartCJ Directory|Popular Tag|Duration Tag|Movies Tag|Search Tag|Categories Tag
------|-----------------|-----------|------------|----------|----------|--------------
domain.com|scj|most-popular|most-long|movies|search|categories


