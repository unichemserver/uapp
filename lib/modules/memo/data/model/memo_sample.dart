import 'package:uapp/modules/memo/data/memo.dart';

class MemoSample extends Memo {
  String? id;
  final String no;
  final String pic;
  final String cc;
  final String hal;
  final String tgl;
  final String cust;
  final String almtKirim;
  final String penerima;
  final String telp;
  final String descBrg;
  final String userid;
  final String ndm;
  final String smh;
  final String? reqSignature;
  final String? ndmSignature;
  final String? smhSignature;
  final String status;

  MemoSample({
    this.id,
    required this.no,
    required this.pic,
    required this.cc,
    required this.hal,
    required this.tgl,
    required this.cust,
    required this.almtKirim,
    required this.penerima,
    required this.telp,
    required this.descBrg,
    required this.userid,
    required this.ndm,
    required this.smh,
    required this.reqSignature,
    required this.ndmSignature,
    required this.smhSignature,
    required this.status,
});

  factory MemoSample.fromJson(Map<String, dynamic> json) {
    return MemoSample(
      id: json['id'],
      no: json['no'],
      pic: json['pic'],
      cc: json['cc'],
      hal: json['hal'],
      tgl: json['tgl'],
      cust: json['cust'],
      almtKirim: json['almt_kirim'],
      penerima: json['penerima'],
      telp: json['telp'],
      descBrg: json['desc_brg'],
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
      'tabel': 'sample',
      'no': no,
      'pic': pic,
      'cc': cc,
      'hal': hal,
      'tgl': tgl,
      'cust': cust,
      'almt_kirim': almtKirim,
      'penerima': penerima,
      'telp': telp,
      'desc_brg': descBrg,
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