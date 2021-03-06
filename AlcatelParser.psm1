###############################################################################
## Start Powershell Cmdlets
###############################################################################

###############################################################################
# Get-AlInterface

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
    
    HelperCheckForObject AlcatelSwitch "AlcatelParser.Switch"
    $Global:AlcatelSwitch.Interfaces = $ReturnObject
    
	return $ReturnObject
}

###############################################################################
# Get-AlRouterId

function Get-AlRouterId {
    [CmdletBinding()]
	<#
        .SYNOPSIS
            Gets Vlan Info from Alcatel Switch Configuration
	#>

	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[array]$Configuration
	)
	
	$VerbosePrefix = "Get-AlRouterId: "
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
			$EvalParams.Regex          = [regex] "^ip\ router\ router-id\ (?<id>$IpRx)"
			$Eval                      = HelperEvalRegex @EvalParams
			if ($Eval) {
                $ReturnObject = $Eval.Groups['id'].Value
			}
		} else {
			continue
		}
	}
    
    HelperCheckForObject AlcatelSwitch "AlcatelParser.Switch"
    $Global:AlcatelSwitch.RouterId = $ReturnObject

	return $ReturnObject
}

###############################################################################
# Get-AlSystemName

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
    
    HelperCheckForObject AlcatelSwitch "AlcatelParser.Switch"
    $Global:AlcatelSwitch.SystemName = $ReturnObject

	return $ReturnObject
}

