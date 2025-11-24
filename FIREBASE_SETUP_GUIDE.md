# Firebase Console Connection Guide

## Current Status

✅ **Firebase is already configured in your project**

Your app is connected to Firebase project: **robofinal-6694b**

---

## Firebase Project Details

| Property | Value |
|----------|-------|
| **Project ID** | robofinal-6694b |
| **Project Number** | 603908914578 |
| **Auth Domain** | robofinal-6694b.firebaseapp.com |
| **Storage Bucket** | robofinal-6694b.firebasestorage.app |

---

## Access Your Firebase Console

### Step 1: Open Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Sign in with your Google account

### Step 2: Select Your Project
1. Click on **robofinal-6694b** project
2. You should see your project dashboard

### Step 3: Verify Platforms
In the Firebase Console, you should see:
- ✅ Android app
- ✅ iOS app
- ✅ Web app
- ✅ Windows app
- ✅ macOS app

---

## Current Configuration

### Web Configuration
```
API Key: AIzaSyBSSaoqF6BDCt3HWuXhmpKRzZAC0EAWoPI
App ID: 1:603908914578:web:337a4c144fe687823b954b
Messaging Sender ID: 603908914578
Project ID: robofinal-6694b
Auth Domain: robofinal-6694b.firebaseapp.com
Storage Bucket: robofinal-6694b.firebasestorage.app
Measurement ID: G-FTPG6NXXV9
```

### Android Configuration
```
API Key: AIzaSyAHJijOdLAz35TOH5dm7vEXP6HMCC05jHI
App ID: 1:603908914578:android:04593a5e491a18443b954b
Messaging Sender ID: 603908914578
Project ID: robofinal-6694b
Storage Bucket: robofinal-6694b.firebasestorage.app
```

### iOS Configuration
```
API Key: AIzaSyBrgcRD3fXd-rc8QUU_kttx1fOgz4FACPI
App ID: 1:603908914578:ios:24eabbdf4a7a26ec3b954b
Messaging Sender ID: 603908914578
Project ID: robofinal-6694b
Storage Bucket: robofinal-6694b.firebasestorage.app
Bundle ID: com.example.robofinal
```

---

## Firebase Services Available

### ✅ Enabled Services

1. **Firebase Authentication**
   - Email/Password authentication
   - Ready to use in your RBAC system

2. **Cloud Firestore**
   - NoSQL database
   - Ready for data storage

3. **Cloud Storage**
   - File storage
   - Ready for uploads

4. **Firebase Messaging**
   - Push notifications
   - Ready for alerts

---

## Integrate Firebase into Your RBAC System

### Option 1: Replace Mock Database with Firestore

Edit `lib/services/auth_service.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  User? _currentUser;

  // Login with Firebase Authentication
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user role from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      final userData = userDoc.data();
      
      _currentUser = User(
        id: userCredential.user!.uid,
        email: userCredential.user!.email ?? '',
        name: userData?['name'] ?? 'User',
        role: userData?['role'] == 'admin' ? UserRole.admin : UserRole.user,
        createdAt: DateTime.parse(userData?['createdAt'] ?? DateTime.now().toIso8601String()),
      );

      return _currentUser;
    } catch (e) {
      _currentUser = null;
      rethrow;
    }
  }

  // Register with Firebase Authentication
  Future<User?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final newUser = User(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        role: UserRole.user,
        createdAt: DateTime.now(),
      );

      // Save user to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'id': newUser.id,
        'email': newUser.email,
        'name': newUser.name,
        'role': 'user',
        'createdAt': newUser.createdAt.toIso8601String(),
      });

      _currentUser = newUser;
      return _currentUser;
    } catch (e) {
      _currentUser = null;
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
  }
}
```

### Option 2: Store User Data in Firestore

Create a `lib/services/firestore_service.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:robofinal/models/user.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  // Save user data
  Future<void> saveUser(User user) async {
    await _firestore.collection('users').doc(user.id).set({
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'role': user.role == UserRole.admin ? 'admin' : 'user',
      'createdAt': user.createdAt.toIso8601String(),
    });
  }

  // Get user data
  Future<User?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return User.fromJson(doc.data()!);
    }
    return null;
  }

  // Update user role
  Future<void> updateUserRole(String userId, UserRole role) async {
    await _firestore.collection('users').doc(userId).update({
      'role': role == UserRole.admin ? 'admin' : 'user',
    });
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }
}
```

