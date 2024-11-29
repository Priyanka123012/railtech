class ManagerCardAssignModel {
  int? statusCode;
  String? status;
  String? statusText;
  List<TDS>? tDS;

  ManagerCardAssignModel(
      {this.statusCode, this.status, this.statusText, this.tDS});

  ManagerCardAssignModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
    if (json['TDS'] != null) {
      tDS = <TDS>[];
      json['TDS'].forEach((v) {
        tDS!.add(new TDS.fromJson(v));
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

class TDS {
  String? cardId;
  String? cardNumber;

  TDS({this.cardId, this.cardNumber});

  TDS.fromJson(Map<String, dynamic> json) {
    cardId = json['CardId'];
    cardNumber = json['CardNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CardId'] = this.cardId;
    data['CardNumber'] = this.cardNumber;
    return data;
  }
}
