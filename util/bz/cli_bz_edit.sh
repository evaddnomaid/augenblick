#!/bin/bash
textholder=$(cat)
echo $textholder
### $0 contains the name that the script was executed under
#echo $0
prettydate=`date +"%a %b %e, %Y"`
echo $prettydate >&2
isodate=`date +"%Y-%m-%d"`
echo $isodate >&2
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

# TODO: Escape double quotes in $textholder
cat >newcomment <<ender
{
  "comment" : "$textholder",
  "is_private" : false
}
ender

# TODO: Add a tag to every new comment that tells where the 
# comment came from (that is, from this bz commenter script).
# Info: https://bugzilla.readthedocs.io/en/latest/api/core/v1/comment.html#update-comment-tags

source ./.config

if [[ -n $bugid ]]; then
	echo bugid set, using $bugid >&2
else
	bugid=6000
	echo bugid not set, using $bugid >&2
fi

###curl -k "https://$bzhost/bz/rest.cgi/bug/$bugid/comment?token=$bztoken" --header "Content-Type: application/json" 2> /dev/null

# TODO: Find the ISO date to give the current time zone, rather
# than hard coding as Central Standard Time
#    date +%Z
# CST: UTC-6
# CDT: UTC-5
iso6801_latest=$(date +%Y-%m-%dT00:01:00-0600)

# Find the ID of the current diary entry
current_diary_bugid=$(curl -k "https://$bzhost/bz/rest.cgi/bug?component=diary&creation_time=$iso6801_latest&token=$bztoken" --header "Content-Type: application/json" | jq ".bugs[0].id")
# Make a comment on the current diary entry 
curl -k -vv -X POST -d @newcomment "https://$bzhost/bz/rest.cgi/bug/$current_diary_bugid/comment?token=$bztoken" --header "Content-Type: application/json"

#curl -k -vv -X POST -d @thistime "https://xx.xx.xx.xx/bz/rest.cgi/bug?id=1&token=1-Oxxxxxxxxx" --header "Content-Type: application/json"
#curl -k -vv "https://$bzhost/bz/rest.cgi/bug?id=$bugid&token=$bztoken" --header "Content-Type: application/json"
# Call above uses a token, not a password.  To request a token:
# curl -k "https://xx.xx.xx.xx/bz/rest.cgi/login?login=burchell@acm.org&password=xxxxxxxxxx"
# Bug for this in Bugzilla is https://xx.xx.xx.xx/bz/show_bug.cgi?id=2076
