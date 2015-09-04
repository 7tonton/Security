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



---------- Find and Sniff Network ----------

# find the network that we want
airodump-ng wlan1mon

# sniff and save packets
airodump-ng --bssid AB:7B:CD:5D:82:C2 --channel 1 --write Desktop/WPAcapture wlan1mon



---------- Deauth Attack ----------

# find the network that we want
airodump-ng wlan1mon

# sniff and save packets
airodump-ng --bssid F0:7B:CB:5D:75:C2 --channel 1 --write Desktop/WPAcapture wlan1mon
