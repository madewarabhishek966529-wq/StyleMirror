plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.stylemirror"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.stylemirror"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
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
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

tasks.register("autoStartBackend") {
    doLast {
        try {
            val socket = java.net.Socket()
            socket.connect(java.net.InetSocketAddress("127.0.0.1", 8000), 400)
            socket.close()
            logger.lifecycle("✓ StyleMirror FastAPI backend is already active on port 8000")
        } catch (e: Exception) {
            logger.lifecycle("⚡ Auto-starting StyleMirror Python backend on port 8000...")
            val rootDir = project.rootDir.parentFile
            val backendDir = java.io.File(rootDir, "backend")
            if (backendDir.exists()) {
                val isWindows = System.getProperty("os.name").lowercase().contains("windows")
                val pb = if (isWindows) {
                    ProcessBuilder("cmd.exe", "/c", "start", "/b", "python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000")
                } else {
                    ProcessBuilder("nohup", "python3", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "&")
                }
                pb.directory(backendDir)
                pb.environment()["PYTHONPATH"] = backendDir.absolutePath
                try {
                    pb.start()
                    logger.lifecycle("✓ StyleMirror backend process started automatically")
                } catch (pe: Exception) {
                    logger.warn("Could not auto-start python backend: ${pe.message}")
                }
            }
        }
    }
}

tasks.matching { it.name.startsWith("assemble") || it.name == "preBuild" }.configureEach {
    dependsOn("autoStartBackend")
}

