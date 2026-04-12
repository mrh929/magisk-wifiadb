_ver=$(grep '^version=' "$MODPATH/module.prop" | cut -d= -f2)
ui_print "- Version  : $_ver"
ui_print "- Port     : $(grep '^ADB_PORT=' "$MODPATH/config" | cut -d= -f2)"
ui_print "- Log file : /data/local/tmp/wifiadb.log (if ENABLE_LOG=1)"

set_perm "$MODPATH/service.sh" root root 0755

ui_print "- Reboot to activate"
