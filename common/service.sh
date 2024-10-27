#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# functions
print_log() {
    if [ "$ENABLE_LOG" != "1" ]; then
        return
    fi

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
            if [ "$(getprop service.adb.tcp.port)" != "$ADB_PORT" ]; then
                print_log "adb is not started, starting adb"
                start_adb "$ADB_PORT"
            fi
        else
            print_log "module is disabled"
            if [ "$(getprop service.adb.tcp.port)" != "" ]; then
                print_log "adb is not stopped, stopping adb"
                stop_adb
            fi
        fi
        sleep 5
    done
}

load_config() {
    CONFIG_PATH="${MODDIR}/config"

    if [[ -f "$CONFIG_PATH" ]]; then
        source "$CONFIG_PATH"
        print_log "config file loaded."
    else
        print_log "config file not found."
    fi
}

parse_config() {
    ADB_PORT_PATTERN='^([1-9]|[1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$'

    if echo "$ADB_PORT" | grep -Eq "$ADB_PORT_PATTERN"; then
        print_log "ADB_PORT value: $ADB_PORT"
    else
        ADB_PORT="5555"
        print_log "ADB_PORT parse failed, set to default value: $ADB_PORT"
    fi
}

# This script will be executed in late_start service mode
(
    until [ "$(getprop sys.boot_completed)" -eq 1 ]; do
        sleep 5
    done

    load_config
    parse_config
    maintain_adb_availability
) &
