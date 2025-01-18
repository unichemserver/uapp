class CollectionModel {
  String idMA;
  String noInvoice;
  String noCollect;
  int amount;
  String type;
  String? buktiBayar;
  String status;

  CollectionModel({
    required this.idMA,
    required this.noInvoice,
    required this.noCollect,
    required this.amount,
    required this.type,
    this.buktiBayar,
    required this.status,
  });

  factory CollectionModel.fromMap(Map<String, dynamic> data) {
    return CollectionModel(
      idMA: data['idMA'],
      noInvoice: data['noinvoice'],
      noCollect: data['nocollect'],
      amount: data['amount'],
      type: data['type'],
      buktiBayar: data['bukti_bayar'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idMA': idMA,
      'noinvoice': noInvoice,
      'nocollect': noCollect,
      'amount': amount,
      'type': type,
      'bukti_bayar': buktiBayar,
      'status': status,
    };
  }
}