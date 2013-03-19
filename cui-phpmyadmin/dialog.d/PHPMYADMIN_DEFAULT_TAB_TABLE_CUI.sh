#!/bin/sh
#------------------------------------------------------------------------------
# /var/install/dialog.d/PHPMYADMIN_DEFAULT_TAB_TABLE_CUI.sh - script dialog for ece
#
# Creation:     2008-02-24 starwarsfan
# Last update:  $Id: PHPMYADMIN_DEFAULT_TAB_TABLE_CUI.sh 21582 2009-10-17 09:17:35Z alex $
#
# Copyright (c) 2001-2009 The eisfair Team, <team(at)eisfair(dot)org>
# Maintained by Y. Schumann <yves(at)eisfair(dot)org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#----------------------------------------------------------------------------

. /var/install/include/cuilib
. /var/install/include/ecelib

#----------------------------------------------------------------------------
# exec_dailog
# ece --> request to create and execute dialog
#         $p2 --> main window handle
#         $p3 --> name of config variable
#----------------------------------------------------------------------------
exec_dialog()
{
    win="$p2"

    sellist="tbl_properties_structure.php,tbl_properties.php,tbl_select.php,tbl_change.php,sql.php"

    ece_select_list_dlg "$win" "Default tab table" "$sellist"
}

#----------------------------------------------------------------------------
# main routine
#----------------------------------------------------------------------------

cui_init
cui_run

#----------------------------------------------------------------------------
# end
#----------------------------------------------------------------------------

exit 0