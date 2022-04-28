param
(
    [string]$domain_ip = "10.10.11.9"
    [string]$domain_name = "auror.local"
    [string]$domain_user = "vagrant"
    [string]$domain_pass = "vagrant"
)

## Turn off the firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Set the DNS server to the domain controller
foreach ($adapter in Get-NetAdapter) {  
    Set-DnsClientServerAddress -InterfaceIndex $adapter.interfaceindex -ServerAddresses ($domain_ip, $domain_ip) 
}

# https://blog.netwrix.com/2018/07/10/how-to-create-delete-rename-disable-and-join-computers-in-ad-using-powershell/#:~:text=To%20join%20a%20PC%20to,password%20for%20the%20domain%20admin.
$secure_pass = ConvertTo-SecureString -String $domain_pass -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential($domain_user, $domain_pass)

# Join the domain
Add-Computer -DomainName $domain_name -Credential $creds -Force

# Add Adam to administrators group
net localgroup "Administrators" auror\adam /add
