import 'package:ahshiaka/models/AddressLocalModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _instance = new DbHelper.internal();
  factory DbHelper() => _instance;
  DbHelper.internal();
  dynamic _db;
  Future<Database> createDatabase() async {
    if (_db != null) {
      return _db;
    }
    //define the path to the database
    String path = join(await getDatabasesPath(), 'cart.db');
    _db = await openDatabase(path, version: 1, onCreate: (Database db, int v) {
      //create tables
      db.execute("CREATE TABLE address ("
          "product_id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "id INTEGER,"
          "firstname TEXT,"
          "lastname TEXT,"
          "phone TEXT,"
          "email REAL,"
          "state REAL,"
          "region INTEGER,"
          "city INTEGER,"
          "address INTEGER,"
          "code TEXT"
          ")");
    });
    return _db;
  }

  Future<int> addToCart(
      AddressMedelLocal addressMedelLocal, String? addressId) async {
    Database db = await createDatabase();
    //db.rawInsert('insert into courses value')
    return addressId == null
        ? db.insert('address', addressMedelLocal.toMap())
        : db.update('address', addressMedelLocal.toMap());
  }

  Future<List> allProduct() async {
    Database db = await createDatabase();
    //db.rawQuery('select * from courses');
    return db.query('address');
  }

  Future<int> delete(var product_id) async {
    Database db = await createDatabase();
    return db.delete('address', where: 'code = ?', whereArgs: [product_id]);
  }

  Future<int> deleteCart() async {
    Database db = await createDatabase();
    return db.delete('product');
  }

  Future<int> updateCourse(AddressMedelLocal addressMedelLocal) async {
    Database db = await createDatabase();
    var x = await db.update('address', addressMedelLocal.toMap(),
        where: 'id = ?', whereArgs: [addressMedelLocal.id]);
    return x;
  }
}
