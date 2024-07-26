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
import 'package:uapp/modules/memo/data/memo_api_service.dart' as api;
import 'package:uapp/modules/memo/data/model/custprod.dart';
import 'package:uapp/modules/memo/data/model/memo_regular.dart';
import 'package:uapp/modules/memo/memo_utils.dart';
import 'package:uapp/modules/memo/widget/content_editor_widget.dart';
import 'package:uapp/modules/memo/widget/dropdown_list.dart';
import 'package:uapp/modules/memo/widget/dropdown_selectable_list.dart';
import 'package:uapp/modules/memo/widget/label_text.dart';
import 'package:uapp/modules/memo/widget/memo_shimmer.dart';
import 'package:uapp/modules/memo/widget/signature_form.dart';
import 'package:uapp/modules/memo/widget/title_memo.dart';

class RegularMemo extends StatefulWidget {
  const RegularMemo({super.key});

  @override
  State<RegularMemo> createState() => _RegularMemoState();
}

class _RegularMemoState extends State<RegularMemo> {
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
  final _areaController = TextEditingController(); // area
  final _fromController = TextEditingController(); // tglMulai
  final _toController = TextEditingController(); // tglSelesai
  final _backgroundController = TextEditingController(); // latarBlkg
  final _objectiveController = TextEditingController(); // sasaran
  String selectedProduct = ''; // produk
  final _startingPriceController = TextEditingController(); // hrgAwal
  final _marketingCostController = TextEditingController(); // disc
  final _priceAfterDiscountController = TextEditingController(); // hrgAkhir
  final _salesEstimationInRpController = TextEditingController(); // estInRp
  final _salesEstimationInTonController = TextEditingController(); // estInTon
  final _salesEstimationTotalController =
      TextEditingController(); // estTotalBiaya
  final _costRatioController = TextEditingController(); // costRatio
  String selectedReq = Utils.getUserData().id; // userid
  String selectedChecker = ''; // ndm
  String selectedApprover = ''; // smh
  ByteData? signature; // reqSignature
  ByteData? ndmSignature; // ndmSignature
  ByteData? smhSignature; // smhSignature
  String status = '0'; // status

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _itemKeys = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Contact> contacts = [];
  Custprod? custprod;
  String mechanism = '';
  String selectedCustomer = ''; // cust
  bool firstLoad = true;
  bool isEditing = false;
  bool isLoading = true;
  String action = MemoAct.create;
  MemoRegular? memo;
  MemoIcon? memoIcon;
  bool isNdm = false;
  bool isSmh = false;

  void _calculateAll() {
    _calculateHrgAkhir();
    _calculateEstInRp();
    _calculateEstTotalBiaya();
    _calculateCostRatio();
  }

