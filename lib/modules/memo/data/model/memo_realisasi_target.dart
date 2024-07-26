import 'package:uapp/modules/memo/data/memo.dart';

class MemoRealisasiTarget extends Memo {
  String? id;
  final String no;
  final String targetAId;
  final String pic;
  final String cc;
  final String hal;
  final String tgl;
  final String program;
  final String cust;
  final String area;
  final String tglMulai;
  final String tglSelesai;
  final String tercapai;
  final String persenTercapai;
  final String bayarInvoiceMax;
  final String mekanisme;
  final String potongInvoice;
  final String potongSuratJalan;
  final String potongPo;
  final String mpNoAcc;
  final String costRatio;
  final String realInRp;
  final String realInTon;
  final String disc;
  final String realTotalBiaya;
  final String realHargaJual;
  final String realCostRatio;
  final String userid;
  final String ndm;
  final String smh;
  final String reqSignature;
  final String ndmSignature;
  final String smhSignature;
  final String status;

  MemoRealisasiTarget({
    this.id,
    required this.no,
    required this.targetAId,
    required this.pic,
    required this.cc,
    required this.hal,
    required this.tgl,
    required this.program,
    required this.cust,
    required this.area,
    required this.tglMulai,
    required this.tglSelesai,
    required this.tercapai,
    required this.persenTercapai,
    required this.bayarInvoiceMax,
    required this.mekanisme,
    required this.potongInvoice,
    required this.potongSuratJalan,
    required this.potongPo,
    required this.mpNoAcc,
    required this.costRatio,
    required this.realInRp,
    required this.realInTon,
    required this.disc,
    required this.realTotalBiaya,
    required this.realHargaJual,
    required this.realCostRatio,
    required this.userid,
    required this.ndm,
    required this.smh,
    required this.reqSignature,
    required this.ndmSignature,
    required this.smhSignature,
    required this.status,
  });

  factory MemoRealisasiTarget.fromJson(Map<String, dynamic> json) {
    return MemoRealisasiTarget(
      id: json['id'],
      no: json['no'],
      targetAId: json['target_a_id'],
      pic: json['pic'],
      cc: json['cc'],
      hal: json['hal'],
      tgl: json['tgl'],
      program: json['program'],
      cust: json['cust'],
      area: json['area'],
      tglMulai: json['tgl_mulai'],
      tglSelesai: json['tgl_selesai'],
      tercapai: json['tercapai'],
      persenTercapai: json['persen_tercapai'],
      bayarInvoiceMax: json['bayar_invoice_max'],
      mekanisme: json['mekanisme'],
      potongInvoice: json['potong_invoice'],
      potongSuratJalan: json['potong_surat_jalan'],
      potongPo: json['potong_po'],
      mpNoAcc: json['mp_no_acc'],
      costRatio: json['cost_ratio'],
      realInRp: json['real_in_rp'],
      realInTon: json['real_in_ton'],
      disc: json['disc'],
      realTotalBiaya: json['real_total_biaya'],
      realHargaJual: json['real_harga_jual'],
      realCostRatio: json['real_cost_ratio'],
      userid: json['userid'],
      ndm: json['ndm'],
      smh: json['smh'],
      reqSignature: json['req_signature'],
      ndmSignature: json['ndm_signature'],
      smhSignature: json['smh_signature'],
      status: json['status'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    var data = {
      'action': 'memo',
      'tabel': 'target_b',
      'no': no,
      'target_a_id': targetAId,
      'pic': pic,
      'cc': cc,
      'hal': hal,
      'tgl': tgl,
      'program': program,
      'cust': cust,
      'area': area,
      'tgl_mulai': tglMulai,
      'tgl_selesai': tglSelesai,
      'tercapai': tercapai,
      'persen_tercapai': persenTercapai,
      'bayar_invoice_max': bayarInvoiceMax,
      'mekanisme': mekanisme,
      'potong_invoice': potongInvoice,
      'potong_surat_jalan': potongSuratJalan,
      'potong_po': potongPo,
      'mp_no_acc': mpNoAcc,
      'cost_ratio': costRatio,
      'real_in_rp': realInRp,
      'real_in_ton': realInTon,
      'disc': disc,
      'real_total_biaya': realTotalBiaya,
      'real_harga_jual': realHargaJual,
      'real_cost_ratio': realCostRatio,
      'userid': userid,
      'ndm': ndm,
      'smh': smh,
      'req_signature': reqSignature,
      'ndm_signature': ndmSignature,
      'smh_signature': smhSignature,
      'status': status,
    };
    if (id != null) {
      data['id'] = id!;
    }
    return data;
  }
}