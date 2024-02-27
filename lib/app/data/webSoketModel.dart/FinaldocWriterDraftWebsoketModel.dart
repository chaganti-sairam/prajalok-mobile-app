import 'dart:convert';

class FinaldocWriterDraftWebsoketModel {
  String? processId;
  String? type;
  UpdateMessage? updateMessage;
  bool? overallStatus;
  double? timestamp;

  FinaldocWriterDraftWebsoketModel({
    this.processId,
    this.type,
    this.updateMessage,
    this.overallStatus,
    this.timestamp,
  });

  factory FinaldocWriterDraftWebsoketModel.fromRawJson(String str) => FinaldocWriterDraftWebsoketModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FinaldocWriterDraftWebsoketModel.fromJson(Map<String, dynamic> json) => FinaldocWriterDraftWebsoketModel(
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
  FetchingQuestionsAndAnswersDetails? fetchingQuestionsAndAnswersDetails;
  FetchingQuestionsAndAnswersDetails? generatingFinalTemplate;
  FetchingQuestionsAndAnswersDetails? finalizing;

  UpdateMessage({
    this.fetchingQuestionsAndAnswersDetails,
    this.generatingFinalTemplate,
    this.finalizing,
  });

  factory UpdateMessage.fromRawJson(String str) => UpdateMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateMessage.fromJson(Map<String, dynamic> json) => UpdateMessage(
        fetchingQuestionsAndAnswersDetails: json["fetchingQuestionsAndAnswersDetails"] == null
            ? null
            : FetchingQuestionsAndAnswersDetails.fromJson(json["fetchingQuestionsAndAnswersDetails"]),
        generatingFinalTemplate:
            json["generatingFinalTemplate"] == null ? null : FetchingQuestionsAndAnswersDetails.fromJson(json["generatingFinalTemplate"]),
        finalizing: json["finalizing"] == null ? null : FetchingQuestionsAndAnswersDetails.fromJson(json["finalizing"]),
      );

  Map<String, dynamic> toJson() => {
        "fetchingQuestionsAndAnswersDetails": fetchingQuestionsAndAnswersDetails?.toJson(),
        "generatingFinalTemplate": generatingFinalTemplate?.toJson(),
        "finalizing": finalizing?.toJson(),
      };
}

class FetchingQuestionsAndAnswersDetails {
  String? label;
  String? description;
  bool? status;

  FetchingQuestionsAndAnswersDetails({
    this.label,
    this.description,
    this.status,
  });

  factory FetchingQuestionsAndAnswersDetails.fromRawJson(String str) => FetchingQuestionsAndAnswersDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FetchingQuestionsAndAnswersDetails.fromJson(Map<String, dynamic> json) => FetchingQuestionsAndAnswersDetails(
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
