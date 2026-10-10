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

   Future<void> createProduct(Product product) async {
      final db = await instance.database;
      
      await db.insert(tableProducts, product.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<Product> readProduct(String id) async {
      final db = await instance.database;

      final maps = await db.query(
        tableProducts,
        columns: ProductFields.values,
        where: '${ProductFields.id} = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Product.fromJson(maps.first);
      } else {
        throw Exception('ID $id not found');
      }
    }

    Future<List<Product>> readAllProducts() async {
      final db = await instance.database;
      final result = await db.query(tableProducts);
      return result.map((json) => Product.fromJson(json)).toList();
    }

    Future<void> createUser(User user) async {
      final db = await instance.database;
      await db.insert(tableusers, user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<User> readUser(String id) async {
      final db = await instance.database;

      final maps = await db.query(
        tableusers,
        columns: UserFields.values,
        where: '${UserFields.id} = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return User.fromJson(maps.first);
      } else {
        throw Exception('ID $id not found');
      }
    }

    Future<List<User>> readAllUsers() async {
      final db = await instance.database;
      final result = await db.query(tableusers);
      return result.map((json) => User.fromJson(json)).toList();
    }

    Future<void> createInventoryBatch(InventoryBatch batch) async {
      final db = await instance.database;
      await db.insert(tableInventoryBatches, batch.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<InventoryBatch> readInventoryBatch(String id) async {
      final db = await instance.database;

      final maps = await db.query(
        tableInventoryBatches,
        columns: InventoryBatchFields.values,
        where: '${InventoryBatchFields.id} = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return InventoryBatch.fromJson(maps.first);
      } else {
        throw Exception('ID $id not found');
      }
    }

    Future<List<InventoryBatch>> readAllInventoryBatches() async {
      final db = await instance.database;
      final result = await db.query(tableInventoryBatches);
      return result.map((json) => InventoryBatch.fromJson(json)).toList();
    }

    Future<void> createTransaction(Transaction transaction) async {
      final db = await instance.database;
      await db.insert(tableTransactions, transaction.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<Transaction> readTransaction(String id) async {
      final db = await instance.database;

      final maps = await db.query(
        tableTransactions,
        columns: TransactionFields.values,
        where: '${TransactionFields.id} = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Transaction.fromJson(maps.first);
      } else {
        throw Exception('ID $id not found');
      }
    }

    Future<List<Transaction>> readAllTransactions() async {
      final db = await instance.database;
      final result = await db.query(tableTransactions);
      return result.map((json) => Transaction.fromJson(json)).toList();
    }

    Future<void> createTransactionItem(TransactionItem item) async {
      final db = await instance.database;
      await db.insert(tableTransactionItems, item.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<TransactionItem> readTransactionItem(String id) async {
      final db = await instance.database;

      final maps = await db.query(
        tableTransactionItems,
        columns: TransactionItemFields.values,
        where: '${TransactionItemFields.id} = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return TransactionItem.fromJson(maps.first);
      } else {
        throw Exception('ID $id not found');
      }
    }

    Future<List<TransactionItem>> readAllTransactionItems() async {
      final db = await instance.database;
      final result = await db.query(tableTransactionItems);
      return result.map((json) => TransactionItem.fromJson(json)).toList();
    }
    Future close() async{
      final db = await instance.database;
      db.close();
    } 




}

