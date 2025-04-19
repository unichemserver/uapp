import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_controller.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_options.dart';

class GeneralInformation extends StatelessWidget {
  GeneralInformation({
    super.key,
    required this.creditLimitCtrl,
    required this.topDateCtrl,
    required this.jaminanCtrl,
    required this.namaPerusahaanCtrl,
    required this.idPelangganCtrl,
    required this.areaPemasaranCtrl,
    required this.tglJoinCtrl,
    required this.supervisorNameCtrl,
    required this.asmNameCtrl,
  });

  final TextEditingController creditLimitCtrl;
  final TextEditingController topDateCtrl;
  final TextEditingController jaminanCtrl;
  final TextEditingController namaPerusahaanCtrl;
  final TextEditingController idPelangganCtrl;
  final TextEditingController areaPemasaranCtrl;
  final TextEditingController tglJoinCtrl;
  final TextEditingController supervisorNameCtrl;
  final TextEditingController asmNameCtrl;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NooController>(
      init: NooController(),
      initState: (state) {
        supervisorNameCtrl.text = Utils.getUserData().id;
      },
      builder: (ctx) {
        return ExpansionTile(
          title: const Text('Informasi Umum'),
          leading: const Icon(Icons.info),
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Group Pelanggan:',
              style: Theme.of(context).textTheme.titleSmall,
            ),            
            Wrap(
              spacing: 8,
              runSpacing: 0,
              children: ctx.customerGroups.keys.map((cluster) {
                return ChoiceChip(
                  label: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      cluster,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  selected: ctx.selectedCluster.value == cluster,
                  onSelected: (value) {
                    if (value) {
                      ctx.setSelectedCluster(cluster);
                      ctx.setSelectedNamaDesc('');
                    }
                  },
                );
              }).toList(),
            ),

            if (ctx.selectedCluster.value.isNotEmpty) 
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Pilih Nama Desc'),
                value: ctx.customerGroups[ctx.selectedCluster.value]!.contains(ctx.selectedNamaDesc.value) == true 
                    ? ctx.selectedNamaDesc.value 
                    : null,
                items: ctx.customerGroups[ctx.selectedCluster.value]!
                    .toSet()
                    .map((namaDesc) => DropdownMenuItem(
                          value: namaDesc,
                          child: Text(namaDesc),
                        ))
                    .toList(),
                onChanged: (value) {
                  ctx.setSelectedNamaDesc(value!);
                  Log.d('Selected Nama Desc: ${ctx.selectedNamaDesc.value}');
                },
              ),
            const SizedBox(height: 16),
            Text(
              'Termin Pembayaran (TOP) Pelanggan:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Obx(() {
              var items = ctx.topOptions
                  .map((item) => DropdownMenuItem<String>(
                        value: item['TOP_ID'],
                        child: Text(item['TOP_ID']),
                      ))
                  .toList();

              var selectedValue = items.any((element) => element.value == topDateCtrl.text)
                  ? topDateCtrl.text
                  : null;

              return DropdownButtonFormField<String>(
                value: selectedValue,
                items: items,
                onChanged: (value) {
                  if (value != null) {
                    Log.d('Selected TOP: $value');
                    topDateCtrl.text = value;
                    ctx.paymentMethod = value;
                    ctx.update();

                    // Hide or show inputs based on selected TOP
                    if (value == 'K00' || value == 'COD' || value == 'CIA') {
                      ctx.showCreditLimitAndJaminan(false);
                    } else {
                      ctx.showCreditLimitAndJaminan(true);
                    }
                  } else {
                    // Hide inputs if no TOP is selected
                    ctx.showCreditLimitAndJaminan(false);
                  }
                },
                hint: const Text('Pilih Termin Pembayaran'),
                icon: const Icon(Icons.calendar_today),
              );
            }),
            Obx(() {
              if (!ctx.isCreditLimitAndJaminanVisible.value) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Credit Limit (Secara Total dalam Rupiah):',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  AppTextField(
                    hintText: 'Masukan Credit Limit',
                    controller: creditLimitCtrl,
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Rp',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'OpenSans',	                        
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      var credit = int.tryParse(value.replaceAll(RegExp(r'\D'), ''));
                      if (credit != null) {
                        jaminanCtrl.text = (credit * 1.1).toInt().toString();
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Credit limit tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nilai Jaminan (Rp) : 110% dari Nominal Credit Limit:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  AppTextField(
                    hintText: 'Masukan Nilai Jaminan',
                    controller: jaminanCtrl,
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Rp',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'OpenSans',	                        
                        )
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nilai jaminan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 16),
            Text(
              'Jaminan (Khusus Distributor):',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 0,
              children: List.generate(
                NooOptions.jaminanDistributor.length,
                (index) {
                  return ChoiceChip(
                    label: Text(
                      NooOptions.jaminanDistributor[index],
                      textAlign: TextAlign.center,
                    ),
                    selected:
                        ctx.jaminan == NooOptions.jaminanDistributor[index],
                    onSelected: (value) {
                      if (value) {
                        ctx.jaminan = NooOptions.jaminanDistributor[index];
                        ctx.update();
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Nama Perusahaan (PT/CV/UD) atau Toko:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppTextField(
              hintText: 'Masukan Nama Perusahaan',
              controller: namaPerusahaanCtrl,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Nama perusahaan tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Text(
            //   'No. ID Pelanggan (Diisi oleh HO PT. UCI):',
            //   style: Theme.of(context).textTheme.titleSmall,
            // ),
            // AppTextField(
            //   hintText: 'Masukan ID Pelanggan',
            //   controller: idPelangganCtrl,
            //   validator: (value) {
            //     if (value!.isEmpty) {
            //       return 'ID Pelanggan tidak boleh kosong';
            //     }
            //     return null;
            //   },
            // ),
            // const SizedBox(height: 16),
            Text(
              'Area Pemasaran:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppTextField(
              hintText: 'Masukan Area Pemasaran',
              controller: areaPemasaranCtrl,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Area pemasaran tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Tanggal Bergabung Menjadi Pelanggan PT.UCI:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppTextField(
              hintText: 'Pilih Tanggal',
              controller: tglJoinCtrl,
              readOnly: true,
              onTap: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ).then((value) {
                  if (value != null) {
                    tglJoinCtrl.text = value.toIso8601String().split('T')[0];
                  }
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Tanggal bergabung tidak boleh kosong';
                }
                return null;
              },
            ),
            // const SizedBox(height: 16),
            // Text(
            //   'Nama ASM PT. UCI:',
            //   style: Theme.of(context).textTheme.titleSmall,
            // ),
            // AppTextField(
            //   hintText: 'Masukan Nama ASM',
            //   controller: asmNameCtrl,
            //   validator: (value) {
            //     if (value!.isEmpty) {
            //       return 'Nama ASM tidak boleh kosong';
            //     }
            //     return null;
            //   },
            // ),
          ],
        );
      },
    );
  }
}
