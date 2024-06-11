import 'package:flutter/material.dart';
import 'package:uapp/modules/hr/model/hr_model.dart';
import 'package:uapp/modules/hr/pages/datang_terlambat/datang_terlambar_page.dart';
import 'package:uapp/modules/hr/pages/dinas_luar/dinas_luar_page.dart';
import 'package:uapp/modules/hr/pages/ijin_keluar_pulang/ijin_keluar_pulang_page.dart';
import 'package:uapp/modules/hr/pages/keluar_mobil/keluar_mobil_page.dart';
import 'package:uapp/modules/hr/pages/permintaan_naker/permintaan_naker_page.dart';
import 'package:uapp/modules/hr/pages/permintaan_naker_borongan/permintaan_naker_borongan_page.dart';
import 'package:uapp/modules/hr/pages/perubahan_status_naker/perubahan_status_naker_page.dart';
import 'package:uapp/modules/hr/pages/realisasi_lembur/realisasi_lembur_page.dart';
import 'package:uapp/modules/hr/pages/realisasi_permintaan_naker/realisasai_permintaan_naker_page.dart';
import 'package:uapp/modules/hr/pages/realisasi_permintaan_naker_borongan/realisasi_permintaan_naker_borongan_page.dart';
import 'package:uapp/modules/hr/pages/rencana_lembur/rencana_lembur_page.dart';
import 'package:uapp/modules/hr/pages/tidak_masuk/tidak_masuk_page.dart';

List<HRMenu> hrMenuList = [
  HRMenu(
    title: "Surat Ijin Tidak Masuk",
    icon: Icons.block,
    page: const TidakMasukPage(),
  ),
  HRMenu(
    title: "Form Rencana Lembur",
    icon: Icons.timer,
    page: const RencanaLemburPage(),
  ),
  HRMenu(
    title: "Tugas Dinas Luar",
    icon: Icons.work,
    page: const DinasLuarPage(),
  ),
  HRMenu(
    title: "Masuk Datang Terlambat",
    icon: Icons.access_time,
    page: const DatangTerlambatPage(),
  ),
  HRMenu(
    title: "Surat Ijin Keluar/Pulang",
    icon: Icons.exit_to_app,
    page: const IjinKeluarPulangPage(),
  ),
  HRMenu(
    title: "Surat Keluar Mobil",
    icon: Icons.departure_board,
    page: const KeluarMobilPage(),
  ),
  HRMenu(
    title: "Form Realisasi Lembur",
    icon: Icons.done,
    page: const RealisasiLemburPage(),
  ),
  HRMenu(
    title: "Form Permintaan Tenaga Kerja",
    icon: Icons.person_add,
    page: const PermintaanNakerPage(),
  ),
  HRMenu(
    title: "Form Realisasi Permintaan Tenaga Kerja",
    icon: Icons.people,
    page: const RealisasiPermintaanNakerPage(),
  ),
  HRMenu(
    title: "Form Permintaan Tenaga Kerja Borongan",
    icon: Icons.group_add,
    page: const PermintaanNakerBoronganPage(),
  ),
  HRMenu(
    title: "Form Realisasi Permintaan Tenaga Kerja Borongan",
    icon: Icons.group,
    page: const RealisasiPermintaanNakerBoronganPage(),
  ),
  HRMenu(
    title: "Form Perubahan Status Tenaga Kerja",
    icon: Icons.person,
    page: const PerubahanStatusNakerPage(),
  ),
];
