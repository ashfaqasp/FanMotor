#declare calling params 
param( [string] $Firstname, [string] $Surname ) 
#end calling params 
#main body 
#Get the current date 
$rundate = Get-Date -displayhint date 

#Now write a message 

Write-Output " Hello $($Firstname) $($Surname) thank you for running this 
script via`r`nthe SSIS subsystem on $($rundate)" | out-file -filepath "C:\Users\Administrator.TBLOCKS\Documents\Visual Studio 2010\Projects\TechBlocks.AES.SSIS\poshscriptout.log"