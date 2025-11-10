# Vercel Environment Setup Script
cd "d:\SafeGirl Pro\backend"

# Add MONGODB_URI
Write-Host "Setting MONGODB_URI..."
$mongoUri = "mongodb+srv://poorvajan:poorvajan28@cluster0.xxxxx.mongodb.net/safegirl-pro?retryWrites=true&w=majority"
vercel env add MONGODB_URI | Out-Null
Start-Sleep -Milliseconds 500

# Add JWT_SECRET
Write-Host "Setting JWT_SECRET..."
$jwtSecret = "poorvajan28_jwt_secret_key_safegirl_pro_2024"
vercel env add JWT_SECRET | Out-Null
Start-Sleep -Milliseconds 500

Write-Host "Environment variables added. Redeploy with: vercel --prod --yes"
