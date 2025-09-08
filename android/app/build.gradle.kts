plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // يجب أن يكون Flutter plugin بعد Android و Kotlin
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
   
}
 dependencies {
  // Import the Firebase BoM
  implementation(platform("com.google.firebase:firebase-bom:34.2.0"))


  // TODO: Add the dependencies for Firebase products you want to use
  // When using the BoM, don't specify versions in Firebase dependencies
  // https://firebase.google.com/docs/android/setup#available-libraries
}
android {
    namespace = "com.example.billwise_499"

    // ثبّت الإصدارات عشان تتطابق البيئات
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.billwise_499"
        minSdk = flutter.minSdkVersion
        targetSdk = 34

        // ثبّت أرقام النسخة (عدّلوها وقت الحاجة وادفعوها للـ Git)
        versionCode = 1
        versionName = "1.0"
    }

    // استخدم Java 17 (AGP 8.x يتطلبه)
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            // مبدئياً نوقّع بمفاتيح debug لسهولة التشغيل
            signingConfig = signingConfigs.getByName("debug")
            // بإمكانكم إضافة proguard لاحقاً
            isMinifyEnabled = false
        }
    }
}

flutter {
    // مسار مشروع Flutter
    source = "../.."
}
