Set shell = wscript.CreateObject("wscript.shell")
shell.run "Powershell.exe -NonInteractive -ExecutionPolicy Bypass -File FixWslCiscoAnyConnect.ps1", 0, True
