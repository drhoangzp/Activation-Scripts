$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURLs = @('https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version/MAS_AIO.cmd', 'https://bitbucket.org/WindowsAddict/microsoft-activation-scripts/raw/master/MAS/All-In-One-Version/MAS_AIO.cmd')

$rand = Get-Random -Maximum 99999999
$isAdmin = bool.Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\MAS_$rand.cmd" } else { "$env:TEMP\MAS_$rand.cmd" }

foreach ($DownloadURL in $DownloadURLs) {
    try {
        $response = Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing
        break
    }
    catch {
        continue
    }
}

$prefix = "@REM $rand `r`n"
$content = $prefix + $response
Set-Content -Path $FilePath -Value $content

Start-Process $FilePath "$args " -Wait

Get-ChildItem -Path "$env:TEMP\MAS*.cmd", "$env:SystemRoot\Temp\MAS*.cmd" | Remove-Item
