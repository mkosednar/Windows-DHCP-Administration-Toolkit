[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$ComputerName,

    [Parameter()]
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'
Import-Module DhcpServer

$scopes = Get-DhcpServerv4Scope -ComputerName $ComputerName
$statistics = Get-DhcpServerv4ScopeStatistics -ComputerName $ComputerName
$statisticsByScope = @{}
foreach ($statistic in $statistics) {
    $statisticsByScope[[string]$statistic.ScopeId] = $statistic
}

$rows = foreach ($scope in $scopes) {
    $statistic = $statisticsByScope[[string]$scope.ScopeId]
    [pscustomobject]@{
        Server            = $ComputerName
        ScopeId           = $scope.ScopeId
        Name              = $scope.Name
        State             = $scope.State
        StartRange        = $scope.StartRange
        EndRange          = $scope.EndRange
        SubnetMask        = $scope.SubnetMask
        LeaseDuration     = $scope.LeaseDuration
        InUse             = $statistic.InUse
        Free              = $statistic.Free
        PercentageInUse   = $statistic.PercentageInUse
        PendingOffers     = $statistic.PendingOffers
    }
}

if (-not $OutputPath) {
    $reportDirectory = Join-Path $PSScriptRoot '..\..\Reports'
    New-Item -ItemType Directory -Path $reportDirectory -Force | Out-Null
    $safeServer = $ComputerName -replace '[^a-zA-Z0-9._-]', '_'
    $OutputPath = Join-Path $reportDirectory ("DHCP-Scope-Utilization-{0}-{1:yyyyMMdd-HHmmss}.csv" -f $safeServer, (Get-Date))
}

$rows | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding UTF8
Write-Information "Exported utilization for $(@($rows).Count) IPv4 scopes on '$ComputerName' to $OutputPath" -InformationAction Continue
