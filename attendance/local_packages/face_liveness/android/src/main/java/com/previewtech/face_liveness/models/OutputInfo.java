package com.previewtech.face_liveness.models;

import androidx.annotation.Nullable;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OutputInfo {
    public  String imageName;
    public  float similarity;




    public static String toJsonList(List<OutputInfo>  data ){

        JsonArray outData = new JsonArray();

        for(OutputInfo x : data){

            JsonObject outmap = new JsonObject();

            outmap.addProperty("imageName",x.imageName);
            outmap.addProperty("similarity",x.similarity);
            outData.add(outmap);
        }



        return  outData.toString();



    }

    public OutputInfo(String imageName ,float similarity ){
        this.imageName = imageName;
        this.similarity = similarity;

    }


}
