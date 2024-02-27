class StaticLegalDocumentsModel {
  int? id;
  String? docCategory;
  String? docSubCategory;
  String? docType;
  InitialAnalysisFunction? initialAnalysisFunction;
  FinalAnalysisFunction? finalAnalysisFunction;
  KeyAnalysisFunction? keyAnalysisFunction;
  Map<String, dynamic>? templateStructure;
  bool? isTemplate;
  int? version;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  StaticLegalDocumentsModel({
    this.id,
    this.docCategory,
    this.docSubCategory,
    this.docType,
    this.initialAnalysisFunction,
    this.finalAnalysisFunction,
    this.keyAnalysisFunction,
    this.templateStructure,
    this.isTemplate,
    this.version,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory StaticLegalDocumentsModel.fromJson(Map<String, dynamic>? json) {
    return StaticLegalDocumentsModel(
      id: json?['id'],
      docCategory: json?['doc_category'],
      docSubCategory: json?['doc_sub_category'],
      docType: json?['doc_type'],
      initialAnalysisFunction: json != null ? InitialAnalysisFunction.fromJson(json['initial_analysis_function']) : null,
      finalAnalysisFunction: json != null ? FinalAnalysisFunction.fromJson(json['final_analysis_function']) : null,
      keyAnalysisFunction: json != null ? KeyAnalysisFunction.fromJson(json['key_analysis_function']) : null,
      templateStructure: json?['template_structure'],
      isTemplate: json?['is_template'],
      version: json?['version'],
      description: json?['description'],
      createdAt: json?['created_at'] != null ? DateTime.parse(json?['created_at']) : null,
      updatedAt: json?['updated_at'] != null ? DateTime.parse(json?['updated_at']) : null,
    );
  }
}

class InitialAnalysisFunction {
  String? name;
  String? description;
  Map<String, dynamic>? parameters;

  InitialAnalysisFunction({
    this.name,
    this.description,
    this.parameters,
  });

  factory InitialAnalysisFunction.fromJson(Map<String, dynamic>? json) {
    return InitialAnalysisFunction(
      name: json?['name'],
      description: json?['description'],
      parameters: json?['parameters'],
    );
  }
}

class FinalAnalysisFunction {
  String? name;
  String? description;
  Map<String, dynamic>? parameters;

  FinalAnalysisFunction({
    this.name,
    this.description,
    this.parameters,
  });

  factory FinalAnalysisFunction.fromJson(Map<String, dynamic>? json) {
    return FinalAnalysisFunction(
      name: json?['name'],
      description: json?['description'],
      parameters: json?['parameters'],
    );
  }
}

class KeyAnalysisFunction {
  String? name;
  String? description;
  Map<String, dynamic>? parameters;

  KeyAnalysisFunction({
    this.name,
    this.description,
    this.parameters,
  });

  factory KeyAnalysisFunction.fromJson(Map<String, dynamic>? json) {
    return KeyAnalysisFunction(
      name: json?['name'],
      description: json?['description'],
      parameters: json?['parameters'],
    );
  }
}
