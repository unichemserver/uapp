import 'package:uapp/modules/memo/data/memo.dart';
import 'package:uapp/modules/memo/data/model/memo_accounting.dart';
import 'package:uapp/modules/memo/data/model/memo_barang_rusak.dart';
import 'package:uapp/modules/memo/data/model/memo_khusus.dart';
import 'package:uapp/modules/memo/data/model/memo_koordinasi.dart';
import 'package:uapp/modules/memo/data/model/memo_location_transfer.dart';
import 'package:uapp/modules/memo/data/model/memo_marcol.dart';
import 'package:uapp/modules/memo/data/model/memo_pengalihan_a.dart';
import 'package:uapp/modules/memo/data/model/memo_regular.dart';
import 'package:uapp/modules/memo/data/model/memo_retur.dart';
import 'package:uapp/modules/memo/data/model/memo_sample.dart';
import 'package:uapp/modules/memo/data/model/memo_target.dart';

class HistoryMemo {
  final List<MemoRegular> regular;
  final List<MemoTarget> targetA;
  final List<dynamic> targetB;
  final List<MemoRetur> retur;
  final List<MemoPengalihanA> pengalihanA;
  final List<MemoMarcol> marcol;
  final List<MemoKhusus> khusus;
  final List<MemoSample> sample;
  final List<MemoLocationTransfer> locationTransfer;
  final List<MemoAccounting> accounting;
  final List<MemoKoordinasi> koordinasi;
  final List<MemoBarangRusak> barangRusak;

  HistoryMemo({
    required this.regular,
    required this.targetA,
    required this.targetB,
    required this.retur,
    required this.pengalihanA,
    required this.marcol,
    required this.khusus,
    required this.sample,
    required this.locationTransfer,
    required this.accounting,
    required this.koordinasi,
    required this.barangRusak,
  });

  factory HistoryMemo.fromJson(Map<String, dynamic> json) {
    return HistoryMemo(
      regular: json['regular'] != null ? (json['regular'] as List).map((i) => MemoRegular.fromJson(i)).toList() : [],
      targetA: json['target_a'] != null ? (json['target_a'] as List).map((i) => MemoTarget.fromJson(i)).toList() : [],
      targetB: json['target_b'],
      retur: json['retur'] != null ? (json['retur'] as List).map((i) => MemoRetur.fromJson(i)).toList() : [],
      pengalihanA: json['pengalihan_a'] != null ? (json['pengalihan_a'] as List).map((i) => MemoPengalihanA.fromJson(i)).toList() : [],
      marcol: json['marcol'] != null ? (json['marcol'] as List).map((i) => MemoMarcol.fromJson(i)).toList() : [],
      khusus: json['khusus'] != null ? (json['khusus'] as List).map((i) => MemoKhusus.fromJson(i)).toList() : [],
      sample: json['sample'] != null ? (json['sample'] as List).map((i) => MemoSample.fromJson(i)).toList() : [],
      locationTransfer: json['location_transfer'] != null ? (json['location_transfer'] as List).map((i) => MemoLocationTransfer.fromJson(i)).toList() : [],
      accounting: json['accounting'] != null ? (json['accounting'] as List).map((i) => MemoAccounting.fromJson(i)).toList() : [],
      koordinasi: json['koordinasi'] != null ? (json['koordinasi'] as List).map((i) => MemoKoordinasi.fromJson(i)).toList() : [],
      barangRusak: json['barang_rusak'] != null ? (json['barang_rusak'] as List).map((i) => MemoBarangRusak.fromJson(i)).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'regular': regular,
      'target_a': targetA,
      'target_b': targetB,
      'retur': retur,
      'pengalihan_a': pengalihanA,
      'marcol': marcol,
      'khusus': khusus,
      'sample': sample,
      'location_transfer': locationTransfer,
      'accounting': accounting,
      'koordinasi': koordinasi,
      'barang_rusak': barangRusak,
    };
  }
}