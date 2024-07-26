import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/contact.dart';
import 'package:uapp/modules/memo/data/model/cust_sybase.dart';
import 'package:uapp/modules/memo/data/model/custprod.dart';
import 'package:uapp/modules/memo/data/model/memo_target.dart';
import 'package:uapp/modules/memo/data/model/pajak_penghasilan.dart';
import 'package:uapp/modules/memo/memo_utils.dart';
import 'package:uapp/modules/memo/widget/content_editor_widget.dart';
import 'package:uapp/modules/memo/widget/dropdown_list.dart';
import 'package:uapp/modules/memo/widget/dropdown_selectable_list.dart';
import 'package:uapp/modules/memo/widget/label_text.dart';
import 'package:uapp/modules/memo/widget/memo_shimmer.dart';
import 'package:uapp/modules/memo/widget/signature_form.dart';
import 'package:uapp/modules/memo/widget/title_memo.dart';
import 'package:uapp/modules/memo/data/memo_api_service.dart' as api;
import '../../../../core/utils/utils.dart';

class TargetMemo extends StatefulWidget {
  const TargetMemo({super.key});

  @override
  State<TargetMemo> createState() => _TargetMemoState();
}

class _TargetMemoState extends State<TargetMemo> {
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
  final _programController = TextEditingController(); // program
  String selectedCustomer = ''; // cust
  final _areaController = TextEditingController(); // area
  final _fromController = TextEditingController(); // tglMulai
  final _toController = TextEditingController(); // tglSelesai
  final _backgroundController = TextEditingController(); // latarBlkg
  final _objectiveController = TextEditingController(); // sasaran
  String selectedProduct = ''; // produk
  String mechanism = ''; // mekanisme
  final _startingPriceController = TextEditingController(); // hrgAwal
  final _marketingCostController = TextEditingController(); // disc
  final _priceAfterDiscountController = TextEditingController(); // hrgAkhir
  final _salesEstimationInRpController = TextEditingController(); // estInRp
  final _salesEstimationInTonController = TextEditingController(); // estInTon
  final _totalCostEstimationController =
      TextEditingController(); // estTotalBiaya
  final _taxValueEstimationController =
      TextEditingController(); // estNilaiPajak
  final _costRatioController = TextEditingController(); // costRatio
  String selectedReq = Utils.getUserData().id; // userid
  String selectedChecker = ''; // ndm
  String selectedApprover = ''; // smh
  ByteData? reqSignature; // reqSignature
  ByteData? ndmSignature; // ndmSignature
  ByteData? smhSignature; // smhSignature
  String status = '1'; // status

  List<Contact> contacts = [];
  List<PajakPenghasilan> pajak = [];
  Custprod? custprod;
  List<CustSybase> custSybase = [];

  bool isEditing = false;
  bool isLoading = true;
  bool firstLoad = true;
  bool stillTakingDataCustomer = true;
  String action = MemoAct.create;
  MemoTarget? memo;
  MemoIcon? memoIcon;
  bool isNdm = false;
  bool isSmh = false;
  String statusNpwp = '0';
  String showSelectedCustomer = '';

  getContacts() async {
    contacts = await DatabaseHelper().getAllContact();
    setState(() {});
  }

  getCustomerProduct() async {
    custprod = await api.getCustprod(Utils.getBaseUrl());
    setState(() {});
  }

  getTaxValue() async {
    pajak = await api.getPajaPenghasilan(Utils.getBaseUrl());
    setState(() {});
  }

