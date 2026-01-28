#!/bin/sh

TARGET="127.0.0.1"

banner() {
    echo "==============================="
    echo "   LOCALHOST OSINT UI"
    echo "   Passive system inspection"
    echo "==============================="
}

pause() {
    echo
    printf "Press Enter..."
    read _
}

http_check() {
    echo "[+] HTTP check on localhost"
    curl -I -s http://$TARGET 2>/dev/null || echo "No HTTP service"
}

common_ports() {
    echo "[+] Common localhost ports"
    for p in 80 443 3000 5000 8000 8080 9000; do
        (echo >/dev/tcp/$TARGET/$p) >/dev/null 2>&1 \
        && echo "Port $p: OPEN" \
        || echo "Port $p: closed"
    done
}

listening_ports() {
    echo "[+] Listening ports"
    if command -v ss >/dev/null 2>&1; then
        ss -ltn
    elif command -v netstat >/dev/null 2>&1; then
        netstat -ltn
    elif [ -r /proc/net/tcp ]; then
        cat /proc/net/tcp
    else
        echo "No port listing method available"
    fi
}

processes() {
    echo "[+] Running processes (limited view)"
    ps 2>/dev/null || echo "ps not available"
}

system_info() {
    echo "[+] System info"
    uname -a 2>/dev/null
    echo
    echo "[+] Uptime"
    cat /proc/uptime 2>/dev/null
}

menu() {
    clear
    banner
    echo
    echo "Target: localhost (127.0.0.1)"
    echo
    echo "1) HTTP service check"
    echo "2) Common ports probe"
    echo "3) Listening ports"
    echo "4) Running processes"
    echo "5) System info"
    echo "0) Exit"
    echo
    printf "> "
    read OPT

    case "$OPT" in
        1) http_check ;;
        2) common_ports ;;
        3) listening_ports ;;
        4) processes ;;
        5) system_info ;;
        0) exit 0 ;;
        *) echo "Invalid option" ;;
    esac

    pause
}

while true; do
    menu
done
