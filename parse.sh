#!/bin/bash

echo "ip number1 number2 dateto datefrom" >> headers
curl https://isc.sans.edu/ipsascii.html | tee ips
sed -i -r '/(#.*)/d' ips # Probably don't need two different temp files /shrug
cat ips >> headers
sed -i 's/\s/,/g' headers
cat headers | perl -pe 's/(?<!\d)0+//g' > ips.csv # This regex is a little overzealous but, OK
rm headers && rm ips
echo 'Operation Complete. Created: ips.csv'

