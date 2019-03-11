# Windows-PowerPlan-Switcher
Automatically change the powerplan according to CPU load

The original source is from [ComputerBase](https://www.computerbase.de/forum/threads/skript-windows-powerplan-switcher-for-nvidia.1830609/).

# How to use
Just adjust the parameters and you are good to go.

## Manually fix to "gaming-plan"

run `keep-plan.ps1 $true` or `keep-plan.ps1 $false`.
* `$true`  
Will keep the gaming-plan until you run the script again with `$false`
* `$false`  
Will disable the fixed powerplan and make it CPU load dependant again

You can set hotkey for the script with `$true` and `$false` for easy switching.  
(Shortcut on Desktop, or G-Keys on Logitech keyboards)

## See current status on Logitech display
Run `check-plan.ps1` to see the current state of powerplan and NVIDIA performance state on the display of your keyboard.

# Other Info
I also use NVIDIA Inspector with Multi Display Power Saver and I didn't want the powerplan dependant on GPU load (and performance state) for tasks only with CPU load.
  