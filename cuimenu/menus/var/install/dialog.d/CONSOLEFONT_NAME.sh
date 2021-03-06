#!/bin/bash
#----------------------------------------------------------------------------
# /var/install/dialog.d/CONSOLEFONT_NAME.sh
# Copyright (c) 2001-2013 the eisfair team, team(at)eisfair(dot)org
#----------------------------------------------------------------------------
. /var/install/include/cuilib
. /var/install/include/ecelib

# exec_dailog
# ece --> request to create and execute dialog
#         $p2 --> main window handle
#         $p3 --> name of config variable
exec_dialog()
{
    win="$p2"
    if [ -e /lib/kbd/consolefonts ]
    then
        cd /lib/kbd/consolefonts
        for I in *
        do 
            [ -n "$sellist" ] && sellist="$sellist,"
            sellist="$sellist$(echo $I | sed 's#\.psf.*\.gz##g')"
        done
    else
        sellist="default8x16"
    fi
    ece_select_list_dlg "$win" "Console font face" "$sellist"
}

# main routine
cui_init
cui_run

# end
exit 0
