import 'dart:convert';

class LeagalIssueModel {
  int? id;
  List<Issue>? issues;
  String? profileId;
  String? taskId;
  String? title;
  String? summary;
  String? status;
  DateTime? createdAt;
  List<String>? docUrls;

  LeagalIssueModel({
    this.id,
    this.issues,
    this.profileId,
    this.taskId,
    this.title,
    this.summary,
    this.status,
    this.createdAt,
    this.docUrls,
  });

  factory LeagalIssueModel.fromRawJson(String str) => LeagalIssueModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LeagalIssueModel.fromJson(Map<String, dynamic> json) => LeagalIssueModel(
        id: json["id"],
        issues: json["issues"] == null ? [] : List<Issue>.from(json["issues"]!.map((x) => Issue.fromJson(x))),
        profileId: json["profile_id"],
        taskId: json["task_id"],
        title: json["title"],
        summary: json["summary"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        docUrls: json["doc_urls"] == null ? [] : List<String>.from(json["doc_urls"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "issues": issues == null ? [] : List<dynamic>.from(issues!.map((x) => x.toJson())),
        "profile_id": profileId,
        "task_id": taskId,
        "title": title,
        "summary": summary,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "doc_urls": docUrls == null ? [] : List<dynamic>.from(docUrls!.map((x) => x)),
      };
}

class Issue {
  String? docUrl;
  List<LegalIssue>? legalIssues;
  int? totalSections;
  int? totalIssues;

  Issue({
    this.docUrl,
    this.legalIssues,
    this.totalSections,
    this.totalIssues,
  });

  factory Issue.fromRawJson(String str) => Issue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
        docUrl: json["doc_url"],
        legalIssues: json["legal_issues"] == null ? [] : List<LegalIssue>.from(json["legal_issues"]!.map((x) => LegalIssue.fromJson(x))),
        totalSections: json["total_sections"],
        totalIssues: json["total_issues"],
      );

  Map<String, dynamic> toJson() => {
        "doc_url": docUrl,
        "legal_issues": legalIssues == null ? [] : List<dynamic>.from(legalIssues!.map((x) => x.toJson())),
        "total_sections": totalSections,
        "total_issues": totalIssues,
      };
}

class LegalIssue {
  String? reason;
  int? section;
  String? severity;
  List<String>? issueLine;
  String? recommendChanges;
  String? possibleInterpretation;

  LegalIssue({
    this.reason,
    this.section,
    this.severity,
    this.issueLine,
    this.recommendChanges,
    this.possibleInterpretation,
  });

  factory LegalIssue.fromRawJson(String str) => LegalIssue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LegalIssue.fromJson(Map<String, dynamic> json) => LegalIssue(
        reason: json["reason"],
        section: json["section"],
        severity: json["severity"],
        issueLine: json["issue_line"] == null ? [] : List<String>.from(json["issue_line"]!.map((x) => x)),
        recommendChanges: json["recommend_changes"],
        possibleInterpretation: json["possible_interpretation"],
      );

  Map<String, dynamic> toJson() => {
        "reason": reason,
        "section": section,
        "severity": severity,
        "issue_line": issueLine == null ? [] : List<dynamic>.from(issueLine!.map((x) => x)),
        "recommend_changes": recommendChanges,
        "possible_interpretation": possibleInterpretation,
      };
}


// class LeagalIssueModel {
//   final String? reason;
//   final int? section;
//   final String? severity;
//   final List<String>? issueLine;
//   final String? recommendChanges;
//   final String? possibleInterpretation;

//   LeagalIssueModel({
//     this.reason,
//     this.section,
//     this.severity,
//     this.issueLine,
//     this.recommendChanges,
//     this.possibleInterpretation,
//   });

//   factory LeagalIssueModel.fromJson(Map<String, dynamic> json) {
//     return LeagalIssueModel(
//       reason: json['reason'],
//       section: json['section'],
//       severity: json['severity'],
//       issueLine: (json['issue_line'] as List<dynamic>?)?.cast<String>(),
//       recommendChanges: json['recommend_changes'],
//       possibleInterpretation: json['possible_interpretation'],
//     );
//   }
// }

// class CaseDetails {
//   final int? totalIssues;

//   CaseDetails({
//     this.totalIssues,
//   });

//   factory CaseDetails.fromJson(Map<String, dynamic> json) {
//     return CaseDetails(
//       totalIssues: json['total_issues'],
//     );
//   }
// }

// class CaseData {
//   final int? id;
//   final String? profileId;
//   final List<String>? docUrls;
//   final List<LeagalIssueModel>? issues;
//   final CaseDetails? caseDetails;
//   final String? title;
//   final String? summary;
//   final String? status;
//   final String? createdAt;

//   CaseData({
//     this.id,
//     this.profileId,
//     this.docUrls,
//     this.issues,
//     this.caseDetails,
//     this.title,
//     this.summary,
//     this.status,
//     this.createdAt,
//   });

//   factory CaseData.fromJson(Map<String, dynamic> json) {
//     return CaseData(
//       id: json['id'],
//       profileId: json['profile_id'],
//       docUrls: (json['doc_urls'] as List<dynamic>?)?.cast<String>(),
//       issues: (json['issues'] as List<dynamic>?)?.map((issue) => LeagalIssueModel.fromJson(issue)).toList(),
//       caseDetails: json['case_details'] != null ? CaseDetails.fromJson(json['case_details']) : null,
//       title: json['title'],
//       summary: json['summary'],
//       status: json['status'],
//       createdAt: json['created_at'],
//     );
//   }
// }



