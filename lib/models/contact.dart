class Contact {
  final String id;
  final String name;
  final String nickName;
  final String jekel;
  final String foto;
  final String jabatan;
  final String bagian;

  Contact({
    required this.id,
    required this.name,
    required this.nickName,
    required this.jekel,
    required this.foto,
    required this.jabatan,
    required this.bagian,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['PersonalID'],
      name: json['namalengkap'],
      nickName: json['namapanggilan'],
      jekel: json['jeniskelamin'],
      foto: json['fotokaryawan'],
      jabatan: json['kode_jabatan'],
      bagian: json['kode_bagian'],
    );
  }
}