<#
.SYNOPSIS Run PowerCLI script w/PowerCLI Core Docker Container and pass in parameters using Docker env variables
.NOTES  Author:  William Lam
.NOTES  Site:    www.virtuallyghetto.com
.NOTES  Reference: http://www.virtuallyghetto.com/2016/10/5-different-ways-to-run-powercli-script-using-powercli-core-docker-container.html
.NOTES  Docker Command: docker run --rm -it --entrypoint='/usr/bin/pwsh' \
    -e VI_SERVER=192.168.1.150 \
    -e VI_USERNAME=administrator@vghetto.local \
    -e VI_PASSWORD=VMware1! \
    -e VI_VM=DummyVM \
    -v /Users/lamw/scripts:/tmp/scripts vmware/powerclicore /tmp/scripts/pcli_core_docker_sample2.ps1
#>

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false | Out-Null

$VI_SERVER = (Get-ChildItem ENV:VI_SERVER).Value
$VI_USERNAME = (Get-ChildItem ENV:VI_USERNAME).Value
$VI_PASSWORD = (Get-ChildItem ENV:VI_PASSWORD).Value
$VI_VM = (Get-ChildItem ENV:VI_VM).Value

Write-Host -ForegroundColor magenta "Variables from Docker Client ..."
Write-Host "VI_SERVER=$VI_SERVER"
Write-Host "VI_USERNAME=$VI_USERNAME"
Write-Host "VI_PASSWORD=$VI_PASSWORD"
Write-Host "VI_VM=$VI_VM"

Write-Host "`nConnecting to vCenter Server ..."
Connect-VIServer -Server $VI_SERVER -User $VI_USERNAME -password $VI_PASSWORD | Out-Null

$time = (Get-Date).toString()
Write-Host "Updating VM Notes ..."
Set-VM -VM (Get-VM -Name $VI_VM) -Notes "Current Time: $time" -Confirm:$false | Out-Null

Write-Host "Disconnecting ...`n"
Disconnect-VIServer * -Confirm:$false
