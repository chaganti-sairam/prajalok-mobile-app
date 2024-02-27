import 'dart:convert';

class ContarctAnalysisWebSoketModel {
  String? processId;
  String? type;
  UpdateMessage? updateMessage;
  bool? overallStatus;
  double? timestamp;

  ContarctAnalysisWebSoketModel({
    this.processId,
    this.type,
    this.updateMessage,
    this.overallStatus,
    this.timestamp,
  });

  factory ContarctAnalysisWebSoketModel.fromRawJson(String str) => ContarctAnalysisWebSoketModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContarctAnalysisWebSoketModel.fromJson(Map<String, dynamic> json) => ContarctAnalysisWebSoketModel(
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
  ClauseAndPartyIdentification? textProcessing;
  ClauseAndPartyIdentification? summaryAndLegibility;
  ClauseAndPartyIdentification? clauseAndPartyIdentification;
  ClauseAndPartyIdentification? fairnessAndRiskAssessment;
  ClauseAndPartyIdentification? clauseNamesGeneration;
  ClauseAndPartyIdentification? comprehensiveClauseAnalysis;

  UpdateMessage({
    this.textProcessing,
    this.summaryAndLegibility,
    this.clauseAndPartyIdentification,
    this.fairnessAndRiskAssessment,
    this.clauseNamesGeneration,
    this.comprehensiveClauseAnalysis,
  });

  factory UpdateMessage.fromRawJson(String str) => UpdateMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateMessage.fromJson(Map<String, dynamic> json) => UpdateMessage(
        textProcessing: json["textProcessing"] == null ? null : ClauseAndPartyIdentification.fromJson(json["textProcessing"]),
        summaryAndLegibility: json["summaryAndLegibility"] == null ? null : ClauseAndPartyIdentification.fromJson(json["summaryAndLegibility"]),
        clauseAndPartyIdentification:
            json["clauseAndPartyIdentification"] == null ? null : ClauseAndPartyIdentification.fromJson(json["clauseAndPartyIdentification"]),
        fairnessAndRiskAssessment:
            json["fairnessAndRiskAssessment"] == null ? null : ClauseAndPartyIdentification.fromJson(json["fairnessAndRiskAssessment"]),
        clauseNamesGeneration: json["clauseNamesGeneration"] == null ? null : ClauseAndPartyIdentification.fromJson(json["clauseNamesGeneration"]),
        comprehensiveClauseAnalysis:
            json["comprehensiveClauseAnalysis"] == null ? null : ClauseAndPartyIdentification.fromJson(json["comprehensiveClauseAnalysis"]),
      );

  Map<String, dynamic> toJson() => {
        "textProcessing": textProcessing?.toJson(),
        "summaryAndLegibility": summaryAndLegibility?.toJson(),
        "clauseAndPartyIdentification": clauseAndPartyIdentification?.toJson(),
        "fairnessAndRiskAssessment": fairnessAndRiskAssessment?.toJson(),
        "clauseNamesGeneration": clauseNamesGeneration?.toJson(),
        "comprehensiveClauseAnalysis": comprehensiveClauseAnalysis?.toJson(),
      };
}

class ClauseAndPartyIdentification {
  String? label;
  String? description;
  bool? status;

  ClauseAndPartyIdentification({
    this.label,
    this.description,
    this.status,
  });

  factory ClauseAndPartyIdentification.fromRawJson(String str) => ClauseAndPartyIdentification.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClauseAndPartyIdentification.fromJson(Map<String, dynamic> json) => ClauseAndPartyIdentification(
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
