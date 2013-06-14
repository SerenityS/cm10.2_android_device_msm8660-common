#!/system/bin/sh
# Copyright (c) 2009-2012, Code Aurora Forum. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Code Aurora nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

target=`getprop ro.board.platform`

case "$target" in
    "msm8660")
         echo 1 > /sys/module/rpm_resources/enable_low_power/L2_cache
         echo 1 > /sys/module/rpm_resources/enable_low_power/pxo
         echo 2 > /sys/module/rpm_resources/enable_low_power/vdd_dig
         echo 2 > /sys/module/rpm_resources/enable_low_power/vdd_mem
         echo 1 > /sys/module/rpm_resources/enable_low_power/rpm_cpu
         echo 1 > /sys/module/pm_8x60/modes/cpu0/power_collapse/suspend_enabled
         echo 1 > /sys/module/pm_8x60/modes/cpu1/power_collapse/suspend_enabled
         echo 1 > /sys/module/pm_8x60/modes/cpu0/standalone_power_collapse/suspend_enabled
         echo 1 > /sys/module/pm_8x60/modes/cpu1/standalone_power_collapse/suspend_enabled
         echo 1 > /sys/module/pm_8x60/modes/cpu0/power_collapse/idle_enabled
         echo 1 > /sys/module/pm_8x60/modes/cpu1/power_collapse/idle_enabled
         echo 1 > /sys/module/pm_8x60/modes/cpu0/standalone_power_collapse/idle_enabled
         echo 1 > /sys/module/pm_8x60/modes/cpu1/standalone_power_collapse/idle_enabled
         echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
         echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
         echo 50000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
         echo 90 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
         echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
         echo 4 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
         echo 384000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
         echo 384000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
#	 	   echo 1188000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
#	 	   echo 1188000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
         chown system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
         chown system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
         chown system /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
         chown system /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
         chown root.system /sys/devices/system/cpu/mfreq
         chmod 220 /sys/devices/system/cpu/mfreq
         chown root.system /sys/devices/system/cpu/cpu1/online
         chmod 664 /sys/devices/system/cpu/cpu1/online
        ;;
esac

chown system /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
chown system /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
chown system /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy

emmc_boot=`getprop ro.boot.emmc`
case "$emmc_boot"
    in "true")
        chown system /sys/devices/platform/rs300000a7.65536/force_sync
        chown system /sys/devices/platform/rs300000a7.65536/sync_sts
        chown system /sys/devices/platform/rs300100a7.65536/force_sync
        chown system /sys/devices/platform/rs300100a7.65536/sync_sts
    ;;
esac

case "$target" in
    "msm8960" | "msm8660" | "msm7630_surf")
        echo 10 > /sys/devices/platform/msm_sdcc.3/idle_timeout
        ;;
esac

# Post-setup services
case "$target" in
    "msm8660" )
        start mpdecision
        start thermald
    ;;
esac


# Install AdrenoTest.apk if not already installed
if [ -f /data/prebuilt/AdrenoTest.apk ]; then
    if [ ! -d /data/data/com.qualcomm.adrenotest ]; then
        pm install /data/prebuilt/AdrenoTest.apk
    fi
fi

# Change adj level and min_free_kbytes setting for lowmemory killer to kick in
case "$target" in
     "msm8660")
        echo 0,1,2,4,9,12 > /sys/module/lowmemorykiller/parameters/adj
        echo 5120 > /proc/sys/vm/min_free_kbytes
     ;;
esac
# Clean mdm files
case "$target" in
    "msm8660" | "msm8660_surf" | "msm8660_csfb" | "ef65l" | "ef40s" | "ef39s" | "ef40k")
        rm -rf /data/tombstones/mdm/*
    ;;
esac

case "$target" in
    "msm8660" | "msm8660_surf" | "msm8660_csfb" | "ef65l" | "ef40s" | "ef39s" | "ef40k")
    if [ -f /system/vendor/apps/kuwo.apk ]; then
        if [ ! -d /data/data/cn.kuwo.player ]; then
            pm install /system/vendor/apps/kuwo.apk
        fi
    fi

    if [ -f /system/vendor/apps/kyd.apk ]; then
        if [ ! -d /data/data/com.shuqi.controller ]; then
            pm install /system/vendor/apps/kyd.apk
        fi
    fi


    if [ -f /system/vendor/apps/SohuTV_3.0_542_201304251627.apk ]; then
        if [ ! -d /data/data/com.souhu.souhuvideo ]; then
            pm install /system/vendor/apps/SohuTV_3.0_542_201304251627.apk
        fi
    fi


    if [ -f /system/vendor/apps/sogoumap-phone-6013-3.8.1.apk ]; then
        if [ ! -d /data/data/com.sogou.map.android.maps ]; then
            pm install /system/vendor/apps/sogoumap-phone-6013-3.8.1.apk
        fi
    fi


    if [ -f /system/vendor/apps/SogouAppMall1.1.0-release.apk ]; then
        if [ ! -d /data/data/com.sogou.appmall ]; then
            pm install /system/vendor/apps/SogouAppMall1.1.0-release.apk
        fi
    fi
    
    if [ -f /system/vendor/apps/jiuyou.apk ]; then
        if [ ! -d /data/data/cn.ninegame.gamemanager ]; then
            pm install /system/vendor/apps/jiuyou.apk
        fi
    fi
    
    if [ -f /system/vendor/apps/ucweb.apk ]; then
        if [ ! -d /data/data/com.UCMobile ]; then
            pm install /system/vendor/apps/ucweb.apk
        fi
    fi
rm -r /system/vendor/apps
    ;;
esac

mount -t ext4 -o remount,rw,barrier=0 /dev/block/mmcblk0p13 /system
mount -o remount,rw rootfs /


