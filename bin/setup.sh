#!/bin/sh
# Copyright (c) 2009 The Open Source Geospatial Foundation.
# Licensed under the GNU LGPL.
# 
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 2.1 of the License,
# or any later version.  This library is distributed in the hope that
# it will be useful, but WITHOUT ANY WARRANTY, without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Lesser General Public License for more details, either
# in the "LICENSE.LGPL.txt" file distributed with this software or at
# web page "http://www.fsf.org/licenses/lgpl.html".

# About:
# =====
# This script will take a raw Xubuntu system and update it ready to run
# GISVM install scripts.

# Running:
# =======
# sudo ./setup.sh

if [ "`uname -m`" != "i686" ] ; then
   echo "WARNING: Current system is not i686; any binaries built may be tied to current system (`uname -m`)"
fi
# look for ./configure --build=BUILD, --host=HOST, --target=TARGET  to try and force build for i686.
# For .deb package building something like: 'debuild binary-arch i686' ???????


# Install some useful stuff
apt-get install --yes wget more less zip unzip bzip2 p7zip \
  cvs cvsutils subversion subversion-tools bzr bzr-tools git mercurial \
  openssh-client lftp sl smbclient usbutils wireless-tools \
  locate diff patch fuseiso menu \
  vim emacs nedit nano \
  evince ghostscript a2ps pdftk netpbm qiv \
  lynx mutt mc xchat rxvt units

# Install build stuff (temporarily?)
apt-get install --yes gcc build-essential devscripts pbuilder fakeroot \
  cvs-buildpackage svn-buildpackage lintian debhelper pkg-config


# Uninstall default applications
apt-get remove --yes gnome-games

# Remove unused home directories
rm -fr /home/user/Documents
rm -fr /home/user/Music
rm -fr /home/user/Pictures
rm -fr /home/user/Templates
rm -fr /home/user/Videos

# Show packages hogging the most space on the disc:
# dpkg-query --show --showformat='${Package;-50}\t${Installed-Size}\n' \
#   | sort -k 2 -n | grep -v deinstall | \
#   awk '{printf "%.3f MB \t %s\n", $2/(1024), $1}'

# Default password list on the desktop to be replaced by html help in the future.
wget -r https://svn.osgeo.org/osgeo/livedvd/gisvm/trunk/doc/passwords.txt \
   --output-document=/home/user/Desktop/passwords.txt
chown user:user /home/user/Desktop/passwords.txt

# Setup the desktop background
wget -r https://svn.osgeo.org/osgeo/livedvd/gisvm/trunk/desktop-conf/arramagong-desktop.bmp \
	--output-document=/usr/share/xfce4/backdrops/arramagong-desktop.bmp

xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor/image-path -s /usr/share/xfce4/backdrops/arramagong-desktop.bmp
