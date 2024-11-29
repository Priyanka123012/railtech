class FaceRegistration {
  final String empId;
  final String fullName;
  final String faceImageUrl;
  final String status;
  final String? faceImage64; // Nullable if not available

  FaceRegistration({
    required this.empId,
    required this.fullName,
    required this.faceImageUrl,
    required this.status,
    this.faceImage64,
  });

  factory FaceRegistration.fromJson(Map<String, dynamic> json) {
    return FaceRegistration(
      empId: json['EMP_BasicDetail_Id'],
      fullName: json['FullName'],
      faceImageUrl: json['FaceImage'],
      status: json['Status'],
      faceImage64: json['FaceImage64'],
    );
  }
}
