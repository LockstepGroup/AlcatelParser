function Resolve-AlPortString {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            Resolves an Alcatel PortString to an array of individual ports.
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[string]$PortString
	)
	$VerbosePrefix = "Resolve-AlPortString: "
	
    $ReturnObject = @()
    
    $PortStringRx = [regex] "((?<type>port|linkagg)\ )((?<module>(\d+\/)+)(?<start>\d+)(-(?<stop>\d+))?|\d+)"
    
    $Match        = $PortStringRx.Match($PortString)
    
    if ($Match.Success) {
        $Type   = $Match.Groups['type'].Value
        $Module = $Match.Groups['module'].Value
        $Start  = [int]($Match.Groups['start'].Value)
        $Stop   = [int]($Match.Groups['stop'].Value)
        
        switch ($Type) {
            'linkagg' {
                $Module = "0"
            }
            'port' { 
            }
        }
        
        if ($Stop) {
            for ($i = $Start; $i -le $Stop; $i++) {
                $ReturnObject += "$Module$i"
            }
        } else {
            $ReturnObject += "$Module$Start"
        }
    }
    
	return $ReturnObject
}