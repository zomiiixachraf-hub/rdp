#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║        ASHRAF SERVER - PRO CLOUD EDITION (IDX & FIREBASE STUDIO)         ║
# ║        Merged UI with Stealth Proxy Core                                 ║
# ╚══════════════════════════════════════════════════════════════════════════╝

# --- COLORS THEME ---
R="\e[1;31m"  # Bright Red
G="\e[1;32m"  # Green
Y="\e[1;33m"  # Yellow
B="\e[1;34m"  # Blue
C="\e[1;36m"  # Cyan
M="\e[1;35m"  # Magenta
W="\e[1;37m"  # White
N="\e[0m"     # Reset

# --- DIRECTORIES ---
DIR="$HOME/.lokmane"
USERS_DB="$DIR/users.db"
mkdir -p "$DIR"
touch "$USERS_DB"

# --- UI FUNCTIONS ---
print_ashraf_logo() {
    echo -e "\n${C}╔════════════════════════════════════════════════════════════════════════════╗${N}"
    echo -e "${C}║${R}      █████╗ ███████╗██╗  ██╗██████╗  █████╗ ███████╗                     ${C}║${N}"
    echo -e "${C}║${R}     ██╔══██╗██╔════╝██║  ██║██╔══██╗██╔══██╗██╔════╝                     ${C}║${N}"
    echo -e "${C}║${R}     ███████║███████╗███████║██████╔╝███████║█████╗                       ${C}║${N}"
    echo -e "${C}║${R}     ██╔══██║╚════██║██╔══██║██╔══██╗██╔══██║██╔══╝                       ${C}║${N}"
    echo -e "${C}║${R}     ██║  ██║███████║██║  ██║██║  ██║██║  ██║██║                           ${C}║${N}"
    echo -e "${C}║${R}     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝                           ${C}║${N}"
    echo -e "${C}║${Y}                      P R O X Y   N E T W O R K                          ${C}║${N}"
    echo -e "${C}╚════════════════════════════════════════════════════════════════════════════╝${N}"
    echo -e "${W}                       Developed by Achraf Lokmane                       ${N}\n"
}

print_header() {
    clear
    print_ashraf_logo
    echo -e "${C}══════════════════════════════════════════════════════════════════════════════${N}"
    echo -e "${W}                  CLOUD DEVELOPMENT & PROXY CONSOLE                  ${N}"
    echo -e "${C}══════════════════════════════════════════════════════════════════════════════${N}\n"
}

print_option() {
    local num="$1"
    local text="$2"
    local color="$3"
    echo -e "  ${color}╔═════════════════════════════════════════════════════════════════════╗${N}"
    echo -e "  ${color}║${W}  [${Y}$num${W}]  ${G}$text$(printf '%*s' $((47 - ${#text})))${color}║${N}"
    echo -e "  ${color}╚═════════════════════════════════════════════════════════════════════╝${N}\n"
}

print_status() {
    local text="$1"
    local color="$2"
    echo -e "\n${Y}▶▶${color} ${text}${N}\n"
}

print_footer() {
    echo -e "${C}┌────────────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${W}             ASHRAF NETWORK © 2026 - All Rights Reserved                  ${C}│${N}"
    echo -e "${C}└────────────────────────────────────────────────────────────────────────────┘${N}\n"
}

# --- CORE FUNCTIONS ---
create_proxy() {
    cat > "$DIR/proxy.py" << 'PROXY'
import socket, threading, time
def handle(client):
    try:
        ssh = socket.socket()
        ssh.connect(('127.0.0.1', 22))
        def fwd(src, dst):
            try:
                while True:
                    d = src.recv(8192)
                    if not d: break
                    dst.sendall(d)
            except: pass
        threading.Thread(target=fwd, args=(client, ssh), daemon=True).start()
        fwd(ssh, client)
    except: pass
    finally: client.close()

sock = socket.socket()
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.bind(('0.0.0.0', 8080))
sock.listen(100)
while True:
    c, a = sock.accept()
    threading.Thread(target=handle, args=(c,), daemon=True).start()
PROXY
    nohup python3 "$DIR/proxy.py" > /dev/null 2>&1 &
}

anti_idle() {
    cat > "$DIR/keep_alive.py" << 'ALIVE'
import time, requests
while True:
    try: requests.get("http://localhost:8080")
    except: pass
    time.sleep(30)
ALIVE
    nohup python3 "$DIR/keep_alive.py" > /dev/null 2>&1 &
}

