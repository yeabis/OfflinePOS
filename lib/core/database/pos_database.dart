import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:offline_pos/core/database/db_schemas.dart';

class pos_database{
    static final pos_database instance = pos_database._init();

    static Database? _database;
    
    pos_database._init();

    Future<Database> get database async{
      if(_database != null) return _database!;
      _database = await _initDB('pos.db');
      return _database!;

      
    }
    Future<Database> _initDB(String filePath) async{
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(path, version: 1, onCreate: _createDB);



    }

    Future _createDB(Database db , int version)async{
        final idType = 'TEXT PRIMARY KEY NOT NULL';
        final textType = 'TEXT NOT NULL';
        final realType = 'REAL NOT NULL'; 
        final intType = 'INTEGER NOT NULL';  
        final textNullable = 'TEXT';    

      await db.execute('''
        CREATE TABLE $tableProducts (
          ${ProductFields.id} $idType,
          ${ProductFields.barcode} $textType,
          ${ProductFields.name} $textType,
          ${ProductFields.defaultPrice} $realType,
          ${ProductFields.taxRate} $realType
        )
      ''');

      await db.execute('''
        CREATE TABLE $tableusers (
          ${UserFields.id} $idType,
          ${UserFields.username} $textType,
          ${UserFields.password} $textType,
          ${UserFields.email} $textType,
          ${UserFields.role} $textType,
          ${UserFields.createdAt} $textType
        )
      ''');

      await db.execute('''
        CREATE TABLE $tableInventoryBatches (
          ${InventoryBatchFields.id} $idType,
          ${InventoryBatchFields.productId} $textType,
          ${InventoryBatchFields.quantity} $intType,
          ${InventoryBatchFields.receivedDate} $textType,
          ${InventoryBatchFields.expiryDate} $textNullable,
          FOREIGN KEY (${InventoryBatchFields.productId}) REFERENCES $tableProducts (${ProductFields.id})
        )
      ''');

      await db.execute('''
        CREATE TABLE $tableTransactions (
          ${TransactionFields.id} $idType,
          ${TransactionFields.cashierId} $textType,
          ${TransactionFields.subtotal} $realType,
          ${TransactionFields.taxAmount} $realType,
          ${TransactionFields.discountAmount} $realType,
          ${TransactionFields.grandTotal} $realType,
          ${TransactionFields.paymentMethod} $textType,
          ${TransactionFields.timestamp} $textType,
          ${TransactionFields.syncStatus} $intType,
          FOREIGN KEY (${TransactionFields.cashierId}) REFERENCES $tableUsers (${UserFields.id})
        )
      ''');

      await db.execute('''
        CREATE TABLE $tableTransactionItems (
          ${TransactionItemFields.id} $idType,
          ${TransactionItemFields.transactionId} $textType,
          ${TransactionItemFields.productId} $textType,
          ${TransactionItemFields.quantity} $intType,
          ${TransactionItemFields.unitPriceAtSale} $realType,
          ${TransactionItemFields.lineTotal} $realType,
          FOREIGN KEY (${TransactionItemFields.transactionId}) REFERENCES $tableTransactions (${TransactionFields.id}),
          FOREIGN KEY (${TransactionItemFields.productId}) REFERENCES $tableProducts (${ProductFields.id})
        )
      ''');
    }


    Future close() async{
      final db = await instance.database;
      db.close();
    } 




}

