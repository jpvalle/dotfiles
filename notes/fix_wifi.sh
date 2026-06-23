# ==============================================================================
# MAC WIF-FI / CISCO VPN STUCK ROUTE REPAIR SCRIPT
# ==============================================================================
# Run this script if your internet disconnects after a Cisco VPN crash and 
# gives you a "No route to host" error. 
#
# USAGE: sudo bash fix_wifi.sh
# ==============================================================================

echo "----------------------------------------------------------------------"
echo "1 Go to: System Settings > General > Login Items & Extensions"
echo "2 Scroll down to Network Extensions, click (i), and toggle Cisco."
echo "3 Go to: System Settings > Network > [...] > Locations"
echo "4 Switch profile and click 'Apply'."
echo "Rember to undo this before attempting to reenable Cisco"
echo "----------------------------------------------------------------------"


# Stuff that didn't quite work but might have helped
sudo ipconfig set en0 DHCP
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

# Where things really popped off

# 1. Kill Cisco AnyConnect interface processes
echo "Stopping stuck Cisco processes..."
sudo launchctl unload /Library/LaunchDaemons/com.cisco.anyconnect.vpnagentd.plist

# 2. Kill the virtual network tunnel if it exists
echo "Dropping leftover tunnel interfaces..."
ifconfig -u | grep utun
# for each leftover utun
exit
sudo ifconfig utunX down

ping -c 4 8.8.8.8
# reenable it when the wifi is fixed
sudo launchctl bootstrap system  /Library/LaunchDaemons/com.cisco.anyconnect.vpnagentd.plist


# Random other stuff
exit
# 3. Flush the corrupted routing tables left by the VPN
echo "Flushing system routing tables..."
route -n flush
route -n flush

# 4. Cycle the physical Wi-Fi card (assumes en0 interface)
echo "Resetting hardware Wi-Fi card (en0)..."
ifconfig en0 down
sleep 2
ifconfig en0 up

# 5. Flush the system DNS cache
echo "Clearing DNS cache..."
dscacheutil -flushcache
killall -HUP mDNSResponder

# 6. Run a quick connection test
echo "Testing connection to Google DNS (8.8.8.8)..."
sleep 3
ping -c 2 8.8.8.8

