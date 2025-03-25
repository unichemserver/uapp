import 'package:flutter/material.dart';
import 'package:uapp/core/widget/app_textfield.dart';

class NooFormWidget extends StatelessWidget {
  final Map<String, String> masternoo;

  const NooFormWidget({Key? key, required this.masternoo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: TextEditingController(text: masternoo['id']),
            label: 'ID Noo',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['nama_perusahaan']),
            label: 'Nama Outlet',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['groupPelanggan']),
            label: 'Group Pelanggan',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['credit_limit']),
            label: 'Credit Limit',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['payment_method']),
            label: 'Termin',
            readOnly: true,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['jaminan']),
            label: 'Jaminan',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['nilai_jaminan']),
            label: 'Nilai Jaminan',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['area_marketing']),
            label: 'Area Marketing',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['tgl_join']),
            label: 'Tanggal Join',
            readOnly: true,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['spv_uci']),
            label: 'Supervisor UCI',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['asm_uci']),
            label: 'ASM UCI',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['nama_owner']),
            label: 'Nama Owner',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['id_owner']),
            label: 'ID Owner',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['age_gender_owner']),
            label: 'Age/Gender Owner',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['nohp_owner']),
            label: 'No HP Owner',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['email_owner']),
            label: 'Email Owner',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['status_pajak']),
            label: 'Status Pajak',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['nama_npwp']),
            label: 'Nama NPWP',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['no_npwp']),
            label: 'No NPWP',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['alamat_npwp']),
            label: 'Alamat NPWP',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['nama_bank']),
            label: 'Nama Bank',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['no_rek_va']),
            label: 'No Rekening/VA',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['nama_rek']),
            label: 'Nama Rekening',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['cabang_bank']),
            label: 'Cabang Bank',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['bidang_usaha']),
            label: 'Bidang Usaha',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['tgl_mulai_usaha']),
            label: 'Tanggal Mulai Usaha',
            readOnly: true,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['produk_utama']),
            label: 'Produk Utama',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['produk_lain']),
            label: 'Produk Lain',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['lima_cust_utama']),
            label: 'Lima Customer Utama',
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: TextEditingController(text: masternoo['est_omset_month']),
            label: 'Estimasi Omset Bulanan',
            readOnly: true,
          ),
        ],
      ),
    );
  }
}
