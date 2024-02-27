import 'dart:convert';

class FileUploadedRes {
  String? publicUrl;
  int? status;

  FileUploadedRes({
    this.publicUrl,
    this.status,
  });

  factory FileUploadedRes.fromRawJson(String str) => FileUploadedRes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FileUploadedRes.fromJson(Map<String, dynamic> json) => FileUploadedRes(
        publicUrl: json["public_url"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "public_url": publicUrl,
        "status": status,
      };
}