---

## Set Up Firestore Database

### Step 1: Create Firestore Database
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select **robofinal-6694b** project
3. Click **Firestore Database** in left menu
4. Click **Create Database**
5. Choose **Start in production mode**
6. Select region (e.g., us-central1)
7. Click **Create**

### Step 2: Create Users Collection
1. In Firestore, click **Create collection**
2. Name it: `users`
3. Add first document with:
   ```
   Document ID: admin_001
   Fields:
   - id: "admin_001"
   - email: "admin@example.com"
   - name: "Admin User"
   - role: "admin"
   - createdAt: "2024-11-20T00:00:00.000Z"
   ```

### Step 3: Set Security Rules
Replace default rules with:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      allow read: if request.auth.uid != null && 
                     get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

---

## Set Up Firebase Authentication

### Step 1: Enable Email/Password Authentication
1. Go to Firebase Console
2. Click **Authentication** in left menu
3. Click **Sign-in method** tab
4. Click **Email/Password**
5. Enable both options
6. Click **Save**

### Step 2: Create Test Users
1. In Authentication tab, click **Users** tab
2. Click **Add user**
3. Enter email: `admin@example.com`
4. Enter password: `admin123`
5. Click **Add user**
6. Repeat for `user@example.com` / `user123`

---

## Test Firebase Connection

### Create Test Script
Create `lib/services/firebase_test.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> testFirebaseConnection() async {
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✓ Firebase initialized successfully');

    // Test Firestore connection
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('users').limit(1).get();
    print('✓ Firestore connection successful');
    print('✓ Users collection accessible');
    print('✓ Found ${snapshot.docs.length} documents');

  } catch (e) {
    print('✗ Firebase connection failed: $e');
  }
}
```

---

## Troubleshooting

### Issue: "Permission denied" error
**Solution**: 
- Check Firestore security rules
- Ensure user is authenticated
- Verify user ID matches document ID

### Issue: "Project not found"
**Solution**:
- Verify project ID in firebase_options.dart
- Check Firebase Console for correct project
- Regenerate firebase_options.dart using FlutterFire CLI

### Issue: "Authentication failed"
**Solution**:
- Enable Email/Password authentication in Firebase Console
- Verify user exists in Firebase Authentication
- Check email/password are correct

### Issue: "Firestore not initialized"
**Solution**:
- Ensure Firebase.initializeApp() is called in main()
- Check firebase_options.dart is correct
- Verify internet connection

---

## Update main.dart for Firebase

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robofinal/screens/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoboCleaner DisposeBot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
```

---

## Firebase CLI Commands

### Regenerate Firebase Options
```bash
flutterfire configure --project=robofinal-6694b
```

### Deploy Firestore Rules
```bash
firebase deploy --only firestore:rules
```

### View Logs
```bash
firebase functions:log
```

---

## Security Best Practices

✅ **Do:**
- Use Firebase Authentication for user management
- Store sensitive data in Firestore with proper rules
- Use environment variables for API keys
- Enable HTTPS for all communications
- Implement proper error handling

❌ **Don't:**
- Expose API keys in client code
- Store passwords in plaintext
- Allow unauthenticated database access
- Disable security rules in production
- Commit sensitive data to version control

---

## Next Steps

1. **Verify Connection**
   - Open Firebase Console
   - Check robofinal-6694b project
   - Verify all platforms are registered

2. **Set Up Firestore**
   - Create users collection
   - Add security rules
   - Create test documents

3. **Integrate with RBAC**
   - Update AuthService to use Firebase
   - Replace mock database
   - Test authentication flow

4. **Deploy**
   - Test on all platforms
   - Monitor Firebase usage
   - Set up billing alerts

---

## Useful Links

- [Firebase Console](https://console.firebase.google.com/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Cloud Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Authentication Documentation](https://firebase.google.com/docs/auth)

---

## Support

For Firebase-related issues:
1. Check [Firebase Status](https://status.firebase.google.com/)
2. Review [Firebase Documentation](https://firebase.google.com/docs)
3. Check project logs in Firebase Console
4. Review security rules in Firestore

---

**Firebase Project**: robofinal-6694b
**Status**: ✅ Configured and Ready
**Last Updated**: November 20, 2024
