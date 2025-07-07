import 'package:aplikasikkp/model/transaksi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class localDB {
  static final localDB panggilini = localDB._internal();
  factory localDB() => panggilini;
  static Database? _database;

  localDB._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'transaksi.db');
    return await openDatabase(path, version: 3, onCreate: onCreate, onUpgrade: onUpgrade);
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE transaksi (
      id_transaksi INTEGER PRIMARY KEY,
      id_spp INTEGER,
      spp TEXT,
      potongan TEXT,
      bulan INTEGER,
      semester INTEGER,
      tahun_ajaran TEXT,
      status_lunas TEXT,
      id_ketua_komite INTEGER,
      nama_ketua_komite TEXT,
      id_kepala_sekolah INTEGER,
      kepala_sekolah TEXT,
      created_at TEXT,
      updated_at TEXT,
      deleted_at TEXT,
      created_by TEXT,
      updated_by TEXT,
      deleted_by TEXT,
      nama_lengkap TEXT,
      id_account INTEGER
    );
    ''');
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('''
      CREATE TABLE transaksi_new (
        id_transaksi INTEGER PRIMARY KEY,
        id_spp INTEGER,
        nama_kelas TEXT,
        spp TEXT,
        potongan TEXT,
        bulan INTEGER,
        semester INTEGER,
        tahun_ajaran TEXT,
        status_lunas TEXT,
        id_ketua_komite INTEGER,
        nama_ketua_komite TEXT,
        id_kepala_sekolah INTEGER,
        kepala_sekolah TEXT,
        created_at TEXT,
        updated_at TEXT,
        deleted_at TEXT,
        created_by INTEGER,
        updated_by INTEGER,
        deleted_by INTEGER,
        nama_lengkap TEXT,
        id_account INTEGER,
        status_verifikasi INTEGER,
        id_verifikasi INTEGER,
        nisn TEXT,
        id_NIS TEXT
      );
    ''');

      await db.execute('DROP TABLE transaksi;');

      await db.execute('ALTER TABLE transaksi_new RENAME TO transaksi;');
    }
  }

  Future<List<transaksi>> getTransaksi() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transaksi');
    return List.generate(maps.length, (i) {
      return transaksi.fromJson(maps[i]);
    });
  }

  Future<int> insertTransaction(transaksi transaksi) async {
    Database db = await database;
    return await db.insert('transaksi', transaksi.toJson());
  }

  Future<int> deleteAllTransaction() async {
    Database db = await database;
    return await db.delete(
        'transaksi'
    );
  }

  Future<int> updateTransaction(transaksi transaksi) async {
    Database db = await database;
    return await db.update(
        'transaksi',
        transaksi.toJson(),
        where: 'id_transaksi = ?',
        whereArgs: [transaksi.idTransaksi]
        );
  }

  Future<List<transaksi>> getSpecificTransaction(String filter) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('transaksi');

    List<transaksi> filteredTransactions = maps
        .map((map) => transaksi.fromJson(map))
        .where((trx) {
      if (trx.statusLunas != null) {
        final parts = trx.statusLunas!.split('|');
        if (parts.isNotEmpty) {
          return parts.first.trim() == filter;
        }
      }
      return false;
    })
        .toList();
    return filteredTransactions;
  }

  Future<List<transaksi>> getSixMonthTransaction(String filter) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transaksi');

    DateTime now = DateTime.now();
    DateTime sixMonthsAgo = DateTime(now.year, now.month - 5, now.day);

    List<transaksi> filteredTransactions = maps
        .map((map) => transaksi.fromJson(map))
        .where((trx) {
      if (trx.statusLunas != null && trx.status_verifikasi == 1) {
        final parts = trx.statusLunas!.split('|');
        if (parts.isNotEmpty) {
          String status = parts[0].trim();
          if (status != filter) return false;

          if (parts.length > 1) {
            try {
              DateTime trxDate = DateTime.parse(parts[1].trim());
              return trxDate.isAfter(sixMonthsAgo) || trxDate.isAtSameMomentAs(sixMonthsAgo);
            } catch (e) {
              return false;
            }
          }
        }
      }
      return false;
    })
        .toList();
    return filteredTransactions;
  }

  Future<int> countTotalTagihan(String statusFilter) async {
    final db = await database;

    final countResult = Sqflite.firstIntValue(
        await db.rawQuery(
        '''
        SELECT COUNT(*) 
        FROM transaksi 
        WHERE status_lunas LIKE ?
        ''',
        ['$statusFilter|%']
    )
    );

    return countResult ?? 0;
  }

  Future<List<transaksi>> getSixMonthTransactionWithoutFilter() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transaksi');

    DateTime now = DateTime.now();
    DateTime sixMonthsAgo = DateTime(now.year, now.month - 5, now.day);

    // Filter: ambil transaksi dalam 6 bulan terakhir
    List<transaksi> filteredTransactions = maps
        .map((map) => transaksi.fromJson(map))
        .where((trx) {
      try {
        final trxDate = DateTime.parse(trx.createdAt!);
        return trxDate.isAfter(sixMonthsAgo) || trxDate.isAtSameMomentAs(sixMonthsAgo);
      } catch (e) {
        return false;
      }
    })
        .toList();

    // Sort: berdasarkan bulan ASC, dan created_at ASC
    filteredTransactions.sort((a, b) {
      final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(1970);
      final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(1970);

      // Urutkan berdasarkan bulan dulu
      if (dateA.month != dateB.month) {
        return dateA.month.compareTo(dateB.month);
      }

      // Kalau bulannya sama, urutkan berdasarkan waktu created_at
      return dateA.compareTo(dateB);
    });

    // Ambil hanya 6 data paling baru (berdasarkan created_at DESC sebelum diurutkan ulang)
    filteredTransactions = filteredTransactions.reversed.take(6).toList();

    // Lalu urutkan kembali berdasarkan bulan dan waktu ASC
    filteredTransactions.sort((a, b) {
      final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(1970);
      final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(1970);

      if (dateA.month != dateB.month) {
        return dateA.month.compareTo(dateB.month);
      }
      return dateA.compareTo(dateB);
    });

    return filteredTransactions;
  }

  // Future<Map<String, dynamic>?> getLatestSemesterAndYear() async {
  //   final db = await database;
  //
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     'transaksi',
  //     columns: ['semester', 'tahun_ajaran'],
  //   );
  //
  //   if (maps.isEmpty) {
  //     return null;
  //   }
  //
  //   maps.sort((a, b) {
  //     String yearA = a['tahun_ajaran'] ?? '';
  //     String yearB = b['tahun_ajaran'] ?? '';
  //
  //     int yearAStart = int.tryParse(yearA.split('/').first) ?? 0;
  //     int yearBStart = int.tryParse(yearB.split('/').first) ?? 0;
  //
  //     if (yearAStart != yearBStart) {
  //       return yearBStart.compareTo(yearAStart);
  //     } else {
  //       int semA = a['semester'] ?? 0;
  //       int semB = b['semester'] ?? 0;
  //       return semB.compareTo(semA);
  //     }
  //   });
  //
  //   final latest = maps.first;
  //
  //   return {
  //     'semester': latest['semester'],
  //     'tahun_ajaran': latest['tahun_ajaran'],
  //   };
  // }

  Future<List<transaksi>> getLatestDateTransactionsFiltered(String statusFilter) async {
    final db = await database;

    final latestDateResult = await db.rawQuery(
        '''
        SELECT SUBSTR(created_at, 1, 10) AS date_only 
        FROM transaksi 
        ORDER BY date_only DESC 
        LIMIT 1
        '''
    );

    if (latestDateResult.isEmpty) return [];

    final latestDate = latestDateResult.first['date_only'] as String;

    final maps = await db.query(
      'transaksi',
      where: "SUBSTR(created_at, 1, 10) = ? AND status_lunas LIKE ?",
      whereArgs: [latestDate, '$statusFilter|%'],
    );

    return maps.map((map) => transaksi.fromJson(map)).toList();
  }

  Future<List<transaksi>> getLatestDateTransactionsFilteredByStatus(String statusFilterPrefix) async {
    final db = await database;

    final latestDateResult = await db.rawQuery(
        '''
        SELECT SUBSTR(created_at, 1, 10) AS date_only
        FROM transaksi
        ORDER BY date_only DESC
        LIMIT 1
        '''
    );

    if (latestDateResult.isEmpty) {
      return [];
    }

    final latestDate = latestDateResult.first['date_only'] as String;

    final maps = await db.query(
      'transaksi',
      where: "SUBSTR(created_at, 1, 10) = ? AND status_lunas LIKE ?",
      whereArgs: [latestDate, '$statusFilterPrefix|%'],
    );

    return maps.map((map) => transaksi.fromJson(map)).toList();
  }

  Future<List<transaksi>> getLatestUnverifiedTransactionsWithAnyLunasStatus() async {
    final db = await database;

    final latestDateResult = await db.rawQuery(
        '''
    SELECT SUBSTR(created_at, 1, 10) AS date_only
    FROM transaksi
    ORDER BY date_only DESC
    LIMIT 1
    '''
    );

    if (latestDateResult.isEmpty) {
      return [];
    }

    final latestDate = latestDateResult.first['date_only'] as String;

    final maps = await db.query(
      'transaksi',
      where: '''
      SUBSTR(created_at, 1, 10) = ? AND (
        (status_lunas LIKE ? AND status_verifikasi = 0) OR 
        (status_lunas LIKE ? AND status_verifikasi = 0)
      )
    ''',
      whereArgs: [
        latestDate,
        '0|%',
        '1|%',
      ],
    );

    return maps.map((map) => transaksi.fromJson(map)).toList();
  }


  Future<List<transaksi>> getUnconfirmedTransactions() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'transaksi',
      where: "status_verifikasi = ? AND status_lunas LIKE ?",
      whereArgs: [0, '1|%'],
      orderBy: "created_at DESC",
    );

    print("Unconfirmed transactions count: ${maps.length}");

    return maps.map((map) => transaksi.fromJson(map)).toList();
  }

  Future<Map<String, dynamic>?> getLatestSemesterAndYear() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'transaksi',
      columns: ['semester', 'tahun_ajaran'],
      orderBy: 'tahun_ajaran DESC, semester DESC',
      limit: 1,
    );

    if (maps.isEmpty) {
      print("No semester/tahun_ajaran data found.");
      return null;
    }

    final latest = maps.first;
    print("Latest semester data: $latest");

    return {
      'semester': latest['semester'],
      'tahun_ajaran': latest['tahun_ajaran'],
    };
  }

  // error function
  Future<List<transaksi>> getLatestDateTransactionsSortedByMonth() async {
    final db = await database;

    final latestDateResult = await db.rawQuery(
        '''
        SELECT SUBSTR(created_at, 1, 10) AS date_only 
        FROM transaksi 
        ORDER BY date_only DESC 
        LIMIT 1
        '''
    );

    if (latestDateResult.isEmpty) return [];

    final latestDate = latestDateResult.first['date_only'] as String;

    final maps = await db.query(
      'transaksi',
      where: "SUBSTR(created_at, 1, 10) = ?",
      whereArgs: [latestDate],
    );

    List<transaksi> transaksiList = maps.map((map) => transaksi.fromJson(map)).toList();

    transaksiList.sort((a, b) {
      int monthA = 0;
      int monthB = 0;

      if (a.createdAt != null && a.createdAt!.isNotEmpty) {
        monthA = int.tryParse(a.createdAt!.split('-')[1]) ?? 0;
      }
      if (b.createdAt != null && b.createdAt!.isNotEmpty) {
        monthB = int.tryParse(b.createdAt!.split('-')[1]) ?? 0;
      }

      return monthA.compareTo(monthB);
    });

    return transaksiList;
  }

  Future<List<transaksi>> getFilteredTransactions({
    required String status,
    String? semester,
    String? tahunAjaran,
  }) async {
    final db = await database;

    final whereClause = StringBuffer("status_lunas LIKE ? AND status_verifikasi = 1");
    final whereArgs = <dynamic>['$status|%'];

    if (semester != null) {
      whereClause.write(" AND semester = ?");
      whereArgs.add(semester);
    }

    if (tahunAjaran != null) {
      whereClause.write(" AND tahun_ajaran = ?");
      whereArgs.add(tahunAjaran);
    }

    final maps = await db.query(
      'transaksi',
      where: whereClause.toString(),
      whereArgs: whereArgs,
    );
    return maps.map((e) => transaksi.fromJson(e)).toList();
  }
}