import 'package:uapp/modules/memo/data/memo.dart';

class MemoTarget extends Memo {
  String? id;
  final String no;
  final String pic;
  final String cc;
  final String hal;
  final String tgl;
  final String program;
  final String cust;
  final String area;
  final String tglMulai;
  final String tglSelesai;
  final String latarBlkg;
  final String sasaran;
  final String produk;
  final String mekanisme;
  final String hrgAwal;
  final String disc;
  final String hrgAkhir;
  final String estInRp;
  final String estInTon;
  final String estTotalBiaya;
  final String estNilaiPajak;
  final String costRatio;
  final String userid;
  final String ndm;
  final String smh;
  final String? reqSignature;
  final String? ndmSignature;
  final String? smhSignature;
  final String status;

  MemoTarget({
    this.id,
    required this.no,
    required this.pic,
    required this.cc,
    required this.hal,
    required this.tgl,
    required this.program,
    required this.cust,
    required this.area,
    required this.tglMulai,
    required this.tglSelesai,
    required this.latarBlkg,
    required this.sasaran,
    required this.produk,
    required this.mekanisme,
    required this.hrgAwal,
    required this.disc,
    required this.hrgAkhir,
    required this.estInRp,
    required this.estInTon,
    required this.estTotalBiaya,
    required this.estNilaiPajak,
    required this.costRatio,
    required this.userid,
    required this.ndm,
    required this.smh,
    required this.reqSignature,
    required this.ndmSignature,
    required this.smhSignature,
    required this.status,
  });

  factory MemoTarget.fromJson(Map<String, dynamic> json) {
    return MemoTarget(
      id: json['id'],
      no: json['no'],
      pic: json['pic'] ?? '',
      cc: json['cc'] ?? '',
      hal: json['hal'],
      tgl: json['tgl'] ?? '',
      program: json['program'],
      cust: json['cust'],
      area: json['area'],
      tglMulai: json['tgl_mulai'],
      tglSelesai: json['tgl_selesai'],
      latarBlkg: json['latar_blkg'] ?? '',
      sasaran: json['sasaran'] ?? '',
      produk: json['produk'] ?? '',
      mekanisme: json['mekanisme'] ?? '',
      hrgAwal: json['hrg_awal'] ?? '',
      disc: json['disc'] ?? '',
      hrgAkhir: json['hrg_akhir'] ?? '',
      estInRp: json['est_in_rp'] ?? '',
      estInTon: json['est_in_ton'] ?? '',
      estTotalBiaya: json['est_total_biaya'] ?? '',
      estNilaiPajak: json['est_nilai_pajak'] ?? '',
      costRatio: json['cost_ratio'] ?? '',
      userid: json['userid'] ?? '',
      ndm: json['ndm'] ?? '',
      smh: json['smh'] ?? '',
      reqSignature: json['req_signature'] ?? '',
      ndmSignature: json['ndm_signature'] ?? '',
      smhSignature: json['smh_signature'] ?? '',
      status: json['status'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    var data = {
      'action': 'memo',
      'tabel': 'target_a',
      'no': no,
      'pic': pic,
      'cc': cc,
      'hal': hal,
      'tgl': tgl,
      'program': program,
      'cust': cust,
      'area': area,
      'tgl_mulai': tglMulai,
      'tgl_selesai': tglSelesai,
      'latar_blkg': latarBlkg,
      'sasaran': sasaran,
      'produk': produk,
      'mekanisme': mekanisme,
      'hrg_awal': hrgAwal,
      'disc': disc,
      'hrg_akhir': hrgAkhir,
      'est_in_rp': estInRp,
      'est_in_ton': estInTon,
      'est_total_biaya': estTotalBiaya,
      'est_nilai_pajak': estNilaiPajak,
      'cost_ratio': costRatio,
      'userid': userid,
      'ndm': ndm,
      'smh': smh,
      'req_signature': reqSignature,
      'ndm_signature': ndmSignature,
      'smh_signature': smhSignature,
      'status': status,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}