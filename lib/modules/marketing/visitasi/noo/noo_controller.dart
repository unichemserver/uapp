import 'package:get/get.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/utils/date_utils.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/home/home_api.dart';
import 'package:uapp/modules/marketing/marketing_api.dart';
import 'package:uapp/modules/marketing/model/noo_model.dart';
import 'package:uapp/modules/marketing/model/spesimen_model.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_address_model.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_text_controller.dart';
import 'package:uapp/app/routes.dart';

class NooController extends GetxController {
  final db = MarketingDatabase();
  final api = MarketingApiService();
  final nooId = ''.obs;
  final masternoo = Rxn<Map<String, dynamic>>();
  final documents = <Map<String, dynamic>>[].obs;
  final spesimens = <Map<String, dynamic>>[].obs;
  String? idNOO;
  String? idUpdate;
  String clusterKelompok = '';
  var paymentMethod = ''.obs; // Store payment method text directly
  String jaminan = '';
  String kantorOwnership = '';
  String gudangOwnership = '';
  String rumahOwnership = '';
  String statusPajak = '';
  var topOptionsError = ''.obs;
  var topOptions = <Map<String, dynamic>>[].obs;
  var customerGroups = <String, List<String>>{}.obs;
  var selectedCluster = ''.obs;
  var selectedNamaDesc = ''.obs;
  NooAddressModel ownerAddress = NooAddressModel();
  NooAddressModel companyAddress = NooAddressModel();
  NooAddressModel warehouseAddress = NooAddressModel();
  NooAddressModel billingAddress = NooAddressModel();
  String idAddress = '';
  String idAddressCompany = '';
  String idAddressWarehouse = '';
  String idAddressBilling = '';

  String ktpPath = '';
  String npwpPath = '';
  String ownerPicPath = '';
  String outletPath = '';
  String warehousePath = '';
  String siupPath = '';
  String tdpPath = '';
  String suratKerjasamaPath = '';
  String suratDistributorPath = '';
  String suratDomisiliUsahaPath = '';
  String suratPenerbitanBankPath = '';
  String suratBankGaransiPath = '';
  String aktaPendirianPath = '';
  String companyProfilePath = '';
  String get formatGroupCust => selectedNamaDesc.isNotEmpty
    ? '${selectedNamaDesc.value}[${selectedCluster.value}]'
    : selectedNamaDesc.value;
  List<SpesimenModel> spesimen = [];
  var isCreditLimitAndJaminanVisible = false.obs; 

  saveData(NooTextController nooDatas, {String? nooId}) async {
    final method = paymentMethod.value;
    if (nooId != null) {
      idNOO = nooId; 
    } else if (idNOO == null ) {
      await getIDNOO();
    }

    if (idUpdate == null && method == 'KREDIT' && nooId != null) {
      await getIDNOOUpdate();
    }

    if (idNOO != null) {
      await db.update(
        'noo_activity',
        {
          'statussync': 0,
        },
        'idnoo = ?',
        [idNOO],
      );
    }

    Map<String, dynamic> additionalData = {
      'group_cust': formatGroupCust,
      'payment_method': paymentMethod.value, // Use text value
      'jaminan': jaminan,
      'ownership_toko': kantorOwnership,
      'ownership_gudang': gudangOwnership,
      'ownership_rumah': rumahOwnership,
      'status_pajak': statusPajak,
    };
    additionalData.addAll(nooDatas.toJson());

    if (nooId != null) {
      await db.update(
        'masternooupdate',
        additionalData,
        'id_noo = ?',
        [idNOO], 
      );
    } else if (idNOO != null && method == 'KREDIT') {
      await db.update(
        'masternooupdate',
        additionalData,
        'id_noo = ?',
        [idNOO], 
      );
    } else {
      await db.update(
        'masternoo',
        additionalData,
        'id = ?', // Use 'id' as the search column
        [idNOO],  // Ensure idNOO is used correctly
      );
    }

    Map<String, dynamic> addressMap = {
      'alamat_owner': ownerAddress,
      'alamat_kantor': companyAddress,
      'alamat_gudang': warehouseAddress,
      'alamat_npwp': billingAddress,
    };

    for (var address in addressMap.keys) {
      var addressObject = addressMap[address];
      await db.update(
        'nooaddress',
        addressObject.toJson(),
        'id = ?',
        [addressObject.id],
      );
    }

    Map<String, dynamic> documentData = {
      if (ktpPath.isNotEmpty) 'ktp': ktpPath,
      if (npwpPath.isNotEmpty) 'npwp': npwpPath,
      if (ownerPicPath.isNotEmpty) 'owner_pic': ownerPicPath,
      if (outletPath.isNotEmpty) 'outlet': outletPath,
      if (warehousePath.isNotEmpty) 'warehouse': warehousePath,
      if (siupPath.isNotEmpty) 'siup': siupPath,
      if (tdpPath.isNotEmpty) 'tdp': tdpPath,
      if (suratKerjasamaPath.isNotEmpty) 'surat_kerjasama': suratKerjasamaPath,
      if (suratDistributorPath.isNotEmpty) 'surat_penunjukan_distributor': suratDistributorPath,
      if (suratDomisiliUsahaPath.isNotEmpty) 'surat_domisili_usaha': suratDomisiliUsahaPath,
      if (suratPenerbitanBankPath.isNotEmpty) 'surat_penerbitan_bank': suratPenerbitanBankPath,
      if (suratBankGaransiPath.isNotEmpty) 'surat_bank_garansi': suratBankGaransiPath,
      if (aktaPendirianPath.isNotEmpty) 'akta_pendirian': aktaPendirianPath,
      if (companyProfilePath.isNotEmpty) 'company_profile': companyProfilePath,
    };

    if (documentData.isNotEmpty) {
      await db.update(
        'noodocument',
        documentData,
        'id_noo = ?',
        [idNOO],
      );
    }
  }

