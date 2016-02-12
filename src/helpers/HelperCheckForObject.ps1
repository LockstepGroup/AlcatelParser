function HelperCheckForObject {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[string]$ObjectName,
        
        [Parameter(Mandatory=$True,Position=1)]
		[string]$ObjectType
	)
	
	$VerbosePrefix = "HelperCheckForObject: "
    
    try {
        $Check = Get-Variable -Name $ObjectName -Scope global -ErrorAction stop
    } catch {
        Set-Variable -Name $ObjectName -Scope global -Value (New-Object -Type $ObjectType)
    }
}