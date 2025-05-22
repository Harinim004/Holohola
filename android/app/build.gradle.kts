plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")



}

android {
    //compileSdkVersion 34
    namespace = "com.example.apptry1"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.apptry1"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"



    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so flutter run --release works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    packagingOptions {
        pickFirst("lib/arm64-v8a/libaosl.so")
        pickFirst("lib/armeabi-v7a/libaosl.so")
        pickFirst("lib/x86/libaosl.so")
        pickFirst("lib/x86_64/libaosl.so")
    }

}

flutter {
    source = "../.."
}
