import 'dart:convert';

class ContractAnalysisResponseModel {
  String? profileId;
  String? docUrl;
  List<ContractStructure>? contractStructure;
  List<ContractAnalysis>? contractAnalysis;
  List<ContractStructure>? contractUpgrades;
  List<ContractStructure>? updatedStructure;
  String? outputUrl;
  DateTime? createdAt;
  String? taskId;
  String? title;
  String? status;
  int? id;

  ContractAnalysisResponseModel({
    this.profileId,
    this.docUrl,
    this.contractStructure,
    this.contractAnalysis,
    this.contractUpgrades,
    this.updatedStructure,
    this.outputUrl,
    this.createdAt,
    this.taskId,
    this.title,
    this.status,
    this.id,
  });

  factory ContractAnalysisResponseModel.fromRawJson(String str) => ContractAnalysisResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContractAnalysisResponseModel.fromJson(Map<String, dynamic> json) => ContractAnalysisResponseModel(
        profileId: json["profile_id"],
        docUrl: json["doc_url"],
        contractStructure: json["contract_structure"] == null
            ? []
            : List<ContractStructure>.from(json["contract_structure"]!.map((x) => ContractStructure.fromJson(x))),
        contractAnalysis:
            json["contract_analysis"] == null ? [] : List<ContractAnalysis>.from(json["contract_analysis"]!.map((x) => ContractAnalysis.fromJson(x))),
        contractUpgrades: json["contract_upgrades"] == null
            ? []
            : List<ContractStructure>.from(json["contract_upgrades"]!.map((x) => ContractStructure.fromJson(x))),
        updatedStructure: json["updated_structure"] == null
            ? []
            : List<ContractStructure>.from(json["updated_structure"]!.map((x) => ContractStructure.fromJson(x))),
        outputUrl: json["output_url"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        taskId: json["task_id"],
        title: json["title"],
        status: json["status"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "profile_id": profileId,
        "doc_url": docUrl,
        "contract_structure": contractStructure == null ? [] : List<dynamic>.from(contractStructure!.map((x) => x.toJson())),
        "contract_analysis": contractAnalysis == null ? [] : List<dynamic>.from(contractAnalysis!.map((x) => x.toJson())),
        "contract_upgrades": contractUpgrades == null ? [] : List<dynamic>.from(contractUpgrades!.map((x) => x.toJson())),
        "updated_structure": updatedStructure == null ? [] : List<dynamic>.from(updatedStructure!.map((x) => x.toJson())),
        "output_url": outputUrl,
        "created_at": createdAt?.toIso8601String(),
        "task_id": taskId,
        "title": title,
        "status": status,
        "id": id,
      };
}

class ContractAnalysis {
  ClauseInfo? clauseInfo;
  List<ClauseAnalysisElement>? clauseAnalysis;

  ContractAnalysis({
    this.clauseInfo,
    this.clauseAnalysis,
  });

  factory ContractAnalysis.fromRawJson(String str) => ContractAnalysis.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContractAnalysis.fromJson(Map<String, dynamic> json) => ContractAnalysis(
        clauseInfo: json["clause_info"] == null ? null : ClauseInfo.fromJson(json["clause_info"]),
        clauseAnalysis: json["clause_analysis"] == null
            ? []
            : List<ClauseAnalysisElement>.from(json["clause_analysis"]!.map((x) => ClauseAnalysisElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "clause_info": clauseInfo?.toJson(),
        "clause_analysis": clauseAnalysis == null ? [] : List<dynamic>.from(clauseAnalysis!.map((x) => x.toJson())),
      };
}

class ClauseAnalysisElement {
  ClauseAnalysisClauseAnalysis? clauseAnalysis;

  ClauseAnalysisElement({
    this.clauseAnalysis,
  });

  factory ClauseAnalysisElement.fromRawJson(String str) => ClauseAnalysisElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClauseAnalysisElement.fromJson(Map<String, dynamic> json) => ClauseAnalysisElement(
        clauseAnalysis: json["clause_analysis"] == null ? null : ClauseAnalysisClauseAnalysis.fromJson(json["clause_analysis"]),
      );

  Map<String, dynamic> toJson() => {
        "clause_analysis": clauseAnalysis?.toJson(),
      };
}

class ClauseAnalysisClauseAnalysis {
  List<GlossaryRisk>? risk;
  Fairness? fairness;
  Glossary? glossary;
  String? benchmark;
  List<String>? strengths;
  Legibility? legibility;
  List<String>? weaknesses;
  String? clauseName;
  int? clauseNumber;
  List<String>? alternativeLaws;
  List<String>? negotiationPoints;
  List<String>? actionRecommendations;
  String? purposeAndImplications;

  ClauseAnalysisClauseAnalysis({
    this.risk,
    this.fairness,
    this.glossary,
    this.benchmark,
    this.strengths,
    this.legibility,
    this.weaknesses,
    this.clauseName,
    this.clauseNumber,
    this.alternativeLaws,
    this.negotiationPoints,
    this.actionRecommendations,
    this.purposeAndImplications,
  });

  factory ClauseAnalysisClauseAnalysis.fromRawJson(String str) => ClauseAnalysisClauseAnalysis.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClauseAnalysisClauseAnalysis.fromJson(Map<String, dynamic> json) => ClauseAnalysisClauseAnalysis(
        risk: json["risk"] == null ? [] : List<GlossaryRisk>.from(json["risk"]!.map((x) => GlossaryRisk.fromJson(x))),
        fairness: json["fairness"] == null ? null : Fairness.fromJson(json["fairness"]),
        glossary: json["glossary"] == null ? null : Glossary.fromJson(json["glossary"]),
        benchmark: json["benchmark"],
        strengths: json["strengths"] == null ? [] : List<String>.from(json["strengths"]!.map((x) => x)),
        legibility: json["legibility"] == null ? null : Legibility.fromJson(json["legibility"]),
        weaknesses: json["weaknesses"] == null ? [] : List<String>.from(json["weaknesses"]!.map((x) => x)),
        clauseName: json["clause_name"],
        clauseNumber: json["clause_number"],
        alternativeLaws: json["alternative_laws"] == null ? [] : List<String>.from(json["alternative_laws"]!.map((x) => x)),
        negotiationPoints: json["negotiation_points"] == null ? [] : List<String>.from(json["negotiation_points"]!.map((x) => x)),
        actionRecommendations: json["action_recommendations"] == null ? [] : List<String>.from(json["action_recommendations"]!.map((x) => x)),
        purposeAndImplications: json["purpose_and_implications"],
      );

  Map<String, dynamic> toJson() => {
        "risk": risk == null ? [] : List<dynamic>.from(risk!.map((x) => x.toJson())),
        "fairness": fairness?.toJson(),
        "glossary": glossary?.toJson(),
        "benchmark": benchmark,
        "strengths": strengths == null ? [] : List<dynamic>.from(strengths!.map((x) => x)),
        "legibility": legibility?.toJson(),
        "weaknesses": weaknesses == null ? [] : List<dynamic>.from(weaknesses!.map((x) => x)),
        "clause_name": clauseName,
        "clause_number": clauseNumber,
        "alternative_laws": alternativeLaws == null ? [] : List<dynamic>.from(alternativeLaws!.map((x) => x)),
        "negotiation_points": negotiationPoints == null ? [] : List<dynamic>.from(negotiationPoints!.map((x) => x)),
        "action_recommendations": actionRecommendations == null ? [] : List<dynamic>.from(actionRecommendations!.map((x) => x)),
        "purpose_and_implications": purposeAndImplications,
      };
}

class Fairness {
  int? fairnessScore;
  String? clauseFairness;

  Fairness({
    this.fairnessScore,
    this.clauseFairness,
  });

  factory Fairness.fromRawJson(String str) => Fairness.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Fairness.fromJson(Map<String, dynamic> json) => Fairness(
        fairnessScore: json["fairness_score"],
        clauseFairness: json["clause_fairness"],
      );

  Map<String, dynamic> toJson() => {
        "fairness_score": fairnessScore,
        "clause_fairness": clauseFairness,
      };
}

class Glossary {
  List<TermsExplained>? termsExplained;
  List<GlossaryRisk>? risk;
  Fairness? fairness;
  Legibility? legibility;

  Glossary({
    this.termsExplained,
    this.risk,
    this.fairness,
    this.legibility,
  });

  factory Glossary.fromRawJson(String str) => Glossary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Glossary.fromJson(Map<String, dynamic> json) => Glossary(
        termsExplained:
            json["terms_explained"] == null ? [] : List<TermsExplained>.from(json["terms_explained"]!.map((x) => TermsExplained.fromJson(x))),
        risk: json["risk"] == null ? [] : List<GlossaryRisk>.from(json["risk"]!.map((x) => GlossaryRisk.fromJson(x))),
        fairness: json["fairness"] == null ? null : Fairness.fromJson(json["fairness"]),
        legibility: json["legibility"] == null ? null : Legibility.fromJson(json["legibility"]),
      );

  Map<String, dynamic> toJson() => {
        "terms_explained": termsExplained == null ? [] : List<dynamic>.from(termsExplained!.map((x) => x.toJson())),
        "risk": risk == null ? [] : List<dynamic>.from(risk!.map((x) => x.toJson())),
        "fairness": fairness?.toJson(),
        "legibility": legibility?.toJson(),
      };
}

class Legibility {
  double? fkGrade;
  double? smogIndex;

  Legibility({
    this.fkGrade,
    this.smogIndex,
  });

  factory Legibility.fromRawJson(String str) => Legibility.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Legibility.fromJson(Map<String, dynamic> json) => Legibility(
        fkGrade: json["fk_grade"]?.toDouble(),
        smogIndex: json["smog_index"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "fk_grade": fkGrade,
        "smog_index": smogIndex,
      };
}

class GlossaryRisk {
  String? party1Name;
  String? party2Name;
  int? party1Score;
  int? party2Score;
  String? riskAnalysis;

  GlossaryRisk({
    this.party1Name,
    this.party2Name,
    this.party1Score,
    this.party2Score,
    this.riskAnalysis,
  });

  factory GlossaryRisk.fromRawJson(String str) => GlossaryRisk.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GlossaryRisk.fromJson(Map<String, dynamic> json) => GlossaryRisk(
        party1Name: json["party1_name"],
        party2Name: json["party2_name"],
        party1Score: json["party1_score"],
        party2Score: json["party2_score"],
        riskAnalysis: json["risk_analysis"],
      );

  Map<String, dynamic> toJson() => {
        "party1_name": party1Name,
        "party2_name": party2Name,
        "party1_score": party1Score,
        "party2_score": party2Score,
        "risk_analysis": riskAnalysis,
      };
}

class TermsExplained {
  String? term;
  String? termType;
  String? explanation;

  TermsExplained({
    this.term,
    this.termType,
    this.explanation,
  });

  factory TermsExplained.fromRawJson(String str) => TermsExplained.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TermsExplained.fromJson(Map<String, dynamic> json) => TermsExplained(
        term: json["term"],
        termType: json["term_type"],
        explanation: json["explanation"],
      );

  Map<String, dynamic> toJson() => {
        "term": term,
        "term_type": termType,
        "explanation": explanation,
      };
}

class ClauseInfo {
  RiskType? riskType;
  RiskFairness? riskFairness;
  Legibility? legibilityScore;
  String? executiveSummary;
  FairnessAssessment? fairnessAssessment;

  ClauseInfo({
    this.riskType,
    this.riskFairness,
    this.legibilityScore,
    this.executiveSummary,
    this.fairnessAssessment,
  });

  factory ClauseInfo.fromRawJson(String str) => ClauseInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClauseInfo.fromJson(Map<String, dynamic> json) => ClauseInfo(
        riskType: json["risk_type"] == null ? null : RiskType.fromJson(json["risk_type"]),
        riskFairness: json["risk_fairness"] == null ? null : RiskFairness.fromJson(json["risk_fairness"]),
        legibilityScore: json["legibility_score"] == null ? null : Legibility.fromJson(json["legibility_score"]),
        executiveSummary: json["executive_summary"],
        fairnessAssessment: json["fairness_assessment"] == null ? null : FairnessAssessment.fromJson(json["fairness_assessment"]),
      );

  Map<String, dynamic> toJson() => {
        "risk_type": riskType?.toJson(),
        "risk_fairness": riskFairness?.toJson(),
        "legibility_score": legibilityScore?.toJson(),
        "executive_summary": executiveSummary,
        "fairness_assessment": fairnessAssessment?.toJson(),
      };
}

class FairnessAssessment {
  String? empty;
  String? biasedTowards;
  String? overallAnalysis;
  int? fairnessPercentage;
  String? obligationAnalysis;
  String? potentialFraudReason;

  FairnessAssessment({
    this.empty,
    this.biasedTowards,
    this.overallAnalysis,
    this.fairnessPercentage,
    this.obligationAnalysis,
    this.potentialFraudReason,
  });

  factory FairnessAssessment.fromRawJson(String str) => FairnessAssessment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FairnessAssessment.fromJson(Map<String, dynamic> json) => FairnessAssessment(
        empty: json[""],
        biasedTowards: json["biased_towards"],
        overallAnalysis: json["overall_analysis"],
        fairnessPercentage: json["fairness_percentage"],
        obligationAnalysis: json["obligation_analysis"],
        potentialFraudReason: json["potential_fraud_reason"],
      );

  Map<String, dynamic> toJson() => {
        "": empty,
        "biased_towards": biasedTowards,
        "overall_analysis": overallAnalysis,
        "fairness_percentage": fairnessPercentage,
        "obligation_analysis": obligationAnalysis,
        "potential_fraud_reason": potentialFraudReason,
      };
}

class RiskFairness {
  String? party1Name;
  String? party2Name;
  int? party1Score;
  int? party2Score;
  String? riskAnalysis;

  RiskFairness({
    this.party1Name,
    this.party2Name,
    this.party1Score,
    this.party2Score,
    this.riskAnalysis,
  });

  factory RiskFairness.fromRawJson(String str) => RiskFairness.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RiskFairness.fromJson(Map<String, dynamic> json) => RiskFairness(
        party1Name: json["party_1_name"],
        party2Name: json["party_2_name"],
        party1Score: json["party_1_score"],
        party2Score: json["party_2_score"],
        riskAnalysis: json["risk_analysis"],
      );

  Map<String, dynamic> toJson() => {
        "party_1_name": party1Name,
        "party_2_name": party2Name,
        "party_1_score": party1Score,
        "party_2_score": party2Score,
        "risk_analysis": riskAnalysis,
      };
}

class RiskType {
  List<RiskTypeRisk>? risks;

  RiskType({
    this.risks,
  });

  factory RiskType.fromRawJson(String str) => RiskType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RiskType.fromJson(Map<String, dynamic> json) => RiskType(
        risks: json["risks"] == null ? [] : List<RiskTypeRisk>.from(json["risks"]!.map((x) => RiskTypeRisk.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "risks": risks == null ? [] : List<dynamic>.from(risks!.map((x) => x.toJson())),
      };
}

class RiskTypeRisk {
  String? riskName;
  int? percentage;

  RiskTypeRisk({
    this.riskName,
    this.percentage,
  });

  factory RiskTypeRisk.fromRawJson(String str) => RiskTypeRisk.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RiskTypeRisk.fromJson(Map<String, dynamic> json) => RiskTypeRisk(
        riskName: json["risk_name"],
        percentage: json["percentage"],
      );

  Map<String, dynamic> toJson() => {
        "risk_name": riskName,
        "percentage": percentage,
      };
}

class ContractStructure {
  ContractStructure();

  factory ContractStructure.fromRawJson(String str) => ContractStructure.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContractStructure.fromJson(Map<String, dynamic> json) => ContractStructure();

  Map<String, dynamic> toJson() => {};
}
