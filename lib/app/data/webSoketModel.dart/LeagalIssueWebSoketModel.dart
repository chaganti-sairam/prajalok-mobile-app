import 'dart:convert';

class LeagalIssueWebSoketModel {
  String? processId;
  String? type;
  UpdateMessage? updateMessage;
  bool? overallStatus;
  double? timestamp;

  LeagalIssueWebSoketModel({
    this.processId,
    this.type,
    this.updateMessage,
    this.overallStatus,
    this.timestamp,
  });

  factory LeagalIssueWebSoketModel.fromRawJson(String str) => LeagalIssueWebSoketModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LeagalIssueWebSoketModel.fromJson(Map<String, dynamic> json) => LeagalIssueWebSoketModel(
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
  FinalizeResult? textProcessing;
  FinalizeResult? findlegalissue;
  FinalizeResult? finalizeResult;

  UpdateMessage({
    this.textProcessing,
    this.findlegalissue,
    this.finalizeResult,
  });

  factory UpdateMessage.fromRawJson(String str) => UpdateMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateMessage.fromJson(Map<String, dynamic> json) => UpdateMessage(
        textProcessing: json["textProcessing"] == null ? null : FinalizeResult.fromJson(json["textProcessing"]),
        findlegalissue: json["findlegalissue"] == null ? null : FinalizeResult.fromJson(json["findlegalissue"]),
        finalizeResult: json["FinalizeResult"] == null ? null : FinalizeResult.fromJson(json["FinalizeResult"]),
      );

  Map<String, dynamic> toJson() => {
        "textProcessing": textProcessing?.toJson(),
        "findlegalissue": findlegalissue?.toJson(),
        "FinalizeResult": finalizeResult?.toJson(),
      };
}

class FinalizeResult {
  String? label;
  String? description;
  bool? status;

  FinalizeResult({
    this.label,
    this.description,
    this.status,
  });

  factory FinalizeResult.fromRawJson(String str) => FinalizeResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FinalizeResult.fromJson(Map<String, dynamic> json) => FinalizeResult(
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
