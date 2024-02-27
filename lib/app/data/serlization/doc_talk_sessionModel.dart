import 'dart:convert';

class DocTalkSessionModel {
  int? id;
  String? profileId;
  List<String>? caseDocUrls;
  List<dynamic>? refDocUrls;
  String? vectorDbCollectionName;
  String? notes;
  String? importantInformation;
  String? summary;
  DateTime? createdAt;
  String? title;
  String? status;
  String? updatedAt;
  String? context;
  List<RecommendedDocUrl>? recommendedDocUrls;
  String? userSide;
  dynamic taskId;
  String? secondaryId;
  List<AvailableRole>? availableRoles;
  String? userRole;

  DocTalkSessionModel({
    this.id,
    this.profileId,
    this.caseDocUrls,
    this.refDocUrls,
    this.vectorDbCollectionName,
    this.notes,
    this.importantInformation,
    this.summary,
    this.createdAt,
    this.title,
    this.status,
    this.updatedAt,
    this.context,
    this.recommendedDocUrls,
    this.userSide,
    this.taskId,
    this.secondaryId,
    this.availableRoles,
    this.userRole,
  });

  factory DocTalkSessionModel.fromRawJson(String str) => DocTalkSessionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocTalkSessionModel.fromJson(Map<String, dynamic> json) => DocTalkSessionModel(
        id: json["id"],
        profileId: json["profile_id"],
        caseDocUrls: json["case_doc_urls"] == null ? [] : List<String>.from(json["case_doc_urls"]!.map((x) => x)),
        refDocUrls: json["ref_doc_urls"] == null ? [] : List<dynamic>.from(json["ref_doc_urls"]!.map((x) => x)),
        vectorDbCollectionName: json["vector_db_collection_name"],
        notes: json["notes"],
        importantInformation: json["important_information"],
        summary: json["summary"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        title: json["title"],
        status: json["status"],
        updatedAt: json["updated_at"],
        context: json["context"],
        recommendedDocUrls: json["recommended_doc_urls"] == null
            ? []
            : List<RecommendedDocUrl>.from(json["recommended_doc_urls"]!.map((x) => RecommendedDocUrl.fromJson(x))),
        userSide: json["user_side"],
        taskId: json["task_id"],
        secondaryId: json["secondary_id"],
        availableRoles:
            json["available_roles"] == null ? [] : List<AvailableRole>.from(json["available_roles"]!.map((x) => AvailableRole.fromJson(x))),
        userRole: json["user_role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_id": profileId,
        "case_doc_urls": caseDocUrls == null ? [] : List<dynamic>.from(caseDocUrls!.map((x) => x)),
        "ref_doc_urls": refDocUrls == null ? [] : List<dynamic>.from(refDocUrls!.map((x) => x)),
        "vector_db_collection_name": vectorDbCollectionName,
        "notes": notes,
        "important_information": importantInformation,
        "summary": summary,
        "created_at": createdAt?.toIso8601String(),
        "title": title,
        "status": status,
        "updated_at": updatedAt,
        "context": context,
        "recommended_doc_urls": recommendedDocUrls == null ? [] : List<dynamic>.from(recommendedDocUrls!.map((x) => x.toJson())),
        "user_side": userSide,
        "task_id": taskId,
        "secondary_id": secondaryId,
        "available_roles": availableRoles == null ? [] : List<dynamic>.from(availableRoles!.map((x) => x.toJson())),
        "user_role": userRole,
      };
}

class AvailableRole {
  String? roleName;
  String? roleDescription;

  AvailableRole({
    this.roleName,
    this.roleDescription,
  });

  factory AvailableRole.fromRawJson(String str) => AvailableRole.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AvailableRole.fromJson(Map<String, dynamic> json) => AvailableRole(
        roleName: json["role_name"],
        roleDescription: json["role_description"],
      );

  Map<String, dynamic> toJson() => {
        "role_name": roleName,
        "role_description": roleDescription,
      };
}

class RecommendedDocUrl {
  String? docUrl;
  String? caseTitle;
  String? judgementSummary;

  RecommendedDocUrl({
    this.docUrl,
    this.caseTitle,
    this.judgementSummary,
  });

  factory RecommendedDocUrl.fromRawJson(String str) => RecommendedDocUrl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecommendedDocUrl.fromJson(Map<String, dynamic> json) => RecommendedDocUrl(
        docUrl: json["doc_url"],
        caseTitle: json["case_title"],
        judgementSummary: json["judgement_summary"],
      );

  Map<String, dynamic> toJson() => {
        "doc_url": docUrl,
        "case_title": caseTitle,
        "judgement_summary": judgementSummary,
      };
}
