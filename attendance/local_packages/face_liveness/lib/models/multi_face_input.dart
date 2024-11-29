// ignore_for_file: public_member_api_docs, sort_constructors_first
// class MultiFaceInput {
//   final String imageName;
//   final String imageBase64;
//   MultiFaceInput({
//     required this.imageName,
//     required this.imageBase64,
//   });

// Map<String, dynamic> get toMap => {
//       "imageName": imageName,
//       "imageBase64": imageBase64,
//     };

//   @override
//   String toString() {
//     return "MultiFaceInput(imageName:$imageName,imageBase64:\n$imageBase64)";
//   }

//   factory MultiFaceInput.fromJson(Map<String, dynamic> json) {
//     return MultiFaceInput(
//       imageName: json['FullName'] ?? "unknown",
//       imageBase64: json['FaceImage'] ?? "",
//     );
//   }
// }

class MultiFaceInput {
  final String imageName;
  final String imageBase64;
  final String? empid;
  final String? markUser;

  MultiFaceInput({
    required this.imageName,
    required this.imageBase64,
    this.empid,
    this.markUser,
  });

  Map<String, dynamic> toJson() => {
        "imageName": imageName,
        "imageBase64": imageBase64,
        "empId": empid,
        "MarkedByUserId": markUser,
      };

  Map<String, dynamic> get toMap => {
        "imageName": imageName,
        "imageBase64": imageBase64,
        "empId": empid,
        "MarkedByUserId": markUser,
      };

  @override
  String toString() {
    return "MultiFaceInput(imageName:$imageName,imageBase64:\n$imageBase64,empId:\n$empid,MarkedByUserId:\n$markUser)";
  }

  factory MultiFaceInput.fromJson(Map<String, dynamic> json) {
    return MultiFaceInput(
      imageName: json['imageName'] ?? "unknown",
      imageBase64: json['imageBase64'] ?? '',
      empid: json['empId'],
      markUser: json['MarkedByUserId'],
    );
  }

  @override
  bool operator ==(covariant MultiFaceInput other) {
    if (identical(this, other)) return true;

    return other.imageName == imageName &&
        other.imageBase64 == imageBase64 &&
        other.empid == empid &&
        other.markUser == markUser;
  }

  @override
  int get hashCode {
    return imageName.hashCode ^
        imageBase64.hashCode ^
        empid.hashCode ^
        markUser.hashCode;
  }
}

class MultiFaceInputs {
  final String imageName;
  final String imageBase64;
  final String? empid;

  MultiFaceInputs({
    required this.imageName,
    required this.imageBase64,
    this.empid,
  });

  Map<String, dynamic> toJson() => {
        "imageName": imageName,
        "imageBase64": imageBase64,
        "empId": empid,
      };

  Map<String, dynamic> get toMap => {
        "imageName": imageName,
        "imageBase64": imageBase64,
        "empId": empid,
      };

  @override
  String toString() {
    return "MultiFaceInputs(imageName:$imageName,imageBase64:\n$imageBase64,empId:\n$empid)";
  }

  factory MultiFaceInputs.fromJson(Map<String, dynamic> json) {
    return MultiFaceInputs(
      imageName: json['imageName'] ?? "unknown",
      imageBase64: json['imageBase64'],
      empid: json['empId'],
    );
  }
}
