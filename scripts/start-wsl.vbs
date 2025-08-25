Set shell = wscript.CreateObject("wscript.shell")
shell.run "wsl.exe -d Ubuntu --exec dbus-launch true", 0, True
