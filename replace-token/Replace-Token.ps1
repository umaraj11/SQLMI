#! /usr/bin/pwsh

<#
.SYNOPSIS
	Replaces tokens in parameter files

.DESCRIPTION
	This script uses the Merge-Variable and Get-Token functions in Token-Helper.psm1 to combine universal and instance tokens,
	replace	all occurences of each provided token for every file contained in the folder specified by the value passed to the
	SourcePath parameter and provide a count for the total number of tokens found in a file, as well as
	the number of tokens that were successfully replaced

.PARAMETER SourcePath
	The path to the folder, which contains the parameter files with token references

.PARAMETER UniversalPath
	The path to the JSON token file with the tokens that apply to each environment

.PARAMETER InstancePath
	The path to the JSON token file with the instance specific tokens

.PARAMETER StartPattern
	The pattern that denotes the beginning of a token

.PARAMETER EndPattern
	The pattern that denotes the end of a token

.EXAMPLE
	$replaceTokenParams = @{
		SourcePath    = "dev"
		UniversalPath = "Tokens/tokens.json"
		InstancePath  = "Tokens/tokens.dev.json"
	}

	PS C:\> Replace-Token @replaceTokenParams

	This command replaces all token references in a folder named 'dev' with tokens used by combining the values in 'Tokens/tokens.json'
	and 'Tokens/tokens.dev.json'

.NOTES
	If a token is specified in a tfvars file, for which no token value has been provided, the script will throw an error and break
	the build

	When a token is specified in both the universal and instance files, the instance value overrides the universal
	value

	If either the UniversalPath or InstancePath are invalid, an error will be thrown
#>

param
(
	[Parameter(Mandatory)]
	[string] $SourcePath,

	[Parameter(Mandatory)]
	[string] $UniversalPath,

	[Parameter(Mandatory)]
	[string] $InstancePath,

	[string] $StartPattern = "%",

	[string] $EndPattern = "%"
)

Import-Module $PSScriptRoot/Token-Helper.psm1

$Error.Clear()

$tokens = Merge-Variable -UniversalPath $UniversalPath -InstancePath $InstancePath

Out-Host -InputObject $tokens

Write-Host "Replacing tokens..."
foreach ($file in (Get-ChildItem -Path $SourcePath)) {
	$tempFile = [System.IO.Path]::GetTempFileName()
	$oldContent = $null
	$oldContent = Get-Content -Path $file
	$totalTokens = 0
	$missedTokens = 0
	$oldContent | ForEach-Object {
		$line = $_
		$totalTokens += Get-TokenCount -Line $line
		foreach ($key in $tokens.Keys) {
			$token = "${StartPattern}${key}${EndPattern}"
			$value = $tokens.$key
			if ($line -match $token) {
				$line = $line -replace "$token", "$value"
			}
		}

		$missedTokens += Get-TokenCount -Line $line
		Out-File -InputObject $line -Append -FilePath $tempFile
	}

	$fileContent = (Get-Content $tempFile)
	if (($totalTokens -gt 0) -and ($missedTokens -eq 0)) {
		Set-Content -Path $file -Value $fileContent
	}

	$message = "Processed: $($InputFile) ($($totalTokens - $missedTokens) out of $totalTokens tokens replaced) in '$($file.Name)'"
	if ($missedTokens -gt 0) {
		$fileContent
		Write-Host ""
		Write-Error $message
		Write-Host "_____________________________________________________"
	}
	else {
		Write-Host $message
		Write-Host "________________________________________"
		$fileContent

		Write-Host ""
	}
}

if ($Error.Count -gt 0) {
	$LASTEXITCODE = 1
}
