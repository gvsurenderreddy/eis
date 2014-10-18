#!/bin/bash
# ----------------------------------------------------------------------------
# /var/install/config.d/samba.sh - configuration generator script for Samba
#
# Copyright (c) 2014 the eisfair team <team@eisfair.org>
#
# Creation   : 2014-04-29 starwarsfan
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ----------------------------------------------------------------------------
#set -x
. /var/install/include/eislib
. /etc/config.d/base
. /etc/config.d/samba

sambaNativeConfig=/etc/samba/smb.conf

createConfigFileHeader()
{
    cat > ${sambaNativeConfig} <<EOF
# ===========================================================================
# This file was generated by the eisfair-ng configuration editor
#
# Do not modify it by hand as it will be overwritten as soon as the
# eisfair-ng configuration editor is used next time configuring samba.
# ===========================================================================

EOF
}

# --------------------------------------------
# Create global section of samba configuration
createGlobalConfiguration()
{
    sed -e "s/BIND_INTERFACES_ONLY/${SAMBA_BIND_INTERFACES_ONLY}/g" \
        -e "s/DEADTIME/${SAMBA_DEADTIME}/g" \
        -e "s/DEFAULT_CASE/${SAMBA_DEFAULT_CASE}/g" \
        -e "s/DISABLE_NETBIOS/${SAMBA_DISABLE_NETBIOS}/g" \
        -e "s/DNS_PROXY/${SAMBA_DNS_PROXY}/g" \
        -e "s/DOMAIN_MASTER/${SAMBA_DOMAIN_MASTER}/g" \
        -e "s/ENCRYPT_PASSWORDS/${SAMBA_ENCRYPT_PASSWORDS}/g" \
        -e "s/GUEST_OK/${SAMBA_GUEST_OK}/g" \
        -e "s/GUEST_ONLY/${SAMBA_GUEST_ONLY}/g" \
        -e "s#HOSTS_ALLOW#${SAMBA_HOSTS_ALLOW}#g" \
        -e "s/HOSTS_DENY/${SAMBA_HOSTS_DENY}/g" \
        -e "s/INTERFACES/${SAMBA_INTERFACES}/g" \
        -e "s/INVALID_USERS/${SAMBA_INVALID_USERS}/g" \
        -e "s/LOAD_PRINTERS/${SAMBA_LOAD_PRINTERS}/g" \
        -e "s/MAX_CONNECTIONS/${SAMBA_MAX_CONNECTIONS}/g" \
        -e "s/NETBIOS_NAME/${SAMBA_NETBIOS_NAME}/g" \
        -e "s/PREFERRED_MASTER/${SAMBA_PREFERRED_MASTER}/g" \
        -e "s/PRESERVE_CASE/${SAMBA_PRESERVE_CASE}/g" \
        -e "s/PRINTABLE/${SAMBA_PRINTABLE}/g" \
        -e "s/SECURITY/${SAMBA_SECURITY}/g" \
        -e "s/SERVER_STRING/${SAMBA_SERVER_STRING}/g" \
        -e "s/SOCKET_OPTIONS/${SAMBA_SOCKET_OPTIONS}/g" \
        -e "s/STRICT_SYNC/${SAMBA_STRICT_SYNC}/g" \
        -e "s/SYNC_ALWAYS/${SAMBA_SYNC_ALWAYS}/g" \
        -e "s/SYSLOG_LEVEL/${SAMBA_SYSLOG_LEVEL}/g" \
        -e "s/SYSLOG_ONLY/${SAMBA_SYSLOG_ONLY}/g" \
        -e "s/WORKGROUP/${SAMBA_WORKGROUP}/g" \
        /etc/default.d/samba.global.template >> ${sambaNativeConfig}
}

