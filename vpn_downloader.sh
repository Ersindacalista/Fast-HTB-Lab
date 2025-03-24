#!/bin/bash

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

# Richiedi all'utente l'API key
echo -n "Inserisci la tua API key: "
read appkey

# Mostra il menu dei server VPN
echo "Seleziona un server VPN:"
select VPN_NAME in "${!VPN_SERVERS[@]}"; do
    if [[ -n "$VPN_NAME" ]]; then
        VPN_SERVER_ID="${VPN_SERVERS[$VPN_NAME]}"
        break
    else
        echo "Selezione non valida. Riprova."
    fi
done

# Switch del server VPN
echo "Cambio del server VPN in $VPN_NAME (ID: $VPN_SERVER_ID)..."
response=$(curl -s --location --request POST "https://labs.hackthebox.com/api/v4/connections/servers/switch/$VPN_SERVER_ID" \
    -H "Authorization: Bearer $appkey")

# Stampa la risposta formattata
echo "Risposta ricevuta:"
echo "$response" | jq

# Verifica se il campo "status" è true
status=$(echo "$response" | jq -r '.status')
if [ "$status" != "true" ]; then
    echo "Errore nello switch del server VPN: $(echo "$response" | jq -r '.message')"
    exit 1
fi

echo "Server VPN cambiato con successo."

# Scarica il file OVPN
echo "Scaricando il file OVPN..."
curl -s --location --request GET "https://labs.hackthebox.com/api/v4/access/ovpnfile/$VPN_SERVER_ID/0" \
    -H "Authorization: Bearer $appkey" -o lab-vpn.ovpn

echo "File OVPN scaricato: congig.ovpn"
