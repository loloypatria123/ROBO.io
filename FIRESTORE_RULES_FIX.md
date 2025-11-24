# Fix Firestore Permission Denied Error

## Problem
You're getting: `[cloud_firestore/permission-denied] Missing or Insufficient permissions`

This means your Firestore security rules are blocking write access during registration.

---

## Solution: Update Firestore Security Rules

### Step 1: Go to Firebase Console
1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your project **robofinal-6694b**
3. Go to **Firestore Database**
4. Click on the **"Rules"** tab

### Step 2: Replace the Rules

**Delete all existing rules** and paste these new rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow anyone to read and write to users collection
    // (In production, you should use Firebase Auth instead)
    match /users/{email} {
      allow read, write: if true;
    }
  }
}
```

### Step 3: Publish the Rules
1. Click **"Publish"** button
2. Wait for confirmation message
3. Rules should now be active

---

## What These Rules Do

✅ **Allow anyone** to:
- Create new user documents (registration)
- Read user documents (login)
- Update user documents
- Delete user documents

⚠️ **Note**: These rules are for **development/testing only**. For production, use Firebase Authentication.

---

## Step-by-Step Screenshots Guide

### Finding the Rules Tab
```
Firebase Console
  ↓
Select "robofinal-6694b" project
  ↓
Click "Firestore Database" (left menu)
  ↓
Click "Rules" tab (top of page)
```

### Replacing the Rules
1. Select all text in the rules editor (Ctrl+A)
2. Delete it
3. Paste the new rules above
4. Click "Publish"

---

## After Updating Rules

### Test Registration Again
1. Run your Flutter app
2. Go to **Sign Up** page
3. Enter:
   - Name: Test User
   - Email: test@example.com
   - Password: test123
4. Click **Sign Up**
5. Enter the verification code sent to email
6. Should now work! ✅

### Verify in Firebase Console
1. Go to Firestore Database
2. Click on **users** collection
3. You should see a new document with your email
4. Document contains: id, email, name, password, role, createdAt

---

## If Still Getting Permission Error

### Check 1: Rules Published?
- Go to Rules tab
- Make sure you clicked "Publish" button
- Wait 30 seconds for rules to take effect

### Check 2: Correct Collection Name?
- Rules should match collection name exactly: `users`
- Check spelling carefully

### Check 3: Clear App Cache
- Stop the app
- Run: `flutter clean`
- Run: `flutter pub get`
- Run the app again

### Check 4: Restart Firebase Emulator (if using)
- If you're using Firebase emulator, restart it
- Make sure app is connecting to correct Firebase project

---

## Production Security Rules (Optional)

When you're ready for production, use these more secure rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to create their own user document during registration
    match /users/{email} {
      allow create: if request.auth == null;
      allow read, update: if request.auth != null && request.auth.uid == resource.data.uid;
      allow delete: if request.auth != null && request.auth.uid == resource.data.uid;
    }
  }
}
```

But for now, use the development rules above.

---

## Quick Fix Summary

1. ✅ Open Firebase Console
2. ✅ Go to Firestore Rules tab
3. ✅ Replace with development rules (allow read, write: if true;)
4. ✅ Click Publish
5. ✅ Wait 30 seconds
6. ✅ Test registration again

**After these steps, registration should work!**
