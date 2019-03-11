$GamingPowerPlanID = '9897998c-92de-4669-853f-b7cd3ecb2790'
$NoGamingPowerPlanID = 'a1841308-3541-4fab-bc81-f71556f20b4a'
$NvidiaSMIFolderPath = "C:\Program Files\NVIDIA Corporation\NVSMI"

if ((powercfg /GetActiveScheme) -like ("*" + $GamingPowerPlanID + "*")) {
    $Plan = 'Gaming'
}
else
{
    $Plan = 'Powersaving'
}

$SMICommand = "& '" + $NvidiaSMIFolderPath+ "\nvidia-smi.exe`' --query-gpu=pstate --format=csv,noheader,nounits"
$GPUState = (Invoke-Expression -command $SMICommand).split(",")
python.exe write_lglcd.py "$Plan $GPUState"
