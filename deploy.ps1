# deploy.ps1
param (
    [string]$Cloud = "all"
)

Write-Host "🚀 Starting Multi-Cloud Deployment with Terraform..." -ForegroundColor Cyan

# Go into terraform directory
Set-Location terraform

if ($Cloud -eq "aws" -or $Cloud -eq "all") {
    Write-Host "`n🌍 Deploying AWS Infrastructure..." -ForegroundColor Green
    Set-Location aws
    terraform init
    terraform apply -auto-approve
    Set-Location ..
}

if ($Cloud -eq "gcp" -or $Cloud -eq "all") {
    Write-Host "`n☁️ Deploying GCP Infrastructure..." -ForegroundColor Yellow
    Set-Location gcp
    terraform init
    terraform apply -auto-approve
    Set-Location ..
}

# Go back to project root
Set-Location ..

Write-Host "`n✅ Deployment finished successfully!" -ForegroundColor Cyan
