plugins {
    // لا تضع com.android.application هنا
    id("dev.flutter.flutter-plugin-loader")
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false
    id("com.android.application") version "8.5.2" apply false
}

task<Delete>("clean") {
    delete(rootProject.buildDir)
}
