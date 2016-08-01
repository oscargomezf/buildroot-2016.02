#!/bin/sh

case "${2}" in
	"tedpi-1b")
		TEDPI_MAC=B8:27:EB:59:EB:61
		;;
	"tedpi-2b"|"tedpi-2b-flea3"|"tedpi-2b-x")
		TEDPI_MAC=B8:27:EB:59:EB:62
		;;
	"tedpi-3b"|"tedpi-3b-flea3")
		TEDPI_MAC=B8:27:EB:59:EB:63
		;;
esac

# Install overlays from tedesys
PWD=$(pwd)
for ovldtb in  ${PWD}/board/tedesys/tedpi/overlays/*.dtb; do
	cp ${ovldtb} ${BINARIES_DIR}/rpi-firmware/overlays/ || exit 1;
done


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
	echo "#${2}"; \
	case "${2}" in
		"tedpi-cm")
			echo "force_turbo=1"; \
			echo "arm_freq=700"; \
			echo "core_freq=250"; \
			echo "device_tree=bcm2708-rpi-cm.dtb"; \
			;;
		"tedpi-1b")
			echo "force_turbo=1"; \
			echo "arm_freq=700"; \
			echo "core_freq=250"; \
			echo "device_tree=bcm2708-rpi-b.dtb"; \
			;;
               "tedpi-2b"|"tedpi-2b-flea3")
                        echo "force_turbo=1"; \
                        echo "arm_freq=900"; \
                        echo "core_freq=250"; \
                        echo "device_tree=bcm2709-rpi-2-b.dtb"; \
                        echo "dtoverlay=tca6424a"; \
                        ;;
		"tedpi-2b-x")
			echo "force_turbo=1"; \
			echo "arm_freq=900"; \
			echo "core_freq=250"; \
			echo "device_tree=bcm2709-rpi-2-b.dtb"; \
			echo "dtoverlay=tca6424a"; \
			echo "# HDMI parameters"; \
			echo "framebuffer_ignore_alpha=1"; \
			echo "framebuffer_swap=1"; \
			echo "disable_overscan=1"; \
			echo "init_uart_clock=16000000"; \
			echo "hdmi_group=2"; \
			echo "hdmi_mode=1"; \
			echo "hdmi_mode=87"; \
			echo "hdmi_cvt=800 480 60 6 0 0 0"; \
			echo "dtparam=spi=on"; \
			echo "dtoverlay=ads7846,penirq=25,speed=10000,penirq_pull=2,xohms=150"; \
			echo "hdmi_force_hotplug=1"; \
			echo "config_hdmi_boost=4"; \
			echo "overscan_left=0"; \
			echo "overscan_right=0"; \
			echo "overscan_top=0"; \
			echo "overscan_bottom=0"; \
			echo "disable_overscan=1"; \
			echo "dtparam=spi=on"; \
			;;
		"tedpi-3b")
			echo "force_turbo=1"; \
			echo "arm_freq=1200"; \
			echo "core_freq=250"; \
			echo "device_tree=bcm2710-rpi-3-b.dtb"; \
			echo "dtoverlay=pi3-disable-bt"; \
			;;
		"tedpi-3b-flea3")
			echo "force_turbo=1"; \
			echo "arm_freq=1200"; \
			echo "core_freq=250"; \
			echo "device_tree=bcm2710-rpi-3-b.dtb"; \
			echo "dtoverlay=pi3-disable-bt"; \
			echo "dtoverlay=tca6424a"; \
			;;
		*)
			exit 1
			;;
	esac
	echo "dtparam=i2c_arm=on,i2c_arm_baudrate=200000"; \
	echo "dtparam=spi=on"; \
	echo "dtparam=watchdog=on"; \
 ) > ${BINARIES_DIR}/rpi-firmware/config.txt

# Rebuild cmdline.txt
(\
	case "${2}" in
		"tedpi-cm")
			echo "console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 root=/dev/mmcblk0p2 rw rootfstype=ext4 elevator=deadline rootwait"; \
			;;
		"tedpi-1b"|"tedpi-2b"|"tedpi-3b")
			echo "console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 root=/dev/mmcblk0p2 rw rootfstype=ext4 elevator=deadline rootwait smsc95xx.macaddr=${TEDPI_MAC}"; \
			;;
		"tedpi-2b-x")
			echo "console=tty1 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 root=/dev/mmcblk0p2 rw rootfstype=ext4 elevator=deadline rootwait smsc95xx.macaddr=${TEDPI_MAC} usbcore.usbfs_memory_mb=256"; \
			;;
		"tedpi-2b-flea3"|"tedpi-3b-flea3")
			echo "console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 root=/dev/mmcblk0p2 rw rootfstype=ext4 elevator=deadline rootwait smsc95xx.macaddr=${TEDPI_MAC} usbcore.usbfs_memory_mb=256"; \
			;;
		*)
			exit 1
			;;
	esac
) > ${BINARIES_DIR}/rpi-firmware/cmdline.txt

if [ "$2" != "${2%"tedpi-3b"*}" ]; then
	# Build /etc/wpa_supplicant/wpa_supplicant.conf
	mkdir -p "${TARGET_DIR}/etc/wpa_supplicant"
	( \
		echo "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev"; \
		echo "update_config=1"; \
		echo ""; \
		echo "network={"; \
		echo "        ssid=\"SSID\""; \
		echo "        scan_ssid=1"; \
		echo "        proto=RSN WPA"; \
		echo "        key_mgmt=WPA-PSK"; \
		echo "        pairwise=CCMP TKIP"; \
		echo "        group=CCMP TKIP"; \
		echo "        auth_alg=OPEN"; \
		echo "        priority=0"; \
		echo "        id_str=\"TAG\""; \
		echo "        psk=PASSWORD"; \
		echo "}"; \
	) > ${TARGET_DIR}/etc/wpa_supplicant/wpa_supplicant.conf

	# Rebuild  /etc/network/interfaces
	grep -r "wlan0" ${TARGET_DIR}/etc/network/interfaces 1> /dev/null
	if [ "$?" = "1" ]; then
		(\
			echo "";\
			echo "auto wlan0"; \
			echo "iface wlan0 inet dhcp"; \
			echo "        pre-up wpa_supplicant -B -Dwext -iwlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf"; \
			echo "        post-down killall -q wpa_supplicant"; \
			echo ""; \
			echo "iface default inet dhcp"; \
		) >> ${TARGET_DIR}/etc/network/interfaces
	fi
fi

# Rebuild /etc/inittab for HDMI console output
if [ "$2" = "tedpi-2b-x" ]; then
	# Add a console on tty1
	grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi

# Rebuild /etc/fstab
grep -qE '^/dev/mmcblk0p1' ${TARGET_DIR}/etc/fstab || \
sed -i '/sysfs/a /dev/mmcblk0p1  /boot           vfat    defaults        0       2 ' ${TARGET_DIR}/etc/fstab 
mkdir -p ${TARGET_DIR}/boot
#fi

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
