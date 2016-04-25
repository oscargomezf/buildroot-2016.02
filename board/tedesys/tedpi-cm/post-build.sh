#!/bin/sh

# Rebuild config.txt file
(\
	echo "# Please note that this is only a sample, we recommend you to change it to fit"; \
	echo "# your needs."; \
	echo "# You should override this file using a post-build script."; \
	echo "# See http://buildroot.org/manual.html#rootfs-custom"; \
	echo "# and http://elinux.org/RPiconfig for a description of config.txt syntax"; \
	echo ""; \
	echo "kernel=zImage"; \
	echo ""; \
	echo "# To use an external initramfs file"; \
	echo "#initramfs rootfs.cpio.gz"; \
	echo ""; \
	echo "# Disable overscan assuming the display supports displaying the full resolution"; \
	echo "# If the text shown on the screen disappears off the edge, comment this out"; \
	echo "disable_overscan=1"; \
	echo ""; \
	echo "# How much memory in MB to assign to the GPU on Pi models having"; \
	echo "# 256, 512 or 1024 MB total memory"; \
	echo "gpu_mem_256=100"; \
	echo "gpu_mem_512=100"; \
	echo "gpu_mem_1024=100"; \
	echo ""; \
	echo "device_tree=bcm2708-rpi-cm.dtb"; \
	echo "dtparam=i2c_arm=on,i2c_arm_baudrate=200000"; \
	echo "dtparam=spi=on"; \
	echo "dtparam=watchdog=on"; \
 ) > ${BINARIES_DIR}/rpi-firmware/config.txt

# Rebuild cmdline.txt
(\
	echo "console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 root=/dev/mmcblk0p2 rw rootfstype=ext4 elevator=deadline rootwait"; \
) > ${BINARIES_DIR}/rpi-firmware/cmdline.txt

# Rebuild /etc/fstab
grep -r "/dev/mmcblk0p1" ${TARGET_DIR}/etc/fstab 1> /dev/null
if [ "$?" = "1" ]; then
	(\
		echo "/dev/mmcblk0p1  /boot           vfat    defaults        0       2"; \
	) >> ${TARGET_DIR}/etc/fstab
	mkdir -p ${TARGET_DIR}/boot
fi

# Build /etc/modules
(\
	echo "i2c-dev"; \
) > ${TARGET_DIR}/etc/modules

chmod 644 ${TARGET_DIR}/etc/modules

# Build S18loadmod file
(\
	echo "#!/bin/sh"; \
	echo "#"; \
	echo "# load modules"; \
	echo "#"; \
	echo ""; \
	echo "MODULES_PATH=\"/etc/modules\""; \
	echo "case \"\$1\" in"; \
	echo "start)"; \
	echo "		echo \"Loading modules in \${MODULES_PATH}...\""; \
	echo "		for line in \$(cat \${MODULES_PATH});"; \
	echo "		do"; \
	echo "			[[ \$line = \#* ]] && continue"; \
	echo "			modprobe \$line;"; \
	echo "		done"; \
	echo "		;;"; \
	echo "	stop)"; \
	echo "		;;"; \
	echo "	restart|reload)"; \
	echo "		;;"; \
	echo "	*)"; \
	echo "		echo \"Usage: \$0 {start|stop|restart}\""; \
	echo "		exit 1"; \
	echo "esac"; \
	echo ""; \
	echo "exit \$?"; \
) > ${TARGET_DIR}/etc/init.d/S18loadmod

chmod 755 ${TARGET_DIR}/etc/init.d/S18loadmod

exit $?