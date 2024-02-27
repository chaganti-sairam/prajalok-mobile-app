import 'dart:convert';

class ChatUserListModel {
  bool? unread;
  int? unreadCount;
  LatestMessage? latestMessage;
  int? conversationId;
  OtherUserDetails? otherUserDetails;

  ChatUserListModel({
    this.unread,
    this.unreadCount,
    this.latestMessage,
    this.conversationId,
    this.otherUserDetails,
  });

  factory ChatUserListModel.fromRawJson(String str) => ChatUserListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatUserListModel.fromJson(Map<String, dynamic> json) => ChatUserListModel(
        unread: json["unread"],
        unreadCount: json["unread_count"],
        latestMessage: json["latest_message"] == null ? null : LatestMessage.fromJson(json["latest_message"]),
        conversationId: json["conversation_id"],
        otherUserDetails: json["other_user_details"] == null ? null : OtherUserDetails.fromJson(json["other_user_details"]),
      );

  Map<String, dynamic> toJson() => {
        "unread": unread,
        "unread_count": unreadCount,
        "latest_message": latestMessage?.toJson(),
        "conversation_id": conversationId,
        "other_user_details": otherUserDetails?.toJson(),
      };
}

class LatestMessage {
  int? id;
  DateTime? createdAt;
  String? contentData;

  LatestMessage({
    this.id,
    this.createdAt,
    this.contentData,
  });

  factory LatestMessage.fromRawJson(String str) => LatestMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LatestMessage.fromJson(Map<String, dynamic> json) => LatestMessage(
        id: json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        contentData: json["content_data"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "content_data": contentData,
      };
}

class OtherUserDetails {
  String? lastName;
  dynamic avatarUrl;
  String? firstName;
  String? profileId;

  OtherUserDetails({
    this.lastName,
    this.avatarUrl,
    this.firstName,
    this.profileId,
  });

  factory OtherUserDetails.fromRawJson(String str) => OtherUserDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OtherUserDetails.fromJson(Map<String, dynamic> json) => OtherUserDetails(
        lastName: json["last_name"],
        avatarUrl: json["avatar_url"],
        firstName: json["first_name"],
        profileId: json["profile_id"],
      );

  Map<String, dynamic> toJson() => {
        "last_name": lastName,
        "avatar_url": avatarUrl,
        "first_name": firstName,
        "profile_id": profileId,
      };
}
