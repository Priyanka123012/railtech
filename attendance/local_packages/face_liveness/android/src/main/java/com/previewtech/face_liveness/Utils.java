package com.previewtech.face_liveness;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.TextUtils;
import android.util.Base64;
import java.io.ByteArrayOutputStream;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.io.File;
import java.io.FilenameFilter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

class Utils {

    public Map getMapData() {
        Map map = new HashMap();
        map.put("isLive", false);
        map.put("liveScore", 0);
        map.put("hasImage", false);
        map.put("hasFace", false);
        map.put("similarity", 0);
        map.put("msg", "");
        map.put("hasError", false);
        map.put("error", "");
        return map;
    }

    public List<File> loadImages(String directoryPath) {
        List<File> imageFiles = new ArrayList<>();

        // Create a File object representing the directory
        File directory = new File(directoryPath);

        // Check if the directory exists
        if (directory.exists() && directory.isDirectory()) {
            // Define a FilenameFilter to filter files based on their extensions (e.g., jpg,
            // png)
            FilenameFilter imageFilter = (dir, name) -> {
                String lowercaseName = name.toLowerCase();
                return lowercaseName.endsWith(".jpg") || lowercaseName.endsWith(".jpeg") ||
                        lowercaseName.endsWith(".png") || lowercaseName.endsWith(".gif") ||
                        lowercaseName.endsWith(".bmp");
            };

            // List all files in the directory that match the filter
            File[] imageFilesArray = directory.listFiles(imageFilter);

            if (imageFilesArray != null) {
                // Convert the array to a List for easier processing
                imageFiles = Arrays.asList(imageFilesArray);
            }
        }

        return imageFiles;
    }

    public Bitmap base64ToBitmap(String base64String) {

        Bitmap data = null;
        System.out.println("decodedBytes base64String : " + base64String);

        try {

            if (TextUtils.isEmpty(base64String)) {

               return  null;
            }

            byte[] decodedBytes = Base64.decode(base64String, Base64.DEFAULT);
            data =  BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.length);


            // byte[] decodedBytes = new byte[0];
            // if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.FROYO)
            // {
            // decodedBytes = Base64.decode(base64String, Base64.DEFAULT);
            // }
            // BitmapFactory.Options options = new BitmapFactory.Options();
            // options.inPreferredConfig = Bitmap.Config.ARGB_8888;
            // return compressBitmap(BitmapFactory.decodeByteArray(decodedBytes, 0,
            // decodedBytes.length, options));

        } catch (Exception e) {
            System.out.println("base64ToBitmap : " + e);
            return null;
        }

        return data;
    }

    public Bitmap compressBitmap(Bitmap bitmap) {
        try {

            ByteArrayOutputStream stream = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.PNG, 8, stream);
            bitmap = Bitmap.createScaledBitmap(bitmap, 100, 150, true);
        } catch (Exception e) {
            return null;
        }

        return bitmap;
    }

    public static String convertBitmapToBase64(Bitmap bitmap) {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 60, byteArrayOutputStream);
        byte[] byteArray = byteArrayOutputStream.toByteArray();
        // return Base64.encodeToString(byteArray, Base64.DEFAULT);
        return Base64.encodeToString(byteArray, Base64.DEFAULT).replace("\n", "").replace(" ", "");
    }

    // public Map<String, Object> mapToJson(Map<String, Object> map) {
    //
    // return map;
    // }
    public String mapToJson(Map<String, Object> map) {
        StringBuilder json = new StringBuilder("{");
        for (Map.Entry<String, Object> entry : map.entrySet()) {
            json.append("\"").append(entry.getKey()).append("\": ").append(toJson(entry.getValue())).append(", ");
        }
        json.deleteCharAt(json.length() - 2); // Remove the trailing comma and space
        json.append("}");
        return json.toString();
    }

    public String toJson(Object value) {
        if (value instanceof String) {
            return "\"" + value + "\"";
        } else if (value instanceof Number) {
            return value.toString();
        } else if (value instanceof Boolean) {
            return value.toString();
        } else if (value instanceof Map) {
            return mapToJson((Map<String, Object>) value);
        } else if (value instanceof List) {
            StringBuilder jsonArray = new StringBuilder("[");
            for (Object item : (List<?>) value) {
                jsonArray.append(toJson(item)).append(", ");
            }
            jsonArray.deleteCharAt(jsonArray.length() - 2);
            jsonArray.append("]");
            return jsonArray.toString();
        } else {
            return "null";
        }
    }

}
