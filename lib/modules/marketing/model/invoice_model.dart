class BelumInvoice {
  String? transaksi;
  String? grpCustomer;
  String? group;
  String? kodeSales;
  String? namaSales;
  String? kodeCustomer;
  String? namaCustomer;
  String? tipeTransaksi;
  String? nomorInvoice;
  String? nomorFaktur;
  String? tanggalInvoice;
  String? jatuhTempo;
  String? umurPiutang;
  String? nilaiInvoice;
  String? pajak;
  String? pembayaran;
  String? sisaPiutang;

  BelumInvoice({
    this.transaksi,
    this.grpCustomer,
    this.group,
    this.kodeSales,
    this.namaSales,
    this.kodeCustomer,
    this.namaCustomer,
    this.tipeTransaksi,
    this.nomorInvoice,
    this.nomorFaktur,
    this.tanggalInvoice,
    this.jatuhTempo,
    this.umurPiutang,
    this.nilaiInvoice,
    this.pajak,
    this.pembayaran,
    this.sisaPiutang,
  });

  factory BelumInvoice.fromJson(Map<String, dynamic> map) {
    return BelumInvoice(
      transaksi: map['Transaksi'] as String?,
      grpCustomer: map['Grp_Customer'] as String?,
      group: map['Group_'] as String?,
      kodeSales: map['Kode_Sales'] as String?,
      namaSales: map['Nama_Sales'] as String?,
      kodeCustomer: map['Kode_Customer'] as String?,
      namaCustomer: map['Nama_Customer'] as String?,
      tipeTransaksi: map['Tipe_Transaksi'] as String?,
      nomorInvoice: map['Nomor_Invoice'] as String?,
      nomorFaktur: map['Nomor_Faktur'] as String?,
      tanggalInvoice: map['Tanggal_Invoice'] as String?,
      jatuhTempo: map['Jatuh_Tempo'] as String?,
      umurPiutang: map['Umur_Piutang'] as String?,
      nilaiInvoice: map['Nilai_Invoice'] as String?,
      pajak: map['Pajak'] as String?,
      pembayaran: map['Pembayaran'] as String?,
      sisaPiutang: map['Sisa_piutang'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Transaksi'] = transaksi;
    data['Grp_Customer'] = grpCustomer;
    data['Group_'] = group;
    data['Kode_Sales'] = kodeSales;
    data['Nama_Sales'] = namaSales;
    data['Kode_Customer'] = kodeCustomer;
    data['Nama_Customer'] = namaCustomer;
    data['Tipe_Transaksi'] = tipeTransaksi;
    data['Nomor_Invoice'] = nomorInvoice;
    data['Nomor_Faktur'] = nomorFaktur;
    data['Tanggal_Invoice'] = tanggalInvoice;
    data['Jatuh_Tempo'] = jatuhTempo;
    data['Umur_Piutang'] = umurPiutang;
    data['Nilai_Invoice'] = nilaiInvoice;
    data['Pajak'] = pajak;
    data['Pembayaran'] = pembayaran;
    data['Sisa_piutang'] = sisaPiutang;
    return data;
  }
}

// CREATE TABLE IF NOT EXISTS invoice (
//     Transaksi TEXT,
//     Grp_Customer TEXT,
//     Group_ TEXT,
//     Kode_Sales TEXT,
//     Nama_Sales TEXT,
//     Kode_Customer TEXT,
//     Nama_Customer TEXT,
//     Tipe_Transaksi TEXT,
//     Nomor_Invoice TEXT,
//     Nomor_Faktur TEXT,
//     Tanggal_Invoice TEXT,
//     Jatuh_Tempo TEXT,
//     Umur_Piutang TEXT,
//     Nilai_Invoice TEXT,
//     Pajak TEXT,
//     Pembayaran TEXT,
//     Sisa_piutang TEXT
//     );