install_core() {
    print_status "Installing Stealth Components..." "$C"
    sudo apt-get update -qq && sudo apt-get install -y openssh-server python3 curl > /dev/null 2>&1
    echo "$(whoami):123456" | sudo chpasswd
    sudo sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config 2>/dev/null || true
    sudo sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config 2>/dev/null || true
    sudo systemctl restart ssh 2>/dev/null || sudo service ssh restart 2>/dev/null
    
    pkill -f proxy.py 2>/dev/null
    pkill -f keep_alive.py 2>/dev/null
    
    create_proxy
    anti_idle
    echo -e "${G}✅ Core Services (Proxy + SSH + Anti-Idle) Installed & Running!${N}"
    sleep 3
}

# --- MAIN MENU LOOP ---
while true; do
    print_header
    
    echo -e "${C}╔════════════════════════════════════════════════════════════════════════════╗${N}"
    echo -e "${C}║${Y}                            MAIN OPTIONS                                    ${C}║${N}"
    echo -e "${C}╚════════════════════════════════════════════════════════════════════════════╝${N}\n"
    
    print_option "1" "🚀 Install / Restart Stealth Proxy" "$C"
    print_option "2" "👤 Add New SSH User" "$C"
    print_option "3" "📋 List Active Users" "$C"
    print_option "4" "🔗 Display Connection Instructions" "$C"
    print_option "5" "❌ Exit Console" "$R"

    echo -ne "${Y}▶▶${W} Select Option [${R}1-5${W}] : ${G}"
    read op
    echo -ne "${N}"
    
    case $op in
    1)
        clear
        print_ashraf_logo
        install_core
        ;;
    2)
        clear
        print_ashraf_logo
        print_status "ADD NEW SSH USER" "$C"
        echo -ne "${Y}  ▶ Username: ${W}"; read u
        echo -ne "${Y}  ▶ Password: ${W}"; read p
        if [ -n "$u" ] && [ -n "$p" ]; then
            sudo useradd -m -s /bin/bash "$u" 2>/dev/null
            echo "$u:$p" | sudo chpasswd
            echo "$u|$p" >> "$USERS_DB"
            echo -e "\n${G}✅ User [$u] created successfully!${N}"
        else
            echo -e "\n${R}❌ Invalid input.${N}"
        fi
        sleep 2
        ;;
    3)
        clear
        print_ashraf_logo
        print_status "REGISTERED USERS" "$C"
        if [ -s "$USERS_DB" ]; then
            printf "  ${C}%-20s %-20s${N}\n" "USERNAME" "PASSWORD"
            echo -e "  ${W}────────────────────────────────────────${N}"
            while IFS='|' read -r u p; do
                printf "  ${G}%-20s ${Y}%-20s${N}\n" "$u" "$p"
            done < "$USERS_DB"
        else
            echo -e "  ${R}No users found.${N}"
        fi
        echo -ne "\n${Y}▶▶ Press Enter to return...${N}"; read
        ;;
    4)
        clear
        print_ashraf_logo
        print_status "CONNECTION INSTRUCTIONS" "$C"
        echo -e "${W}To connect via HTTP Custom / NapsternetV / v2rayNG:${N}\n"
        echo -e "  ${G}1.${W} Go to the 'Ports' tab in your Cloud Workspace (IDX/Firebase)."
        echo -e "  ${G}2.${W} Make Port ${Y}8080${W} ${C}PUBLIC${W}."
        echo -e "  ${G}3.${W} Copy the generated URL (e.g., ${C}your-workspace.dev${W})."
        echo -e "  ${G}4.${W} Use the copied URL as your Server / SNI."
        echo -e "  ${G}5.${W} Use Port ${Y}443${W}."
        echo -e "  ${G}6.${W} Use the credentials you created in Option 2 (or default: $(whoami) / 123456)."
        echo -ne "\n${Y}▶▶ Press Enter to return...${N}"; read
        ;;
    5)
        clear
        print_ashraf_logo
        echo -e "${C}══════════════════════════════════════════════════════════════════════════════${N}"
        echo -e "${W}                     SESSION SECURELY TERMINATED                     ${N}"
        echo -e "${C}══════════════════════════════════════════════════════════════════════════════${N}\n"
        print_footer
        exit 0
        ;;
    *)
        echo -e "\n${R}❌ INVALID OPTION! Please choose between 1-5.${N}"
        sleep 2
        ;;
    esac
done