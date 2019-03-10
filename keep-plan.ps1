param(
    [bool]$keepplan
)

if ($keepplan) {
    Write-Output 'true' > keepplan.txt
}
else {
    Write-Output 'false' > keepplan.txt
}
