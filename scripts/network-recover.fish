#!/usr/bin/env fish

# Recover the desktop's RTL8126 Ethernet connection and keep 5 Gb/s out of
# auto-negotiation. The 2.5 Gb/s advertisement bit plus the slower modes is
# 0x80000000002f.

set -l interface eth0
if test (count $argv) -ge 1
    set interface $argv[1]
end

if test (id -u) -ne 0
    exec sudo (status filename) $argv
end

if not test -e "/sys/class/net/$interface"
    echo "Interface $interface does not exist." >&2
    exit 1
end

echo "Cycling $interface and limiting auto-negotiation to 2.5 Gb/s or slower..."
ip link set dev $interface down
ethtool -s $interface autoneg on advertise 0x80000000002f
ip link set dev $interface up

echo "Waiting for carrier..."
set -l carrier_up false
for attempt in (seq 1 15)
    if test (cat "/sys/class/net/$interface/carrier" 2>/dev/null) = 1
        set carrier_up true
        break
    end
    sleep 1
end

if test $carrier_up != true
    echo "No carrier detected after 15 seconds. Check the cable and router port." >&2
    ethtool $interface
    exit 1
end

networkctl reconfigure $interface
networkctl renew $interface

echo
ethtool $interface | string match -r '^\s*(Advertised link modes:|Speed:|Duplex:|Link detected:).*'
echo
echo "Testing the local gateway..."
ping -c 20 -W 2 192.168.1.254
