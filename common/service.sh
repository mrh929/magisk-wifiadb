#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# these environment variables below can be customized
# --------------------------------------------------------

# default definitions
ENABLE_LOG=""
ADB_PORT=""
STATUS_CHK_FREQUENCY=""

# --------------------------------------------------------

# constant definitions
DEFAULT_ADB_PORT="5555"
DEFAULT_STATUS_CHK_FREQUENCY="1"
ADB_PORT_PATTERN='^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$'
STATUS_CHK_FREQUENCY_PATTERN='^([1-9]|10)$'

# functions
print_log() {
    [ "$ENABLE_LOG" != "1" ] && return
    echo "$(date '+[%Y-%m-%d %I:%M:%S]') $1" >> /data/local/tmp/wifiadb.log
}

start_adb() {
    setprop service.adb.tcp.port "$ADB_PORT"
    stop adbd
    start adbd
}

stop_adb() {
    setprop service.adb.tcp.port ""
    stop adbd
    start adbd
}

check_adb_status() {
    if [ "$(getprop init.svc.adbd)" != "running" ]; then
        return 0
    fi

    if [ "$(getprop service.adb.tcp.port)" != "$ADB_PORT" ]; then
        return 0
    fi

    return 1
}

maintain_adb_availability() {
    while true; do
        # print_log "Checking ADB status..."

        if [ -e "${MODDIR}/disable" ]; then
            check_adb_status
            if [ $? -eq 1 ]; then
                print_log "Module is disabled, stopping ADB..."
                stop_adb
            fi
        else
            check_adb_status
            if [ $? -eq 0 ]; then
                print_log "Module is enabled, starting ADB..."
                start_adb
            fi
        fi

        sleep $STATUS_CHK_FREQUENCY
    done
}

load_config() {
    CONFIG_PATH="${MODDIR}/config"
    if [ -f "$CONFIG_PATH" ]; then
        source "$CONFIG_PATH"
        print_log "Config file loaded."
    else
        print_log "Config file not found."
    fi
}

parse_config() {
    if ! echo "$ADB_PORT" | grep -Eq "$ADB_PORT_PATTERN"; then
        print_log "ADB_PORT parse failed, set to default value"
        ADB_PORT=$DEFAULT_ADB_PORT
    fi
    print_log "ADB_PORT value: $ADB_PORT"

    if ! echo "$STATUS_CHK_FREQUENCY" | grep -Eq "$STATUS_CHK_FREQUENCY_PATTERN"; then
        print_log "STATUS_CHK_FREQUENCY parse failed, set to default value"
        STATUS_CHK_FREQUENCY=$DEFAULT_STATUS_CHK_FREQUENCY
    fi
    print_log "STATUS_CHK_FREQUENCY value: $STATUS_CHK_FREQUENCY"
}

# This script will be executed in late_start service mode
(
    until [ "$(getprop sys.boot_completed)" -eq 1 ]; do
        sleep 1
    done

    load_config
    parse_config

    print_log "---- magisk-wifiadb started ----"
    maintain_adb_availability
) &