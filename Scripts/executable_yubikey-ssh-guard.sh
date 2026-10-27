#!/usr/bin/env bash
# Monitor YubiKey unplug and screen lock events to immediately close
# cached SSH ControlMaster connections (so the YubiKey PIN is required again).

close_ssh_sessions() {
    ssh -O exit github.com 2>/dev/null || true
    rm -f "${XDG_RUNTIME_DIR}"/ssh-cm-* 2>/dev/null || true
}

# 1. Watch for YubiKey USB removal via udevadm
udevadm monitor --udev --subsystem-match=hidraw --subsystem-match=usb | while read -r line; do
    if [[ "$line" == *"remove"* ]]; then
        if ! lsusb -d 1050: >/dev/null 2>&1; then
            close_ssh_sessions
        fi
    fi
done &

# 2. Watch for systemd-logind session Lock / PrepareForSleep signals via gdbus
gdbus monitor --system --dest org.freedesktop.login1 | while read -r line; do
    if [[ "$line" == *"org.freedesktop.login1.Session.Lock"* ]] || [[ "$line" == *"org.freedesktop.login1.Manager.PrepareForSleep (true)"* ]]; then
        close_ssh_sessions
    fi
done &

trap 'kill 0 2>/dev/null' EXIT INT TERM

wait
