import 'dart:convert';

class Module {
  int? id;
  String? name;
  String? description;
  String? module;
  bool? archived;
  bool? isFree;
  bool? isPayPerUse;
  int? credits;
  int? price;
  bool? caseWork;
  bool? lawBook;
  bool? prajalok;

  Module({
    this.id,
    this.name,
    this.description,
    this.module,
    this.archived,
    this.isFree,
    this.isPayPerUse,
    this.credits,
    this.price,
    this.caseWork,
    this.lawBook,
    this.prajalok,
  });

  factory Module.fromRawJson(String str) => Module.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        module: json["module"],
        archived: json["archived"],
        isFree: json["is_free"],
        isPayPerUse: json["is_pay_per_use"],
        credits: json["credits"],
        price: json["price"],
        caseWork: json["case_work"],
        lawBook: json["law_book"],
        prajalok: json["prajalok"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "module": module,
        "archived": archived,
        "is_free": isFree,
        "is_pay_per_use": isPayPerUse,
        "credits": credits,
        "price": price,
        "case_work": caseWork,
        "law_book": lawBook,
        "prajalok": prajalok,
      };
}
