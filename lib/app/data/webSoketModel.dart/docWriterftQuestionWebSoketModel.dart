import 'dart:convert';

class DocWriterftQuestionWebSoketModel {
  String? processId;
  String? type;
  UpdateMessage? updateMessage;
  bool? overallStatus;
  double? timestamp;

  DocWriterftQuestionWebSoketModel({
    this.processId,
    this.type,
    this.updateMessage,
    this.overallStatus,
    this.timestamp,
  });

  factory DocWriterftQuestionWebSoketModel.fromRawJson(String str) => DocWriterftQuestionWebSoketModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocWriterftQuestionWebSoketModel.fromJson(Map<String, dynamic> json) => DocWriterftQuestionWebSoketModel(
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
  CaseDetailRetrieval? referenceDocumentCheck;
  CaseDetailRetrieval? sectionIdentificationForAnalysis;
  CaseDetailRetrieval? questionGeneration;

  UpdateMessage({
    this.caseDetailRetrieval,
    this.referenceDocumentCheck,
    this.sectionIdentificationForAnalysis,
    this.questionGeneration,
  });

  factory UpdateMessage.fromRawJson(String str) => UpdateMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateMessage.fromJson(Map<String, dynamic> json) => UpdateMessage(
        caseDetailRetrieval: json["caseDetailRetrieval"] == null ? null : CaseDetailRetrieval.fromJson(json["caseDetailRetrieval"]),
        referenceDocumentCheck: json["referenceDocumentCheck"] == null ? null : CaseDetailRetrieval.fromJson(json["referenceDocumentCheck"]),
        sectionIdentificationForAnalysis:
            json["sectionIdentificationForAnalysis"] == null ? null : CaseDetailRetrieval.fromJson(json["sectionIdentificationForAnalysis"]),
        questionGeneration: json["questionGeneration"] == null ? null : CaseDetailRetrieval.fromJson(json["questionGeneration"]),
      );

  Map<String, dynamic> toJson() => {
        "caseDetailRetrieval": caseDetailRetrieval?.toJson(),
        "referenceDocumentCheck": referenceDocumentCheck?.toJson(),
        "sectionIdentificationForAnalysis": sectionIdentificationForAnalysis?.toJson(),
        "questionGeneration": questionGeneration?.toJson(),
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
