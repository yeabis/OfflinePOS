import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:offline_pos/core/database/db_schemas.dart';

class PosDatabase {
  static final PosDatabase instance = PosDatabase._init();

  static Database? _database;

  PosDatabase._init();

    Future<Database> get database async{
      if(_database != null) return _database!;
      _database = await _initDB('pos.db');
      return _database!;

      
    }
    Future<Database> _initDB(String filePath) async{
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
        onOpen: (db) async {
          await _seedInitialProducts(db);
        },
      );
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
        CREATE TABLE $tableUsers (
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

      await db.insert(tableUsers, {
        UserFields.id: 'user_001',
        UserFields.username: 'almaz',
        UserFields.password: '1234',
        UserFields.email: 'admin@suk.com',
        UserFields.role: 'cashier',
        UserFields.createdAt: DateTime.now().toIso8601String(),
      });

      await db.insert(tableUsers, {
        UserFields.id: 'user_002',
        UserFields.username: 'aaron',
        UserFields.password: '1234',
        UserFields.email: 'aaron@suk.com',
        UserFields.role: 'Owner',
        UserFields.createdAt: DateTime.now().toIso8601String(),
      });



      await _seedInitialProducts(db);
    }

    Future<void> _seedInitialProducts(Database db) async {
      final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableProducts')) ?? 0;
      if (count == 0) {
        final initialProducts = [
          const Product(id: 'prod_1', barcode: '6972476860584', name: 'Small Notebook', defaultPrice: 15.0, taxRate: 0.15),
          const Product(id: 'prod_2', barcode: '911249496120', name: 'Big Notebook', defaultPrice: 25.0, taxRate: 0.15),
          const Product(id: 'prod_3', barcode: '8992696420557', name: 'Nescafe', defaultPrice: 5.0, taxRate: 0.15),
          const Product(id: 'prod_4', barcode: '3587925290152', name: 'Cotten-Cotten', defaultPrice: 2.0, taxRate: 0.15),
          const Product(id: 'prod_5', barcode: '8850124011053', name: 'coffeemate', defaultPrice: 7.0, taxRate: 0.15),
        ];
        for (final p in initialProducts) {
          await db.insert(tableProducts, p.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
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

    Future<Product?> getProductByBarcode(String barcode) async {
      final db = await instance.database;

      final maps = await db.query(
        tableProducts,
        columns: ProductFields.values,
        where: '${ProductFields.barcode} = ? OR LOWER(${ProductFields.name}) = ?',
        whereArgs: [barcode.trim(), barcode.trim().toLowerCase()],
      );

      if (maps.isNotEmpty) {
        return Product.fromJson(maps.first);
      } else {
        return null;
      }
    }

    Future<void> createUser(User user) async {
      final db = await instance.database;
      await db.insert(tableUsers, user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<User> readUser(String id) async {
      final db = await instance.database;

      final maps = await db.query(
        tableUsers,
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
      final result = await db.query(tableUsers);
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

    Future<List<Map<String, dynamic>>> getAllTransactions() async {

      final db = await instance.database;
      
      final List<Map<String, dynamic>> transactionRows = await db.query(
        tableTransactions,
        orderBy: '${TransactionFields.timestamp} DESC',
      );

      List<Map<String, dynamic>> fullTransactions = [];

      for (var row in transactionRows) {
        final transactionId = row[TransactionFields.id] as String;

        final List<Map<String, dynamic>> itemRows = await db.rawQuery('''
          SELECT 
            ti.${TransactionItemFields.id} AS id,
            ti.${TransactionItemFields.productId} AS productId,
            ti.${TransactionItemFields.quantity} AS qty,
            ti.${TransactionItemFields.unitPriceAtSale} AS price,
            ti.${TransactionItemFields.lineTotal} AS total,
            p.${ProductFields.name} AS name
          FROM $tableTransactionItems ti
          LEFT JOIN $tableProducts p ON ti.${TransactionItemFields.productId} = p.${ProductFields.id}
          WHERE ti.${TransactionItemFields.transactionId} = ?
        ''', [transactionId]);

        fullTransactions.add({
          'id': transactionId,
          'billNo': '#SK-${transactionId.length > 6 ? transactionId.substring(0, 6).toUpperCase() : transactionId}',
          'date': row[TransactionFields.timestamp] ?? 'Unknown Date',
          'cashierId': row[TransactionFields.cashierId],
          'subtotal': row[TransactionFields.subtotal],
          'tax': row[TransactionFields.taxAmount],
          'grandTotal': row[TransactionFields.grandTotal],
          'paymentMethod': row[TransactionFields.paymentMethod],
          'cart': itemRows,
        });
      }

      return fullTransactions;
    }

    Future<String> saveTransaction({
      required List<Map<String, dynamic>> cart,
      required double subtotal,
      required double tax,
      required double grandTotal,
      String cashierId = 'user_001',
      String paymentMethod = 'CASH',
    }) async {
      final db = await instance.database;
      final transactionId = 'TX_${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now().toIso8601String();

      await db.transaction((txn) async {
        await txn.insert(tableTransactions, {
          TransactionFields.id: transactionId,
          TransactionFields.cashierId: cashierId,
          TransactionFields.subtotal: subtotal,
          TransactionFields.taxAmount: tax,
          TransactionFields.discountAmount: 0.0,
          TransactionFields.grandTotal: grandTotal,
          TransactionFields.paymentMethod: paymentMethod,
          TransactionFields.timestamp: now,
          TransactionFields.syncStatus: 0,
        });

        for (int i = 0; i < cart.length; i++) {
          final item = cart[i];
          final itemId = '${transactionId}_item_$i';
          final qty = (item['qty'] as num?)?.toInt() ?? 1;
          final price = (item['price'] as num?)?.toDouble() ?? 0.0;
          await txn.insert(tableTransactionItems, {
            TransactionItemFields.id: itemId,
            TransactionItemFields.transactionId: transactionId,
            TransactionItemFields.productId: item['id'] as String? ?? 'unknown',
            TransactionItemFields.quantity: qty,
            TransactionItemFields.unitPriceAtSale: price,
            TransactionItemFields.lineTotal: qty * price,
          });
        }
      });

      return transactionId;
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
    Future<int> updateProduct(Product product) async {
      final db = await instance.database;
      return db.update(
        tableProducts,
        product.toJson(),
        where: '${ProductFields.id} = ?',
        whereArgs: [product.id],
      );
    }

    Future<int> deleteProduct(String id) async {
      final db = await instance.database;
      return await db.delete(
        tableProducts,
        where: '${ProductFields.id} = ?',
        whereArgs: [id],
      );
    }

    Future<int> updateUser(User user) async {
      final db = await instance.database;
      return db.update(
        tableUsers,
        user.toJson(),
        where: '${UserFields.id} = ?',
        whereArgs: [user.id],
      );
    }

    Future<int> deleteUser(String id) async {
      final db = await instance.database;
      return await db.delete(
        tableUsers,
        where: '${UserFields.id} = ?',
        whereArgs: [id],
      );
    }

    Future<int> updateInventoryBatch(InventoryBatch batch) async {
      final db = await instance.database;
      return db.update(
        tableInventoryBatches,
        batch.toJson(),
        where: '${InventoryBatchFields.id} = ?',
        whereArgs: [batch.id],
      );
    }

    Future<int> deleteInventoryBatch(String id) async {
      final db = await instance.database;
      return await db.delete(
        tableInventoryBatches,
        where: '${InventoryBatchFields.id} = ?',
        whereArgs: [id],
      );
    }

    Future<int> updateTransaction(Transaction transaction) async {
      final db = await instance.database;
      return db.update(
        tableTransactions,
        transaction.toJson(),
        where: '${TransactionFields.id} = ?',
        whereArgs: [transaction.id],
      );
    }

    Future<int> deleteTransaction(String id) async {
      final db = await instance.database;
      return await db.delete(
        tableTransactions,
        where: '${TransactionFields.id} = ?',
        whereArgs: [id],
      );
    }

    Future<int> updateTransactionItem(TransactionItem item) async {
      final db = await instance.database;
      return db.update(
        tableTransactionItems,
        item.toJson(),
        where: '${TransactionItemFields.id} = ?',
        whereArgs: [item.id],
      );
    }

    Future<int> deleteTransactionItem(String id) async {
      final db = await instance.database;
      return await db.delete(
        tableTransactionItems,
        where: '${TransactionItemFields.id} = ?',
        whereArgs: [id],
      );
    }

    Future close() async {
      final db = await instance.database;
      db.close();
    }

    Future<Map<String, dynamic>?> login(String username, String password) async {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        tableUsers,
        where: '${UserFields.username} = ? AND ${UserFields.password} = ?',
        whereArgs: [username, password],
      );

      if (result.isNotEmpty) {
        return result.first;
      } else {
        return null;
      }
    }
}


