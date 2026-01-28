#!/bin/sh

echo "==============================="
echo "     LOCALHOST OSINT UI"
echo "==============================="
echo

printf "Enter localhost (example: localhost:3000): "
read TARGET

while true
do
    echo
    echo "Target: $TARGET"
    echo
    echo "1) HTTP headers"
    echo "2) HTTP response (first lines)"
    echo "3) Check port (HTTP)"
    echo "0) Exit"
    echo
    printf "> "
    read OPT

    if [ "$OPT" = "1" ]; then
        echo "[+] HTTP headers"
        curl -I -s "http://$TARGET" 2>/dev/null || echo "No HTTP response"
        printf "\nPress Enter..."
        read _
    elif [ "$OPT" = "2" ]; then
        echo "[+] HTTP response"
        curl -s "http://$TARGET" 2>/dev/null | head -n 20
        printf "\nPress Enter..."
        read _
    elif [ "$OPT" = "3" ]; then
        PORT=$(echo "$TARGET" | sed 's/.*://')
        echo "[+] Checking port $PORT"
        curl -s --connect-timeout 2 "http://$TARGET" >/dev/null \
            && echo "Port $PORT: OPEN (HTTP)" \
            || echo "Port $PORT: CLOSED or not HTTP"
        printf "\nPress Enter..."
        read _
    elif [ "$OPT" = "0" ]; then
        exit 0
    else
        echo "Invalid option"
        printf "\nPress Enter..."
        read _
    fi
done    echo
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
