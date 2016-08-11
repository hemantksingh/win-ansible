
function ChocolateyInstalled
{
  $chocolateyBin = [Environment]::GetEnvironmentVariable("ChocolateyInstall", "Machine") + "\bin"
  if(-not (Test-Path $chocolateyBin)) {
      Write-Output "Environment variable 'ChocolateyInstall' was not found in the system variables. Attempting to find it in the user variables..."
      $chocolateyBin = [Environment]::GetEnvironmentVariable("ChocolateyInstall", "User") + "\bin"
  }

  return (Test-Path $chocolateyBin)
}

function ListWindowsFeatures($filter) {
  Write-Output "Listing '$filter' windows features..."

  $windowsfeatures = choco list -source windowsfeatures
  $windowsfeatures | ForEach-Object {
      $line = ""
      if ($_ -match "\| " + $filter) {
          $line += $_ -replace " {0,1}\|.*", ""
          $line
      }
  }
}

function GetAllWindowsFeatures ($installed) {
  Import-Module ServerManager
  Get-WindowsFeature | Where-Object {$_.Installed -match $installed} | Select-Object -Property Name
}

function FeatureInstalled ($feature) {
  $f = Get-WindowsFeature $feature | Where-Object {$_.Installed -match "True"}
  return $f.Name -eq $feature
}

function AddFeature($feature, $includeAllSubfeatures) {
    Write-Output "Installing '$feature' with 'includeAllSubfeatures=$includeAllSubfeatures' ..."
    Add-WindowsFeature $feature
    if($includeAllSubfeatures) {
        $f = Get-WindowsFeature $feature
        $subFeatures = $f.SubFeatures -split " "
        foreach ($subFeature in $subFeatures)
        {
          Write-Output "Installing '$subFeature' for '$feature'..."
          Add-WindowsFeature $subFeature
        }
    }
}

function Skip($feature) {
  Write-Output "Skipping '$feature', it is already installed."
}

if(-not (ChocolateyInstalled)) {
  Write-Output "Installing Chocolatey ..."
  iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
} else {
  Skip "Chocolatey"
}

$featuresToInstall = "Web-WebServer", "Web-App-Dev --includeAllSubfeatures", "Web-Mgmt-Tools"

$featuresToInstall | ForEach-Object {
    $feature = $_.split()[0];
    $includeAllSubfeatures = $_.split()[1] -eq "--includeAllSubfeatures";

    if( -not (FeatureInstalled $feature)) {
      AddFeature $feature $includeAllSubfeatures
    }
    else {
      Skip $feature
    }
}

#GetAllWindowsFeatures "False"
