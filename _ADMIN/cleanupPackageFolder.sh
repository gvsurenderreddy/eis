#! /bin/bash
# ----------------------------------------------------------------------------
# cleanupPackageFolder.sh - Remove old versions of packages from package
#                           repository folder.
#
# Creation   :  2013-11-21  starwarsfan
#
# Copyright (c) 2013 the eisfair team, team(at)eisfair(dot)org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ----------------------------------------------------------------------------

#exec 2> /tmp/createRepoIndex-trace$$.txt
#set -x

# Backup where we came from
callDir=`pwd`

# Go into the folder where the script is located and store the path.
# So all other scripts can be used directly
cd `dirname $0`
scriptDir=`pwd`
scriptName=`basename $0`
rtc=0

# -----------------------------
# Check if settings file exists
if [ -f "settings.txt" ] ; then
    # ----------------------------------------------------------------
    # This should be the normal case: settings.txt exists, so load it.
    . settings.txt
    echo "Settings loaded."
elif [ -f "settings.default.txt" ] ; then
    echo ""
    echo "Settings file not existing, creating new one out of default file."
    echo "The new one is on .gitignore, so it is secured that personal settings"
    echo "are not commited to the repository."
    cp settings.default.txt settings.txt
    echo "The script will be aborted here, please modify"
    echo "    ${scriptDir}/settings.txt"
    echo "to fit your needs. If the settings are OK, restart the script."
    echo ""
    exit 2
else
    # ---------------------------------------------------------------------
    # Thats odd: Not even 'settings.txt' nor 'settings.default.txt' exists!
    echo ""
    echo "ERROR: No settings file existing!"
    echo "The default file 'settings.default.txt' must exist on the folder"
    echo "'_ADMIN/'. This file is used to create"
    echo "a personal settings file, which you can setup to your needs."
    echo "Please check for that and restart the script again."
    echo ""
    exit 1
fi



getSortedContent ()
{
    for i in `ls ${repoPath}/` ; do
        rev=${i##*-r}
        rev=${rev%.apk}
        echo "${i%-r*} r${i##*-r} $rev"
    done | LANG=C sort -b -k1,1 -k3,3nr | sed "s/ /%/g"
}



cleanupPackageFolder ()
{
    counter=1
    for currentEntry in `getSortedContent` ; do
        #echo "Current package: $currentEntry"
        currentPackage=${currentEntry%\%*}
        currentRevision=${currentPackage#*\%}
        currentPackage=${currentPackage%\%*}
        echo "-> $currentPackage $currentRevision"
        if [ "$currentPackage" = "$previousPackage" ] ; then
            if [ ${counter} -gt ${amountOfPackagesToHold} ] ; then
                # Limit reached, remove package
                rm -f ${repoPath}/${currentPackage}-${currentRevision}
            fi
        else
            # First entry of a new package, reset counter
            previousPackage=${currentPackage}
            counter=1
        fi
        counter=$((counter+1))
    done
}



usage ()
{
    cat <<EOF

  Usage:
  ${0} -v <version> -a <architecture> [Options]
        Remove old package versions from pkg repository folder but let the
        default amount of packages stay in place. See options on how to
        modify this amount.

  Parameters:
  -v <version>
        .. The version of the system, for which the pkg repository folder
           should be cleaned up. Example: v2.7
  -a <architecture>
        .. The architecture of the system, for which the pkg repository
           folder should be cleaned up. Example: x86_64

  Optional parameters:
  -b <branch>
        .. The branch to be used on the repository. Default value: 'main'
  -s <amount>
        .. Amount of versions per package which should be stay in place,
           all other (old) versions will be deleted.

EOF
}

alpineRelease=''
branch='main'
alpineArch=''
amountOfPackagesToHold=3

while [ $# -ne 0 ]
do
    case $1 in
        -help|--help)
            # print usage
            usage
            exit 1
            ;;

        -v)
            if [ $# -ge 2 ] ; then
                alpineRelease=$2
                shift
            fi
            ;;

        -b)
            if [ $# -ge 2 ] ; then
                branch=$2
                shift
            fi
            ;;

        -a)
            if [ $# -ge 2 ] ; then
                alpineArch=$2
                shift
            fi
            ;;

        -s)
            if [ $# -ge 2 ] ; then
                amountOfPackagesToHold=$2
                shift
            fi
            ;;

        * )
            ;;
    esac
    shift
done

if [ -z "$alpineRelease" -o -z "$alpineArch" ] ; then
    echo "Parameters -v and -a must be used!"
    exit 1
fi

repoPath=${apkRepositoryBaseFolder}/${alpineRelease}/${branch}/${alpineArch}

# Now do the job :-)
cleanupPackageFolder

# ============================================================================
# End
# ============================================================================
