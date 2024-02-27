import 'dart:convert';

class DocWriterAnswerModel {
  int? generationId;
  String? question;
  String? answer;
  DateTime? createdAt;
  List<String>? options;
  String? sectionRef;
  int? id;
  String? updatedAt;
  String? questionType;

  DocWriterAnswerModel({
    this.generationId,
    this.question,
    this.answer,
    this.createdAt,
    this.options,
    this.sectionRef,
    this.id,
    this.updatedAt,
    this.questionType,
  });

  factory DocWriterAnswerModel.fromRawJson(String str) => DocWriterAnswerModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocWriterAnswerModel.fromJson(Map<String, dynamic> json) => DocWriterAnswerModel(
        generationId: json["generation_id"],
        question: json["question"],
        answer: json["answer"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        options: json["options"] == null ? [] : List<String>.from(json["options"]!.map((x) => x)),
        sectionRef: json["section_ref"],
        id: json["id"],
        updatedAt: json["updated_at"],
        questionType: json["question_type"],
      );

  Map<String, dynamic> toJson() => {
        "generation_id": generationId,
        "question": question,
        "answer": answer,
        "created_at": createdAt?.toIso8601String(),
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
        "section_ref": sectionRef,
        "id": id,
        "updated_at": updatedAt,
        "question_type": questionType,
      };
}
