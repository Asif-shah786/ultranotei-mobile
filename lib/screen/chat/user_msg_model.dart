// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserAllChatMsgs {
  bool? IsAdmin;
  bool? IsMuted;
  List<UserMsgModel>? messages;
  UserAllChatMsgs({
    this.IsAdmin,
    this.IsMuted,
    this.messages,
  });

  UserAllChatMsgs copyWith({
    bool? IsAdmin,
    bool? IsMuted,
    List<UserMsgModel>? messages,
  }) {
    return UserAllChatMsgs(
      IsAdmin: IsAdmin ?? this.IsAdmin,
      IsMuted: IsMuted ?? this.IsMuted,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'IsAdmin': IsAdmin,
      'IsMuted': IsMuted,
      'messages': messages?.map((x) => x.toMap()).toList(),
    };
  }

  factory UserAllChatMsgs.fromMap(Map<String, dynamic> map) {
    return UserAllChatMsgs(
      IsAdmin: map['IsAdmin'] != null ? map['IsAdmin'] as bool : null,
      IsMuted: map['IsMuted'] != null ? map['IsMuted'] as bool : null,
      messages: map['messages'] != null
          ? List<UserMsgModel>.from(
        (map['messages'] as List<dynamic>).map<UserMsgModel?>(
              (x) => UserMsgModel.fromMap(x as Map<String, dynamic>),
        ),
      )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAllChatMsgs.fromJson(String source) =>
      UserAllChatMsgs.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserAllChatMsgs(IsAdmin: $IsAdmin, IsMuted: $IsMuted, messages: $messages)';

  @override
  bool operator ==(covariant UserAllChatMsgs other) {
    if (identical(this, other)) return true;

    return other.IsAdmin == IsAdmin &&
        other.IsMuted == IsMuted &&
        listEquals(other.messages, messages);
  }

  @override
  int get hashCode => IsAdmin.hashCode ^ IsMuted.hashCode ^ messages.hashCode;
}

class UserMsgModel {
  String? msgId;
  String? userId;
  String? name;
  String? msgType;
  String? message;
  String? picture;
  String? time;
  bool? isEdited;
  UserMsgModel({
    this.msgId,
    this.userId,
    this.name,
    this.msgType,
    this.message,
    this.picture,
    this.time,
    this.isEdited,
  });

  UserMsgModel copyWith({
    String? msgId,
    String? userId,
    String? name,
    String? msgType,
    String? message,
    String? picture,
    String? time,
    bool? isEdited,
  }) {
    return UserMsgModel(
      msgId: msgId ?? this.msgId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      msgType: msgType ?? this.msgType,
      message: message ?? this.message,
      picture: picture ?? this.picture,
      time: time ?? this.time,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msgId': msgId,
      'userId': userId,
      'name': name,
      'msgType': msgType,
      'message': message,
      'picture': picture,
      'time': time,
      'isEdited': isEdited,
    };
  }

  factory UserMsgModel.fromMap(Map<String, dynamic> map) {
    return UserMsgModel(
      msgId: map['msgId'] != null ? map['msgId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      msgType: map['msgType'] != null ? map['msgType'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      picture: map['picture'] != null ? map['picture'] as String : null,
      time: map['time'] != null ? map['time'] as String : null,
      isEdited: map['isEdited'] != null ? map['isEdited'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserMsgModel.fromJson(String source) =>
      UserMsgModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserMsgModel(msgId: $msgId, userId: $userId, name: $name, msgType: $msgType, message: $message, picture: $picture, time: $time, isEdited: $isEdited)';
  }

  @override
  bool operator ==(covariant UserMsgModel other) {
    if (identical(this, other)) return true;

    return other.msgId == msgId &&
        other.userId == userId &&
        other.name == name &&
        other.msgType == msgType &&
        other.message == message &&
        other.picture == picture &&
        other.time == time &&
        other.isEdited == isEdited;
  }

  @override
  int get hashCode {
    return msgId.hashCode ^
    userId.hashCode ^
    name.hashCode ^
    msgType.hashCode ^
    message.hashCode ^
    picture.hashCode ^
    time.hashCode ^
    isEdited.hashCode;
  }
}
