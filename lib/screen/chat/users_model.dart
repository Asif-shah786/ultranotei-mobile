// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? userId;
  String? name;
  String? picture;
  bool? IsMuted;
  UserModel({
    this.userId,
    this.name,
    this.picture,
    this.IsMuted,
  });

  UserModel copyWith({
    String? userId,
    String? name,
    String? picture,
    bool? IsMuted,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      IsMuted: IsMuted ?? this.IsMuted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'picture': picture,
      'IsMuted': IsMuted,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] != null ? map['userId'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      picture: map['picture'] != null ? map['picture'] as String : null,
      IsMuted: map['IsMuted'] != null ? map['IsMuted'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(userId: $userId, name: $name, picture: $picture, IsMuted: $IsMuted)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.name == name &&
        other.picture == picture &&
        other.IsMuted == IsMuted;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
    name.hashCode ^
    picture.hashCode ^
    IsMuted.hashCode;
  }
}
