import 'dart:convert';

class MuliFaceResponse {
  final String imageName;
  final double similarity;
  MuliFaceResponse({
    required this.imageName,
    required this.similarity,
  });

  static List<MuliFaceResponse> tryParse(String? data) {
    try {
      if (data == null) return [];
      final x = jsonDecode(data);
      return List<MuliFaceResponse>.from(
        (x as List<dynamic>).map(
          (e) => MuliFaceResponse(
            imageName: e["imageName"],
            similarity: e['similarity'],
          ),
        ),
      );
    } catch (e) {
      return [];
    }
  }

  @override
  String toString() {
    return "MuliFaceResponse(imageName : $imageName,similarity : $similarity)";
  }
}

class MuliFaceResponses {
  final String imageName;
  final double similarity;
  MuliFaceResponses({
    required this.imageName,
    required this.similarity,
  });

  static List<MuliFaceResponses> tryParse(String? data) {
    try {
      if (data == null) return [];
      final x = jsonDecode(data);
      return List<MuliFaceResponses>.from(
        (x as List<dynamic>).map(
          (e) => MuliFaceResponses(
            imageName: e["imageName"],
            similarity: e['similarity'],
          ),
        ),
      );
    } catch (e) {
      return [];
    }
  }

  @override
  String toString() {
    return "MuliFaceResponses(imageName : $imageName,similarity : $similarity)";
  }
}
