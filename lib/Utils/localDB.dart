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
    return await openDatabase(path, version: 1, onCreate: onCreate);
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
      if (trx.statusLunas != null) {
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

  Future<Map<String, dynamic>?> getLatestSemesterAndYear() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'transaksi',
      columns: ['semester', 'tahun_ajaran'],
    );

    if (maps.isEmpty) {
      return null;
    }

    maps.sort((a, b) {
      String yearA = a['tahun_ajaran'] ?? '';
      String yearB = b['tahun_ajaran'] ?? '';

      int yearAStart = int.tryParse(yearA.split('/').first) ?? 0;
      int yearBStart = int.tryParse(yearB.split('/').first) ?? 0;

      if (yearAStart != yearBStart) {
        return yearBStart.compareTo(yearAStart);
      } else {
        int semA = a['semester'] ?? 0;
        int semB = b['semester'] ?? 0;
        return semB.compareTo(semA);
      }
    });

    final latest = maps.first;

    return {
      'semester': latest['semester'],
      'tahun_ajaran': latest['tahun_ajaran'],
    };
  }
}