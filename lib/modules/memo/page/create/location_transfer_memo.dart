import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/contact.dart';
import 'package:uapp/modules/memo/data/model/custprod.dart';
import 'package:uapp/modules/memo/data/model/memo_location_transfer.dart';
import 'package:uapp/modules/memo/memo_utils.dart';
import 'package:uapp/modules/memo/data/memo_api_service.dart' as api;
import 'package:uapp/modules/memo/widget/dropdown_selectable_list.dart';
import 'package:uapp/modules/memo/widget/label_text.dart';
import 'package:uapp/modules/memo/widget/memo_shimmer.dart';
import 'package:uapp/modules/memo/widget/signature_form.dart';
import 'package:uapp/modules/memo/widget/title_memo.dart';

class LocationTransferMemo extends StatefulWidget {
  const LocationTransferMemo({super.key});

  @override
  State<LocationTransferMemo> createState() => _LocationTransferMemoState();
}

class _LocationTransferMemoState extends State<LocationTransferMemo> {
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
  final _transferDateController = TextEditingController(); // ltgl
  String selectedCustomer = ''; // cust
  final _requestorController = TextEditingController(); // lreq
  final _senderWarehouseController = TextEditingController(); // lgdg_kirim
  final _receiverWarehouseController = TextEditingController(); // lgdg_terima
  List<String> selectedProduct = []; // ldesc_brg
  String selectedReq = Utils.getUserData().id; // userid
  String selectedChecker = ''; // ndm
  String selectedApprover = ''; // smh
  ByteData? signature; // req_signature
  ByteData? ndmSignature; // ndm_signature
  ByteData? smhSignature; // smh_signature
  String status = '0'; // status

  List<Contact> contacts = [];
  Custprod? custprod;
  String mechanism = '';
  List<Contact> selectedContacts = [];
  List<Product> selectedProducts = [];
  bool firstLoad = true;
  bool isEdit = false;
  bool isLoading = true;
  String action = MemoAct.create;
  MemoLocationTransfer? memo;
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
    MemoLocationTransfer data = MemoLocationTransfer(
      no: _memoController.text,
      pic: _makerController.text,
      cc: selectedRecipient.join(','),
      hal: _subjectController.text,
      tgl: _dateController.text,
      ltgl: _transferDateController.text,
      cust: selectedCustomer,
      lreq: _requestorController.text,
      lgdgKirim: _senderWarehouseController.text,
      lgdgTerima: _receiverWarehouseController.text,
      ldescBrg: selectedProduct.join(','),
      userid: selectedReq,
      ndm: selectedChecker,
      smh: selectedApprover,
      reqSignature: Utils.generateBase64Image(signature!) ?? '',
      ndmSignature: Utils.generateBase64Image(ndmSignature!) ?? '',
      smhSignature: Utils.generateBase64Image(smhSignature!) ?? '',
      status: status,
    );
    if (isEdit) {
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
    if (isEdit) {
      url = url + '?&updateMemo';
    }
    api.saveMemo<MemoLocationTransfer>(data, url).then((response) {
      Navigator.pop(context);
      if (response == null) {
        _formKey.currentState?.reset();
        Navigator.pop(context);
        String message =
            isEdit ? 'Memo berhasil diubah' : 'Memo berhasil disimpan';
        Utils.showSuccessSnackBar(context, message);
        if (isEdit) {
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

  void isEditMemo(MemoLocationTransfer? memo) {
    if (memo != null && firstLoad) {
      isEdit = true;
      this.memo = memo;
      _memoController.text = memo.no;
      _makerController.text = memo.pic;
      _subjectController.text = memo.hal;
      _dateController.text = memo.tgl;
      _transferDateController.text = memo.ltgl;
      _requestorController.text = memo.lreq;
      _senderWarehouseController.text = memo.lgdgKirim;
      _receiverWarehouseController.text = memo.lgdgTerima;
      selectedProduct = memo.ldescBrg.contains(',')
          ? memo.ldescBrg.split(',')
          : [memo.ldescBrg];

      selectedRecipient =
          memo.cc.contains(',') ? memo.cc.split(',') : [memo.cc];
      selectedCustomer = memo.cust;

      selectedReq = memo.userid;
      selectedChecker = memo.ndm;
      selectedApprover = memo.smh;
      signature = Utils.generateByteData(memo.reqSignature ?? '');
      ndmSignature = Utils.generateByteData(memo.ndmSignature ?? '');
      smhSignature = Utils.generateByteData(memo.smhSignature ?? '');
      selectedContacts = contacts.where((element) {
        return selectedRecipient.contains(element.id);
      }).toList();
      selectedProducts = custprod!.products.where((element) {
        return selectedProduct.contains(element.id);
      }).toList();
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
        if (!isEdit) {
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
    _transferDateController.dispose();
    _requestorController.dispose();
    _senderWarehouseController.dispose();
    _receiverWarehouseController.dispose();
    _itemKeys.clear();
    _formKey.currentState?.dispose();
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
                  controller: _makerController,
                  readOnly: true,
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
                  'Bersama ini kami sampaikan pengajuan Location Transfer Produk, dengan rincian sbb :',
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Tanggal Location Transfer'),
                AppTextField(
                  controller: _transferDateController,
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
                            _transferDateController.text =
                                date.toString().substring(0, 10);
                          }
                        },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal Location Transfer tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Requestor (Nama, Jabatan)'),
                AppTextField(
                  controller: _requestorController,
                  readOnly: action != MemoAct.create,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requestor tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Lokasi Gudang Pengirim'),
                AppTextField(
                  controller: _senderWarehouseController,
                  readOnly: action != MemoAct.create,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lokasi Gudang Pengirim tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Lokasi Gudang Penerima'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _receiverWarehouseController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lokasi Gudang Penerima tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Deskripsi Item Barang'),
                DropdownSelectableList<Product>(
                  enabled: action == MemoAct.create,
                  items: custprod?.products ?? [],
                  displayItem: (item) => item.name,
                  onSelectionChanged: (selectedItems) {
                    selectedProduct = selectedItems.map((e) => e.id).toList();
                  },
                  isContact: false,
                  selectedItems: selectedProducts,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Note: Apabila Item Barang tidak tersedia, mohon dibantu untuk diproduksi segera.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Demikian Memo ini diajukan agar dapat digunakan sebagaimana semestinya.\nAtas perhatian dan kerjasamanya kami ucapkan terima kasih.',
                  textAlign: TextAlign.start,
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
                  child: const Text('Kirim'),
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