  getIDNOO() async {
  idNOO = await generateNOOID();
  final method = paymentMethod.value;

  if (method == 'KREDIT') {
    await createKreditRecords();
  } else {
    await createCashRecords();
  }
  update();
}

createKreditRecords() async {
  idUpdate = await generateID();
  await db.insert(
    'masternooupdate',
    {
      'id': idUpdate,
      'id_noo': idNOO,
    },
    nullColumnHack: 'group_cust',
  );

  await db.insert(
    'noo_activity',
    {
      'idnoo': idNOO,
      'statussync': 0,
      'approved': 0,
    },
  );

  await createCommonRecords();

  await db.update(
    'masternooupdate',
    {
      'alamat_owner': ownerAddress.id,
      'alamat_kantor': companyAddress.id,
      'alamat_gudang': warehouseAddress.id,
      'alamat_npwp': billingAddress.id,
    },
    'id_noo = ?',
    [idNOO],
  );
}

createCashRecords() async {
  await db.insert(
    'masternoo',
    {
      'id': idNOO,
    },
    nullColumnHack: 'group_cust',
  );


  await db.insert(
    'noo_activity',
    {
      'idnoo': idNOO,
      'statussync': 0,
      'approved': 0,
    },
  );

  await createCommonRecords();

  await db.update(
    'masternoo',
    {
      'alamat_owner': ownerAddress.id,
      'alamat_kantor': companyAddress.id,
      'alamat_gudang': warehouseAddress.id,
      'alamat_npwp': billingAddress.id,
    },
    'id = ?',
    [idNOO],
  );
}

createCommonRecords() async {
  var idDocNoo = await generateNooID('noodocument');
  await db.insert(
    'noodocument',
    {
      'id': idDocNoo,
      'id_noo': idNOO,
    },
    nullColumnHack: 'ktp',
  );

  ownerAddress.id = await generateNooID('nooaddress');
  ownerAddress.idNoo = idNOO;
  await db.insert(
    'nooaddress',
    ownerAddress.toJson(),
  );
  
  companyAddress.id = await generateNooID('nooaddress');
  companyAddress.idNoo = idNOO;
  await db.insert(
    'nooaddress',
    companyAddress.toJson(),
  );
  
  warehouseAddress.id = await generateNooID('nooaddress');
  warehouseAddress.idNoo = idNOO;
  await db.insert(
    'nooaddress',
    warehouseAddress.toJson(),
  );
  
  billingAddress.id = await generateNooID('nooaddress');
  billingAddress.idNoo = idNOO;
  await db.insert(
    'nooaddress',
    billingAddress.toJson(),
  );
}

