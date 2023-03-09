#! /usr/bin/pwsh

Describe "Replace-Token unit tests" {
	BeforeAll {
		$replaceTokenParams = @{
			SourcePath    = "$PSScriptRoot/resource_group.tfvars"
			UniversalPath = "$PSScriptRoot/tokens.json"
			InstancePath  = "$PSScriptRoot/tokens.dev.json"
		}

		$originalContent = Get-Content -Path $replaceTokenParams.SourcePath -Raw
		Import-Module $PSScriptRoot/Token-Helper.psm1 -Force
	}

	Context "Merge-Variable" {
		BeforeAll {
			$mergeVariableParams = @{
				UniversalPath = $replaceTokenParams.UniversalPath
				InstancePath  = $replaceTokenParams.InstancePath
			}
		}

		It "Should throw if UniversalPath is invalid" {
			$mergeVariableParams.UniversalPath = "$PSScriptRoot/fake.json"
			{ Merge-Variable @mergeVariableParams } | Should -Throw
		}

		It "Should throw if InstancePath is invalid" {
			$mergeVariableParams.UniversalPath = $replaceTokenParams.UniversalPath
			$mergeVariableParams.InstancePath = "$PSScriptRoot/fake.json"
			{ Merge-Variable @mergeVariableParams } | Should -Throw
		}

		It "Should Add instance variables to universal variables" {
			$mergeVariableParams.InstancePath = $replaceTokenParams.InstancePath
			$tokens = Merge-Variable @mergeVariableParams
			$tokens.env | Should -Be "dev"
		}

		It "Should override universal variables with instance variables" {
			$tokens = Merge-Variable @mergeVariableParams
			$tokens.location | Should -Be "eastus2"
		}

		It "Should output a hashtable" {
			$tokens = Merge-Variable @mergeVariableParams
			$tokens | Should -BeOfType "Hashtable"
		}
	}

	Context "Get-TokenCount" {
		It "Should accurately count the number of tokens" {
			$line = "This is a %test%.  I repeat, this is only a %test%"
			$count = Get-TokenCount -Line $line
			$count | Should -Be 2
		}

		It "Should return 0 if line is empty" {
			$line = ""
			$count = Get-TokenCount -Line $line
			$count | Should -Be 0
		}
	}

	Context "Script Logic" {
		It "Should replace all tokens with values" {
			& $PSScriptRoot/Replace-Token.ps1 @replaceTokenParams
			$newContent = Get-Content -Path $replaceTokenParams.SourcePath -Raw
			$tokenCount = (Select-String -InputObject $newContent -Pattern "\%\w{1,}\%" -AllMatches).Matches.Count
			$tokenCount | Should -Be 0
		}

		AfterAll {
			Set-Content -Path $replaceTokenParams.SourcePath -Value $originalContent -NoNewline
		}
	}
}
