plugins {
    id("com.android.application")
    id("kotlin-android")
    // لازم بعد Android/Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.smart_farmer"

    // استخدم قيم Flutter الافتراضية
    compileSdk = flutter.compileSdkVersion

    // لتوحيد نسخة الـ NDK مع الإضافات
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.smart_farmer"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Java/Kotlin 17
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    buildTypes {
        // Debug: لا تفعّل shrinkResources هنا
        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
        }

        // Release: لازم الاثنين معًا
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                file("proguard-rules.pro")
            )

            // مؤقتًا: وقّع بتوقيع debug (بدله لاحقًا لو عندك keystore)
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
