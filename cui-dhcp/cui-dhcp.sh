#!/bin/sh
#-------------------------------------------------------------------------------
# Eisfair configuration generator script
# Copyright (c) 2007 - 2015 the eisfair team, team(at)eisfair(dot)org
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#-------------------------------------------------------------------------------

#echo "Executing $0 ..."
#exec 2> /tmp/ssmtp-trace$$.log
#set -x

# read base configuration file for domain
. /etc/config.d/base

. /etc/config.d/dhcp

serverip_mask=$(/var/install/bin/netcalc interface ipv4 eth0)
servernetwork=$(/var/install/bin/netcalc network ${serverip_mask})
servermask=="${serverip_mask#* }" 
serverbrc=$(/var/install/bin/netcalc broadcast ${serverip_mask})


#-------------------------------------------------------------------------------
# creating/edit config file
#-------------------------------------------------------------------------------
idx=1
{
    echo "#----------------------------------------------------------------------"
    echo "# Do not edit this file directly, modify '/etc/config.d/dhcp' file and"
    echo "# re-run the /var/install/config.d/dhcp.sh' command to update."
    echo "#----------------------------------------------------------------------"
    echo "option domain-name '$DOMAIN_NAME';"
    echo "option domain-name-servers $DNS_SERVER ;"
    echo "option broadcast-address $serverbrc ;"
    echo "option routers $DHCP_NETWORK_GATE ;"
    echo "option subnet-mask $servermask ;"
    echo "default-lease-time 600;"
    echo "max-lease-time 7200;"
    echo "log-facility local7;"
    echo "subnet $servernetwork netmask $servermask"
    echo "  {"
    while [ $idx -le 0$DHCP_DYNAMIC_N ]
    do
      eval range_en='$DHCP_DYNAMIC_'$idx'_ACTIVE'
      if [ "$range_en" = "yes" ]
      then
        eval range_ip='$DHCP_DYNAMIC_'$idx'_RANGE'
        echo "    range $range_ip ;"
      fi
		  idx=`expr $idx + 1`
	  done    
    echo "  }"
} > /etc/dhcp/dhcpd.conf

# Set rights for configuration file
chmod 0644 /etc/dhcp/dhcp.conf
# hide plaintext password
chown root /etc/dhcp/dhcp.conf


#------------------------------------------------------------------------------
exit 0
