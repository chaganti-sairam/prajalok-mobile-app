import 'dart:convert';

class SearchLawWebSoketModel {
  String? processId;
  String? type;
  UpdateMessage? updateMessage;
  bool? overallStatus;
  double? timestamp;

  SearchLawWebSoketModel({
    this.processId,
    this.type,
    this.updateMessage,
    this.overallStatus,
    this.timestamp,
  });

  factory SearchLawWebSoketModel.fromRawJson(String str) => SearchLawWebSoketModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchLawWebSoketModel.fromJson(Map<String, dynamic> json) => SearchLawWebSoketModel(
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
  ConsolidatingSearchOutcomes? executingLawSearch;
  ConsolidatingSearchOutcomes? consolidatingSearchOutcomes;

  UpdateMessage({
    this.executingLawSearch,
    this.consolidatingSearchOutcomes,
  });

  factory UpdateMessage.fromRawJson(String str) => UpdateMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateMessage.fromJson(Map<String, dynamic> json) => UpdateMessage(
        executingLawSearch: json["executingLawSearch"] == null ? null : ConsolidatingSearchOutcomes.fromJson(json["executingLawSearch"]),
        consolidatingSearchOutcomes:
            json["consolidatingSearchOutcomes"] == null ? null : ConsolidatingSearchOutcomes.fromJson(json["consolidatingSearchOutcomes"]),
      );

  Map<String, dynamic> toJson() => {
        "executingLawSearch": executingLawSearch?.toJson(),
        "consolidatingSearchOutcomes": consolidatingSearchOutcomes?.toJson(),
      };
}

class ConsolidatingSearchOutcomes {
  String? label;
  String? description;
  bool? status;

  ConsolidatingSearchOutcomes({
    this.label,
    this.description,
    this.status,
  });

  factory ConsolidatingSearchOutcomes.fromRawJson(String str) => ConsolidatingSearchOutcomes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConsolidatingSearchOutcomes.fromJson(Map<String, dynamic> json) => ConsolidatingSearchOutcomes(
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
