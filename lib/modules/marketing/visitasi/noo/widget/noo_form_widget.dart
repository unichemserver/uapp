import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/widget/app_textfield.dart';

class NooFormWidget extends StatelessWidget {
  final Map<String, String> masternoo;


  const NooFormWidget({
    Key? key,
    required this.masternoo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReadOnlyTextField('ID Noo', masternoo['id']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Nama Outlet', masternoo['nama_perusahaan']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Group Pelanggan', masternoo['group_cust']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Termin', masternoo['termin']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Nilai Jaminan', masternoo['jaminan']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Area Marketing', masternoo['area_marketing']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Tanggal Join', masternoo['tgl_join'], suffixIcon: const Icon(Icons.calendar_today)),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Sales UCI', masternoo['spv_uci']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Nama Owner', masternoo['nama_owner']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Age/Gender Owner', masternoo['age_gender_owner']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('No HP Owner', masternoo['nohp_owner']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Email Owner', masternoo['email_owner']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Alamat Owner', masternoo['alamat_owner']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Alamat Usaha', masternoo['alamat_kantor']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Status Pajak', masternoo['status_pajak']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Nama NPWP', masternoo['nama_npwp']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('No NPWP', masternoo['no_npwp']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Alamat NPWP', masternoo['alamat_npwp']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Nama Bank', masternoo['nama_bank']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('No Rekening/VA', masternoo['no_rek_va']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Nama Rekening', masternoo['nama_rek']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Cabang Bank', masternoo['cabang_bank']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Bidang Usaha', masternoo['bidang_usaha']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Tanggal Mulai Usaha', masternoo['tgl_mulai_usaha'], suffixIcon: const Icon(Icons.calendar_today)),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Produk Utama', masternoo['produk_utama']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Produk Lain', masternoo['produk_lain']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Lima Customer Utama', masternoo['lima_cust_utama']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Estimasi Omset Bulanan', masternoo['est_omset_month']),
        ],
      ),
    );
  }

  Widget _buildReadOnlyTextField(String label, String? value, {Widget? suffixIcon}) {
    return AppTextField(
      controller: TextEditingController(text: value ?? '-'),
      label: label,
      readOnly: true,
      suffixIcon: suffixIcon,
    );
  }
}