###############################################################################
# Get-AlVlan

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
			$EvalParams.Regex          = [regex] '^vlan\ (?<start>\d+)(-(?<stop>\d+))?\ admin-state\ (?<state>\w+)'
			$Eval                      = HelperEvalRegex @EvalParams
			if ($Eval) {
                $Start = $Eval.Groups['start'].Value
                $Stop  = $Eval.Groups['stop'].Value
                
                if (!($Stop)) { $Stop = $Start }
                
                for ($i = [int]$Start; $i -le [int]$Stop; $i++) {
                    $NewObject        = New-Object AlcatelParser.Vlan
                    $NewObject.Id     = $i
                    $NewObject.State  = $Eval.Groups['state'].Value
                    $ReturnObject    += $NewObject
                    Write-Verbose "object created: $($NewObject.Id)"
                }
			}
			if ($NewObject) {
				
				###########################################################################################
				# Special Properties
				
				# Member Ports
				$EvalParams.Regex          = [regex] "^vlan\ (?<vlan>\d+)\ members\ (?<portstring>(port|linkagg)\ .+?)\ (?<tag>.+)"
				$Eval                      = HelperEvalRegex @EvalParams
				if ($Eval) {
                    $Lookup                = $ReturnObject | ? { $_.id -eq [int]($Eval.Groups['vlan'].Value) }
                    $Tag                   = $Eval.Groups['tag'].Value
                    $Lookup."$Tag`Members" = Resolve-AlPortString $Eval.Groups['portstring'].Value
				}
                
                # Names
				$EvalParams.Regex          = [regex] "^vlan\ (?<vlan>\d+)\ name\ `"(?<name>.+?)`""
				$Eval                      = HelperEvalRegex @EvalParams
				if ($Eval) {
                    $Lookup      = $ReturnObject | ? { $_.id -eq [int]($Eval.Groups['vlan'].Value) }
                    $Tag         = $Eval.Groups['tag'].Value
                    $Lookup.Name = $Eval.Groups['name'].Value
				}
                
				
				###########################################################################################
				# Regular Properties
				
				# Update eval Parameters for remaining matches
				$EvalParams.VariableToUpdate = ([REF]$NewObject)
				$EvalParams.ReturnGroupNum   = 1
				$EvalParams.LoopName         = 'fileloop'
			}
		} else {
			continue
		}
	}
    
    HelperCheckForObject AlcatelSwitch "AlcatelParser.Switch"
    $Global:AlcatelSwitch.Vlans = $ReturnObject
    
	return $ReturnObject
}

###############################################################################
# Resolve-AlPortString

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
    
    $PortStringRx = [regex] "((?<type>port|linkagg)\ )((?<module>(\d+\/)+)(?<start>\d+)(-(?<stop>\d+))?|(?<start>\d+)(-(?<stop>\d+)))"
    
    $Match        = $PortStringRx.Match($PortString)
    
    if ($Match.Success) {
        $Type   = $Match.Groups['type'].Value
        $Module = $Match.Groups['module'].Value
        $Start  = [int]($Match.Groups['start'].Value)
        $Stop   = [int]($Match.Groups['stop'].Value)
        
        switch ($Type) {
            'linkagg' {
                $Module = "0/"
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

###############################################################################
## Start Helper Functions
###############################################################################

###############################################################################
# HelperCheckForObject

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

###############################################################################
# HelperCloneCustomType

function HelperCloneCustomType {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True,Position=0)]
		[object]$Object,
		
		[Parameter(Mandatory=$False,Position=1)]
		[array]$AddProperties
	)
	
	$VerbosePrefix = "HelperCloneCustomType: "
	
	$Type         = $Object.GetType().FullName
	$Properties   = $Object | gm -Type *Property
	$ValidProperties = @()
	
	foreach ($p in $Properties) {
		$ValidProperties += "$($p.Name)"
	}
	
	if ($AddProperties) {
		$ValidProperties += ( $AddProperties | ? { $ValidProperties -notcontains $_ } )
	}
	
    Write-Verbose "$VerbosePrefix $($ValidProperties -join ',')"
    
	$ReturnObject = "" | Select $ValidProperties
	
	foreach ($p in $Properties) {
		$ReturnObject."$($p.Name)" = $Object."$($p.Name)"
	}
	
	return $ReturnObject
}

###############################################################################
# HelperDetectClassful

function HelperDetectClassful {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True,Position=0,ParameterSetName='RxString')]
		[ValidatePattern("(\d+\.){3}\d+")]
		[String]$IpAddress
	)
	
	$VerbosePrefix = "HelperDetectClassful: "
	
	$Regex = [regex] "(?x)
					  (?<first>\d+)\.
					  (?<second>\d+)\.
					  (?<third>\d+)\.
					  (?<fourth>\d+)"
						  
	$Match = HelperEvalRegex $Regex $IpAddress
	
	$First  = $Match.Groups['first'].Value
	$Second = $Match.Groups['second'].Value
	$Third  = $Match.Groups['third'].Value
	$Fourth = $Match.Groups['fourth'].Value
	
	$Mask = 32
	if ($Fourth -eq "0") {
		$Mask -= 8
		if ($Third -eq "0") {
			$Mask -= 8
			if ($Second -eq "0") {
				$Mask -= 8
			}
		}
	}
	
	return "$IpAddress/$([string]$Mask)"
}

###############################################################################
# HelperEvalRegex

function HelperEvalRegex {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True,Position=0,ParameterSetName='RxString')]
		[String]$RegexString,
		
		[Parameter(Mandatory=$True,Position=0,ParameterSetName='Rx')]
		[regex]$Regex,
		
		[Parameter(Mandatory=$True,Position=1)]
		[string]$StringToEval,
		
		[Parameter(Mandatory=$False)]
		[string]$ReturnGroupName,
		
		[Parameter(Mandatory=$False)]
		[int]$ReturnGroupNumber,
		
		[Parameter(Mandatory=$False)]
		$VariableToUpdate,
		
		[Parameter(Mandatory=$False)]
		[string]$ObjectProperty,
		
		[Parameter(Mandatory=$False)]
		[string]$LoopName
	)
	
	$VerbosePrefix = "HelperEvalRegex: "
	
	if ($RegexString) {
		$Regex = [Regex] $RegexString
	}
	
	if ($ReturnGroupName) { $ReturnGroup = $ReturnGroupName }
	if ($ReturnGroupNumber) { $ReturnGroup = $ReturnGroupNumber }
	
	$Match = $Regex.Match($StringToEval)
	if ($Match.Success) {
		#Write-Verbose "$VerbosePrefix Matched: $($Match.Value)"
		if ($ReturnGroup) {
			#Write-Verbose "$VerbosePrefix ReturnGroup"
			switch ($ReturnGroup.Gettype().Name) {
				"Int32" {
					$ReturnValue = $Match.Groups[$ReturnGroup].Value.Trim()
				}
				"String" {
					$ReturnValue = $Match.Groups["$ReturnGroup"].Value.Trim()
				}
				default { Throw "ReturnGroup type invalid" }
			}
			if ($VariableToUpdate) {
                $VariableToUpdate.Value.$ObjectProperty = $ReturnValue
                Write-Verbose "$ObjectProperty`: $ReturnValue"
                
				<#  I'm not sure why I ever did this, but I'm saving it just in case I remember.
                if ($VariableToUpdate.Value.$ObjectProperty) {
					#Property already set on Variable
					continue $LoopName
				} else {
					$VariableToUpdate.Value.$ObjectProperty = $ReturnValue
					Write-Verbose "$ObjectProperty`: $ReturnValue"
				}
                #>
                
				continue $LoopName
			} else {
				return $ReturnValue
			}
		} else {
			return $Match
		}
	} else {
		if ($ObjectToUpdate) {
			return
			# No Match
		} else {
			return $false
		}
	}
}

###############################################################################
# HelperTestVerbose

function HelperTestVerbose {
[CmdletBinding()]
param()
    [System.Management.Automation.ActionPreference]::SilentlyContinue -ne $VerbosePreference
}

###############################################################################
## Export Cmdlets
###############################################################################

Export-ModuleMember *-*
