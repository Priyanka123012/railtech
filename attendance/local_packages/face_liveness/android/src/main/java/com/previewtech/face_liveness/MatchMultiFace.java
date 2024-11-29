package com.previewtech.face_liveness;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Environment;

import com.previewtech.face_liveness.models.*;


import com.huawei.hms.mlsdk.common.MLFrame;
import com.huawei.hms.mlsdk.faceverify.MLFaceVerificationAnalyzer;
import com.huawei.hms.mlsdk.faceverify.MLFaceVerificationResult;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class MatchMultiFace {

    MLFaceVerificationAnalyzer analyzer = null;
    List<OutputInfo> outResult = new ArrayList<OutputInfo>();

    boolean checkAll = false;
    double threshold = 0;
    String   folderPath = null;
    List<InputImageInfo>   faces = new ArrayList<InputImageInfo>();



    public  void parseFromJson(String data){
        faces = new ArrayList<>();
        try{
            JSONArray json = new JSONArray(data);

            for(int i = 0;i<json.length();i++){
                JSONObject obj = json.getJSONObject(i);
                InputImageInfo img = new InputImageInfo(obj.getString("imageName"),obj.getString("imageBase64"));
                faces.add(img);

            }


        }catch (Exception e){
            System.out.println("parseFromJson : " + e);
        }


    }

    public void  match(){
        if(folderPath != null && !folderPath.isEmpty()){
            matchFromDir(folderPath);
        }else{
            matchInFaces(faces);
        }
    }



    private  boolean  canBreak(String fileName, float result){


        if(checkAll){
            outResult.add( new OutputInfo(fileName,result));
        }else if(result > 0 &&  result > threshold){
            outResult.add( new OutputInfo(fileName,result));
            return  true;
        }

        return  false;

    }


    private void   matchFromDir(String dirPath){

        List<OutputInfo> outResult = new ArrayList<OutputInfo>();


        File folder = new File(dirPath);
        if(folder.isDirectory()){
            File[] files = folder.listFiles();
            if(files == null){
                return ;
            }
            for (File file : files){
                String fileName = file.getName();
                if (file.isFile() && isImageFile(fileName)){
                    Bitmap bitmap = decodeFileToBitmap(file.getAbsolutePath());
                    if(bitmap != null){
                        float result =  handelSingleMatch(MLFrame.fromBitmap(bitmap));
                        if(canBreak(fileName,result)){
                            break;
                        }

                    }



                }
            }
        }



    }



    static  private  boolean isImageFile(String name){
        String[] x = name.split("\\.");
        System.out.println("xxxxx :: "+ x.length);
        return  x[x.length-1].toLowerCase().matches("jpeg|png|jpg");

    }


    private static Bitmap decodeFileToBitmap(String filePath)  {
        try{
            BitmapFactory.Options options = new BitmapFactory.Options();
            return BitmapFactory.decodeFile(filePath, options);
        }catch (Exception e){
            return  null;
        }
    }




    private void matchInFaces(List<InputImageInfo> faces ){
        Utils utils = new Utils();
        for(InputImageInfo face :  faces){

            Bitmap faceBitmap = utils.base64ToBitmap(face.imageBase64);

            float result = handelSingleMatch(MLFrame.fromBitmap(faceBitmap));
            if(canBreak(face.imageName,result)){
                break;
            }

        }


    }






    private  float handelSingleMatch(MLFrame cFace ){
        float similarity = -1;
        System.out.println("handelSingleMatch getByteBuffer : " + cFace.getByteBuffer());
        try {

            MLFaceVerificationResult mlCompare =   analyzer.analyseFrame(cFace).get(0);
            if(mlCompare != null ){
                similarity = mlCompare.getSimilarity();
            }


        }catch (RuntimeException e){
            similarity = -1;
            System.out.println("handelSingleMatch : " + e);
        }

        return similarity;

    }



}




