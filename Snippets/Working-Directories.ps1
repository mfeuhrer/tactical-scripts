$basedir = $env:SYSTEMDRIVE + "\tactical\"
if (-Not (Test-Path -Path $basedir)) {New-Item $basedir -ItemType Directory}
$logdir = $basedir + "logs\"
if (-Not (Test-Path -Path $logdir)) {New-Item $logdir -ItemType Directory}
$logfile = $logdir+$logname