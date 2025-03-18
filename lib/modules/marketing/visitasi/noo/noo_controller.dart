// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'package:get/get.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/utils/date_utils.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/marketing_api.dart';
import 'package:uapp/modules/marketing/model/noo_model.dart';
import 'package:uapp/modules/marketing/model/spesimen_model.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_address_model.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_text_controller.dart';

class NooController extends GetxController {
  final db = MarketingDatabase();
  final api = MarketingApiService();
  String? idNOO;
  String clusterKelompok = '';
  // String groupPelanggan = ''; 
  String paymentMethod = '';
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
 

  saveData(NooTextController nooDatas) async {
    if (idNOO == null) {
      await getIDNOO();
    }

    Map<String, dynamic> additionalData = {
      'group_cust': formatGroupCust,
      // 'group_cust': groupPelanggan,
      'payment_method': paymentMethod,
      'jaminan': jaminan,
      'ownership_toko': kantorOwnership,
      'ownership_gudang': gudangOwnership,
      'ownership_rumah': rumahOwnership,
      'status_pajak': statusPajak,
    };
    additionalData.addAll(nooDatas.toJson());
    await db.update(
      'masternoo',
      additionalData,
      'id = ?',
      [idNOO],
    );
    Map<String, dynamic> addressMap = {
      'alamat_owner': ownerAddress,
      'alamat_kantor': companyAddress,
      'alamat_gudang': warehouseAddress,
      'alamat_npwp': billingAddress
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
    // Save document data
    Map<String, dynamic> documentData = {
      'ktp': ktpPath,
      'npwp': npwpPath,
      'owner_pic': ownerPicPath,
      'outlet': outletPath,
      'warehouse': warehousePath,
      'siup': siupPath,
      'tdp': tdpPath,
      'surat_kerjasama': suratKerjasamaPath,
      'surat_penunjukan_distributor': suratDistributorPath,
      'surat_domisili_usaha': suratDomisiliUsahaPath,
      'surat_penerbitan_bank': suratPenerbitanBankPath,
      'surat_bank_garansi': suratBankGaransiPath,
      'akta_pendirian': aktaPendirianPath,
      'company_profile': companyProfilePath,
    };
    documentData.removeWhere((key, value) => value == null || value.isEmpty);
    await db.update(
      'noodocument',
      documentData,
      'id_noo = ?',
      [idNOO],
    );
  }

  getIDNOO() async {
    idNOO = await generateNOOID();
    await db.insert(
      'masternoo',
      {
        'id': idNOO,
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
    update();
  }

Future<void> fetchCustomerGroup() async {
   try {
      List<dynamic> result = await api.getMasterGroup();
      // Log.d('Customer Group: $result');

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

// Future<void> saveCustomerGroupsToDB(List<dynamic> groups) async {
//   await db.delete(
//     'mastergroup',
//     'cluster_kelompok = ?',
//     [clusterKelompok],
//   );

//   for (var group in groups) {
//     await db.insert('mastergroup', {
//       'cluster_kelompok': group['cluster_kelompok'],
//       'nama_desc': group['nama_desc'],
//     });
//   }
// }

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
    String query = '''
    SELECT id FROM masternoo
      WHERE id LIKE '$pattern%'
      ORDER BY id DESC
      LIMIT 1
    ''';
    List<Map> result = await db.rawQuery(query);
    int newIncrement = 1;
    if (result.isNotEmpty) {
      String lastId = result.first['id'];
      int lastIncrement = int.parse(lastId.substring(lastId.length - 1));
      newIncrement = lastIncrement + 1;
    }
    if (newIncrement > 9) {
      newIncrement = 1;
    }
    return '$pattern$newIncrement';
  }

  setNooId(String nooId) {
    idNOO = nooId;
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
    paymentMethod = data.paymentMethod ?? '';
    jaminan = data.jaminan ?? '';
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
      Log.d('owner address: $address');
      ownerAddress = address;
    });
    await _setAddress(data['alamat_kantor'], (address) {
      Log.d('company address: $address');
      companyAddress = address;
    });
    await _setAddress(data['alamat_gudang'], (address) {
      Log.d('warehouse address: $address');
      warehouseAddress = address;
    });
    await _setAddress(data['alamat_npwp'], (address) {
      Log.d('billing address: $address');
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
        "SELECT * FROM masternoo");
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

  

  @override
  void onInit() {
    super.onInit();
    fetchCustomerGroup();
    fetchTopOptions();
    loadTopOptions();
    loadCustomerGroups();
    checkTables();
  }
}
