#!/bin/bash

WORKDIR="/root/site-generator"
DESTDIR="/etc/nginx"
TMPLDIR="/root/site-generator/tmpl"
IPADDR=`hostname --ip-address`
DEFILE="/opt/dehydrated/domains.txt"

INPUT="$WORKDIR/dataset.txt"
OLDIFS=$IFS
IFS=','

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read domain cjdir poptag durtag searchtag movtag cattag
do
[[ "$domain" =~ ^[[:space:]]*# ]] && continue
	echo "----------------"
	echo "Domain : $domain"
	echo "CJ Dir : $cjdir"
	echo "Popular : $poptag"
	echo "Duration : $durtag"
	echo "Search : $searchtag"
	echo "Movies : $movtag"
	echo "Category : $cattag"
if [ "$domain" == "domain.com" ]; then
    echo "### TESTING, not continuing"
    exit 0
else
	echo "## Cleanup Dehydrated domain string(s)"
	sed -i "/$domain/d" $DEFILE

##	echo "## Checking $domain IP address"
##	RESIP=`host $domain | awk '/has address/ { print $4 }'`
##	TESTIP=$RESIP
##	if [ "$IPADDR" == "$TESTIP" ]; then
##	    echo "## Domain $domain IP is  correct : $TESTIP, server IP: $IPADDR"

	    echo "## Generating rewrites template"
	    RWRFILE="$DESTDIR/templates/smartcj-rewrite-$domain"
	    cp -f $TMPLDIR/smartcj-rewrite-tmpl $RWRFILE
	    sed -i "s/##CJDIR##/$cjdir/g" $RWRFILE
	    sed -i "s/##POPTAG##/$poptag/g" $RWRFILE
	    sed -i "s/##DURTAG##/$durtag/g" $RWRFILE
	    sed -i "s/##SEARCHTAG##/$searchtag/g" $RWRFILE
	    sed -i "s/##MOVTAG##/$movtag/g" $RWRFILE
	    sed -i "s/##CATTAG##/$cattag/g" $RWRFILE

	    echo "## Generating Nginx HTTP config"
	    HTTPFILE="$DESTDIR/sites-available/$domain"
	    LHTTPFILE="$DESTDIR/sites-enabled/$domain"
	    cp -f $TMPLDIR/nginx80 $HTTPFILE
	    sed -i "s/##DOMAIN##/$domain/g" $HTTPFILE
	    ln -f -s $HTTPFILE $LHTTPFILE

	    echo "## Nginx test 1"
	    nginx -t > /dev/null && { echo "## Nginx Test OK"; nginx -s reload; } || { echo "!! Nginx Test Failed!"; exit 99; }

	    echo "## Creating new certificate"
	    /opt/dehydrated/dehydrated -4 -c -d $domain && { echo "## Certificate done OK."; sleep 1; } || { echo "!! Certificate FAILED!"; exit 99; }
	    echo $domain >> $DEFILE
	    echo "## Generating Nginx HTTPS config"
	    HTTPSFILE="$WORKDIR/nginx443-$domain.tmp"
	    cp -f $TMPLDIR/nginx443 $HTTPSFILE
	    sed -i "s/##DOMAIN##/$domain/g" $HTTPSFILE
	    sed -i "s/##CJDIR##/$cjdir/g" $HTTPSFILE
	    cat $HTTPSFILE >> $HTTPFILE
	    sed -i 's/##return/return/g' $HTTPFILE
	    rm -f $HTTPSFILE
	    echo "## Nginx test 2"
	    nginx -t > /dev/null && { echo "## Nginx Test OK"; nginx -s reload; } || { echo "!! Nginx Test Failed!"; exit 99; }

##	else
##	    echo "!! Domain $domain IP is wrong : $TESTIP but server IP: $IPADDR"
##	    echo "!! Skipping $domain"
##	fi

fi

done < $INPUT
IFS=$OLDIFS

exit 0