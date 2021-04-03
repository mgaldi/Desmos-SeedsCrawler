#!/usr/bin/env bash
dump=$(curl -s $1)
ids=$(echo $dump | jq ' .result.peers[].node_info | .id ' | sed 's/"//g')
ips=$(echo $dump | jq ' .result.peers[] | .remote_ip ' | sed 's/"//g' )
ports=$(echo $dump | jq '.result.peers[].node_info | .listen_addr ' | grep -o '[^:]*$' | sed 's/"//g' )
ip_port=$(paste <(echo "$ips") <(echo "$ports") -d ':')
seeds=$(paste <(echo "$ids") <(echo "$ip_port") -d '@' | sed '$!s/$/,/' | tr -d '\r\n')
echo $seeds
