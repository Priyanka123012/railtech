class GetTotalpresntabsentModel {
  int? statusCode;
  String? status;
  String? statusText;
  List<EP>? eP;

  GetTotalpresntabsentModel(
      {this.statusCode, this.status, this.statusText, this.eP});

  GetTotalpresntabsentModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
    if (json['EP'] != null) {
      eP = <EP>[];
      json['EP'].forEach((v) {
        eP!.add(new EP.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusCode'] = this.statusCode;
    data['status'] = this.status;
    data['statusText'] = this.statusText;
    if (this.eP != null) {
      data['EP'] = this.eP!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EP {
  String? totalCount;
  String? status;

  EP({this.totalCount, this.status});

  EP.fromJson(Map<String, dynamic> json) {
    totalCount = json['TotalCount'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalCount'] = this.totalCount;
    data['Status'] = this.status;
    return data;
  }
}