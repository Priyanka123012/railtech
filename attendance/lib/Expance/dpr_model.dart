class ExpanceCategoryModel {
  int? statusCode;
  String? status;
  String? statusText;
  List<ExpanceCategory>? tDS;

  ExpanceCategoryModel(
      {this.statusCode, this.status, this.statusText, this.tDS});

  ExpanceCategoryModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
    if (json['TDS'] != null) {
      tDS = <ExpanceCategory>[];
      json['TDS'].forEach((v) {
        tDS!.add(new ExpanceCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusCode'] = this.statusCode;
    data['status'] = this.status;
    data['statusText'] = this.statusText;
    if (this.tDS != null) {
      data['TDS'] = this.tDS!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExpanceCategory {
  String? catHead;
  String? mECategoryId;

  ExpanceCategory({this.catHead, this.mECategoryId});

  ExpanceCategory.fromJson(Map<String, dynamic> json) {
    catHead = json['CatHead'];
    mECategoryId = json['MECategoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CatHead'] = this.catHead;
    data['MECategoryId'] = this.mECategoryId;
    return data;
  }
}
