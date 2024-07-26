import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/memo/data/model/history_memo.dart';
import 'package:uapp/modules/memo/page/create/accounting_memo.dart';
import 'package:uapp/modules/memo/page/create/barang_memo.dart';
import 'package:uapp/modules/memo/page/create/khusus_memo.dart';
import 'package:uapp/modules/memo/page/create/koordinasi_memo.dart';
import 'package:uapp/modules/memo/page/create/location_transfer_memo.dart';
import 'package:uapp/modules/memo/page/create/marketing_collateral_memo.dart';
import 'package:uapp/modules/memo/page/create/pengalihan_memo.dart';
import 'package:uapp/modules/memo/page/create/realisasi_target_memo.dart';
import 'package:uapp/modules/memo/page/create/regular_memo.dart';
import 'package:uapp/modules/memo/page/create/retur_memo.dart';
import 'package:uapp/modules/memo/page/create/sample_memo.dart';
import 'package:uapp/modules/memo/page/create/target_memo.dart';

List<MemoIcon> createdMemoList = [
  MemoIcon(
    'REGULAR',
    Icons.description,
    RegularMemo(),
    'RGR',
  ),
  MemoIcon(
    'TARGET',
    Icons.flag,
    const TargetMemo(),
    'TGA',
  ),
  MemoIcon(
    'REALISASI TARGET',
    Icons.done,
    const RealisasiTargetMemo(),
    'TGB',
  ),
  MemoIcon(
    'RETUR',
    Icons.undo,
    const ReturMemo(),
    'RTR',
  ),
  MemoIcon(
    'PENGALIHAN',
    Icons.shuffle,
    const PengalihanMemo(),
    'PGL',
  ),
  MemoIcon(
    'MARKETING COLLATERAL',
    Icons.library_books,
    const MarketingCollateralMemo(),
    'MRL',
  ),
  MemoIcon(
    'KHUSUS',
    Icons.star,
    const KhususMemo(),
    'KHS',
  ),
  MemoIcon(
    'SAMPLE',
    Icons.local_offer,
    const SampleMemo(),
    'SPL',
  ),
  MemoIcon(
    'LOCATION TRANSFER',
    Icons.location_on,
    const LocationTransferMemo(),
    'LCT',
  ),
  MemoIcon(
    'ACCOUNTING',
    Icons.account_balance,
    const AccountingMemo(),
    'ACC',
  ),
  MemoIcon(
    'KOORDINASI',
    Icons.people,
    const KoordinasiMemo(),
    'KOR',
  ),
  MemoIcon(
    'BARANG RUSAK / KURANG BARANG',
    Icons.warning,
    const BarangMemo(),
    'BRK',
  ),
];

List<String> officeAddress = ['Gresik', 'Sidoarjo'];

String generateNoMemo(String memoType) {
  // example DRAFT/RGR/STI/JUL/2024
  var draft = 'DRAFT';
  var memoTypeCode = memoType;
  var department = Utils.getUserData().department;
  var now = DateTime.now();
  var monthCode = DateFormat('MMM').format(now).toUpperCase();
  var year = DateFormat('yyyy').format(now);
  return '$draft/$memoTypeCode/$department/$monthCode/$year';
}

class MemoIcon {
  final String name;
  final IconData icon;
  final Widget page;
  final String no;

  MemoIcon(this.name, this.icon, this.page, this.no);
}

class MemoAct {
  static const String create = 'create';
  static const String approval = 'approval';
  static const String received = 'received';
}

String getMemoCount(HistoryMemo historyMemo, String memoNo) {
    switch (memoNo) {
      case 'RGR':
        return historyMemo.regular.length.toString();
      case 'TGA':
        return historyMemo.targetA.length.toString();
      case 'TGB':
        return historyMemo.targetB.length.toString();
      case 'RTR':
        return historyMemo.retur.length.toString();
      case 'PGL':
        return historyMemo.pengalihanA.length.toString();
      case 'MRL':
        return historyMemo.marcol.length.toString();
      case 'KHS':
        return historyMemo.khusus.length.toString();
      case 'KOR':
        return historyMemo.koordinasi.length.toString();
      case 'LCT':
        return historyMemo.locationTransfer.length.toString();
      case 'ACC':
        return historyMemo.accounting.length.toString();
      case 'BRG':
        return historyMemo.barangRusak.length.toString();
      case 'SMP':
        return historyMemo.sample.length.toString();
      default:
        return '0';
    }
  }
