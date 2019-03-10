## To Fill
$MinCPUUsage = 10
$MaxCPUUsage = 30
$CheckEverySeconds = 3
$GamingPowerPlanID = '9897998c-92de-4669-853f-b7cd3ecb2790'
$NoGamingPowerPlanID = 'a1841308-3541-4fab-bc81-f71556f20b4a'
#$DebugPreference = "Continue"

## Power Plans IDs (Use Without #)
# 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c = High performance
# a1841308-3541-4fab-bc81-f71556f20b4a = Power saver
# 381b4222-f694-41f0-9685-ff5bb260df2e = Balanced
# 9897998c-92de-4669-853f-b7cd3ecb2790 = AMD Balanced | Might be different for everyone

# https://social.technet.microsoft.com/Forums/en-US/f89267b7-5069-4e57-9970-af80dcc58f8f/get-cpu-usage-faster-with-net-within-powershell-then-using-wmi-or
$counters = New-Object -TypeName System.Diagnostics.PerformanceCounter
$counters.CategoryName='Processor'
$counters.CounterName='% Processor Time'
$counters.InstanceName='_Total'

while ($true){
    $KeepGamingPowerPlan = gc 'keepplan.txt'
    Start-Sleep -Seconds $CheckEverySeconds
    if ($KeepGamingPowerPlan -eq 'True') {
        Write-Debug 'Keep Powerplan'
        if ((powercfg /GetActiveScheme) -notlike ("*" + $GamingPowerPlanID + "*")) {
            powercfg -s $GamingPowerplanID
            Write-Debug 'Set Gaming Powerplan'
        }
        Continue
    }
    $CPULoad = $counters.NextValue()
    if ((powercfg /GetActiveScheme) -notlike ("*" + $GamingPowerPlanID + "*")){
        Write-Debug 'Powersaving Powerplan is active'
        if ($CPULoad -ge $MaxCPUUsage){
            Write-Debug 'CPU Load is higher than MaxCPU'
            powercfg -s $GamingPowerplanID
            Write-Debug 'Gaming Powerplan activated'
        }
    }
    else{
        Write-Debug 'Gaming Powerplan is active'
        if ($CPULoad -le $MinCPUUsage){
            Write-Debug 'CPU Load is lower than MinCPU'
            powercfg -s $NoGamingPowerPlanID
            Write-Debug 'Powersaving Powerplan activated'
        }
    }
    Write-Debug 'Sleeping...'
}
