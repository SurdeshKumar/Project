# Deploy LegalLens to AWS App Runner
# Prerequisites: AWS CLI configured, App Runner enabled, GitHub connection created in AWS Console

param(
    [Parameter(Mandatory=$true)]
    [string]$ConnectionArn
)

$ServiceName = "legal-lens-app"
$RepoUrl = "https://github.com/SurdeshKumar/Project"
$Branch = "master"
$Region = "us-east-1"

$inputJson = @{
    ServiceName = $ServiceName
    SourceConfiguration = @{
        AuthenticationConfiguration = @{ ConnectionArn = $ConnectionArn }
        AutoDeploymentsEnabled = $true
        CodeRepository = @{
            RepositoryUrl = $RepoUrl
            SourceCodeVersion = @{ Type = "BRANCH"; Value = $Branch }
            CodeConfiguration = @{ ConfigurationSource = "REPOSITORY" }
        }
    }
    InstanceConfiguration = @{ Cpu = "1 vCPU"; Memory = "2 GB" }
} | ConvertTo-Json -Depth 10

$inputFile = [System.IO.Path]::GetTempFileName()
$inputJson | Out-File -FilePath $inputFile -Encoding utf8

Write-Host "Creating App Runner service '$ServiceName' from GitHub (free-tier: 1 vCPU, 2 GB)..." -ForegroundColor Cyan
$result = aws apprunner create-service --cli-input-json "file://$inputFile" --region $Region --output json 2>&1
Remove-Item -Path $inputFile -ErrorAction SilentlyContinue

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: $result" -ForegroundColor Red
    exit 1
}

$json = $result | ConvertFrom-Json
$serviceUrl = $json.Service.ServiceUrl
$fullUrl = "https://$serviceUrl"

Write-Host ""
Write-Host "Deployment started. Service URL: $fullUrl" -ForegroundColor Green
Write-Host "Initial build may take 5-10 minutes. Check status: aws apprunner list-services --region $Region" -ForegroundColor Yellow
Write-Host "Live app (once RUNNING): $fullUrl" -ForegroundColor Green
