﻿@{
    RootModule= 'SHiPS.psm1'
    ModuleVersion = '0.8.0'
    GUID = 'd8f30f8e-191e-4d48-b66b-d6a1bfb79604'
    Author = 'Microsoft Corporation'
    CompanyName = 'Microsoft Corporation'
    Copyright = '© Microsoft Corporation. All rights reserved.'
    Description = 'SHiPS is a PowerShell provider. More accurately it is a provider platform that simplifies developing PowerShell providers.'
    PowerShellVersion = '5.0'

    FormatsToProcess = @( 'SHiPS.formats.ps1xml' )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    DscResourcesToExport = @()

    PrivateData = @{
        PSData = @{
            Tags = @('SHiPS', 'PSEdition_Core', 'PSEdition_Desktop', 'Linux', 'Mac')
            ProjectUri = 'https://github.com/PowerShell/SHiPS'
            ReleaseNotes = @'
## 0.6.0
* Fixed Test-Path cmdlet
* Updated SHiPS to build with .NET Core 2.0.5 to be in sync with pwsh
* Fixed SHiPS formats.ps1xml

## 0.7.0
* Fixed forward slash issue on Linux
* Fixed Set-Location drive: path issue on Linux

## 0.7.1
* Perf improvement. For providers using cached data, [SHiPSProvider(UseCache=$true)], 'dir -force' will only refresh the last node in the path.
* Allowed to navigate home directory, e.g., 'dir ~' or 'cd ~' under SHiPS based provider drive.
## 0.7.2
* Bug fix for 'dir -force' case

## 0.8.0
* Add support for GetContent for folders and files

'@
        }
    }
}
