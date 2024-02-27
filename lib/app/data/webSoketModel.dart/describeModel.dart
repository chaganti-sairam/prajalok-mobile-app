import 'dart:convert';

class ClientQueryWebModel {
  String? processId;
  String? type;
  UpdateMessage? updateMessage;
  bool? overallStatus;
  double? timestamp;

  ClientQueryWebModel({
    this.processId,
    this.type,
    this.updateMessage,
    this.overallStatus,
    this.timestamp,
  });

  factory ClientQueryWebModel.fromRawJson(String str) => ClientQueryWebModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClientQueryWebModel.fromJson(Map<String, dynamic> json) => ClientQueryWebModel(
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
  FetchingQuery? fetchingQuery;
  FetchingQuery? queryProcessing;

  UpdateMessage({
    this.fetchingQuery,
    this.queryProcessing,
  });

  factory UpdateMessage.fromRawJson(String str) => UpdateMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateMessage.fromJson(Map<String, dynamic> json) => UpdateMessage(
        fetchingQuery: json["fetchingQuery"] == null ? null : FetchingQuery.fromJson(json["fetchingQuery"]),
        queryProcessing: json["queryProcessing"] == null ? null : FetchingQuery.fromJson(json["queryProcessing"]),
      );

  Map<String, dynamic> toJson() => {
        "fetchingQuery": fetchingQuery?.toJson(),
        "queryProcessing": queryProcessing?.toJson(),
      };
}

class FetchingQuery {
  String? label;
  String? description;
  bool? status;

  FetchingQuery({
    this.label,
    this.description,
    this.status,
  });

  factory FetchingQuery.fromRawJson(String str) => FetchingQuery.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FetchingQuery.fromJson(Map<String, dynamic> json) => FetchingQuery(
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
