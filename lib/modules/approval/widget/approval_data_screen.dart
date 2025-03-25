import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/utils/log.dart';
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
    ctx.fetchMasterNooData(); // Fetch masternoo data using the controller
    ctx.fetchDocumentNoo(); // Fetch documents from API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Details'),
      ),
      body: Obx(() {
        if (ctx.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

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
                _buildApprovalItem('ID Noo', masternoo['id'] ?? ''),
                _buildApprovalItem('Nama Outlet', masternoo['nama_perusahaan'] ?? ''),
                _buildApprovalItem('Group Pelanggan', masternoo['group_cust'] ?? ''),
                _buildApprovalItem('Credit Limit', masternoo['credit_limit'] ?? ''),
                _buildApprovalItem('Termin', masternoo['payment_method'] ?? ''),
                _buildApprovalItem('Jaminan', masternoo['jaminan'] ?? ''),
                _buildApprovalItem('Nilai Jaminan', masternoo['nilai_jaminan'] ?? ''),
                _buildApprovalItem('Area Marketing', masternoo['area_marketing'] ?? ''),
                _buildApprovalItem('Tanggal Join', masternoo['tgl_join'] ?? ''),
                _buildApprovalItem('Supervisor UCI', masternoo['spv_uci'] ?? ''),
                _buildApprovalItem('ASM UCI', masternoo['asm_uci'] ?? ''),
                _buildApprovalItem('Nama Owner', masternoo['nama_owner'] ?? ''),
                _buildApprovalItem('ID Owner', masternoo['id_owner'] ?? ''),
                _buildApprovalItem('Age/Gender Owner', masternoo['age_gender_owner'] ?? ''),
                _buildApprovalItem('No HP Owner', masternoo['nohp_owner'] ?? ''),
                _buildApprovalItem('Email Owner', masternoo['email_owner'] ?? ''),
                _buildApprovalItem('Status Pajak', masternoo['status_pajak'] ?? ''),
                _buildApprovalItem('Nama NPWP', masternoo['nama_npwp'] ?? ''),
                _buildApprovalItem('No NPWP', masternoo['no_npwp'] ?? ''),
                _buildApprovalItem('Alamat NPWP', masternoo['alamat_npwp'] ?? ''),
                _buildApprovalItem('Nama Bank', masternoo['nama_bank'] ?? ''),
                _buildApprovalItem('No Rekening/VA', masternoo['no_rek_va'] ?? ''),
                _buildApprovalItem('Nama Rekening', masternoo['nama_rek'] ?? ''),
                _buildApprovalItem('Cabang Bank', masternoo['cabang_bank'] ?? ''),
                _buildApprovalItem('Bidang Usaha', masternoo['bidang_usaha'] ?? ''),
                _buildApprovalItem('Tanggal Mulai Usaha', masternoo['tgl_mulai_usaha'] ?? ''),
                _buildApprovalItem('Produk Utama', masternoo['produk_utama'] ?? ''),
                _buildApprovalItem('Produk Lain', masternoo['produk_lain'] ?? ''),
                _buildApprovalItem('Lima Customer Utama', masternoo['lima_cust_utama'] ?? ''),
                _buildApprovalItem('Estimasi Omset Bulanan', masternoo['est_omset_month'] ?? ''),
              ],
            ),
            // Address Data
            ExpansionTile(
              title: const Text('Address Details'),
              leading: const Icon(Icons.store),
              children: ctx.approvalDetail['address'].isEmpty
                  ? [const Text('No address data available')]
                  : ctx.approvalDetail['address'].map((addr) {
                      return _buildApprovalItem(
                        'Alamat',
                        '${addr['alamat'] ?? ''}, Kota: ${addr['kota'] ?? ''}',
                      );
                    }).toList(),
            ),
            // Document Data
            ExpansionTile(
              title: const Text('Documents'),
              leading: const Icon(Icons.find_in_page),
              children: ctx.documents.isEmpty
                  ? [const Text('No documents available')]
                  : ctx.documents.map((doc) {
                    Log.d('Document: $doc');
                      return Column(
                        children: [
                          if (doc['ktp'] != null)
                            _buildApprovalItem('KTP', doc['ktp'], isImage: true),
                          if (doc['npwp'] != null)
                            _buildApprovalItem('NPWP', doc['npwp'], isImage: true),
                        ],
                      );
                    }).toList(),
            ),
            // Spesimen Data
            ExpansionTile(
              title: const Text('Spesimen Details'),
              leading: const Icon(Icons.system_update_alt_sharp),
              children: ctx.approvalDetail['spesimen'].isEmpty
                  ? [const Text('No spesimen data available')]
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
      }),
    );
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
      leading: isImage ? const Icon(Icons.image) : null,
      onTap: () {
        if (isImage) {
          Get.dialog(
            Dialog(
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
        }
      },
      title: Text(title),
      subtitle: isImage ? null : Text(value),
    );
  }
}
