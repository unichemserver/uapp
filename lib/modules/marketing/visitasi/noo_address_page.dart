import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_address_model.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_controller.dart';

// Enum untuk jenis alamat
enum AddressType {
  ownerAddress,
  companyAddress,
  warehouseAddress,
  billingAddress
}

class NooAddressPage extends StatefulWidget {
  const NooAddressPage({Key? key}) : super(key: key);

  @override
  State<NooAddressPage> createState() => _NooAddressPageState();
}

class _NooAddressPageState extends State<NooAddressPage> {
  final db = MarketingDatabase();
  final controller = Get.find<NooController>();
  String? nooId;
  List<NooAddressModel> addresses = [];
  AddressType? selectedBillToAddress;
  AddressType? selectedShipToAddress;
  AddressType? selectedTaxToAddress;
  bool shipToSameAsBillTo = false;
  bool taxToSameAsBillTo = false;

  @override
  void initState() {
    super.initState();
    nooId = Get.arguments['id'];
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    try {
      controller.setNooUpdateAddress();
      addresses = [
        controller.ownerAddress,
        controller.companyAddress,
        controller.warehouseAddress,
        controller.billingAddress,
      ].toList().cast<NooAddressModel>();
      setState(() {});
    } catch (e) {
      Log.d('Error loading addresses: $e');
    }
  }

  NooAddressModel? getAddressByType(AddressType type) {
    switch (type) {
      case AddressType.ownerAddress:
        return controller.ownerAddress;
      case AddressType.companyAddress:
        return controller.companyAddress;
      case AddressType.warehouseAddress:
        return controller.warehouseAddress;
      case AddressType.billingAddress:
        return controller.billingAddress;
      default:
        return null;
    }
  }

  Future<void> saveSelectedAddresses(BuildContext context) async {
    if (selectedBillToAddress == null ||
        (selectedShipToAddress == null && !shipToSameAsBillTo) ||
        (selectedTaxToAddress == null && !taxToSameAsBillTo)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua alamat')),
      );
      return;
    }

