# 🚀 Vercel Deployment Guide for SafeGirl Pro

## Step 1: Push to GitHub

### 1.1 Create Repository on GitHub

1. Go to https://github.com/Poorvajan28
2. Click "New" to create a new repository
3. Name it: `SafeGirl-Pro`
4. Description: "Personal Safety Application with Flutter & Node.js"
5. Click "Create repository"

### 1.2 Push Code from Your Computer

Run these commands in PowerShell:

```powershell
cd "d:\SafeGirl Pro"

git remote add origin https://github.com/Poorvajan28/SafeGirl-Pro.git
git branch -M main
git push -u origin main
```

After running these, GitHub will ask for your personal access token (PAT).

### 1.3 Creating GitHub Personal Access Token

1. Go to: https://github.com/settings/tokens
2. Click "Generate new token"
3. Give it a name (e.g., "SafeGirl Pro Deployment")
4. Select scopes: `repo`, `workflow`
5. Click "Generate token"
6. Copy the token (you'll use it as password when pushing)

---

## Step 2: Deploy Backend to Vercel

### 2.1 Create Vercel Project for Backend

1. Go to https://vercel.com
2. Sign up/Login with GitHub (Poorvajan28)
3. Click "Add New" → "Project"
4. Select repository: `SafeGirl-Pro`
5. Click "Import"

### 2.2 Configure Backend Settings

1. Root Directory: `./backend`
2. Framework: `Other`
3. Build Command: (leave empty)
4. Environment Variables:

   - `MONGODB_URI`: Your MongoDB Atlas connection string
   - `JWT_SECRET`: Your secure JWT secret
   - `NODE_ENV`: `production`
   - `PORT`: `3000`

5. Click "Deploy"

**Backend URL**: Will be something like:

```
https://safegirl-pro-api.vercel.app
```

### 2.3 Add MongoDB Connection

Before deployment works, you need MongoDB Atlas:

1. Go to https://www.mongodb.com/cloud/atlas
2. Create free cluster
3. Get connection string
4. Paste in Vercel environment variable `MONGODB_URI`

---

## Step 3: Deploy Frontend (Flutter Web) to Vercel

### 3.1 Create Vercel Project for Frontend

1. In Vercel dashboard, click "Add New" → "Project"
2. Select: `SafeGirl-Pro` repository
3. Framework: `Other`

### 3.2 Configure Frontend

1. Root Directory: `.` (root)
2. Build Command: `flutter build web --release`
3. Output Directory: `build/web`
4. Environment Variables: (none needed)
5. Click "Deploy"

**Frontend URL**: Will be something like:

```
https://safegirl-pro.vercel.app
```

### 3.3 Update API URL in Flutter

After backend is deployed, update the API URL:

File: `lib/config/api_config.dart`

```dart
static const String baseUrl = 'https://safegirl-pro-api.vercel.app/api';
```

Then commit and push:

```powershell
cd "d:\SafeGirl Pro"
git add lib/config/api_config.dart
git commit -m "Update API URL for production"
git push
```

---

## Step 4: Database (MongoDB)

### Using MongoDB Atlas (Free)

1. Go to https://www.mongodb.com/cloud/atlas
2. Create account
3. Create free cluster (M0 tier, unlimited data for free)
4. Get connection string
5. Add to Vercel as environment variable

**Connection String Format**:

```
mongodb+srv://username:password@cluster.mongodb.net/safegirl-pro
```

---

## Complete URLs After Deployment

Once deployed, you'll have:

**Frontend**: https://safegirl-pro.vercel.app
**Backend API**: https://safegirl-pro-api.vercel.app
**Database**: MongoDB Atlas

---

## Troubleshooting

### Backend Not Working

1. Check environment variables in Vercel
2. Verify MONGODB_URI is correct
3. Check Vercel logs: Dashboard → Project → Deployments → Logs

### Frontend Can't Connect to Backend

1. Update `api_config.dart` with correct backend URL
2. Rebuild and redeploy
3. Check CORS in backend (already configured)

### Build Fails

1. Make sure `build/web` exists locally
2. Run `flutter build web --release` locally first
3. Commit and push

---

## Quick Summary

```
Step 1: Push to GitHub
  git remote add origin https://github.com/Poorvajan28/SafeGirl-Pro.git
  git push -u origin main

Step 2: Deploy Backend
  - Import project in Vercel
  - Set root directory to ./backend
  - Add MongoDB URI
  - Deploy

Step 3: Deploy Frontend
  - Import same project
  - Build command: flutter build web --release
  - Output: build/web
  - Deploy

Step 4: Update URLs
  - Update lib/config/api_config.dart
  - Push changes
  - Frontend auto-redeployes

Done! ✅
```

---

## Your Deployment Commands

```powershell
# 1. Setup GitHub
cd "d:\SafeGirl Pro"
git remote add origin https://github.com/Poorvajan28/SafeGirl-Pro.git
git branch -M main
git push -u origin main

# 2. Update API URL (after backend deployed)
# Edit: lib/config/api_config.dart
# Change: static const String baseUrl = 'https://safegirl-pro-api.vercel.app/api';

# 3. Push update
git add lib/config/api_config.dart
git commit -m "Update API URL for production"
git push
```

---

**Status**: Ready to Deploy ✅
**Time to Deploy**: ~15 minutes
**Cost**: FREE (Vercel + MongoDB Atlas free tier)
