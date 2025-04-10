import 'package:sqflite/sqflite.dart';
import 'package:uapp/core/database/ext.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:path/path.dart';

class MarketingDatabase {
  static final MarketingDatabase _instance =
      MarketingDatabase._privateConstructor();
  static Database? _database;
  final int marketingDbVersion = 8;

  MarketingDatabase._privateConstructor();

  factory MarketingDatabase() {
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
    String path = join(await getDatabasesPath(), 'marketing.db');
    return await openDatabase(
      path,
      version: marketingDbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    Log.d('creating database...');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS marketing_activity (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        rute_id TEXT,
        cust_id TEXT,
        top_id TEXT,
        cust_name TEXT,
        foto_ci TEXT,
        waktu_ci TEXT,
        waktu_co TEXT,
        lat_ci DECIMAL(10, 8),
        lon_ci DECIMAL(11, 8),
        lat_co DECIMAL(10, 8),
        lon_co DECIMAL(11, 8),
        status_call TEXT DEFAULT 'unv',
        jenis TEXT,
        ttd TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status_sync INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS stock (
        idMA TEXT,
        item_id TEXT,
        name TEXT,
        quantity DECIMAL(10, 2),
        unit TEXT,
        image_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS competitor (
        idMA TEXT,
        name TEXT,
        price DECIMAL(10, 2),
        program TEXT,
        support TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS display (
        idMA TEXT,
        image TEXT,
        type TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS taking_order (
        idMA TEXT,
        itemid TEXT,
        description TEXT,
        quantity DECIMAL(10, 2),
        unit TEXT,
        price DECIMAL(10, 2),
        top TEXT,
        unit_id TEXT,
        ppn DECIMAL(10, 2) DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS collection (
        idMA TEXT,
        noinvoice TEXT,
        nocollect TEXT,
        amount DECIMAL(10, 2),
        type TEXT,
        bukti_bayar TEXT,
        status TEXT
      )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS mastergroup (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cluster_kelompok TEXT NOT NULL,
        type TEXT NOT NULL,
        kode TEXT NOT NULL,
        nama_desc TEXT NOT NULL,
        singkatan TEXT NOT NULL,
        definisi TEXT NOT NULL,
        active INTEGER DEFAULT 1
    )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS noo_activity (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idnoo TEXT,
        statussync INTEGER DEFAULT 0,
        status TEXT,
        approved INTEGER DEFAULT 0,
        idCustOrlan TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS top_options (
        TOP_ID TEXT PRIMARY KEY,
        Description TEXT
      )
    ''');

    await db.execute(mastergroupTable);
    await db.execute(invoiceTable);
    await db.execute(masterNooTable);
    await db.execute(ttdNooTable);
    await db.execute(nooAddressTable);
    await db.execute(nooDocumentTable);
    await db.execute(nooSpesimenTable);
    await db.execute(canvasingTable);
    await db.execute(deleteSevenDaysMarketingActivity);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 6) {
      Log.d('upgrading database...');

      await db.execute('''
      CREATE TABLE IF NOT EXISTS mastergroup (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          cluster_kelompok TEXT NOT NULL,
          type TEXT NOT NULL,
          kode TEXT NOT NULL,
          nama_desc TEXT NOT NULL,
          singkatan TEXT NOT NULL,
          definisi TEXT NOT NULL,
          active INTEGER DEFAULT 1
      )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS noo_activity (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          idnoo TEXT,
          statussync INTEGER DEFAULT 0,
          status TEXT,
          approved INTEGER DEFAULT 0,
          idCustOrlan TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS top_options (
          TOP_ID TEXT PRIMARY KEY,
          Description TEXT
        )
      ''');

      await db.execute(mastergroupTable);
    }

    if (oldVersion < 7) {
      // Check if the 'pembayaran' column exists in the 'canvasing' table
      var result = await db.rawQuery('PRAGMA table_info(canvasing)');
      bool columnExists = result.any((column) => column['name'] == 'pembayaran');

      if (!columnExists) {
        // Add the 'pembayaran' column if it does not exist
        await db.execute('''
          ALTER TABLE canvasing ADD COLUMN pembayaran INTEGER DEFAULT 0
        ''');
        Log.d('Column "pembayaran" added to "canvasing" table.');
      } else {
        Log.d('Column "pembayaran" already exists in "canvasing" table.');
      }
    }

    if (oldVersion < 8) {
            // Check if the 'ppn' column exists in the 'taking_order' table
      var result = await db.rawQuery('PRAGMA table_info(taking_order)');
      bool columnExists = result.any((column) => column['name'] == 'ppn');

      if (!columnExists) {
        // Add the 'ppn' column if it does not exist
        await db.execute('''
          ALTER TABLE taking_order ADD COLUMN ppn DECIMAL(10, 2) DEFAULT 0
        ''');
        Log.d('Column "ppn" added to "taking_order" table.');
      } else {
        Log.d('Column "ppn" already exists in "taking_order" table.');
      }
    }
  }

  Future<int> insert(String table, Map<String, dynamic> data,
      {String? nullColumnHack}) async {
    final db = await database;
    return await db.insert(
      table,
      data,
      nullColumnHack: nullColumnHack,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<List<Map<String, dynamic>>> rawQuery(String query,
      {List<dynamic>? args}) async {
    final db = await database;
    return await db.rawQuery(query, args);
  }

  Future<int> update(String table, Map<String, dynamic> data, String where,
      List<dynamic> whereArgs) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(
      String table, String where, List<dynamic> whereArgs) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('marketing_activity');
    await db.delete('stock');
    await db.delete('competitor');
    await db.delete('display');
    await db.delete('taking_order');
    await db.delete('collection');
    await db.delete('invoice');
    await db.delete('masternoo');
    // await db.delete('ttdnoo');
    await db.delete('nooaddress');
    await db.delete('noodocument');
    await db.delete('noospesimen');
    await db.delete('canvasing');
    await db.delete('mastergroup');
  }

  Future<Map<String, dynamic>> getAllData() async {
    final db = await database;
    final List<String> tables = [
      'marketing_activity',
      'stock',
      'competitor',
      'display',
      'taking_order',
      'collection',
      'invoice',
      'masternoo',
      'nooaddress',
      'noodocument',
      'noospesimen',
      'canvasing',
      'mastergroup'
    ];
    final Map<String, dynamic> result = {};
    for (String table in tables) {
      final List<Map<String, dynamic>> tableData = await db.query(table);
      result[table] = tableData;
    }
    return result;
  }
}
