# Set MongoDB URI with correct database name
$mongoUri = "mongodb+srv://poorvajan28_db_user:YJE87Ono9BYRRWMO@cluster0.83uuqfh.mongodb.net/safegirl-pro?appName=Cluster0&retryWrites=true&w=majority"

Write-Host "Setting MONGODB_URI environment variable..." -ForegroundColor Yellow
Write-Host "URI: $mongoUri" -ForegroundColor Cyan

# This will prompt for confirmation
vercel env add MONGODB_URI production

Write-Host ""
Write-Host "When prompted, paste this value:" -ForegroundColor Green
Write-Host $mongoUri -ForegroundColor Magenta
