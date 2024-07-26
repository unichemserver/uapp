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
import 'package:uapp/modules/memo/data/model/memo_retur.dart';
import 'package:uapp/modules/memo/memo_utils.dart';
import 'package:uapp/modules/memo/widget/dropdown_list.dart';
import 'package:uapp/modules/memo/widget/dropdown_selectable_list.dart';
import 'package:uapp/modules/memo/widget/label_text.dart';
import 'package:uapp/modules/memo/widget/memo_shimmer.dart';
import 'package:uapp/modules/memo/widget/signature_form.dart';
import 'package:uapp/modules/memo/widget/title_memo.dart';
import 'package:uapp/modules/memo/data/memo_api_service.dart' as api;

class ReturMemo extends StatefulWidget {
  const ReturMemo({super.key});

  @override
  State<ReturMemo> createState() => _ReturMemoState();
}

class _ReturMemoState extends State<ReturMemo> {
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
  String selectedCompany = ''; // cust
  final _companyAddressController = TextEditingController(); // almtPers
  final _companyNameController = TextEditingController(); // upers
  final _officeAddressController = TextEditingController(); // ualamat
  final _warehouseAddressController = TextEditingController(); // ualamatGdg
  final _customerNameController = TextEditingController(); // upic
  final _phoneController = TextEditingController(); // utelp
  final _reasonController = TextEditingController(); // ualasan
  final _withdrawalDateController = TextEditingController(); // utglTarik
  List<Product> withdrawProducts = []; // udescBrg
  final _recipientController = TextEditingController(); // nmaPers
  int selectedAddress = 0; // almtKntr
  String selectedReq = Utils.getUserData().id; // userid
  String selectedChecker = ''; // ndm
  String selectedApprover = ''; // smh
  ByteData? signature; // reqSignature
  ByteData? ndmSignature; // ndmSignature
  ByteData? smhSignature; // smhSignature
  String status = '0';

