import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:robofinal/models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  User? _currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  bool get isAdmin => _currentUser?.role == UserRole.admin;

  bool get isUser => _currentUser?.role == UserRole.user;

  // Mock database of users - fallback for testing
  static final Map<String, Map<String, dynamic>> _mockUsers = {
    'admin@example.com': {
      'id': 'admin_001',
      'email': 'admin@example.com',
      'name': 'Admin User',
      'password': 'admin123', // In production, use hashed passwords
      'role': 'admin',
      'createdAt': DateTime.now().toIso8601String(),
    },
    'user@example.com': {
      'id': 'user_001',
      'email': 'user@example.com',
      'name': 'Regular User',
      'password': 'user123', // In production, use hashed passwords
      'role': 'user',
      'createdAt': DateTime.now().toIso8601String(),
    },
  };

  /// Authenticate user with email and password
  /// Returns the authenticated user if successful, null otherwise
  Future<User?> login({required String email, required String password}) async {
    try {
      // Check Firebase first
      final doc = await _firestore.collection('users').doc(email).get();

      if (doc.exists) {
        final userData = doc.data() as Map<String, dynamic>;

        if (userData['password'] != password) {
          throw Exception('Invalid password');
        }

        _currentUser = User(
          id: userData['id'] as String,
          email: userData['email'] as String,
          name: userData['name'] as String,
          role: userData['role'] == 'admin' ? UserRole.admin : UserRole.user,
          createdAt: DateTime.parse(userData['createdAt'] as String),
        );

        return _currentUser;
      }

      // Fallback to mock database for testing
      final userData = _mockUsers[email];

      if (userData == null) {
        throw Exception('User not found');
      }

      if (userData['password'] != password) {
        throw Exception('Invalid password');
      }

      _currentUser = User(
        id: userData['id'] as String,
        email: userData['email'] as String,
        name: userData['name'] as String,
        role: userData['role'] == 'admin' ? UserRole.admin : UserRole.user,
        createdAt: DateTime.parse(userData['createdAt'] as String),
      );

      return _currentUser;
    } catch (e) {
      _currentUser = null;
      rethrow;
    }
  }

  /// Register a new user (defaults to 'user' role)
  Future<User?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Check if user already exists in Firebase
      final doc = await _firestore.collection('users').doc(email).get();
      if (doc.exists) {
        throw Exception('User already exists');
      }

      // Check mock database as fallback
      if (_mockUsers.containsKey(email)) {
        throw Exception('User already exists');
      }

      final newUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        role: UserRole.user,
        createdAt: DateTime.now(),
      );

      // Save to Firebase
      await _firestore.collection('users').doc(email).set({
        'id': newUser.id,
        'email': newUser.email,
        'name': newUser.name,
        'password': password,
        'role': 'user',
        'createdAt': newUser.createdAt.toIso8601String(),
      });

      // Also save to mock database for fallback
      _mockUsers[email] = {
        'id': newUser.id,
        'email': newUser.email,
        'name': newUser.name,
        'password': password,
        'role': 'user',
        'createdAt': newUser.createdAt.toIso8601String(),
      };

      _currentUser = newUser;
      return _currentUser;
    } catch (e) {
      _currentUser = null;
      rethrow;
    }
  }

  /// Logout the current user
  void logout() {
    _currentUser = null;
  }

  /// Get user role as string
  String? getUserRoleString() {
    return _currentUser?.role == UserRole.admin ? 'admin' : 'user';
  }

  /// Check if user exists by email
  Future<bool> checkUserExists(String email) async {
    try {
      // Check Firebase first
      final doc = await _firestore.collection('users').doc(email).get();
      if (doc.exists) {
        return true;
      }

      // Check mock database as fallback
      return _mockUsers.containsKey(email);
    } catch (e) {
      return false;
    }
  }

  /// Reset user password
  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      // Check if user exists in Firebase
      final doc = await _firestore.collection('users').doc(email).get();
      if (doc.exists) {
        // Update password in Firebase
        await _firestore.collection('users').doc(email).update({
          'password': newPassword,
        });

        // Also update mock database
        if (_mockUsers.containsKey(email)) {
          _mockUsers[email]!['password'] = newPassword;
        }

        return true;
      }

      // Check mock database
      if (_mockUsers.containsKey(email)) {
        _mockUsers[email]!['password'] = newPassword;
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Update user profile picture
  /// Returns true if successful, false otherwise
  Future<bool> updateProfilePicture({
    required String email,
    required String profilePictureUrl,
  }) async {
    try {
      // Check if user exists in Firebase
      final doc = await _firestore.collection('users').doc(email).get();
      if (doc.exists) {
        // Update profile picture in Firebase
        await _firestore.collection('users').doc(email).update({
          'profilePicture': profilePictureUrl,
        });

        // Also update mock database
        if (_mockUsers.containsKey(email)) {
          _mockUsers[email]!['profilePicture'] = profilePictureUrl;
        }

        // Update current user if it's the same user
        if (_currentUser?.email == email) {
          _currentUser = _currentUser!.copyWith(
            profilePicture: profilePictureUrl,
          );
        }

        return true;
      }

      // Check mock database
      if (_mockUsers.containsKey(email)) {
        _mockUsers[email]!['profilePicture'] = profilePictureUrl;

        // Update current user if it's the same user
        if (_currentUser?.email == email) {
          _currentUser = _currentUser!.copyWith(
            profilePicture: profilePictureUrl,
          );
        }

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
