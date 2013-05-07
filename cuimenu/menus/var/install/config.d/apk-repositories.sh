#!/bin/sh
#----------------------------------------------------------------------------
# /var/install/config.d/apk-repositories.sh - apply configuration 
# Copyright (c) 2001-2013 the eisfair team, team(at)eisfair(dot)org
# Creation:     2013-05-03 starwarsfan
#----------------------------------------------------------------------------

package_name=apk-repositories

#exec 2>/tmp/${package_name}-trace$$.log
#set -x

. /etc/config.d/$package_name

# ----------------------------------------------------------------------------
# Busybox wget can't handle https:// urls, so give the user a hint to install
# gnu wget.
# ----------------------------------------------------------------------------
checkHttps ()
{
    local givenHost=$1
    case $givenHost in
        https*)
            if ! apk info --installed wget >/dev/null 2>&1 ; then
                echo "Busybox wget does not suppoert https:// urls! Please install gnu wget."
                echo "Url $givenHost will be deactivated."
                commentCharacter='#'
            fi
            ;;
        *)
            ;;
    esac
}

# ----------------------------------------------------------------------------
# Create apk repo configuration /etc/apk/repositories
# ----------------------------------------------------------------------------
cat > /etc/apk/repositories <<EOF
# ----------------------------------------------------------------------------
# Config file generated by alpeis setup
# Do not edit this file, edit /etc/config.d/apk-repositories
# ----------------------------------------------------------------------------

EOF

# Begin idx -le ${APK_REPOSITORY_N}
idx=1
while [ "${idx}" -le "${APK_REPOSITORY_N}" ] : do
    eval active='${APK_REPOSITORY_'${idx}'_ACTIVE}'
    eval host='${APK_REPOSITORY_'${idx}'_URL}'
    if [ "${active}" = 'yes' ] ; then
        commentCharacter=''
        checkHttps ${host}
    else
        commentCharacter='#'
    fi

    echo ${commentCharacter}${host} >> /etc/apk/repositories

    # End idx -le ${APK_REPOSITORY_N}
    idx=`/usr/bin/expr ${idx} + 1`
done

echo "Apk repository configuration written."

exit 0
