@echo off
if not exist C:\AutoSecure\log mkdir C:\AutoSecure\log
%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -command Set-ExecutionPolicy unrestricted
%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -File "C:\AutoSecure\WindowsFirewallRolesSetup.ps1"
timeout 5
"c:\program files\windows defender\MpCmdRun.exe" -SignatureUpdate
"c:\program files\windows defender\MpCmdRun.exe" -Scan -ScanType 1
forfiles /p "C:\AutoSecure\log" /s /m *.* /d -30 /c "cmd /c del @path"