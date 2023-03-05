# Windows-PowerPlan-Switcher
Automatically change the powerplan according to CPU load, idle time, processes or manual override

The original source is from [ComputerBase](https://www.computerbase.de/forum/threads/skript-windows-powerplan-switcher-for-nvidia.1830609/).

# How to use
Just adjust the parameters (explained below) and you are good to go.  
`power-manager.ps1` is the main script, which you can setup in the Taskplaner. The window will be hidden, if "*run even if user is not logged in*" is active.

## Config
### $CPUUsageLimit
CPU Load, which needs to fall bellow this value to set energy saving or go higher to set gaming plan.

### $UseIdleLimit [$true or $false]
Enable or disable to check for user idle time.

### $UserIdleLimit
Float, seconds. Amount of time the user should be idling to set powersaving plan.

### $LGLCD [$true or $false]
Enable or disable showing status on the Logitech keyboard display. Requires Python if enabled.

### $GamingPowerPlanID
Use `powercfg /L` to get the IDs of the power plans.  
This powerplan is set if CPU load is higher than `$CPUUsageLimit`, mouse and keyboard inputs are not older than `$UserIdleLimit`, at least one process from `gameprocess.txt` is running or "True" is written in `keepplan.txt` (read below).

### $IdlePowerPlanID
This powerplan is set, if none of the above apply.

## Manually fix to "gaming-plan"
run `keep-plan.ps1 true` or `keep-plan.ps1 false`.
* `true`  
Will keep the gaming-plan until you run the script again with `false`
* `false`  
Will disable the fixed powerplan and make it CPU load and idle time dependant again

You can set hotkey for the script with `true` and `false` for easy switching.  
(Shortcut on Desktop, or G-Keys on Logitech keyboards)

## Programs to keep gaming-plan
Enter the processes in `gamingprocess.txt` (_without .exe_). If one of these processes are running, gaming-plan will be kept.

## See current status on Logitech display
Run `check-plan.ps1` to see the current state of powerplan and NVIDIA performance state on the display of your keyboard.

