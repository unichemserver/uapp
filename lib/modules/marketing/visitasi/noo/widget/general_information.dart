import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      initState: (state) {},
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

            
            // Wrap(
            //   spacing: 8,
            //   runSpacing: 0,
            //   children: List.generate(
            //     NooOptions.custGroup.length,
            //     (index) {
            //       return ChoiceChip(
            //         label: SizedBox(
            //           width: MediaQuery.of(context).size.width * 0.3,
            //           child: Text(
            //             NooOptions.custGroup[index],
            //             textAlign: TextAlign.center,
            //           ),
            //         ),
            //         selected: ctx.groupPelanggan == NooOptions.custGroup[index],
            //         onSelected: (value) {
            //           if (value) {
            //             ctx.groupPelanggan = NooOptions.custGroup[index];
            //             ctx.update();
            //           }
            //         },
            //       );
            //     },
            //   ),
            // ),
            // if (ctx.groupPelanggan.isNotEmpty)
            //   DropdownButtonFormField<String>(
            //     decoration: InputDecoration(labelText: 'Pilih Pelanggan'),
            //     items: NooOptions.custGroup
            //         .map((cluster) => DropdownMenuItem(
            //               value: cluster,
            //               child: Text(cluster),
            //             ))
            //         .toList(),
            //     onChanged: (value) {
            //       ctx.groupPelanggan = value!;
                  
            //     },
            //   ),


            Wrap(
              spacing: 8,
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
                    if (value) ctx.setSelectedCluster(cluster);
                  },
                );
              }).toList(),
            ),
            if (ctx.selectedCluster.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Pilih Nama Desc'),
                value: ctx.selectedNamaDesc.value,
                items: ctx.customerGroups[ctx.selectedCluster]!
                    .map((namaDesc) => DropdownMenuItem(
                          value: namaDesc,
                          child: Text(namaDesc),
                        ))
                    .toList(),
                onChanged: (value) {
                  ctx.setSelectedNamaDesc(value!);
                },
              ),
            // ElevatedButton(
            //   onPressed: () {
            //     if (ctx.selectedNamaDesc.value.isNotEmpty) {
            //       ctx.saveData(Value()); // Langsung simpan ke DB
            //     } else {
            //       Get.snackbar('Error', 'Silakan pilih Nama Desc sebelum menyimpan.');
            //     }
            //   },
            //   child: const Text('Simpan Data')
            // ),
          
            const SizedBox(height: 16),
            Text(
              'Credit Limit (Secara Total dalam Rupiah):',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppTextField(
              controller: creditLimitCtrl,
              prefixIcon: Container(
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Rp',
                  style: TextStyle(fontSize: 20),
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
              'Metode Pembayaran Pelanggan:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 0,
              children: List.generate(
                NooOptions.paymentMethod.length,
                (index) {
                  return ChoiceChip(
                    label: Row(
                      children: [
                        Text(
                          NooOptions.paymentMethod[index],
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    selected:
                        ctx.paymentMethod == NooOptions.paymentMethod[index],
                    onSelected: (value) {
                      if (value) {
                        ctx.paymentMethod = NooOptions.paymentMethod[index];
                        ctx.update();
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Termin Pembayaran (TOP) dari Tanggal Surat Jalan:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: topDateCtrl,
                    prefixIcon: const Icon(Icons.calendar_today),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Termin pembayaran tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Hari',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
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
              'Nilai Jaminan (Rp) : 110% dari Nominal Credit Limit:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppTextField(
              controller: jaminanCtrl,
              prefixIcon: Container(
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Rp',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Nilai jaminan tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Nama Perusahaan (PT/CV/UD) atau Toko:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppTextField(
              controller: namaPerusahaanCtrl,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Nama perusahaan tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              'No. ID Pelanggan (Diisi oleh HO PT. UCI):',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppTextField(
              controller: idPelangganCtrl,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'ID Pelanggan tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Area Pemasaran:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppTextField(
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
            const SizedBox(height: 16),
            Text(
              'Nama Supervisor PT. UCI:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppTextField(
              controller: supervisorNameCtrl,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Nama Supervisor tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Nama ASM PT. UCI:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppTextField(
              controller: asmNameCtrl,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Nama ASM tidak boleh kosong';
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }
}
