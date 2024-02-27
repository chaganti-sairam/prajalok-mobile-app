import 'dart:convert';

class CheckFileModel {
  bool isEnglish;
  bool isPageLimit;

  CheckFileModel({
    required this.isEnglish,
    required this.isPageLimit,
  });

  factory CheckFileModel.fromRawJson(String str) => CheckFileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckFileModel.fromJson(Map<String, dynamic> json) => CheckFileModel(
        isEnglish: json["is_english"],
        isPageLimit: json["is_page_limit"],
      );

  Map<String, dynamic> toJson() => {
        "is_english": isEnglish,
        "is_page_limit": isPageLimit,
      };
}
