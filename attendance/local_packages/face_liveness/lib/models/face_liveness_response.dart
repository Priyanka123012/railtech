class FaceLivenessResponse {
  FaceLivenessResponse({
    this.msg = '',
    this.isBackPress = false,
    this.isLive = false,
    this.hasFace = false,
    this.liveScore = 0,
    this.similarity = 0,
    this.hasImage = false,
    this.hasError = false,
    this.error = '',
    this.imageBase64,
  });

  String msg;
  bool isBackPress;
  bool isLive;
  bool hasFace;
  num liveScore;
  num similarity;
  bool hasImage;
  bool hasError;
  String error;
  String? imageBase64;

//fetch
  static FaceLivenessResponse fetch(dynamic data) {
    if (data == null) return FaceLivenessResponse();
    try {
      return FaceLivenessResponse.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      return FaceLivenessResponse();
    }
  }

  String get strVAl => [
        "msg : $msg",
        "isBackPress : $isBackPress",
        "isLive : $isLive",
        "hasFace : $hasFace",
        "liveScore : $liveScore",
        "similarity : $similarity",
        "hasImage : $hasImage",
        "hasError : $hasError",
        "error : $error"
      ].join(", ");

//fromJson
  // factory FaceApiResponse.fromdynamic(dynamic json) {
  //   return FaceApiResponse(
  //     msg: json["msg"],
  //     isBackPress: json['IsBackPress'] == true,
  //     isLive: json['isLive'] == true,
  //     hasFace: json['hasFace'],
  //     liveScore: json['liveScore'],
  //     similarity: json['similarity'],
  //     hasImage: json['hasImage'],
  //     hasError: json['hasError'] == true,
  //     error: json['error'],
  //     imageBase64: json["base64Image"],
  //   );
  // }
//fromJson
  factory FaceLivenessResponse.fromJson(Map<String, dynamic> json) =>
      FaceLivenessResponse(
        msg: json["msg"],
        isBackPress: json['IsBackPress'] == true,
        isLive: json['isLive'] == true,
        hasFace: json['hasFace'],
        liveScore: json['liveScore'],
        similarity: json['similarity'],
        hasImage: json['hasImage'],
        hasError: json['hasError'] == true,
        error: json['error'],
        imageBase64: json["base64Image"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "isLive": isLive,
        "similarity": similarity,
        "hasError": hasError,
        "imageBase64": imageBase64,
      };
}
