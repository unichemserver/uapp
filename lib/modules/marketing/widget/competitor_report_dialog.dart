import 'package:flutter/material.dart';
import 'package:uapp/core/utils/rupiah_formatter.dart';
import 'package:uapp/models/competitor.dart';

class CompetitorReportDialog extends StatefulWidget {
  const CompetitorReportDialog({super.key, this.competitor,required this.idMarketingActivity});

  final Competitor? competitor;
  final int idMarketingActivity;

  @override
  State<CompetitorReportDialog> createState() => _CompetitorReportDialogState();
}

class _CompetitorReportDialogState extends State<CompetitorReportDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController programController = TextEditingController();
  final TextEditingController supportController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (widget.competitor != null) {
      nameController.text = widget.competitor!.name;
      priceController.text = widget.competitor!.price.toString();
      programController.text = widget.competitor!.program;
      supportController.text = widget.competitor!.support;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Tambah Laporan Kompetitor'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Nama Kompetitor',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nama Kompetitor tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama Kompetitor',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Harga',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [RupiahInputFormatter()],
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Harga produk tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan harga produk',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Program',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: programController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Program produk tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'contoh: Diskon, Cashback, dll',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Support',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: supportController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Support produk tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'contoh: Garansi, Service, dll',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // the price only take the number
                        var price = priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
                        var competitor = Competitor(
                          id: DateTime.now().millisecondsSinceEpoch,
                          idMA: widget.idMarketingActivity,
                          name: nameController.text,
                          price: int.parse(price),
                          program: programController.text,
                          support: supportController.text,
                        );
                        Navigator.pop(context, competitor);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40.0),
                    ),
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
