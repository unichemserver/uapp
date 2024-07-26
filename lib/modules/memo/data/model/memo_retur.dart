import 'package:uapp/modules/memo/data/memo.dart';

class MemoRetur extends Memo {
  String? id;
  final String no;
  final String pic;
  final String cc;
  final String hal;
  final String tgl;
  final String cust;
  final String almtPers;
  final String upers;
  final String ualamat;
  final String ualamatGdg;
  final String upic;
  final String utelp;
  final String ualasan;
  final String utglTarik;
  final String udescBrg;
  final String userid;
  final String nmaPers;
  final String almtKntr;
  final String ndm;
  final String smh;
  final String? reqSignature;
  final String? ndmSignature;
  final String? smhSignature;
  final String status;

  MemoRetur({
    this.id,
    required this.no,
    required this.pic,
    required this.cc,
    required this.hal,
    required this.tgl,
    required this.cust,
    required this.almtPers,
    required this.upers,
    required this.ualamat,
    required this.ualamatGdg,
    required this.upic,
    required this.utelp,
    required this.ualasan,
    required this.utglTarik,
    required this.udescBrg,
    required this.userid,
    required this.nmaPers,
    required this.almtKntr,
    required this.ndm,
    required this.smh,
    required this.reqSignature,
    required this.ndmSignature,
    required this.smhSignature,
    required this.status,
  });

  factory MemoRetur.fromJson(Map<String, dynamic> json) {
    return MemoRetur(
      id: json['id'],
      no: json['no'],
      pic: json['pic'],
      cc: json['cc'],
      hal: json['hal'],
      tgl: json['tgl'],
      cust: json['cust'],
      almtPers: json['almt_pers'],
      upers: json['upers'],
      ualamat: json['ualamat'],
      ualamatGdg: json['ualamat_gdg'],
      upic: json['upic'],
      utelp: json['utelp'],
      ualasan: json['ualasan'],
      utglTarik: json['utgl_tarik'],
      udescBrg: json['udesc_brg'],
      userid: json['userid'],
      nmaPers: json['nma_pers'],
      almtKntr: json['almt_kntr'],
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
      'tabel': 'retur',
      'no': no,
      'pic': pic,
      'cc': cc,
      'hal': hal,
      'tgl': tgl,
      'cust': cust,
      'almt_pers': almtPers,
      'upers': upers,
      'ualamat': ualamat,
      'ualamat_gdg': ualamatGdg,
      'upic': upic,
      'utelp': utelp,
      'ualasan': ualasan,
      'utgl_tarik': utglTarik,
      'udesc_brg': udescBrg,
      'userid': userid,
      'nma_pers': nmaPers,
      'almt_kntr': almtKntr,
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
