import 'dart:convert';

class TranslatedFileModel {
  int? id;
  String? profileId;
  String? inputDocUrl;
  String? outputDocUrl;
  String? language;
  String? title;
  DateTime? createdAt;
  String? status;
  DateTime? updatedAt;
  String? taskId;

  TranslatedFileModel({
    this.id,
    this.profileId,
    this.inputDocUrl,
    this.outputDocUrl,
    this.language,
    this.title,
    this.createdAt,
    this.status,
    this.updatedAt,
    this.taskId,
  });

  factory TranslatedFileModel.fromRawJson(String str) =>
      TranslatedFileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TranslatedFileModel.fromJson(Map<String, dynamic> json) =>
      TranslatedFileModel(
        id: json["id"],
        profileId: json["profile_id"],
        inputDocUrl: json["input_doc_url"],
        outputDocUrl: json["output_doc_url"],
        language: json["language"],
        title: json["title"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        status: json["status"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        taskId: json["task_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_id": profileId,
        "input_doc_url": inputDocUrl,
        "output_doc_url": outputDocUrl,
        "language": language,
        "title": title,
        "created_at": createdAt?.toIso8601String(),
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
        "task_id": taskId,
      };
}
