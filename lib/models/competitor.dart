class Competitor {
  final int id;
  final int idMA;
  final String name;
  final int price;
  final String program;
  final String support;

  Competitor({
    required this.id,
    required this.idMA,
    required this.name,
    required this.price,
    required this.program,
    required this.support,
  });

  factory Competitor.fromJson(Map<String, dynamic> json) {
    return Competitor(
      id: json['id'],
      idMA: json['id_marketing_activity'],
      name: json['name'],
      price: json['price'],
      program: json['program'],
      support: json['support'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_marketing_activity': idMA,
      'name': name,
      'price': price,
      'program': program,
      'support': support,
    };
  }
}