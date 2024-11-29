class GetExpancesDetailsList {
  int? statusCode;
  String? status;
  String? statusText;
  List<TDS>? tDS;

  GetExpancesDetailsList(
      {this.statusCode, this.status, this.statusText, this.tDS});

  GetExpancesDetailsList.fromJson(Map<String, dynamic> json) {
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
  String? managerId;
  String? submitDate;
  String? reference;
  String? nameOfExpance;
  String? expanseType;
  String? discription;
  String? mode;
  String? amount;
  String? attachment;
  Null att;

  TDS(
      {this.managerId,
      this.submitDate,
      this.reference,
      this.nameOfExpance,
      this.expanseType,
      this.discription,
      this.mode,
      this.amount,
      this.attachment,
      this.att});

  TDS.fromJson(Map<String, dynamic> json) {
    managerId = json['ManagerId'];
    submitDate = json['SubmitDate'];
    reference = json['Reference'];
    nameOfExpance = json['NameOfExpance'];
    expanseType = json['ExpanseType'];
    discription = json['Discription'];
    mode = json['Mode'];
    amount = json['Amount'];
    attachment = json['Attachment'];
    att = json['Att'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ManagerId'] = this.managerId;
    data['SubmitDate'] = this.submitDate;
    data['Reference'] = this.reference;
    data['NameOfExpance'] = this.nameOfExpance;
    data['ExpanseType'] = this.expanseType;
    data['Discription'] = this.discription;
    data['Mode'] = this.mode;
    data['Amount'] = this.amount;
    data['Attachment'] = this.attachment;
    data['Att'] = this.att;
    return data;
  }
}
