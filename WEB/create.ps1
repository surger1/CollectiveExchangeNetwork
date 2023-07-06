Get-ChildItem -Directory -Recurse | ForEach-Object {
    $path = $_.FullName
    New-Item -ItemType File -Path "$path\index.php" -Force
}
Write-Host "index.php files created in all subdirectories."
