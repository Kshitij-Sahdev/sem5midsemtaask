New-Item -ItemType Directory -Force -Path "modules\loadbalancer" | Out-Null
Push-Location "modules\loadbalancer"

if (!(Get-Command openssl -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: OpenSSL not found. Install it or use Git Bash." -ForegroundColor Red
    Pop-Location
    exit 1
}

openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes `
    -subj "/CN=localhost"

openssl pkcs12 -export -out self-signed-cert.pfx -inkey key.pem -in cert.pem `
    -password pass:Password123

Pop-Location
Write-Host "Cert generated: modules\loadbalancer\self-signed-cert.pfx (Password123)" -ForegroundColor Green
