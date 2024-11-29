package com.previewtech.face_liveness;

import com.previewtech.face_liveness.Helper;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.android.FlutterActivity;
// Activity
import android.app.Activity;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;



import android.content.Context;

/** FaceLivenessPlugin */
//extends FlutterActivity
public class FaceLivenessPlugin  implements FlutterPlugin, MethodCallHandler,ActivityAware  {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
   private Context context;
   private Activity activity;
  Helper helper = new Helper();

  public Context getContext() {
        return context;
    }

  public Activity getActivity() {
        return activity;
    }

   //  ActivityAware Start
  @Override
    public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
        this.activity = activityPluginBinding.getActivity();
        // Access the activity instance here
    }  

  @Override
    public void onDetachedFromActivityForConfigChanges() {
        // Handle activity detached for configuration changes
    }

  @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
        this.activity = activityPluginBinding.getActivity();
        // Handle activity reattached for configuration changes
    }

    @Override
    public void onDetachedFromActivity() {
        // Handle activity detached
    }  

  //  ActivityAware End

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    // PluginRegistry.Registrar registrar = flutterPluginBinding.getFlutterEngine().getPlugins().get(PluginRegistry.Registrar.class);
    // activity = registrar.activity();
    // flutterPluginBinding.getActivity();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "face_liveness");
    channel.setMethodCallHandler(this);

  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }else if(call.method.equals("caputeFaceLiveness")){
        helper.caputeFaceLiveness(call,result,getActivity());
    } else if(call.method.equals("initAnalyzer")){
           helper.initAnalyzer();
           result.success("initAnalyzer " );
     }
    else if(call.method.equals("stopAnalyzer")){
       helper.stopAnalyzer();
        result.success("initAnalyzer " );
     }
    else if(call.method.equals("matchmultifaces")){
        helper.matchMultiFace(call,result,getActivity());
    }
    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    helper.stopAnalyzer();
  }
}
