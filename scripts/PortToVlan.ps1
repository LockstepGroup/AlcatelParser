[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False,Position=0)]
    [ValidateScript({Test-Path $_})]
	[string]$ConfigFile
)

try {
    ipmo AlcatelParser -ErrorAction Stop
} catch {
    Throw "AlcatelParser Module not found"
}

$Config     = gc $ConfigFile

$Vlans = Get-AlVlan $Config

$VlanIds = @()
$Ports   = @()
foreach ($v in $Vlans) {
    $VlanIds += $v.Id
    $Ports   += $v.UntaggedMembers
    $Ports   += $v.TaggedMembers
}

$Ports     = $Ports | Select -Unique
$SwitchNum = @{Expression={if ($_ -match '^(\d+)(\/\d+)+') {[int]$Matches[1]}}; Ascending=$true}
$ModuleNum = @{Expression={if ($_ -match '^\d+\/(\d+)') {[int]$Matches[1]}}; Ascending=$true}
$PortNum   = @{Expression={if ($_ -match '^\d+\/\d+\/(\d+)') {[int]$Matches[1]}}; Ascending=$true}
$Ports     = $Ports | Sort-Object -Property $SwitchNum,$ModuleNum,$PortNum

$PortToVlan = @()
foreach ($p in $Ports) {
    $NewObject           = "" | Select Port,Untagged,Tagged
    $NewObject.Port      = $p
    $NewObject.Untagged  = ($Vlans | ? { $_.UntaggedMembers -contains $p }).Id
    $NewObject.Tagged    = ($Vlans | ? { $_.TaggedMembers   -contains $p }).Id
    $PortToVlan += $NewObject
}

return $PortToVlan