    try {
      final billToId = getAddressByType(selectedBillToAddress!)?.id;
      final shipToId = shipToSameAsBillTo
          ? billToId
          : getAddressByType(selectedShipToAddress!)?.id;
      final taxToId = taxToSameAsBillTo
          ? billToId
          : getAddressByType(selectedTaxToAddress!)?.id;

      if (billToId == null || shipToId == null || taxToId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alamat tidak valid')),
        );
        return;
      }
      await db.update(
        'masternooupdate',
        {
          'bill_to': billToId,
          'ship_to': shipToId,
          'tax_to': taxToId,
        },
        'id_noo = ?',
        [nooId],
      );
    } catch (e) {
      Log.d('Error saving addresses: $e');
      Utils.showErrorSnackBar(context, 'Gagal menyimpan data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Pilih Alamat'),
        ),
        automaticallyImplyLeading: false, // Disable the back button
      ),
      body: addresses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bill To Section
                  _buildSectionTitle('Bill To (Alamat Tagihan)'),
                  _buildAddressSelector(
                    selectedValue: selectedBillToAddress,
                    onChanged: (value) {
                      setState(() {
                        selectedBillToAddress = value;

                        // Update alamat yang sama dengan Bill To jika checkbox dicentang
                        if (shipToSameAsBillTo) {
                          selectedShipToAddress = value;
                        }
                        if (taxToSameAsBillTo) {
                          selectedTaxToAddress = value;
                        }
                      });
                    },
                  ),
                  if (selectedBillToAddress != null)
                    _buildAddressCard(getAddressByType(selectedBillToAddress!)!),
                  const SizedBox(height: 24),

                  // Ship To Section
                  _buildSectionTitle('Ship To (Alamat Pengiriman)'),
                  _buildCheckbox(
                    value: shipToSameAsBillTo,
                    title: 'Sama dengan Bill To',
                    onChanged: (value) {
                      setState(() {
                        shipToSameAsBillTo = value!;
                        if (shipToSameAsBillTo) {
                          selectedShipToAddress = selectedBillToAddress;
                        }
                      });
                    },
                  ),
                  if (!shipToSameAsBillTo)
                    _buildAddressSelector(
                      selectedValue: selectedShipToAddress,
                      onChanged: (value) {
                        setState(() {
                          selectedShipToAddress = value;
                        });
                      },
                    ),
                  if (!shipToSameAsBillTo && selectedShipToAddress != null)
                    _buildAddressCard(getAddressByType(selectedShipToAddress!)!),
                  if (shipToSameAsBillTo && selectedBillToAddress != null)
                    _buildAddressCard(getAddressByType(selectedBillToAddress!)!),
                  const SizedBox(height: 24),

                  // Tax To Section
                  _buildSectionTitle('Tax To (Alamat Pajak)'),
                  _buildCheckbox(
                    value: taxToSameAsBillTo,
                    title: 'Sama dengan Bill To',
                    onChanged: (value) {
                      setState(() {
                        taxToSameAsBillTo = value!;
                        if (taxToSameAsBillTo) {
                          selectedTaxToAddress = selectedBillToAddress;
                        }
                      });
                    },
                  ),
                  if (!taxToSameAsBillTo)
                    _buildAddressSelector(
                      selectedValue: selectedTaxToAddress,
                      onChanged: (value) {
                        setState(() {
                          selectedTaxToAddress = value;
                        });
                      },
                    ),
                  if (!taxToSameAsBillTo && selectedTaxToAddress != null)
                    _buildAddressCard(getAddressByType(selectedTaxToAddress!)!),
                  if (taxToSameAsBillTo && selectedBillToAddress != null)
                    _buildAddressCard(getAddressByType(selectedBillToAddress!)!),
                  const SizedBox(height: 36),

                  // Tombol Lanjut
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => {
                        Utils.showLoadingDialog(context),
                        saveSelectedAddresses(context).then((value) {
                          Navigator.pop(context); 
                          Get.offNamed(Routes.HOME); 
                          Utils.showSuccessSnackBar(context, 'Data berhasil disimpan');
                        }).catchError((error) {
                          Navigator.pop(context);
                          Utils.showErrorSnackBar(
                            context,
                            'Terjadi kesalahan saat menyimpan data: $error',
                          );
                        })
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Widget untuk judul section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget untuk pemilihan alamat dengan radio
  Widget _buildAddressSelector({
    required AddressType? selectedValue,
    required Function(AddressType?) onChanged,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AddressType.values.map((address) {
            return RadioListTile<AddressType>(
              title: Text(getAddressTypeName(address)),
              subtitle: Text(getAddressByType(address)?.address ?? ''),
              value: address,
              groupValue: selectedValue,
              onChanged: (value) => onChanged(value),
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Widget untuk checkbox
  Widget _buildCheckbox({
    required bool value,
    required String title,
    required Function(bool?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 1,
        child: CheckboxListTile(
          title: Text(title),
          value: value,
          onChanged: onChanged,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }

  // Widget untuk menampilkan detail alamat dalam bentuk card
  Widget _buildAddressCard(NooAddressModel address) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address.address ?? '-',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            if (address.rtRw != null) Text('RT/RW: ${address.rtRw}'),
            if (address.desaKelurahan != null)
              Text('${address.desaKelurahan}, Kec. ${address.kecamatan}'),
            if (address.kabupatenKota != null)
              Text('${address.kabupatenKota}, ${address.provinsi} ${address.kodePos}'),
          ],
        ),
      ),
    );
  }

  // Mendapatkan nama alamat untuk ditampilkan
  String getAddressTypeName(AddressType type) {
    switch (type) {
      case AddressType.ownerAddress:
        return 'Alamat Pemilik';
      case AddressType.companyAddress:
        return 'Alamat Toko/Outlet';
      case AddressType.warehouseAddress:
        return 'Alamat Gudang';
      case AddressType.billingAddress:
        return 'Alamat Penagihan';
      default:
        return '';
    }
  }
}