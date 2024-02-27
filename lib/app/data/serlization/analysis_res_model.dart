import 'dart:convert';

class LegalDocument {
  final int? id;
  final String? createdAt;
  final String? updatedAt;
  final String? profileId;
  final Map<String, dynamic>? analysis;
  final String? docUrl;
  final int? legalDocumentId;
  final String? status;
  final String? title;
  final String? taskId;

  LegalDocument({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.profileId,
    this.analysis,
    this.docUrl,
    this.legalDocumentId,
    this.status,
    this.title,
    this.taskId,
  });

  factory LegalDocument.fromJson(Map<String, dynamic> json) {
    return LegalDocument(
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'] ?? "",
      profileId: json['profile_id'],
      analysis: Map<String, dynamic>.from(json['analysis'] ?? {}),
      docUrl: json['doc_url'],
      legalDocumentId: json['legal_document_id'],
      status: json['status'],
      title: json['title'],
      taskId: json['task_id'] ?? "",
    );
  }
}

/// for recent model class

class DocAnalysisRecentModel {
  int? id;
  DateTime? createdAt;
  dynamic updatedAt;
  String? profileId;
  final Map<String, dynamic>? analysis;
  String? docUrl;
  int? legalDocumentId;
  String? status;
  String? title;
  dynamic taskId;

  DocAnalysisRecentModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.profileId,
    this.analysis,
    this.docUrl,
    this.legalDocumentId,
    this.status,
    this.title,
    this.taskId,
  });

  factory DocAnalysisRecentModel.fromRawJson(String str) => DocAnalysisRecentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocAnalysisRecentModel.fromJson(Map<String, dynamic> json) => DocAnalysisRecentModel(
        id: json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        profileId: json["profile_id"],
        analysis: Map<String, dynamic>.from(json['analysis']),
        docUrl: json["doc_url"],
        legalDocumentId: json["legal_document_id"],
        status: json["status"],
        title: json["title"],
        taskId: json["task_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
        "profile_id": profileId,
        //"analysis": Map<String, dynamic>.from(json{analysis}),
        "doc_url": docUrl,
        "legal_document_id": legalDocumentId,
        "status": status,
        "title": title,
        "task_id": taskId,
      };
}
