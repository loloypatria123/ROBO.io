# Firebase Quick Start - 5 Minutes

## Your Firebase Project

✅ **Project ID**: robofinal-6694b
✅ **Status**: Already configured
✅ **Platforms**: Android, iOS, Web, Windows, macOS

---

## Step 1: Access Firebase Console (1 minute)

1. Go to: https://console.firebase.google.com/
2. Sign in with your Google account
3. Click **robofinal-6694b** project
4. You're in! ✓

---

## Step 2: Verify Your Project (1 minute)

In Firebase Console, check:

- [ ] **Project Settings** → Project ID is `robofinal-6694b`
- [ ] **Authentication** → Email/Password is enabled
- [ ] **Firestore Database** → Database exists (or create one)
- [ ] **Storage** → Bucket exists

---

## Step 3: Set Up Firestore (2 minutes)

### If Firestore doesn't exist:
1. Click **Firestore Database** in left menu
2. Click **Create Database**
3. Choose **Production mode**
4. Select region (e.g., us-central1)
5. Click **Create**

### Create Users Collection:
1. Click **Create collection**
2. Name: `users`
3. Click **Auto ID** for first document
4. Add fields:
   - `email`: "admin@example.com"
   - `name`: "Admin User"
   - `role`: "admin"
   - `createdAt`: (current timestamp)
5. Click **Save**

---

## Step 4: Enable Authentication (1 minute)

1. Click **Authentication** in left menu
2. Click **Sign-in method** tab
3. Click **Email/Password**
4. Toggle **Enable** both options
5. Click **Save**

---

## Done! ✓

Your Firebase is now connected and ready to use.

---

## Quick Reference

| Item | Value |
|------|-------|
| Project ID | robofinal-6694b |
| Console URL | https://console.firebase.google.com/ |
| Auth Method | Email/Password |
| Database | Firestore |
| Status | ✅ Ready |

---

## Next: Integrate with Your App

See **FIREBASE_SETUP_GUIDE.md** for code integration examples.

---

## Troubleshooting

**Can't access Firebase Console?**
- Make sure you're signed in with the correct Google account
- Check internet connection

**Project not showing?**
- Refresh the page
- Check you're in the correct Google account

**Firestore not accessible?**
- Create the database first
- Check security rules

---

**Time to complete**: ~5 minutes
**Status**: Ready for integration