  getIDNOOUpdate() async {
    var idNOOUpdate = await generateID();
    await db.insert(
      'masternooupdate',
      {
        'id': idNOOUpdate,
        'id_noo': idNOO,
      },
      nullColumnHack: 'group_cust',
    );

    // Insert into noo_activity
    await db.insert(
      'noo_activity',
      {
        'idnoo': idNOO,
        'statussync': 0,
        'approved': 0,
      },
    );

    var idDocNoo = await generateNooID('noodocument');
    await db.insert(
      'noodocument',
      {
        'id': idDocNoo,
        'id_noo': idNOO,
      },
      nullColumnHack: 'ktp',
    );

    ownerAddress.id = await generateNooID('nooaddress');
    ownerAddress.idNoo = idNOO;
    await db.insert(
      'nooaddress',
      ownerAddress.toJson(),
    );
    companyAddress.id = await generateNooID('nooaddress');
    companyAddress.idNoo = idNOO;
    await db.insert(
      'nooaddress',
      companyAddress.toJson(),
    );
    warehouseAddress.id = await generateNooID('nooaddress');
    warehouseAddress.idNoo = idNOO;
    await db.insert(
      'nooaddress',
      warehouseAddress.toJson(),
    );
    billingAddress.id = await generateNooID('nooaddress');
    billingAddress.idNoo = idNOO;
    await db.insert(
      'nooaddress',
      billingAddress.toJson(),
    );

    await db.update(
      'masternooupdate',
      {
        'alamat_owner': ownerAddress.id,
        'alamat_kantor': companyAddress.id,
        'alamat_gudang': warehouseAddress.id,
        'alamat_npwp': billingAddress.id,
      },
      'id_noo = ?',
      [idNOO],
    );
    update();
  }
  

Future<void> fetchCustomerGroup() async {
   try {
      List<dynamic> result = await api.getMasterGroup();

      await db.delete('mastergroup', '1 = 1', []); 

      for (var row in result) {
      await db.insert('mastergroup', {
        'id': row['id'] == 0 ? null : row['id'],
        'cluster_kelompok': row['cluster_kelompok'] ?? '',
        'type': row['type'] ?? 'UNKNOWN', 
        'kode': row['kode'] ?? '',
        'nama_desc': row['nama_desc'] ?? '',
        'singkatan': row['singkatan'] ?? '',
        'definisi': row['definisi'] ?? '',
        'active': row['active'] ?? 1,
      });
    }

      await loadCustomerGroups(); 
    } catch (e) {
      Log.d('Error fetching customer groups: $e');
    }
}

Future<void> loadCustomerGroups() async {
    List<Map<String, dynamic>> results = await db.query('mastergroup');
    Map<String, List<String>> groups = {};
    
    for (var row in results) {
      String cluster = row['cluster_kelompok'];
      String namaDesc = row['nama_desc'];

      if (!groups.containsKey(cluster)) {
        groups[cluster] = [];
      }
      groups[cluster]!.add(namaDesc);
    }

    customerGroups.assignAll(groups);
    update();
  }

  Future<String> generateNooID(String table) async {
    var userId = Utils.getUserData().id;
    String pattern = 'NOO$userId';
    String query = '''
      SELECT id FROM $table
      WHERE id LIKE '$pattern%'
      ORDER BY id DESC
      LIMIT 1
    ''';
    List<Map> result = await db.rawQuery(query);
    int newIncrement = 1;
    if (result.isNotEmpty) {
      String lastId = result.first['id'];
      int lastIncrement = int.parse(lastId.substring(lastId.length - 3));
      newIncrement = lastIncrement + 1;
    }
    String incrementString = newIncrement.toString().padLeft(3, '0');
        return '$pattern$incrementString';
  }

  Future<String> generateNOOID() async {
    var dateToday = DateUtils.getFormatDate();
    var userId = Utils.getUserData().id;
    String pattern = 'NOO$userId$dateToday';
    String id;
    bool isDuplicate;

    do {
      int randomDigit = Utils.getRandomDigit(); // Generate a random digit
      int newIncrement = 1;
      String query = '''
      SELECT id FROM masternoo
        WHERE id LIKE '$pattern%'
        ORDER BY id DESC
        LIMIT 1
      ''';
      List<Map> result = await db.rawQuery(query);
      if (result.isNotEmpty) {
        String lastId = result.first['id'];
        int lastIncrement = int.parse(lastId.substring(lastId.length - 1));
        newIncrement = lastIncrement + 1;
      }
      if (newIncrement > 9) {
        newIncrement = 1;
      }
      id = '$pattern$randomDigit$newIncrement';

      // Check for duplicate ID
      String checkQuery = '''
      SELECT COUNT(*) as count FROM masternoo
        WHERE id = ?
      ''';
      List<Map> checkResult = await db.rawQuery(checkQuery, args: [id]);
      isDuplicate = checkResult.first['count'] > 0;
    } while (isDuplicate);

    return id;
  }

