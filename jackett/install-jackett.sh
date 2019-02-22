#!/bin/zsh
## This script will install iocage jackett jail

# configure jackett's IP address & gateway
echo "Enter the jackett's IP address: "
read jackettip
echo "You entered $jackettip"
sleep 1
echo "Enter the default gateway of your network: "
read gwip
echo "You entered $gwip"
sleep 1
#
echo '{"pkgs":["nano","mono","curl"]}' > /tmp/pkg.json
iocage create -n "jackett" -p /tmp/pkg.json -r 11.2-RELEASE ip4_addr="vnet0|$jackettip/24" defaultrouter=$gwip vnet="on" allow_raw_sockets="1" boot="on"
rm -f /tmp/pkg.json
#
iocage exec jackett ln -s /usr/local/bin/mono /usr/bin/mono
iocage exec jackett "fetch https://github.com/Jackett/Jackett/releases/download/v0.10.805/Jackett.Binaries.Mono.tar.gz -o /usr/local/share"
iocage exec jackett "tar xf /usr/local/share/Jackett.Binaries.Mono.tar.gz -C /usr/local/share"
iocage exec jackett rm -f /usr/local/share/Jackett.Binaries.Mono.tar.gz

iocage exec jackett "pw user add jackett -c jackett -u 818 -d /nonexistent -s /usr/bin/nologin"
iocage exec jackett chown -R jackett:jackett /usr/local/share/Jackett /config
iocage exec jackett mkdir /usr/local/etc/rc.d
# Add script
cp jackett /mnt/data/iocage/jails/jackett/root/usr/local/etc/rc.d/jackett
#
iocage exec jackett chmod u+x /usr/local/etc/rc.d/jackett
iocage exec jackett sysrc "jackett_enable=YES"
iocage exec jackett service jackett start