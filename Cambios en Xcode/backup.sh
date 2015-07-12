
#!/bin/bash


# Backup
cp /Users/Manuel/Desktop/Info.plist /Users/Manuel/Desktop/Info.plist.bakup

sudo /usr/bin/sed -i .bak 's/XCiPhoneOSCodeSignContext/XCCodeSignContext/' /Users/Manuel/Desktop/Info.plist

