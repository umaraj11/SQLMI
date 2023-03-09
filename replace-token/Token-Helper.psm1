function Merge-Variable {
	param
	(
		[Parameter(Mandatory)]
		[string] $UniversalPath,

		[Parameter(Mandatory)]
		[string] $InstancePath
	)

	if ((Test-Path $UniversalPath) -eq $true) {
		$universalObject = ConvertFrom-Json -InputObject (Get-Content -Path $UniversalPath -Raw)
		$universalVariables = $universalObject.variables
	}
	else {
		throw "'$UniversalPath' is not a valid value for the parameter 'UniversalPath'"
	}

	$mergeProperties = @()
	if ((Test-Path $InstancePath) -eq $true) {
		$instanceObject = ConvertFrom-Json -InputObject (Get-Content -Path $InstancePath -Raw)
		$mergeProperties += $instanceObject.psobject.Properties
	}
	else {
		throw "'$InstancePath' is not a valid value for the parameter 'InstancePath'"
	}

	foreach ($property in $mergeProperties) {
		Add-Member -InputObject $universalVariables -MemberType $property.MemberType -Name $property.Name -Value $property.Value -Force
	}

	$universalObject.variables = $universalVariables

	$mergedObject = ConvertTo-Json -InputObject $universalObject -Depth 20
	return (ConvertFrom-Json -InputObject $mergedObject -AsHashtable).variables
}

function Get-TokenCount {
	param
	(
		[Parameter(Mandatory)]
		[AllowEmptyString()]
		[string] $Line,

		[string] $Pattern = "\%\w{1,}\%"
	)

	if ($Line) {
		(Select-String -InputObject $Line -Pattern $Pattern -AllMatches).Matches.Count
	}
	else {
		0
	}
}
