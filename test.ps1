
1.  13:19:38.712  Masina nimi (hostname): KALLASTE-W11
1.  13:19:38.733  PowerShelli versioon: 5.1.26100.7019
1.  13:19:38.749  Windowsi versioon: Microsoft Windows 11 Pro Education (Version 10.0.26100, Build 26100)
2.  13:19:38.964  Võrgu konfiguratsioon (IP, mask, gateway, DHCP, MAC): @{Description=Intel(R) PRO/1000 MT Desktop Adapter; IPAddress=10.0.2.15, fe80::f8ae:103c:ed4f:e745, fd17:625c:f037:2:b1b8:726:deaa:4e7f, fd17:625c:f037:2:e1c8:515f:d042:d122; IPSubnet=255.255.255.0, 64, 128, 64; DefaultGateway=10.0.2.2, fe80::2; DHCPEnabled=True; MACAddress=08:00:27:D8:1D:14}
3.  13:19:43.648  Protsessori kirjeldus: Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz
3.  13:19:43.663  RAM kogus (GB): 3.98
4.  13:19:43.907  Graafikakaardi info (nimi, driver, kuupäev, lahutus):

Name                            DriverVersion DriverDate CurrentResolution
----                            ------------- ---------- -----------------
Microsoft Basic Display Adapter 10.0.26100.1  21.06.2006 1024x768         



5.  13:19:44.872  Ketta/partitsioonide info (partitsioonitabel):

DiskModel     DiskSizeGB Partition             PartType             PartSizeGB
---------     ---------- ---------             --------             ----------
VBOX HARDDISK          1 Disk #1, Partition #0 Logical Disk Manager          1
VBOX HARDDISK      63,99 Disk #0, Partition #0 GPT: System                 0,1
VBOX HARDDISK      63,99 Disk #0, Partition #1 GPT: Basic Data           63,17
VBOX HARDDISK      63,99 Disk #0, Partition #2 GPT: Unknown               0,72
VBOX HARDDISK          1 Disk #2, Partition #0 Logical Disk Manager          1



5.  13:19:44.909  Ketta kogumaht (GB, kõik kohalikud kettad kokku): 64.16
5.  13:19:44.931  Vaba ruum kettal C: (GB): 38.02
6.  13:19:49.319  PCI seadmete driveri info (kirjeldus, tootja, versioon):

Description                          Manufacturer                     DriverVersion  
-----------                          ------------                     -------------  
Standard SATA AHCI Controller        Standard SATA AHCI Controller    10.0.26100.7019
USB xHCI Compliant Host Controller   Generic USB xHCI Host Controller 10.0.26100.7019
High Definition Audio Controller     Microsoft                        10.0.26100.7019
VirtualBox Guest Device              Oracle Corporation               7.2.2.20484    
Intel(R) PRO/1000 MT Desktop Adapter Intel                            8.4.13.0       
Microsoft Basic Display Adapter      (Standard display types)         10.0.26100.1   
PCI to ISA Bridge                    Intel                            10.0.26100.1150
CPU to PCI Bridge                    Intel                            10.0.26100.1150



7.  13:19:49.553  Arvutis olevad kasutajad (nimi, kirjeldus, LocalAccount, Disabled):

Name               Description                                                           
----               -----------                                                           
Administrator      Built-in account for administering the computer/domain                
DefaultAccount     A user account managed by the system.                                 
Guest              Built-in account for guest access to the computer/domain              
Joosep                                                                                   
WDAGUtilityAccount A user account managed and used by the system for Windows Defender ...



8.  13:19:49.610  Käimasolevate protsesside arv: 158
9.  13:19:49.827  10 viimasena käivitatud protsessi (Name, PID, StartTime):

Name     PID StartTime          
----     --- ---------          
svchost 1748 24.12.2025 13:19:37
sppsvc  9256 24.12.2025 13:19:14
svchost 9888 24.12.2025 13:18:55
firefox 9500 24.12.2025 13:18:45
firefox 9492 24.12.2025 13:18:45
firefox 9484 24.12.2025 13:18:45
firefox 3880 24.12.2025 13:18:31
firefox 7740 24.12.2025 13:18:21
firefox 7008 24.12.2025 13:18:19
firefox 2360 24.12.2025 13:18:16



10.  13:19:49.854  Arvuti kuupäev ja kellaaeg: 24.12.2025 13:19:49