  void _calculateCostRatio() {
    final estTotalBiaya = int.tryParse(
            _marketingCostController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final estInTon = int.tryParse(_salesEstimationInTonController.text
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final hrgAwal = int.tryParse(
            _startingPriceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;

    final costRatio = estInTon != 0 && hrgAwal != 0
        ? (estTotalBiaya / (hrgAwal * estInTon) * 100 / 100)
        : 0;

    _costRatioController.text = costRatio.toString();
  }

  void _calculateEstInRp() {
    final estInTon = int.tryParse(_salesEstimationInTonController.text
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final hrgAkhir = int.tryParse(_priceAfterDiscountController.text
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;

    final estInRp = estInTon * hrgAkhir;

    _salesEstimationInRpController.text = Utils.formatCurrency(estInRp.toString());
  }

  void _calculateEstTotalBiaya() {
    final estInTon = int.tryParse(_salesEstimationInTonController.text
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final hrgAwal = int.tryParse(
            _startingPriceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final estInRp = int.tryParse(_salesEstimationInRpController.text
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;

    final estTotalBiaya = (hrgAwal * estInTon) - estInRp;

    _salesEstimationTotalController.text = Utils.formatCurrency(estTotalBiaya.toString());
  }

  void _calculateHrgAkhir() {
    final hrgAwal = int.tryParse(
            _startingPriceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final disc = int.tryParse(
            _marketingCostController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;

    final hrgAkhir = hrgAwal - disc;

    _priceAfterDiscountController.text = Utils.formatCurrency(hrgAkhir.toString());
  }

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
    // regex only take number and point
    var regex = RegExp(r'^[0-9]+(\.[0-9]+)?$');
    var data = MemoRegular(
      no: _memoController.text,
      pic: _makerController.text,
      cc: selectedRecipient.join(','),
      hal: _subjectController.text,
      tgl: _dateController.text,
      program: _programController.text,
      cust: selectedCustomer,
      area: _areaController.text,
      tglMulai: _fromController.text,
      tglSelesai: _toController.text,
      latarBlkg: _backgroundController.text,
      sasaran: _objectiveController.text,
      produk: selectedProduct,
      mekanisme: mechanism,
      hrgAwal: _startingPriceController.text.replaceAll(regex, ''),
      disc: _marketingCostController.text.replaceAll(regex, ''),
      hrgAkhir: _priceAfterDiscountController.text.replaceAll(regex, ''),
      estInRp: _salesEstimationInRpController.text.replaceAll(regex, ''),
      estInTon: _salesEstimationInTonController.text.replaceAll(regex, ''),
      estTotalBiaya: _salesEstimationTotalController.text.replaceAll(regex, ''),
      costRatio: _costRatioController.text.replaceAll(regex, ''),
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
    api.saveMemo<MemoRegular>(data, url).then((response) {
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

  void isEditMemo(MemoRegular? memo) {
    if (memo != null && firstLoad) {
      isEditing = true;
      this.memo = memo;
      _memoController.text = memo.no;
      _makerController.text = memo.pic;
      selectedRecipient = memo.cc.split(',');
      _subjectController.text = memo.hal;
      _dateController.text = memo.tgl;
      _programController.text = memo.program;
      _areaController.text = memo.area;
      _fromController.text = memo.tglMulai;
      _toController.text = memo.tglSelesai;
      _backgroundController.text = memo.latarBlkg;
      _objectiveController.text = memo.sasaran;
      selectedProduct = memo.produk;
      selectedCustomer = memo.cust;
      mechanism = memo.mekanisme;
      _startingPriceController.text = memo.hrgAwal;
      _marketingCostController.text = memo.disc;
      _priceAfterDiscountController.text = memo.hrgAkhir;
      _salesEstimationInRpController.text = memo.estInRp;
      _salesEstimationInTonController.text = memo.estInTon;
      _salesEstimationTotalController.text = memo.estTotalBiaya;
      _costRatioController.text = memo.costRatio;
      selectedReq = memo.userid;
      selectedChecker = memo.ndm;
      selectedApprover = memo.smh;
      status = memo.status;
      firstLoad = false;
      isNdm = memo.ndm == Utils.getUserData().id;
      isSmh = memo.smh == Utils.getUserData().id;
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
    _startingPriceController.addListener(_calculateAll);
    _marketingCostController.addListener(_calculateAll);
    _salesEstimationInTonController.addListener(_calculateAll);
  }

  @override
  void dispose() {
    _memoController.dispose();
    _makerController.dispose();
    _subjectController.dispose();
    _dateController.dispose();
    _programController.dispose();
    _areaController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _backgroundController.dispose();
    _objectiveController.dispose();
    _startingPriceController.dispose();
    _marketingCostController.dispose();
    _priceAfterDiscountController.dispose();
    _salesEstimationInRpController.dispose();
    _salesEstimationInTonController.dispose();
    _salesEstimationTotalController.dispose();
    _costRatioController.dispose();
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
        padding: const EdgeInsets.all(16),
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
                  items: custprod?.customers ?? [],
                  displayItem: (item) => item.name,
                  onChanged: action != MemoAct.create
                      ? null
                      : (value) {
                          selectedCustomer = value?.id ?? '';
                        },
                  warningText: 'Nama customer tidak boleh kosong',
                  selectedItem: custprod?.customers.firstWhereOrNull(
                      (element) => element.id == selectedCustomer),
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Area Pemasaran'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _areaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Area pemasaran tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Periode Program'),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        hintText: 'Dari',
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
                                  _fromController.text =
                                      date.toString().substring(0, 10);
                                }
                              },
                        readOnly: true,
                        controller: _fromController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Periode program tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: AppTextField(
                        hintText: 'Sampai',
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
                                  _toController.text =
                                      date.toString().substring(0, 10);
                                }
                              },
                        readOnly: true,
                        controller: _toController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Periode program tidak boleh kosong';
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
                      return 'Latar belakan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Sasaran'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _objectiveController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Sasaran tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Item Produk'),
                DropdownList<Product>(
                  items: custprod?.products ?? [],
                  displayItem: (item) => item.name,
                  onChanged: (value) {
                    selectedProduct = value?.id ?? '';
                  },
                  warningText: 'Item produk tidak boleh kosong',
                  selectedItem: custprod?.products.firstWhereOrNull(
                      (element) => element.id == selectedProduct),
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Mekanisme'),
                GestureDetector(
                  onTap: action != MemoAct.create ? null : routeToContentEditor,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 1,
                    ),
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
                const Divider(),
                const SizedBox(height: 16),
                const LabelText(label: 'Harga Awal (per Kg)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _startingPriceController,
                  onChanged: (value) {
                    var newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (newValue.isEmpty) {
                      _startingPriceController.clear();
                      return;
                    }
                    _startingPriceController.text = Utils.formatCurrency(newValue);
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Marketing Cost (per Kg)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _marketingCostController,
                  onChanged: (value) {
                    var newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (newValue.isEmpty) {
                      _marketingCostController.clear();
                      return;
                    }
                    _marketingCostController.text = Utils.formatCurrency(newValue);
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Harga Setelah Diskon (per Kg)'),
                AppTextField(
                  controller: _priceAfterDiscountController,
                  readOnly: true,
                  onChanged: (value) {
                    var newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (newValue.isEmpty) {
                      _priceAfterDiscountController.clear();
                      return;
                    }
                    _priceAfterDiscountController.text = Utils.formatCurrency(newValue);
                  },
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const LabelText(label: 'Estimasi Penjualan (Rp)'),
                AppTextField(
                  controller: _salesEstimationInRpController,
                  readOnly: true,
                  onChanged: (value) {
                    var newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (newValue.isEmpty) {
                      _salesEstimationInRpController.clear();
                      return;
                    }
                    _salesEstimationInRpController.text = Utils.formatCurrency(newValue);
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Estimasi Penjualan (Ton)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _salesEstimationInTonController,
                  onChanged: (value) {
                    var newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (newValue.isEmpty) {
                      _salesEstimationInTonController.clear();
                      return;
                    }
                    var regex = RegExp(r'\B(?=(\d{3})+(?!\d))');
                    var formattedValue = newValue.replaceAll(regex, '.');
                    _salesEstimationInTonController.text = formattedValue;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Estimasi Penjualan Total'),
                AppTextField(
                  readOnly: true,
                  controller: _salesEstimationTotalController,
                  onChanged: (value) {
                    var newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (newValue.isEmpty) {
                      _salesEstimationTotalController.clear();
                      return;
                    }
                    _salesEstimationTotalController.text = Utils.formatCurrency(newValue);
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Cost Ratio'),
                AppTextField(
                  readOnly: true,
                  controller: _costRatioController,
                ),
                const SizedBox(height: 16),
                const Divider(),
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
                          if (_formKey.currentState!.validate()) {
                            _saveMemo(context);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(isEditing ? 'Simpan Perubahan' : 'Simpan Memo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
