# Test Credentials for Role-Based Access Control

## Quick Start

Use these credentials to test the role-based access control system:

### Admin Account
- **Email**: `admin@example.com`
- **Password**: `admin123`
- **Role**: Admin
- **Access**: Full access to all features (Home, Monitoring, Schedules, Logs, Alerts, Settings)

### User Account
- **Email**: `user@example.com`
- **Password**: `user123`
- **Role**: User
- **Access**: Limited access (Home, Monitoring, Alerts, Settings)

## What to Expect

### After Admin Login
1. AppBar title shows: "RoboCleaner DisposeBot – Admin"
2. Bottom navigation bar displays 6 items:
   - Home
   - Monitoring
   - Schedules
   - Logs
   - Alerts
   - Settings
3. Email notification sent with: "ADMIN - HH:MM"

### After User Login
1. AppBar title shows: "RoboCleaner DisposeBot – User"
2. Bottom navigation bar displays 4 items:
   - Home
   - Monitoring
   - Alerts
   - Settings
3. Email notification sent with: "USER - HH:MM"
4. Schedules and Logs tabs are hidden

## Testing Steps

### Test 1: Admin Login
1. Open the app and navigate to login screen
2. Enter email: `admin@example.com`
3. Enter password: `admin123`
4. Click "Sign In"
5. Verify: Full navigation bar appears with all 6 items

### Test 2: User Login
1. Open the app and navigate to login screen
2. Enter email: `user@example.com`
3. Enter password: `user123`
4. Click "Sign In"
5. Verify: Limited navigation bar appears with 4 items

### Test 3: Invalid Credentials
1. Enter any email and wrong password
2. Click "Sign In"
3. Verify: Error message appears "Login failed: Invalid password"

### Test 4: Non-existent User
1. Enter email: `nonexistent@example.com`
2. Enter any password
3. Click "Sign In"
4. Verify: Error message appears "Login failed: User not found"

## Email Notifications

When you successfully log in, an email is sent to your registered email address with:
- **To**: Your email address
- **Subject**: OTP Verification (configured in EmailJS)
- **Body**: Includes your role and login timestamp

**Note**: Email sending uses the EmailJS service configured in `lib/services/emailjs_service.dart`

## Adding New Test Users

To add more test users, edit `lib/services/auth_service.dart`:

```dart
static final Map<String, Map<String, dynamic>> _mockUsers = {
  'your-email@example.com': {
    'id': 'user_001',
    'email': 'your-email@example.com',
    'name': 'Your Name',
    'password': 'your-password',
    'role': 'admin', // or 'user'
    'createdAt': DateTime.now().toIso8601String(),
  },
};
```

## Troubleshooting

### Login Button Shows Loading Spinner
- This is normal - the authentication is processing
- Wait for it to complete (simulates 500ms network delay)

### "User not found" Error
- Double-check the email spelling
- Use the exact test credentials provided above
- Email is case-sensitive in the mock database

### Email Not Received
- Verify EmailJS credentials are correct in `emailjs_service.dart`
- Check your email spam/junk folder
- Verify internet connection

### Wrong Navigation Items Showing
- Clear app cache and restart
- Verify you're using the correct test credentials
- Check that `MainShell` is receiving the `userRole` parameter

## Production Migration

When migrating to production:

1. **Replace Mock Database**: Connect to your backend API
2. **Implement Real Authentication**: Use OAuth, JWT, or similar
3. **Secure Passwords**: Hash passwords with bcrypt or argon2
4. **Add Rate Limiting**: Prevent brute force attacks
5. **Implement Session Management**: Use secure tokens
6. **Add Audit Logging**: Track all authentication events

See `RBAC_SETUP.md` for more details on the architecture.
