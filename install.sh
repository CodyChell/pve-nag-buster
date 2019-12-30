#!/bin/bash

# pve-nag-buster (v02) https://github.com/foundObjects/pve-nag-buster
# Copyright (C) 2019 /u/seaQueue (reddit.com/u/seaQueue)
#
# Removes Proxmox VE 5.x license nags automatically after updates
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

RELEASE=$(awk -F"[)(]+" '/VERSION=/ {print $2}' /etc/os-release)

# create the pve-no-subscription list

echo "$0: Creating PVE no-subscription repo list ..."
cat <<EOF>"/etc/apt/sources.list.d/pve-no-subscription.list"
# .list file automatically generated by pve-nag-buster:$0 at $(date)
#
# If $0 is run again this file will likely be overwritten
#

deb http://download.proxmox.com/debian/pve $RELEASE pve-no-subscription
EOF

# create dpkg pre/post install hooks for persistence

cat <<'EOF' >/etc/apt/apt.conf.d/86pve-nags
DPkg::Pre-Install-Pkgs {
    "while read -r pkg; do case $pkg in *proxmox-widget-toolkit* | *pve-manager*) touch /tmp/.pve-nag-buster && exit 0; esac done < /dev/stdin";
};

DPkg::Post-Invoke {
    "[ -f /tmp/.pve-nag-buster ] && /usr/share/pve-nag-buster.sh && rm -f /tmp/.pve-nag-buster; exit 0";
};
EOF

# fetch the post-install patch script, patches license nag and switches to pve-no-subscription repository as needed

if true ; then
  wget https://raw.githubusercontent.com/foundObjects/pve-nag-buster/master/pve-nag-buster.sh \
      -O "/usr/share/pve-nag-buster.sh" && \
      chmod +x "/usr/share/pve-nag-buster.sh" && \
      /usr/share/pve-nag-buster.sh

  exit 0
fi

# this is the end, example offline code below

# Example code for inclusion into host provisioning scripts offline: this is just pve-nag-buster.sh
# run through "xz -z -9 -c pve-nag-buster.sh | base64" to avoid needing to fetch the script from github
# To use this installer offline just nuke the entire if block above.

# Important: if you're not me you should probably decode this and read it to make sure I'm not doing
#            something malicious like mining dogecoin or stealing your valuable cat pictures

# pve-nag-buster.sh (v02) inline:

# REMOVED BASE64 CODE

## YEET ##
