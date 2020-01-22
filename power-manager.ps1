## To Fill
$CPUUsageLimit = 15
$UserIdleLimit = 15.0
$LGLCD = $false
$CheckEverySeconds = 3
$GamingPowerPlanID = '9897998c-92de-4669-853f-b7cd3ecb2790'
$IdlePowerPlanID = 'a1841308-3541-4fab-bc81-f71556f20b4a'
#$DebugPreference = "Continue"

## Power Plans IDs
# 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c = High performance
# a1841308-3541-4fab-bc81-f71556f20b4a = Power saver
# 381b4222-f694-41f0-9685-ff5bb260df2e = Balanced
# 9897998c-92de-4669-853f-b7cd3ecb2790 = AMD Ryzen Balanced

# https://social.technet.microsoft.com/Forums/en-US/f89267b7-5069-4e57-9970-af80dcc58f8f/get-cpu-usage-faster-with-net-within-powershell-then-using-wmi-or
$counters = New-Object -TypeName System.Diagnostics.PerformanceCounter
$counters.CategoryName='Processor'
$counters.CounterName='% Processor Time'
$counters.InstanceName='_Total'

# So autostart won't be too slow
powercfg -s $GamingPowerplanID
#Start-Sleep -Seconds 180

# https://stackoverflow.com/a/39319540
Add-Type @'
    using System;
    using System.Diagnostics;
    using System.Runtime.InteropServices;
    namespace PInvoke.Win32 {
        public static class UserInput {
            [DllImport("user32.dll", SetLastError=false)]
            private static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);
            [StructLayout(LayoutKind.Sequential)]
            private struct LASTINPUTINFO {
                public uint cbSize;
                public int dwTime;
            }
            public static DateTime LastInput {
                get {
                    DateTime bootTime = DateTime.UtcNow.AddMilliseconds(-Environment.TickCount);
                    DateTime lastInput = bootTime.AddMilliseconds(LastInputTicks);
                    return lastInput;
                }
            }
            public static TimeSpan IdleTime {
                get {
                    return DateTime.UtcNow.Subtract(LastInput);
                }
            }
            public static int LastInputTicks {
                get {
                    LASTINPUTINFO lii = new LASTINPUTINFO();
                    lii.cbSize = (uint)Marshal.SizeOf(typeof(LASTINPUTINFO));
                    GetLastInputInfo(ref lii);
                    return lii.dwTime;
                }
            }
        }
    }
'@

function change-powerplan {
    Param ($PowerPlanID)
    if ((powercfg /GetActiveScheme) -notlike ("*" + $PowerPlanID + "*")) {
        powercfg -s $PowerPlanID
        if ($LGLCD) {
            ./check-plan.ps1
        }
        Write-Debug "Set Powerplan ID $PowerPlanID"
    }
}

while ($true){
    # Keep Gaming Powerplan according to keepplan.txt
    $KeepGamingPowerPlan = gc 'keepplan.txt'
    Start-Sleep -Seconds $CheckEverySeconds
    if ($KeepGamingPowerPlan -eq 'True') {
        Write-Debug 'Keep Powerplan'
        change-powerplan $GamingPowerPlanID
        Continue
    }
    $process_list = gc 'gamingprocess.txt'
    foreach ($this_process in $process_list) {
        $process_exists = Get-Process -erroraction 'silentlycontinue' -Name $this_process
        if ($process_exists) {
            Write-Debug "$this_process is running"
            change-powerplan $GamingPowerPlanID
            break
        }
    }
    if ($process_exists) {
        Write-Debug "$this_process still running"
        continue
    }
    # Decide with CPU load if keepplan.txt is false
    $CPULoad = $counters.NextValue()
    $IdleSeconds = [PInvoke.Win32.UserInput]::IdleTime.TotalSeconds
    Write-Debug ('User IdleTime ' + $IdleSeconds)
    if ($CPULoad -le $CPUUsageLimit) {
        Write-Debug 'CPU Load is lower than MinCPU'
        # Check user idle time to set $IdlePowerPlanID
        if ($IdleSeconds -ge $UserIdleLimit) {
            Write-Debug 'User is idling'
            change-powerplan $IdlePowerPlanID
        }
        else {
            change-powerplan $GamingPowerPlanID
            }
    }
    else {
        Write-Debug 'CPU Load is higher than MaxCPU'
        change-powerplan $GamingPowerPlanID
    }
    Write-Debug 'Sleeping...'
}
