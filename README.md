# borgbackup on android
This project provides build scripts to compile borgbackup (https://github.com/borgbackup/borg) and its dependencies on Android. It uses termux (https://termux.com/) as a lightweight environment. 

Yoou don't root permission on your phone to use it. However without root permissions the access to data of other apps or system data is not possible, but you can still access your photos, videos,...

If you have root permission on your device, you can use tsu (https://github.com/cswl/tsu) to conveniently gain root permissions in termux and backup you complete device.

Tested so far is:

- creation of repositories 
- backup to repositories on the device
- backup up to remote repositories via ssh

Tested on devices:
- Huawei Nexus6p with stock Android 7.1.2 (angler, aarch64)
- Samsung Galaxy Note 2 with Lineage 14.1 (n7100, armv7l)

Feedback on tests with other devices and android versions is very welcome.
