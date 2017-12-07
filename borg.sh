#!/data/data/com.termux/files/usr/bin/bash
t=`date +%d_%m_%Y`
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes
export BORG_RELOCATED_REPO_ACCESS_IS_OK=yes
host=angler
dirs="/ /system /vendor /cache /persist /firmware /storage /data"
export BORG_RSH=borg_ssh_wrapper
source /data/data/com.termux/files/home/borgbackup_on_android/borg-env/bin/activate
borg create -C lz4 -p -v --stats --one-file-system backup:/backup/borg/$host::$t $dirs # 2> ~/borg_backup_${t}.err
