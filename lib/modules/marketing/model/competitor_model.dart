class CompetitorModel {
  String? idMA;
  String? name;
  int? price;
  String? program;
  String? support;

  CompetitorModel({
    this.idMA,
    this.name,
    this.price,
    this.program,
    this.support,
  });

  factory CompetitorModel.fromJson(Map<String, dynamic> json) => CompetitorModel(
    idMA: json["idMA"],
    name: json["name"],
    price: json["price"],
    program: json["program"],
    support: json["support"],
  );

  Map<String, dynamic> toJson() => {
    "idMA": idMA,
    "name": name,
    "price": price,
    "program": program,
    "support": support,
  };
}