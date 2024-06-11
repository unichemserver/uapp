class Collection {
  final int? id;
  final int idMA;
  final String noInvoice;
  String? noCollection;
  final int amount;
  final String type;
  final String status;
  final DateTime? createdDate;

  Collection({
    this.id,
    required this.idMA,
    required this.noInvoice,
    this.noCollection,
    required this.amount,
    required this.type,
    required this.status,
    this.createdDate,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'],
      idMA: json['id_marketing_activity'],
      noInvoice: json['noinvoice'],
      noCollection: json['nocollect'],
      amount: json['amount'],
      type: json['type'],
      status: json['status'],
      createdDate: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_marketing_activity': idMA,
      'noinvoice': noInvoice,
      'nocollect': noCollection,
      'amount': amount,
      'type': type,
      'status': status,
      'created_at': createdDate?.toIso8601String(),
    };
  }
}
