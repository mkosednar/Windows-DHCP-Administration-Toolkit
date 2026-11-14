[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$ComputerName,

    [Parameter(Mandatory)]
    [System.Net.IPAddress]$ScopeId,

    [Parameter()]
    [switch]$AllLeases,

    [Parameter()]
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'
Import-Module DhcpServer
$leaseParameters = @{ ComputerName = $ComputerName; ScopeId = $ScopeId }
if ($AllLeases) { $leaseParameters.AllLeases = $true }

$leases = Get-DhcpServerv4Lease @leaseParameters | Select-Object -Property @(
    @{ Name = 'Server'; Expression = { $ComputerName } },
    'ScopeId', 'IPAddress', 'ClientId', 'HostName', 'AddressState',
    'LeaseExpiryTime', 'ClientType', 'DnsRegistration'
)

if (-not $OutputPath) {
    $reportDirectory = Join-Path $PSScriptRoot '..\..\Reports'
    New-Item -ItemType Directory -Path $reportDirectory -Force | Out-Null
    $safeServer = $ComputerName -replace '[^a-zA-Z0-9._-]', '_'
    $safeScope = $ScopeId.ToString() -replace '[^a-zA-Z0-9._-]', '_'
    $OutputPath = Join-Path $reportDirectory ("DHCP-Leases-{0}-{1}-{2:yyyyMMdd-HHmmss}.csv" -f $safeServer, $safeScope, (Get-Date))
}

$leases | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding UTF8
Write-Information "Exported $(@($leases).Count) lease records for scope '$ScopeId' on '$ComputerName' to $OutputPath" -InformationAction Continue
