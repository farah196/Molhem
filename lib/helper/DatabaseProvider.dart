
import 'dart:io';

import 'package:molhem/models/QuoteModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Quote.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE Quote (id TEXT PRIMARY KEY, quote TEXT, said TEXT)');

//          await db.execute("CREATE TABLE Quote ("
//              "id INTEGER PRIMARY KEY,"
//              "quote TEXT,"
//              "said TEXT,"
//              ")");
        });
  }

  addQuote(QuoteModel quote) async {
    final db = await database;
    //get the biggest id in the table
//    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Quote");
//    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Quote (id,quote,said)"
            " VALUES (?,?,?)",
        [quote.id, quote.quote, quote.said]);
    return raw;
  }

  getQuoteById(String id) async {
    final db = await database;
    var res = await db.query("Quote", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? QuoteModel.fromMap(res.first) : null;
  }

  isExist(String id) async {
    final db = await database;
    var res = await db.query("Quote", where: "id = ?", whereArgs: [id]);
    return res.isEmpty? false : true ;
  }

  Future<List<QuoteModel>> getAllQuote() async {
    final db = await database;
    var res = await db.query("Quote");
    List<QuoteModel> list =
    res.isNotEmpty ? res.map((c) => QuoteModel.fromMap(c)).toList() : [];
    return list;
  }

  deleteQuoteById(String id) async {
    final db = await database;
    return db.delete("Quote", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Quote");
  }



}
