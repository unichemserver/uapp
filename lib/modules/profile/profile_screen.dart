import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remove_bg/remove_bg.dart';
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
    final theme = Theme.of(context);
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            title: const Text(
              'Profile',
               style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                  fontSize: 18,
                ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: const Text('Keluar'),
                      content: const Text(
                        'Apakah anda yakin ingin keluar dari aplikasi U-APP?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            'Batal',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        ElevatedButton(
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Keluar'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          body: ctx.userData == null
              ? const Center(child: CircularProgressIndicator())
              : _buildBody(context, ctx),
          floatingActionButton: FloatingActionButton.extended(
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
            icon: const Icon(Icons.qr_code),
            label: const Text('ID Card'),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProfileController ctx) {
    // final theme = Theme.of(context);
    
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(context, ctx),
          const SizedBox(height: 24),
          _buildProfileBody(context, ctx.profile),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileController ctx) {
    // final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Hero(
            tag: 'profile_photo',
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
              ),
              child: ClipOval(
                child: ProfileImage(
                  imgUrl: ctx.profilePicture!,
                  radius: 120.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            ctx.userData!.nama,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2D3748).withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              ctx.userData!.namaJabatan,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2D3748),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.business, size: 16, color: Color(0xFF2D3748)),
              const SizedBox(width: 6),
              Text(
                ctx.userData!.namaDepartment,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2D3748),
                ),
              ),
              // const SizedBox(width: 16),
              // const Icon(Icons.dashboard, size: 16, color: Color(0xFF2D3748)),
              // const SizedBox(width: 6),
              // Text(
              //   ctx.userData!.bagian,
              //   style: const TextStyle(
              //     fontSize: 14,
              //     color: Color(0xFF2D3748),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileBody(BuildContext context, Profile? profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileSection(
            context,
            'Data Karyawan',
            Icons.person,
            profile == null
                ? [const Center(child: CircularProgressIndicator())]
                : [
                    _buildProfileItem(context, 'Nama Panggilan', profile.namaPanggilan ?? ''),
                    _buildProfileItem(context, 'Tanggal Masuk Kerja', profile.tanggalMasukKerja ?? ''),
                    _buildProfileItem(context, 'Status Kerja', profile.statusPekerja ?? ''),
                    _buildProfileItem(context, 'Tanggal Pengangkatan', profile.tanggalPengangkatan ?? ''),
                    _buildProfileItem(context, 'Tanggal Habis Kontrak Kerja', profile.tanggalHabisKontrakKerja ?? ''),
                    _buildProfileItem(context, 'Jenis Kelamin', profile.jenisKelamin ?? ''),
                    _buildProfileItem(context, 'Tempat Tanggal Lahir', '${profile.tempatLahir}, ${profile.tanggalLahir}'),
                    _buildProfileItem(context, 'Suku Bangsa', profile.sukuBangsa ?? ''),
                    _buildProfileItem(context, 'Agama', profile.agama ?? ''),
                    _buildProfileItem(context, 'Golongan Darah', profile.golonganDarah ?? ''),
                    _buildProfileItem(context, 'Status Perkawinan', profile.statusPerkawinan ?? ''),
                    _buildProfileItem(context, 'Tipe', profile.tipe ?? ''),
                  ],
          ),
          const SizedBox(height: 16),
          _buildProfileSection(
            context,
            'Dokumen Karyawan',
            Icons.description,
            profile == null
                ? [const Center(child: CircularProgressIndicator())]
                : [
                    _buildProfileItem(context, 'No KTP', profile.noKtp ?? ''),
                    _buildProfileItem(context, 'Berlaku Sampai', profile.berlakuSampai ?? ''),
                    _buildProfileItem(context, 'No KK', profile.noKk ?? ''),
                    _buildProfileItem(context, 'No NPWP', profile.npwp ?? ''),
                    _buildProfileItem(context, 'Tanggal Terdaftar NPWP', profile.tanggalTerdaftarNpwp ?? ''),
                    _buildProfileItem(context, 'No Jamsostek', profile.noJamsostek ?? ''),
                    _buildProfileItem(context, 'Tanggal Terdaftar Jamsostek', profile.tanggalTerdaftarJamsostek ?? ''),
                    _buildProfileItem(context, 'No BPJS Kesehatan', profile.noBpjsKesehatan ?? ''),
                    _buildProfileItem(context, 'Tanggal Terdaftar BPJS Kesehatan', profile.tanggalTerdaftarBpjsKesehatan ?? ''),
                  ],
          ),
          const SizedBox(height: 16),
          _buildProfileSection(
            context,
            'Attachment',
            Icons.attach_file,
            profile == null
                ? [const Center(child: CircularProgressIndicator())]
                : [
                    _buildAttachmentItem(context, 'Kontrak Kerja', profile.kontrakKerja ?? ''),
                    _buildAttachmentItem(context, 'KK', profile.kk ?? ''),
                    _buildAttachmentItem(context, 'NPWP', profile.npwp ?? ''),
                    _buildAttachmentItem(context, 'Ijazah', profile.ijazah ?? ''),
                    _buildAttachmentItem(context, 'Foto Karyawan', profile.fotoKaryawan ?? ''),
                  ],
          ),
          const SizedBox(height: 80), // Extra space for FAB
        ],
      ),
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: theme.primaryColor
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          initiallyExpanded: true,
          childrenPadding: EdgeInsets.zero,
          children: [
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(BuildContext context, String title, String value) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () {
        if (value.isNotEmpty) {
          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                      ),
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
                  ),
                ],
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.insert_drive_file,
                color: theme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            value.isNotEmpty
                ? Icon(
                    Icons.visibility,
                    color: theme.primaryColor,
                    size: 20,
                  )
                : const Icon(
                    Icons.visibility_off,
                    color: Colors.grey,
                    size: 20,
                  ),
          ],
        ),
      ),
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
}