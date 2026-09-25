plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android { namespace = "com.terebaronline.app" }

android {
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion
    defaultConfig {
        applicationId = "com.terebaronline.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    buildTypes {
        release { signingConfig = signingConfigs.getByName("debug") }
    }
}

flutter { source = "../.." }
