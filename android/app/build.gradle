plugins {
    id "com.android.application"
    id "org.jetbrains.kotlin.android"
    // مهم: هذا هو البلجن الحديث للتكامل مع Flutter
    id "dev.flutter.flutter-gradle-plugin"
}

android {
    namespace "com.abood.example.smart_farmer"

    // استخدم الصياغة الحديثة مع AGP 8+
    compileSdk = 35

    defaultConfig {
        applicationId "com.abood.example.smart_farmer"
        // يُفضّل 23 فما فوق لدعم معظم الإضافات الحديثة
        minSdk = 23
        targetSdk = 35

        versionCode 1
        versionName "1.0.0"

        multiDexEnabled true
    }

    buildTypes {
        release {
            // للتجربة فقط: نوقّع ببصمة الديبَج
            signingConfig signingConfigs.debug
            minifyEnabled false
            shrinkResources false
            // proguardFiles getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro"
        }
        debug {
            // تأكد من إنتاج APK في وضع debug
            debuggable true
            signingConfig signingConfigs.debug
        }
    }

    // يفيد بتجنّب تضارب رخص بعض الحِزم
    packagingOptions {
        resources {
            excludes += [ "META-INF/AL2.0", "META-INF/LGPL2.1" ]
        }
    }

    // Java 17 مع AGP 8+
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
    // Kotlin 17 toolchain
    kotlin {
        jvmToolchain(17)
    }
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib:1.9.24"
    implementation "androidx.multidex:multidex:2.0.1"
}

// ===== Fix Flutter APK lookup (copy outputs to build/app/outputs/flutter-apk) =====
tasks.register("syncFlutterOutputsDebug", Copy) {
    from("$buildDir/outputs/apk/debug")
    include("*.apk")
    into("$rootDir/build/app/outputs/flutter-apk")
}

tasks.register("syncFlutterOutputsRelease", Copy) {
    from("$buildDir/outputs/apk/release")
    include("*.apk")
    into("$rootDir/build/app/outputs/flutter-apk")
}

afterEvaluate {
    tasks.matching { it.name == "assembleDebug" }.configureEach {
        finalizedBy("syncFlutterOutputsDebug")
    }
    tasks.matching { it.name == "assembleRelease" }.configureEach {
        finalizedBy("syncFlutterOutputsRelease")
    }
}
