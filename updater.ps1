$currentPath=Split-Path ((Get-Variable MyInvocation -Scope 0).Value).MyCommand.Path
Import-Module ("{0}\updater-functions.ps1" -f $currentPath)

$hostname = "HOSTNAME"
$password = "PASSWORD"
$url = "https://dyn.dns.he.net/nic/update?hostname={0}&password={1}" -f $hostname, $password

# To use a custom IP:
#$myip = @(Get-IPAddresses | where { $_ -match "10.25.6*" })[0]
#$url = "https://dyn.dns.he.net/nic/update?hostname={0}&password={1}&myip={2}" -f $hostname, $password, $myip

Ignore-SLL-Errors
UseUnsafeHeaderParsing

$wc = Get-Webclient
$wc.DownloadString($url)
