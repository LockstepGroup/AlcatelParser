function Get-AlSystemName {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            Gets Vlan Info from Alcatel Switch Configuration
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$Configuration
	)
	
	$VerbosePrefix = "Get-AlSystemName: "
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
		
		$Regex = [regex] "^!\ Chassis:"
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
			$EvalParams.Regex          = [regex] "^system\ name\ `"(?<name>.+?)`""
			$Eval                      = HelperEvalRegex @EvalParams
			if ($Eval) {
                $ReturnObject = $Eval.Groups['name'].Value
			}
		} else {
			continue
		}
	}	
	return $ReturnObject
}