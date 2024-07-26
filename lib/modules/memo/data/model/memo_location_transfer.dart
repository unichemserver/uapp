import 'package:uapp/modules/memo/data/memo.dart';

class MemoLocationTransfer extends Memo {
  String? id;
  final String no;
  final String pic;
  final String cc;
  final String hal;
  final String tgl;
  final String ltgl;
  final String cust;
  final String lreq;
  final String lgdgKirim;
  final String lgdgTerima;
  final String ldescBrg;
  final String userid;
  final String ndm;
  final String smh;
  final String? reqSignature;
  final String? ndmSignature;
  final String? smhSignature;
  final String status;

  MemoLocationTransfer({
    this.id,
    required this.no,
    required this.pic,
    required this.cc,
    required this.hal,
    required this.tgl,
    required this.ltgl,
    required this.cust,
    required this.lreq,
    required this.lgdgKirim,
    required this.lgdgTerima,
    required this.ldescBrg,
    required this.userid,
    required this.ndm,
    required this.smh,
    required this.reqSignature,
    required this.ndmSignature,
    required this.smhSignature,
    required this.status,
  });

  factory MemoLocationTransfer.fromJson(Map<String, dynamic> json) {
    return MemoLocationTransfer(
      id: json['id'],
      no: json['no'],
      pic: json['pic'],
      cc: json['cc'],
      hal: json['hal'],
      tgl: json['tgl'],
      ltgl: json['ltgl'],
      cust: json['cust'],
      lreq: json['lreq'],
      lgdgKirim: json['lgdg_kirim'],
      lgdgTerima: json['lgdg_terima'],
      ldescBrg: json['ldesc_brg'],
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
      'tabel': 'location_transfer',
      'no': no,
      'pic': pic,
      'cc': cc,
      'hal': hal,
      'tgl': tgl,
      'ltgl': ltgl,
      'cust': cust,
      'lreq': lreq,
      'lgdg_kirim': lgdgKirim,
      'lgdg_terima': lgdgTerima,
      'ldesc_brg': ldescBrg,
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