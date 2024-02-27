import 'dart:convert';

class MessageModels {
  int? id;
  int? conversationId;
  String? senderId;
  String? recipientId;
  String? contentType;
  String? contentData;
  DateTime? createdAt;
  String? updatedAt;
  String? fileName;
  double? fileSize;

  MessageModels({
    this.id,
    this.conversationId,
    this.senderId,
    this.recipientId,
    this.contentType,
    this.contentData,
    this.createdAt,
    this.updatedAt,
    this.fileName,
    this.fileSize,
  });

  factory MessageModels.fromRawJson(String str) => MessageModels.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageModels.fromJson(Map<String, dynamic> json) => MessageModels(
        id: json["id"],
        conversationId: json["conversation_id"],
        senderId: json["sender_id"],
        recipientId: json["recipient_id"],
        contentType: json["content_type"],
        contentData: json["content_data"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        fileName: json["file_name"],
        fileSize: double.tryParse(json["file_size"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "conversation_id": conversationId,
        "sender_id": senderId,
        "recipient_id": recipientId,
        "content_type": contentType,
        "content_data": contentData,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
        "file_name": fileName,
        "file_size": fileSize,
      };
}
