class TamuModel {
  final String nomortamu;
  String? noktp;
  String? namalengkap;
  String? namaperusahaan;
  String? alamat;
  String? nomertelpon;
  String? keperluan;
  String? barangbawaan;
  String? jeniskendaraan;
  String? nopol;
  String? status;
  DateTime? tanggaljamdaftar;
  DateTime? tanggaljammasuk;
  DateTime? tanggaljamkeluar;
  String? fotoBarang;
  int? appointmentId;
  int? appointmentWithPoId;
  int? appointmentWithSoId;
  int? appointmentWithLtoId;
  int? appointmentWithRoId;
  bool? confirmed;
  String? userid;
  DateTime? createdDate;

  TamuModel({
    required this.nomortamu,
    this.noktp,
    this.namalengkap,
    this.namaperusahaan,
    this.alamat,
    this.nomertelpon,
    this.keperluan,
    this.barangbawaan,
    this.jeniskendaraan,
    this.nopol,
    this.status,
    this.tanggaljamdaftar,
    this.tanggaljammasuk,
    this.tanggaljamkeluar,
    this.fotoBarang,
    this.appointmentId,
    this.appointmentWithPoId,
    this.appointmentWithSoId,
    this.appointmentWithLtoId,
    this.appointmentWithRoId,
    this.confirmed,
    this.userid,
    this.createdDate,
  });

  // Factory method to create an instance from JSON
  factory TamuModel.fromJson(Map<String, dynamic> json) {
    return TamuModel(
      nomortamu: json['nomortamu'] ?? '',
      noktp: json['noktp'],
      namalengkap: json['namalengkap'],
      namaperusahaan: json['namaperusahaan'],
      alamat: json['alamat'],
      nomertelpon: json['nomertelpon'],
      keperluan: json['keperluan'],
      barangbawaan: json['barangbawaan'],
      jeniskendaraan: json['jeniskendaraan'],
      nopol: json['nopol'],
      status: json['status'],
      tanggaljamdaftar: json['tanggaljamdaftar'] != null ? DateTime.parse(json['tanggaljamdaftar']) : null,
      tanggaljammasuk: json['tanggaljammasuk'] != null ? DateTime.parse(json['tanggaljammasuk']) : null,
      tanggaljamkeluar: json['tanggaljamkeluar'] != null ? DateTime.parse(json['tanggaljamkeluar']) : null,
      fotoBarang: json['foto_barang'],
      appointmentId: json['appointment_id'],
      appointmentWithPoId: json['appointment_with_po_id'],
      appointmentWithSoId: json['appointment_with_so_id'],
      appointmentWithLtoId: json['appointment_with_lto_id'],
      appointmentWithRoId: json['appointment_with_ro_id'],
      confirmed: json['confirmed'] == 1,
      userid: json['userid'],
      createdDate: json['created_date'] != null ? DateTime.parse(json['created_date']) : null,
    );
  }
}
