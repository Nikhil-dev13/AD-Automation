Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False
set-mppreference -disableioavprotection $true -DisableRealtimeMonitoring $true -DisableScriptScanning $true -EnableNetworkProtection 0 -DisableBehaviorMonitoring $true

$adapters = Get-WmiObject Win32_NetworkAdapterConfiguration
$adapters | ForEach-Object {$_.SetDNSServerSearchOrder("10.0.0.9")}

$username = "vagrant"
$password = "vagrant"
$sPassword = $password | ConvertTo-SecureString -AsPlainText -Force

$creds = New-Object System.Management.Automation.PSCredential $username, $sPassword

Add-Computer -DomainName auror.local -credential $creds

net localgroup "Administrators" auror\adam /add
 
Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile C:\\Windows\\Tasks\\chrome_setup.exe

Start-Process -FilePath C:\\Windows\\Tasks\\chrome_setup.exe -Args "/silent /install"