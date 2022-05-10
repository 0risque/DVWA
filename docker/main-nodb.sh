#!/bin/bash

# trick to pass system env var to apache2
# write env related to DVWA in a file, then append export to apache2 config file
eval "env | grep DVWA > /dvwaenv"
if [ -s /dvwaenv ] ;then
    echo "export \$(cat /dvwaenv | xargs)" >> /etc/apache2/envvars
fi

echo '[+] Starting apache'
service apache2 start

while true
do
    tail -f /var/log/apache2/*.log
    exit 0
done
