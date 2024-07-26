import 'package:uapp/modules/memo/data/memo.dart';

class MemoBarangRusak extends Memo {
  String? id;
  final String no;
  final String pic;
  final String cc;
  final String hal;
  final String tgl;
  final String cust;
  final String frm;
  final String subject;
  final String fileNo;
  final String tglB;
  final String sheetNo;
  final String pesan;
  final String userid;
  final String ndm;
  final String smh;
  final String? reqSignature;
  final String? ndmSignature;
  final String? smhSignature;
  final String status;

  MemoBarangRusak({
    this.id,
    required this.no,
    required this.pic,
    required this.cc,
    required this.hal,
    required this.tgl,
    required this.cust,
    required this.frm,
    required this.subject,
    required this.fileNo,
    required this.tglB,
    required this.sheetNo,
    required this.pesan,
    required this.userid,
    required this.ndm,
    required this.smh,
    required this.reqSignature,
    required this.ndmSignature,
    required this.smhSignature,
    required this.status,
  });

  factory MemoBarangRusak.fromJson(Map<String, dynamic> json) {
    return MemoBarangRusak(
      id: json['id'],
      no: json['no'],
      pic: json['pic'],
      cc: json['cc'],
      hal: json['hal'],
      tgl: json['tgl'],
      cust: json['cust'],
      frm: json['frm'],
      subject: json['subject'],
      fileNo: json['file_no'],
      tglB: json['tgl_b'],
      sheetNo: json['sheet_no'],
      pesan: json['pesan'],
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
      'tabel': 'barang_rusak',
      'no': no,
      'pic': pic,
      'cc': cc,
      'hal': hal,
      'tgl': tgl,
      'cust': cust,
      'frm': frm,
      'subject': subject,
      'file_no': fileNo,
      'tgl_b': tglB,
      'sheet_no': sheetNo,
      'pesan': pesan,
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