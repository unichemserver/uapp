class Equipment {
  final String idPeralatan;
  final String namaPeralatan;

  Equipment({
    required this.idPeralatan,
    required this.namaPeralatan,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      idPeralatan: json['id_peralatan'],
      namaPeralatan: json['nama_peralatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_peralatan': idPeralatan,
      'nama_peralatan': namaPeralatan,
    };
  }
}

class HeavyEquipment {
  final String namaAlatBerat;
  final String nomerSerial;

  HeavyEquipment({
    required this.namaAlatBerat,
    required this.nomerSerial,
  });

  factory HeavyEquipment.fromJson(Map<String, dynamic> json) {
    return HeavyEquipment(
      namaAlatBerat: json['nama_alat_berat'],
      nomerSerial: json['nomer_serial'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_alat_berat': namaAlatBerat,
      'nomer_serial': nomerSerial,
    };
  }
}

class ResponseData {
  final List<Equipment> it;
  final List<HeavyEquipment> ab;

  ResponseData({
    required this.it,
    required this.ab,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    var itList = json['it'] as List;
    var abList = json['ab'] as List;

    List<Equipment> itItems = itList.map((i) => Equipment.fromJson(i)).toList();
    List<HeavyEquipment> abItems = abList.map((i) => HeavyEquipment.fromJson(i)).toList();

    return ResponseData(
      it: itItems,
      ab: abItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'it': it.map((item) => item.toJson()).toList(),
      'ab': ab.map((item) => item.toJson()).toList(),
    };
  }
}