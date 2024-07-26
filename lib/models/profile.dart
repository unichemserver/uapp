class Profile {
  final String id;
  final String personalID;
  final String username;
  final String password;
  final String role;
  final String nama;
  final String jabatan;
  final String idupline;
  final String colectorid;
  final String salesrepid;
  final String jenisUser;
  final String kodeWarna;
  final String? deskripsiProfile;
  final String mobileToken;
  final String nik;
  final String namaLengkap;
  final String namaPanggilan;
  final String kodeJabatan;
  final String kodeBagian;
  final String tanggalMasukKerja;
  final String kodeDepartment;
  final String statusPekerja;
  final String tanggalPengangkatan;
  final String jenisKelamin;
  final String tempatLahir;
  final String tanggalLahir;
  final String sukuBangsa;
  final String agama;
  final String golonganDarah;
  final String alamatRumah;
  final String alamatRumahSementara;
  final String teleponRumah;
  final String hp;
  final String email;
  final String noKtp;
  final String berlakuSampai;
  final String noKk;
  final String dokumenKk;
  final String npwp;
  final String dokumenNpwp;
  final String tanggalTerdaftarNpwp;
  final String tingkatPendidikan;
  final String noJamsostek;
  final String dokumenJamsostek;
  final String tanggalTerdaftarJamsostek;
  final String noBpjsKesehatan;
  final String dokumenBpjsKesehatan;
  final String tanggalTerdaftarBpjsKesehatan;
  final String statusPerkawinan;
  final String fotoKaryawan;
  final String tipe;
  final String lokasiKantor;
  final String sisaCuti;
  final String addedBy;
  final String status;
  final String kk;
  final String bpjs;
  final String ijazah;
  final String kontrakKerja;
  final String tanggalHabisKontrakKerja;
  final String suratPengangkatan;
  final String dokumenLain1;
  final String dokumenLain2;

  Profile({
    required this.id,
    required this.personalID,
    required this.username,
    required this.password,
    required this.role,
    required this.nama,
    required this.jabatan,
    required this.idupline,
    required this.colectorid,
    required this.salesrepid,
    required this.jenisUser,
    required this.kodeWarna,
    this.deskripsiProfile,
    required this.mobileToken,
    required this.nik,
    required this.namaLengkap,
    required this.namaPanggilan,
    required this.kodeJabatan,
    required this.kodeBagian,
    required this.tanggalMasukKerja,
    required this.kodeDepartment,
    required this.statusPekerja,
    required this.tanggalPengangkatan,
    required this.jenisKelamin,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.sukuBangsa,
    required this.agama,
    required this.golonganDarah,
    required this.alamatRumah,
    required this.alamatRumahSementara,
    required this.teleponRumah,
    required this.hp,
    required this.email,
    required this.noKtp,
    required this.berlakuSampai,
    required this.noKk,
    required this.dokumenKk,
    required this.npwp,
    required this.dokumenNpwp,
    required this.tanggalTerdaftarNpwp,
    required this.tingkatPendidikan,
    required this.noJamsostek,
    required this.dokumenJamsostek,
    required this.tanggalTerdaftarJamsostek,
    required this.noBpjsKesehatan,
    required this.dokumenBpjsKesehatan,
    required this.tanggalTerdaftarBpjsKesehatan,
    required this.statusPerkawinan,
    required this.fotoKaryawan,
    required this.tipe,
    required this.lokasiKantor,
    required this.sisaCuti,
    required this.addedBy,
    required this.status,
    required this.kk,
    required this.bpjs,
    required this.ijazah,
    required this.kontrakKerja,
    required this.tanggalHabisKontrakKerja,
    required this.suratPengangkatan,
    required this.dokumenLain1,
    required this.dokumenLain2,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      personalID: json['PersonalID'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
      nama: json['nama'],
      jabatan: json['jabatan'],
      idupline: json['idupline'],
      colectorid: json['colectorid'],
      salesrepid: json['salesrepid'],
      jenisUser: json['jenis_user'],
      kodeWarna: json['kodewarna'],
      deskripsiProfile: json['deskripsiprofile'],
      mobileToken: json['mobile_token'],
      nik: json['nik'],
      namaLengkap: json['namalengkap'],
      namaPanggilan: json['namapanggilan'],
      kodeJabatan: json['kode_jabatan'],
      kodeBagian: json['kode_bagian'],
      tanggalMasukKerja: json['tanggalmasukkerja'],
      kodeDepartment: json['kode_department'],
      statusPekerja: json['statuspekerja'],
      tanggalPengangkatan: json['tanggalpengangkatan'],
      jenisKelamin: json['jeniskelamin'],
      tempatLahir: json['tempatlahir'],
      tanggalLahir: json['tanggallahir'],
      sukuBangsa: json['sukubangsa'],
      agama: json['agama'],
      golonganDarah: json['golongandarah'],
      alamatRumah: json['alamatrumah'],
      alamatRumahSementara: json['alamatrumahsementara'],
      teleponRumah: json['teleponrumah'],
      hp: json['hp'],
      email: json['email'],
      noKtp: json['noktp'],
      berlakuSampai: json['berlakusampai'],
      noKk: json['nokk'],
      dokumenKk: json['dokumenkk'],
      npwp: json['npwp'],
      dokumenNpwp: json['dokumennpwp'],
      tanggalTerdaftarNpwp: json['tanggalterdaftarnpwp'],
      tingkatPendidikan: json['tingkatpendidikan'],
      noJamsostek: json['nojamsostek'],
      dokumenJamsostek: json['dokumenjamsostek'],
      tanggalTerdaftarJamsostek: json['tanggalterdaftarjamsostek'],
      noBpjsKesehatan: json['nobpjskesehatan'],
      dokumenBpjsKesehatan: json['dokumenbpjskesehatan'],
      tanggalTerdaftarBpjsKesehatan: json['tanggalterdaftarbpjskesehatan'] ?? '',
      statusPerkawinan: json['statusperkawinan'] ?? '',
      fotoKaryawan: json['fotokaryawan'] ?? '',
      tipe: json['tipe'] ?? '',
      lokasiKantor: json['lokasi_kantor'] ?? '',
      sisaCuti: json['sisa_cuti'] ?? '',
      addedBy: json['added_by'] ?? '',
      status: json['status'] ?? '',
      kk: json['kk'] ?? '',
      bpjs: json['bpjs'] ?? '',
      ijazah: json['ijazah'] ?? '',
      kontrakKerja: json['kontrakkerja'] ?? '',
      tanggalHabisKontrakKerja: json['tanggalhabiskontrakkerja'] ?? '',
      suratPengangkatan: json['suratpengangkatan'] ?? '',
      dokumenLain1: json['dokumenlain1'] ?? '',
      dokumenLain2: json['dokumenlain2'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'PersonalID': personalID,
      'username': username,
      'password': password,
      'role': role,
      'nama': nama,
      'jabatan': jabatan,
      'idupline': idupline,
      'colectorid': colectorid,
      'salesrepid': salesrepid,
      'jenis_user': jenisUser,
      'kodewarna': kodeWarna,
      'deskripsiprofile': deskripsiProfile,
      'mobile_token': mobileToken,
      'nik': nik,
      'namalengkap': namaLengkap,
      'namapanggilan': namaPanggilan,
      'kode_jabatan': kodeJabatan,
      'kode_bagian': kodeBagian,
      'tanggalmasukkerja': tanggalMasukKerja,
      'kode_department': kodeDepartment,
      'statuspekerja': statusPekerja,
      'tanggalpengangkatan': tanggalPengangkatan,
      'jeniskelamin': jenisKelamin,
      'tempatlahir': tempatLahir,
      'tanggallahir': tanggalLahir,
      'sukubangsa': sukuBangsa,
      'agama': agama,
      'golongandarah': golonganDarah,
      'alamatrumah': alamatRumah,
      'alamatrumahsementara': alamatRumahSementara,
      'teleponrumah': teleponRumah,
      'hp': hp,
      'email': email,
      'noktp': noKtp,
      'berlakusampai': berlakuSampai,
      'nokk': noKk,
      'dokumenkk': dokumenKk,
      'npwp': npwp,
      'dokumennpwp': dokumenNpwp,
      'tanggalterdaftarnpwp': tanggalTerdaftarNpwp,
      'tingkatpendidikan': tingkatPendidikan,
      'nojamsostek': noJamsostek,
      'dokumenjamsostek': dokumenJamsostek,
      'tanggalterdaftarjamsostek': tanggalTerdaftarJamsostek,
      'nobpjskesehatan': noBpjsKesehatan,
      'dokumenbpjskesehatan': dokumenBpjsKesehatan,
    };
  }
}