#!/sbin/sh
#rifle007
# We use this shell script because the script will follow symlinks and
# different trees will use different binaries to supply the setenforce
# tool. Before M we use toolbox, M and beyond will use toybox. The init
# binary and init.rc will not follow symlinks.

setenforce 0

# aboot protection
rm /dev/block/mmcblk0p4
ln -s /dev/null /dev/block/mmcblk0p4
rm /dev/block/mmcblk0p5
ln -s /dev/null /dev/block/mmcblk0p5


## semoga bisa disable stock recovery
mount /system >/dev/null 2>&1
mv /system/bin/install-recovery.sh /system/bin/install-recovery.sh.bak
mv /system/recovery-from-boot.p /system/recovery-from-boot.p.bak
mv /system/etc/recovery-resource.dat /system/etc/recovery-resource.dat.bak


sdzipdir=/twres/patcher;
tmpzipdir=/tmp/patcher;


    # wait out any post-addon.d zip actions (flashing boot.img, etc.)
    while sleep 0; do
      # read zips from sdcard directory and unpack then run update-binary/script
      test ! -d "$sdzipdir" && mkdir "$sdzipdir";
      metadir=META-INF/com/google/android;
      for i in "$sdzipdir"/*; do
        mkdir -p "$tmpzipdir";
        unzip "$i" -d "$tmpzipdir" "$metadir/*";
        chmod 755 "$tmpzipdir/$metadir/update-binary";
        "$tmpzipdir/$metadir/update-binary" "$tmpzipdir/$metadir/update-binary" 1 "$i";
        rm -rf "$tmpzipdir";

        #for dual boot patcher        
if [ ! -f /sdcard/MultiBoot/data*/boot.img >/dev/null 2>&1 ]; then
rm -R /sdcard/MultiBoot/primary
else
echo " "
fi
        chmod 755 /res/mbtool
        chmod 755 /res/devices.json
/twres/patcher/mbtool utilities --device /twres/patcher/devices.json switch --force primary
      done;
      exit;
      done;
      
