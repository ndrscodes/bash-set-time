#!/bin/bash

NTP_SERVICE="/etc/init.d/ntp"
URL="timeapi.io"
ENDPOINT="/api/TimeZone/zone?timeZone=Europe/Berlin"
DNS="8.8.8.8"

IP=$(nslookup $URL $DNS | egrep -o "([0-9]{1,3}\.){1,3}[0-9]{1,3}" | tail -n 1)
echo "server ip seems to be $IP"

RESPONSE=$(curl --insecure -s --resolve $URL:443:$IP https://${URL}${ENDPOINT})
echo "server response: $RESPONSE"

TIME=$(echo "$RESPONSE" | egrep -o "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}" | head -n 1 | tr T " ")
echo "found time $TIME"

if systemctl list-units --full -all | grep "ntp\.service" | grep -q "active"; then
        $NTP_SERVICE stop
        echo "stopped $NTP_SERVICE"
fi

timedatectl set-time "$TIME"
echo "set time to $TIME"

ntpd -q
echo "NTP sync done, time is $(date)"

if systemctl list-units --full -all | grep "ntp\.service"; then
        $NTP_SERVICE start
        echo "$NTP_SERVICE started"
fi
