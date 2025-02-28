#! /bin/sh -e
# tup - A file-based build system
#
# Copyright (C) 2011-2021  Mike Shal <marfey@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# Make sure @(TUP_ARCH) has a default value, and can be overridden.

. ./tup.sh
cat > Tupfile << HERE
: |> echo @(TUP_ARCH) |>
HERE
parse

# Could validate other cpu architectures here if desired - not really necessary.
if uname -s | grep Linux > /dev/null; then
	arch=`uname -m`
	case $arch in
	i686)
		arch=i386 ;;
	esac
	tup_object_exist . "echo $arch"
	tup_dep_exist tup.config TUP_ARCH 0 .
fi

varsetall TUP_ARCH=bar
parse
tup_object_exist . 'echo bar'
tup_dep_exist tup.config TUP_ARCH 0 .
tup_object_no_exist . 'echo x86_64'
tup_object_no_exist . 'echo i386'

eotup
