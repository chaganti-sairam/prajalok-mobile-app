import 'dart:convert';

class DocChatWebsoketModel {
  String? processId;
  String? type;
  UpdateMessage? updateMessage;
  bool? overallStatus;
  double? timestamp;

  DocChatWebsoketModel({
    this.processId,
    this.type,
    this.updateMessage,
    this.overallStatus,
    this.timestamp,
  });

  factory DocChatWebsoketModel.fromRawJson(String str) => DocChatWebsoketModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocChatWebsoketModel.fromJson(Map<String, dynamic> json) => DocChatWebsoketModel(
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

  void dispose() {}
}

class UpdateMessage {
  FinalSummary? textExtraction;
  FinalSummary? individualSummary;
  FinalSummary? finalSummary;
  FinalSummary? knowledgeSave;

  UpdateMessage({
    this.textExtraction,
    this.individualSummary,
    this.finalSummary,
    this.knowledgeSave,
  });

  factory UpdateMessage.fromRawJson(String str) => UpdateMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateMessage.fromJson(Map<String, dynamic> json) => UpdateMessage(
        textExtraction: json["textExtraction"] == null ? null : FinalSummary.fromJson(json["textExtraction"]),
        individualSummary: json["individualSummary"] == null ? null : FinalSummary.fromJson(json["individualSummary"]),
        finalSummary: json["finalSummary"] == null ? null : FinalSummary.fromJson(json["finalSummary"]),
        knowledgeSave: json["knowledgeSave"] == null ? null : FinalSummary.fromJson(json["knowledgeSave"]),
      );

  Map<String, dynamic> toJson() => {
        "textExtraction": textExtraction?.toJson(),
        "individualSummary": individualSummary?.toJson(),
        "finalSummary": finalSummary?.toJson(),
        "knowledgeSave": knowledgeSave?.toJson(),
      };
}

class FinalSummary {
  String? label;
  String? description;
  bool? status;

  FinalSummary({
    this.label,
    this.description,
    this.status,
  });

  factory FinalSummary.fromRawJson(String str) => FinalSummary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FinalSummary.fromJson(Map<String, dynamic> json) => FinalSummary(
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
