$currentPath=Split-Path ((Get-Variable MyInvocation -Scope 0).Value).MyCommand.Path
Import-Module ("{0}\updater-functions.ps1" -f $currentPath)

$hostname = "HOSTNAME (fqdn)"
$password = "PASSWORD"
$url = "https://dyn.dns.he.net/nic/update?hostname={0}&password={1}" -f $hostname, $password

$regkey = 'HKCU:\Software\bennettp123\dns.he.updater'

# get oldip from registry
$oldip = $( (Get-ItemProperty -path $regkey).oldip 2>$null )
if (-not $oldip) { $oldip = "UNKNOWN"; }

Ignore-SLL-Errors
UseUnsafeHeaderParsing
$wc = Get-Webclient

# get newip from checkip.dns.he.net
$regex = 'Your (Proxy)? IPaddress is : ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})\(via ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})\)?'
$myip = $( $wc.DownloadString("http://checkip.dns.he.net") | ForEach-Object {
  if ($_ -match $regex) {
    if ($matches[4]) { $matches[4]; } else { $matches[3]; }
  }
})

# or, to use a custom IP:
#$myip = @(Get-IPAddresses | where { $_ -match "10.25.64.*" })[0]
#$url = "https://dyn.dns.he.net/nic/update?hostname={0}&password={1}&myip={2}" -f $hostname, $password, $myip

# quit if oldip == newip
if ($myip -eq $oldip) { exit 0; }

# send newip to dyn.dns.he.net; save to registry if successful
$wc.DownloadString($url) | ForEach-Object {
  if ($_ -match '(good|nochg) (.*)') { $matches[2]; }
} | ForEach-Object { 
  New-Item -Path $regkey -Type directory -Force
  Set-ItemProperty -path $regkey -name oldip -value $_ 
} >$null 2>&1
