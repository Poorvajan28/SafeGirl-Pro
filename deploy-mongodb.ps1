# MongoDB Deployment Script for Vercel
# This script adds MongoDB connection to Vercel backend

Write-Host "SafeGirl Pro - MongoDB Vercel Deployment"
Write-Host "=========================================="
Write-Host ""

# Your MongoDB Atlas connection string
$mongodbUri = "mongodb+srv://poorvajan28_db_user:<db_password>@cluster0.83uuqfh.mongodb.net/safegirl-pro?appName=Cluster0&retryWrites=true&w=majority"

Write-Host "IMPORTANT: Replace <db_password> with your actual database user password!"
Write-Host ""
Write-Host "Your connection string template:"
Write-Host $mongodbUri
Write-Host ""

# Manual Steps
Write-Host "MANUAL STEPS TO COMPLETE:"
Write-Host "========================"
Write-Host ""
Write-Host "1. Go to: https://vercel.com/poorvajan-g-s-projects/backend/settings/environment-variables"
Write-Host ""
Write-Host "2. Click 'Add New' and add these variables:"
Write-Host ""
Write-Host "   Variable 1:"
Write-Host "   Name: MONGODB_URI"
Write-Host "   Value: mongodb+srv://poorvajan28_db_user:YOUR_PASSWORD@cluster0.83uuqfh.mongodb.net/safegirl-pro?appName=Cluster0&retryWrites=true&w=majority"
Write-Host ""
Write-Host "   Replace 'YOUR_PASSWORD' with your database user password"
Write-Host ""
Write-Host "3. Click 'Add New' and add second variable:"
Write-Host ""
Write-Host "   Variable 2:"
Write-Host "   Name: JWT_SECRET"
Write-Host "   Value: poorvajan28_jwt_secret_key_safegirl_pro_2024"
Write-Host ""
Write-Host "4. Click 'Save'"
Write-Host ""
Write-Host "5. Go to Deployments and click 'Redeploy' on the latest deployment"
Write-Host ""
Write-Host "6. Done! Your app will be fully functional"
Write-Host ""
