import 'dart:convert';

class WebSoketChatRedyModel {
  String? processId;
  String? type;
  UpdateMessage? updateMessage;
  bool? overallStatus;
  double? timestamp;

  WebSoketChatRedyModel({
    this.processId,
    this.type,
    this.updateMessage,
    this.overallStatus,
    this.timestamp,
  });

  factory WebSoketChatRedyModel.fromRawJson(String str) => WebSoketChatRedyModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WebSoketChatRedyModel.fromJson(Map<String, dynamic> json) => WebSoketChatRedyModel(
        processId: json["processId"],
        type: json["type"],
        updateMessage: json["update_message"] == null ? null : UpdateMessage.fromJson(json["update_message"]),
        overallStatus: json["overall_status"],
        timestamp: json["timestamp"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "processId": processId,
        "type": type,
        "update_message": updateMessage?.toJson(),
        "overall_status": overallStatus,
        "timestamp": timestamp,
      };
}

class UpdateMessage {
  ChatActivation? referenceDocumentCheck;
  ChatActivation? documentProcessing;
  ChatActivation? welcomeMessageCrafting;
  ChatActivation? chatActivation;

  UpdateMessage({
    this.referenceDocumentCheck,
    this.documentProcessing,
    this.welcomeMessageCrafting,
    this.chatActivation,
  });

  factory UpdateMessage.fromRawJson(String str) => UpdateMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateMessage.fromJson(Map<String, dynamic> json) => UpdateMessage(
        referenceDocumentCheck: json["referenceDocumentCheck"] == null ? null : ChatActivation.fromJson(json["referenceDocumentCheck"]),
        documentProcessing: json["documentProcessing"] == null ? null : ChatActivation.fromJson(json["documentProcessing"]),
        welcomeMessageCrafting: json["welcomeMessageCrafting"] == null ? null : ChatActivation.fromJson(json["welcomeMessageCrafting"]),
        chatActivation: json["chatActivation"] == null ? null : ChatActivation.fromJson(json["chatActivation"]),
      );

  Map<String, dynamic> toJson() => {
        "referenceDocumentCheck": referenceDocumentCheck?.toJson(),
        "documentProcessing": documentProcessing?.toJson(),
        "welcomeMessageCrafting": welcomeMessageCrafting?.toJson(),
        "chatActivation": chatActivation?.toJson(),
      };
}

class ChatActivation {
  String? label;
  String? description;
  bool? status;

  ChatActivation({
    this.label,
    this.description,
    this.status,
  });

  factory ChatActivation.fromRawJson(String str) => ChatActivation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatActivation.fromJson(Map<String, dynamic> json) => ChatActivation(
        label: json["label"],
        description: json["description"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "description": description,
        "status": status,
      };
}
