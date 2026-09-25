# Build ابری APK

این پروژه برای GitHub Actions آماده شده است.

## روش استفاده

1. کل محتوای این پوشه را داخل یک Repository در GitHub قرار بده.
2. از تب **Actions**، ورک‌فلو **Build Android APK** را اجرا کن.
3. بعد از پایان موفق Build، در همان اجرای Workflow بخش **Artifacts** فایل `terebar-online-release-apk` را دانلود کن.
4. داخل فایل دانلودی، `app-release.apk` قرار دارد و می‌توانی آن را روی گوشی نصب کنی.

### اجرای دستی
در GitHub:
**Actions → Build Android APK → Run workflow**

### نکته
این Build برای تست و نصب روی گوشی با debug signing تنظیم شده و برای انتشار رسمی در Google Play باید release keystore واقعی اضافه شود.
