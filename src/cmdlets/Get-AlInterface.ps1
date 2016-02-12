function Get-AlInterface {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            Gets Vlan Info from Alcatel Switch Configuration
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$Configuration
	)
	
	$VerbosePrefix = "Get-AlInterface: "
    $IpRx = [regex] "(\d+\.){3}\d+"
	
	$TotalLines = $Configuration.Count
	$i          = 0 
	$StopWatch  = [System.Diagnostics.Stopwatch]::StartNew() # used by Write-Progress so it doesn't slow the whole function down
	
	$ReturnObject = @()
	
	:fileloop foreach ($line in $Configuration) {
		$i++
		
		# Write progress bar, we're only updating every 1000ms, if we do it every line it takes forever
		
		if ($StopWatch.Elapsed.TotalMilliseconds -ge 1000) {
			$PercentComplete = [math]::truncate($i / $TotalLines * 100)
	        Write-Progress -Activity "Reading Support Output" -Status "$PercentComplete% $i/$TotalLines" -PercentComplete $PercentComplete
	        $StopWatch.Reset()
			$StopWatch.Start()
		}
		
		if ($line -eq "") { continue }
		
		###########################################################################################
		# Section Start
		
		$Regex = [regex] "^!\ IP:"
		$Match = HelperEvalRegex $Regex $line
		if ($Match) {
			$Section = $true
			Write-Verbose "Section started"
		}
		
		if ($Section) {
			#Write-Verbose $line
			###########################################################################################
			# End of Section
			$Regex = [regex] '^$'
			$Match = HelperEvalRegex $Regex $line
			if ($Match) {
				$NewObject = $null
				break
			}
			
			###########################################################################################
			# Bool Properties and Properties that need special processing
			# Eval Parameters for this section
			$EvalParams              = @{}
			$EvalParams.StringToEval = $line
			
			
			# New Object
			$EvalParams.Regex          = [regex] "^ip\ interface\ `"(?<name>.+?)`"\ address\ (?<ip>$IpRx)\ mask\ (?<mask>$IpRx)\ vlan\ (?<vlan>\d+)\ ifindex\ (?<ifindex>\d+)"
            #ip interface "OSPF_243" address 10.243.1.254 mask 255.255.0.0 vlan 243 ifindex 1
			$Eval                      = HelperEvalRegex @EvalParams
			if ($Eval) {
                $NewObject            = New-Object AlcatelParser.Interface
                $NewObject.Name       = $Eval.Groups['name'].Value
                $NewObject.IpAddress  = $Eval.Groups['ip'].Value
                $NewObject.IpAddress += "/" + (ConvertTo-MaskLength $Eval.Groups['mask'].Value)
                $NewObject.Vlan       = $Eval.Groups['vlan'].Value
                $NewObject.ifIndex    = $Eval.Groups['ifindex'].Value
                $ReturnObject        += $NewObject
			}
		} else {
			continue
		}
	}	
	return $ReturnObject
}