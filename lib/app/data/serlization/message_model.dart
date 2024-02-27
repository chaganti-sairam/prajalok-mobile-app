import 'dart:convert';

class MessageModel {
  int? id;
  int? sessionId;
  String? messageType;
  String? content;
  dynamic structuredContent;
  String? docUrl;
  String? chatUserType;
  DateTime? sentAt;
  bool? isMine;

  MessageModel({
    this.id,
    this.sessionId,
    this.messageType,
    this.content,
    this.structuredContent,
    this.docUrl,
    this.chatUserType,
    this.sentAt,
    this.isMine,
  });

  factory MessageModel.fromRawJson(String str) => MessageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["id"],
        sessionId: json["session_id"],
        messageType: json["message_type"],
        content: json["content"],
        structuredContent: json["structured_content"],
        docUrl: json["doc_url"],
        chatUserType: json["chat_user_type"],
        sentAt: json["sent_at"] == null ? null : DateTime.parse(json["sent_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "session_id": sessionId,
        "message_type": messageType,
        "content": content,
        "structured_content": structuredContent,
        "doc_url": docUrl,
        "chat_user_type": chatUserType,
        "sent_at": sentAt?.toIso8601String(),
      };
}