  Future<String> generateID() async {
    var dateToday = DateUtils.getFormatDate();
    String pattern = 'CUS$dateToday';
    String id;
    int newIncrement = 1;
    bool isDuplicate;

    do {
    int randomDigit = Utils.getRandomDigit(); 
    String query = '''
      SELECT id FROM masternooupdate
      WHERE id LIKE '$pattern%'
      ORDER BY id DESC
      LIMIT 1
    ''';
    List<Map> result = await db.rawQuery(query);

    if (result.isNotEmpty) {
      String lastId = result.first['id'];
      int lastIncrement = int.parse(lastId.substring(pattern.length));
      newIncrement = lastIncrement + 1;
    }

    if (newIncrement > 9) {
      newIncrement = 1;
    }

    id = '$pattern$randomDigit$newIncrement';

    String checkQuery = '''
    SELECT COUNT(*) as count FROM masternooupdate
      WHERE id = ?
    ''';
    List<Map> checkResult = await db.rawQuery(checkQuery, args: [id]);
    isDuplicate = checkResult.first['count'] > 0;
    } while (isDuplicate);
  
    return id;
  }

  setNooId(String nooId) {
    idNOO = nooId;
    update();
  }

  setNooUpdateId(String nooId) {
    idUpdate = nooId;
    update();
  }

  setIdAddress() {
    idAddress = masternoo.value?['alamat_owner'];
    update();
  }

  setIdAddressCompany() {
    idAddressCompany = masternoo.value?['alamat_kantor'];
    update();
  }

  setIdAddressWarehouse() {
    idAddressWarehouse = masternoo.value?['alamat_gudang'];
    update();
  }

  setIdAddressBilling() {
    idAddressBilling = masternoo.value?['alamat_npwp'];
    update();
  }

  setNooData(NooModel data) {
    var match = RegExp(r'^(.*?)\[(.*?)\]$').firstMatch(data.groupCust ?? '');
    if (match != null) {
      selectedNamaDesc.value = match.group(1) ?? '';
      selectedCluster.value = match.group(2) ?? '';
    } else {
      selectedNamaDesc.value = data.groupCust ?? '';
      selectedCluster.value = '';
    }
    jaminan = data.jaminan ?? '';
    paymentMethod.value = data.paymentMethod ?? '';
    kantorOwnership = data.ownershipToko ?? '';
    gudangOwnership = data.ownershipGudang ?? '';
    rumahOwnership = data.ownershipRumah ?? '';
    statusPajak = data.statusPajak ?? '';
  }

  void setSelectedCluster(String cluster) {
  selectedCluster.value = cluster;
  selectedNamaDesc.value = '';
  update();
}

  void setSelectedNamaDesc(String namaDesc) {
    selectedNamaDesc.value = namaDesc;
    update();
  }

  void setPaymentMethod(String method) {
    paymentMethod.value = method; // Set text value
    update();
  }

  setNooDocument() async {
    var data =
        await db.query('noodocument', where: 'id_noo = ?', whereArgs: [idNOO]);
    if (data.isNotEmpty) {
      ktpPath = data[0]['ktp'] ?? '';
      npwpPath = data[0]['npwp'] ?? '';
      ownerPicPath = data[0]['owner_pic'] ?? '';
      outletPath = data[0]['outlet'] ?? '';
      warehousePath = data[0]['warehouse'] ?? '';
      siupPath = data[0]['siup'] ?? '';
      tdpPath = data[0]['tdp'] ?? '';
      suratKerjasamaPath = data[0]['surat_kerjasama'] ?? '';
      suratDistributorPath = data[0]['surat_penunjukan_distributor'] ?? '';
      suratDomisiliUsahaPath = data[0]['surat_domisili_usaha'] ?? '';
      suratPenerbitanBankPath = data[0]['surat_penerbitan_bank'] ?? '';
      suratBankGaransiPath = data[0]['surat_bank_garansi'] ?? '';
      aktaPendirianPath = data[0]['akta_pendirian'] ?? '';
      companyProfilePath = data[0]['company_profile'] ?? '';
    }
  }

  setSpesimentData() async {
    var data =
        await db.query('noospesimen', where: 'id_noo = ?', whereArgs: [idNOO]);
    if (data.isNotEmpty) {
      spesimen = data.map((e) => SpesimenModel.fromJson(e)).toList();
      update();
    } else {
      spesimen = [];
      update();
    }
  }

