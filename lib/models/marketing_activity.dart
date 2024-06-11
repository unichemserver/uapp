class MarketingActivity {
  final int? id;
  final String userId;
  final String? ruteId;
  final String? custId;
  final String? fotoCi;
  final String? fotoCo;
  final DateTime? waktuCi;
  final DateTime? waktuCo;
  final double? latCi;
  final double? lonCi;
  final double? latCo;
  final double? lonCo;
  final int? statusSync;
  final String statusCall;
  final String jenis;
  final String? ttd;
  final DateTime createdAt;

  MarketingActivity({
    this.id,
    required this.userId,
    this.ruteId,
    this.custId,
    this.fotoCi,
    this.fotoCo,
    this.waktuCi,
    this.waktuCo,
    this.latCi,
    this.lonCi,
    this.latCo,
    this.lonCo,
    this.statusSync,
    required this.statusCall,
    required this.jenis,
    this.ttd,
    required this.createdAt,
  });

  factory MarketingActivity.fromJson(Map<String, dynamic> json) {
    return MarketingActivity(
      id: json['id'],
      userId: json['user_id'],
      ruteId: json['rute_id'],
      custId: json['cust_id'],
      fotoCi: json['foto_ci'],
      fotoCo: json['foto_co'],
      waktuCi: json['waktu_ci'] != null ? DateTime.parse(json['waktu_ci']) : null,
      waktuCo: json['waktu_co'] != null ? DateTime.parse(json['waktu_co']) : null,
      latCi: json['lat_ci'],
      lonCi: json['lon_ci'],
      latCo: json['lat_co'],
      lonCo: json['lon_co'],
      statusSync: json['status_sync'],
      statusCall: json['status_call'],
      jenis: json['jenis'],
      ttd: json['ttd'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'rute_id': ruteId,
      'cust_id': custId,
      'foto_ci': fotoCi,
      'foto_co': fotoCo,
      'waktu_ci': waktuCi?.toIso8601String(),
      'waktu_co': waktuCo?.toIso8601String(),
      'lat_ci': latCi,
      'lon_ci': lonCi,
      'lat_co': latCo,
      'lon_co': lonCo,
      'status_sync': statusSync,
      'status_call': statusCall,
      'jenis': jenis,
      'ttd': ttd,
      'created_at': createdAt.toIso8601String(),
    };
  }
}