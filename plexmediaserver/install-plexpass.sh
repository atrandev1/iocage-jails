#!/bin/zsh
## This script will install plexmedia_plexpass

# configure plexserver's IP address & gateway
echo "Enter the plexserver's IP Address: "
read plexip
echo "You entered $plexip"
sleep 1
echo "Enter the default gateway of your network: "
read gwip
echo "You entered $gwip"
sleep 1
echo '{"pkgs":["plexmediaserver-plexpass","nano","wget","curl","ca_root_nss"]}' > /tmp/pkg.json
iocage create -n "plexpass" -p /tmp/pkg.json -r 11.2-RELEASE ip4_addr="vnet0|$plexip/24" defaultrouter=$gwip vnet="on" allow_raw_sockets="1" boot="on"
rm -f /tmp/pkg.json
iocage exec plexpass mkdir /config
iocage fstab -a plexpass /mnt/data/apps/plexpass /config nullfs rw 0 0
# create mount points
iocage exec plexpass mkdir /mnt/{animated,horrors,marvels,movies,tvshows,dceu,vnlt,asiandrama}
# mount media drives
iocage fstab -a plexpass /mnt/data/plexmedia/animated /mnt/animated nullfs ro 0 0
iocage fstab -a plexpass /mnt/data/plexmedia/horrors /mnt/horrors nullfs ro 0 0
iocage fstab -a plexpass /mnt/data/plexmedia/marvels /mnt/marvels nullfs ro 0 0
iocage fstab -a plexpass /mnt/data/plexmedia/movies /mnt/movies nullfs ro 0 0
iocage fstab -a plexpass /mnt/data/plexmedia/tvshows /mnt/tvshows nullfs ro 0 0
iocage fstab -a plexpass /mnt/data/plexmedia/dceu /mnt/dceu nullfs ro 0 0
iocage fstab -a plexpass /mnt/data/plexmedia/vnlt /mnt/vnlt nullfs ro 0 0
iocage fstab -a plexpass /mnt/data/plexmedia/asiandrama /mnt/asiandrama nullfs ro 0 0
# autostart plexpass service
iocage exec plexpass chown -R plex:plex /config
iocage exec plexpass sysrc "plexmediaserver_plexpass_enable=YES"
iocage exec plexpass sysrc plexmediaserver_plexpass_support_path="/config"
iocage exec plexpass service plexmediaserver_plexpass start
#
echo "The site is located @ $plexip:32400/web"