  setNooAddress() async {
    var query = "SELECT alamat_owner, alamat_kantor, alamat_gudang, alamat_npwp FROM masternoo WHERE id = ?";
    var result = await db.rawQuery(query, args: [idNOO]);
    var data = result[0];
    await _setAddress(data['alamat_owner'], (address) {
      ownerAddress = address;
    });
    await _setAddress(data['alamat_kantor'], (address) {
      companyAddress = address;
    });
    await _setAddress(data['alamat_gudang'], (address) {
      warehouseAddress = address;
    });
    await _setAddress(data['alamat_npwp'], (address) {
      billingAddress = address;
    });
  }
  setNooUpdateAddress() async {
    var query = "SELECT alamat_owner, alamat_kantor, alamat_gudang, alamat_npwp FROM masternooupdate WHERE id_noo = ?";
    var result = await db.rawQuery(query, args: [idNOO]);
    var data = result[0];
    await _setAddress(data['alamat_owner'], (address) {
      ownerAddress = address;
    });
    await _setAddress(data['alamat_kantor'], (address) {
      companyAddress = address;
    });
    await _setAddress(data['alamat_gudang'], (address) {
      warehouseAddress = address;
    });
    await _setAddress(data['alamat_npwp'], (address) {
      billingAddress = address;
    });
  }

  Future<void> _setAddress(String id, Function(NooAddressModel) setAddressCallback) async {
    var data = await db.query('nooaddress', where: 'id = ?', whereArgs: [id]);
    if (data.isNotEmpty) {
      setAddressCallback(NooAddressModel.fromJson(data.first));
      update();
    }
  }

  deleteSpesimen(String id) async {
    await db.delete('noospesimen', 'id = ?', [id]);
    setSpesimentData();
  }

  updateTtdSpesimen(String id, String ttd) async {
    await db.update(
      'noospesimen',
      {'ttd': ttd},
      'id = ?',
      [id],
    );
    setSpesimentData();
  }

  deleteTtdSpesimen(String id) async {
    await db.update(
      'noospesimen',
      {'ttd': ''},
      'id = ?',
      [id],
    );
    setSpesimentData();
  }

  updateStempelSpesimen(String id, String stempel) async {
    await db.update(
      'noospesimen',
      {'stempel': stempel},
      'id = ?',
      [id],
    );
    setSpesimentData();
  }

  deleteStempelSpesimen(String id) async {
    await db.update(
      'noospesimen',
      {'stempel': ''},
      'id = ?',
      [id],
    );
    setSpesimentData();
  }

  addSpesimen(SpesimenModel data) async {
    data.id = await generateNooID('noospesimen');
    data.idNoo = idNOO;
    await db.insert(
      'noospesimen',
      data.toJson(),
    );
    setSpesimentData();
  }

  Future<void> deleteData() async {
    if (idNOO != null) {
      await db.delete('masternoo', 'id = ?', [idNOO]);
      await db.delete('noodocument', 'id_noo = ?', [idNOO]);
      await db.delete('noospesimen', 'id_noo = ?', [idNOO]);
      await db.delete('nooaddress', 'id_noo = ?', [idNOO]);
      await db.delete('noo_activity', 'idnoo = ?', [idNOO]);
      idNOO = null;
      update();
    }
  }

  updateDocument(Map<String, String> data) async {
    db.update(
      'noodocument',
      data,
      'id_noo = ?',
      [idNOO],
    );
  }

  deleteDocument(String document) async {
    db.update(
      'noodocument',
      {document: null},
      'id_noo = ?',
      [idNOO],
    );
  }

  Future<void> checkTables() async {
    final tables = await db.rawQuery(
        "SELECT id FROM nooaddress");
    Log.d("Tables in Database: $tables");
  }

  Future<void> fetchTopOptions() async {
    topOptionsError.value = '';
    try {
      var response = await api.getTopOptions();
      List<dynamic> result = response['data'];

      await db.delete('top_options', '1 = 1', []);

      for (var row in result) {
        await db.insert('top_options', {
          'TOP_ID': row['TOP_ID'],
          'Description': row['Description'],
        });
      }
      topOptions.assignAll(result.map((item) => {
        'TOP_ID': item['TOP_ID'],
        'Description': item['Description'],
      }).toList());

      await loadTopOptions();
    } catch (e) {
      topOptionsError.value = 'Error fetching TOP options: $e';
    }
  }

