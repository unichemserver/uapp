import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remove_bg/remove_bg.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/app/strings.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/id_card_image.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/core/widget/profile_image.dart';
import 'package:uapp/models/profile.dart';
import 'package:uapp/modules/profile/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              // IconButton(
              //   icon: const Icon(Icons.settings),
              //   onPressed: () {
              //     Get.toNamed(Routes.SETTING);
              //   },
              // ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Keluar'),
                      content: const Text(
                        'Apakah anda yakin ingin keluar dari aplikasi U-APP?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            Get.dialog(
                              const LoadingDialog(
                                message: 'Keluar...',
                              ),
                              barrierDismissible: false,
                            );
                            ctx.logout();
                          },
                          child: const Text('Keluar'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Hero(
                        tag: 'profile_photo',
                        child: ProfileImage(
                          imgUrl: ctx.profilePicture!,
                          radius: 200.0,
                        ),
                      ),
                    ),
                    Text(
                      ctx.userData!.nama,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ctx.userData!.namaJabatan,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      ctx.userData!.namaDepartment,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      ctx.userData!.namaBagian,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              _buildProfileBody(ctx.profile),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (Utils.fotoKaryawan() == null) {
                Get.dialog(
                  const LoadingDialog(
                    message: 'Membuat ID Card...',
                  ),
                );
                var url =
                    'https://unichem.co.id/EDS/upload/dokumenkaryawan/Foto_Karyawan/${ctx.userData!.foto}';
                var fileDownloaded = await ctx.downloadProfilePicture(url);
                var documentDirectory =
                    await getApplicationDocumentsDirectory();
                var firstPath = "${documentDirectory.path}/images";
                var filePathAndName =
                    '${documentDirectory.path}/images/profile.jpg';
                await Directory(firstPath).create(recursive: true);
                File file2 = File(filePathAndName);
                file2.writeAsBytesSync(fileDownloaded!);
                Uint8List? data = await Remove().bg(
                  file2,
                  privateKey: Strings.removeBgAPIKey,
                  onUploadProgressCallback: print,
                );
                Utils.saveFotoKaryawan(data!);
                Get.back();
              }
              Get.to(
                () => IdCard(
                  name: ctx.userData!.nama,
                  jobTitle: ctx.userData!.namaJabatan,
                  photoUrl: Utils.fotoKaryawan()!,
                  qrUrl:
                      'https://unichem.co.id/EDS//qrcode/profile/${ctx.userData!.id}.png',
                  nik: ctx.userData!.id,
                  department: ctx.userData!.namaDepartment,
                ),
              );
            },
            child: const Icon(Icons.qr_code),
          ),
        );
      },
    );
  }

  _buildProfileBody(Profile? profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          title: const Text(
            'Data Karyawan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: profile == null
              ? [const CircularProgressIndicator()]
              : [
                  _buildProfileItem(
                      'Nama Panggilan', profile.namaPanggilan ?? ''),
                  _buildProfileItem(
                      'Tanggal Masuk Kerja', profile.tanggalMasukKerja ?? ''),
                  _buildProfileItem(
                      'Status Kerja', profile.statusPekerja ?? ''),
                  _buildProfileItem('Tanggal Pengangkatan',
                      profile.tanggalPengangkatan ?? ''),
                  _buildProfileItem('Tanggal Habis Kontrak Kerja',
                      profile.tanggalHabisKontrakKerja ?? ''),
                  _buildProfileItem(
                      'Jenis Kelamin', profile.jenisKelamin ?? ''),
                  _buildProfileItem('Tempat Tanggal Lahir',
                      '${profile.tempatLahir}, ${profile.tanggalLahir}'),
                  _buildProfileItem('Suku Bangsa', profile.sukuBangsa ?? ''),
                  _buildProfileItem('Agama', profile.agama ?? ''),
                  _buildProfileItem(
                      'Golongan Darah', profile.golonganDarah ?? ''),
                  _buildProfileItem(
                      'Status Perkawinan', profile.statusPerkawinan ?? ''),
                  _buildProfileItem('Tipe', profile.tipe ?? ''),
                ],
        ),
        ExpansionTile(
          title: const Text(
            'Dokumen Karyawan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: profile == null
              ? [const CircularProgressIndicator()]
              : [
                  _buildProfileItem('No KTP', profile.noKtp ?? ''),
                  _buildProfileItem(
                      'Berlaku Sampai', profile.berlakuSampai ?? ''),
                  _buildProfileItem('No KK', profile.noKk ?? ''),
                  _buildProfileItem('No NPWP', profile.npwp ?? ''),
                  _buildProfileItem('Tanggal Terdaftar NPWP',
                      profile.tanggalTerdaftarNpwp ?? ''),
                  _buildProfileItem('No Jamsostek', profile.noJamsostek ?? ''),
                  _buildProfileItem('Tanggal Terdaftar Jamsostek',
                      profile.tanggalTerdaftarJamsostek ?? ''),
                  _buildProfileItem(
                      'No BPJS Kesehatan', profile.noBpjsKesehatan ?? ''),
                  _buildProfileItem('Tanggal Terdaftar BPJS Kesehatan',
                      profile.tanggalTerdaftarBpjsKesehatan ?? ''),
                ],
        ),
        ExpansionTile(
          title: const Text(
            'Attachment',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: profile == null
              ? [const CircularProgressIndicator()]
              : [
                  _buildProfileItem(
                    'Kontrak Kerja',
                    profile.kontrakKerja ?? '',
                    isImage: true,
                  ),
                  _buildProfileItem(
                    'KK',
                    profile.kk ?? '',
                    isImage: true,
                  ),
                  _buildProfileItem(
                    'NPWP',
                    profile.npwp ?? '',
                    isImage: true,
                  ),
                  _buildProfileItem(
                    'Ijazah',
                    profile.ijazah ?? '',
                    isImage: true,
                  ),
                  _buildProfileItem(
                    'Foto Karyawan',
                    profile.fotoKaryawan ?? '',
                    isImage: true,
                  ),
                ],
        ),
      ],
    );
  }

  String _getImageUrl(String? url, String type) {
    type = type.replaceAll(' ', '_');
    if (Utils.getBaseUrl().contains('unichem')) {
      return 'https://unichem.co.id/EDS//upload/dokumenkaryawan/$type/$url';
    } else {
      return 'https://unifood.id/EDS//upload/dokumenkaryawan/$type/$url';
    }
  }

  _buildProfileItem(
    String title,
    String value, {
    bool isImage = false,
  }) {
    return ListTile(
      leading: isImage ? const Icon(Icons.image) : null,
      onTap: () {
        if (isImage) {
          Get.dialog(
            Dialog(
              child: InteractiveViewer(
                minScale: 0.1,
                maxScale: 4.0,
                child: CachedNetworkImage(
                  imageUrl: _getImageUrl(value, title),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        }
      },
      title: Text(title),
      subtitle: isImage ? null : Text(value),
    );
  }
}
