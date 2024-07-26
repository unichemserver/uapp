import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/contact.dart';
import 'package:uapp/modules/memo/data/model/custprod.dart';
import 'package:uapp/modules/memo/data/model/memo_marcol.dart';
import 'package:uapp/modules/memo/memo_utils.dart';
import 'package:uapp/modules/memo/widget/content_editor_widget.dart';
import 'package:uapp/modules/memo/widget/dropdown_list.dart';
import 'package:uapp/modules/memo/widget/dropdown_selectable_list.dart';
import 'package:uapp/modules/memo/widget/label_text.dart';
import 'package:uapp/modules/memo/widget/memo_shimmer.dart';
import 'package:uapp/modules/memo/widget/signature_form.dart';
import 'package:uapp/modules/memo/widget/title_memo.dart';
import 'package:uapp/modules/memo/data/memo_api_service.dart' as api;

class MarketingCollateralMemo extends StatefulWidget {
  const MarketingCollateralMemo({super.key});

  @override
  State<MarketingCollateralMemo> createState() =>
      _MarketingCollateralMemoState();
}

class _MarketingCollateralMemoState extends State<MarketingCollateralMemo> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _itemKeys = {};
  final _formKey = GlobalKey<FormState>();

  final _memoController = TextEditingController(); // no
  final _makerController = TextEditingController(
    text: Utils.getUserData().nama,
  ); // pic
  List<String> selectedRecipient = []; // cc
  final _subjectController = TextEditingController(); // hal
  final _dateController = TextEditingController(
    text: DateTime.now().toString().substring(0, 10),
  ); // tgl
  final _programController = TextEditingController(); // program
  String selectedCustomer = ''; // cust
  final _marketingAreaController = TextEditingController(); // area
  final _fromDateController = TextEditingController(); // tgl_mulai
  final _toDateController = TextEditingController(); // tgl_selesai
  final _backgroundController = TextEditingController(); // latar_blkg
  String mechanism = ''; // mekanisme
  String selectedProduct = ''; // barang
  final _qtyController = TextEditingController(text: '0'); // qty
  final _receiverNameController = TextEditingController(); // penerima
  final _dateReceiverController = TextEditingController(
    text: DateTime.now().toString().substring(0, 10),
  ); // tgl_kirim
  final _receiverAddressController = TextEditingController(); // almt_kirim
  final _phoneController = TextEditingController(); // no_kirim
  final _senderAddressController = TextEditingController(); // alamat
  String selectedReq = Utils.getUserData().id; // userid
  String selectedKnownBy = ''; // msm
  String selectedChecker = ''; // ndm
  String selectedApprover = ''; // smh
  ByteData? signature; // req_signature
  ByteData? ndmSignature; // ndm_signature
  ByteData? smhSignature; // smh_signature
  String status = '0';

  List<Contact> contacts = [];
  Custprod? custprod;
  bool isEditing = false;
  bool isLoading = true;
  bool firstLoad = true;
  String action = MemoAct.create;
  List<Contact>? selectedContacts;
  MemoMarcol? memo;
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

  void routeToContentEditor() async {
    bool continueNavigation = true;
    if (mechanism.isNotEmpty) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Peringatan'),
            content: const Text(
                'Anda akan menghapus mekanisme yang sudah ada. Apakah anda ingin melanjutkan?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  continueNavigation = false;
                },
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () {
                  mechanism = '';
                  Navigator.pop(context);
                },
                child: const Text('Ya'),
              ),
            ],
          );
        },
      );
    }
    if (!continueNavigation) {
      return;
    }
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContentEditorWidget(
            onTextChanged: (text) {
              setState(() {
                mechanism = text;
              });
            },
          ),
        ),
      );
    }
  }

  void _saveMemo(BuildContext context) async {
    var data = MemoMarcol(
      no: _memoController.text,
      pic: _makerController.text,
      cc: selectedRecipient.join(','),
      hal: _subjectController.text,
      tgl: _dateController.text,
      program: _programController.text,
      cust: selectedCustomer,
      area: _marketingAreaController.text,
      tglMulai: _fromDateController.text,
      tglSelesai: _toDateController.text,
      latarBlkg: _backgroundController.text,
      mekanisme: mechanism,
      barang: selectedProduct,
      qty: _qtyController.text,
      penerima: _receiverNameController.text,
      tglKirim: _dateReceiverController.text,
      almtKirim: _receiverAddressController.text,
      noKirim: _phoneController.text,
      alamat: _senderAddressController.text,
      userid: selectedReq,
      msm: selectedKnownBy,
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
    api.saveMemo<MemoMarcol>(data, url).then((response) {
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

  void isEditMemo(MemoMarcol? memo) {
    if (memo != null && firstLoad) {
      isEditing = true;
      this.memo = memo;
      _memoController.text = memo.no;
      _makerController.text = memo.pic;
      _subjectController.text = memo.hal;
      _dateController.text = memo.tgl;

      _programController.text = memo.program;
      _marketingAreaController.text = memo.area;
      _fromDateController.text = memo.tglMulai;
      _toDateController.text = memo.tglSelesai;
      _backgroundController.text = memo.latarBlkg;
      _qtyController.text = memo.qty;
      _receiverNameController.text = memo.penerima;
      _dateReceiverController.text = memo.tglKirim;
      _senderAddressController.text = memo.alamat;
      _receiverAddressController.text = memo.almtKirim;
      _phoneController.text = memo.noKirim;

      selectedProduct = memo.barang;
      print('selectedProduct: $selectedProduct');
      selectedRecipient =
          memo.cc.contains(',') ? memo.cc.split(',') : [memo.cc];
      selectedCustomer = memo.cust;
      mechanism = memo.mekanisme;

      selectedReq = memo.userid;
      selectedKnownBy = memo.msm;
      selectedChecker = memo.ndm;
      selectedApprover = memo.smh;
      signature = Utils.generateByteData(memo.reqSignature ?? '');
      ndmSignature = Utils.generateByteData(memo.ndmSignature ?? '');
      smhSignature = Utils.generateByteData(memo.smhSignature ?? '');
      selectedContacts = contacts.where((element) {
        return selectedRecipient.contains(element.id);
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
    _programController.dispose();
    _marketingAreaController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    _backgroundController.dispose();
    _qtyController.dispose();
    _receiverNameController.dispose();
    _dateReceiverController.dispose();
    _receiverAddressController.dispose();
    _phoneController.dispose();
    _senderAddressController.dispose();
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
                const LabelText(label: 'Program'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _programController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Program tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Nama Customer'),
                DropdownList<Customer>(
                  onChanged: action != MemoAct.create
                      ? null
                      : (value) {
                          setState(() {
                            selectedCustomer = value?.id ?? '';
                          });
                        },
                  items: custprod?.customers ?? [],
                  displayItem: (item) => item.name,
                  selectedItem: custprod?.customers.firstWhereOrNull(
                      (element) => element.id == selectedCustomer),
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Area Pemasaran'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _marketingAreaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Area Marketing tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Periode'),
                // make two textfield in one row, wrap with expanded each
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _fromDateController,
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
                                  _fromDateController.text =
                                      date.toString().substring(0, 10);
                                }
                              },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppTextField(
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
                                  _toDateController.text =
                                      date.toString().substring(0, 10);
                                }
                              },
                        controller: _toDateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Latar Belakang'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _backgroundController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Latar belakang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Mekanisme'),
                GestureDetector(
                  onTap: action != MemoAct.create ? null : routeToContentEditor,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 1,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: mechanism.isNotEmpty
                        ? Html(data: mechanism)
                        : Container(
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              'Klik disini untuk menambahkan mekanisme',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Barang'),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownList<Product>(
                        onChanged: action != MemoAct.create
                            ? null
                            : (value) {
                                setState(() {
                                  selectedProduct = value?.id ?? '';
                                });
                              },
                        items: custprod?.products ?? [],
                        displayItem: (item) => item.name,
                        selectedItem: custprod!.products.firstWhereOrNull(
                          (element) => element.id == selectedProduct,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: AppTextField(
                        readOnly: action != MemoAct.create,
                        label: 'Qty',
                        controller: _qtyController,
                        keyboardType: TextInputType.number,
                        prefixIcon: IconButton(
                          onPressed: action != MemoAct.create
                              ? null
                              : () {
                                  if (selectedProduct.isEmpty) {
                                    Utils.showErrorSnackBar(context,
                                        'Pilih barang terlebih dahulu');
                                    return;
                                  }
                                  final currentValue =
                                      int.tryParse(_qtyController.text) ?? 0;
                                  if (currentValue > 0) {
                                    _qtyController.text =
                                        (currentValue - 1).toString();
                                  }
                                },
                          icon: const Icon(Icons.remove),
                        ),
                        suffixIcon: IconButton(
                          onPressed: action != MemoAct.create
                              ? null
                              : () {
                                  if (selectedProduct.isEmpty) {
                                    Utils.showErrorSnackBar(context,
                                        'Pilih barang terlebih dahulu');
                                    return;
                                  }
                                  final currentValue =
                                      int.tryParse(_qtyController.text) ?? 0;
                                  _qtyController.text =
                                      (currentValue + 1).toString();
                                },
                          icon: const Icon(Icons.add),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Qty tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const LabelText(label: 'Metode Pengiriman'),
                const SizedBox(height: 16),
                const LabelText(label: 'Nama Penerima'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _receiverNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama penerima tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Alamat Kirim'),
                AppTextField(
                  controller: _receiverAddressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat penerima tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'No. HP'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No. HP tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const LabelText(label: 'Diketahui Oleh'),
                DropdownList<Contact>(
                  onChanged: action != MemoAct.create
                      ? null
                      : (value) {
                          setState(() {
                            selectedKnownBy = value?.id ?? '';
                          });
                        },
                  items: contacts,
                  displayItem: (item) => item.name,
                  selectedItem: contacts.firstWhereOrNull(
                      (element) => element.id == selectedKnownBy),
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
                      : () async {
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
