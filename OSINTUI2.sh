#!/bin/sh

clear
echo "==============================="
echo "     LOCALHOST OSINT UI"
echo "==============================="
echo

printf "Enter localhost (example: localhost:8080): "
read TARGET

HOST=$(echo "$TARGET" | cut -d: -f1)
PORT=$(echo "$TARGET" | cut -d: -f2)

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
    echo "[+] HTTP response body (first lines)"
    curl -s "http://$TARGET" | head -n 20
}

port_check() {
    echo "[+] Checking port $PORT on $HOST"
    (echo >/dev/tcp/$HOST/$PORT) >/dev/null 2>&1 \
        && echo "Port $PORT: OPEN" \
        || echo "Port $PORT: CLOSED or unavailable"
}

menu() {
    clear
    echo "Target: $TARGET"
    echo
    echo "1) Check HTTP headers"
    echo "2) View HTTP response"
    echo "3) Check port status"
    echo "0) Exit"
    echo
