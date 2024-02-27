import 'dart:convert';

class LawSearchModel {
  int? id;
  String? profileId;
  String? title;
  String? query;
  Response? response;
  DateTime? createdAt;
  String? updatedAt;
  String? taskId;

  LawSearchModel({
    this.id,
    this.profileId,
    this.title,
    this.query,
    this.response,
    this.createdAt,
    this.updatedAt,
    this.taskId,
  });

  factory LawSearchModel.fromRawJson(String str) => LawSearchModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LawSearchModel.fromJson(Map<String, dynamic> json) => LawSearchModel(
        id: json["id"],
        profileId: json["profile_id"],
        title: json["title"],
        query: json["query"],
        response: json["response"] == null ? null : Response.fromJson(json["response"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        taskId: json["task_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_id": profileId,
        "title": title,
        "query": query,
        "response": response?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
        "task_id": taskId,
      };
}

class Response {
  List<Law>? laws;
  String? title;

  Response({
    this.laws,
    this.title,
  });

  factory Response.fromRawJson(String str) => Response.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        laws: json["laws"] == null ? [] : List<Law>.from(json["laws"]!.map((x) => Law.fromJson(x))),
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "laws": laws == null ? [] : List<dynamic>.from(laws!.map((x) => x.toJson())),
        "title": title,
      };
}

class Law {
  String? lawName;
  String? lawSummary;
  List<RelatedLaw>? relatedLaws;
  List<String>? lawKeyPoints;

  Law({
    this.lawName,
    this.lawSummary,
    this.relatedLaws,
    this.lawKeyPoints,
  });

  factory Law.fromRawJson(String str) => Law.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Law.fromJson(Map<String, dynamic> json) => Law(
        lawName: json["law_name"],
        lawSummary: json["law_summary"],
        relatedLaws: json["related_laws"] == null ? [] : List<RelatedLaw>.from(json["related_laws"]!.map((x) => RelatedLaw.fromJson(x))),
        lawKeyPoints: json["law_key_points"] == null ? [] : List<String>.from(json["law_key_points"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "law_name": lawName,
        "law_summary": lawSummary,
        "related_laws": relatedLaws == null ? [] : List<dynamic>.from(relatedLaws!.map((x) => x.toJson())),
        "law_key_points": lawKeyPoints == null ? [] : List<dynamic>.from(lawKeyPoints!.map((x) => x)),
      };
}

class RelatedLaw {
  String? nameOfRelatedLaw;
  String? descriptionOfRelatedLaw;

  RelatedLaw({
    this.nameOfRelatedLaw,
    this.descriptionOfRelatedLaw,
  });

  factory RelatedLaw.fromRawJson(String str) => RelatedLaw.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RelatedLaw.fromJson(Map<String, dynamic> json) => RelatedLaw(
        nameOfRelatedLaw: json["name_of_related_law"],
        descriptionOfRelatedLaw: json["description_of_related_law"],
      );

  Map<String, dynamic> toJson() => {
        "name_of_related_law": nameOfRelatedLaw,
        "description_of_related_law": descriptionOfRelatedLaw,
      };
}
