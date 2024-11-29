import 'dart:convert';
import 'dart:io';

import 'package:face_liveness/models/face_liveness_response.dart';
import 'package:face_liveness/models/multi_face_input.dart';
import 'package:face_liveness/models/multi_face_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'face_liveness_platform_interface.dart';

/// An implementation of [FaceLivenessPlatform] that uses method channels.
class MethodChannelFaceLiveness extends FaceLivenessPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('face_liveness');

  @override
  Future<String?> getPlatformVersion() async {
    final version =await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> initAnalyzer() async {
    final version = await methodChannel.invokeMethod<String>('initAnalyzer');
    return version;
  }

  @override
  Future<FaceLivenessResponse?> caputeFaceLiveness(String? base64Img) async {
    FaceLivenessResponse resp = FaceLivenessResponse();
    if (Platform.isAndroid) {
      try {
        final result = await methodChannel.invokeMethod<dynamic>(
            'caputeFaceLiveness', {'image': base64Img ?? ''});

        if (result != null) {
          final data = json.decode(result);
          resp = FaceLivenessResponse.fetch(data);
        }
      } catch (e) {
        resp.hasError = true;
        if (resp.error.isEmpty) {
          resp.error = e.toString();
        }
      }
    }

    return resp;
  }

  @override
  Future<List<MuliFaceResponse>> matchMultiFaces(
    String base64Img, {
    required double threshold,
    String? folderPath,
    bool checkAll = false,
    List<MultiFaceInput>? multifaceInput,
  }) async {
    try {
      final body = {
        "imageBase64": base64Img,
        "folderPath": folderPath,
        "threshold": threshold,
        "checkAll": checkAll,
        "faces":
            jsonEncode((multifaceInput ?? []).map((e) => e.toMap).toList()),
      };
      final result =
          await methodChannel.invokeMethod<String?>("matchmultifaces", body);
      return MuliFaceResponse.tryParse(result);
    } catch (e) {
      return [];
    }
  }
}
