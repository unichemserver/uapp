import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/speech_to_textfield.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/api_param.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/peralatan_reparasi.dart';

class PeralatanNonIt extends StatefulWidget {
  const PeralatanNonIt({
    super.key,
    required this.alatBerat,
    required this.formKey,
    this.onSaved,
  });

  final List<HeavyEquipment>? alatBerat;
  final GlobalKey<FormState> formKey;
  final void Function(ApiParams)? onSaved;

  @override
  State<PeralatanNonIt> createState() => _PeralatanNonItState();
}

class _PeralatanNonItState extends State<PeralatanNonIt> {
  final namaCtrl = TextEditingController();
  final gudangCtrl = TextEditingController();
  final bengkelCtrl = TextEditingController();
  final keteranganCtrl = TextEditingController();
  final List<String> mesin = [
    'Excavator',
    'Bulldozer',
    'Loader',
    'Grader',
    'Dump Truck',
    'Forklift',
    'Crane',
    'Compactor',
    'Asphalt Finisher',
    'Paver',
    'Tractor',
    'Lainnya'
  ];
  String selectedMesin = 'Excavator';
  final box = Hive.box(HiveKeys.appBox);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Nama Barang:'),
          SpeechToTextField(
            controller: namaCtrl,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Nama Barang tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text('Untuk Mesin:'),
          DropdownSearch<HeavyEquipment>(
            items: widget.alatBerat!,
            itemAsString: (item) =>
                '${item.nomerSerial} - ${item.namaAlatBerat}',
            validator: (value) {
              if (value == null) {
                return 'Mesin tidak boleh kosong';
              }
              return null;
            },
            onChanged: (item) {
              selectedMesin = '${item!.nomerSerial} - ${item.namaAlatBerat}';
            },
          ),
          const SizedBox(height: 16),
          const Text('Untuk Gudang:'),
          SpeechToTextField(
            controller: gudangCtrl,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Gudang tidak boleh kosong';
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
                  jenisAlat: '1',
                  barang: namaCtrl.text,
                  mesin: selectedMesin,
                  gudang: gudangCtrl.text,
                  bengkel: bengkelCtrl.text,
                  keterangan: keteranganCtrl.text,
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
