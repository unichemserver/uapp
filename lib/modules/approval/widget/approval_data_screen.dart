// import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/utils/utils.dart';
// import 'package:uapp/core/utils/log.dart';
import 'package:uapp/modules/approval/widget/noo_form_widget.dart';
// import '../../home/home_api.dart'; // Import HomeApi
import '../approval_controller.dart';

class ApprovalDataScreen extends StatefulWidget {
  @override
  _ApprovalDataScreenState createState() => _ApprovalDataScreenState();
}

class _ApprovalDataScreenState extends State<ApprovalDataScreen> {
  final ApprovalController ctx = Get.find(); // Initialize ctx with the controller

  @override
  void initState() {
    super.initState();
    ctx.fetchMasterNooData(); 
    ctx.fetchDocumentNoo(); 
  }

  // Future<void> _saveField(String field, String value) async {
  //   try {
  //     Utils.showLoadingDialog(context); // Show loading indicator
  //     await ctx.updateMasterNooField(field, value); // Save to database
  //     Utils.showSuccessSnackBar(context, 'Field $field berhasil disimpan');
  //   } catch (e) {
  //     Utils.showErrorSnackBar(context, 'Gagal menyimpan $field: $e');
  //   } finally {
  //     Navigator.pop(context); // Hide loading indicator
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Details'),
      ),
      body: FutureBuilder(
        future: _fetchData(), // Fetch data before rendering the UI
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Obx(() {
            final masternoo = ctx.masternoo.value;
            if (masternoo == null) {
              return const Center(child: Text('No data found for this ID'));
            }

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Master Noo Data
                ExpansionTile(
                  title: const Text('Master Noo Details'),
                  leading: const Icon(Icons.info),
                  children: [
                    NooFormWidget(
                      masternoo: {
                        'id': masternoo['id'] == "null" ? '-' : masternoo['id'] ?? '-',
                        'nama_perusahaan': masternoo['nama_perusahaan'] == "null" ? '-' : masternoo['nama_perusahaan'] ?? '-',
                        'group_cust': masternoo['group_cust'] == "null" ? '-' : masternoo['group_cust'] ?? '-',
                        'credit_limit': masternoo['credit_limit'] == "null" ? '-' : masternoo['credit_limit'] ?? '-',
                        'payment_method': masternoo['payment_method'] == "null" ? '-' : masternoo['payment_method'] ?? '-',
                        'jaminan': masternoo['jaminan'] == "null" ? '-' : masternoo['jaminan'] ?? '-',
                        'nilai_jaminan': masternoo['nilai_jaminan'] == "null" ? '-' : masternoo['nilai_jaminan'] ?? '-',
                        'area_marketing': masternoo['area_marketing'] == "null" ? '-' : masternoo['area_marketing'] ?? '-',
                        'tgl_join': masternoo['tgl_join'] == "null" ? '-' : masternoo['tgl_join'] ?? '-',
                        'spv_uci': masternoo['spv_uci'] == "null" ? '-' : masternoo['spv_uci'] ?? '-',
                        'asm_uci': masternoo['asm_uci'] == "null" ? '-' : masternoo['asm_uci'] ?? '-',
                        'nama_owner': masternoo['nama_owner'] == "null" ? '-' : masternoo['nama_owner'] ?? '-',
                        'id_owner': masternoo['id_owner'] == "null" ? '-' : masternoo['id_owner'] ?? '-',
                        'age_gender_owner': masternoo['age_gender_owner'] == "null" ? '-' : masternoo['age_gender_owner'] ?? '-',
                        'nohp_owner': masternoo['nohp_owner'] == "null" ? '-' : masternoo['nohp_owner'] ?? '-',
                        'email_owner': masternoo['email_owner'] == "null" ? '-' : masternoo['email_owner'] ?? '-',
                        'status_pajak': masternoo['status_pajak'] == "null" ? '-' : masternoo['status_pajak'] ?? '-',
                        'nama_npwp': masternoo['nama_npwp'] == "null" ? '-' : masternoo['nama_npwp'] ?? '-',
                        'no_npwp': masternoo['no_npwp'] == "null" ? '-' : masternoo['no_npwp'] ?? '-',
                        'alamat_npwp': masternoo['alamat_npwp'] == "null" ? '-' : masternoo['alamat_npwp'] ?? '-',
                        'nama_bank': masternoo['nama_bank'] == "null" ? '-' : masternoo['nama_bank'] ?? '-',
                        'no_rek_va': masternoo['no_rek_va'] == "null" ? '-' : masternoo['no_rek_va'] ?? '-',
                        'nama_rek': masternoo['nama_rek'] == "null" ? '-' : masternoo['nama_rek'] ?? '-',
                        'cabang_bank': masternoo['cabang_bank'] == "null" ? '-' : masternoo['cabang_bank'] ?? '-',
                        'bidang_usaha': masternoo['bidang_usaha'] == "null" ? '-' : masternoo['bidang_usaha'] ?? '-',
                        'tgl_mulai_usaha': masternoo['tgl_mulai_usaha'] == "null" ? '-' : masternoo['tgl_mulai_usaha'] ?? '-',
                        'produk_utama': masternoo['produk_utama'] == "null" ? '-' : masternoo['produk_utama'] ?? '-',
                        'produk_lain': masternoo['produk_lain'] == "null" ? '-' : masternoo['produk_lain'] ?? '-',
                        'lima_cust_utama': masternoo['lima_cust_utama'] == "null" ? '-' : masternoo['lima_cust_utama'] ?? '-',
                        'est_omset_month': masternoo['est_omset_month'] == "null" ? '-' : masternoo['est_omset_month'] ?? '-',
                      },
                    ),
                  ],
                ),
                // Document Data
                ExpansionTile(
                  title: const Text('Documents'),
                  leading: const Icon(Icons.find_in_page),
                  children: ctx.documents.isEmpty ||
                          ctx.documents.every((doc) =>
                              doc.entries
                                  .where((entry) => 
                                      entry.key.toLowerCase() != 'id' && 
                                      entry.key.toLowerCase() != 'id_noo')
                                  .every((entry) => entry.value == null || entry.value == "null"))
                      ? [_buildNoDataAvailable('No document data available')]
                      : (() {
                          final processedKeys = <String>{}; // Set untuk menyimpan kunci yang sudah diproses
                          return ctx.documents.expand((doc) {
                            return doc.entries
                                .where((entry) =>
                                    entry.value != null &&
                                    entry.value != "null" &&
                                    entry.key.toLowerCase() != 'id' &&
                                    entry.key.toLowerCase() != 'id_noo' &&
                                    processedKeys.add(entry.key)) // Memastikan hanya memproses kunci unik
                                .map((entry) => _buildApprovalItem(
                                      entry.key.toUpperCase(),
                                      entry.value,
                                      isImage: true,
                                    ));
                          }).toList();
                        })(),
                ),
                // Spesimen Data
                ExpansionTile(
                  title: const Text('Spesimen Details'),
                  leading: const Icon(Icons.system_update_alt_sharp),
                  children: ctx.approvalDetail['spesimen'].isEmpty
                      ? [_buildNoDataAvailable('No spesimen data available')]
                      : ctx.approvalDetail['spesimen'].map((spec) {
                          return _buildApprovalItem(
                            'Tanda Tangan',
                            spec['url_ttd'] ?? '',
                            isImage: true,
                          );
                        }).toList(),
                ),
              ],
            );
          });
        },
      ),
    );
  }

  Future<void> _fetchData() async {
    await ctx.fetchMasterNooData();
    await ctx.fetchDocumentNoo();
  }

  // Helper method to construct image URL
  String _getImageUrl(String? url) {
    if (Utils.getBaseUrl().contains('unichem')) {
      return 'https://unichem.co.id/EDS//upload/marketing_activity/$url';
    } else {
      return 'https://unifood.id/EDS//upload/marketing_activity/$url';
    }
  }

  // Updated helper method to build approval items
  Widget _buildApprovalItem(String title, String value, {bool isImage = false}) {
    return ListTile(
      title: Text(title),
      subtitle: isImage
          ? ElevatedButton.icon(
              onPressed: () {
                Get.dialog(
                  Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InteractiveViewer(
                      minScale: 0.1,
                      maxScale: 4.0,
                      child: CachedNetworkImage(
                        imageUrl: _getImageUrl(value),
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.image_search_rounded), // Add icon to the button
              label: const Text('Lihat File'),
            )
          : Text(value),
    );
  }

  Widget _buildNoDataAvailable(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}