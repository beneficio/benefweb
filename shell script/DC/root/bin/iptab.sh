#!/bin/bash

# filtro de red

iptables -F

for i in 192.168.2.171 192.168.2.172
do
	iptables -A INPUT -p udp -s $i -j DROP
done

iptables -A INPUT -j ACCEPT
