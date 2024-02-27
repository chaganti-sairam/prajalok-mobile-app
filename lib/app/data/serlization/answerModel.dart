import 'dart:convert';

class ClientQueryRecentModel {
  int? id;
  String? profileId;
  String? query;
  DateTime? createdAt;
  String? taskId;
  List<Answer>? answer;

  ClientQueryRecentModel({
    this.id,
    this.profileId,
    this.query,
    this.createdAt,
    this.taskId,
    this.answer,
  });

  factory ClientQueryRecentModel.fromRawJson(String str) => ClientQueryRecentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClientQueryRecentModel.fromJson(Map<String, dynamic> json) => ClientQueryRecentModel(
        id: json["id"],
        profileId: json["profile_id"],
        query: json["query"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        taskId: json["task_id"],
        answer: json["answer"] == null ? [] : List<Answer>.from(json["answer"]!.map((x) => Answer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_id": profileId,
        "query": query,
        "created_at": createdAt?.toIso8601String(),
        "task_id": taskId,
        "answer": answer == null ? [] : List<dynamic>.from(answer!.map((x) => x.toJson())),
      };
}

class Answer {
  List<Tip>? tips;
  String? title;
  List<Evidence>? evidences;
  List<NextStep>? nextSteps;
  String? refinedQuery;
  List<LawReference>? lawReferences;
  List<ImmediateAction>? immediateActions;
  OtherImportantInformation? otherImportantInformation;

  Answer({
    this.tips,
    this.title,
    this.evidences,
    this.nextSteps,
    this.refinedQuery,
    this.lawReferences,
    this.immediateActions,
    this.otherImportantInformation,
  });

  factory Answer.fromRawJson(String str) => Answer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        tips: json["tips"] == null ? [] : List<Tip>.from(json["tips"]!.map((x) => Tip.fromJson(x))),
        title: json["title"],
        evidences: json["evidences"] == null ? [] : List<Evidence>.from(json["evidences"]!.map((x) => Evidence.fromJson(x))),
        nextSteps: json["next_steps"] == null ? [] : List<NextStep>.from(json["next_steps"]!.map((x) => NextStep.fromJson(x))),
        refinedQuery: json["refined_query"],
        lawReferences: json["law_references"] == null ? [] : List<LawReference>.from(json["law_references"]!.map((x) => LawReference.fromJson(x))),
        immediateActions:
            json["immediate_actions"] == null ? [] : List<ImmediateAction>.from(json["immediate_actions"]!.map((x) => ImmediateAction.fromJson(x))),
        otherImportantInformation:
            json["other_important_information"] == null ? null : OtherImportantInformation.fromJson(json["other_important_information"]),
      );

  Map<String, dynamic> toJson() => {
        "tips": tips == null ? [] : List<dynamic>.from(tips!.map((x) => x.toJson())),
        "title": title,
        "evidences": evidences == null ? [] : List<dynamic>.from(evidences!.map((x) => x.toJson())),
        "next_steps": nextSteps == null ? [] : List<dynamic>.from(nextSteps!.map((x) => x.toJson())),
        "refined_query": refinedQuery,
        "law_references": lawReferences == null ? [] : List<dynamic>.from(lawReferences!.map((x) => x.toJson())),
        "immediate_actions": immediateActions == null ? [] : List<dynamic>.from(immediateActions!.map((x) => x.toJson())),
        "other_important_information": otherImportantInformation?.toJson(),
      };
}

class Evidence {
  int? serialNo;
  String? documentName;
  String? documentNotice;

  Evidence({
    this.serialNo,
    this.documentName,
    this.documentNotice,
  });

  factory Evidence.fromRawJson(String str) => Evidence.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Evidence.fromJson(Map<String, dynamic> json) => Evidence(
        serialNo: json["serial_no"],
        documentName: json["document_name"],
        documentNotice: json["document_notice"],
      );

  Map<String, dynamic> toJson() => {
        "serial_no": serialNo,
        "document_name": documentName,
        "document_notice": documentNotice,
      };
}

class ImmediateAction {
  int? serialNo;
  String? actionTitles;
  String? actionDescription;

  ImmediateAction({
    this.serialNo,
    this.actionTitles,
    this.actionDescription,
  });

  factory ImmediateAction.fromRawJson(String str) => ImmediateAction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImmediateAction.fromJson(Map<String, dynamic> json) => ImmediateAction(
        serialNo: json["serial_no"],
        actionTitles: json["action_titles"],
        actionDescription: json["action_description"],
      );

  Map<String, dynamic> toJson() => {
        "serial_no": serialNo,
        "action_titles": actionTitles,
        "action_description": actionDescription,
      };
}

class LawReference {
  String? lawTitle;
  int? serialNo;
  String? lawDescription;

  LawReference({
    this.lawTitle,
    this.serialNo,
    this.lawDescription,
  });

  factory LawReference.fromRawJson(String str) => LawReference.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LawReference.fromJson(Map<String, dynamic> json) => LawReference(
        lawTitle: json["law_title"],
        serialNo: json["serial_no"],
        lawDescription: json["law_description"],
      );

  Map<String, dynamic> toJson() => {
        "law_title": lawTitle,
        "serial_no": serialNo,
        "law_description": lawDescription,
      };
}

class NextStep {
  int? serialNo;
  String? stepTitle;
  String? stepDescription;

  NextStep({
    this.serialNo,
    this.stepTitle,
    this.stepDescription,
  });

  factory NextStep.fromRawJson(String str) => NextStep.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NextStep.fromJson(Map<String, dynamic> json) => NextStep(
        serialNo: json["serial_no"],
        stepTitle: json["step_title"],
        stepDescription: json["step_description"],
      );

  Map<String, dynamic> toJson() => {
        "serial_no": serialNo,
        "step_title": stepTitle,
        "step_description": stepDescription,
      };
}

class OtherImportantInformation {
  int? serialNo;
  String? informationDescription;

  OtherImportantInformation({
    this.serialNo,
    this.informationDescription,
  });

  factory OtherImportantInformation.fromRawJson(String str) => OtherImportantInformation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OtherImportantInformation.fromJson(Map<String, dynamic> json) => OtherImportantInformation(
        serialNo: json["serial_no"],
        informationDescription: json["information_description"],
      );

  Map<String, dynamic> toJson() => {
        "serial_no": serialNo,
        "information_description": informationDescription,
      };
}

class Tip {
  int? serialNo;
  String? tipDescription;

  Tip({
    this.serialNo,
    this.tipDescription,
  });

  factory Tip.fromRawJson(String str) => Tip.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tip.fromJson(Map<String, dynamic> json) => Tip(
        serialNo: json["serial_no"],
        tipDescription: json["tip_description"],
      );

  Map<String, dynamic> toJson() => {
        "serial_no": serialNo,
        "tip_description": tipDescription,
      };
}
