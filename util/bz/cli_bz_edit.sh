#!/bin/bash
prettydate=`date +"%a %b %e, %Y"`
echo $prettydate
isodate=`date +"%Y-%m-%d"`
echo $isodate
cat >thistime <<ender
{
  "status" : "DIARY",
  "product" : "DJB_Personal",
  "component" : "diary",
  "version" : "unspecified",
  "summary" : "$prettydate",
  "cf_revisit_date" : "$isodate"
}
ender

source ./.config

if [[ -n $bugid ]]; then
	echo bugid set, using $bugid
else
	bugid=6000
	echo bugid not set, using $bugid
fi

# TODO: Get the token and IP addr from .config
#echo "$THISDOC"
#exit
#curl -k -vv -X POST -d @thistime "https://xx.xx.xx.xx/bz/rest.cgi/bug?id=1&token=1-lxxxxxxxxx" --header "Content-Type: application/json"
#curl -k -vv -X POST -d @thistime "https://xx.xx.xx.xx/bz/rest.cgi/bug?id=1&token=1-Oxxxxxxxxx" --header "Content-Type: application/json"
curl -k -vv "https://$bzhost/bz/rest.cgi/bug?id=$bugid&token=$bztoken" --header "Content-Type: application/json"
# Call above uses a token, not a password.  To request a token:
# curl -k "https://xx.xx.xx.xx/bz/rest.cgi/login?login=burchell@acm.org&password=xxxxxxxxxx"
# Bug for this in Bugzilla is https://xx.xx.xx.xx/bz/show_bug.cgi?id=2076
