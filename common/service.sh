#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# functions
print_log() {
  log_text="$1"
  now=$(date '+[%Y-%m-%d %I:%M:%S]')
  echo "$now $log_text" >>/data/local/tmp/wifiadb.log
}

is_module_enable() {
  if [ -e "${MODDIR}/disable" ]; then
    return 0
  else
    return 1
  fi
}

start_adb() {
  port=$1
  setprop service.adb.tcp.port "$port"
  stop adbd
  start adbd
}

stop_adb() {
  setprop service.adb.tcp.port ""
  stop adbd
  start adbd
}

maintain_adb_availability() {
  while true; do
    print_log "check module status"
    is_module_enable
    if [ $? -eq 1 ]; then
      print_log "module is enabled"
      if [ "$(getprop service.adb.tcp.port)" != "5555" ]; then
        print_log "======= adb is not started, starting adb ======="
        start_adb 5555
      fi
    else
      print_log "module is disabled"
      if [ "$(getprop service.adb.tcp.port)" != "" ]; then
        print_log "======= adb is not stopped, stopping adb ======="
        stop_adb
      fi
    fi
    sleep 5
  done
}

# This script will be executed in late_start service mode
(
  until [ "$(getprop sys.boot_completed)" -eq 1 ]; do
    sleep 5
  done

  print_log "boot complete"
  maintain_adb_availability
) &
