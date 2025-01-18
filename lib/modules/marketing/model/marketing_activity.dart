class MarketingActivity {
  final String id;
  final String? userId;
  final String? ruteId;
  final String? custId;
  final String? custName;
  final String? fotoCi;
  final String? waktuCi;
  final String? waktuCo;
  final double? latCi;
  final double? lonCi;
  final double? latCo;
  final double? lonCo;
  final String? statusCall;
  final String? jenis;
  final String? ttd;
  final DateTime? createdAt;
  final int? statusSync;

  MarketingActivity({
    required this.id,
    this.userId,
    this.ruteId,
    this.custId,
    this.custName,
    this.fotoCi,
    this.waktuCi,
    this.waktuCo,
    this.latCi,
    this.lonCi,
    this.latCo,
    this.lonCo,
    this.statusCall,
    this.jenis,
    this.ttd,
    this.createdAt,
    this.statusSync,
  });

  // Method untuk membuat instance dari Map
  factory MarketingActivity.fromJson(Map<String, dynamic> map) {
    return MarketingActivity(
      id: map['id'] as String,
      userId: map['user_id'] as String?,
      ruteId: map['rute_id'] as String?,
      custId: map['cust_id'] as String?,
      custName: map['cust_name'] as String?,
      fotoCi: map['foto_ci'] as String?,
      waktuCi: map['waktu_ci'] as String?,
      waktuCo: map['waktu_co'] as String?,
      latCi: map['lat_ci'] as double?,
      lonCi: map['lon_ci'] as double?,
      latCo: map['lat_co'] as double?,
      lonCo: map['lon_co'] as double?,
      statusCall: map['status_call'] as String?,
      jenis: map['jenis'] as String?,
      ttd: map['ttd'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      statusSync: map['status_sync'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'rute_id': ruteId,
      'cust_id': custId,
      'cust_name': custName,
      'foto_ci': fotoCi,
      'waktu_ci': waktuCi,
      'waktu_co': waktuCo,
      'lat_ci': latCi,
      'lon_ci': lonCi,
      'lat_co': latCo,
      'lon_co': lonCo,
      'status_call': statusCall,
      'jenis': jenis,
      'ttd': ttd,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
