
function ChocolateyInstalled
{
  $chocolateyBin = [Environment]::GetEnvironmentVariable("ChocolateyInstall", "Machine") + "\bin"
  if(-not (Test-Path $chocolateyBin)) {
      Write-Output "Environment variable 'ChocolateyInstall' was not found in the system variables. Attempting to find it in the user variables..."
      $chocolateyBin = [Environment]::GetEnvironmentVariable("ChocolateyInstall", "User") + "\bin"
  }

  return (Test-Path $chocolateyBin)
}

if(-not (ChocolateyInstalled)) {
  Write-Output "Installing Chocolatey..."
  iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
} else {
  Write-Output "Chocolatey found. Skipping install."
}

$windowsfeatures = choco list -source windowsfeatures

$windowsfeatures | ForEach-Object {

    $line = "choco windowsfeatures "

    if ($_ -match "\| Enabled") {

        $line += $_ -replace " {0,1}\|.*", ""
        $line
    }
}
