#!/data/data/com.termux/files/usr/bin/bash
set -x
apt -y install make clang openssl-dev perl tsu wget git python python-dev gnupg dirmngr curl autoconf automake sed gettext gzip pkg-config libcrypt-dev


pip install virtualenv
virtualenv --python=python3 borg-env
source borg-env/bin/activate

git clone https://github.com/borgbackup/borg.git
cd borg
git branch 1.1-maint remotes/origin/1.1-maint
git checkout 1.1-maint

pip install -r requirements.d/development.txt

#find if sync_file_range is available
s=`bash ../sync_file_range_test/test.sh`
if [ "$s" = "1" ];
then
	echo "patching borg to not use sync_file_range...."
	git apply ../borg_sync_file_range.patch
else
	echo "no need to patch borg"
fi

#download and build lz4
wget https://github.com/lz4/lz4/archive/v1.7.5.tar.gz -O lz4.tar.gz
tar -xf lz4.tar.gz
cd lz4-1.7.5
make
make install
cd ..

#download and build libattr
wget https://download.savannah.gnu.org/releases/attr/attr-2.4.47.src.tar.gz
wget https://download.savannah.gnu.org/releases/attr/attr-2.4.47.src.tar.gz.sig
gpg2 attr-2.4.47.src.tar.gz.sig
tar -xf attr-2.4.47.src.tar.gz
cd attr-2.4.47
#fixing paths to sh
sed -i "s/\/bin\/sh/\/data\/data\/com.termux\/files\/usr\/bin\/sh/" configure
sed -i "s/\/bin\/sh/\/data\/data\/com.termux\/files\/usr\/bin\/sh/" install-sh
sed -i "s/\/bin\/sh/\/data\/data\/com.termux\/files\/usr\/bin\/sh/" include/install-sh
#fix for non-existent /tmp directory in set_cc_for_build of config.guess for 32-bit arm
sed -i "s/TMPDIR=\/tmp/TMPDIR=tmp/g" config.guess
mkdir tmp

./configure CC=clang --prefix=/data/data/com.termux/files/usr/

#fix for ./include/attr/xattr.h:37:58: error: expected function body after function declarator
#                      const void *__value, size_t __size, int __flags) __THROW;
sed -i "s/__THROW//g" include/xattr.h
make
make install install-lib install-dev
cd ..

#download and build libacl
wget https://download.savannah.gnu.org/releases/acl/acl-2.2.52.src.tar.gz
wget https://download.savannah.gnu.org/releases/acl/acl-2.2.52.src.tar.gz.sig
gpg2 --recv-key 0542DF34
tar -xf acl-2.2.52.src.tar.gz
cd acl-2.2.52
#fixing paths to sh
sed -i "s/\/bin\/sh/\/data\/data\/com.termux\/files\/usr\/bin\/sh/" configure
sed -i "s/\/bin\/sh/\/data\/data\/com.termux\/files\/usr\/bin\/sh/" install-sh
sed -i "s/\/bin\/sh/\/data\/data\/com.termux\/files\/usr\/bin\/sh/" include/install-sh

#fix for non-existent /tmp directory in set_cc_for_build of config.guess for 32-bit arm
sed -i "s/TMPDIR=\/tmp/TMPDIR=tmp/g" config.guess
mkdir tmp

./configure --prefix=/data/data/com.termux/files/usr/ CC=clang
make
make install install-lib install-dev
cd ..

#patching paths
export BORG_OPENSSL_PREFIX="/data/data/com.termux/files/usr/"
export BORG_LZ4_PREFIX="/data/data/com.termux/files/usr/"

pip install -e .

cd ..
#need wrapper for ssh, because /system/lib64/ needs to be in LD_LIBRARY_PATH
#otherwise: Remote: CANNOT LINK EXECUTABLE "ssh": library "libandroid-support.so" not found
export BORG_RSH=borg_ssh_wrapper
cp borg_ssh_wrapper /data/data/com.termux/files/usr/bin/borg_ssh_wrapper
chmod +x /data/data/com.termux/files/usr/bin/borg_ssh_wrapper

#test by creating a backup of the borg directory
borg init -e none borg_test
borg create borg_test::1 borg
borg list borg_test
borg info borg_test::1
borg list borg_test::1
