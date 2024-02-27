import 'dart:convert';

class AnalysisWebSoketModel {
  String? processId;
  String? type;
  UpdateMessage? updateMessage;
  bool? overallStatus;
  double? timestamp;

  AnalysisWebSoketModel({
    this.processId,
    this.type,
    this.updateMessage,
    this.overallStatus,
    this.timestamp,
  });

  factory AnalysisWebSoketModel.fromRawJson(String str) => AnalysisWebSoketModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AnalysisWebSoketModel.fromJson(Map<String, dynamic> json) => AnalysisWebSoketModel(
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
  AnalysisFinalization? textExtraction;
  AnalysisFinalization? analysisInitiation;
  AnalysisFinalization? documentTypeIdentification;
  AnalysisFinalization? keyAnalysis;
  AnalysisFinalization? initialAnalysis;
  AnalysisFinalization? detailedAnalysis;
  AnalysisFinalization? analysisFinalization;

  UpdateMessage({
    this.textExtraction,
    this.analysisInitiation,
    this.documentTypeIdentification,
    this.keyAnalysis,
    this.initialAnalysis,
    this.detailedAnalysis,
    this.analysisFinalization,
  });

  factory UpdateMessage.fromRawJson(String str) => UpdateMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateMessage.fromJson(Map<String, dynamic> json) => UpdateMessage(
        textExtraction: json["textExtraction"] == null ? null : AnalysisFinalization.fromJson(json["textExtraction"]),
        analysisInitiation: json["analysisInitiation"] == null ? null : AnalysisFinalization.fromJson(json["analysisInitiation"]),
        documentTypeIdentification:
            json["documentTypeIdentification"] == null ? null : AnalysisFinalization.fromJson(json["documentTypeIdentification"]),
        keyAnalysis: json["keyAnalysis"] == null ? null : AnalysisFinalization.fromJson(json["keyAnalysis"]),
        initialAnalysis: json["initialAnalysis"] == null ? null : AnalysisFinalization.fromJson(json["initialAnalysis"]),
        detailedAnalysis: json["detailedAnalysis"] == null ? null : AnalysisFinalization.fromJson(json["detailedAnalysis"]),
        analysisFinalization: json["analysisFinalization"] == null ? null : AnalysisFinalization.fromJson(json["analysisFinalization"]),
      );

  Map<String, dynamic> toJson() => {
        "textExtraction": textExtraction?.toJson(),
        "analysisInitiation": analysisInitiation?.toJson(),
        "documentTypeIdentification": documentTypeIdentification?.toJson(),
        "keyAnalysis": keyAnalysis?.toJson(),
        "initialAnalysis": initialAnalysis?.toJson(),
        "detailedAnalysis": detailedAnalysis?.toJson(),
        "analysisFinalization": analysisFinalization?.toJson(),
      };
}

class AnalysisFinalization {
  String? label;
  String? description;
  bool? status;

  AnalysisFinalization({
    this.label,
    this.description,
    this.status,
  });

  factory AnalysisFinalization.fromRawJson(String str) => AnalysisFinalization.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AnalysisFinalization.fromJson(Map<String, dynamic> json) => AnalysisFinalization(
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
