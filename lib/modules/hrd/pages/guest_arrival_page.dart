import 'package:flutter/material.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/hrd/model/tamu_model.dart';
import 'package:uapp/modules/hrd/service/hrd_api_client.dart';
import 'package:uapp/modules/hrd/utils/jenis_tamu_opt.dart';
import 'package:uapp/modules/hrd/widget/jenis_tamu_option.dart';

class GuestArrivalPage extends StatefulWidget {
  const GuestArrivalPage({super.key});

  @override
  State<GuestArrivalPage> createState() => _GuestArrivalPageState();
}

class _GuestArrivalPageState extends State<GuestArrivalPage> {
  final api = HrdApiClient();
  final List<TamuModel> listTamu = [];
  JenisTamu? selectedJenisTamu;

  void getListTamu() async {
    listTamu.clear();
    final result = await api.postRequest(method: selectedJenisTamu!.method);
    if (result.success) {
      final data =
          (result.data as List).map((e) => TamuModel.fromJson(e)).toList();
      listTamu.addAll(data);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kedatangan Tamu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => FilterDialog(
                  items: jenisTamuList,
                  selectedJenisTamu: selectedJenisTamu ?? jenisTamuList.first,
                  onSelected: (value) {
                    setState(() {
                      selectedJenisTamu = value;
                    });
                  },
                  onApply: getListTamu,
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppTextField(
                controller: TextEditingController(), label: 'Cari Tamu'),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => ListTile(
                  title: Text('Item $index'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
