#################################
# STRIPE SDK RULES
#################################

-keep class com.stripe.** { *; }
-dontwarn com.stripe.**

-keep class com.stripe.android.model.** { *; }
-keep class com.stripe.android.paymentsheet.** { *; }
-keep class com.stripe.android.googlepay.** { *; }
-keep class com.stripe.android.pushProvisioning.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**

-keep class com.google.crypto.tink.** { *; }
-keep class com.google.crypto.tink.subtle.** { *; }
-keep class com.nimbusds.** { *; }

-keep class javax.annotation.** { *; }
-dontwarn javax.annotation.**

-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

-keep class kotlin.Metadata { *; }
-keepclassmembers class ** {
    @kotlin.Metadata *;
}

-keepclassmembers class kotlin.coroutines.jvm.internal.BaseContinuationImpl {
    private final int label;
}

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-dontwarn androidx.**
-keep class androidx.lifecycle.** { *; }
-keep class androidx.activity.** { *; }

-dontwarn com.google.firebase.**
-keep class com.google.firebase.** { *; }

#################################
# RAZORPAY SDK RULES
#################################

-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Required for Gson used by Razorpay
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Keep methods accessed by reflection
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

-keepclassmembers class * {
    public <init>(org.json.JSONObject);
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context);
}

# Keep native payment-related classes and members
-keepclasseswithmembers class * {
    public <init>(android.app.Activity);
}

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

#################################
# GENERAL KEEP RULES (safe for Stripe + Razorpay)
#################################

# Flutter plugins often use reflection
-keep class io.flutter.embedding.engine.FlutterEngine { *; }
-keep class io.flutter.plugin.** { *; }
-dontwarn io.flutter.plugin.**

# Avoid removing entries used by Dart
-keep class io.flutter.app.** { *; }
-keep class io.flutter.view.** { *; }

# JSON parsing for models
-keepclassmembers class * {
    ** set*(***);
    *** get*();
}

# Prevent removing logs during minify (optional, helpful for debugging release crashes)
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}
