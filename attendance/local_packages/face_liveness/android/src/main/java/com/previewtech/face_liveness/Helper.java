package com.previewtech.face_liveness;

import com.previewtech.face_liveness.Utils;
import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.huawei.hms.mlsdk.livenessdetection.MLLivenessCapture;
import com.huawei.hms.mlsdk.livenessdetection.MLLivenessCaptureResult;
import com.huawei.hms.mlsdk.faceverify.MLFaceVerificationAnalyzer;
import com.huawei.hms.mlsdk.faceverify.MLFaceTemplateResult;
import com.huawei.hms.mlsdk.faceverify.MLFaceVerificationAnalyzerFactory;
import com.huawei.hms.mlsdk.faceverify.MLFaceVerificationAnalyzerSetting;
import com.huawei.hms.mlsdk.faceverify.MLFaceVerificationResult;
import com.huawei.hms.mlsdk.livenessdetection.MLLivenessCapture;
import com.huawei.hms.mlsdk.livenessdetection.MLLivenessCaptureResult;

import com.huawei.hmf.tasks.OnSuccessListener;
import com.huawei.hmf.tasks.Task;
import com.huawei.hms.mlsdk.common.MLFrame;
import com.previewtech.face_liveness.models.InputImageInfo;
import com.previewtech.face_liveness.models.OutputInfo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
// import android.util.SparseArray;



