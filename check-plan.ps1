$GamingPowerPlanID = '9897998c-92de-4669-853f-b7cd3ecb2790'
$IdlePowerPlanID = 'a1841308-3541-4fab-bc81-f71556f20b4a'

if ((powercfg /GetActiveScheme) -like ("*" + $GamingPowerPlanID + "*")) {
    $Plan = 'Gaming'
}
else {
    $Plan = 'Powersaving'
}

python.exe write_lglcd.py "$Plan"