# --------------------------------------------------
# Create homes share sections of samba configuration
createHomeShareConfiguration()
{
    if [ "${SAMBA_SHARE_HOMES_ACTIVE}" = 'yes' ] ; then
        if [ "${SAMBA_SHARE_HOMES_ADVANCED_SETTINGS}" = 'yes' ] ; then
            sambaShareHomeCreateMask=$SAMBA_SHARE_HOMES_CREATE_MASK
            sambaHomeShareDirectoryMask=$SAMBA_SHARE_HOMES_DIRECTORY_MASK
            sambaHomeShareWriteable=$SAMBA_SHARE_HOMES_WRITEABLE
            sambaHomeShareValidUsers=$SAMBA_SHARE_HOMES_VALID_USERS
            sambaHomeShareForceCreateMode=$SAMBA_SHARE_HOMES_FORCE_CREATE_MODE
            sambaHomeShareForceDirectoryMode=$SAMBA_SHARE_HOMES_FORCE_DIRECTORY_MODE
        else
            sambaShareHomeCreateMask=${CREATE_MASK}
            sambaHomeShareDirectoryMask=${DIRECTORY_MASK}
            sambaHomeShareWriteable=${WRITEABLE}
            sambaHomeShareValidUsers='%S root'
            sambaHomeShareForceCreateMode=${FORCE_CREATE_MODE}
            sambaHomeShareForceDirectoryMode=${FORCE_DIRECTORY_MODE}
        fi
        sed -e "s/COMMENT/${SAMBA_SHARE_COMMENT}/g" \
            -e "s/CREATE_MASK/${sambaShareHomeCreateMask}/g" \
            -e "s/DIRECTORY_MASK/${sambaHomeShareDirectoryMask}/g" \
            -e "s/WRITEABLE/${sambaHomeShareWriteable}/g" \
            -e "s/BROWSEABLE/no/g" \
            -e "s/VALID_USERS/${sambaHomeShareValidUsers}/g" \
            -e "s/FORCE_CREATE_MODE/${sambaHomeShareForceCreateMode}/g" \
            -e "s/FORCE_DIRECTORY_MODE/${sambaHomeShareForceDirectoryMode}/g" \
            /etc/default.d/samba.homes.template >> ${sambaNativeConfig}
    fi
}

# --------------------------------------------
# Create share sections of samba configuration
createShareConfiguration()
{
    local shareIsActive='no'
    idx=1
    while [ ${idx} -le ${SAMBA_SHARE_N} ] ; do
        eval SAMBA_SHARE_NAME='$SAMBA_SHARE_'${idx}'_NAME'

        eval shareIsActive='$SAMBA_SHARE_'${idx}'_ACTIVE'
        if [ "${shareIsActive}" = 'yes' ] ; then
            eval SAMBA_SHARE_COMMENT='$SAMBA_SHARE_'${idx}'_COMMENT'
            eval SAMBA_SHARE_CREATE_MASK='$SAMBA_SHARE_'${idx}'_CREATE_MASK'
            eval SAMBA_SHARE_DIRECTORY_MASK='$SAMBA_SHARE_'${idx}'_DIRECTORY_MASK'
            eval SAMBA_SHARE_DIRECTORY_PATH='$SAMBA_SHARE_'${idx}'_DIRECTORY_PATH'
            eval SAMBA_SHARE_WRITEABLE='$SAMBA_SHARE_'${idx}'_WRITEABLE'
            eval SAMBA_SHARE_BROWSEABLE='$SAMBA_SHARE_'${idx}'_BROWSEABLE'
            eval SAMBA_SHARE_VALID_USERS='$SAMBA_SHARE_'${idx}'_VALID_USERS'
            eval SAMBA_SHARE_FORCE_CREATE_MODE='$SAMBA_SHARE_'${idx}'_FORCE_CREATE_MODE'
            eval SAMBA_SHARE_FORCE_DIRECTORY_MODE='$SAMBA_SHARE_'${idx}'_FORCE_DIRECTORY_MODE'
            sed -e "s/SHARE_NAME/${SAMBA_SHARE_NAME}/g" \
                -e "s/COMMENT/${SAMBA_SHARE_COMMENT}/g" \
                -e "s/CREATE_MASK/${SAMBA_SHARE_CREATE_MASK}/g" \
                -e "s/DIRECTORY_MASK/${SAMBA_SHARE_DIRECTORY_MASK}/g" \
                -e "s#DIRECTORY_PATH#${SAMBA_SHARE_DIRECTORY_PATH}#g" \
                -e "s/WRITEABLE/${SAMBA_SHARE_WRITEABLE}/g" \
                -e "s/BROWSEABLE/${SAMBA_SHARE_BROWSEABLE}/g" \
                -e "s/VALID_USERS/${SAMBA_SHARE_VALID_USERS}/g" \
                -e "s/FORCE_CREATE_MODE/${SAMBA_SHARE_FORCE_CREATE_MODE}/g" \
                -e "s/FORCE_DIRECTORY_MODE/${SAMBA_SHARE_FORCE_DIRECTORY_MODE}/g" \
                /etc/default.d/samba.share.template >> ${sambaNativeConfig}
        fi
        idx=$((idx+1))
    done
}

setupBooleanValues()
{
    if [ "$ENCRYPT_PASSWORDS" = 'yes' ] ; then
        ENCRYPT_PASSWORDS='true'
    else
        ENCRYPT_PASSWORDS='false'
    fi
}

# ----------------------------------------------------------------------------
# Main
if [ "$START_SAMBA" = 'yes' ] ; then
    setupBooleanValues
    createConfigFileHeader
    createGlobalConfiguration
    createHomeShareConfiguration
    createShareConfiguration
    rc-update add samba
else
    rc-update del samba
fi
exit 0
