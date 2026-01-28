#!/bin/sh

echo "==============================="
echo "     LOCALHOST OSINT UI"
echo "==============================="
echo

printf "Enter localhost (example: localhost:3000): "
read TARGET

pause() {
    echo
    printf "Press Enter..."
    read _
}

http_headers() {
    echo "[+] HTTP headers from http://$TARGET"
    curl -I -s "http://$TARGET" 2>/dev/null || echo "No HTTP response"
}

http_body() {
    echo "[+] HTTP response (first lines)"
    curl -s "http://$TARGET" 2>/dev/null | head -n 20
}

port_check() {
    PORT=$(echo "$TARGET" | sed 's/.*://')
    echo "[+] Checking port $PORT (via HTTP connect)"
    curl -s --connect-timeout 2 "http://$TARGET" >/dev/null \
        && echo "Port $PORT: OPEN (HTTP)" \
        || echo "Port $PORT: CLOSED or not HTTP"
}

while true
do
    echo
    echo "Target: $TARGET"
    echo
    echo "1) Check HTTP headers"
    echo "2) View HTTP response"
    echo "3) Check port status"
    echo "0) Exit"
    echo
menu() {
    clear
    echo "Target: $TARGET"
    echo
    echo "1) Check HTTP headers"
    echo "2) View HTTP response"
    echo "3) Check port status"
    echo "0) Exit"
    echo
