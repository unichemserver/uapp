class User {
  final String id;
  final String nama;
  final String? namaPanggilan;
  final String role;
  final String department;
  final String bagian;
  final String jabatan;
  final String posisi;
  final String jenis;
  final String colectorid;
  final String? salesrepid;
  final String idupline;
  final String token;
  final String foto;
  String passwdStatus;
  final String namaJabatan;
  final String namaDepartment;
  final String namaBagian;

  User({
    required this.id,
    required this.nama,
    required this.namaPanggilan,
    required this.role,
    required this.department,
    required this.bagian,
    required this.jabatan,
    required this.posisi,
    required this.jenis,
    required this.colectorid,
    required this.salesrepid,
    required this.idupline,
    required this.token,
    required this.foto,
    required this.passwdStatus,
    required this.namaJabatan,
    required this.namaDepartment,
    required this.namaBagian,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nama: json['nama'],
      namaPanggilan: json['namapanggilan'],
      role: json['role'],
      department: json['department'],
      bagian: json['bagian'],
      jabatan: json['jabatan'],
      posisi: json['posisi'],
      jenis: json['jenis'],
      colectorid: json['colectorid'],
      salesrepid: json['salesrepid'],
      idupline: json['idupline'],
      token: json['token'],
      foto: json['foto'] ?? '',
      passwdStatus: json['password_status'] ?? '0',
      namaJabatan: json['nama_jabatan'],
      namaDepartment: json['nama_department'],
      namaBagian: json['nama_bagian'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'namapanggilan': namaPanggilan,
      'role': role,
      'department': department,
      'bagian': bagian,
      'jabatan': jabatan,
      'posisi': posisi,
      'jenis': jenis,
      'colectorid': colectorid,
      'salesrepid': salesrepid,
      'idupline': idupline,
      'token': token,
      'foto': foto,
      'password_status': passwdStatus,
      'nama_jabatan': namaJabatan,
      'nama_department': namaDepartment,
      'nama_bagian': namaBagian,
    };
  }
}
