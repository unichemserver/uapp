import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/models/hr_approval_response.dart';
import 'package:uapp/modules/home/home_controller.dart';

class HrPendingApproval extends StatelessWidget {
  const HrPendingApproval({
    super.key,
    required this.hrResponse,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final HrResponse? hrResponse;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    if (hrResponse == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final categories = [
      {
        'title': 'Surat Ijin Tidak Masuk',
        'count': hrResponse!.hrSuratIjinTidakMasuk.length,
        'icon': Icons.block,
        'data': hrResponse!.hrSuratIjinTidakMasuk,
      },
      {
        'title': 'Form Rencana Lembur',
        'count': hrResponse!.hrLaporanRencanaLembur.length,
        'icon': Icons.timer,
        'data': hrResponse!.hrLaporanRencanaLembur,
      },
      {
        'title': 'Form Realisasi Lembur',
        'count': hrResponse!.hrFormRealisasiLembur.length,
        'icon': Icons.done,
        'data': hrResponse!.hrFormRealisasiLembur,
      },
      {
        'title': 'Tugas Dinas Luar',
        'count': hrResponse!.hrTugasDinasLuar.length,
        'icon': Icons.work,
        'data': hrResponse!.hrTugasDinasLuar,
      },
      {
        'title': 'Masuk Datang Terlambat',
        'count': hrResponse!.hrMasukDatangTerlambat.length,
        'icon': Icons.access_time,
        'data': hrResponse!.hrMasukDatangTerlambat,
      },
      {
        'title': 'Surat Ijin Pulang',
        'count': hrResponse!.hrSuratIjinPulang.length,
        'icon': Icons.exit_to_app,
        'data': hrResponse!.hrSuratIjinPulang,
      },
      {
        'title': 'Surat Ijin Keluar',
        'count': hrResponse!.hrSuratIjinKeluar.length,
        'icon': Icons.logout_sharp,
        'data': hrResponse!.hrSuratIjinKeluar,
      },
      {
        'title': 'Surat Keluar Mobil',
        'count': hrResponse!.hrSuratKeluarMobil.length,
        'icon': Icons.departure_board,
        'data': hrResponse!.hrSuratKeluarMobil,
      },
      {
        'title': 'Order Reparasi',
        'count': hrResponse!.hrOrderReparasi.length,
        'icon': Icons.build,
        'data': hrResponse!.hrOrderReparasi,
      },
      {
        'title': 'Form Permintaan Tenaga Kerja',
        'count': hrResponse!.hrFormPermintaanTenagaKerja.length,
        'icon': Icons.person_add,
        'data': hrResponse!.hrFormPermintaanTenagaKerja,
      },
      {
        'title': 'Form Permintaan Tenaga Kerja Tidak Rutin',
        'count': hrResponse!.hrFormPermintaanTenagaKerjaTidakRutin.length,
        'icon': Icons.people,
        'data': hrResponse!.hrFormPermintaanTenagaKerjaTidakRutin,
      },
      {
        'title': 'Form Permintaan Tenaga Kerja Borongan',
        'count': hrResponse!.hrFormPermintaanTenagaKerjaBorongan.length,
        'icon': Icons.group_add,
        'data': hrResponse!.hrFormPermintaanTenagaKerjaBorongan,
      },
    ];

    categories.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

    return GetBuilder(
        init: HomeController(),
        initState: (_) {},
        builder: (ctx) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final dataList = category['data'] as List;
              final count = category['count'] as int;
              final title = category['title'] as String;
              final icon = category['icon'] as IconData;

              return ExpansionTile(
                title: Text(title),
                trailing: _buildCountIjin(count),
                leading: Icon(icon),
                children: dataList
                    .map((e) => CheckboxListTile(
                          title: Text(e.nama),
                          subtitle: Text(e.keterangan),
                          value: ctx.hrApprovalList.contains(e),
                          onChanged: (bool? value) {
                            if (value == true) {
                              Log.d('Add to list');
                              ctx.hrApprovalList.add(e);
                              ctx.update();
                            } else {
                              Log.d('Remove from list');
                              ctx.hrApprovalList.remove(e);
                              ctx.update();
                            }
                          },
                        ))
                    .toList(),
              );
            },
          );
        });
  }

  Container _buildCountIjin(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.blueAccent[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count.toString(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
