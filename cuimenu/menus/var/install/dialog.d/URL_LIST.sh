#!/bin/bash
#----------------------------------------------------------------------------
# /var/install/dialog.d/URL_LIST.sh - script dialog for ece
# Copyright (c) 2012 - 2013 the eisfair team, team(at)eisfair(dot)org
#----------------------------------------------------------------------------
. /var/install/include/cuilib
. /var/install/include/ecelib

# exec_dailog
# ece --> request to create and execute dialog
#         $p2 --> main window handle
#         $p3 --> name of config variable
exec_dialog()
{
    win="${p2}"
    sellist="nl.alpinelinux.org,dl-2.alpinelinux.org,dl-3.alpinelinux.org,dl-4.alpinelinux.org,dl-5.alpinelinux.org,distrib-coffee.ipsl.jussieu.fr,mirror.yandex.ru,mirrors.gigenet.com,repos.lax-noc.com"
    ece_select_list_dlg "${win}" "Priority level" "${sellist}"
}

# main routine
cui_init
cui_run

# end
exit 0
