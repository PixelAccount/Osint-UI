#!/bin/sh

clear

banner() {
    echo "==============================="
    echo "      OSINT WEB MINI UI"
    echo "   Portable • Passive • Simple"
    echo "==============================="
}

pause() {
    echo
    printf "Press Enter to continue..."
    read _
}

normalize_domain() {
    DOMAIN=$(echo "$TARGET" | sed 's~http[s]*://~~; s~/.*~~')
}

resolve_ip() {
    normalize_domain
    echo "[+] Resolving IP (via DNS over HTTP)"
    curl -s "https://dns.google/resolve?name=$DOMAIN&type=A" \
    | grep -o '"data":"[^"]*"' \
    | sed 's/"data":"//;s/"//'
}

http_headers() {
    echo "[+] HTTP headers"
    curl -I -L -s "$TARGET"
}

server_info() {
    echo "[+] Server & technology hints"
    curl -I -s "$TARGET" | grep -iE "server:|x-powered-by:"
}

geoip() {
    IP=$(resolve_ip | head -n 1)
    if [ -z "$IP" ]; then
        echo "No IP found"
        return
    fi
    echo "[+] IP geolocation"
    curl -s "http://ip-api.com/json/$IP" \
    | sed 's/[{},]/\n/g'
}

menu() {
    clear
    banner
    echo
    echo "Target: $TARGET"
    echo
    echo "1) Resolve IP"
    echo "2) HTTP headers"
    echo "3) Server info"
    echo "4) IP geolocation"
    echo "0) Exit"
    echo
    printf "Option: "
    read OPT

    case "$OPT" in
        1) resolve_ip ;;
        2) http_headers ;;
        3) server_info ;;
        4) geoip ;;
        0) exit 0 ;;
        *) echo "Invalid option" ;;
    esac

    pause
}

banner
echo
printf "Enter website (https://example.com): "
read TARGET

while true; do
    menu
done
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
