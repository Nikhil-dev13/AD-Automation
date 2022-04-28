# Add user
net user adam Pass@123 /add

# https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-a-new-windows-server-2012-active-directory-forest--level-200-#BKMK_PSForest
$domain_name  = "auror.local"
$netbios_name = "auror"
$mode  = "WinThreshold"
$password = "Password@123"

# https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-
Install-WindowsFeature -name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools

## https://docs.microsoft.com/en-us/powershell/module/addsdeployment/install-addsforest?view=windowsserver2022-ps
Import-Module ADDSDeployment

$ADProperties = @{

    DatabasePath         = "C:\Windows\NTDS"
    LogPath              = "C:\Windows\NTDS"
    SysvolPath           = "C:\Windows\SYSVOL"
    
    DomainName           = $domain_name
    DomainNetbiosName    = $netbios_name
    
    ForestMode           = $mode
    DomainMode           = $mode
    SafeModeAdministratorPassword = $password | ConvertTo-SecureString -AsPlainText -Force
    
    InstallDns           = $true
    Force                = $true
    NoRebootOnCompletion = $true
}

Install-ADDSForest @$ADProperties
