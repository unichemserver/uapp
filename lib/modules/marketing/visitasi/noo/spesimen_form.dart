
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/widget/signature_widget.dart';
import 'package:uapp/modules/marketing/model/spesimen_model.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_controller.dart';
import 'package:uapp/modules/marketing/widget/image_picker_widget.dart';

class SpesimenForm extends StatelessWidget {
  const SpesimenForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NooController>(
      init: NooController(),
      initState: (_) {},
      builder: (ctx) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ...ctx.spesimen.map(
                (spesimen) {
                  return Card(
                    child: ExpansionTile(
                      maintainState: true,
                      title: Text(spesimen.nama!),
                      subtitle: Text('Jabatan: ${spesimen.jabatan}\nNo. HP: ${spesimen.noHp}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          ctx.deleteSpesimen(spesimen.id!);
                        },
                      ),
                      children: [
                        SignatureWidget(
                          onSaved: (path) {
                            if (path.isEmpty) {
                              ctx.deleteTtdSpesimen(spesimen.id!);
                            } else {
                              ctx.updateTtdSpesimen(spesimen.id!, path);
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        ImagePickerWidget(
                          imagePath: spesimen.stempel ?? '',
                          onImagePicked: (path) {
                            ctx.updateStempelSpesimen(spesimen.id!, path);
                          },
                          onImageRemoved: () {
                            ctx.deleteStempelSpesimen(spesimen.id!);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Get.dialog(
                    AddSpesimenDialog(
                      onAdd: (spesimen) {
                        ctx.addSpesimen(spesimen);
                      },
                    ),
                  );
                },
                child: const Text('Tambah Spesimen'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AddSpesimenDialog extends StatelessWidget {
  AddSpesimenDialog({super.key, required this.onAdd});

  final Function(SpesimenModel) onAdd;
  final nameController = TextEditingController();
  final jabatanController = TextEditingController();
  final noHpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Spesimen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nama',
            ),
          ),
          TextField(
            controller: jabatanController,
            decoration: const InputDecoration(
              labelText: 'Jabatan',
            ),
          ),
          TextField(
            controller: noHpController,
            decoration: const InputDecoration(
              labelText: 'No HP',
            ),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            final spesimen = SpesimenModel(
              nama: nameController.text,
              jabatan: jabatanController.text,
              noHp: noHpController.text,
            );
            onAdd(spesimen);
            Get.back();
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
