import 'package:uapp/modules/memo/data/memo.dart';

class MemoMarcol extends Memo {
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
  final String mekanisme;
  final String barang;
  final String qty;
  final String penerima;
  final String tglKirim;
  final String almtKirim;
  final String noKirim;
  final String alamat;
  final String userid;
  final String msm;
  final String ndm;
  final String smh;
  final String? reqSignature;
  final String? ndmSignature;
  final String? smhSignature;
  final String status;

  MemoMarcol({
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
    required this.mekanisme,
    required this.barang,
    required this.qty,
    required this.penerima,
    required this.tglKirim,
    required this.almtKirim,
    required this.noKirim,
    required this.alamat,
    required this.userid,
    required this.msm,
    required this.ndm,
    required this.smh,
    required this.reqSignature,
    required this.ndmSignature,
    required this.smhSignature,
    required this.status,
  });

  factory MemoMarcol.fromJson(Map<String, dynamic> json) {
    return MemoMarcol(
      id: json['id'],
      no: json['no'],
      pic: json['pic'],
      cc: json['cc'],
      hal: json['hal'],
      tgl: json['tgl'],
      program: json['program'],
      cust: json['cust'],
      area: json['area'],
      tglMulai: json['tgl_mulai'],
      tglSelesai: json['tgl_selesai'],
      latarBlkg: json['latar_blkg'],
      mekanisme: json['mekanisme'],
      barang: json['barang'],
      qty: json['qty'],
      penerima: json['penerima'],
      tglKirim: json['tgl_kirim'],
      almtKirim: json['almt_kirim'],
      noKirim: json['no_kirim'],
      alamat: json['alamat'],
      userid: json['userid'],
      msm: json['msm'],
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
      'tabel': 'marcol',
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
      'mekanisme': mekanisme,
      'barang': barang,
      'qty': qty,
      'penerima': penerima,
      'tgl_kirim': tglKirim,
      'almt_kirim': almtKirim,
      'no_kirim': noKirim,
      'alamat': alamat,
      'userid': userid,
      'msm': msm,
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