param
(
    [string]$password = "PAssword@123",
    [string]$user = "Administrator",
    [string]$hostname = "auror-b"
)
Write-Host -ForegroundColor Green "Chagning_hostname"
$pass = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $pass)
Rename-Computer -NewName $hostname -DomainCredential $cred