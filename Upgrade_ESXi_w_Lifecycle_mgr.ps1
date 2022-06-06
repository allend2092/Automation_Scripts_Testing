<#
Steps to upgrade ESXi host using Lifecycle Manager

1. Identify the ESXi version or Patched version you want to upgrade to.
2. If you're going to an upgrade image, get that from my.vmware.com and upload it to the vCenter image repository.
3. If you're going to a patched version of ESXi, create a baseline, skip the automatic patches and select the patch you want that VC has downloaded.
4. Identify which hosts require patching and upgrading
+++++++++++++++++++++++PowerCLI code can do the remaining steps++++++++++++++++++++++++++++

5. Attach baseline to host
6. Check that the host is compliant with the baseline
7. (optional) copy the patch to the host such that it is staged for the actual upgrade
8. Remediate to baseline
9. Validate the functionality of the host and of VMs on the host
#>

#Declare ESXi host to be upgraded
$EsxiHost = '<ESXi host ip or URL>'

#Get the baseline object and stuff it into a variable
$Baseline = Get-Baseline -name '<Name of Baseline>'

#Add the baseline to the host
Add-EntityBaseline -Entity $EsxiHost -Baseline $Baseline

#Check the baseline against the host
Test-Compliance -Entity $EsxiHost

#Output the state of compliance
Get-Compliance -Entity $EsxiHost 

#Stage the patch or upgrade code
Copy-Patch -Entity $EsxiHost

#Perform the upgrade / patching
Update-Entity -Baseline $Baseline -Entity $EsxiHost -RunAsync -Confirm:$False
