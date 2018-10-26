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
 - (if virtualenv for python does not work properly you have to set selinux to permissive (do "/system/bin/setenforce 0" with root permissions))

Known issues:
 - borg starting at 1.1 requires the system call sync_file_range (see https://github.com/borgbackup/borg/pull/985 and https://github.com/borgbackup/borg/issues/1961). The linux subsystem in Windows 10 and some older Android versions (for example Lineage including 14.1) do not yet have this. Lineage 15.0 has this call and should work. I have added a test to the build script that checks if sync_file_range is available. If it is not, then I apply a patch (borg_sync_file_range.patch) that replaces this sync with convential file syncs.

Tested with:
- termux 0.56
- borg 1.0.12, 1.1.3

Tested and working so far is:
- creation of repositories 
- backup to repositories on the device
- backup up to remote repositories via ssh

Tested and working on devices:
- OnePlus 6 with stock Android 9 (aarch64)
- Huawei Nexus6p with stock Android 8.1.0 (angler, aarch64)
- Samsung Galaxy Note 2 with Lineage 14.1 (n7100, armv7l, Android 7.1.1)

Feedback on tests with other devices and android versions is very welcome.

Warning messages like 
````
WARNING: linker: /data/data/com.termux/files/usr/lib/libacl.so.1.1.0: unused DT entry: type 0xf arg 0x449
````
are due to the Android linker. More details can be found at https://stackoverflow.com/questions/33206409/unused-dt-entry-type-0x1d-arg.


So all in all my Android backup setup looks like:
- borg, termux and tasker
- termux: Task (https://f-droid.org/packages/com.termux.tasker/) for tasker integration
- tsu (modified so that it takes commands with -c): https://github.com/ravenschade/tsu
- .termux/tasker/backup.sh:
``` bash
#!/data/data/com.termux/files/usr/bin/bash
date
tsu -e -c "~/borgbackup_on_android/borg.sh"
date
read
```
- ~/borgbackup_on_android/borg.sh:
```bash
#!/data/data/com.termux/files/usr/bin/bash
t=`date +%d_%m_%Y`
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes
export BORG_RELOCATED_REPO_ACCESS_IS_OK=yes
host=angler
dirs="/ /system /vendor /cache /persist /firmware /storage /data"
export BORG_RSH=borg_ssh_wrapper
source /data/data/com.termux/files/home/borgbackup_on_android/borg-env/bin/activate
borg create -C lz4 -p -v --stats --one-file-system backup:/backup/borg/$host::$t $dirs # 2> ~/borg_backup_${t}.err
```
