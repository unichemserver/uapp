class NooActivity {
  final int id;
  final String? idnoo;
  final int? statussync;
  final String? status;
  final int? approved;
  final String? idCustOrlan;

  NooActivity({
    required this.id,
    this.idnoo,
    this.statussync,
    this.status,
    this.approved,
    this.idCustOrlan,
  });

  factory NooActivity.fromJson(Map<String, dynamic> json) => NooActivity(
        id: json['id'] as int,
        idnoo: json['idnoo'] as String?,
        statussync: json['statussync'] as int?,
        status: json['status'] as String?,
        approved: json['approved'] as int?,
        idCustOrlan: json['idCustOrlan'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'idnoo': idnoo,
        'statussync': statussync,
        'status': status,
        'approved': approved,
        'idCustOrlan': idCustOrlan,
      };
}

