# Role-Based Access Control Architecture

## System Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        LOGIN SCREEN                             │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Email Input: admin@example.com or user@example.com     │  │
│  │  Password Input: ••••••••                               │  │
│  │  [Sign In Button]                                       │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
            ┌────────────────────────────┐
            │   AuthService.login()      │
            │  (Validates Credentials)   │
            └────────────┬───────────────┘
                         │
        ┌────────────────┴────────────────┐
        │                                 │
        ▼                                 ▼
   ✓ Valid                          ✗ Invalid
   (User Found)                    (Error)
        │                                 │
        ▼                                 ▼
   Create User                    Show Error Message
   Object with Role               "Login failed: ..."
        │                                 │
        ▼                                 │
   Send OTP Email                        │
   via EmailJsService                    │
        │                                 │
        ▼                                 │
   Navigate to MainShell                 │
   with userRole parameter               │
        │                                 │
        └─────────────────┬───────────────┘
                          │
                          ▼
            ┌─────────────────────────────┐
            │      MAIN SHELL             │
            │  (Role-Based Navigation)    │
            └────────────┬────────────────┘
                         │
        ┌────────────────┴────────────────┐
        │                                 │
        ▼                                 ▼
    ADMIN ROLE                       USER ROLE
    (6 Items)                        (4 Items)
    ┌──────────────────┐            ┌──────────────────┐
    │ 1. Home          │            │ 1. Home          │
    │ 2. Monitoring    │            │ 2. Monitoring    │
    │ 3. Schedules     │            │ 3. Alerts        │
    │ 4. Logs          │            │ 4. Settings      │
    │ 5. Alerts        │            └──────────────────┘
    │ 6. Settings      │
    └──────────────────┘
```

## Component Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────┐        ┌──────────────────────────────┐  │
│  │  LoginScreen     │        │      MainShell               │  │
│  │  ├─ Email Input  │        │  ├─ Admin Navigation (6)     │  │
│  │  ├─ Password     │        │  ├─ User Navigation (4)      │  │
│  │  └─ Submit       │        │  └─ Role-based UI            │  │
│  └────────┬─────────┘        └──────────────────────────────┘  │
│           │                                                     │
└───────────┼─────────────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    SERVICE LAYER                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────┐  ┌──────────────────────────┐   │
│  │   AuthService            │  │  EmailJsService          │   │
│  │  (Singleton)             │  │  (Email Notifications)   │   │
│  │  ├─ login()              │  │  ├─ sendOtp()            │   │
│  │  ├─ register()           │  │  └─ Email Config         │   │
│  │  ├─ logout()             │  └──────────────────────────┘   │
│  │  ├─ currentUser          │                                 │
│  │  ├─ isAdmin              │                                 │
│  │  └─ isUser               │                                 │
│  └──────────────────────────┘                                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    MODEL LAYER                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  User Model                                              │  │
│  │  ├─ id: String                                           │  │
│  │  ├─ email: String                                        │  │
│  │  ├─ name: String                                         │  │
│  │  ├─ role: UserRole (admin | user)                        │  │
│  │  └─ createdAt: DateTime                                  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    DATA LAYER                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Mock Database (In-Memory)                               │  │
│  │  ├─ admin@example.com → {id, name, role: 'admin'}       │  │
│  │  └─ user@example.com → {id, name, role: 'user'}         │  │
│  │                                                          │  │
│  │  [Future: Replace with Backend API]                     │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Class Diagram

```
┌─────────────────────────────────┐
│        UserRole (Enum)          │
├─────────────────────────────────┤
│ • admin                         │
│ • user                          │
└─────────────────────────────────┘
           △
           │ uses
           │
┌─────────────────────────────────┐
│         User (Model)            │
├─────────────────────────────────┤
│ - id: String                    │
│ - email: String                 │
│ - name: String                  │
│ - role: UserRole                │
│ - createdAt: DateTime           │
├─────────────────────────────────┤
│ + fromJson()                    │
│ + toJson()                      │
│ + copyWith()                    │
└─────────────────────────────────┘
           △
           │ manages
           │
┌─────────────────────────────────┐
│    AuthService (Singleton)      │
├─────────────────────────────────┤
│ - _currentUser: User?           │
│ - _mockUsers: Map               │
├─────────────────────────────────┤
│ + login(): Future<User?>        │
│ + register(): Future<User?>     │
│ + logout(): void                │
│ + currentUser: User?            │
│ + isAuthenticated: bool         │
│ + isAdmin: bool                 │
│ + isUser: bool                  │
└─────────────────────────────────┘
           △
           │ uses
           │
┌─────────────────────────────────┐
│    LoginScreen (Widget)         │
├─────────────────────────────────┤
│ - _authService: AuthService     │
│ - _emailController              │
│ - _passwordController           │
│ - _isLoading: bool              │
├─────────────────────────────────┤
│ + _submit(): Future<void>       │
│ + build(): Widget               │
└─────────────────────────────────┘
           │
           │ navigates to
           ▼
