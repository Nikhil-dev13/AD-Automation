net user adam Pass@123 /add
net localgroup "Remote Desktop Users" adam /add

$domain_name = "auror.local"
$netbios_name = "auror"
$mode = "Win2012R2"
$password = "Vagrant@2022"
$sPassword = $password | ConvertTo-SecureString -AsPlainText -Force

Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools

Import-Module ADDSDeployment

$forestProperties = @{

    DomainName                    = $domain_name
    DomainNetbiosName             = $netbios_name
    ForestMode                    = $mode
    DomainMode                    = $mode
    InstallDns                    = $true
    SafeModeAdministratorPassword = $sPassword
    DatabasePath                  = "C:\Windows\NTDS"
    LogPath                       = "C:\Windows\NTDS"
    SysvolPath                    = "C:\Windows\SYSVOL"
    Force                         = $true
    NoRebootOnCompletion          = $true
}

Install-ADDSForest @forestProperties