import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/rupiah_formatter.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/modules/memo/data/model/custprod.dart';
import 'package:uapp/modules/memo/data/model/memo_realisasi_target.dart';
import 'package:uapp/modules/memo/data/model/memo_target.dart';
import 'package:uapp/modules/memo/memo_utils.dart';
import 'package:uapp/modules/memo/widget/content_editor_widget.dart';
import 'package:uapp/modules/memo/widget/dropdown_list.dart';
import 'package:uapp/modules/memo/widget/dropdown_selectable_list.dart';
import 'package:uapp/modules/memo/widget/label_text.dart';
import 'package:uapp/modules/memo/widget/memo_shimmer.dart';
import 'package:uapp/modules/memo/widget/signature_form.dart';
import 'package:uapp/modules/memo/widget/title_memo.dart';
import 'package:uapp/modules/memo/data/memo_api_service.dart' as api;
import 'package:uapp/modules/memo/widget/yes_no_option.dart';
import '../../../../models/contact.dart';

class RealisasiTargetMemo extends StatefulWidget {
  const RealisasiTargetMemo({super.key});

  @override
  State<RealisasiTargetMemo> createState() => _RealisasiTargetMemoState();
}

class _RealisasiTargetMemoState extends State<RealisasiTargetMemo> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _itemKeys = {};
  final _formKey = GlobalKey<FormState>();

  final _memoController = TextEditingController();
  final _makerController = TextEditingController(
    text: Utils.getUserData().nama,
  );
  List<String> selectedRecipient = [];
  final _subjectController = TextEditingController();
  final _dateController = TextEditingController(
    text: DateTime.now().toString().substring(0, 10),
  );
  final _programController = TextEditingController();
  String selectedCustomer = '';
  final _areaController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  int isTargetAchieved = -1;
  final _percentageController = TextEditingController();
  int isInvoiced = -1;
  final _salesRealizationRpController = TextEditingController();
  final _salesrealizationTonController = TextEditingController();
  final _marketingCostController = TextEditingController();
  final _totalPriceRealizationController = TextEditingController();
  final _salesPriceRealizationController = TextEditingController();
  final _costRatioController = TextEditingController();
  String mechanism = '';
  final _subsInvoiceController = TextEditingController();
  final _subsTravDocController = TextEditingController();
  final _customerAccountController = TextEditingController();
  final _subsPoController = TextEditingController();
  String selectedReq = Utils.getUserData().id; // userid
  String selectedChecker = ''; // ndm
  String selectedApprover = ''; // smh
  ByteData? reqSignature; // reqSignature
  ByteData? ndmSignature; // ndmSignature
  ByteData? smhSignature; // smhSignature
  String status = '0';

  List<Contact> contacts = [];
  Custprod? custprod;
  MemoIcon? memoIcon;
  MemoRealisasiTarget? memo;
  bool isLoading = true;
  bool isEditing = false;
  String action = MemoAct.create;
  bool isNdm = false;
  bool isSmh = false;
  String targetAId = '';
  String estimateInRp = '';

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void _initKeys() {
    _itemKeys['ndm'] = GlobalKey();
    _itemKeys['smh'] = GlobalKey();
  }

  Future<void> getContacts() async {
    contacts = await DatabaseHelper().getAllContact();
    setState(() {});
  }

  Future<void> getCustomerProduct() async {
    custprod = await api.getCustprod(Utils.getBaseUrl());
    setState(() {});
  }

  void _saveMemo(BuildContext context) async {
    var regex = RegExp(r'^[0-9]+(\.[0-9]+)?$');
    var data = MemoRealisasiTarget(
      no: _memoController.text,
      targetAId: targetAId,
      pic: _makerController.text,
      cc: selectedRecipient.join(','),
      hal: _subjectController.text,
      tgl: _dateController.text,
      program: _programController.text,
      cust: selectedCustomer,
      area: _areaController.text,
      tglMulai: _fromController.text,
      tglSelesai: _toController.text,
      tercapai: isTargetAchieved.toString(),
      persenTercapai: _percentageController.text,
      bayarInvoiceMax: isInvoiced.toString(),
      mekanisme: mechanism,
      potongInvoice: _subsInvoiceController.text,
      potongSuratJalan: _subsTravDocController.text,
      potongPo: _subsPoController.text,
      mpNoAcc: _customerAccountController.text,
      realInRp: _salesRealizationRpController.text.replaceAll(regex, ''),
      realInTon: _salesrealizationTonController.text.replaceAll(regex, ''),
      disc: _marketingCostController.text.replaceAll(regex, ''),
      realTotalBiaya: _totalPriceRealizationController.text.replaceAll(regex, ''),
      realHargaJual: _salesPriceRealizationController.text.replaceAll(regex, ''),
      realCostRatio: _costRatioController.text.replaceAll(regex, ''),
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
    api.saveMemo<MemoRealisasiTarget>(data, url).then((response) {
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

  Future<List<MemoTarget>> getTargetMemo() async {
    var result = await api.getTargetMemo();
    return result;
  }

  void showListTargetMemo() async {
    showDialog(
      context: context,
      builder: (context) {
        return const LoadingDialog(
          message: 'Mengambil data target...',
        );
      },
    );
    getTargetMemo().then((memoTarget) {
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text('Pilih Target'),
              content: SizedBox(
                width: double.maxFinite,
                height: 200,
                child: ListView.builder(
                  itemCount: memoTarget.length,
                  itemBuilder: (context, index) {
                    var target = memoTarget[index];
                    return ListTile(
                      title: Text(target.no),
                      onTap: () {
                        targetAId = target.id!;
                        estimateInRp = target.estInRp;
                        _subjectController.text = target.hal;
                        _programController.text = target.program;
                        selectedCustomer = target.cust;
                        _areaController.text = target.area;
                        _fromController.text = target.tglMulai;
                        _toController.text = target.tglSelesai;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Batal'),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _updatePercentageAchieved() {
    var realInRpNum =
        _salesRealizationRpController.text.replaceAll(RegExp(r'[^0-9]'), '');
    double estInRp = double.tryParse(estimateInRp) ?? 0;
    double realInRp = double.tryParse(realInRpNum) ?? 0;
    double val = estInRp != 0 ? (realInRp / estInRp) * 100 : 0;
    print('update percentage achieved: $val');
    _percentageController.text = val.toStringAsFixed(2);
  }

  void _updateMarketingCost() {
    var totalBiaya =
        _totalPriceRealizationController.text.replaceAll(RegExp(r'[^0-9]'), '');
    var realInTonNum =
        _salesrealizationTonController.text.replaceAll(RegExp(r'[^0-9]'), '');
    double realTotalBiaya = double.tryParse(totalBiaya) ?? 0;
    double realInTon = double.tryParse(realInTonNum) ?? 0;
    double val = realInTon != 0 ? realTotalBiaya / realInTon : 0;
    print('update marketing cost: $val');
    _marketingCostController.text = val.toStringAsFixed(2);
  }

  void _updateSalesPrice() {
    var realInRpNum =
        _salesRealizationRpController.text.replaceAll(RegExp(r'[^0-9]'), '');
    var realInTonNum =
        _salesrealizationTonController.text.replaceAll(RegExp(r'[^0-9]'), '');
    double realInRp = double.tryParse(realInRpNum) ?? 0;
    double realInTon = double.tryParse(realInTonNum) ?? 0;
    double val = realInTon != 0 ? realInRp / realInTon : 0;
    print('update sales price: $val');
    _salesPriceRealizationController.text = val.toStringAsFixed(2);
  }

  void _updateCostRatio() {
    var marketingCost =
        _marketingCostController.text.replaceAll(RegExp(r'[^0-9]'), '');
    var salesPrice =
        _salesPriceRealizationController.text.replaceAll(RegExp(r'[^0-9]'), '');
    double disc = double.tryParse(marketingCost) ?? 0;
    double realHargaJual = double.tryParse(salesPrice) ?? 0;
    double val = realHargaJual != 0 ? disc / realHargaJual : 0;
    print('update cost ratio: $val');
    _costRatioController.text = val.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    _initKeys();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setLoading(true);
      Future.wait([
        getContacts(),
        getCustomerProduct(),
      ]).then((value) {
        var arg =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        memoIcon = arg['memo'] as MemoIcon;
        action = arg['action'] as String;
        if (!isEditing) {
          _memoController.text = generateNoMemo(memoIcon!.no);
        }
        if (action == MemoAct.create) {
          showListTargetMemo();
        }
        setLoading(false);
        _salesRealizationRpController.addListener(_updatePercentageAchieved);
        _totalPriceRealizationController.addListener(_updateMarketingCost);
        _salesrealizationTonController.addListener(_updateMarketingCost);
        _salesRealizationRpController.addListener(_updateSalesPrice);
        _salesrealizationTonController.addListener(_updateSalesPrice);
        _marketingCostController.addListener(_updateCostRatio);
        _salesPriceRealizationController.addListener(_updateCostRatio);
      });
    });
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _memoController.dispose();
    _makerController.dispose();
    _subjectController.dispose();
    _dateController.dispose();
    _programController.dispose();
    _areaController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _percentageController.dispose();
    _salesRealizationRpController.dispose();
    _salesrealizationTonController.dispose();
    _marketingCostController.dispose();
    _totalPriceRealizationController.dispose();
    _salesPriceRealizationController.dispose();
    _costRatioController.dispose();
    _subsInvoiceController.dispose();
    _subsTravDocController.dispose();
    _customerAccountController.dispose();
    _subsPoController.dispose();
    _scrollController.dispose();
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
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const TitleMemo(
                    title: 'MEMO INTERNAL\nTARGET B - MEMO REALISASI PROMO',
                  ),
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'No Memo'),
                AppTextField(
                  readOnly: true,
                  controller: _memoController,
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Dibuat Oleh'),
                AppTextField(
                  controller: _makerController,
                  readOnly: true,
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
                  readOnly: true,
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
                  controller: _programController,
                  readOnly: true,
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
                  onChanged: null,
                  warningText: 'Nama customer tidak boleh kosong',
                  selectedItem: custprod?.customers.firstWhereOrNull(
                      (element) => element.id == selectedCustomer),
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Area Pemasaran'),
                AppTextField(
                  readOnly: true,
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
                const SizedBox(height: 32),
                const LabelText(label: 'Apakah target sudah tercapai?'),
                YesNoOption(
                  selectedOption: isTargetAchieved,
                  onSelected: (value) {
                    setState(() {
                      isTargetAchieved = value;
                    });
                    if (value == 0) {
                      _percentageController.text = '100';
                    } else {
                      _percentageController.text = '';
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: LabelText(label: 'Pencapaian Target (%)'),
                    ),
                    SizedBox(
                      width: 100,
                      child: AppTextField(
                        hintText: '',
                        controller: _percentageController,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pencapaian target tidak boleh kosong';
                          }
                          return null;
                        },
                        suffixIcon: Container(
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          child: const Text(
                            '%',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Apakah invoice sudah dibayar penuh?'),
                YesNoOption(
                  selectedOption: isInvoiced,
                  onSelected: (value) {
                    setState(() {
                      isInvoiced = value;
                    });
                  },
                ),
                const SizedBox(height: 32),
                const TitleMemo(title: 'Realisasi Target'),
                const SizedBox(height: 16),
                const LabelText(label: 'Realisasi Penjualan (Rp)'),
                AppTextField(
                  controller: _salesRealizationRpController,
                  readOnly: action != MemoAct.create,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // only take the number
                    var val = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (val.isEmpty) {
                      _salesRealizationRpController.text = '';
                      return;
                    }
                    _salesRealizationRpController.text =
                        Utils.formatCurrency(val);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Realisasi penjualan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Realisasi Penjualan (Ton)'),
                AppTextField(
                  controller: _salesrealizationTonController,
                  readOnly: action != MemoAct.create,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Realisasi penjualan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Marketing Cost (per KG)'),
                AppTextField(
                  controller: _marketingCostController,
                  readOnly: true,
                  onChanged: (value) {
                    // only take the number
                    var val = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (val.isEmpty) {
                      _marketingCostController.text = '';
                      return;
                    }
                    _marketingCostController.text = Utils.formatCurrency(val);
                  },
                  inputFormatters: [RupiahInputFormatter()],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Biaya marketing tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Realisasi Total Biaya (Rp)'),
                AppTextField(
                    controller: _totalPriceRealizationController,
                    readOnly: action != MemoAct.create,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      // only take the number
                      var val = value.replaceAll(RegExp(r'[^0-9]'), '');
                      if (val.isEmpty) {
                        _totalPriceRealizationController.text = '';
                        return;
                      }
                      _totalPriceRealizationController.text =
                          Utils.formatCurrency(val);
                    }),
                const SizedBox(height: 16),
                const LabelText(label: 'Realisasi Harga Jual (per KG)'),
                AppTextField(
                  controller: _salesPriceRealizationController,
                  readOnly: true,
                  onChanged: (value) {
                    // only take the number
                    var val = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (val.isEmpty) {
                      _salesPriceRealizationController.text = '';
                      return;
                    }
                    _salesPriceRealizationController.text = Utils.formatCurrency(val);
                  },
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Cost Ratio'),
                AppTextField(
                  controller: _costRatioController,
                  readOnly: true,
                ),
                const SizedBox(height: 32),
                const LabelText(label: 'Mekanisme'),
                GestureDetector(
                  onTap: action != MemoAct.create ? null : routeToContentEditor,
                  child: Container(
                    width: double.infinity,
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
                const SizedBox(height: 32),
                const LabelText(label: 'Dipotongkan terhadap Invoice No'),
                AppTextField(
                  controller: _subsInvoiceController,
                  readOnly: action != MemoAct.create,
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Dipotongkan terhadap Surat Jalan No'),
                AppTextField(
                  controller: _subsTravDocController,
                  readOnly: action != MemoAct.create,
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'No Account Customer (Bank Transfer)'),
                AppTextField(
                  controller: _customerAccountController,
                  readOnly: action != MemoAct.create,
                ),
                const SizedBox(height: 16),
                const LabelText(label: 'Dipotongkan terhadap PO No'),
                AppTextField(
                  controller: _subsPoController,
                  readOnly: action != MemoAct.create,
                ),
                const SizedBox(height: 32),
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
