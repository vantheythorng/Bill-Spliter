import com.android.build.gradle.internal.api.BaseVariantOutputImpl

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Name of the app used as the prefix for built APK files.
val appName = "bill_splitter"

android {
    namespace = "com.beniten.bill_splitter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.beniten.bill_splitter"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Required for the per-flavor `app_name` resValue below.
    buildFeatures {
        resValues = true
    }

    // Build flavors: dev / staging / prod. Each gets its own application ID
    // suffix so all three can be installed side by side, and a distinct app
    // name exposed via the `app_name` string resource (see AndroidManifest).
    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Bill Splitter Dev")
        }
        create("staging") {
            dimension = "env"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue("string", "app_name", "Bill Splitter Staging")
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "Bill Splitter")
        }
    }

    // Rename built APKs to: appname_flavor_versioncode_versionname.apk
    // When no product flavor is defined, the build type name is used in its place.
    applicationVariants.all {
        val variant = this
        val flavor = variant.flavorName.ifEmpty { variant.buildType.name }
        outputs.all {
            (this as BaseVariantOutputImpl).outputFileName =
                "${appName}_${flavor}_${variant.versionCode}_${variant.versionName}.apk"
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
