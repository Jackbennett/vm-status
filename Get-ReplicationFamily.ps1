Import-Module Hyper-V
Import-Module ActiveDirectory

function Get-Hypervisors{
    Get-ADComputer -Filter * -searchBase "OU=Hypervisors,OU=Servers,OU=Upholland,DC=upholland,DC=lancsngfl,DC=ac,DC=uk" |
        select @{name="ComputerName"; expression={ $_.DNSHostName }} |
        Sort-Object ComputerName
}

function Get-ReplicationPartners{
    Get-Hypervisors |
        ForEach-Object {
            Get-vmreplication -computername $_.computername -PrimaryServerName $_.computername |
            select Name,PrimaryServer,ReplicaServer,state
        }
}

function New-ReplicationMap{
    Get-ReplicationPartners | convertto-json | Out-File .\ReplicationMap.json
}