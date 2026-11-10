# StyleMirror Full-Stack Launcher for PowerShell
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "  StyleMirror - Auto Full-Stack Launcher" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan

# Check if port 8000 is open
$portActive = $false
try {
    $tcp = New-Object System.Net.Sockets.TcpClient
    $iar = $tcp.BeginConnect("127.0.0.1", 8000, $null, $null)
    $portActive = $iar.AsyncWaitHandle.WaitOne(600, $false)
    $tcp.Close()
} catch {
    $portActive = $false
}

if ($portActive) {
    Write-Host "[OK] FastAPI backend is already running on port 8000." -ForegroundColor Green
} else {
    Write-Host "[..] Launching StyleMirror FastAPI backend in background..." -ForegroundColor Yellow
    $backendPath = Join-Path $PSScriptRoot "backend"
    $env:PYTHONPATH = $backendPath
    Start-Process python -ArgumentList "-m", "uvicorn", "app.main:app", "--app-dir", "`"$backendPath`"", "--host", "0.0.0.0", "--port", "8000" -WindowStyle Hidden
    Start-Sleep -Seconds 2
    Write-Host "[OK] Backend running on http://127.0.0.1:8000" -ForegroundColor Green
}

Write-Host "[..] Starting Flutter app..." -ForegroundColor Cyan
flutter run $args