```
# -------------------------------------------
# Väljundi abifunktsioon (alus.ps1 loogika)
# -------------------------------------------
function valjasta {
    param([string]$nr, [string]$param, $sisu)

    $fail = ".\tulemus.txt"
    $aeg  = Get-Date -Format "HH:mm:ss.fff"

    if ($null -eq $sisu) {
        $rida = "$nr.  $aeg  ${param}: NULL"
        Write-Output $rida
        $rida | Out-File -FilePath $fail -Append -Encoding UTF8
    }
    elseif ($sisu.GetType().Name -eq "Object[]") {
        $rida = "$nr.  $aeg  ${param}:"
        Write-Output $rida
        $rida | Out-File -FilePath $fail -Append -Encoding UTF8
        $txt = $sisu | Format-Table -AutoSize | Out-String
        Write-Output $txt
        $txt | Out-File -FilePath $fail -Append -Encoding UTF8
    }
    else {
        $rida = "$nr.  $aeg  ${param}: $sisu"
        Write-Output $rida
        $rida | Out-File -FilePath $fail -Append -Encoding UTF8
    }
}

# Puhastame vana tulemuse (et iga jooks ei kuhjaks)
Remove-Item ".\tulemus.txt" -ErrorAction SilentlyContinue

# -------------------------------------------
# 1) Hostname, PowerShelli versioon, Windowsi versioon
# -------------------------------------------
$hostName = $env:COMPUTERNAME
$psVer    = $PSVersionTable.PSVersion.ToString()

# Windowsi versioon (korralik, mitte ainult build)
$os = Get-CimInstance Win32_OperatingSystem
$winVer = "$($os.Caption) (Version $($os.Version), Build $($os.BuildNumber))"

valjasta 1 "Masina nimi (hostname)" $hostName
valjasta 1 "PowerShelli versioon" $psVer
valjasta 1 "Windowsi versioon" $winVer

# -------------------------------------------
# 2) Võrgu konfiguratsioon: IP, mask, gateway, DHCP, MAC
#    (valime kõik IPEnabled adapterid ja väljastame objektid)
# -------------------------------------------
$net = Get-CimInstance Win32_NetworkAdapterConfiguration -Filter "IPEnabled=True" |
    ForEach-Object {
        [PSCustomObject]@{
            Description     = $_.Description
            IPAddress       = ($_.IPAddress -join ", ")
            IPSubnet        = ($_.IPSubnet -join ", ")
            DefaultGateway  = ($_.DefaultIPGateway -join ", ")
            DHCPEnabled     = $_.DHCPEnabled
            MACAddress      = $_.MACAddress
        }
    }

valjasta 2 "Võrgu konfiguratsioon (IP, mask, gateway, DHCP, MAC)" $net

# -------------------------------------------
# 3) Protsessori kirjeldus ja RAM kogus (Win32_ComputerSystem)
# -------------------------------------------
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$cs  = Get-CimInstance Win32_ComputerSystem
$ramGB = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)

valjasta 3 "Protsessori kirjeldus" $cpu.Name
valjasta 3 "RAM kogus (GB)" $ramGB

# -------------------------------------------
# 4) Graafikakaart: nimi, draiveri versioon, kuupäev, ekraani lahutus
#    (Win32_VideoController)
# -------------------------------------------
$gpu = @(Get-CimInstance Win32_VideoController | ForEach-Object {
    $dd = $null
    if ($_.DriverDate -is [datetime]) {
        $dd = $_.DriverDate.ToString("dd.MM.yyyy")
    }
    elseif ($_.DriverDate) {
        try { $dd = ([Management.ManagementDateTimeConverter]::ToDateTime($_.DriverDate)).ToString("dd.MM.yyyy") }
        catch { $dd = "$($_.DriverDate)" }
    }

    [PSCustomObject]@{
        Name              = $_.Name
        DriverVersion     = $_.DriverVersion
        DriverDate        = $dd
        CurrentResolution = if ($_.CurrentHorizontalResolution -and $_.CurrentVerticalResolution) {
            "$($_.CurrentHorizontalResolution)x$($_.CurrentVerticalResolution)"
        } else { $null }
    }
})

valjasta 4 "Graafikakaardi info (nimi, driver, kuupäev, lahutus)" $gpu

# -------------------------------------------
# 5) Kõvaketas: partitsioonitabel + kogu maht (GB) + vaba ruum C:
# -------------------------------------------
# Partitsioonide/diskide ülevaade (WMI/CIM)
$diskInfo = Get-CimInstance Win32_DiskDrive |
    ForEach-Object {
        $disk = $_
        # Seosed partitsioonidega (ASSOCIATORS)
        $parts = @(Get-CimAssociatedInstance -InputObject $disk -Association Win32_DiskDriveToDiskPartition -ErrorAction SilentlyContinue)
        if ($parts.Count -eq 0) {
            [PSCustomObject]@{
                DiskModel = $disk.Model
                DiskSizeGB = [math]::Round($disk.Size / 1GB, 2)
                Partitions = "NULL"
            }
        } else {
            $parts | ForEach-Object {
                [PSCustomObject]@{
                    DiskModel   = $disk.Model
                    DiskSizeGB  = [math]::Round($disk.Size / 1GB, 2)
                    Partition   = $_.Name
                    PartType    = $_.Type
                    PartSizeGB  = [math]::Round($_.Size / 1GB, 2)
                }
            }
        }
    }

# Kogu maht (summa kõigist kohalikest ketastest)
$logical = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
$totalGB = [math]::Round((($logical | Measure-Object -Property Size -Sum).Sum) / 1GB, 2)

# C: vaba ruum
$c = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$cFreeGB = $null
if ($c) { $cFreeGB = [math]::Round($c.FreeSpace / 1GB, 2) }

valjasta 5 "Ketta/partitsioonide info (partitsioonitabel)" $diskInfo
valjasta 5 "Ketta kogumaht (GB, kõik kohalikud kettad kokku)" $totalGB
valjasta 5 "Vaba ruum kettal C: (GB)" $cFreeGB

# -------------------------------------------
# 6) PCI seadmete driverite info: kirjeldus, tootja, versioon
# -------------------------------------------
$pciDrivers = Get-CimInstance Win32_PnPSignedDriver |
    Where-Object { $_.DeviceID -like "PCI*" } |
    Select-Object -First 50 |  # et väljund liiga metsikuks ei lähe; soovi korral eemalda
    ForEach-Object {
        [PSCustomObject]@{
            Description   = $_.DeviceName
            Manufacturer  = $_.Manufacturer
            DriverVersion = $_.DriverVersion
        }
    }

valjasta 6 "PCI seadmete driveri info (kirjeldus, tootja, versioon)" $pciDrivers

# -------------------------------------------
# 7) Kasutajad: nimi, kirjeldus, LocalAccount, Disabled
# -------------------------------------------
$users = Get-CimInstance Win32_UserAccount |
    Where-Object { $_.LocalAccount -eq $true } |
    ForEach-Object {
        [PSCustomObject]@{
            Name         = $_.Name
            Description  = $_.Description
            LocalAccount = $_.LocalAccount
            Disabled     = $_.Disabled
        }
    }

valjasta 7 "Arvutis olevad kasutajad (nimi, kirjeldus, LocalAccount, Disabled)" $users

# -------------------------------------------
# 8) Käimasolevate protsesside arv
# -------------------------------------------
$procCount = (Get-Process).Count
valjasta 8 "Käimasolevate protsesside arv" $procCount

# -------------------------------------------
# 9) 10 viimasena käivitatud protsessi (nimi, PID, StartTime), sort StartTime
#    (StartTime võib nõuda admin õigusi; filtreerime NULL välja)
# -------------------------------------------
$last10 = Get-Process |
    Select-Object ProcessName, Id, StartTime |
    Where-Object { $_.StartTime -ne $null } |
    Sort-Object StartTime -Descending |
    Select-Object -First 10 |
    ForEach-Object {
        [PSCustomObject]@{
            Name      = $_.ProcessName
    1.  13:19:38.712  Masina nimi (hostname): KALLASTE-W11
1.  13:19:38.733  PowerShelli versioon: 5.1.26100.7019
1.  13:19:38.749  Windowsi versioon: Microsoft Windows 11 Pro Education (Version 10.0.26100, Build 26100)
2.  13:19:38.964  Võrgu konfiguratsioon (IP, mask, gateway, DHCP, MAC): @{Description=Intel(R) PRO/1000 MT Desktop Adapter; IPAddress=10.0.2.15, fe80::f8ae:103c:ed4f:e745, fd17:625c:f037:2:b1b8:726:deaa:4e7f, fd17:625c:f037:2:e1c8:515f:d042:d122; IPSubnet=255.255.255.0, 64, 128, 64; DefaultGateway=10.0.2.2, fe80::2; DHCPEnabled=True; MACAddress=08:00:27:D8:1D:14}
3.  13:19:43.648  Protsessori kirjeldus: Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz
3.  13:19:43.663  RAM kogus (GB): 3.98
4.  13:19:43.907  Graafikakaardi info (nimi, driver, kuupäev, lahutus):

Name                            DriverVersion DriverDate CurrentResolution
----                            ------------- ---------- -----------------
Microsoft Basic Display Adapter 10.0.26100.1  21.06.2006 1024x768         



5.  13:19:44.872  Ketta/partitsioonide info (partitsioonitabel):

DiskModel     DiskSizeGB Partition             PartType             PartSizeGB
---------     ---------- ---------             --------             ----------
VBOX HARDDISK          1 Disk #1, Partition #0 Logical Disk Manager          1
VBOX HARDDISK      63,99 Disk #0, Partition #0 GPT: System                 0,1
VBOX HARDDISK      63,99 Disk #0, Partition #1 GPT: Basic Data           63,17
VBOX HARDDISK      63,99 Disk #0, Partition #2 GPT: Unknown               0,72
VBOX HARDDISK          1 Disk #2, Partition #0 Logical Disk Manager          1



5.  13:19:44.909  Ketta kogumaht (GB, kõik kohalikud kettad kokku): 64.16
5.  13:19:44.931  Vaba ruum kettal C: (GB): 38.02
6.  13:19:49.319  PCI seadmete driveri info (kirjeldus, tootja, versioon):

Description                          Manufacturer                     DriverVersion  
-----------                          ------------                     -------------  
Standard SATA AHCI Controller        Standard SATA AHCI Controller    10.0.26100.7019
USB xHCI Compliant Host Controller   Generic USB xHCI Host Controller 10.0.26100.7019
High Definition Audio Controller     Microsoft                        10.0.26100.7019
VirtualBox Guest Device              Oracle Corporation               7.2.2.20484    
Intel(R) PRO/1000 MT Desktop Adapter Intel                            8.4.13.0       
Microsoft Basic Display Adapter      (Standard display types)         10.0.26100.1   
PCI to ISA Bridge                    Intel                            10.0.26100.1150
CPU to PCI Bridge                    Intel                            10.0.26100.1150



7.  13:19:49.553  Arvutis olevad kasutajad (nimi, kirjeldus, LocalAccount, Disabled):

Name               Description                                                           
----               -----------                                                           
Administrator      Built-in account for administering the computer/domain                
DefaultAccount     A user account managed by the system.                                 
Guest              Built-in account for guest access to the computer/domain              
Joosep                                                                                   
WDAGUtilityAccount A user account managed and used by the system for Windows Defender ...



8.  13:19:49.610  Käimasolevate protsesside arv: 158
9.  13:19:49.827  10 viimasena käivitatud protsessi (Name, PID, StartTime):

Name     PID StartTime          
----     --- ---------          
svchost 1748 24.12.2025 13:19:37
sppsvc  9256 24.12.2025 13:19:14
svchost 9888 24.12.2025 13:18:55
firefox 9500 24.12.2025 13:18:45
firefox 9492 24.12.2025 13:18:45
firefox 9484 24.12.2025 13:18:45
firefox 3880 24.12.2025 13:18:31
firefox 7740 24.12.2025 13:18:21
firefox 7008 24.12.2025 13:18:19
firefox 2360 24.12.2025 13:18:16



10.  13:19:49.854  Arvuti kuupäev ja kellaaeg: 24.12.2025 13:19:49
        PID       = $_.Id
            StartTime = $_.StartTime.ToString("dd.MM.yyyy HH:mm:ss")
        }
    }

valjasta 9 "10 viimasena käivitatud protsessi (Name, PID, StartTime)" $last10

# -------------------------------------------
# 10) Kuupäev ja kellaaeg formaadis dd.MM.yyyy HH:mm:ss
# -------------------------------------------
$nowNice = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
valjasta 10 "Arvuti kuupäev ja kellaaeg" $nowNice
```
