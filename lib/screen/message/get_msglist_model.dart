class GetMsgList {
  List<MsgList>? msgList;

  GetMsgList({this.msgList});

  GetMsgList.fromJson(Map<String, dynamic> json) {
    if (json['msgList'] != null) {
      msgList = <MsgList>[];
      json['msgList'].forEach((v) {
        msgList!.add(new MsgList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.msgList != null) {
      data['msgList'] = this.msgList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MsgList {
  String? message;
  String? fullMessage;
  List<Headers>? headers;
  int? timestamp;
  String? datetime;
  int? totalAmount;
  int? amount;
  String? walletAddress;
  String? type;
  int? blockHeight;
  String? hash;

  MsgList(
      {this.message,
      this.fullMessage,
      this.headers,
      this.timestamp,
      this.datetime,
      this.totalAmount,
      this.amount,
      this.walletAddress,
      this.type,
      this.blockHeight,
      this.hash});

  MsgList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    fullMessage = json['full_message'];
    if (json['headers'] != null) {
      headers = <Headers>[];
      json['headers'].forEach((v) {
        headers!.add(new Headers.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
    datetime = json['datetime'];
    totalAmount = json['totalAmount'];
    amount = json['amount'];
    walletAddress = json['walletAddress'];
    type = json['type'];
    blockHeight = json['blockHeight'];
    hash = json['hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['full_message'] = this.fullMessage;
    if (this.headers != null) {
      data['headers'] = this.headers!.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    data['datetime'] = this.datetime;
    data['totalAmount'] = this.totalAmount;
    data['amount'] = this.amount;
    data['walletAddress'] = this.walletAddress;
    data['type'] = this.type;
    data['blockHeight'] = this.blockHeight;
    data['hash'] = this.hash;
    return data;
  }
}

class Headers {
  String? name;
  String? value;

  Headers({this.name, this.value});

  Headers.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
