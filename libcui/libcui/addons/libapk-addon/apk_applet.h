/* apk_applet.h - Alpine Package Keeper (APK)
 *
 * Copyright (C) 2005-2008 Natanael Copa <n@tanael.org>
 * Copyright (C) 2008-2011 Timo Teräs <timo.teras@iki.fi>
 * All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 as published
 * by the Free Software Foundation. See http://www.gnu.org/ for details.
 */

#ifndef APK_APPLET_H
#define APK_APPLET_H

#include <getopt.h>
#include "apk_defines.h"
#include "apk_database.h"

struct apk_option {
	int val;
	const char *name;
	const char *help;
	int has_arg;
	const char *arg_name;
};

struct apk_applet {
	struct list_head node;

	const char *name;
	const char *arguments;
	const char *help;

	unsigned int open_flags, forced_flags;
	int context_size;
	int num_options;
	struct apk_option *options;

	int (*parse)(void *ctx, struct apk_db_options *dbopts,
		     int optch, int optindex, const char *optarg);
	int (*main)(void *ctx, struct apk_database *db, struct apk_string_array *args);
};

void apk_applet_register(struct apk_applet *);
typedef void (*apk_init_func_t)(void);

#define APK_DEFINE_APPLET(x) \
static void __register_##x(void) { apk_applet_register(&x); } \
static apk_init_func_t __regfunc_##x __attribute__((__section__("initapplets"))) __attribute((used)) = __register_##x;

#endif
