import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/speech_to_textfield.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/api_param.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/peralatan_reparasi.dart';

class PeralatanIt extends StatefulWidget {
  const PeralatanIt({
    super.key,
    required this.peralatanIt,
    required this.formKey,
    this.onSaved,
  });

  final List<Equipment>? peralatanIt;
  final GlobalKey<FormState> formKey;
  final void Function(ApiParams)? onSaved;

  @override
  State<PeralatanIt> createState() => _PeralatanItState();
}

class _PeralatanItState extends State<PeralatanIt> {
  final keteranganCtrl = TextEditingController();
  String? selectedPeralatanIt;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Peralatan IT:'),
          DropdownSearch<Equipment>(
            items: widget.peralatanIt!,
            itemAsString: (item) =>
                '${item.namaPeralatan} - ${item.idPeralatan}',
            onChanged: (value) {
              selectedPeralatanIt =
                  '${value!.namaPeralatan} - ${value.idPeralatan}';
            },
            validator: (value) {
              if (value == null) {
                return 'Peralatan IT tidak boleh kosong';
              }
              return null;
            },
            popupProps: PopupProps.menu(
              showSearchBox: true,
            ),
          ),
          const SizedBox(height: 16),
          const Text('Keterangan'),
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
                  mesin: selectedPeralatanIt!,
                  gudang: '',
                  bengkel: '',
                  keterangan: keteranganCtrl.text,
                  jenisAlat: '2',
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
