#!/bin/bash
scripts_dir=/opt/easy-linux
hashcat -a 0 -m 22000 ${scripts_dir}/support <dictionary_file> -r /usr/share/wordlists/OneRuleToRuleThemAll.rule

hashcat -a 9 -m 2500 /opt/easy-linux/hcxdump_full.pcapng /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule -w 3 --deprecated-check-disable



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