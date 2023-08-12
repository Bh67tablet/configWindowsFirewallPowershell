@echo off
timeout 5
schtasks.exe /create /TN "startAutoSecure" /SC ONSTART /RU system /TR "C:\AutoSecure\startAutoSecure.cmd"
timeout 5
schtasks.exe /create /TN "startAutoSecure2" /SC STÜNDLICH /RU system /TR "C:\AutoSecure\startAutoSecure.cmd"
timeout 5
C:\AutoSecure\startAutoSecure.cmd
pause