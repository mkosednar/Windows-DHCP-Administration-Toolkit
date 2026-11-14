[CmdletBinding()]
param(
    [Parameter()]
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'
Import-Module DhcpServer
$servers = Get-DhcpServerInDC | Select-Object DnsName, IPAddress

if (-not $OutputPath) {
    $reportDirectory = Join-Path $PSScriptRoot '..\..\Reports'
    New-Item -ItemType Directory -Path $reportDirectory -Force | Out-Null
    $OutputPath = Join-Path $reportDirectory ("DHCP-Authorized-Servers-{0:yyyyMMdd-HHmmss}.csv" -f (Get-Date))
}

$servers | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding UTF8
Write-Information "Exported $($servers.Count) authorized DHCP servers to $OutputPath" -InformationAction Continue
