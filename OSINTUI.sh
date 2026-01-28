#!/usr/bin/env bash

clear

BANNER() {
    echo "===================================="
    echo "        OSINT WEB UI (Shell)"
    echo "   Passive intelligence for websites"
    echo "===================================="
}

PAUSE() {
    echo
    read -p "Press Enter to continue..."
}

NORMALIZE_DOMAIN() {
    DOMAIN=$(echo "$TARGET" | sed 's~http[s]*://~~' | sed 's~/.*~~')
}

GET_IP() {
    NORMALIZE_DOMAIN
    echo "[+] Resolving IP for $DOMAIN"
    dig +short "$DOMAIN" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}'
}

DNS_INFO() {
    NORMALIZE_DOMAIN
    echo "[+] DNS records for $DOMAIN"
    dig "$DOMAIN" ANY +noall +answer
}

HEADERS() {
    echo "[+] HTTP headers"
    curl -I -L -s "$TARGET"
}

WHOIS_INFO() {
    NORMALIZE_DOMAIN
    echo "[+] Whois info"
    whois "$DOMAIN" | head -n 60
}

GEOIP() {
    IP=$(GET_IP | head -n 1)
    if [ -z "$IP" ]; then
        echo "No IP found"
        return
    fi
    echo "[+] Geolocation for $IP"
    curl -s "http://ip-api.com/json/$IP?fields=country,regionName,city,isp,org,as"
}

COMMON_PORTS() {
    IP=$(GET_IP | head -n 1)
    if [ -z "$IP" ]; then
        echo "No IP found"
        return
    fi

    echo "[+] Checking common ports (80,443)"
    for PORT in 80 443; do
        timeout 2 bash -c "echo > /dev/tcp/$IP/$PORT" 2>/dev/null \
            && echo "Port $PORT: OPEN" \
            || echo "Port $PORT: CLOSED"
    done
}

MENU() {
    clear
    BANNER
    echo
    echo "Target: $TARGET"
    echo
    echo "1) Resolve IP"
    echo "2) DNS information"
    echo "3) HTTP headers"
    echo "4) Whois"
    echo "5) IP geolocation"
    echo "6) Common ports"
    echo "0) Exit"
    echo
    read -p "Select option: " OPT

    case $OPT in
        1) GET_IP ;;
        2) DNS_INFO ;;
        3) HEADERS ;;
        4) WHOIS_INFO ;;
        5) GEOIP ;;
        6) COMMON_PORTS ;;
        0) exit 0 ;;
        *) echo "Invalid option" ;;
    esac

    PAUSE
}

BANNER
echo
read -p "Enter website (https://example.com): " TARGET

while true; do
    MENU
done
