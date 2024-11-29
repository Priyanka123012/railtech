class CardBalanceModel {
  int? statusCode;
  String? status;
  String? statusText;
  List<CardBalance>? tDS;

  CardBalanceModel({this.statusCode, this.status, this.statusText, this.tDS});

  CardBalanceModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    status = json['status'];
    statusText = json['statusText'];
    if (json['TDS'] != null) {
      tDS = <CardBalance>[];
      json['TDS'].forEach((v) {
        tDS!.add(new CardBalance.fromJson(v));
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

class CardBalance {
  String? cardBalanceAvailable;

  CardBalance({this.cardBalanceAvailable});

  CardBalance.fromJson(Map<String, dynamic> json) {
    cardBalanceAvailable = json['CardBalanceAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CardBalanceAvailable'] = this.cardBalanceAvailable;
    return data;
  }
}
