import 'dart:convert';

class WebsoketResponseModel {
  String? processId;
  String? type;
  UpdateMessage? updateMessage;
  bool? overallStatus;
  double? timestamp;

  WebsoketResponseModel({
    this.processId,
    this.type,
    this.updateMessage,
    this.overallStatus,
    this.timestamp,
  });

  factory WebsoketResponseModel.fromRawJson(String str) => WebsoketResponseModel.fromJson(json.decode(str));

  get length => null;

  String toRawJson() => json.encode(toJson());

  factory WebsoketResponseModel.fromJson(Map<String, dynamic> json) => WebsoketResponseModel(
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
  DocumentFetching? documentFetching;
  DocumentFetching? languageDetection;
  DocumentFetching? pageTranslation;
  DocumentFetching? pdfCreation;
  DocumentFetching? shareableLinkGeneration;

  UpdateMessage({
    this.documentFetching,
    this.languageDetection,
    this.pageTranslation,
    this.pdfCreation,
    this.shareableLinkGeneration,
  });

  factory UpdateMessage.fromRawJson(String str) => UpdateMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateMessage.fromJson(Map<String, dynamic> json) => UpdateMessage(
        documentFetching: json["documentFetching"] == null ? null : DocumentFetching.fromJson(json["documentFetching"]),
        languageDetection: json["languageDetection"] == null ? null : DocumentFetching.fromJson(json["languageDetection"]),
        pageTranslation: json["pageTranslation"] == null ? null : DocumentFetching.fromJson(json["pageTranslation"]),
        pdfCreation: json["pdfCreation"] == null ? null : DocumentFetching.fromJson(json["pdfCreation"]),
        shareableLinkGeneration: json["shareableLinkGeneration"] == null ? null : DocumentFetching.fromJson(json["shareableLinkGeneration"]),
      );

  Map<String, dynamic> toJson() => {
        "documentFetching": documentFetching?.toJson(),
        "languageDetection": languageDetection?.toJson(),
        "pageTranslation": pageTranslation?.toJson(),
        "pdfCreation": pdfCreation?.toJson(),
        "shareableLinkGeneration": shareableLinkGeneration?.toJson(),
      };
}

class DocumentFetching {
  String? label;
  String? description;
  bool? status;

  DocumentFetching({
    this.label,
    this.description,
    this.status,
  });

  factory DocumentFetching.fromRawJson(String str) => DocumentFetching.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocumentFetching.fromJson(Map<String, dynamic> json) => DocumentFetching(
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
