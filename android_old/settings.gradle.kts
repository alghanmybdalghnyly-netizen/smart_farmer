// android/settings.gradle.kts

pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        maven(url = "https://storage.googleapis.com/download.flutter.io")
    }

    // تعريف flutterSdkPath من local.properties أو متغير البيئة FLUTTER_SDK
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        val localProps = file("local.properties")
        if (localProps.exists()) {
            localProps.inputStream().use { properties.load(it) }
        }
        val fromProps = properties.getProperty("flutter.sdk")
        val fromEnv = System.getenv("FLUTTER_SDK")
        (fromProps ?: fromEnv) ?: error(
            "Flutter SDK not found. Define flutter.sdk in local.properties or set FLUTTER_SDK env var."
        )
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.4.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false
}

include(":app")
