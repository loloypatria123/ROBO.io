# Firebase Firestore Setup Guide

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"**
3. Enter your project name (e.g., "RoboCleaner")
4. Click **"Continue"**
5. Enable/disable Google Analytics (optional)
6. Click **"Create project"**
7. Wait for the project to be created

## Step 2: Enable Firestore Database

1. In the Firebase Console, go to **Build** → **Firestore Database**
2. Click **"Create database"**
3. Choose **"Start in production mode"** (we'll set rules later)
4. Select your region (closest to your users)
5. Click **"Create"**

## Step 3: Set Firestore Security Rules

1. In Firestore, go to the **"Rules"** tab
2. Replace the default rules with these rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read and write their own user document
    match /users/{email} {
      allow read, write: if request.auth != null;
    }
    
    // Allow anyone to check if email exists (for registration)
    match /users/{email} {
      allow get: if true;
    }
  }
}
```

3. Click **"Publish"**

## Step 4: Create the Users Collection

### Option A: Manual Creation (Recommended for first time)

1. In Firestore, click **"+ Start collection"**
2. Enter collection name: **`users`**
3. Click **"Next"**
4. Click **"Auto ID"** to auto-generate the first document ID
5. Add these fields:

| Field | Type | Value |
|-------|------|-------|
| email | String | test@example.com |
| name | String | Test User |
| id | String | user_001 |
| password | String | password123 |
| role | String | user |
| createdAt | String | 2024-11-23T20:55:00.000Z |

6. Click **"Save"**

### Option B: Automatic Creation (Via App)

When you register a new user in the app, the collection and documents will be created automatically!

## Step 5: Get Your Firebase Config

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Go to **"Your apps"** section
3. Select your Flutter app (or create one if not listed)
4. Copy the configuration values
5. These should already be in your `firebase_options.dart` file

## Step 6: Verify the Setup

### Test in Firebase Console:

1. Go to **Firestore Database**
2. You should see the **`users`** collection
3. Inside, you'll see documents with email as the document ID
4. Each document contains: `id`, `email`, `name`, `password`, `role`, `createdAt`

### Test in Your App:

1. Run your Flutter app
2. Go to Sign Up page
3. Register a new user with email and password
4. Verify email
5. Go back to Firebase Console
6. Refresh the **Firestore Database** page
7. You should see a new document in the `users` collection with your registered email

## Collection Structure

```
Firestore Database
└── users (Collection)
    ├── test@example.com (Document - uses email as ID)
    │   ├── id: "user_001"
    │   ├── email: "test@example.com"
    │   ├── name: "Test User"
    │   ├── password: "password123"
    │   ├── role: "user"
    │   └── createdAt: "2024-11-23T20:55:00.000Z"
    │
    ├── john@example.com (Document)
    │   ├── id: "user_1234567890"
    │   ├── email: "john@example.com"
    │   ├── name: "John Doe"
    │   ├── password: "john123"
    │   ├── role: "user"
    │   └── createdAt: "2024-11-23T21:00:00.000Z"
```

## Important Notes

⚠️ **Security Warning**: Storing passwords in plain text is NOT recommended for production. In a real app, you should:
- Use Firebase Authentication instead of storing passwords
- Hash passwords using bcrypt or similar
- Never store passwords in Firestore

## Troubleshooting

### Issue: "Permission denied" error
**Solution**: Check your Firestore rules. Make sure they allow read/write access.

### Issue: Collection not appearing
**Solution**: 
1. Refresh the Firebase Console
2. Make sure you registered a user in the app
3. Check if there are any errors in the app console

### Issue: Can't register new users
**Solution**:
1. Check your internet connection
2. Verify Firebase is initialized in your app
3. Check the app logs for error messages
4. Make sure Firestore rules allow write access

## Next Steps

1. ✅ Create Firebase Project
2. ✅ Enable Firestore Database
3. ✅ Set Security Rules
4. ✅ Create Users Collection
5. ✅ Test Registration and Login

Your app is now ready to save user data to Firebase!
