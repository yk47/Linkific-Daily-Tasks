plugins {

    id("com.android.application")

    id("kotlin-android")

    id("dev.flutter.flutter-gradle-plugin")

    id("com.google.gms.google-services")
}


android {

    namespace = "com.example.vibez"

    compileSdk = flutter.compileSdkVersion

    ndkVersion = flutter.ndkVersion


    compileOptions {

        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_17

        targetCompatibility = JavaVersion.VERSION_17
    }


    kotlinOptions {

        jvmTarget = JavaVersion.VERSION_17.toString()
    }


    defaultConfig {

        applicationId = "com.example.vibez"

        minSdk = flutter.minSdkVersion

        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode

        versionName = flutter.versionName
    }


    buildTypes {

        release {

            signingConfig =
                signingConfigs.getByName("debug")
        }
    }
}


flutter {

    source = "../.."
}



dependencies {

    // Core library desugaring for Java 8+ APIs
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // Firebase BOM

    implementation(
        platform(
            "com.google.firebase:firebase-bom:34.14.1"
        )
    )


    // Firebase Analytics

    implementation(
        "com.google.firebase:firebase-analytics"
    )


}