  Future<void> loadTopOptions() async {
    List<Map<String, dynamic>> results = await db.query('top_options');
    topOptions.assignAll(results);
    update();
  }

  void showCreditLimitAndJaminan(bool isVisible) {
    isCreditLimitAndJaminanVisible.value = isVisible;
    update();
  }

  void setIdNoo(String idNoo) {
    nooId.value = idNoo;
    update();
  }

   Future<void> fetchMasterNooData() async {
    try {
      final apiData = await HomeApi.getDataNoo();
      if (apiData != null) {
        masternoo.value = apiData.firstWhere(
          (noo) => noo['id'] == nooId.value,
          orElse: () => <String, dynamic>{},
        ).map((key, value) => MapEntry(key, value ?? "")); // Replace null with ""
      }
      setIdAddress();
      setIdAddressCompany();
      setIdAddressWarehouse();
      setIdAddressBilling();
    } catch (e) {
      Log.d('Error fetching masternoo data: $e');
    }
  }

  Future<void> fetchDocumentNoo() async {
    try {
      final apiDocuments = await HomeApi.getDocumentNoo(nooId.value);
      if (apiDocuments != null) {
        documents.assignAll(apiDocuments.map((doc) => doc.map((key, value) => MapEntry(key, value ?? "")))); // Replace null with ""
      } else {
        documents.clear();
      }
    } catch (e) {
      Log.d('Error fetching document data: $e');
    }
  }

  Future<void> fetchSpesimenNoo() async {
    try {
      final data = await db.query('noospesimen', where: 'id_noo = ?', whereArgs: [nooId.value]);
      spesimens.assignAll(data.map((spec) => spec.map((key, value) => MapEntry(key, value ?? "")))); // Replace null with ""
    } catch (e) {
      Log.d('Error fetching spesimen data: $e');
    }
  }

Future<void> setNooAddressFromApi() async {
  try {
    final response = await HomeApi.getAddress(nooId.value);
    if (response != null) {
      final List<dynamic> addresses = response;

      await fetchMasterNooData();
      final noo = masternoo.value;

      if (noo != null) {
        _matchAndSetAddress(addresses, noo['alamat_owner'], (val) {
          ownerAddress = val;
        });

        _matchAndSetAddress(addresses, noo['alamat_kantor'], (val) {
          companyAddress = val;
        });

        _matchAndSetAddress(addresses, noo['alamat_gudang'], (val) {
          warehouseAddress = val;
        });

        _matchAndSetAddress(addresses, noo['alamat_npwp'], (val) {
          billingAddress = val;
        });
        update(); // Update state
      } else {
        Log.d('Error: masternoo.value is null or invalid');
      }
    }
  } catch (e) {
    Log.d('Error fetching address data: $e');
  }
}

void _matchAndSetAddress(List<dynamic> addressList, String? id, Function(NooAddressModel) callback) {
  if (id == null) return;
  final matched = addressList.firstWhere(
    (element) => element['id'] == id,
    orElse: () => <String, dynamic>{},
  );
if (matched.isNotEmpty) {
      callback(NooAddressModel.fromJson(matched));
      update();
    }
}

  Future<void> updateMasterNooField(String field, String value) async {
    try {
      await db.update(
        'masternoo',
        {field: value},
        'id = ?',
        [nooId.value],
      );
      await fetchMasterNooData();
    } catch (e) {
      Log.d('Error updating $field: $e');
    }
  }

  void navigateToAddressPage(String nooId) {
    Get.toNamed(Routes.NOO_ADDRESS, arguments: {'id': nooId});
  }

  Future<String?> getPaymentMethod(String idNoo) async {
    try {
      var result = await db.rawQuery(
        "SELECT payment_method, id_noo FROM masternooupdate where id_noo = ?", args: [idNoo]
      );

      if (result.isNotEmpty) {
        return result.first['payment_method'] as String?;
      }
    } catch (e) {
      Log.d('Error fetching payment_method for id_noo $idNoo: $e');
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();

    // Fetch arguments and set nooId
    final arg = Get.arguments as Map<String, dynamic>?;
    if (arg != null && arg.containsKey('id')) {
      setIdNoo(arg['id']);
    }

    fetchCustomerGroup();
    fetchTopOptions();
    loadTopOptions();
    loadCustomerGroups();
    checkTables();
    fetchMasterNooData();
    fetchDocumentNoo();
    fetchSpesimenNoo();
  }
}