┌─────────────────────────────────┐
│    MainShell (Widget)           │
├─────────────────────────────────┤
│ - userRole: UserRole?           │
│ - _authService: AuthService     │
│ - _adminPages: List<Widget>     │
│ - _userPages: List<Widget>      │
├─────────────────────────────────┤
│ + _isAdmin: bool                │
│ + _currentPages: List<Widget>   │
│ + build(): Widget               │
└─────────────────────────────────┘
```

## Data Flow Sequence

```
User                LoginScreen         AuthService         EmailJsService
 │                      │                    │                    │
 │─ Enter Credentials ──>│                    │                    │
 │                      │─ login() ─────────>│                    │
 │                      │                    │─ Validate ─────────┐
 │                      │                    │<────────────────────┘
 │                      │                    │─ Create User Obj    │
 │                      │<─ User Object ─────│                    │
 │                      │                    │─ Send OTP ──────────────────>│
 │                      │                    │                    │─ Email  │
 │                      │                    │                    │<─ OK ───┘
 │                      │<─ Success ─────────────────────────────┘
 │<─ Navigate to MainShell with userRole ────│
 │                      │                    │
 │                      └────────────────────┘
 │
 └─> MainShell (Role-based UI)
```

## State Management Flow

```
┌─────────────────────────────────────────────────────────────┐
│                  AUTHENTICATION STATE                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  AuthService._currentUser = null                           │
│  ├─ isAuthenticated = false                                │
│  ├─ isAdmin = false                                        │
│  └─ isUser = false                                         │
│                                                             │
│  [User enters credentials and clicks Sign In]              │
│                                                             │
│  AuthService._currentUser = User(                          │
│    id: "admin_001",                                        │
│    email: "admin@example.com",                             │
│    name: "Admin User",                                     │
│    role: UserRole.admin,                                   │
│    createdAt: DateTime.now()                               │
│  )                                                          │
│  ├─ isAuthenticated = true                                 │
│  ├─ isAdmin = true                                         │
│  └─ isUser = false                                         │
│                                                             │
│  MainShell receives userRole = UserRole.admin              │
│  ├─ Shows 6 navigation items                               │
│  ├─ AppBar title = "RoboCleaner DisposeBot – Admin"       │
│  └─ Displays admin pages                                   │
│                                                             │
│  [User clicks Logout]                                      │
│                                                             │
│  AuthService._currentUser = null                           │
│  ├─ isAuthenticated = false                                │
│  ├─ isAdmin = false                                        │
│  └─ isUser = false                                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## File Structure

```
lib/
├── models/
│   ├── user.dart                    ← User model with role
│   ├── alert.dart
│   ├── cleaning_schedule.dart
│   ├── log_entry.dart
│   └── robot_status.dart
├── services/
│   ├── auth_service.dart            ← Authentication & RBAC
│   └── emailjs_service.dart         ← Email notifications (unchanged)
├── screens/
│   ├── login_screen.dart            ← Updated with auth integration
│   ├── main_shell.dart              ← Updated with role-based UI
│   ├── home_screen.dart
│   ├── monitoring_screen.dart
│   ├── schedules_screen.dart        ← Admin only
│   ├── logs_screen.dart             ← Admin only
│   ├── notifications_screen.dart
│   ├── settings_screen.dart
│   ├── signup_screen.dart
│   ├── splash_screen.dart
│   ├── verification_screen.dart
│   └── welcome_screen.dart
└── main.dart
```

## Security Layers

```
┌─────────────────────────────────────────────────────────────┐
│                   SECURITY LAYERS                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Layer 1: Authentication                                   │
│  ├─ Email/Password validation                              │
│  ├─ User existence check                                   │
│  └─ Session creation                                       │
│                                                             │
│  Layer 2: Authorization (RBAC)                             │
│  ├─ Role-based feature access                              │
│  ├─ Navigation item visibility                             │
│  └─ UI element rendering                                   │
│                                                             │
│  Layer 3: Audit & Logging                                  │
│  ├─ Login timestamp                                        │
│  ├─ Role information in email                              │
│  └─ [Future: Detailed audit logs]                          │
│                                                             │
│  Layer 4: Session Management                               │
│  ├─ Current user tracking                                  │
│  ├─ Logout functionality                                   │
│  └─ [Future: Token expiration]                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Integration Points

```
EmailJsService (Unchanged)
        ↑
        │ sendOtp()
        │
    LoginScreen
        │
        ├─→ AuthService.login()
        │
        └─→ MainShell(userRole: user.role)
                │
                ├─→ Admin Pages (if admin)
                │   ├─ Home
                │   ├─ Monitoring
                │   ├─ Schedules
                │   ├─ Logs
                │   ├─ Alerts
                │   └─ Settings
                │
                └─→ User Pages (if user)
                    ├─ Home
                    ├─ Monitoring
                    ├─ Alerts
                    └─ Settings
```
