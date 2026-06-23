

# Stuff that didn't quite work but might have helped
sudo ipconfig set en0 DHCP
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

# Where things really popped off
# disable cisco completely
sudo launchctl unload /Library/LaunchDaemons/com.cisco.anyconnect.vpnagentd.plist
ifconfig -u | grep utun
# for each leftover utun
sudo ifconfig utunX down
ping -c 4 8.8.8.8
# reenable it when the wifi is fixed
sudo launchctl bootstrap system  /Library/LaunchDaemons/com.cisco.anyconnect.vpnagentd.plist