  List<Contact> contacts = [];
  Custprod? custprod;
  bool firstLoad = true;
  bool isEditing = false;
  bool isLoading = true;
  String action = MemoAct.create;
  MemoRetur? memo;
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
    var data = MemoRetur(
      no: _memoController.text,
      pic: _makerController.text,
      cc: selectedRecipient.join(','),
      hal: _subjectController.text,
      tgl: _dateController.text,
      cust: selectedCompany,
      almtPers: _companyAddressController.text,
      upers: _companyNameController.text,
      ualamat: _officeAddressController.text,
      ualamatGdg: _warehouseAddressController.text,
      upic: _customerNameController.text,
      utelp: _phoneController.text,
      ualasan: _reasonController.text,
      utglTarik: _withdrawalDateController.text,
      udescBrg: withdrawProducts.map((e) => e.id).join(','),
      nmaPers: _recipientController.text,
      almtKntr: selectedAddress.toString(),
      userid: selectedReq,
      ndm: selectedChecker,
      smh: selectedApprover,
      reqSignature: Utils.generateBase64Image(signature!) ?? '',
      ndmSignature: Utils.generateBase64Image(ndmSignature!) ?? '',
      smhSignature: Utils.generateBase64Image(smhSignature!) ?? '',
      status: status,
    );
    if (isEditing) {
      data.id = memo?.id;
    }
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
    api.saveMemo<MemoRetur>(data, url).then((response) {
      Navigator.pop(context);
      if (response == null) {
        _formKey.currentState?.reset();
        Navigator.pop(context);
        String message =
            isEditing ? 'Memo berhasil diubah' : 'Memo berhasil disimpan';
        Utils.showSuccessSnackBar(context, message);
        if (isEditing) {
          Navigator.pop(context);
        }
      } else {
        Utils.showErrorSnackBar(context, 'Gagal menyimpan memo');
      }
    }).catchError((error) {
      Navigator.pop(context);
      Utils.showErrorSnackBar(context, 'Gagal menyimpan memo');
    });
  }

  void isEditMemo(MemoRetur? memo) {
    if (memo != null && firstLoad) {
      isEditing = true;
      this.memo = memo;
      _memoController.text = memo.no;
      _makerController.text = memo.pic;
      _subjectController.text = memo.hal;
      _dateController.text = memo.tgl;

      selectedRecipient =
          memo.cc.contains(',') ? memo.cc.split(',') : [memo.cc];
      selectedCompany = memo.cust;
      _companyAddressController.text = memo.almtPers;
      _companyNameController.text = memo.upers;
      _officeAddressController.text = memo.ualamat;
      _warehouseAddressController.text = memo.ualamatGdg;
      _customerNameController.text = memo.upic;
      _phoneController.text = memo.utelp;
      _reasonController.text = memo.ualasan;

      selectedReq = memo.userid;
      selectedChecker = memo.ndm;
      selectedApprover = memo.smh;
      signature = Utils.generateByteData(memo.reqSignature ?? '');
      ndmSignature = Utils.generateByteData(memo.ndmSignature ?? '');
      smhSignature = Utils.generateByteData(memo.smhSignature ?? '');
      status = memo.status;

      isNdm = memo.ndm == Utils.getUserData().id;
      isSmh = memo.smh == Utils.getUserData().id;
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
    _scrollController.dispose();
    _memoController.dispose();
    _makerController.dispose();
    _subjectController.dispose();
    _dateController.dispose();
    _companyAddressController.dispose();
    _companyNameController.dispose();
    _officeAddressController.dispose();
    _warehouseAddressController.dispose();
    _customerNameController.dispose();
    _phoneController.dispose();
    _reasonController.dispose();
    _withdrawalDateController.dispose();
    _recipientController.dispose();
    _formKey.currentState?.dispose();
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
                const LabelText(label: 'No. Memo'),
                AppTextField(
                  readOnly: true,
                  controller: _memoController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'No. Memo tidak boleh kosong';
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
                DropdownSelectableList<Contact>(
                  items: contacts,
                  displayItem: (item) => item.name,
                  onSelectionChanged: (selectedItems) {
                    selectedRecipient = selectedItems.map((e) => e.id).toList();
                  },
                  selectedItems: contacts
                      .where(
                          (element) => selectedRecipient.contains(element.id))
                      .toList(),
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
                  'Bersama ini kami sampaikan pengajuan retur barang dari customer ke PT. UnichemCandi Indonesia dengan rincian :',
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Nama Perusahaan/Toko'),
                DropdownList<Customer>(
                  onChanged: action != MemoAct.create
                      ? null
                      : (value) {
                          selectedCompany = value?.id ?? '';
                          _companyAddressController.text = value?.address ?? '';
                        },
                  items: custprod?.customers ?? [],
                  displayItem: (item) => item.name,
                  selectedItem: custprod?.customers.firstWhereOrNull(
                      (element) => element.id == selectedCompany),
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Alamat'),
                AppTextField(
                  readOnly: true,
                  controller: _companyAddressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                  maxLines: null,
                ),
                const SizedBox(height: 32),
                const TitleMemo(title: 'DATA PENARIKAN BARANG'),
                const SizedBox(height: 16),
                const LabelText(label: 'PIHAK YANG MENYERAHKAN'),
                const SizedBox(height: 16),
                const LabelText(label: 'Nama Perusahaan'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _companyNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama perusahaan tidak boleh kosong';
                    }
                    return null;
                  },
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
                const LabelText(label: 'Alamat Pengambilan Barang (Gudang)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _warehouseAddressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat gudang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Nama PIC Customer/Jabatan'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _customerNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama PIC tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'No Telp/Handphone (Aktif)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No. Telp/Handphone tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Alasan Retur'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _reasonController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alasan retur tidak boleh kosong';
                    }
                    return null;
                  },
                  maxLines: null,
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Tanggal Penarikan Barang'),
                AppTextField(
                  readOnly: true,
                  onTap: action != MemoAct.create
                      ? null
                      : () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            _withdrawalDateController.text =
                                date.toString().substring(0, 10);
                          }
                        },
                  controller: _withdrawalDateController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal penarikan barang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Deskripsi Barang yang di Retur'),
                DropdownSelectableList<Product>(
                  enabled: action == MemoAct.create,
                  items: custprod?.products ?? [],
                  displayItem: (item) => item.name,
                  onSelectionChanged: (selectedItems) {
                    withdrawProducts = selectedItems;
                  },
                  selectedItems: custprod?.products
                      .where((element) => withdrawProducts
                          .map((e) => e.id)
                          .contains(element.id))
                      .toList(),
                  isContact: false,
                ),
                const SizedBox(height: 32),
                const LabelText(label: 'PIHAK PENERIMA BARANG'),
                const SizedBox(height: 16),
                const LabelText(label: 'Nama Perusahaan/Toko'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _recipientController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama perusahaan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Alamat Kantor'),
                DropdownList<String>(
                  onChanged: action != MemoAct.create
                      ? null
                      : (value) {
                          selectedAddress = officeAddress.indexOf(value!);
                        },
                  items: officeAddress,
                  displayItem: (item) => item,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Mohon agar dapat diproses penarikan barang & penyelesaian administrasinya, agar dapat memotong outstanding piutang customer tersebut.',
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
                  child: Text(isEditing ? 'Edit Memo' : 'Simpan Memo'),
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
