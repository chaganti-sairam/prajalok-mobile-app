import 'dart:convert';

class ReferanceWebSoketModel {
  String? processId;
  String? type;
  UpdateMessage? updateMessage;
  bool? overallStatus;
  double? timestamp;

  ReferanceWebSoketModel({
    this.processId,
    this.type,
    this.updateMessage,
    this.overallStatus,
    this.timestamp,
  });

  factory ReferanceWebSoketModel.fromRawJson(String str) => ReferanceWebSoketModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReferanceWebSoketModel.fromJson(Map<String, dynamic> json) => ReferanceWebSoketModel(
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
  CaseDetailRetrieval? caseDetailRetrieval;
  CaseDetailRetrieval? legalDocumentSearch;
  CaseDetailRetrieval? recommendationFinalization;

  UpdateMessage({
    this.caseDetailRetrieval,
    this.legalDocumentSearch,
    this.recommendationFinalization,
  });

  factory UpdateMessage.fromRawJson(String str) => UpdateMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateMessage.fromJson(Map<String, dynamic> json) => UpdateMessage(
        caseDetailRetrieval: json["caseDetailRetrieval"] == null ? null : CaseDetailRetrieval.fromJson(json["caseDetailRetrieval"]),
        legalDocumentSearch: json["legalDocumentSearch"] == null ? null : CaseDetailRetrieval.fromJson(json["legalDocumentSearch"]),
        recommendationFinalization:
            json["recommendationFinalization"] == null ? null : CaseDetailRetrieval.fromJson(json["recommendationFinalization"]),
      );

  Map<String, dynamic> toJson() => {
        "caseDetailRetrieval": caseDetailRetrieval?.toJson(),
        "legalDocumentSearch": legalDocumentSearch?.toJson(),
        "recommendationFinalization": recommendationFinalization?.toJson(),
      };
}

class CaseDetailRetrieval {
  String? label;
  String? description;
  bool? status;

  CaseDetailRetrieval({
    this.label,
    this.description,
    this.status,
  });

  factory CaseDetailRetrieval.fromRawJson(String str) => CaseDetailRetrieval.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CaseDetailRetrieval.fromJson(Map<String, dynamic> json) => CaseDetailRetrieval(
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
