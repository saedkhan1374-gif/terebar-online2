# تره‌بار آنلاین — پروژه آماده Build APK

این پروژه نسخه Flutter اپ تره‌بار آنلاین است و پوشه Android نیز برای Build اضافه شده است.

## پیش‌نیاز
- Flutter 3.22 یا جدیدتر
- Android Studio و Android SDK
- JDK سازگار با نسخه Android Gradle Plugin

## Build سریع
در ریشه پروژه اجرا کنید:

```bash
flutter pub get
flutter doctor
flutter build apk --release
```

فایل خروجی:
`build/app/outputs/flutter-apk/app-release.apk`

## اجرای تست روی گوشی
USB Debugging را فعال کنید و:

```bash
flutter devices
flutter run
```

نام پکیج: `com.terebaronline.app`
نسخه: `0.1.0+1`
