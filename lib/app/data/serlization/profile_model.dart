import 'dart:convert';

class ProfileModel {
  String? id;
  int? roleId;
  String? dob;
  String? gender;
  List<String>? location;
  String? referredBy;
  String? firstName;
  String? lastName;
  String? language;
  String? updatedAt;
  String? username;
  String? avatarUrl;
  String? website;
  String? emailId;
  DateTime? createdAt;
  String? headline;
  bool? accountDelete;
  DateTime? deletedAt;
  String? textVector;
  bool? vectorUpdate;

  ProfileModel({
    this.id,
    this.roleId,
    this.dob,
    this.gender,
    this.location,
    this.referredBy,
    this.firstName,
    this.lastName,
    this.language,
    this.updatedAt,
    this.username,
    this.avatarUrl,
    this.website,
    this.emailId,
    this.createdAt,
    this.headline,
    this.accountDelete,
    this.deletedAt,
    this.textVector,
    this.vectorUpdate,
  });

  factory ProfileModel.fromRawJson(String str) => ProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"],
        roleId: json["role_id"],
        dob: json["dob"],
        gender: json["gender"],
        location: json["location"] == null ? [] : List<String>.from(json["location"]!.map((x) => x)),
        referredBy: json["referred_by"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        language: json["language"],
        updatedAt: json["updated_at"],
        username: json["username"],
        avatarUrl: json["avatar_url"],
        website: json["website"],
        emailId: json["email_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        headline: json["headline"],
        accountDelete: json["account_delete"],
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
        textVector: json["text_vector"],
        vectorUpdate: json["vector_update"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "dob": dob,
        "gender": gender,
        "location": location == null ? [] : List<dynamic>.from(location!.map((x) => x)),
        "referred_by": referredBy,
        "first_name": firstName,
        "last_name": lastName,
        "language": language,
        "updated_at": updatedAt,
        "username": username,
        "avatar_url": avatarUrl,
        "website": website,
        "email_id": emailId,
        "created_at": createdAt?.toIso8601String(),
        "headline": headline,
        "account_delete": accountDelete,
        "deleted_at": deletedAt?.toIso8601String(),
        "text_vector": textVector,
        "vector_update": vectorUpdate,
      };
}



// import 'dart:convert';

// class ProfileModel {
//   String? id;
//   int? roleId;
//   String? dob;
//   String? gender;
//   List<String>? location;
//   String? referredBy;
//   String? firstName;
//   String? lastName;
//   String? language;
//   String? updatedAt;
//   String? username;
//   String? avatarUrl;
//   String? website;
//   String? emailId;
//   DateTime? createdAt;
//   String? headline;

//   ProfileModel({
//     this.id,
//     this.roleId,
//     this.dob,
//     this.gender,
//     this.location,
//     this.referredBy,
//     this.firstName,
//     this.lastName,
//     this.language,
//     this.updatedAt,
//     this.username,
//     this.avatarUrl,
//     this.website,
//     this.emailId,
//     this.createdAt,
//     this.headline,
//   });

//   factory ProfileModel.fromRawJson(String str) => ProfileModel.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
//         id: json["id"],
//         roleId: json["role_id"],
//         dob: json["dob"],
//         gender: json["gender"],
//         location: json["location"] == null ? [] : List<String>.from(json["location"]!.map((x) => x)),
//         referredBy: json["referred_by"],
//         firstName: json["first_name"],
//         lastName: json["last_name"],
//         language: json["language"],
//         updatedAt: json["updated_at"],
//         username: json["username"],
//         avatarUrl: json["avatar_url"],
//         website: json["website"],
//         emailId: json["email_id"],
//         createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//         headline: json["headline"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "role_id": roleId,
//         "dob": dob,
//         "gender": gender,
//         "location": location == null ? [] : List<dynamic>.from(location!.map((x) => x)),
//         "referred_by": referredBy,
//         "first_name": firstName,
//         "last_name": lastName,
//         "language": language,
//         "updated_at": updatedAt,
//         "username": username,
//         "avatar_url": avatarUrl,
//         "website": website,
//         "email_id": emailId,
//         "created_at": createdAt?.toIso8601String(),
//         "headline": headline,
//       };
// }
