import 'dart:convert';

class DocWriterWebSoketResponseModel {
  String? processId;
  String? type;
  UpdateMessage? updateMessage;
  bool? overallStatus;
  double? timestamp;

  DocWriterWebSoketResponseModel({
    this.processId,
    this.type,
    this.updateMessage,
    this.overallStatus,
    this.timestamp,
  });

  factory DocWriterWebSoketResponseModel.fromRawJson(String str) => DocWriterWebSoketResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocWriterWebSoketResponseModel.fromJson(Map<String, dynamic> json) => DocWriterWebSoketResponseModel(
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
  DocAnalysis? textExtraction;
  DocAnalysis? individualSummary;
  DocAnalysis? finalSummary;
  DocAnalysis? docAnalysis;
  DocAnalysis? knowledgeSave;

  UpdateMessage({
    this.textExtraction,
    this.individualSummary,
    this.finalSummary,
    this.docAnalysis,
    this.knowledgeSave,
  });

  factory UpdateMessage.fromRawJson(String str) => UpdateMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateMessage.fromJson(Map<String, dynamic> json) => UpdateMessage(
        textExtraction: json["textExtraction"] == null ? null : DocAnalysis.fromJson(json["textExtraction"]),
        individualSummary: json["individualSummary"] == null ? null : DocAnalysis.fromJson(json["individualSummary"]),
        finalSummary: json["finalSummary"] == null ? null : DocAnalysis.fromJson(json["finalSummary"]),
        docAnalysis: json["docAnalysis"] == null ? null : DocAnalysis.fromJson(json["docAnalysis"]),
        knowledgeSave: json["knowledgeSave"] == null ? null : DocAnalysis.fromJson(json["knowledgeSave"]),
      );

  Map<String, dynamic> toJson() => {
        "textExtraction": textExtraction?.toJson(),
        "individualSummary": individualSummary?.toJson(),
        "finalSummary": finalSummary?.toJson(),
        "docAnalysis": docAnalysis?.toJson(),
        "knowledgeSave": knowledgeSave?.toJson(),
      };
}

class DocAnalysis {
  String? label;
  String? description;
  bool? status;

  DocAnalysis({
    this.label,
    this.description,
    this.status,
  });

  factory DocAnalysis.fromRawJson(String str) => DocAnalysis.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocAnalysis.fromJson(Map<String, dynamic> json) => DocAnalysis(
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
