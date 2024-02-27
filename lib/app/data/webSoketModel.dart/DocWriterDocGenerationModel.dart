import 'dart:convert';

class DocWriterDocGenerationModel {
  String? profileId;
  String? caseContext;
  List<String>? caseFiles;
  List<String>? refDocUrls;
  int? legalDocumentId;
  TempTemplate? tempTemplate;
  String? finalDocUrl;
  String? secondaryId;
  String? importantInformation;
  String? summary;
  DateTime? createdAt;
  String? updatedAt;
  String? title;
  String? status;
  int? id;
  List<RecommendedDocUrl>? recommendedDocUrls;
  List<Summary>? summaries;
  String? taskId;
  String? vectorDbCollectionName;

  DocWriterDocGenerationModel({
    this.profileId,
    this.caseContext,
    this.caseFiles,
    this.refDocUrls,
    this.legalDocumentId,
    this.tempTemplate,
    this.finalDocUrl,
    this.secondaryId,
    this.importantInformation,
    this.summary,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.status,
    this.id,
    this.recommendedDocUrls,
    this.summaries,
    this.taskId,
    this.vectorDbCollectionName,
  });

  factory DocWriterDocGenerationModel.fromRawJson(String str) =>
      DocWriterDocGenerationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocWriterDocGenerationModel.fromJson(Map<String, dynamic> json) =>
      DocWriterDocGenerationModel(
        profileId: json["profile_id"],
        caseContext: json["case_context"],
        caseFiles: json["case_files"] == null
            ? []
            : List<String>.from(json["case_files"]!.map((x) => x)),
        refDocUrls: json["ref_doc_urls"] == null
            ? []
            : List<String>.from(json["ref_doc_urls"]!.map((x) => x)),
        legalDocumentId: json["legal_document_id"],
        tempTemplate: json["temp_template"] == null
            ? null
            : TempTemplate.fromJson(json["temp_template"]),
        finalDocUrl: json["final_doc_url"],
        secondaryId: json["secondary_id"],
        importantInformation: json["important_information"],
        summary: json["summary"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        title: json["title"],
        status: json["status"],
        id: json["id"],
        recommendedDocUrls: json["recommended_doc_urls"] == null
            ? []
            : List<RecommendedDocUrl>.from(json["recommended_doc_urls"]!
                .map((x) => RecommendedDocUrl.fromJson(x))),
        summaries: json["summaries"] == null
            ? []
            : List<Summary>.from(
                json["summaries"]!.map((x) => Summary.fromJson(x))),
        taskId: json["task_id"],
        vectorDbCollectionName: json["vector_db_collection_name"],
      );

  Map<String, dynamic> toJson() => {
        "profile_id": profileId,
        "case_context": caseContext,
        "case_files": caseFiles == null
            ? []
            : List<dynamic>.from(caseFiles!.map((x) => x)),
        "ref_doc_urls": refDocUrls == null
            ? []
            : List<dynamic>.from(refDocUrls!.map((x) => x)),
        "legal_document_id": legalDocumentId,
        "temp_template": tempTemplate?.toJson(),
        "final_doc_url": finalDocUrl,
        "secondary_id": secondaryId,
        "important_information": importantInformation,
        "summary": summary,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
        "title": title,
        "status": status,
        "id": id,
        "recommended_doc_urls": recommendedDocUrls == null
            ? []
            : List<dynamic>.from(recommendedDocUrls!.map((x) => x.toJson())),
        "summaries": summaries == null
            ? []
            : List<dynamic>.from(summaries!.map((x) => x.toJson())),
        "task_id": taskId,
        "vector_db_collection_name": vectorDbCollectionName,
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

  factory RecommendedDocUrl.fromRawJson(String str) =>
      RecommendedDocUrl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecommendedDocUrl.fromJson(Map<String, dynamic> json) =>
      RecommendedDocUrl(
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

class Summary {
  String? docTitle;
  String? docSummary;

  Summary({
    this.docTitle,
    this.docSummary,
  });

  factory Summary.fromRawJson(String str) => Summary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        docTitle: json["doc_title"],
        docSummary: json["doc_summary"],
      );

  Map<String, dynamic> toJson() => {
        "doc_title": docTitle,
        "doc_summary": docSummary,
      };
}

class TempTemplate {
  String? header;
  Introduction? introduction;
  Introduction? verification;
  Introduction? statementOfOath;
  Introduction? titleOfTheAffidavit;

  TempTemplate({
    this.header,
    this.introduction,
    this.verification,
    this.statementOfOath,
    this.titleOfTheAffidavit,
  });

  factory TempTemplate.fromRawJson(String str) =>
      TempTemplate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TempTemplate.fromJson(Map<String, dynamic> json) => TempTemplate(
        header: json["header"],
        introduction: json["Introduction"] == null
            ? null
            : Introduction.fromJson(json["Introduction"]),
        verification: json["Verification"] == null
            ? null
            : Introduction.fromJson(json["Verification"]),
        statementOfOath: json["Statement of Oath"] == null
            ? null
            : Introduction.fromJson(json["Statement of Oath"]),
        titleOfTheAffidavit: json["Title of the Affidavit"] == null
            ? null
            : Introduction.fromJson(json["Title of the Affidavit"]),
      );

  Map<String, dynamic> toJson() => {
        "header": header,
        "Introduction": introduction?.toJson(),
        "Verification": verification?.toJson(),
        "Statement of Oath": statementOfOath?.toJson(),
        "Title of the Affidavit": titleOfTheAffidavit?.toJson(),
      };
}

class Introduction {
  List<RequiredPoint>? requiredPoints;

  Introduction({
    this.requiredPoints,
  });

  factory Introduction.fromRawJson(String str) =>
      Introduction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Introduction.fromJson(Map<String, dynamic> json) => Introduction(
        requiredPoints: json["required_points"] == null
            ? []
            : List<RequiredPoint>.from(
                json["required_points"]!.map((x) => RequiredPoint.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "required_points": requiredPoints == null
            ? []
            : List<dynamic>.from(requiredPoints!.map((x) => x.toJson())),
      };
}

class RequiredPoint {
  String? mainPoint;
  List<String>? subPoints;

  RequiredPoint({
    this.mainPoint,
    this.subPoints,
  });

  factory RequiredPoint.fromRawJson(String str) =>
      RequiredPoint.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequiredPoint.fromJson(Map<String, dynamic> json) => RequiredPoint(
        mainPoint: json["main_point"],
        subPoints: json["sub_points"] == null
            ? []
            : List<String>.from(json["sub_points"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "main_point": mainPoint,
        "sub_points": subPoints == null
            ? []
            : List<dynamic>.from(subPoints!.map((x) => x)),
      };
}
