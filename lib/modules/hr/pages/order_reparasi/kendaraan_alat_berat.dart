import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/speech_to_textfield.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/api_param.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/peralatan_reparasi.dart';

class KendaraanAlatBerat extends StatefulWidget {
  const KendaraanAlatBerat({
    super.key,
    required this.alatBerat,
    required this.formKey,
    this.onSaved,
  });

  final List<HeavyEquipment>? alatBerat;
  final GlobalKey<FormState> formKey;
  final void Function(ApiParams)? onSaved;

  @override
  State<KendaraanAlatBerat> createState() => _KendaraanAlatBeratState();
}

class _KendaraanAlatBeratState extends State<KendaraanAlatBerat> {
  final bengkelCtrl = TextEditingController();
  final keteranganCtrl = TextEditingController();
  String? selectedMesin;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Untuk Mesin:'),
          DropdownSearch<HeavyEquipment>(
            items: widget.alatBerat!,
            itemAsString: (item) => '${item.namaAlatBerat} - ${item.nomerSerial}',
            onChanged: (value) {
              selectedMesin = '${value!.namaAlatBerat} - ${value.nomerSerial}';
            },
            validator: (value) {
              if (value == null) {
                return 'Peralatan IT tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text('Bengkel:'),
          SpeechToTextField(
            controller: bengkelCtrl,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Bengkel tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text('Keterangan:'),
          SpeechToTextField(
            controller: keteranganCtrl,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Keterangan tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (widget.formKey.currentState!.validate()) {
                var params = ApiParams(
                  method: HrMethodApi.orderReparasi,
                  nik: Utils.getUserData().id,
                  barang: '',
                  mesin: selectedMesin!,
                  gudang: '',
                  bengkel: bengkelCtrl.text,
                  keterangan: keteranganCtrl.text,
                  jenisAlat: '3',
                );
                widget.onSaved!(params);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
