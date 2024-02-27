import 'dart:convert';

class FileCheckModel {
  bool? isEnglish;
  bool? isPageLimit;
  bool? isLegal;
  bool? isAgreement;
  bool? isReadable;

  FileCheckModel({
    this.isEnglish,
    this.isPageLimit,
    this.isLegal,
    this.isAgreement,
    this.isReadable,
  });

  factory FileCheckModel.fromRawJson(String str) => FileCheckModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FileCheckModel.fromJson(Map<String, dynamic> json) => FileCheckModel(
        isEnglish: json["is_english"],
        isPageLimit: json["is_page_limit"],
        isLegal: json["is_legal"],
        isAgreement: json["is_agreement"],
        isReadable: json["is_readable"],
      );

  Map<String, dynamic> toJson() => {
        "is_english": isEnglish,
        "is_page_limit": isPageLimit,
        "is_legal": isLegal,
        "is_agreement": isAgreement,
        "is_readable": isReadable,
      };
}
