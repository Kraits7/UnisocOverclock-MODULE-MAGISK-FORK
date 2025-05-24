#!/system/bin/sh

MAX_FREQ=2300000           # 2.3 GHz
BOOST_FREQ=2100000         # 2.1 GHz постоянная
MIN_FREQ=1800000           # Минимум 1.8 GHz
GPU_BOOST=900000           # Разгон GPU
VOLTAGE_BOOST=1300000      # 1.3V
THERMAL_LIMIT=95           # Лимит температуры °C

mount -o remount,rw /system
echo 0 > /sys/module/msm_thermal/parameters/enabled
echo 0 > /sys/module/msm_thermal/core_control/enabled

for cpu in /sys/devices/system/cpu/cpu*/cpufreq/; do
    echo performance > ${cpu}/scaling_governor
    echo $MAX_FREQ > ${cpu}/scaling_max_freq
    echo $BOOST_FREQ > ${cpu}/scaling_min_freq
    echo $BOOST_FREQ > ${cpu}/scaling_setspeed
done


if [ -f /sys/class/kgsl/kgsl-3d0/devfreq/max_freq ]; then
    echo $GPU_BOOST > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
    echo $GPU_BOOST > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
fi


for reg in /sys/class/regulator/*; do
    if [ -f ${reg}/microvolts ]; then
        echo $VOLTAGE_BOOST > ${reg}/microvolts
    fi
done


echo 100 > /proc/sys/vm/swappiness
echo 1 > /proc/sys/vm/oom_kill_allocating_task
echo 3 > /proc/sys/vm/drop_caches