  getListCustomer() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mengambil data customer...'),
        duration: Duration(minutes: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
    api.getCustomer().then((value) {
      custSybase = value;
      stillTakingDataCustomer = false;
      setState(() {});
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }).catchError((error) {
      stillTakingDataCustomer = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengambil data customer'),
        ),
      );
    });
  }

  void _saveMemo(BuildContext context) async {
    var data = MemoTarget(
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
      hrgAwal: _startingPriceController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      disc: _marketingCostController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      hrgAkhir:
          _priceAfterDiscountController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      estInRp:
          _salesEstimationInRpController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      estInTon: _salesEstimationInTonController.text,
      estTotalBiaya:
          _totalCostEstimationController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      estNilaiPajak:
          _taxValueEstimationController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      costRatio: _costRatioController.text,
      userid: selectedReq,
      ndm: selectedChecker,
      smh: selectedApprover,
      reqSignature: Utils.generateBase64Image(reqSignature!) ?? '',
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
    api.saveMemo<MemoTarget>(data, url).then((response) {
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

  void setLoading(bool value) {
    isLoading = value;
    setState(() {});
  }

  void _initKeys() {
    _itemKeys['ndm'] = GlobalKey();
    _itemKeys['smh'] = GlobalKey();
  }

  void isEditMemo(MemoTarget? memo) {
    if (memo != null && firstLoad) {
      this.memo = memo;
      isEditing = true;

      _memoController.text = memo.no;
      _makerController.text = memo.pic;
      selectedRecipient = memo.cc.contains(',')
          ? memo.cc.split(',').map((e) => e.trim()).toList()
          : [memo.cc];
      _subjectController.text = memo.hal;
      _dateController.text = memo.tgl;
      _programController.text = memo.program;
      selectedCustomer = memo.cust;
      _areaController.text = memo.area;
      _fromController.text = memo.tglMulai;
      _toController.text = memo.tglSelesai;
      _backgroundController.text = memo.latarBlkg;
      _objectiveController.text = memo.sasaran;
      selectedProduct = memo.produk;
      mechanism = memo.mekanisme;
      _startingPriceController.text = memo.hrgAwal;
      _marketingCostController.text = memo.disc;
      _priceAfterDiscountController.text = memo.hrgAkhir;
      _salesEstimationInRpController.text = memo.estInRp;
      _salesEstimationInTonController.text = memo.estInTon;
      _taxValueEstimationController.text = memo.estTotalBiaya;
      _costRatioController.text = memo.costRatio;
      selectedReq = memo.userid;
      selectedChecker = memo.ndm;
      selectedApprover = memo.smh;
      reqSignature = Utils.generateByteData(memo.reqSignature ?? '');
      ndmSignature = Utils.generateByteData(memo.ndmSignature ?? '');
      smhSignature = Utils.generateByteData(memo.smhSignature ?? '');
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

  void _calculateCostRatio() {
    final etb = double.tryParse(_totalCostEstimationController.text
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final hga = double.tryParse(
            _startingPriceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final eit = double.tryParse(_salesEstimationInTonController.text
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;

    double costRatio = 0;
    if (hga > 0 && eit > 0) {
      costRatio = etb / (hga * eit);
      // Periksa jika costRatio adalah NaN
      if (costRatio.isNaN) costRatio = 0;
    }

    _costRatioController.text =
        costRatio.toStringAsFixed(2); // Format untuk dua desimal
  }

  void _calculateTaxValue() {
    final etb = double.tryParse(_totalCostEstimationController.text
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    double totalPajak = 0;

    for (final pajakItem in pajak) {
      final tarif = pajakItem.tarif;
      final pajakItemValue = etb * (0.50 * (double.parse(tarif) / 100));

      if (statusNpwp == '0') {
        totalPajak += pajakItemValue * 1.20; // Jika NPWP = 0, tambahkan 20%
      } else {
        totalPajak += pajakItemValue; // Jika NPWP != 0
      }

      if (etb < double.parse(pajakItem.nilaiAkhir)) {
        break; // Keluar dari loop jika etb lebih kecil dari nilai_akhir
      }
    }

    // Periksa jika totalPajak adalah NaN
    if (totalPajak.isNaN) totalPajak = 0;

    _taxValueEstimationController.text = Utils.formatCurrency(totalPajak.toInt().toString());
        // totalPajak.toStringAsFixed(2); // Format untuk dua desimal
  }

  void _calculateSalesEstimationInRp() {
    final eit = double.tryParse(_salesEstimationInTonController.text
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final hgk = double.tryParse(_priceAfterDiscountController.text
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final val = eit * hgk;
    
    _salesEstimationInRpController.text = Utils.formatCurrency(val.toInt().toString());
        // val.toStringAsFixed(2); // Format untuk dua desimal
  }

  void _calculateTotalCostEstimation() {
    final eit = double.tryParse(_salesEstimationInTonController.text
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final hga = double.tryParse(
            _startingPriceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final eir = double.tryParse(_salesEstimationInRpController.text
            .replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;

    double totalCost = (hga * eit) - eir;
    // Periksa jika totalCost adalah NaN
    if (totalCost.isNaN) totalCost = 0;

    _totalCostEstimationController.text = Utils.formatCurrency(totalCost.toInt().toString());
    // totalCost.toStringAsFixed(2);

    // Hitung rasio biaya dan nilai pajak setelah menghitung total biaya
    _calculateCostRatio();
    _calculateTaxValue();
  }

  void _calculatePriceAfterDiscount() {
    final hga = double.tryParse(
            _startingPriceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final dsc = double.tryParse(
            _marketingCostController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final val = hga - dsc;

    _priceAfterDiscountController.text = Utils.formatCurrency(val.toInt().toString());
  }

  @override
  void initState() {
    super.initState();
    _initKeys();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setLoading(true);
      getListCustomer();
      Future.wait(<Future<void>>[
        getContacts(),
        getCustomerProduct(),
        getTaxValue(),
      ]).then((value) {
        var arg =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
        memoIcon = arg['memo'] as MemoIcon;
        action = arg['action'] as String;
        isEditMemo(arg['data']);
        if (!isEditing) {
          _memoController.text = generateNoMemo(memoIcon!.no);
        }
        _startingPriceController.addListener(_calculatePriceAfterDiscount);
        _marketingCostController.addListener(_calculatePriceAfterDiscount);
        _salesEstimationInTonController
            .addListener(_calculateSalesEstimationInRp);
        _priceAfterDiscountController
            .addListener(_calculateSalesEstimationInRp);
        _salesEstimationInTonController
            .addListener(_calculateTotalCostEstimation);
        _salesEstimationInRpController
            .addListener(_calculateTotalCostEstimation);
        _totalCostEstimationController.addListener(_calculateCostRatio);
        setLoading(false);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _formKey.currentState?.dispose();
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
    _taxValueEstimationController.dispose();
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
                Icon(memoIcon!.icon),
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
                const TitleMemo(
                    title: 'MEMO INTERNAL\nTARGET A - PROMO PENCAPAIAN TARGET'),
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
                DropdownSelectableList<Contact>(
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
                DropdownList<CustSybase>(
                  items: stillTakingDataCustomer
                      ? [
                          CustSybase(
                            custID: '',
                            custname: 'Memuat data...',
                            description: '',
                            taxid: '',
                            groupaId: '',
                          )
                        ]
                      : custSybase,
                  displayItem: (item) =>
                      stillTakingDataCustomer || item.custID.isEmpty
                          ? item.custname
                          : '${item.custID} - ${item.custname}',
                  onChanged: action != MemoAct.create
                      ? null
                      : (value) {
                          selectedCustomer = value?.custID ?? '';
                          print(value?.groupaId);
                          bool isNpwp = value?.groupaId == '14';
                          statusNpwp = (isNpwp ? '0' : value?.taxid)!;
                          print(statusNpwp);
                          showSelectedCustomer =
                              '${value?.description} - $statusNpwp';
                          _calculateCostRatio();
                          setState(() {});
                        },
                  warningText: 'Nama customer tidak boleh kosong',
                  selectedItem: custSybase.firstWhereOrNull(
                    (element) => element.custID == selectedCustomer,
                  ),
                ),
                selectedCustomer.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          showSelectedCustomer,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
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
                  selectedItem: custprod?.products.firstWhereOrNull(
                      (element) => element.id == selectedProduct),
                  warningText: 'Item produk tidak boleh kosong',
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
                const Divider(),
                const SizedBox(height: 16),
                const LabelText(label: 'Harga Awal (per Kg)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _startingPriceController,
                  onChanged: (value) {
                    final price = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (price.isEmpty) {
                      _startingPriceController.clear();
                      return;
                    }
                    _startingPriceController.text = Utils.formatCurrency(price);
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Marketing Cost (per Kg)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _marketingCostController,
                  onChanged: (value) {
                    final price = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (price.isEmpty) {
                      _marketingCostController.clear();
                      return;
                    }
                    _marketingCostController.text = Utils.formatCurrency(price);
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Harga Setelah Diskon (per Kg)'),
                AppTextField(
                  controller: _priceAfterDiscountController,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const LabelText(label: 'Estimasi Penjualan (Rp)'),
                AppTextField(
                  controller: _salesEstimationInRpController,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Estimasi Penjualan (Ton)'),
                AppTextField(
                  readOnly: action != MemoAct.create,
                  controller: _salesEstimationInTonController,
                  onChanged: (value) {
                    final price = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (price.isEmpty) {
                      _salesEstimationInTonController.clear();
                      return;
                    }
                    // using thousand separator
                    var regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
                    _salesEstimationInTonController.text =
                        price.replaceAllMapped(
                            regex, (match) => '${match.group(1)},');
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Estimasi Total Biaya (Rp)'),
                AppTextField(
                  readOnly: true,
                  controller: _totalCostEstimationController,
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Estimasi Nilai Pajak (Rp)'),
                AppTextField(
                  readOnly: true,
                  controller: _taxValueEstimationController,
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Cost Ratio'),
                AppTextField(
                  readOnly: true,
                  controller: _costRatioController,
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
                    reqSignature = value;
                  },
                  onSaveNdmSignature: (value) {
                    ndmSignature = value;
                  },
                  onSaveSmhSignature: (value) {
                    smhSignature = value;
                  },
                  signatureData: reqSignature,
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
