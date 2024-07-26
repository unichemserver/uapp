import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uapp/models/canvasing.dart';
import 'package:uapp/models/collection.dart';
import 'package:uapp/models/competitor.dart';
import 'package:uapp/models/contact.dart';
import 'package:uapp/models/customer.dart';
import 'package:uapp/models/item.dart';
import 'package:uapp/models/marketing_activity.dart';
import 'package:uapp/models/noo.dart';
import 'package:uapp/models/stock.dart';
import 'package:uapp/models/to.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'uniapp.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS stocks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_marketing_activity INTEGER NOT NULL,
            item_id TEXT NOT NULL,
            name TEXT NOT NULL,
            quantity REAL NOT NULL,
            unit TEXT NOT NULL,
            image_path TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS competitors(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_marketing_activity INTEGER NOT NULL,
            name TEXT NOT NULL,
            price INTEGER NOT NULL,
            program TEXT NOT NULL,
            support TEXT NOT NULL
          )
          ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS imagepath (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_marketing_activity INTEGER NOT NULL,
            image TEXT NOT NULL,
            type TEXT NOT NULL
          )
          ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS collections (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_marketing_activity INTEGER NOT NULL,
            noinvoice TEXT NOT NULL,
            nocollect TEXT,
            amount INTEGER NOT NULL,
            type TEXT NOT NULL,
            status TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS marketing_activity (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL,
            rute_id TEXT,
            cust_id TEXT,
            foto_ci TEXT,
            foto_co TEXT,
            waktu_ci TIMESTAMP,
            waktu_co TIMESTAMP,
            lat_ci DECIMAL(10, 8),
            lon_ci DECIMAL(11, 8),
            lat_co DECIMAL(10, 8),
            lon_co DECIMAL(11, 8),
            status_sync INTEGER DEFAULT 0,
            status_call TEXT DEFAULT 'unv',
            jenis TEXT,
            ttd TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
          ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            PersonalID TEXT,
            namalengkap TEXT NOT NULL,
            namapanggilan TEXT NOT NULL,
            jeniskelamin,
            fotokaryawan,
            kode_jabatan TEXT NOT NULL,
            kode_bagian TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS invoice (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            custID TEXT,
            custname TEXT NOT NULL,
            noinv TEXT NOT NULL,
            amount INTEGER NOT NULL,
            amountpaid INTEGER NOT NULL,
            discrepancy INTEGER NOT NULL,
            duedate TEXT NOT NULL,
            currencyID TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS item (
            itemid TEXT PRIMARY KEY,
            description TEXT NOT NULL,
            unitsetid TEXT,
            Inventory_Unit TEXT NOT NULL
          )
          ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS rute (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_rute TEXT NOT NULL,
            id_customer TEXT NOT NULL,
            jadwal_rute TEXT NOT NULL,
            keterangan TEXT,
            custname TEXT
            )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS customer (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            CustID TEXT NOT NULL,
            custname TEXT NOT NULL,
            address TEXT NOT NULL,
            phones TEXT NOT NULL,
            PersonalName TEXT NOT NULL
          )
        ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS takingorder (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_marketing_activity INTEGER NOT NULL,
            itemid TEXT NOT NULL,
            description TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            unit TEXT NOT NULL,
            price INTEGER NOT NULL
          )
        ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS noo (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          group_pelanggan TEXT,
          metode_pembayaran TEXT,
          termin TEXT,
          jaminan TEXT,
          nama_perusahaan TEXT,
          area_pemasaran TEXT,
          nama_owner TEXT,
          no_ktp TEXT,
          umur INTEGER,
          jekel TEXT,
          no_telepon TEXT,
          email TEXT,
          address TEXT,
          desa TEXT,
          kec TEXT,
          kab TEXT,
          prov TEXT,
          kode_pos TEXT,
          status_sync INTEGER DEFAULT 0
        )
        ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS canvasing (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          CustID TEXT,
          nama_outlet TEXT,
          nama_owner TEXT,
          no_hp TEXT,
          latitude DECIMAL(10,8),
          longitude DECIMAL(11,8),
          alamat TEXT,
          status_sync INTEGER DEFAULT 0,
          image_path TEXT
        )
        ''');

        // await db.execute('''
        // CREATE TABLE IF NOT EXISTS price_list (
        //   id INTEGER PRIMARY KEY,
        //   itemid TEXT,
        //   unit_price TEXT,
        //   min_qty INTEGER,
        //   unitid TEXT,
        //   version INTEGER,
        //   description TEXT
        // )
        // ''');
      },
    );
  }

  Future<String> getCustomerName(int idMa, String custId, String jenis) async {
    Database db = await database;

    if (jenis == 'canvasing') {
      List<Map<String, dynamic>> result =
          await db.query('canvasing', where: 'CustID = ?', whereArgs: [custId]);
      return result[0]['nama_owner'];
    } else if (jenis == 'noo') {
      List<Map<String, dynamic>> result =
          await db.query('noo', where: 'id = ?', whereArgs: [custId]);
      return result[0]['nama_owner'];
    } else {
      List<Map<String, dynamic>> result =
          await db.query('customer', where: 'CustID = ?', whereArgs: [custId]);
      return result[0]['PersonalName'];
    }
  }

  Future<List<String>> getFinishFotoCi() async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.query('marketing_activity', where: 'foto_ci IS NOT NULL');
    List<String> finishFotoCi = [];
    for (Map<String, dynamic> map in result) {
      finishFotoCi.add(map['foto_ci']);
    }
    return finishFotoCi;
  }

  Future<List<dynamic>> getTodayActivity(String userId) async {
    Database db = await database;
    // get only list of id from marketing_activity
    var today = DateTime.now().toIso8601String().substring(0, 10);
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT id FROM marketing_activity
      WHERE user_id = ? AND created_at LIKE ?
    ''', [userId, '$today%']);
    return result;
  }

  Future<int> checkInCanvasing(Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert('marketing_activity', data);
  }

  Future<void> deleteMarketingActivity(int id) async {
    Database db = await database;
    await db.delete('marketing_activity', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateCustomerCanvasing(Map<String, dynamic> data) async {
    Database db = await database;
    await db.update('canvasing', data,
        where: 'CustID = ?', whereArgs: [data['CustID']]);
  }

  Future<String> addCustomerCanvasing(Map<String, dynamic> data) async {
    Database db = await database;
    int id = await db.insert('canvasing', data);
    String month = DateTime.now().month.toString().padLeft(2, '0');
    String year = DateTime.now().year.toString().substring(2);
    String idStr = id.toString().padLeft(4, '0');
    await db.update('canvasing', {'CustID': '$month$year$idStr'},
        where: 'id = ?', whereArgs: [id]);
    return '$month$year$idStr';
  }

  deleteCustomerCanvasing(String custID) async {
    Database db = await database;
    await db.delete('canvasing', where: 'CustID = ?', whereArgs: [custID]);
  }

  Future<Canvasing> getCanvasing(String custID) async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.query('canvasing', where: 'CustID = ?', whereArgs: [custID]);
    return Canvasing.fromJson(result[0]);
  }

  Future<int> addNoo(Map<String, dynamic> noo) async {
    Database db = await database;
    return await db.insert('noo', noo);
  }

  Future<List<Contact>> getAllContact() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('user');
    List<Contact> contactList = [];
    for (Map<String, dynamic> map in result) {
      contactList.add(Contact.fromJson(map));
    }
    return contactList;
  }

  Future<List<Contact>> getContact(String selfId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'user',
      where: 'PersonalID != ?',
      whereArgs: [selfId],
    );
    List<Contact> contactList = [];
    for (Map<String, dynamic> map in result) {
      contactList.add(Contact.fromJson(map));
    }
    return contactList;
  }

  Future<List<Contact>> searchContact(String query, String selfId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'user',
      where:
          '(namalengkap LIKE ? OR PersonalID LIKE ? OR kode_bagian LIKE ? OR namapanggilan LIKE ?) AND PersonalID != ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%', selfId],
    );
    List<Contact> contactList = [];
    for (Map<String, dynamic> map in result) {
      contactList.add(Contact.fromJson(map));
    }
    return contactList;
  }

  Future<List<Noo>> getUnsyncedNoo() async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.query('noo', where: 'status_sync = 0');
    List<Noo> nooList = [];
    for (Map<String, dynamic> map in result) {
      nooList.add(Noo.fromJson(map));
    }
    return nooList;
  }

  Future<void> updateNooStatus(int id) async {
    Database db = await database;
    await db.update('noo', {'status_sync': 1},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateCanvasingStatus(int id) async {
    Database db = await database;
    await db.update('canvasing', {'status_sync': 1},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<Noo> getNooById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.query('noo', where: 'id = ?', whereArgs: [id]);
    return Noo.fromJson(result[0]);
  }

  Future<Canvasing> getCanvasingById(String id) async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.query('canvasing', where: 'CustID = ?', whereArgs: [id]);
    return Canvasing.fromJson(result[0]);
  }

  Future<void> updateTtd(int idMA, String ttd) async {
    Database db = await database;
    await db.update(
      'marketing_activity',
      {'ttd': ttd},
      where: 'id = ?',
      whereArgs: [idMA],
    );
  }

  Future<String?> getTtd(int idMA) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'marketing_activity',
      where: 'id = ?',
      whereArgs: [idMA],
    );

    return result[0]['ttd'];
  }

  Future<bool> isTtdExist(int idMA) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'marketing_activity',
      where: 'id = ? AND ttd IS NOT NULL',
      whereArgs: [idMA],
    );

    return result.isNotEmpty;
  }

  Future<List<Stock>> getStockReports(int idMA) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'stocks',
      where: 'id_marketing_activity = ?',
      whereArgs: [idMA],
    );

    List<Stock> stockList = [];
    for (Map<String, dynamic> map in result) {
      stockList.add(Stock(
        id: map['id'],
        idMA: map['id_marketing_activity'],
        itemID: map['item_id'],
        name: map['name'],
        quantity: map['quantity'],
        unit: map['unit'],
        imagePath: map['image_path'],
      ));
    }

    return stockList;
  }

  Future<List<Competitor>> getCompetitors(int idMA) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'competitors',
      where: 'id_marketing_activity = ?',
      whereArgs: [idMA],
    );

    List<Competitor> competitorList = [];
    for (Map<String, dynamic> map in result) {
      competitorList.add(Competitor.fromJson(map));
    }

    return competitorList;
  }

  Future<List<Collection>> getCollections(int idMA) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'collections',
      where: 'id_marketing_activity = ?',
      whereArgs: [idMA],
    );

    List<Collection> collectionList = [];
    for (Map<String, dynamic> map in result) {
      collectionList.add(Collection.fromJson(map));
    }

    return collectionList;
  }

  Future<List<Item>> getListItem() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('item');

    List<Item> itemList = [];
    for (Map<String, dynamic> map in result) {
      itemList.add(Item.fromJson(map));
    }

    return itemList;
  }

  Future<int> insertMarketingActivity(
    int id,
    String ruteId,
    String userId,
    String custId,
  ) async {
    Database db = await database;
    return await db.insert(
      'marketing_activity',
      {
        'id': id,
        'user_id': userId,
        'cust_id': custId,
        'rute_id': ruteId,
      },
    );
  }

  Future<void> deleteSyncData() async {
    Database db = await database;
    await db.delete('stocks');
    await db.delete('competitors');
    await db.delete('imagepath');
    await db.delete('collections');
    await db.delete('marketing_activity');

    await db.delete('invoice');
    await db.delete('item');
    await db.delete('rute');
    await db.delete('user');
  }

  Future<List<Map<String, dynamic>>> getRute(int week, String hari) async {
    Database db = await database;
    final result = await db.rawQuery('''
      SELECT * FROM rute
      JOIN customer ON rute.id_customer = customer.CustID
      WHERE INSTR(rute.jadwal_rute, ?) > 0 AND INSTR(rute.jadwal_rute, ?) > 0
    ''', [week.toString(), hari]);
    return result;
  }

  // Start CRUD Data to Database
  Future<int> insertData(
    String table,
    Map<String, dynamic> data,
  ) async {
    Database db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> getData(String table) async {
    Database db = await database;
    return await db.query(table);
  }

  Future<int> updateData(
    String table,
    Map<String, dynamic> data,
    String column,
    dynamic value,
  ) async {
    Database db = await database;
    return await db.update(
      table,
      data,
      where: '$column = ?',
      whereArgs: [value],
    );
  }

  Future<void> insertOrUpdate(Map<String, dynamic> data, String table) async {
    Database db = await database;
    await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteDataById(String table, int id) async {
    Database db = await database;
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // End CRUD Data to Database

  Future<void> deleteCanvasing(Map<String, dynamic> item) async {
    Database db = await database;
    await db.delete('canvasing', where: 'CustID = ?', whereArgs: [item['CustID']]);
    await db.delete('marketing_activity', where: 'cust_id = ?', whereArgs: [item['CustID']]);
  }

  Future<int> insertCollection(Map<String, Object?> collection) async {
    Database db = await database;
    return await db.insert('collections', collection);
  }

  Future<void> updateCollection(int id, Map<String, Object?> collection) async {
    Database db = await database;
    await db.update(
      'collections',
      collection,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCollection(int id) async {
    Database db = await database;
    return await db.delete('collections', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertDisplay(int idMA, String imagePath) async {
    Database db = await database;
    return await db.insert('imagepath', {
      'id_marketing_activity': idMA,
      'image': imagePath,
      'type': 'display',
    });
  }

  Future<int> insertCheckout(int idMA, String imagePath) async {
    Database db = await database;
    return await db.insert('imagepath', {
      'id_marketing_activity': idMA,
      'image': imagePath,
      'type': 'checkout',
    });
  }

  // Future<int> insertTakingOrder(int idMA, String imagePath) async {
  //   Database db = await database;
  //   return await db.insert('imagepath', {
  //     'id_marketing_activity': idMA,
  //     'image': imagePath,
  //     'type': 'takingorder',
  //   });
  // }

  Future<List<String>> getDisplay(int idMA) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('imagepath',
        where: 'id_marketing_activity = ? AND type = ?',
        whereArgs: [idMA, 'display']);

    List<String> displayList = [];
    for (Map<String, dynamic> map in result) {
      displayList.add(map['image']);
    }

    return displayList;
  }

  Future<String> getCheckout(int idMA) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'imagepath',
      where: 'id_marketing_activity = ? AND type = ?',
      whereArgs: [idMA, 'checkout'],
    );

    List<String> checkoutList = [];
    for (Map<String, dynamic> map in result) {
      checkoutList.add(map['image']);
    }

    return checkoutList.isNotEmpty ? checkoutList[0] : '';
  }

  Future<List<To>> getTakingOrder(int idMA) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'takingorder',
      where: 'id_marketing_activity = ?',
      whereArgs: [idMA],
    );

    List<To> toList = [];
    for (Map<String, dynamic> map in result) {
      toList.add(To.fromMap(map));
    }

    return toList;
  }

  Future<void> updateTakingOrder(
    int idMA,
    String itemId,
    String namaItem,
    int qty,
    String unit,
    int harga,
  ) async {
    Database db = await database;
    await db.update(
      'takingorder',
      {
        'itemid': itemId,
        'description': namaItem,
        'quantity': qty,
        'unit': unit,
        'price': harga,
      },
      where: 'id_marketing_activity = ? AND itemid = ?',
      whereArgs: [idMA, itemId],
    );
  }

  Future<int> insertTakingOrder(
    int idMA,
    String itemID,
    String description,
    int quantity,
    String unit,
    int price,
  ) async {
    Database db = await database;
    return await db.insert(
      'takingorder',
      {
        'id_marketing_activity': idMA,
        'itemid': itemID,
        'description': description,
        'quantity': quantity,
        'unit': unit,
        'price': price,
      },
    );
  }

  Future<int> deleteDisplay(int idMA, String imagePath) async {
    Database db = await database;
    return await db.delete(
      'imagepath',
      where: 'id_marketing_activity = ? AND image = ? AND type = ?',
      whereArgs: [idMA, imagePath, 'display'],
    );
  }

  Future<int> deleteCheckout(int idMA) async {
    Database db = await database;
    return await db.delete(
      'imagepath',
      where: 'id_marketing_activity = ? AND type = ?',
      whereArgs: [idMA, 'checkout'],
    );
  }

  Future<int> deleteTakingOrder(int idMA, String itemid) async {
    Database db = await database;
    return await db.delete(
      'takingorder',
      where: 'id_marketing_activity = ? AND itemid = ?',
      whereArgs: [idMA, itemid],
    );
  }

  Future<List<Customer>> getExistingCustomer() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('customer');

    List<Customer> customerList = [];
    for (Map<String, dynamic> map in result) {
      customerList.add(Customer.fromJson(map));
    }

    return customerList;
  }

  Future<int> insertMarketingActivityData(Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert('marketing_activity', data);
  }

  Future<int> checkInOnRoute(
    String ruteId,
    String userId,
    String imagePath,
    double lat,
    double lon,
  ) async {
    Database db = await database;
    var today = DateTime.now().toIso8601String().substring(0, 10);
    await db.update(
      'marketing_activity',
      {
        'foto_ci': imagePath,
        'waktu_ci': DateTime.now().toIso8601String(),
        'lat_ci': lat,
        'lon_ci': lon,
      },
      where: 'rute_id = ? AND created_at LIKE ?',
      whereArgs: [ruteId, '$today%'],
    );
    List<Map<String, dynamic>> result = await db.query(
      'marketing_activity',
      where: 'rute_id = ? AND created_at LIKE ?',
      whereArgs: [ruteId, '$today%'],
    );
    int idMA = result[0]['id'];
    return idMA;
  }

  Future<int> checkIn(
    String ruteId,
    String userId,
    String imagePath,
    double lat,
    double lon,
  ) async {
    Database db = await database;
    var today = DateTime.now().toIso8601String().substring(0, 10);
    await db.update(
      'marketing_activity',
      {
        'foto_ci': imagePath,
        'waktu_ci': DateTime.now().toIso8601String(),
        'lat_ci': lat,
        'lon_ci': lon,
      },
      where: 'rute_id = ? AND created_at LIKE ?',
      whereArgs: [ruteId, '$today%'],
    );
    List<Map<String, dynamic>> result = await db.query(
      'marketing_activity',
      where: 'rute_id = ? AND created_at LIKE ?',
      whereArgs: [ruteId, '$today%'],
    );
    int idMA = result[0]['id'];
    return idMA;
  }

  Future<int> checkOut(
    int idMA,
    double lat,
    double lon,
    String statusCall,
    String jenis,
  ) async {
    Database db = await database;
    return await db.update(
      'marketing_activity',
      {
        'waktu_co': DateTime.now().toIso8601String(),
        'lat_co': lat,
        'lon_co': lon,
        'status_call': statusCall,
        'jenis': jenis,
      },
      where: 'id = ?',
      whereArgs: [idMA],
    );
  }

  Future<List<MarketingActivity>> getMarketingActivityList() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('marketing_activity');
    List<MarketingActivity> marketingActivityList = [];
    for (Map<String, dynamic> map in result) {
      marketingActivityList.add(MarketingActivity.fromJson(map));
    }
    return marketingActivityList;
  }

  Future<List<Map<String, dynamic>>> getCanvasingList() async {
    Database db = await database;
    // make query to get marketing_activity data with jenis = canvasing
    // then join with canvasing table to get the data
    // exclude the id column from canvasing table

    var query = '''
  SELECT marketing_activity.*, canvasing.CustID, canvasing.nama_outlet, canvasing.nama_owner, canvasing.no_hp, canvasing.latitude, canvasing.longitude, canvasing.alamat, canvasing.image_path
  FROM marketing_activity
  JOIN canvasing ON marketing_activity.cust_id = canvasing.CustID
  WHERE marketing_activity.jenis = 'canvasing'
''';
    return await db.rawQuery(query);
  }

  Future<Map<String, dynamic>> getMarketingActivity(int idMA) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'marketing_activity',
      where: 'id = ?',
      whereArgs: [idMA],
    );

    return result.isNotEmpty ? result[0] : {};
  }

  Future<void> updateMarketingActivityStatus(int idMA) async {
    Database db = await database;
    await db.update(
      'marketing_activity',
      {'status_sync': 1},
      where: 'id = ?',
      whereArgs: [idMA],
    );
  }

  Future<List<Map<String, dynamic>>> getSyncedMarketingActivity(
    int? status,
  ) async {
    Database db = await database;
    List<Map<String, dynamic>> result = status != null
        ? await db.query(
            'marketing_activity',
            where: 'status_sync = ?',
            whereArgs: [status],
          )
        : await db.query('marketing_activity');

    return result;
  }

  Future<List<Map<String, dynamic>>> getImageItems(int idMA) async {
    Database db = await database;
    return await db.query(
      'imagepath',
      where: 'id_marketing_activity = ?',
      whereArgs: [idMA],
    );
  }

  Future<int> insertMessage(Map<String, dynamic> message) async {
    Database db = await database;
    return await db.insert('chat_messages', message);
  }

  Future<int> removeStockReport(int id) async {
    Database db = await database;
    return await db.delete('stocks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> removeCompetitor(int id) async {
    Database db = await database;
    return await db.delete('competitors', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertStockReport(Map<String, dynamic> stockReport) async {
    Database db = await database;
    return await db.insert('stocks', stockReport);
  }

  Future<int> insertCompetitor(Map<String, dynamic> competitor) async {
    Database db = await database;
    return await db.insert('competitors', competitor);
  }

  Future<int> updateStockReport(Map<String, dynamic> stockReport) async {
    Database db = await database;
    return await db.update(
      'stocks',
      stockReport,
      where: 'id = ?',
      whereArgs: [stockReport['id']],
    );
  }

  Future<int> updateCompetitor(Map<String, dynamic> competitor) async {
    Database db = await database;
    return await db.update(
      'competitors',
      competitor,
      where: 'id = ?',
      whereArgs: [competitor['id']],
    );
  }

  Future<void> truncateTable(String table) async {
    Database db = await database;
    await db.execute('DELETE FROM $table');
  }
}
