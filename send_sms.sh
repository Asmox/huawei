#!/bin/sh

# usage: sh send.sh "192.168.8.1" "+48xxxyyyzzz" "test kolejny :) ąśćź"

if [ $# -lt 2 ]
then
echo "Podałeś za mało paramerów ustawiam domyslne\n"
host="192.168.8.1"
number="+48533090410"
content="testowy sms do $number"
echo -e "Host: $host\nNumer: $number\nTreść: $content"
else
host="$1"
number="$2"
content="$3"
echo -e "Podałeś Host: $host\nNumer: $number\nTreść: $content"
fi 
length=${#content}

echo $length
cc=`curl -s -X GET http://$host/api/webserver/SesTokInfo`
echo $cc
c=`echo "$cc"| cut -b 58-185`
t=`echo "$cc"| cut -b 205-236`
date=$(date +"%Y-%m-%d %H:%M:%S")
echo $date

curl -v http://$host/api/sms/send-sms \
 -H "Cookie: SessionID=$c" -H "__RequestVerificationToken: $t" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
 --data "<?xml version="1.0" encoding="UTF-8"?><request><Index>-1</Index><Phones><Phone>$number</Phone></Phones><Sca></Sca><Content>$content</Content><Length>$length</Length><Reserved>1</Reserved><Date>$date</Date></request>"
