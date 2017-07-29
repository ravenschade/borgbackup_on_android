# borgbackup on android
This project provides build scripts to compile borgbackup (https://github.com/borgbackup/borg) and its dependencies on Android. It uses termux (https://termux.com/) as a lightweight environment. 

Yoou don't root permission on your phone to use it. However without root permissions the access to data of other apps or system data is not possible, but you can still access your photos, videos,...

If you have root permission on your device, you can use tsu (https://github.com/cswl/tsu) to conveniently gain root permissions in termux and backup you complete device.

How to use:
 - install termux from F-Droid or Google Play (https://termux.com/)
 - open app
 - run "apt update; apt install git"
 - run "git clone https://github.com/ravenschade/borgbackup_on_android.git"
 - run "cd borgbackup_on_android; bash build.sh"

Tested with:
- termux 0.53
- borg 1.0.12

Tested and working so far is:
- creation of repositories 
- backup to repositories on the device
- backup up to remote repositories via ssh

Tested and working on devices:
- Huawei Nexus6p with stock Android 7.1.2 (angler, aarch64)
- Samsung Galaxy Note 2 with Lineage 14.1 (n7100, armv7l)

Feedback on tests with other devices and android versions is very welcome.