import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class Helper {

    MLFaceVerificationAnalyzer analyzer = null;
    String imageBase64 = "";
    boolean hasTemplateFace = false;
    Result finalResult;
    Utils utils = new Utils();
    Map<String, Object> map = new HashMap<String, Object>();

    int trycount = 0;
    int templateFaceCount = 0;

    public void caputeFaceLiveness(@NonNull MethodCall call, @NonNull Result result, Activity activity) {
        finalResult = result;
        initAnalyzer();
        map = utils.getMapData();
        hasTemplateFace = false;
        imageBase64 = call.argument("image");
        loadTemplatePic(imageBase64);
        startDetect(activity);

    }

    public final MLLivenessCapture.Callback callback = new MLLivenessCapture.Callback() {
        @Override
        public void onSuccess(MLLivenessCaptureResult result) {
            map.put("hasError", false);
            map.put("isLive", result.isLive());
            map.put("liveScore", result.getScore());
            if (result.isLive()) {

                Bitmap resultBitmap = result.getBitmap();
                if (resultBitmap != null) {
                    map.put("hasImage", true);
                    map.put("similarity", -1);
                    map.put("base64Image", utils.convertBitmapToBase64(resultBitmap));

                    if (!TextUtils.isEmpty(imageBase64) && templateFaceCount > 0) {
                        compareFace(resultBitmap);

                    } else {
                        map.put("hasFace", false);
                        sendResult();

                    }

                } else {
                    map.put("hasImage", false);
                    map.put("msg", "Face analyzation failed. Please try again ");
                    sendResult();

                }

            } else {
                map.put("msg", "Failed to Detect face ML with error code  " + result);
                sendResult();
            }

        }

        @Override
        public void onFailure(int errorCode) {
            if (errorCode == 11403) {
                map.put("IsBackPress", true);

            } else {
                map.put("hasError", true);
                map.put("error", "Failed to Detect face ML with error code  " + errorCode);

            }

            finalResult.success(utils.mapToJson(map));

        }

    };

    public void initAnalyzer() {
        templateFaceCount = 0;
        if (analyzer != null) {
            return;
        }

        try {

            MLFaceVerificationAnalyzerSetting.Factory factory = new MLFaceVerificationAnalyzerSetting.Factory()
                    .setMaxFaceDetected(1);
            MLFaceVerificationAnalyzerSetting setting = factory.create();
            analyzer = MLFaceVerificationAnalyzerFactory
                    .getInstance()
                    .getFaceVerificationAnalyzer();

        } catch (Exception e) {

            e.printStackTrace();
            System.out.println("failed to init face analyzer");
        }

    }

    public void stopAnalyzer() {

        if (analyzer != null) {
            analyzer.stop();
            analyzer = null;
        }
    }

    public boolean isAnalyzerInitialized() {
        return analyzer != null;
    }

    public void sendResult() {
        finalResult.success(utils.mapToJson(map));
    }

    public void loadTemplatePic(String imageBase64) {
        map.put("hasFace", false);
        try {
            if (!TextUtils.isEmpty(imageBase64) && analyzer != null) {

                MLFrame templateFrame = createMLFrameFromBase64(imageBase64);
                List<MLFaceTemplateResult> results = analyzer.setTemplateFace(templateFrame);
                templateFaceCount = results.size();
                System.out.println("i/flutter  TempFace Len ::" + templateFaceCount);
                if (templateFaceCount > 0) {
                    map.put("hasFace", true);

                }
            }

        } catch (Exception e) {
            map.put("hasError", true);
            map.put("error", "Exception: " + e);
            e.printStackTrace();

        }
    }

    public MLFrame createMLFrameFromBase64(String base64Image) {
        // Decode Base64 string to a byte array
        byte[] decodedBytes = android.util.Base64.decode(base64Image, android.util.Base64.NO_WRAP);

        // Convert the byte array to a Bitmap
        Bitmap bitmap = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.length);

        // Create an MLFrame from the Bitmap
//        MLFrame mlFrame = new MLFrame.;

//        MLFrame mlFrame =  MLFrame.fromBitmap(bitmap);



        MLFrame mlFrame = new MLFrame.Creator().setBitmap(bitmap).create();

//        System.out.println("i/flutter Class of Object mlFrame is : "
//                + mlFrame.getClass().getName() + "  And   " + bitmap.getClass().getName()  );

        return mlFrame;
    }

    public void compareFace(Bitmap bitmap) {

        try {


            MLFrame cFace = MLFrame.fromBitmap(bitmap);

            Task<List<MLFaceVerificationResult>> task = analyzer.asyncAnalyseFrame(cFace);

            task.addOnSuccessListener(new OnSuccessListener<List<MLFaceVerificationResult>>() {
                @Override
                public void onSuccess(List<MLFaceVerificationResult> mlCompareList) {

                    System.out.println(" has mlCompareList ::" + mlCompareList.size());

                    map.put("hasError", false);
                    if (mlCompareList == null || mlCompareList.size() < 1) {
                        map.put("similarity", 0);
                        map.put("msg",
                                "Face verification failed, Please make sure your profile photo is clear and updated.");
                        // finalResult.success(utils.mapToJson(map));

                    } else {
                        float similarity = mlCompareList.get(0).getSimilarity();
                        map.put("similarity", similarity);
                        System.out.println(" has mlCompareList similarity ::" + similarity);
                        // finalResult.success(utils.mapToJson(map));

                    }

                    sendResult();
                }
            }).addOnFailureListener(e -> {

                map.put("hasError", true);
                map.put("error", "Face verification failed,::" + e);
                // finalResult.success(utils.mapToJson(map));
                sendResult();

            });

        } catch (RuntimeException e) {
            trycount = trycount + 1;
            map.put("hasError", true);
            map.put("trycount", trycount);
            map.put("error", "Exception " + e + ", index :");
            // finalResult.success(utils.mapToJson(map));
            e.printStackTrace();
            if (trycount < 5) {
                loadTemplatePic(imageBase64);
                compareFace(bitmap);
            } else {
                sendResult();
            }

        }

    }


    public void compareFace2(Bitmap bitmap) {

        try {
            MLFrame cFace = MLFrame.fromBitmap(bitmap);
            List<MLFaceVerificationResult> mlCompareList = analyzer.asyncAnalyseFrame(cFace).getResult();
            System.out.println(" has mlCompareList ::" + mlCompareList.size());
            map.put("hasError", false);
            if (mlCompareList.size() < 1) {
                map.put("similarity", 0);
                map.put("msg",
                        "Face verification failed, Please make sure your profile photo is clear and updated.");
                // finalResult.success(utils.mapToJson(map));

            } else {
                float similarity = mlCompareList.get(0).getSimilarity();
                map.put("similarity", similarity);
                System.out.println(" has mlCompareList similarity ::" + similarity);
                // finalResult.success(utils.mapToJson(map));

            }




        } catch (RuntimeException e) {
            map.put("hasError", true);
            map.put("error", "Exception " + e + ", index :");


        }

        sendResult();

    }


    public void matchMultiFace(
            @NonNull MethodCall call, @NonNull Result result, Activity activity  ){


        MatchMultiFace multiFace = new MatchMultiFace();
        String facesDataList = (String) call.argument("faces");


        String  imageBase64 = call.argument("imageBase64");

        multiFace.folderPath = call.argument("folderPath");

        multiFace.parseFromJson(facesDataList);
        multiFace.checkAll = (boolean) call.argument("checkAll");
        multiFace.threshold =(double) call.argument("threshold");

        initAnalyzer();
        loadTemplatePic(imageBase64);
        multiFace.analyzer = analyzer;

        multiFace.match();

        result.success(OutputInfo.toJsonList(multiFace.outResult));






    }








    public void startDetect(Activity activity) {
        MLLivenessCapture capture = MLLivenessCapture.getInstance();

        capture.startDetect(activity, callback);
    }
}

//
