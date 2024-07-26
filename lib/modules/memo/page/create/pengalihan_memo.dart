import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/contact.dart';
import 'package:uapp/modules/memo/data/model/custprod.dart';
import 'package:uapp/modules/memo/data/model/memo_pengalihan_a.dart';
import 'package:uapp/modules/memo/memo_utils.dart';
import 'package:uapp/modules/memo/widget/dropdown_list.dart';
import 'package:uapp/modules/memo/widget/dropdown_selectable_list.dart';
import 'package:uapp/modules/memo/widget/label_text.dart';
import 'package:uapp/modules/memo/widget/memo_shimmer.dart';
import 'package:uapp/modules/memo/widget/signature_form.dart';
import 'package:uapp/modules/memo/widget/title_memo.dart';
import 'package:uapp/modules/memo/data/memo_api_service.dart' as api;

class PengalihanMemo extends StatefulWidget {
  const PengalihanMemo({super.key});

  @override
  State<PengalihanMemo> createState() => _PengalihanMemoState();
}

class _PengalihanMemoState extends State<PengalihanMemo> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _itemKeys = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _memoController = TextEditingController(); // no
  final _makerController = TextEditingController(
    text: Utils.getUserData().nama,
  ); // pic
  List<String> selectedRecipient = []; // cc
  final _subjectController = TextEditingController(); // hal
  final _dateController = TextEditingController(
    text: DateTime.now().toString().substring(0, 10),
  ); // tgl
  String selectedCustomer = ''; // cust
  final _officeAddressController = TextEditingController(); // ualamat
  final _officePhoneController = TextEditingController(); // utelp_kntr
  final _warehouseAddressController = TextEditingController(); // ualamat_gdg
  final _warehousePICController = TextEditingController(); // upic_gdg
  final _warehousePhoneController = TextEditingController(); // utelp_gdg
  final _reasonController = TextEditingController(); // ualasan
  final _withdrawalDateController = TextEditingController(); // utgl_tarik

  final _companyNameController = TextEditingController(); // spers
  final _companyOwnerController = TextEditingController(); // spemilik
  final _companyOwnerIDController = TextEditingController(); // sno_ktp
  final _productReceivedDateController = TextEditingController(); // stgl_terima
  final _receiverAddressController = TextEditingController(); // salmt_terima
  final _warehouseReceiverController = TextEditingController(); // spenerima_gdg
  final _warehouseReceiverPhoneController =
      TextEditingController(); // stelp_gdg
  final _supportController = TextEditingController(); // ssupport

  String selectedReq = Utils.getUserData().id;
  String selectedChecker = '';
  String selectedApprover = '';
  ByteData? signature;
  ByteData? ndmSignature;
  ByteData? smhSignature;
  String status = '0';

  List<Contact> contacts = [];
  List<Contact>? selectedContacts;
  Custprod? custprod;
  List<String> selectedProduct = [];
  bool firstLoad = true;
  bool isEditing = false;
  bool isLoading = true;
  String action = MemoAct.create;
  MemoPengalihanA? memo;
  MemoIcon? memoIcon;
  bool isNdm = false;
  bool isSmh = false;

  void setLoading(bool value) {
    isLoading = value;
    setState(() {});
  }

  void _initKeys() {
    _itemKeys['ndm'] = GlobalKey();
    _itemKeys['smh'] = GlobalKey();
  }

  getContacts() async {
    contacts = await DatabaseHelper().getAllContact();
    setState(() {});
  }

  getCustomerProduct() async {
    final box = Hive.box(HiveKeys.appBox);
    custprod = await api.getCustprod(box.get(HiveKeys.baseURL));
    setState(() {});
  }

  void _saveMemo(BuildContext context) async {
    var data = MemoPengalihanA(
      no: _memoController.text,
      pic: _makerController.text,
      cc: selectedRecipient.join(','),
      hal: _subjectController.text,
      tgl: _dateController.text,
      cust: selectedCustomer,
      ualamat: _officeAddressController.text,
      utelpKntr: _officePhoneController.text,
      ualamatGdg: _warehouseAddressController.text,
      upicGdg: _warehousePICController.text,
      utelpGdg: _warehousePhoneController.text,
      ualasan: _reasonController.text,
      utglTarik: _withdrawalDateController.text,
      spers: _companyNameController.text,
      spemilik: _companyOwnerController.text,
      snoKtp: _companyOwnerIDController.text,
      salmtKntr: _receiverAddressController.text,
      stelp: _warehouseReceiverPhoneController.text,
      stglTerima: _productReceivedDateController.text,
      salmtTerima: _receiverAddressController.text,
      spenerimaGdg: _warehouseReceiverController.text,
      stelpGdg: _warehouseReceiverPhoneController.text,
      ssupport: _supportController.text,
      sdescBrg: selectedProduct.join(','),
      userid: selectedReq,
      ndm: selectedChecker,
      smh: selectedApprover,
      reqSignature: Utils.generateBase64Image(signature!) ?? '',
      ndmSignature: Utils.generateBase64Image(ndmSignature!) ?? '',
      smhSignature: Utils.generateBase64Image(smhSignature!) ?? '',
      status: status,
    );
    showDialog(
      context: context,
      builder: (context) {
        return const LoadingDialog(
          message: 'Menyimpan memo...',
        );
      },
      barrierDismissible: false,
    );
    final box = Hive.box(HiveKeys.appBox);
    var url = box.get(HiveKeys.baseURL);
    if (isEditing) {
      url = url + '?&updateMemo';
    }
    api.saveMemo<MemoPengalihanA>(data, url).then((response) {
      Navigator.pop(context);
      if (response == null) {
        _formKey.currentState?.reset();
        Navigator.pop(context);
        String message =
            isEditing ? 'Memo berhasil diubah' : 'Memo berhasil disimpan';
        Utils.showSuccessSnackBar(context, message);
        if (isEditing) {
          Navigator.pop(context, true);
        }
      } else {
        Utils.showErrorSnackBar(context, 'Gagal menyimpan memo');
      }
    }).catchError((error) {
      Navigator.pop(context);
      Utils.showErrorSnackBar(context, 'Gagal menyimpan memo');
    });
  }

  void isEditMemo(MemoPengalihanA? memo) {
    if (memo != null && firstLoad) {
      isEditing = true;
      this.memo = memo;
      _memoController.text = memo.no;
      _makerController.text = memo.pic;
      selectedRecipient = memo.cc.contains(',')
          ? memo.cc.split(',').map((e) => e.trim()).toList()
          : [memo.cc];
      _subjectController.text = memo.hal;
      _dateController.text = memo.tgl;

      selectedCustomer = memo.cust;
      _officeAddressController.text = memo.ualamat;
      _officePhoneController.text = memo.utelpKntr;
      _warehouseAddressController.text = memo.ualamatGdg;
      _warehousePICController.text = memo.upicGdg;
      _warehousePhoneController.text = memo.utelpGdg;
      _reasonController.text = memo.ualasan;
      _withdrawalDateController.text = memo.utglTarik;
      _companyNameController.text = memo.spers;
      _companyOwnerController.text = memo.spemilik;
      _companyOwnerIDController.text = memo.snoKtp;
      _productReceivedDateController.text = memo.stglTerima;
      _receiverAddressController.text = memo.salmtTerima;
      _warehouseReceiverController.text = memo.spenerimaGdg;
      _warehouseReceiverPhoneController.text = memo.stelpGdg;
      _supportController.text = memo.ssupport;
      selectedProduct = memo.sdescBrg.contains(',')
          ? memo.sdescBrg.split(',').map((e) => e.trim()).toList()
          : [memo.sdescBrg];
      selectedContacts = contacts.where((element) {
        return selectedRecipient.contains(element.id);
      }).toList();

      selectedReq = memo.userid;
      selectedChecker = memo.ndm;
      selectedApprover = memo.smh;
      isNdm = memo.ndm == Utils.getUserData().id;
      isSmh = memo.smh == Utils.getUserData().id;
      signature = Utils.generateByteData(memo.reqSignature ?? '');
      ndmSignature = Utils.generateByteData(memo.ndmSignature ?? '');
      smhSignature = Utils.generateByteData(memo.smhSignature ?? '');
      status = memo.status;
      firstLoad = false;
      setState(() {});

      if ((isNdm || isSmh) && action == MemoAct.approval) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Peringatan'),
              content: Text(
                'Memo ini memerlukan tanda tangan anda sebagai orang yang ${isNdm ? 'memeriksa' : 'menyetujui'} memo ini.\nApakah anda ingin menandatangani memo ini?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Tidak'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _scrollToItem(isNdm ? 'ndm' : 'smh');
                  },
                  child: const Text('Ya'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _scrollToItem(String key) {
    final context = _itemKeys[key]?.currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final offset = position.dy + _scrollController.offset;
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initKeys();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setLoading(true);
      Future.wait(<Future<void>>[
        getContacts(),
        getCustomerProduct(),
      ]).then((value) {
        var arg =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
        memoIcon = arg['memo'] as MemoIcon;
        action = arg['action'] as String;
        isEditMemo(arg['data']);
        if (!isEditing) {
          _memoController.text = generateNoMemo(memoIcon!.no);
        }
        setLoading(false);
      });
    });
  }

  @override
  void dispose() {
    // dispose all of the controllers
    _memoController.dispose();
    _makerController.dispose();
    _subjectController.dispose();
    _dateController.dispose();
    _officeAddressController.dispose();
    _officePhoneController.dispose();
    _warehouseAddressController.dispose();
    _warehousePICController.dispose();
    _warehousePhoneController.dispose();
    _reasonController.dispose();
    _withdrawalDateController.dispose();
    _companyNameController.dispose();
    _companyOwnerController.dispose();
    _companyOwnerIDController.dispose();
    _productReceivedDateController.dispose();
    _receiverAddressController.dispose();
    _warehouseReceiverController.dispose();
    _warehouseReceiverPhoneController.dispose();
    _supportController.dispose();
    _formKey.currentState?.dispose();
    _scrollController.dispose();
    _itemKeys.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: SafeArea(
          child: MemoShimmer(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('MEMO ${memoIcon!.name}'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(
            tag: memoIcon!.name,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back_ios),
                Center(
                  child: Icon(memoIcon!.icon),
                )
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleMemo(title: 'MEMO INTERNAL'),
                const SizedBox(height: 16),
                const LabelText(label: 'No Memo'),
                AppTextField(
                  readOnly: true,
                  controller: _memoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No Memo tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Dibuat Oleh'),
                AppTextField(
                  readOnly: true,
                  controller: _makerController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Dibuat oleh tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Ditujukan Kepada'),
                DropdownSelectableList(
                  enabled: action == MemoAct.create,
                  items: contacts,
                  displayItem: (item) => item.name,
                  onSelectionChanged: (selectedItems) {
                    selectedRecipient = selectedItems.map((e) => e.id).toList();
                  },
                  selectedItems: selectedContacts,
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Perihal'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _subjectController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Perihal tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Tanggal'),
                AppTextField(
                  controller: _dateController,
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Bersama ini kami sampaikan adanya Pengalihan Garam dengan rincian sbb :',
                ),
                const SizedBox(height: 16),
                const TitleMemo(title: 'DATA PENGALIHAN BARANG'),
                const SizedBox(height: 16),
                const LabelText(label: 'PIHAK YANG MENYERAHKAN'),
                const SizedBox(height: 16),
                const LabelText(label: 'Nama Perusahaan / Toko'),
                DropdownList<Customer>(
                  onChanged: action != MemoAct.create
                      ? null
                      : (value) {
                          selectedCustomer = value?.id ?? '';
                        },
                  items: custprod?.customers ?? [],
                  displayItem: (item) => item.name,
                  selectedItem: custprod?.customers.firstWhereOrNull(
                    (element) => element.id == selectedCustomer,
                  ),
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Alamat Kantor'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _officeAddressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat kantor tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'No Telp/ Handphone Kantor (Aktif)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _officePhoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No Telp/ Handphone Kantor tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Alamat Pengambilan Barang (Gudang)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _warehouseAddressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat pengambilan barang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Nama PIC Customer/ Jabatan (Gudang)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _warehousePICController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama PIC Customer/ Jabatan (Gudang) tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'No Telp/ Handphone Gudang (Aktif)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _warehousePhoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No Telp/ Handphone Gudang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Alasan Barang Dialihkan'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _reasonController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alasan barang dialihkan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Tanggal Penarikan Barang'),
                AppTextField(
                  controller: _withdrawalDateController,
                  readOnly: true,
                  onTap: action != MemoAct.create
                      ? null
                      : () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          ).then((value) {
                            if (value != null) {
                              _withdrawalDateController.text =
                                  value.toString().substring(0, 10);
                            }
                          });
                        },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal penarikan barang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'PIHAK PENERIMA BARANG'),
                const SizedBox(height: 16),
                const LabelText(label: 'Nama Perusahaan/ Toko'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _companyNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama perusahaan/ toko tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Nama Pemilik'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _companyOwnerController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama pemilik tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'No KTP Pemilik'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _companyOwnerIDController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No KTP pemilik tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Tanggal Barang Diterima'),
                AppTextField(
                  controller: _productReceivedDateController,
                  readOnly: true,
                  onTap: action != MemoAct.create
                      ? null
                      : () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          ).then((value) {
                            if (value != null) {
                              _productReceivedDateController.text =
                                  value.toString().substring(0, 10);
                            }
                          });
                        },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal barang diterima tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Alamat Penerima (Gudang)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _receiverAddressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat penerima tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Nama Penerima/ Jabatan (Gudang)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _warehouseReceiverController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama penerima/ jabatan (gudang) tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'No Telp/ Handphone Gudang (Aktif)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _warehouseReceiverPhoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No Telp/ Handphone Gudang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Support yang Diberikan (Bila Ada)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _supportController,
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'DESKRIPSI BARANG DIALIHKAN'),
                const SizedBox(height: 16),
                DropdownSelectableList<Product>(
                  enabled: action == MemoAct.create,
                  items: custprod?.products ?? [],
                  displayItem: (item) => item.name,
                  onSelectionChanged: (selectedItems) {
                    selectedProduct = selectedItems.map((e) => e.id).toList();
                  },
                  isContact: false,
                  selectedItems: custprod?.products.where((element) {
                    return selectedProduct.contains(element.id);
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Mohon untuk surat jalan bisa segera direvisi ke tujuan tersebut agar tidak terjadi kesalahan invoice dan pembayarannya.',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Demikian memo ini dibuat agar dapat digunakan sebagaimana mestinya. Terima kasih.',
                ),
                const SizedBox(height: 16),
                SignatureForm(
                  contacts: contacts,
                  ndmKey: _itemKeys['ndm'],
                  smhKey: _itemKeys['smh'],
                  onReqChanged: (value) {
                    selectedReq = value?.id ?? '';
                  },
                  onCheckerChanged: (value) {
                    selectedChecker = value?.id ?? '';
                  },
                  onApproverChanged: (value) {
                    selectedApprover = value?.id ?? '';
                  },
                  onSaveSignature: (value) {
                    signature = value;
                  },
                  onSaveNdmSignature: (value) {
                    ndmSignature = value;
                  },
                  onSaveSmhSignature: (value) {
                    smhSignature = value;
                  },
                  signatureData: signature,
                  ndmSignature: ndmSignature,
                  smhSignature: smhSignature,
                  selectedReq: selectedReq,
                  selectedApprover: selectedApprover,
                  selectedChecker: selectedChecker,
                  disabledContactReq: true,
                  disabledSignatureReq: action != MemoAct.create,
                  disabledContactChecker: action != MemoAct.create,
                  disabledSignatureChecker:
                      action != MemoAct.approval || !isNdm,
                  disabledContactApprover: action != MemoAct.create,
                  disabledSignatureApprover:
                      action != MemoAct.approval || !isSmh,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: action == MemoAct.received
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _saveMemo(context);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(isEditing ? 'Simpan Perubahan' : 'Simpan Memo'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
