import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_controller.dart';
import 'package:uapp/modules/marketing/widget/image_picker_widget.dart';

class DocForm extends StatelessWidget {
  const DocForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NooController>(
        init: NooController(),
        initState: (_) {},
        builder: (ctx) {
          return ListView(
            children: [
              ExpansionTile(
                title: const Text('Foto/Scan KTP'),
                children: [
                  ImagePickerWidget(
                    imagePath: ctx.ktpPath,
                    onImagePicked: (path) {
                      ctx.ktpPath = path;
                      ctx.updateDocument({'ktp': path});
                      ctx.update();
                    },
                    onImageRemoved: () {
                      ctx.ktpPath = '';
                      ctx.deleteDocument('ktp');
                      ctx.update();
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('Foto/Scan NPWP'),
                children: [
                  ImagePickerWidget(
                    imagePath: ctx.npwpPath,
                    onImagePicked: (path) {
                      ctx.npwpPath = path;
                      ctx.updateDocument({'npwp': path});
                      ctx.update();
                    },
                    onImageRemoved: () {
                      ctx.npwpPath = '';
                      ctx.deleteDocument('npwp');
                      ctx.update();
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text(
                  'Foto Owner dengan PIC Marketing, Foto Outlet, Foto Gudang, dll',
                ),
                children: [
                  ImagePickerWidget(
                    imagePath: ctx.ownerPicPath,
                    onImagePicked: (path) {
                      ctx.ownerPicPath = path;
                      ctx.updateDocument({'owner_pic': path});
                      ctx.update();
                    },
                    onImageRemoved: () {
                      ctx.ownerPicPath = '';
                      ctx.deleteDocument('owner_pic');
                      ctx.update();
                    },
                  ),
                  ImagePickerWidget(
                    imagePath: ctx.outletPath,
                    onImagePicked: (path) {
                      ctx.outletPath = path;
                      ctx.updateDocument({'outlet': path});
                      ctx.update();
                    },
                    onImageRemoved: () {
                      ctx.outletPath = '';
                      ctx.deleteDocument('outlet');
                      ctx.update();
                    },
                  ),
                  ImagePickerWidget(
                    imagePath: ctx.warehousePath,
                    onImagePicked: (path) {
                      ctx.warehousePath = path;
                      ctx.updateDocument({'warehouse': path});
                      ctx.update();
                    },
                    onImageRemoved: () {
                      ctx.warehousePath = '';
                      ctx.deleteDocument('warehouse');
                      ctx.update();
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('Foto/Scan SIUP/NIB'),
                children: [
                  ImagePickerWidget(
                    imagePath: ctx.siupPath,
                    onImagePicked: (path) {
                      ctx.siupPath = path;
                      ctx.updateDocument({'siup': path});
                      ctx.update();
                    },
                    onImageRemoved: () {
                      ctx.siupPath = '';
                      ctx.deleteDocument('siup');
                      ctx.update();
                    },
                  ),
                ],
              ),
              
              ExpansionTile(
                title: const Text('Surat Perjanjian Kerjasama'),
                children: [
                  ImagePickerWidget(
                    imagePath: ctx.suratKerjasamaPath,
                    onImagePicked: (path) {
                      ctx.suratKerjasamaPath = path;
                      ctx.updateDocument({'surat_kerjasama': path});
                      ctx.update();
                    },
                    onImageRemoved: () {
                      ctx.suratKerjasamaPath = '';
                      ctx.deleteDocument('surat_kerjasama');
                      ctx.update();
                    },
                  ),
                ],
              ),
              // ExpansionTile(
              //   title: const Text('Surat Penunjukan Distributor'),
              //   children: [
              //     ImagePickerWidget(
              //       imagePath: ctx.suratDistributorPath,
              //       onImagePicked: (path) {
              //         ctx.suratDistributorPath = path;
              //         ctx.updateDocument(
              //             {'surat_penunjukan_distributor': path});
              //         ctx.update();
              //       },
              //       onImageRemoved: () {
              //         ctx.suratDistributorPath = '';
              //         ctx.deleteDocument('surat_penunjukan_distributor');
              //         ctx.update();
              //       },
              //     ),
              //   ],
              // ),
              // ExpansionTile(
              //   title: const Text('Surat Domisili Usaha'),
              //   children: [
              //     ImagePickerWidget(
              //       imagePath: ctx.suratDomisiliUsahaPath,
              //       onImagePicked: (path) {
              //         ctx.suratDomisiliUsahaPath = path;
              //         ctx.updateDocument({'surat_domisili_usaha': path});
              //         ctx.update();
              //       },
              //       onImageRemoved: () {
              //         ctx.suratDomisiliUsahaPath = '';
              //         ctx.deleteDocument('surat_domisili_usaha');
              //         ctx.update();
              //       },
              //     ),
              //   ],
              // ),
              // ExpansionTile(
              //   title: const Text(
              //     'Surat Pengantar Penerbitan Bank Garansi (BF)',
              //   ),
              //   children: [
              //     ImagePickerWidget(
              //       imagePath: ctx.suratPenerbitanBankPath,
              //       onImagePicked: (path) {
              //         ctx.suratPenerbitanBankPath = path;
              //         ctx.updateDocument({'surat_penerbitan_bank': path});
              //         ctx.update();
              //       },
              //       onImageRemoved: () {
              //         ctx.suratPenerbitanBankPath = '';
              //         ctx.deleteDocument('surat_penerbitan_bank');
              //         ctx.update();
              //       },
              //     ),
              //   ],
              // ),
              // ExpansionTile(
              //   title: const Text('Bank Garansi (Asli)'),
              //   children: [
              //     ImagePickerWidget(
              //       imagePath: ctx.suratBankGaransiPath,
              //       onImagePicked: (path) {
              //         ctx.suratBankGaransiPath = path;
              //         ctx.updateDocument({'surat_bank_garansi': path});
              //         ctx.update();
              //       },
              //       onImageRemoved: () {
              //         ctx.suratBankGaransiPath = '';
              //         ctx.deleteDocument('surat_bank_garansi');
              //         ctx.update();
              //       },
              //     ),
              //   ],
              // ),
              // ExpansionTile(
              //   title: const Text('Akta Pendirian'),
              //   children: [
              //     ImagePickerWidget(
              //       imagePath: ctx.aktaPendirianPath,
              //       onImagePicked: (path) {
              //         ctx.aktaPendirianPath = path;
              //         ctx.updateDocument({'akta_pendirian': path});
              //         ctx.update();
              //       },
              //       onImageRemoved: () {
              //         ctx.aktaPendirianPath = '';
              //         ctx.deleteDocument('akta_pendirian');
              //         ctx.update();
              //       },
              //     ),
              //   ],
              // ),
              // ExpansionTile(
              //   title: const Text('Company Profile'),
              //   children: [
              //     ImagePickerWidget(
              //       imagePath: ctx.companyProfilePath,
              //       onImagePicked: (path) {
              //         ctx.companyProfilePath = path;
              //         ctx.updateDocument({'company_profile': path});
              //         ctx.update();
              //       },
              //       onImageRemoved: () {
              //         ctx.companyProfilePath = '';
              //         ctx.deleteDocument('company_profile');
              //         ctx.update();
              //       },
              //     ),
              //   ],
              // ),
            ],
          );
        });
  }
}
