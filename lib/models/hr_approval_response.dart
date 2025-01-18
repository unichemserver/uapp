class HrSuratIjin {
  String id;
  String noNik;
  String nomor;
  String nama;
  String keterangan;
  String trtype;
  String status;
  String approvedBy;
  bool isChecked;

  HrSuratIjin({
    required this.id,
    required this.noNik,
    required this.nomor,
    required this.nama,
    required this.keterangan,
    required this.trtype,
    required this.status,
    required this.approvedBy,
    this.isChecked = false,
  });

  factory HrSuratIjin.fromJson(Map<String, dynamic> json) {
    return HrSuratIjin(
      id: json['id'],
      noNik: json['no_nik'],
      nomor: json['nomor'],
      nama: json['nama'],
      keterangan: json['keterangan'],
      trtype: json['trtype'],
      status: json['status'],
      approvedBy: json['approved_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'no_nik': noNik,
      'nomor': nomor,
      'nama': nama,
      'keterangan': keterangan,
      'trtype': trtype,
      'status': status,
      'approved_by': approvedBy,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HrSuratIjin && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class HrResponse {
  List<HrSuratIjin> hrSuratIjinTidakMasuk;
  List<HrSuratIjin> hrLaporanRencanaLembur;
  List<HrSuratIjin> hrFormRealisasiLembur;
  List<HrSuratIjin> hrTugasDinasLuar;
  List<HrSuratIjin> hrMasukDatangTerlambat;
  List<HrSuratIjin> hrSuratIjinPulang;
  List<HrSuratIjin> hrSuratIjinKeluar;
  List<HrSuratIjin> hrSuratKeluarMobil;
  List<HrSuratIjin> hrOrderReparasi;
  List<HrSuratIjin> hrFormPermintaanTenagaKerja;
  List<HrSuratIjin> hrFormPermintaanTenagaKerjaTidakRutin;
  List<HrSuratIjin> hrFormPermintaanTenagaKerjaBorongan;
  int get total => hrSuratIjinTidakMasuk.length + hrLaporanRencanaLembur.length + hrFormRealisasiLembur.length + hrTugasDinasLuar.length + hrMasukDatangTerlambat.length + hrSuratIjinPulang.length + hrSuratIjinKeluar.length + hrSuratKeluarMobil.length + hrOrderReparasi.length + hrFormPermintaanTenagaKerja.length + hrFormPermintaanTenagaKerjaTidakRutin.length + hrFormPermintaanTenagaKerjaBorongan.length;

  HrResponse({
    required this.hrSuratIjinTidakMasuk,
    required this.hrLaporanRencanaLembur,
    required this.hrFormRealisasiLembur,
    required this.hrTugasDinasLuar,
    required this.hrMasukDatangTerlambat,
    required this.hrSuratIjinPulang,
    required this.hrSuratIjinKeluar,
    required this.hrSuratKeluarMobil,
    required this.hrOrderReparasi,
    required this.hrFormPermintaanTenagaKerja,
    required this.hrFormPermintaanTenagaKerjaTidakRutin,
    required this.hrFormPermintaanTenagaKerjaBorongan,
  });

  factory HrResponse.fromJson(Map<String, dynamic> json) {
    return HrResponse(
      hrSuratIjinTidakMasuk: (json['hr_surat_ijin_tidak_masuk'] as List)
          .map((i) => HrSuratIjin.fromJson(i))
          .toList(),
      hrLaporanRencanaLembur: (json['hr_laporan_rencana_lembur'] as List)
          .map((i) => HrSuratIjin.fromJson(i))
          .toList(),
      hrFormRealisasiLembur: (json['hr_form_realisasi_lembur'] as List)
          .map((i) => HrSuratIjin.fromJson(i))
          .toList(),
      hrTugasDinasLuar: (json['hr_tugas_dinas_luar'] as List)
          .map((i) => HrSuratIjin.fromJson(i))
          .toList(),
      hrMasukDatangTerlambat: (json['hr_masuk_datang_terlambat'] as List)
          .map((i) => HrSuratIjin.fromJson(i))
          .toList(),
      hrSuratIjinPulang: (json['hr_surat_ijin_pulang'] as List)
          .map((i) => HrSuratIjin.fromJson(i))
          .toList(),
      hrSuratIjinKeluar: (json['hr_surat_ijin_keluar'] as List)
          .map((i) => HrSuratIjin.fromJson(i))
          .toList(),
      hrSuratKeluarMobil: (json['hr_surat_keluar_mobil'] as List)
          .map((i) => HrSuratIjin.fromJson(i))
          .toList(),
      hrOrderReparasi: (json['hr_order_reparasi'] as List)
          .map((i) => HrSuratIjin.fromJson(i))
          .toList(),
      hrFormPermintaanTenagaKerja:
          (json['hr_form_permintaan_tenaga_kerja'] as List)
              .map((i) => HrSuratIjin.fromJson(i))
              .toList(),
      hrFormPermintaanTenagaKerjaTidakRutin:
          (json['hr_form_permintaan_tenaga_kerja_tidak_rutin'] as List)
              .map((i) => HrSuratIjin.fromJson(i))
              .toList(),
      hrFormPermintaanTenagaKerjaBorongan:
          (json['hr_form_permintaan_tenaga_kerja_borongan'] as List)
              .map((i) => HrSuratIjin.fromJson(i))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hr_surat_ijin_tidak_masuk':
          hrSuratIjinTidakMasuk.map((i) => i.toJson()).toList(),
      'hr_laporan_rencana_lembur':
          hrLaporanRencanaLembur.map((i) => i.toJson()).toList(),
      'hr_form_realisasi_lembur':
          hrFormRealisasiLembur.map((i) => i.toJson()).toList(),
      'hr_tugas_dinas_luar': hrTugasDinasLuar.map((i) => i.toJson()).toList(),
      'hr_masuk_datang_terlambat':
          hrMasukDatangTerlambat.map((i) => i.toJson()).toList(),
      'hr_surat_ijin_pulang': hrSuratIjinPulang.map((i) => i.toJson()).toList(),
      'hr_surat_ijin_keluar': hrSuratIjinKeluar.map((i) => i.toJson()).toList(),
      'hr_surat_keluar_mobil': hrSuratKeluarMobil.map((i) => i.toJson()).toList(),
      'hr_order_reparasi': hrOrderReparasi.map((i) => i.toJson()).toList(),
      'hr_form_permintaan_tenaga_kerja':
          hrFormPermintaanTenagaKerja.map((i) => i.toJson()).toList(),
      'hr_form_permintaan_tenaga_kerja_tidak_rutin':
          hrFormPermintaanTenagaKerjaTidakRutin.map((i) => i.toJson()).toList(),
      'hr_form_permintaan_tenaga_kerja_borongan':
          hrFormPermintaanTenagaKerjaBorongan.map((i) => i.toJson()).toList(),
    };
  }
}
