$ErrorActionPreference = "Stop"

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$URL1 = 'https://raw.githubusercontent.com/drhoangzp/Activation-Scripts/master/MAS/All-In-One-Version/MAS_AIO.cmd'
$URL2 = 'https://bitbucket.org/WindowsAddict/microsoft-activation-scripts/raw/master/MAS/All-In-One-Version/MAS_AIO.cmd'

$randomNumber = Get-Random -Maximum 99999999
$checkAdmin = bool.Groups -match 'S-1-5-32-544'

$FileDir = if ($checkAdmin) { "$env:SystemRoot\Temp\MAS_$randomNumber.cmd" } else { "$env:TEMP\MAS_$randomNumber.cmd" }

try {
    $webResponse = Invoke-WebRequest -Uri $URL1 -UseBasicParsing
}
catch {
    $webResponse = Invoke-WebRequest -Uri $URL2 -UseBasicParsing
}

$ArgsForScript = "$args "
$prefixContent = "@REM $randomNumber `r`n"
$fileContent = $prefixContent + $webResponse

Set-Content -Path $FileDir -Value $fileContent

Start-Process $FileDir $ArgsForScript -Wait

$FilesToBeDeleted = @("$env:TEMP\MAS*.cmd", "$env:SystemRoot\Temp\MAS*.cmd")
foreach ($File in $FilesToBeDeleted) { Get-Item $File | Remove-Item }
