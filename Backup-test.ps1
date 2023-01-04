#Site backup -WP Engine Sites


# Progress Bar Variables
$Activity             = "Backup Downloads"
$UserActivity         = "Download"
$Id                   = 1

#test

$CurrentDate          = Get-Date -UFormat "%Y-%m"

#net use V: "\\sitsnas01\webbackup"

function FileTransferProgress
{
    param($e)
 
    Write-Progress `
        -Activity "Uploading" -Status ("{0:P0} complete:" -f $e.OverallProgress) `
        -PercentComplete ($e.OverallProgress * 100)
    Write-Progress `
        -Id 1 -Activity $e.FileName -Status ("{0:P0} complete:" -f $e.FileProgress) `
        -PercentComplete ($e.FileProgress * 100)
}

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
$TotalSteps           = 240 
$Step                 = Get-CurrentLine # Set this at the beginning of each step
$StepText             = "Setting Initial Variables" # Set this at the beginning of each step


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



# Session.FileTransferProgress event handler
 
function FileTransferProgress
{
    param($e)
 
    # New line for every new file
    if (($script:lastFileName -ne $Null) -and
        ($script:lastFileName -ne $e.FileName))
    {
        Write-Host
    }
 
    # Print transfer progress
    Write-Host -NoNewline ("`r{0} ({1:P0})" -f $e.FileName, $e.FileProgress)
 
    # Remember a name of the last file reported
    $script:lastFileName = $e.FileName
}
 
# Main script
 
$script:lastFileName = $Null
 
 try
 {



#First Site

# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "site.hosting.com"
    PortNumber = 2222
    UserName = "user@hosting"
    Password = "PassWord"
    SshHostKeyFingerprint = "ssh-rsa 2048 fe:7a:9f:9d:11:XX:XX:56:XX:98:31:XX:e4:70:cd:9c"
}

$Step = Get-CurrentLine
$hostname = $sessionOptions.HostName
$StepText = "Backing up files"
$Task = "Backing up files from ($hostname)"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

$session = New-Object WinSCP.Session

$Step = Get-CurrentLine
$Task = "Connecting to SFTP ($hostname)"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }


if( -Not (Test-Path -Path "C:\FTP Files\site-backups\$CurrentDate\$hostname" ) )
{
    mkdir "C:\FTP Files\site-backup\$CurrentDate\$hostname"
}



try
{
    # Will continuously report progress of transfer
    $session.add_FileTransferProgress( { FileTransferProgress($_) } )

    # Connect
    $session.Open($sessionOptions)

    $Step = Get-CurrentLine
    $Task = "Downloading backup files ($hostname)"
    Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
    if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

    # Transfer old files
    $remotePath = "/wp-content/updraft/*"
    # Transfer new files
    $session.GetFiles("/wp-content/updraft/*.zip", "C:\FTP Files\site-backup\$CurrentDate\$hostname\*", $False).Check()
    $session.GetFiles("/wp-content/updraft/*.gz", "C:\FTP Files\site-backup\$CurrentDate\$hostname\*", $False).Check()

}
finally
{
    # Terminate line after the last file (if any)
    if ($script:lastFileName -ne $Null)
    {
        Write-Host
    }
    $session.Dispose()
}




$Step = Get-CurrentLine
$Task = "Next Site"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }


#Second Site



# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "site.hosting.com"
    PortNumber = 2222
    UserName = "user@hosting"
    Password = "PassWord"
    SshHostKeyFingerprint = "ssh-rsa 2048 fe:7a:9f:9d:11:XX:XX:56:XX:98:31:XX:e4:70:cd:9c"
}

$Step = Get-CurrentLine
$hostname = $sessionOptions.HostName
$StepText = "Backing up files"
$Task = "Backing up files from ($hostname)"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

if( -Not (Test-Path -Path "C:\FTP Files\site-backup\$CurrentDate\$hostname" ) )
{
    mkdir "C:\FTP Files\site-backup\$CurrentDate\$hostname"
}

# Set up session options
$session = New-Object WinSCP.Session

$Step = Get-CurrentLine
$Task = "Connecting to SFTP ($hostname)"
Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

try
{
    # Will continuously report progress of transfer
    $session.add_FileTransferProgress( { FileTransferProgress($_) } )

    # Connect
    $session.Open($sessionOptions)

    $Step = Get-CurrentLine
    $Task = "Downloading backup files ($hostname)"
    Write-Progress -Id $Id -Activity $Activity  -CurrentOperation $Task -PercentComplete (($Step / $TotalSteps) * 100)
    if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

    # Transfer old files
    $remotePath = "/wp-content/uploads/*"
    # Transfer new files
    $session.GetFiles("/wp-content/updraft/*.zip", "C:\FTP Files\site-backup\$CurrentDate\$hostname\*", $False).Check()
    $session.GetFiles("/wp-content/updraft/*.gz", "C:\FTP Files\site-backup\$CurrentDate\$hostname\*", $False).Check()
}
finally
{
    # Terminate line after the last file (if any)
    if ($script:lastFileName -ne $Null)
    {
        Write-Host
    }
    $session.Dispose()
}

}
catch [Exception]
{
 Write-Host "Error: $($_.Exception.Message)"
 exit 1
}

$Step = Get-CurrentLine
$StepText = "Finishing Script"
$Task = "Complete"
Write-Progress -Id ($Id+1) -Activity $Activity -Completed
if ($AddPauses) { Start-Sleep -Milliseconds $ProgressBarWait }

#End