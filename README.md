🛡️ Termux ইথিক্যাল হ্যাকিং টুলকিট (All-in-One)



Termux-এর জন্য একটি শক্তিশালী, রঙিন ও অল-ইন-ওয়ান হ্যাকিং টুলকিট – শুধুমাত্র শিক্ষাগত উদ্দেশ্যে!

---

📖 ভূমিকা

Termux Ethical Hacking Toolkit হলো Termux-এর জন্য তৈরি একটি সম্পূর্ণ Bash স্ক্রিপ্ট, যেখানে রয়েছে:

· ইনফরমেশন গাদারিং (Whois, DNS, জিওলোকেশন, সাবডোমেইন)
· নেটওয়ার্ক স্ক্যানিং (Ping Sweep, পোর্ট স্ক্যান, OS ডিটেকশন)
· ব্রুটফোর্স (SSH, FTP – Hydra)
· ওয়েব টুলস (Gobuster, SQLmap, Nikto, WhatWeb)
· অ্যানোনিমিটি (Tor + Proxychains)
· শিক্ষামূলক স্ট্রেস টেস্ট (HTTP/ICMP ফ্লাড)
· OSINT (Sherlock, Holehe, TheHarvester)
· পেলোড জেনারেটর (Android APK, Windows EXE, Python Reverse Shell)
· Wi-Fi ও LAN (ARP Scan, Wi-Fi Scan, Wifite)
· পাসওয়ার্ড ক্র্যাকিং (John the Ripper)
· সাবডোমেইন ও ফাজিং (Subfinder, FFUF, HTTPX)
· কাস্টম কমান্ড রানার (যেকোনো Termux কমান্ড)
· অটো রিপোর্ট (সব আউটপুট /sdcard/hack_reports/-এ সেভ হয়)

⚠️ সতর্কতা: এই টুলটি শুধুমাত্র শিক্ষাগত উদ্দেশ্যে এবং নিজের মালিকানাধীন নেটওয়ার্ক বা লিখিত অনুমতিপ্রাপ্ত সিস্টেমে ব্যবহারের জন্য। অননুমোদিত ব্যবহার আইনত দণ্ডনীয়। ব্যবহারকারী নিজেই সম্পূর্ণ দায়ী।

---

🔧 ইনস্টলেশন নির্দেশাবলী (Installation)

ধাপ ১: Termux সেটআপ

```bash
termux-setup-storage
```

ধাপ ২:

```bash
git clone https://github.com/device2331-beep/mehidi_tools.git
cd mehidi_tools
```

ধাপ ৩:

```bash
chmod +x mehidi_tools.sh
```

ধাপ ৪: স্ক্রিপ্ট রান করুন

```bash
./mehidi_tools.sh
```

প্রথমবার রান করলে:
স্ক্রিপ্ট স্বয়ংক্রিয়ভাবে সব প্রয়োজনীয় প্যাকেজ চেক করবে এবং অনুপস্থিত প্যাকেজ ইনস্টল করতে চাইবে – আপনি y চাপুন।
এরপর সব ডিপেন্ডেন্সি ইনস্টল হয়ে যাবে এবং আপনি মেনু দেখতে পাবেন।

---

📦 কী কী প্যাকেজ ইনস্টল হয়?

স্ক্রিপ্ট চালানোর সময় নিচের প্যাকেজগুলো অটো ইনস্টল হবে (যদি না থাকে):

```bash
nmap curl wget git python openssh hydra whois dnsutils tor proxychains-ng gobuster sqlmap nikto unzip arp-scan john ffuf subfinder httpx whatweb
```

Python প্যাকেজ (OSINT):

```bash
theharvester sherlock holehe
```

মেটাসপ্লোইট (msfvenom) আলাদা ইনস্টল করতে হবে:

```bash
pkg install metasploit -y
```

termux-api (Wi-Fi স্ক্যানের জন্য):

```bash
pkg install termux-api -y
```

---

🚀 কীভাবে ব্যবহার করবেন?

1. Termux-এ ./mehidi_tools.sh লিখে এন্টার দিন।
2. রঙিন মেনু দেখাবে – আপনার পছন্দের অপশন নম্বর টাইপ করুন।
3. প্রতিটি টুলের জন্য প্রয়োজনীয় ইনপুট (IP, URL, ইউজারনেম, ওয়ার্ডলিস্ট পাথ ইত্যাদি) দিন।
4. সব রিপোর্ট /sdcard/hack_reports/ ফোল্ডারে টাইমস্ট্যাম্পসহ সেভ হবে।
5. বের হতে চাইলে 0 চাপুন বা Ctrl+C প্রেস করুন।

💡 টিপ: প্রথমবার /sdcard/rockyou.txt ওয়ার্ডলিস্ট ডাউনলোড হবে (যদি না থাকে)। আপনার নিজের ওয়ার্ডলিস্ট ব্যবহার করতে চাইলে পাথ দিয়ে দিন।

---

🛠️ অতিরিক্ত টুলস ইনস্টল (Extra Tools)

মেনুতে অপশন 13 রয়েছে – যা Zphisher (ফিশিং), XSStrike (XSS স্ক্যানার) ও BeEF (ব্রাউজার এক্সপ্লয়েটেশন) ইনস্টল করে দেবে।
আপনি চাইলে ম্যানুয়ালিও করতে পারেন:

```bash
git clone https://github.com/htr-tech/zphisher.git
git clone https://github.com/s0md3v/XSStrike.git
git clone https://github.com/beefproject/beef.git
```

---

⚠️ দায়িত্ব অস্বীকার (Disclaimer)

এই টুলকিট শুধুমাত্র শিক্ষাগত উদ্দেশ্যে তৈরি করা হয়েছে।

· নিজের নেটওয়ার্ক বা লিখিত অনুমতিপ্রাপ্ত সিস্টেম ছাড়া এটি ব্যবহার করবেন না।
· যেকোনো ধরনের অননুমোদিত কার্যকলাপের জন্য ব্যবহারকারী নিজেই দায়ী।
· এই প্রকল্পের নির্মাতা বা কোনো অবদানকারী আইনগতভাবে দায়ী থাকবে না।

---

📬 যোগাযোগ ও সহায়তা

· কোনো সমস্যা বা পরামর্শ থাকলে GitHub Issues-এ জানান।
· Pull Request সবসময় স্বাগতম!

হ্যাপি হ্যাকিং (শুধু নৈতিকভাবে)! 😊

---

প্রকল্পটি পছন্দ হলে ⭐ দিতে ভুলবেন না!
