package com.previewtech.face_liveness.models;

import androidx.annotation.Nullable;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.List;

public  class InputImageInfo {

  public  String imageName;
  public  String imageBase64;


  public static List<InputImageInfo> getFromGson(@Nullable String  data ){
      if (data == null){
          return  new ArrayList<InputImageInfo>();
      }
      return new Gson().fromJson(data, new TypeToken<List<InputImageInfo>>(){}.getType());
  }


  public   InputImageInfo(String imageName,String imageBase64){
        this.imageName = imageName ;
        this.imageBase64 = imageBase64;
    }




}