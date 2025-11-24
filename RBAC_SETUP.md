# Role-Based Access Control (RBAC) Setup

## Overview
This document describes the role-based access control system implemented for the RoboCleaner DisposeBot application. The system supports two user roles: **Admin** and **User**, each with different access levels and features.

## Architecture

### User Roles

#### Admin Role
- Full access to all features
- Can access: Home, Monitoring, Schedules, Logs, Alerts, Settings
- Can manage system configurations and view detailed logs

#### User Role
- Limited access to core features
- Can access: Home, Monitoring, Alerts, Settings
- Cannot access: Schedules and Logs (admin-only features)

## Files Created/Modified

### New Files

#### 1. `lib/models/user.dart`
Defines the `User` model and `UserRole` enum.

```dart
enum UserRole { admin, user }

class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;
  // ... methods
}
```

**Features:**
- User data model with role information
- JSON serialization/deserialization
- Copy-with pattern for immutability

#### 2. `lib/services/auth_service.dart`
Singleton authentication service managing user login, registration, and role-based access.

```dart
class AuthService {
  User? get currentUser;
  bool get isAuthenticated;
  bool get isAdmin;
  bool get isUser;
  
  Future<User?> login({required String email, required String password});
  Future<User?> register({required String email, required String password, required String name});
  void logout();
}
```

**Features:**
- Singleton pattern for global access
- Mock user database (easily replaceable with backend)
- Session management
- Role checking methods

**Mock Users (for testing):**
- **Admin**: `admin@example.com` / `admin123`
- **User**: `user@example.com` / `user123`

### Modified Files

#### 1. `lib/screens/login_screen.dart`
Updated login screen with authentication integration.

**Changes:**
- Integrated `AuthService` for role-based login
- Added loading state during authentication
- Email notification via `EmailJsService` (preserved as requested)
- Role-based navigation to `MainShell`
- Error handling with user-friendly messages

**Key Features:**
- Validates credentials against `AuthService`
- Sends OTP email with role information
- Navigates based on user role
- Shows loading indicator during login

#### 2. `lib/screens/main_shell.dart`
Updated main navigation shell with role-based UI.

**Changes:**
- Added `userRole` parameter to constructor
- Separate page lists for admin and user roles
- Dynamic bottom navigation bar based on role
- Role label in AppBar title

**Admin Navigation (6 items):**
1. Home
2. Monitoring
3. Schedules
4. Logs
5. Alerts
6. Settings

**User Navigation (4 items):**
1. Home
2. Monitoring
3. Alerts
4. Settings

## Usage

### Login Flow

1. User enters email and password on login screen
2. `LoginScreen` calls `AuthService.login()`
3. Credentials are validated
4. If successful:
   - User object is created with role information
   - OTP email is sent via `EmailJsService` (unchanged)
   - User is navigated to `MainShell` with their role
5. `MainShell` displays role-appropriate UI

### Accessing Current User

```dart
final authService = AuthService();

// Check authentication
if (authService.isAuthenticated) {
  final user = authService.currentUser;
  print('Logged in as: ${user?.name}');
  
  // Check role
  if (authService.isAdmin) {
    // Show admin features
  } else if (authService.isUser) {
    // Show user features
  }
}
```

### Logout

```dart
final authService = AuthService();
authService.logout();
// Navigate to login screen
```

## Integration with EmailJS

The email authentication system remains **unchanged** as requested. The `EmailJsService` is still used to send OTP notifications:

```dart
await EmailJsService.sendOtp(
  toEmail: user.email,
  toName: user.name,
  otpCode: '${user.role.name.toUpperCase()} - ${DateTime.now().hour}:${DateTime.now().minute}',
);
```

The OTP code now includes the user's role for audit purposes.

## Testing

### Test Admin Login
1. Email: `admin@example.com`
2. Password: `admin123`
3. Expected: Full navigation bar with 6 items, "Admin" label in AppBar

### Test User Login
1. Email: `user@example.com`
2. Password: `user123`
3. Expected: Limited navigation bar with 4 items, "User" label in AppBar

## Future Enhancements

1. **Backend Integration**: Replace mock database with real backend API
2. **Token-based Auth**: Implement JWT tokens for session management
3. **Permission Granularity**: Add more granular permissions per feature
4. **Role Management**: Add admin panel to manage user roles
5. **Audit Logging**: Track role-based access for security
6. **Multi-factor Authentication**: Enhance security with MFA

## Security Considerations

⚠️ **Current Implementation Notes:**
- Mock passwords are stored in plaintext (for demo only)
- In production, implement:
  - Password hashing (bcrypt, argon2)
  - Secure token storage
  - HTTPS for all communications
  - Rate limiting on login attempts
  - Session timeout

## Troubleshooting

### Issue: User sees wrong navigation items
- **Solution**: Verify `userRole` is passed correctly to `MainShell`
- Check `AuthService.currentUser?.role` value

### Issue: Email not sending
- **Solution**: Verify `EmailJsService` credentials in `emailjs_service.dart`
- Check internet connectivity
- Review EmailJS dashboard for errors

### Issue: Login fails with "User not found"
- **Solution**: Use test credentials provided above
- Check email spelling (case-sensitive in mock database)

## API Reference

### AuthService Methods

#### `login(email, password)`
Authenticates user and returns User object if successful.

```dart
try {
  final user = await authService.login(
    email: 'user@example.com',
    password: 'password123',
  );
} catch (e) {
  print('Login failed: $e');
}
```

#### `register(email, password, name)`
Registers new user with 'user' role by default.

```dart
try {
  final user = await authService.register(
    email: 'newuser@example.com',
    password: 'password123',
    name: 'New User',
  );
} catch (e) {
  print('Registration failed: $e');
}
```

#### `logout()`
Clears current user session.

```dart
authService.logout();
```

## Support

For issues or questions about the RBAC system, refer to:
- `lib/services/auth_service.dart` - Authentication logic
- `lib/models/user.dart` - User model definition
- `lib/screens/login_screen.dart` - Login UI integration
- `lib/screens/main_shell.dart` - Role-based navigation
