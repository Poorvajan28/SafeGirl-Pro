# 📋 GitHub & Vercel Deployment - Step by Step

## ✅ Your Repository Status

```
✅ Code is already committed locally
✅ Ready to push to GitHub
✅ Git configured
```

---

## 🎯 EXACT COMMANDS TO RUN

### Step 1: Create GitHub PAT (Personal Access Token)

**DO THIS FIRST IN YOUR BROWSER:**

1. Visit: https://github.com/settings/tokens
2. Click "Generate new token" (top right)
3. Name: "SafeGirl-Pro-Deploy"
4. Checkboxes to select:
   - ☑️ repo (Full control of private repositories)
   - ☑️ workflow (Update GitHub Action and workflow permissions)
5. Click "Generate token" (bottom)
6. **COPY THE TOKEN** (you won't see it again!)

---

### Step 2: Push to GitHub (Run in PowerShell)

**Copy & Paste These Commands:**

```powershell
cd "d:\SafeGirl Pro"

git remote add origin https://github.com/Poorvajan28/SafeGirl-Pro.git

git branch -M main

git push -u origin main
```

**When prompted:**

- Username: `Poorvajan28`
- Password: Paste the GitHub PAT token you copied above

---

### Step 3: Verify on GitHub

1. Go to: https://github.com/Poorvajan28/SafeGirl-Pro
2. You should see all your files there ✅

---

## 🚀 VERCEL DEPLOYMENT

### Step 1: Deploy Backend

**In Your Browser:**

1. Visit: https://vercel.com
2. Sign in with GitHub
3. Click "Add New" → "Project"
4. Select repository: `SafeGirl-Pro`
5. Click "Import"
6. **Configure:**
   - Root Directory: `./backend`
   - Click "Deploy"

### Step 2: Add Environment Variables

After backend deployment starts:

1. Go to Settings → Environment Variables
2. Add these:

| Key         | Value                                                      |
| ----------- | ---------------------------------------------------------- |
| MONGODB_URI | `mongodb+srv://user:pass@cluster.mongodb.net/safegirl-pro` |
| JWT_SECRET  | `your-secret-key-here`                                     |
| NODE_ENV    | `production`                                               |

3. Click "Deploy" again

---

### Step 3: Get MongoDB Connection String

**DO THIS FIRST:**

1. Visit: https://www.mongodb.com/cloud/atlas
2. Create free account
3. Create a cluster (M0 tier is free)
4. Copy connection string
5. Use it in Vercel environment variables above

---

### Step 4: Deploy Frontend

1. In Vercel, click "Add New" → "Project"
2. Select: `SafeGirl-Pro` (same repository)
3. **Configure:**
   - Root Directory: `.` (leave as is)
   - Build Command: `flutter build web --release`
   - Output Directory: `build/web`
4. Click "Deploy"

---

### Step 5: Update API URL in Flutter

**After backend is deployed, run:**

```powershell
cd "d:\SafeGirl Pro"

# This will open the file - update the URL
notepad lib/config/api_config.dart
```

Find this line:

```dart
static const String baseUrl = 'http://localhost:5000/api';
```

Replace with (your backend URL):

```dart
static const String baseUrl = 'https://safegirl-pro-api.vercel.app/api';
```

Then run:

```powershell
git add lib/config/api_config.dart
git commit -m "Update API URL for production"
git push
```

Frontend will auto-redeploy! ✅

---

## 📊 Your Final URLs

After deployment completes:

**Frontend**: https://safegirl-pro.vercel.app
**Backend**: https://safegirl-pro-api.vercel.app
**Database**: MongoDB Atlas (free tier)

---

## ✅ COMPLETE CHECKLIST

- [ ] Created GitHub PAT token
- [ ] Pushed code to GitHub
- [ ] Verified repo on GitHub
- [ ] Created MongoDB Atlas cluster
- [ ] Deployed backend to Vercel
- [ ] Added environment variables
- [ ] Deployed frontend to Vercel
- [ ] Updated API URL in Flutter
- [ ] Verified frontend works
- [ ] Verified backend works

---

## 🎉 SUCCESS INDICATORS

### Backend Working ✅

```
Visit: https://safegirl-pro-api.vercel.app/api/health
You should see: {"status":"Server is running","timestamp":"..."}
```

### Frontend Working ✅

```
Visit: https://safegirl-pro.vercel.app
You should see the SafeGirl Pro app!
```

---

## 📞 QUICK REFERENCE

**GitHub Account**: https://github.com/Poorvajan28
**Vercel Account**: https://vercel.com (sign in with GitHub)
**MongoDB Atlas**: https://www.mongodb.com/cloud/atlas

**Your Repository**: https://github.com/Poorvajan28/SafeGirl-Pro
**Frontend URL**: https://safegirl-pro.vercel.app
**Backend URL**: https://safegirl-pro-api.vercel.app

---

## 🚀 START NOW!

1. **First**: Create GitHub PAT token (Step 1 above)
2. **Then**: Run PowerShell commands (Step 2)
3. **Finally**: Deploy on Vercel (Vercel Deployment section)

**Total Time**: ~20 minutes ⏱️
**Cost**: FREE ✅

---

**Status**: READY FOR DEPLOYMENT
**All Code**: Already Committed ✅
