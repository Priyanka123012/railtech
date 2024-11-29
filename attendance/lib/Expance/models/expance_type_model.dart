// class ExpanseTypeModel {
//   int?
//       statusCode;
//   String?
//       status;
//   String?
//       statusText;
//   List<ExpanceType>?
//       tDS;

//   ExpanseTypeModel(
//       {this.statusCode,
//       this.status,
//       this.statusText,
//       this.tDS});

//   ExpanseTypeModel.fromJson(
//       Map<String, dynamic> json) {
//     statusCode =
//         json['StatusCode'];
//     status =
//         json['status'];
//     statusText =
//         json['statusText'];
//     if (json['TDS'] !=
//         null) {
//       tDS = <ExpanceType>[];
//       json['TDS'].forEach((v) {
//         tDS!.add(new ExpanceType.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic>
//       toJson() {
//     final Map<String, dynamic>
//         data =
//         new Map<String, dynamic>();
//     data['StatusCode'] =
//         this.statusCode;
//     data['status'] =
//         this.status;
//     data['statusText'] =
//         this.statusText;
//     if (this.tDS !=
//         null) {
//       data['TDS'] = this.tDS!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class ExpanceType {
//   String?
//       typeHead;
//   String?
//       mECTypeId;

//   ExpanceType(
//       {this.typeHead,
//       this.mECTypeId});

//   ExpanceType.fromJson(
//       Map<String, dynamic> json) {
//     typeHead =
//         json['TypeHead'];
//     mECTypeId =
//         json['MECTypeId'];
//   }

//   Map<String, dynamic>
//       toJson() {
//     final Map<String, dynamic>
//         data =
//         new Map<String, dynamic>();
//     data['TypeHead'] =
//         this.typeHead;
//     data['MECTypeId'] =
//         this.mECTypeId;
//     return data;
//   }
// }

class ExpanceType {
  final String typeHead;
  final String mECategoryId;

  ExpanceType({required this.typeHead, required this.mECategoryId});
}
