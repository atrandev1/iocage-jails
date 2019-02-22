#!/bin/zsh

echo "Iocage Jails Installation Script in FreeNAS 11.2-U2"
echo "Which jail you want to install?"
select ans in "plexpass" "sonarr" "radarr" "jackett"  "transmission" "Quit"; do
    case $ans in
        plexpass ) /bin/zsh ./plexmediaserver/install-plexpass.sh; break;;
        sonarr ) /bin/zsh ./install-sonarr.sh; break;;
        radarr ) /bin/zsh ./install-radarr.sh; break;;
	    jackett ) /bin/zsh ./install-jackett.sh; break;;
        transmission ) /bin/zsh ./install-transmission.sh; break;;
	    Quit ) exit;;
    esac
done
