param(
    [string]$keepplan
)

if ($keepplan -eq 'true') {
    Write-Output 'true' > keepplan.txt
}
else {
    Write-Output 'false' > keepplan.txt
}
