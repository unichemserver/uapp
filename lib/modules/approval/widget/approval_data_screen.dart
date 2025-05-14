// import '../../home/home_api.dart'; // Import HomeApi
// import 'package:uapp/core/utils/log.dart';
// import 'dart:io';
import 'package:get/get.dart';
import 'package:uapp/core/utils/log.dart';
import '../approval_controller.dart';
import 'package:flutter/material.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uapp/modules/approval/widget/noo_form_widget.dart';

class ApprovalDataScreen extends StatefulWidget {
  @override
  _ApprovalDataScreenState createState() => _ApprovalDataScreenState();
}

class _ApprovalDataScreenState extends State<ApprovalDataScreen> {
  final ApprovalController ctx = Get.find();


  @override
  void initState() {
    super.initState();
    ctx.fetchMasterNooData(); 
    ctx.fetchDocumentNoo();
    ctx.fetchTopOptions(); 
  }
  String safeValue(dynamic value) {
  if (value == null || value == "null") return "-";
  return value.toString();
}

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

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      
                      ExpansionTile(
                        title: const Text('Master Noo Details'),
                        leading: const Icon(Icons.info),
                        children: [
                          NooFormWidget(
                            masternoo: {
                              'id': safeValue(masternoo['id']),
                              'nama_perusahaan': safeValue(masternoo['nama_perusahaan']),
                              'group_cust': safeValue(masternoo['group_cust']),
                              'credit_limit': safeValue(masternoo['credit_limit']),
                              'payment_method': safeValue(masternoo['payment_method']),
                              'termin': safeValue(masternoo['termin']),
                              // 'jaminan': safeValue(masternoo['jaminan']),
                              // 'nilai_jaminan': safeValue(masternoo['nilai_jaminan']),
                              'area_marketing': safeValue(masternoo['area_marketing']),
                              'tgl_join': safeValue(masternoo['tgl_join']),
                              'spv_uci': safeValue(masternoo['spv_uci']),
                              'asm_uci': safeValue(masternoo['asm_uci']),
                              'nama_owner': safeValue(masternoo['nama_owner']),
                              'id_owner': safeValue(masternoo['id_owner']),
                              'age_gender_owner': safeValue(masternoo['age_gender_owner']),
                              'nohp_owner': safeValue(masternoo['nohp_owner']),
                              'email_owner': safeValue(masternoo['email_owner']),
                              'status_pajak': safeValue(masternoo['status_pajak']),
                              'nama_npwp': safeValue(masternoo['nama_npwp']),
                              'no_npwp': safeValue(masternoo['no_npwp']),
                              'alamat_npwp': safeValue(masternoo['alamat_npwp']),
                              'nama_bank': safeValue(masternoo['nama_bank']),
                              'no_rek_va': safeValue(masternoo['no_rek_va']),
                              'nama_rek': safeValue(masternoo['nama_rek']),
                              'cabang_bank': safeValue(masternoo['cabang_bank']),
                              'bidang_usaha': safeValue(masternoo['bidang_usaha']),
                              'tgl_mulai_usaha': safeValue(masternoo['tgl_mulai_usaha']),
                              'produk_utama': safeValue(masternoo['produk_utama']),
                              'produk_lain': safeValue(masternoo['produk_lain']),
                              'lima_cust_utama': safeValue(masternoo['lima_cust_utama']),
                              'est_omset_month': safeValue(masternoo['est_omset_month']),
                            },
                            topOptions: ctx.topOptions,
                            paymentMethod: ctx.paymentMethod.value,
                            creditLimitCtrl: TextEditingController(text: safeValue(masternoo['credit_limit']),),
                            jaminanCtrl: TextEditingController(text: safeValue(masternoo['nilai_jaminan']),),
                            onPaymentMethodChanged: (value) {ctx.paymentMethod.value = value;},
                            onCreditLimitChanged: (value) {ctx.creditLimit.value = value;},
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Approve Button (Primary Action)
                      ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog(
                            context,
                            'approve',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 56.0),
                        ),
                        child: const Text(
                          'Approve',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      // Reject Button (Secondary Action)
                      OutlinedButton(
                        onPressed: () {
                          _showConfirmationDialog(
                            context,
                            'reject',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 56.0),
                        ),
                        child: const Text(
                          'Reject',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
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

  void _showConfirmationDialog(BuildContext context, String action) {
    final masternoo = ctx.masternoo.value;

    String creditLimit = ctx.creditLimit.value.isNotEmpty 
        ? ctx.creditLimit.value 
        : safeValue(masternoo?['credit_limit']);

    String paymentMethod = ctx.paymentMethod.value.isNotEmpty 
        ? ctx.paymentMethod.value 
        : safeValue(masternoo?['termin']);


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text('Are you sure you want to $action this data?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (action == 'approve') {
                  Log.d('Credit Limit: $creditLimit (${creditLimit.runtimeType})');
                  Log.d('Payment Method: $paymentMethod (${creditLimit.runtimeType})');
                  await ctx.approveData(creditLimit, paymentMethod);

                } else {
                  await ctx.rejectData();
                }
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}