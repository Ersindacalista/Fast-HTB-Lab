#!/bin/bash

# Define VPN servers
declare -A VPN_SERVERS=(
    ["EU Starting Point 1"]="412"
    ["US Starting Point 1"]="414"
    ["EU Free 1"]="1"
    ["EU Free 2"]="201"
    ["EU Free 3"]="253"
    ["US Free 1"]="113"
    ["US Free 2"]="202"
    ["US Free 3"]="254"
    ["AU Free 1"]="177"
    ["SG Free 1"]="251"
)

# Prompt user for API key
echo -n "Enter your API key: "
read appkey

# Display VPN server menu
echo "Select a VPN server:"
select VPN_NAME in "${!VPN_SERVERS[@]}"; do
    if [[ -n "$VPN_NAME" ]]; then
        VPN_SERVER_ID="${VPN_SERVERS[$VPN_NAME]}"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Switch VPN server
echo "Switching VPN server to $VPN_NAME (ID: $VPN_SERVER_ID)..."
response=$(curl -s --location --request POST "https://labs.hackthebox.com/api/v4/connections/servers/switch/$VPN_SERVER_ID" \
    -H "Authorization: Bearer $appkey")

# Display the response
echo "Response received:"
echo "$response" | jq

# Check if the switch was successful
status=$(echo "$response" | jq -r '.status')
if [ "$status" != "true" ]; then
    echo "Error switching VPN server: $(echo "$response" | jq -r '.message')"
    exit 1
fi

echo "VPN server switched successfully."

# Download the OVPN file
echo "Downloading OVPN file..."
curl -s --location --request GET "https://labs.hackthebox.com/api/v4/access/ovpnfile/$VPN_SERVER_ID/0" \
    -H "Authorization: Bearer $appkey" -o config.ovpn

echo "OVPN file downloaded: config.ovpn"
