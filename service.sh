#!/system/bin/sh
MODDIR=${0%/*}

# ── defaults (override in $MODDIR/config) ──────────────────────────────────
ENABLE_LOG=""
ADB_PORT=""
STATUS_CHK_FREQUENCY=""

# ── constants ───────────────────────────────────────────────────────────────
DEFAULT_ADB_PORT="5555"
DEFAULT_STATUS_CHK_FREQUENCY="5"
ADB_PORT_PATTERN='^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$'
STATUS_CHK_FREQUENCY_PATTERN='^([1-9]|10)$'

# ── helpers ──────────────────────────────────────────────────────────────────
print_log() {
    [ "$ENABLE_LOG" != "1" ] && return
    echo "$(date '+[%Y-%m-%d %I:%M:%S]') $1" >> /data/local/tmp/wifiadb.log
}

# Enable TCP ADB + wireless-debugging settings so they survive reboots.
start_adb() {
    setprop persist.adb.tcp.port "$ADB_PORT"
    setprop service.adb.tcp.port "$ADB_PORT"
    settings put global adb_wifi_enabled 1
    stop adbd
    start adbd
}

stop_adb() {
    setprop persist.adb.tcp.port ""
    setprop service.adb.tcp.port ""
    settings put global adb_wifi_enabled 0
    stop adbd
    start adbd
}

# Returns 0 if ADB needs (re)starting, 1 if everything is fine.
check_adb_status() {
    local svc="$(getprop init.svc.adbd)"
    local tcp="$(getprop service.adb.tcp.port)"
    local ptcp="$(getprop persist.adb.tcp.port)"

    [ "$svc" = "running" ] || { print_log "check: adbd not running"; return 0; }
    [ "$tcp" = "$ADB_PORT" ] && return 1
    [ "$ptcp" = "$ADB_PORT" ] && return 1

    print_log "check: adbd running but no TCP port"
    return 0
}

maintain_adb_availability() {
    while true; do
        if [ -e "${MODDIR}/disable" ]; then
            sleep $STATUS_CHK_FREQUENCY
            continue
        fi
        check_adb_status
        if [ $? -eq 0 ]; then
            print_log "ADB not ready — starting"
            start_adb
        fi
        sleep $STATUS_CHK_FREQUENCY
    done
}

load_config() {
    local cfg="${MODDIR}/config"
    [ -f "$cfg" ] && . "$cfg"
}

parse_config() {
    if [ -z "$ADB_PORT" ]; then
        ADB_PORT=$DEFAULT_ADB_PORT
    elif ! echo "$ADB_PORT" | grep -Eq "$ADB_PORT_PATTERN"; then
        print_log "ADB_PORT invalid — using default"
        ADB_PORT=$DEFAULT_ADB_PORT
    fi
    print_log "ADB_PORT=$ADB_PORT"

    if [ -z "$STATUS_CHK_FREQUENCY" ]; then
        STATUS_CHK_FREQUENCY=$DEFAULT_STATUS_CHK_FREQUENCY
    elif ! echo "$STATUS_CHK_FREQUENCY" | grep -Eq "$STATUS_CHK_FREQUENCY_PATTERN"; then
        print_log "STATUS_CHK_FREQUENCY invalid — using default"
        STATUS_CHK_FREQUENCY=$DEFAULT_STATUS_CHK_FREQUENCY
    fi
    print_log "STATUS_CHK_FREQUENCY=$STATUS_CHK_FREQUENCY"
}

# ── main (late_start service) ─────────────────────────────────────────────
(
    until [ "$(getprop sys.boot_completed)" = "1" ]; do
        sleep 1
    done

    rm -f /data/local/tmp/wifiadb.log
    load_config
    _ver=$(grep '^version=' "$MODDIR/module.prop" 2>/dev/null | cut -d= -f2)
    print_log "---- MagiskWiFiADB ${_ver} started ----"
    parse_config

    # Enable wireless ADB — AdbService will properly init network stack and start adbd
    if [ ! -e "${MODDIR}/disable" ]; then
        setprop persist.adb.tcp.port "$ADB_PORT"
        settings put global adb_wifi_enabled 1
        print_log "Boot-time: persist.adb.tcp.port=$ADB_PORT, adb_wifi_enabled=1"
    fi
    print_log "Entering monitor loop"

    maintain_adb_availability
) &
