import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/widget/app_textfield.dart';
// import 'package:intl/intl.dart';

class NooFormWidget extends StatelessWidget {
  final Map<String, String> masternoo;
  final List<Map<String, dynamic>> topOptions;
  final String paymentMethod;
  final TextEditingController creditLimitCtrl;
  final TextEditingController jaminanCtrl;
  final Function(String) onPaymentMethodChanged;
  final Function(String) onCreditLimitChanged;


  const NooFormWidget({
    Key? key,
    required this.masternoo,
    required this.topOptions,
    required this.paymentMethod,
    required this.creditLimitCtrl,
    required this.jaminanCtrl,
    required this.onPaymentMethodChanged,
    required this.onCreditLimitChanged,
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
          _buildCreditLimitField(context),
          const SizedBox(height: 16),
          _buildPaymentMethodField(context),
          const SizedBox(height: 16),
          _buildPaymentTermDropdown(context),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Nilai Jaminan', jaminanCtrl.text),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Area Marketing', masternoo['area_marketing']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Tanggal Join', masternoo['tgl_join'], suffixIcon: const Icon(Icons.calendar_today)),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Supervisor UCI', masternoo['spv_uci']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('ASM UCI', masternoo['asm_uci']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Nama Owner', masternoo['nama_owner']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('ID Owner', masternoo['id_owner']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Age/Gender Owner', masternoo['age_gender_owner']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('No HP Owner', masternoo['nohp_owner']),
          const SizedBox(height: 16),
          _buildReadOnlyTextField('Email Owner', masternoo['email_owner']),
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
      controller: TextEditingController(text: value),
      label: label,
      enabled: false,
      suffixIcon: suffixIcon,
    );
  }

  Widget _buildCreditLimitField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Credit Limit (Secara Total dalam Rupiah):',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        TextFormField(
          controller: creditLimitCtrl,
          decoration: InputDecoration(
            hintText: 'Masukkan Credit Limit',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            var credit = int.tryParse(value.replaceAll(RegExp(r'\D'), ''));
            if (credit != null) {
              jaminanCtrl.text = (credit * 1.1).toInt().toString();
            }
            onCreditLimitChanged(value);
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Credit limit tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPaymentTermDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Termin Pembayaran (TOP) Pelanggan:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Obx(() {
          // var descriptionToTopIdMap = {
          //   for (var item in topOptions) item['Description']: item['TOP_ID']
          // };

          var items = topOptions
              .map((item) => DropdownMenuItem<String>(
                    value: item['TOP_ID'],
                    child: Text(item['TOP_ID']),
                  ))
              .toList();
          var selectedValue = items.any((element) => element.value == masternoo['termin'])
              ? masternoo['termin']
              : null;

          return DropdownButtonFormField<String>(
            value: selectedValue,
            items: items,
            onChanged: (value) {
              if (value != null) {
                Log.d('Selected TOP_ID: $value');
                onPaymentMethodChanged(value); // Notify parent about the change
              }
            },
            hint: const Text('Pilih Termin Pembayaran'),
            icon: const Icon(Icons.calendar_today),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            selectedItemBuilder: (BuildContext context) {
              return items.map((DropdownMenuItem<String> item) {
                return Text(item.value ?? '');
              }).toList();
            },
          );
        }),
      ],
    );
  }

  Widget _buildPaymentMethodField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Metode Pembayaran:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        DropdownButtonFormField<String>(
          value: paymentMethod.isNotEmpty && ['CASH', 'KREDIT'].contains(paymentMethod)
              ? paymentMethod
              : null,
          items: ['CASH', 'KREDIT']
              .map((method) => DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              onPaymentMethodChanged(value); // Notify parent about the change
            }
          },
          hint: const Text('Pilih Metode Pembayaran'),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ],
    );
  }
}
