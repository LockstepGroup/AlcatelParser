function Get-AlVlan {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            Gets Vlan Info from Alcatel Switch Configuration
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$Configuration
	)
	
	$VerbosePrefix = "Get-AlVlan: "
	
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
		
		$Regex = [regex] "^!\ VLAN:"
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
			$EvalParams.Regex          = [regex] '^vlan\ (?<id>\d+)\ admin-state\ (?<state>\w+)'
			$Eval                      = HelperEvalRegex @EvalParams
			if ($Eval) {
				$NewObject        = New-Object AlcatelParser.Vlan
				$NewObject.Id     = $Eval.Groups['id'].Value
                $NewObject.State  = $Eval.Groups['state'].Value
				$ReturnObject    += $NewObject
				Write-Verbose "object created: $($NewObject.Id)"
                
                $Vlan = $Eval.Groups['id'].Value
			}
			if ($NewObject) {
				
				###########################################################################################
				# Special Properties
				
				# Member Ports
				$EvalParams.Regex          = [regex] "^vlan\ $Vlan`\ members\ (?<portstring>(port|linkagg)\ .+?)\ (?<tag>.+)"
				$Eval                      = HelperEvalRegex @EvalParams
				if ($Eval) {
                    $Tag = $Eval.Groups['tag'].Value
                    $NewObject."$Tag`Members" = Resolve-AlPortString $Eval.Groups['portstring'].Value
				}
                
				
				###########################################################################################
				# Regular Properties
				
				# Update eval Parameters for remaining matches
				$EvalParams.VariableToUpdate = ([REF]$NewObject)
				$EvalParams.ReturnGroupNum   = 1
				$EvalParams.LoopName         = 'fileloop'
					
				# Name
				$EvalParams.Regex          = [regex] "^vlan\ $Vlan`\ name\ `"(.+?)`""
				$EvalParams.ObjectProperty = "Name"
				$Eval                      = HelperEvalRegex @EvalParams
			}
		} else {
			continue
		}
	}	
	return $ReturnObject
}