import 'dart:convert';

class TaskStatumodel {
  FinalResponse? finalResponse;
  double? timestamp;

  TaskStatumodel({
    this.finalResponse,
    this.timestamp,
  });

  factory TaskStatumodel.fromRawJson(String str) =>
      TaskStatumodel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaskStatumodel.fromJson(Map<String, dynamic> json) => TaskStatumodel(
        finalResponse: json["final_response"] == null
            ? null
            : FinalResponse.fromJson(json["final_response"]),
        timestamp: json["timestamp"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "final_response": finalResponse?.toJson(),
        "timestamp": timestamp,
      };
}

class FinalResponse {
  String? title;
  String? refinedQuery;
  List<ImmediateAction>? immediateActions;
  List<LawReference>? lawReferences;
  List<NextStep>? nextSteps;
  List<Evidence>? evidences;
  List<Tip>? tips;

  FinalResponse({
    this.title,
    this.refinedQuery,
    this.immediateActions,
    this.lawReferences,
    this.nextSteps,
    this.evidences,
    this.tips,
  });

  factory FinalResponse.fromRawJson(String str) =>
      FinalResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FinalResponse.fromJson(Map<String, dynamic> json) => FinalResponse(
        title: json["title"],
        refinedQuery: json["refined_query"],
        immediateActions: json["immediate_actions"] == null
            ? []
            : List<ImmediateAction>.from(json["immediate_actions"]!
                .map((x) => ImmediateAction.fromJson(x))),
        lawReferences: json["law_references"] == null
            ? []
            : List<LawReference>.from(
                json["law_references"]!.map((x) => LawReference.fromJson(x))),
        nextSteps: json["next_steps"] == null
            ? []
            : List<NextStep>.from(
                json["next_steps"]!.map((x) => NextStep.fromJson(x))),
        evidences: json["evidences"] == null
            ? []
            : List<Evidence>.from(
                json["evidences"]!.map((x) => Evidence.fromJson(x))),
        tips: json["tips"] == null
            ? []
            : List<Tip>.from(json["tips"]!.map((x) => Tip.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "refined_query": refinedQuery,
        "immediate_actions": immediateActions == null
            ? []
            : List<dynamic>.from(immediateActions!.map((x) => x.toJson())),
        "law_references": lawReferences == null
            ? []
            : List<dynamic>.from(lawReferences!.map((x) => x.toJson())),
        "next_steps": nextSteps == null
            ? []
            : List<dynamic>.from(nextSteps!.map((x) => x.toJson())),
        "evidences": evidences == null
            ? []
            : List<dynamic>.from(evidences!.map((x) => x.toJson())),
        "tips": tips == null
            ? []
            : List<dynamic>.from(tips!.map((x) => x.toJson())),
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

  factory Evidence.fromRawJson(String str) =>
      Evidence.fromJson(json.decode(str));

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

  factory ImmediateAction.fromRawJson(String str) =>
      ImmediateAction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImmediateAction.fromJson(Map<String, dynamic> json) =>
      ImmediateAction(
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
  int? serialNo;
  String? lawTitle;
  String? lawDescription;

  LawReference({
    this.serialNo,
    this.lawTitle,
    this.lawDescription,
  });

  factory LawReference.fromRawJson(String str) =>
      LawReference.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LawReference.fromJson(Map<String, dynamic> json) => LawReference(
        serialNo: json["serial_no"],
        lawTitle: json["law_title"],
        lawDescription: json["law_description"],
      );

  Map<String, dynamic> toJson() => {
        "serial_no": serialNo,
        "law_title": lawTitle,
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

  factory NextStep.fromRawJson(String str) =>
      NextStep.fromJson(json.decode(str));

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
