# 🔧 Profile Picture Troubleshooting Guide

## Common Issues & Solutions

### ❌ Issue: "Failed to take photo"
**Causes & Solutions:**

#### 1. Camera Permission Denied
```
Error: "Camera permission denied. Please enable camera access in settings."
```
**Solution:**
- Go to phone Settings → Apps → RoboFinal → Permissions
- Enable Camera permission
- Restart the app

#### 2. Camera Permanently Denied
```
Error: "Camera permission permanently denied. Please enable it in app settings."
```
**Solution:**
- Go to phone Settings → Apps → RoboFinal → Permissions
- Enable Camera permission (may need to clear app data first)
- Or reinstall the app

#### 3. Camera Not Available
```
Error: "Camera is not available on this device."
```
**Solution:**
- Check if device has a working camera
- Test camera in other apps
- Restart device

---

### ❌ Issue: "Failed to select image"
**Causes & Solutions:**

#### 1. Storage Permission Denied
```
Error: "Storage permission denied. Please enable storage access in settings."
```
**Solution:**
- Go to phone Settings → Apps → RoboFinal → Permissions
- Enable Storage permission
- Restart the app

#### 2. File Too Large
```
Error: "Image file is too large. Please choose a smaller image."
```
**Solution:**
- Choose an image smaller than 10MB
- Crop/resize the image before selecting
- Use a different image

#### 3. Unsupported Format
```
Error: "Unsupported image format. Please choose a valid image file."
```
**Solution:**
- Use JPG, PNG, or common image formats
- Avoid GIF, SVG, or other unsupported formats
- Convert image to JPG/PNG if needed

---

## 🔧 Platform-Specific Fixes

### Android Issues
```bash
# 1. Clear app data and cache
Settings → Apps → RoboFinal → Storage → Clear Data/Clear Cache

# 2. Reinstall app
Uninstall → Install from Play Store/Debug

# 3. Check permissions
Settings → Apps → RoboFinal → Permissions → Camera/Storage → Allow
```

### iOS Issues
```bash
# 1. Check permissions
Settings → RoboFinal → Photos & Camera → Allow

# 2. Reset permissions
Settings → General → Reset → Reset Location & Privacy
```

---

## 🧪 Testing Checklist

### ✅ Pre-Flight Checks
- [ ] App has camera permission
- [ ] App has storage permission  
- [ ] Device has working camera
- [ ] Device has gallery access
- [ ] Internet connection (for Firebase)

### ✅ Camera Test
1. Open Settings screen
2. Tap profile picture
3. Select "Camera"
4. Grant permission if asked
5. Take a photo
6. Verify image appears

### ✅ Gallery Test
1. Open Settings screen  
2. Tap profile picture
3. Select "Gallery"
4. Grant permission if asked
5. Choose an image
6. Verify image appears

---

## 🛠️ Developer Fixes

### 1. Missing Permissions in AndroidManifest.xml
```xml
<!-- Add to android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-feature android:name="android.hardware.camera" />
<uses-feature android:name="android.hardware.camera.autofocus" />
```

### 2. Missing Permissions in Info.plist (iOS)
```xml
<!-- Add to ios/Runner/Info.plist -->
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take profile pictures</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to select profile pictures</string>
```

### 3. Run Flutter Clean
```bash
flutter clean
flutter pub get
flutter run
```

### 4. Check Dependencies
```yaml
# Verify in pubspec.yaml
dependencies:
  image_picker: ^1.1.2
  permission_handler: ^11.3.1
  path_provider: ^2.1.3
```

---

## 📱 Device-Specific Issues

### Samsung Devices
- May need to enable "Allow modify system settings"
- Check battery optimization settings

### Xiaomi/Redmi Devices  
- May need to enable "Display popup windows"
- Check "Auto-start" permissions

### Huawei Devices
- May need to manually enable permissions
- Check "Protected apps" settings

---

## 🔍 Debug Steps

### 1. Check Console Logs
```bash
# Run with verbose logging
flutter run --verbose
```

### 2. Test Permissions Manually
```dart
// Add this debug code to check permissions
Future<void> debugPermissions() async {
  final cameraStatus = await Permission.camera.status;
  final storageStatus = await Permission.photos.status;
  
  print('Camera: $cameraStatus');
  print('Storage: $storageStatus');
}
```

### 3. Test Image Picker Directly
```dart
// Simple test
final ImagePicker picker = ImagePicker();
final XFile? image = await picker.pickImage(source: ImageSource.camera);
print('Image path: ${image?.path}');
```

---

## 🚨 Emergency Fixes

### If Nothing Works:
1. **Restart Device** - Simple but often effective
2. **Reinstall App** - Fresh permissions and data
3. **Check OS Updates** - May fix permission bugs
4. **Test on Different Device** - Isolate device-specific issues

### Last Resort:
- Use a different device for testing
- Report the device model and OS version
- Check if other apps have camera/gallery issues

---

## 📞 Support Information

### What to Report When Asking for Help:
```
Device: [Brand/Model]
OS Version: [Android/iOS version]
App Version: [RoboFinal version]
Error Message: [Exact error text]
Steps to Reproduce: [What you did]
Permissions Status: [Camera/Storage enabled?]
```

### Quick Debug Commands:
```dart
// Add to your code for debugging
print('Device info: ${Platform.operatingSystem}');
print('OS version: ${Platform.operatingSystemVersion}');
print('App version: ${PackageInfo.fromPlatform()}');
```

---

## ✅ Success Indicators

### Working Correctly When:
✅ Camera opens without errors
✅ Photo saves and displays
✅ Gallery opens without errors  
✅ Image selection works
✅ Profile picture updates
✅ Success messages appear
✅ Image persists after restart

### Still Having Issues?
- Check all permissions are granted
- Try with a different image
- Test on a different device
- Contact support with device details

---

## 🎯 Quick Fix Summary

| Issue | Quick Fix |
|-------|-----------|
| Camera denied | Enable camera permission in settings |
| Gallery denied | Enable storage permission in settings |
| File too large | Choose smaller image (<10MB) |
| Unsupported format | Use JPG/PNG only |
| Camera unavailable | Test camera in other apps |
| App crashes | Restart app, check permissions |

---

**Status: 📋 Complete Troubleshooting Guide**
