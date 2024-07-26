import 'package:uapp/modules/memo/data/memo.dart';

class MemoPengalihanA extends Memo {
  String? id;
  final String no;
  final String pic;
  final String cc;
  final String hal;
  final String tgl;
  final String cust;
  final String ualamat;
  final String utelpKntr;
  final String ualamatGdg;
  final String upicGdg;
  final String utelpGdg;
  final String ualasan;
  final String utglTarik;
  final String spers;
  final String spemilik;
  final String snoKtp;
  final String salmtKntr;
  final String stelp;
  final String stglTerima;
  final String salmtTerima;
  final String spenerimaGdg;
  final String stelpGdg;
  final String ssupport;
  final String sdescBrg;
  final String userid;
  final String ndm;
  final String smh;
  final String? reqSignature;
  final String? ndmSignature;
  final String? smhSignature;
  final String status;

  MemoPengalihanA({
    this.id,
    required this.no,
    required this.pic,
    required this.cc,
    required this.hal,
    required this.tgl,
    required this.cust,
    required this.ualamat,
    required this.utelpKntr,
    required this.ualamatGdg,
    required this.upicGdg,
    required this.utelpGdg,
    required this.ualasan,
    required this.utglTarik,
    required this.spers,
    required this.spemilik,
    required this.snoKtp,
    required this.salmtKntr,
    required this.stelp,
    required this.stglTerima,
    required this.salmtTerima,
    required this.spenerimaGdg,
    required this.stelpGdg,
    required this.ssupport,
    required this.sdescBrg,
    required this.userid,
    required this.ndm,
    required this.smh,
    required this.reqSignature,
    required this.ndmSignature,
    required this.smhSignature,
    required this.status,
  });

  factory MemoPengalihanA.fromJson(Map<String, dynamic> json) {
    return MemoPengalihanA(
      id: json['id'],
      no: json['no'],
      pic: json['pic'],
      cc: json['cc'],
      hal: json['hal'],
      tgl: json['tgl'],
      cust: json['cust'],
      ualamat: json['ualamat'],
      utelpKntr: json['utelp_kntr'],
      ualamatGdg: json['ualamat_gdg'],
      upicGdg: json['upic_gdg'],
      utelpGdg: json['utelp_gdg'],
      ualasan: json['ualasan'],
      utglTarik: json['utgl_tarik'],
      spers: json['spers'],
      spemilik: json['spemilik'],
      snoKtp: json['sno_ktp'],
      salmtKntr: json['salmt_kntr'],
      stelp: json['stelp'],
      stglTerima: json['stgl_terima'],
      salmtTerima: json['salmt_terima'],
      spenerimaGdg: json['spenerima_gdg'],
      stelpGdg: json['stelp_gdg'],
      ssupport: json['ssupport'],
      sdescBrg: json['sdesc_brg'],
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
      'tabel': 'pengalihan_a',
      'no': no,
      'pic': pic,
      'cc': cc,
      'hal': hal,
      'tgl': tgl,
      'cust': cust,
      'ualamat': ualamat,
      'utelp_kntr': utelpKntr,
      'ualamat_gdg': ualamatGdg,
      'upic_gdg': upicGdg,
      'utelp_gdg': utelpGdg,
      'ualasan': ualasan,
      'utgl_tarik': utglTarik,
      'spers': spers,
      'spemilik': spemilik,
      'sno_ktp': snoKtp,
      'salmt_kntr': salmtKntr,
      'stelp': stelp,
      'stgl_terima': stglTerima,
      'salmt_terima': salmtTerima,
      'spenerima_gdg': spenerimaGdg,
      'stelp_gdg': stelpGdg,
      'ssupport': ssupport,
      'sdesc_brg': sdescBrg,
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