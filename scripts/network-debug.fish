#!/usr/bin/env fish

# Capture network state while the failure is happening. This script only reads
# system state; it does not restart or reconfigure the network.

set -l output_dir "$HOME/network-debug-logs"
mkdir -p "$output_dir"

set -l timestamp (date +%Y%m%d-%H%M%S)
set -l log_file "$output_dir/network-debug-$timestamp.log"

begin
    echo "Network diagnostic capture"
    echo "Captured: "(date --iso-8601=seconds)
    echo "Host: "(hostname)
    echo "Kernel: "(uname -r)
    echo "Boot ID: "(cat /proc/sys/kernel/random/boot_id)

    echo
    echo "===== Gateway connectivity ====="
    ping -c 3 -W 2 192.168.1.254

    echo
    echo "===== Direct internet connectivity ====="
    ping -c 3 -W 2 1.1.1.1

    echo
    echo "===== DNS resolution ====="
    resolvectl query example.com

    echo
    echo "===== Resolver status ====="
    resolvectl status

    echo
    echo "===== Addresses ====="
    ip -details address show

    echo
    echo "===== Routes ====="
    ip -details route show table all

    echo
    echo "===== Ethernet counters ====="
    ip -statistics -statistics link show enp7s0

    echo
    echo "===== Neighbor table ====="
    ip neigh show dev enp7s0

    echo
    echo "===== networkd status ====="
    networkctl status enp7s0 --no-pager

    echo
    echo "===== Generated network configuration ====="
    echo "--- /etc/systemd/network/10-wired.network"
    sed -n '1,200p' /etc/systemd/network/10-wired.network
    echo "--- /etc/systemd/resolved.conf"
    sed -n '1,200p' /etc/systemd/resolved.conf
    echo "--- /etc/resolv.conf target"
    readlink -f /etc/resolv.conf
    sed -n '1,100p' /etc/resolv.conf

    echo
    echo "===== Current boot network journal ====="
    journalctl -b --no-pager -o short-monotonic | grep -Ei \
        'r8169|rtl8126|enp7s0|networkd|resolved|dhcp|dns|carrier|watchdog|timeout|reset|unreachable|no route|packet|firmware'

    echo
    echo "===== Failed units ====="
    systemctl --failed --no-pager
end 2>&1 | tee "$log_file"

echo
echo "Saved diagnostic log to: $log_file"
