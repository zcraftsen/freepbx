#!/bin/bash

# File to be modified
ntp_conf="/etc/ntp.conf"

# Comment out the specified lines
sed -i 's/^server 0.centos.pool.ntp.org iburst/#&/' "$ntp_conf"
sed -i 's/^server 1.centos.pool.ntp.org iburst/#&/' "$ntp_conf"
sed -i 's/^server 2.centos.pool.ntp.org iburst/#&/' "$ntp_conf"
sed -i 's/^server 3.centos.pool.ntp.org iburst/#&/' "$ntp_conf"

# Add new NTP server entries
echo -e "\n# added\nserver ntp1.tls.ad iburst\nserver ntp3.tls.ad iburst" >> "$ntp_conf"

# Restart the NTP service to apply changes
systemctl restart ntpd
