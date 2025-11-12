# SafeGirl Pro - Deploy to Vercel Script
Write-Host "🚀 SafeGirl Pro Deployment Script" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Clean previous build
Write-Host "🧹 Cleaning previous build..." -ForegroundColor Yellow
flutter clean
Write-Host "✅ Clean complete" -ForegroundColor Green
Write-Host ""

# Step 2: Get dependencies
Write-Host "📦 Getting Flutter dependencies..." -ForegroundColor Yellow
flutter pub get
Write-Host "✅ Dependencies installed" -ForegroundColor Green
Write-Host ""

# Step 3: Build web release
Write-Host "🔨 Building Flutter web release..." -ForegroundColor Yellow
flutter build web --release
Write-Host "✅ Build complete" -ForegroundColor Green
Write-Host ""

# Step 4: Deploy to Vercel
Write-Host "🌐 Deploying to Vercel..." -ForegroundColor Yellow
Set-Location build\web
vercel --prod --yes
Set-Location ..\..
Write-Host "✅ Deployment complete!" -ForegroundColor Green
Write-Host ""

Write-Host "🎉 SafeGirl Pro is now live!" -ForegroundColor Cyan
Write-Host "Frontend: https://web-poorvajan-g-s-projects.vercel.app" -ForegroundColor Magenta
Write-Host "Backend: https://backend-eight-omega-92.vercel.app" -ForegroundColor Magenta
