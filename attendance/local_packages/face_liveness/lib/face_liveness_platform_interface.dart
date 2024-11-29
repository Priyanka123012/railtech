import 'package:face_liveness/models/face_liveness_response.dart';
import 'package:face_liveness/models/multi_face_input.dart';
import 'package:face_liveness/models/multi_face_response.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'face_liveness_method_channel.dart';

abstract class FaceLivenessPlatform extends PlatformInterface {
  /// Constructs a FaceLivenessPlatform.
  FaceLivenessPlatform() : super(token: _token);

  static final Object _token = Object();

  static FaceLivenessPlatform _instance = MethodChannelFaceLiveness();

  /// The default instance of [FaceLivenessPlatform] to use.
  ///
  /// Defaults to [MethodChannelFaceLiveness].
  static FaceLivenessPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FaceLivenessPlatform] when
  /// they register themselves.
  static set instance(FaceLivenessPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> initAnalyzer() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<FaceLivenessResponse?> caputeFaceLiveness(String? base64Img) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<List<MuliFaceResponse>> matchMultiFaces(
    String base64Img, {
    required double threshold,
    String? folderPath,
    bool checkAll = false,
    List<MultiFaceInput>? multifaceInput,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<List<MuliFaceResponses>> matchTeamMultiFaces(
    String base64Img, {
    required double threshold,
    String? folderPath,
    bool checkAll = false,
    List<MultiFaceInputs>? multiTeamfaceInput,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
