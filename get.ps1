$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURLs = @(
    'https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version/MAS_AIO.cmd',
    'https://bitbucket.org/WindowsAddict/microsoft-activation-scripts/raw/master/MAS/All-In-One-Version/MAS_AIO.cmd'
)

$FilePath = if (bool.Groups -match 'S-1-5-32-544')) { 
    "$env:SystemRoot\Temp\MAS_$(Get-Random -Maximum 99999999).cmd" 
} else { 
    "$env:TEMP\MAS_$(Get-Random -Maximum 99999999).cmd" 
}

foreach ($url in $DownloadURLs) {
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            break
        }
    } catch {
        continue
    }
}

Set-Content -Path $FilePath -Value ("@REM $(Get-Random -Maximum 99999999) `r`n" + $response)
Start-Process $FilePath "$args " -Wait
Remove-Item -Path @("$env:TEMP\MAS*.cmd", "$env:SystemRoot\Temp\MAS*.cmd") -ErrorAction Ignore
