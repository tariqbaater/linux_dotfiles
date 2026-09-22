-- Extra autostart processes.
-- o.launch_on_start("my-service")
o.launch_on_start("vicinae server")
o.launch_on_start("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
