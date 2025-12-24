# Praktikum 14 - Skriptimine Windowsis
---

```
# -------------------------------------------
# Väljundi abifunktsioon
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

# Puhastan vana tulemuse (et iga jooks ei kuhjaks)
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
# -------------------------------------------
$last10 = Get-Process |
    Select-Object ProcessName, Id, StartTime |
    Where-Object { $_.StartTime -ne $null } |
    Sort-Object StartTime -Descending |
    Select-Object -First 10 |
    ForEach-Object {
        [PSCustomObject]@{
            Name      = $_.ProcessName
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
