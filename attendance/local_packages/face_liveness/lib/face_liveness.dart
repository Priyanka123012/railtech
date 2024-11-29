import 'package:face_liveness/models/face_liveness_response.dart';
import 'package:face_liveness/models/multi_face_input.dart';
import 'package:face_liveness/models/multi_face_response.dart';
import 'face_liveness_platform_interface.dart';

class FaceLiveness {
  Future<String?> getPlatformVersion() {
    return FaceLivenessPlatform.instance.getPlatformVersion();
  }
//CAMERA DESCRIPTION,CAMERA CONTROLLER , STATEFULL WIDGET(28/11/2024)
  Future<String?> initAnalyzer() {
    return FaceLivenessPlatform.instance.initAnalyzer();
  }

  Future<FaceLivenessResponse?> caputeFaceLiveness({
    String? base64Image,
  }) {
    return FaceLivenessPlatform.instance.caputeFaceLiveness(base64Image);
  }

  Future<List<MuliFaceResponse>> matchMultiFaces({
    required String primaryBase64Img,
    double threshold = 0.1,
    String? folderPath,
    bool checkAll = true,
    List<MultiFaceInput>? multifaceInput,
  }) {
    return FaceLivenessPlatform.instance.matchMultiFaces(
      primaryBase64Img,
      threshold: threshold,
      folderPath: folderPath,
      checkAll: checkAll,
      multifaceInput: multifaceInput,
    );
  }

  Future<List<MuliFaceResponses>> matchTeamMultiFaces({
    required String primaryBase64Img,
    double threshold = 0.1,
    String? folderPath,
    bool checkAll = true,
    List<MultiFaceInputs>? multiTeamfaceInput,
  }) {
    return FaceLivenessPlatform.instance.matchTeamMultiFaces(
      primaryBase64Img,
      threshold: threshold,
      folderPath: folderPath,
      checkAll: checkAll,
      multiTeamfaceInput: multiTeamfaceInput,
    );
  }
}
