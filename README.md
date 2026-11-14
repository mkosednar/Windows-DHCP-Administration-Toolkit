# Windows DHCP Administration Toolkit

A collection of practical PowerShell scripts for routine Windows Server DHCP inventory, lease reporting, and scope-capacity monitoring.

The scripts follow the numbered-folder style used by the other administration toolkits. Reports are written to a local `Reports` folder, which is excluded from version control because exports can contain client names, hardware addresses, and IP assignments.

## Requirements

- Windows PowerShell 5.1 or PowerShell 7 on Windows
- The DHCP Server role or RSAT DHCP Server tools with the `DhcpServer` module
- DHCP management permissions on the target server; read-only reports generally need only delegated read access

Check module availability:

```powershell
Get-Module -ListAvailable DhcpServer
Import-Module DhcpServer
```

## Project structure

### 01 – Scope Reporting
- `Get-DhcpScopeUtilization.ps1` – reports IPv4 scope configuration and utilization statistics.

### 02 – Lease Reporting
- `Export-DhcpScopeLeases.ps1` – exports leases for one explicitly selected IPv4 scope.

### 03 – Authorization Reporting
- `Get-DhcpAuthorizedServers.ps1` – lists DHCP servers authorized in Active Directory.

## Examples

Review scope utilization:

```powershell
.\01-Scope-Reporting\Get-DhcpScopeUtilization.ps1 -ComputerName 'dhcp01.example.com'
```

Export active leases from a scope:

```powershell
.\02-Lease-Reporting\Export-DhcpScopeLeases.ps1 -ComputerName 'dhcp01.example.com' -ScopeId '10.0.10.0'
```

Include expired, offered, or declined lease records when investigating an address:

```powershell
.\02-Lease-Reporting\Export-DhcpScopeLeases.ps1 -ComputerName 'dhcp01.example.com' -ScopeId '10.0.10.0' -AllLeases
```

List authorized DHCP servers:

```powershell
.\03-Authorization-Reporting\Get-DhcpAuthorizedServers.ps1
```

## Safety and privacy

- These examples are read-only. They do not create scopes, alter options, activate/deactivate scopes, or remove leases.
- Review scripts and test them in a non-production environment before operational use.
- Lease exports contain client identifiers and IP address assignments. Store reports securely and do not commit them.
- Use a least-privilege account and specify the intended server and scope explicitly.

## Language

Documentation, code comments, and user-facing messages are maintained in English for consistency with the other toolkits.

## License

No open-source license has been selected for this project yet. Until a license is added, use, modification, and redistribution are not automatically permitted.

## Microsoft Learn

- [Get-DhcpServerv4Scope](https://learn.microsoft.com/powershell/module/dhcpserver/get-dhcpserverv4scope)
- [Get-DhcpServerv4ScopeStatistics](https://learn.microsoft.com/powershell/module/dhcpserver/get-dhcpserverv4scopestatistics)
- [Get-DhcpServerv4Lease](https://learn.microsoft.com/powershell/module/dhcpserver/get-dhcpserverv4lease)
