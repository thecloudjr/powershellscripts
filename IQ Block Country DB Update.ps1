#IQ Block Country Plugin - DB Update (IPv4/IPv6) -WP Engine Sites

clear
# Progress Bar Variables
$Activity             = "IP Database Update"
$UserActivity         = "File Upload"
$Id                   = 1

# Line count for steps
$lines = Get-Content 'C:\Program Files (x86)\WinScp\Upload-WPEngine.ps1'| Measure-Object -Line
$Stepcount = Function Get-CurrentLine {
    $Myinvocation.ScriptlineNumber
}

# Progress Bar Pause Variables
$ProgressBarWait      = 1500 # Set the pause length for operations in the main script
$AddPauses            = $true # Set to $true to add pauses that help highlight progress bar functionality

# Simple Progress Bar
$Task                 = "Setting Initial Variables"


# Complex Progress Bar
$numberlines          = $lines.Lines
$TotalSteps           = 5141
$Step                 = Get-CurrentLine # Set this at the beginning of each step
$StepText             = "Setting Initial Variables" # Set this at the beginning of each step


#Download updated DB file
wget "http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz" -outfile "C:\IQBLOCK\GeoLite2-Country.tar.gz"


#Unzip updated DB File

function Unzip {

$zipExe = join-path ${env:ProgramFiles} '7-zip\7z.exe'
if (-not (test-path $zipExe)) {
    $zipExe = join-path ${env:ProgramW6432} '7-zip\7z.exe'
    if (-not (test-path $zipExe)) {
         '7-zip does not exist on this system.'
    }
}

$SourceFile="C:\IQBLOCK\GeoLite2-Country.tar.gz"
$Destination="C:\IQBLOCK"
&$zipExe x $SourceFile "-o$Destination" -y 

$SourceFile="C:\IQBLOCK\GeoLite2-Country.tar"
$Destination="C:\IQBLOCK"
&$zipExe e $SourceFile "-o$Destination" -y 
}

Unzip

#Start Upload by loading WinSCP
$Step = Get-CurrentLine
$StepText = "Load WinSCP"
$Task = "Loading WinSCP .NET assembly"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

# Load WinSCP .NET assembly
Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"
$ErrorActionPreference = 'Continue';


$Step = Get-CurrentLine
$Task = "Pausing After Loading WinSCP"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }


##Flywheel##

##Start with Flywheel Sites##
$Step = Get-CurrentLine
$Task = "Updating Flywheel Sites"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }



#Site 1

# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "sftp.flywheelsites.com"
    UserName = "flywheeluser"
    Password = "flywheel"
    SshHostKeyFingerprint = "ssh-ed25519 256 HHHHHHHHHHHHHHHHHHHHHHHOLKNLKNLJNKJBKHJBKJ"
}

$sessionOptions.AddRawSettings("ProxyPort", "0")


$Step = Get-CurrentLine
$hostname = "Site 1"
$StepText = "Upload files"
$Task = "Uploading IPv4/IPv6 Database ($hostname)"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

$session = New-Object WinSCP.Session

$Step = Get-CurrentLine
$Task = "Connecting to SFTP ($hostname)"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }


try
{


    # Connect
    $session.Open($sessionOptions)

    $Step = Get-CurrentLine
    $Task = "Uploading files ($hostname)"
    Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
    if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

    # Transfer files
    $remotePath = "/org-inc/site1/wp-content/uploads/*"
  # Transfer files
    $session.PutFiles("C:\IQBLOCK\GeoLite2-Country.mmdb", $remotePath).Check()

}
finally
{
    $session.Dispose()
}




$Step = Get-CurrentLine
$Task = "Next Site"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

#Site 2
# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "sftp.flywheelsites.com"
    UserName = "flywheeluser"
    Password = "flywheel"
    SshHostKeyFingerprint = "ssh-ed25519 256 HHHHHHHHHHHHHHHHHHHHHHHOLKNLKNLJNKJBKHJBKJ"
}

$sessionOptions.AddRawSettings("ProxyPort", "0")


$Step = Get-CurrentLine
$hostname = "Site 2"
$StepText = "Upload files"
$Task = "Uploading IPv4/IPv6 Database ($hostname)"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

$session = New-Object WinSCP.Session

$Step = Get-CurrentLine
$Task = "Connecting to SFTP ($hostname)"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }


try
{


    # Connect
    $session.Open($sessionOptions)

    $Step = Get-CurrentLine
    $Task = "Uploading files ($hostname)"
    Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
    if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

    # Transfer files
    $remotePath = "/org-inc/site2/wp-content/uploads/*"
  # Transfer files
    $session.PutFiles("C:\IQBLOCK\GeoLite2-Country.mmdb", $remotePath).Check()

}
finally
{
    $session.Dispose()
}



$Step = Get-CurrentLine
$Task = "Next Site"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }


#Site 3
# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "sftp.flywheelsites.com"
    UserName = "flywheeluser"
    Password = "flywheel"
    SshHostKeyFingerprint = "ssh-ed25519 256 HHHHHHHHHHHHHHHHHHHHHHHOLKNLKNLJNKJBKHJBKJ"
}

$sessionOptions.AddRawSettings("ProxyPort", "0")


$Step = Get-CurrentLine
$hostname = "Site 3"
$StepText = "Upload files"
$Task = "Uploading IPv4/IPv6 Database ($hostname)"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

$session = New-Object WinSCP.Session

$Step = Get-CurrentLine
$Task = "Connecting to SFTP ($hostname)"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }


try
{


    # Connect
    $session.Open($sessionOptions)

    $Step = Get-CurrentLine
    $Task = "Uploading files ($hostname)"
    Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
    if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

    # Transfer files
    $remotePath = "/org-inc/site3/wp-content/uploads/*"
  # Transfer files
    $session.PutFiles("C:\IQBLOCK\GeoLite2-Country.mmdb", $remotePath).Check()

}
finally
{
    $session.Dispose()
}



$Step = Get-CurrentLine
$Task = "Next Site"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }



$Step = Get-CurrentLine
$StepText = "Finishing Script"
$Task = "Complete"
Write-Progress -Id ($Id+1) -Activity $Activity -Completed
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

#End