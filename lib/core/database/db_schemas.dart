final String tableProducts = 'products';

class ProductFields {
  static final List<String> values = [
    id, barcode, name, defaultPrice, taxRate
  ];

  static const String id = 'product_id';
  static const String barcode = 'barcode';
  static const String name = 'product_name';
  static const String defaultPrice = 'default_price';
  static const String taxRate = 'tax_rate';
}

class Product {
  final String id;
  final String barcode;
  final String name;
  final double defaultPrice;
  final double taxRate;

  const Product({
    required this.id,
    required this.barcode,
    required this.name,
    required this.defaultPrice,
    required this.taxRate,
  });

  Map<String, Object?> toJson() {
    return {
      ProductFields.id: id,
      ProductFields.barcode: barcode,
      ProductFields.name: name,
      ProductFields.defaultPrice: defaultPrice,
      ProductFields.taxRate: taxRate,
    };
  }
  static Product fromJson(Map<String, Object?> json) {
    return Product(
      id: json[ProductFields.id] as String,
      barcode: json[ProductFields.barcode] as String,
      name: json[ProductFields.name] as String,
      defaultPrice: json[ProductFields.defaultPrice] as double,
      taxRate: json[ProductFields.taxRate] as double,
    );
  }
}

final String tableusers = 'users';

class UserFields {
  static final List<String> values = [
    id, username, password, email, role, createdAt
  ];

  static const String id = 'user_id';
  static const String username = 'username';
  static const String password = 'password';
  static const String email = 'email';
  static const String role = 'role';
  static const String createdAt = 'createdAt';
}

class User {
  final String id;
  final String username;
  final String password;
  final String email;
  final String role;
  final String createdAt;

  const User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.role,
    required this.createdAt,
  });
  Map<String, Object?> toJson() {
    return {
      UserFields.id: id,
      UserFields.username: username,
      UserFields.password: password,
      UserFields.email: email,
      UserFields.role: role,
      UserFields.createdAt: createdAt,
    };
  }

  static User fromJson(Map<String, Object?> json) {
    return User(
      id: json[UserFields.id] as String,
      username: json[UserFields.username] as String,
      password: json[UserFields.password] as String,
      email: json[UserFields.email] as String,
      role: json[UserFields.role] as String,
      createdAt: json[UserFields.createdAt] as String,
    );
  }
}

final String tableInventoryBatches = 'inventory_batches';




class InventoryBatchFields {
  static final List<String> values = [
    id, productId, quantity, receivedDate, expiryDate
  ];

  static const String id = 'batch_id';
  static const String productId = 'product_id';
  static const String quantity = 'quantity';
  static const String receivedDate = 'received_date';
  static const String expiryDate = 'expiry_date';
}

class InventoryBatch {
  final String id;
  final String productId;
  final int quantity;
  final String receivedDate;
  final String? expiryDate; 

  const InventoryBatch({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.receivedDate,
    this.expiryDate, 
  });
  Map<String, Object?> toJson() {
    return {
      InventoryBatchFields.id: id,
      InventoryBatchFields.productId: productId,
      InventoryBatchFields.quantity: quantity,
      InventoryBatchFields.receivedDate: receivedDate,
      InventoryBatchFields.expiryDate: expiryDate,
    };
  }

  static InventoryBatch fromJson(Map<String, Object?> json) {
    return InventoryBatch(
      id: json[InventoryBatchFields.id] as String,
      productId: json[InventoryBatchFields.productId] as String,
      quantity: json[InventoryBatchFields.quantity] as int,
      receivedDate: json[InventoryBatchFields.receivedDate] as String,
      expiryDate: json[InventoryBatchFields.expiryDate] as String?,
    );
  }
}






final String tableTransactions = 'transactions';

class TransactionFields {
  static final List<String> values = [
    id, cashierId, subtotal, taxAmount, discountAmount, grandTotal, paymentMethod, timestamp, syncStatus
  ];

  static const String id = 'transaction_id';
  static const String cashierId = 'cashier_id';
  static const String subtotal = 'subtotal';
  static const String taxAmount = 'tax_amount';
  static const String discountAmount = 'discount_amount';
  static const String grandTotal = 'grand_total';
  static const String paymentMethod = 'payment_method';
  static const String timestamp = 'timestamp';
  static const String syncStatus = 'sync_status';
}

class Transaction {
  final String id;
  final String cashierId;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double grandTotal;
  final String paymentMethod;
  final String timestamp;
  final int syncStatus; 

  const Transaction({
    required this.id,
    required this.cashierId,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.grandTotal,
    required this.paymentMethod,
    required this.timestamp,
    required this.syncStatus,
  });
  Map<String, Object?> toJson() {
    return {
      TransactionFields.id: id,
      TransactionFields.cashierId: cashierId,
      TransactionFields.subtotal: subtotal,
      TransactionFields.taxAmount: taxAmount,
      TransactionFields.discountAmount: discountAmount,
      TransactionFields.grandTotal: grandTotal,
      TransactionFields.paymentMethod: paymentMethod,
      TransactionFields.timestamp: timestamp,
      TransactionFields.syncStatus: syncStatus,
    };
  }

  static Transaction fromJson(Map<String, Object?> json) {
    return Transaction(
      id: json[TransactionFields.id] as String,
      cashierId: json[TransactionFields.cashierId] as String,
      subtotal: json[TransactionFields.subtotal] as double,
      taxAmount: json[TransactionFields.taxAmount] as double,
      discountAmount: json[TransactionFields.discountAmount] as double,
      grandTotal: json[TransactionFields.grandTotal] as double,
      paymentMethod: json[TransactionFields.paymentMethod] as String,
      timestamp: json[TransactionFields.timestamp] as String,
      syncStatus: json[TransactionFields.syncStatus] as int,
    );
  }
}


final String tableTransactionItems = 'transaction_items';

class TransactionItemFields {
  static final List<String> values = [
    id, transactionId, productId, quantity, unitPriceAtSale, lineTotal
  ];

  static const String id = 'items_id';
  static const String transactionId = 'transaction_id';
  static const String productId = 'product_id';
  static const String quantity = 'quantity';
  static const String unitPriceAtSale = 'unit_price_at_sale';
  static const String lineTotal = 'line_total';
}

class TransactionItem {
  final String id;
  final String transactionId;
  final String productId;
  final int quantity;
  final double unitPriceAtSale;
  final double lineTotal;

  const TransactionItem({
    required this.id,
    required this.transactionId,
    required this.productId,
    required this.quantity,
    required this.unitPriceAtSale,
    required this.lineTotal,
  });
  Map<String, Object?> toJson() {
    return {
      TransactionItemFields.id: id,
      TransactionItemFields.transactionId: transactionId,
      TransactionItemFields.productId: productId,
      TransactionItemFields.quantity: quantity,
      TransactionItemFields.unitPriceAtSale: unitPriceAtSale,
      TransactionItemFields.lineTotal: lineTotal,
    };
  }

  static TransactionItem fromJson(Map<String, Object?> json) {
    return TransactionItem(
      id: json[TransactionItemFields.id] as String,
      transactionId: json[TransactionItemFields.transactionId] as String,
      productId: json[TransactionItemFields.productId] as String,
      quantity: json[TransactionItemFields.quantity] as int,
      unitPriceAtSale: json[TransactionItemFields.unitPriceAtSale] as double,
      lineTotal: json[TransactionItemFields.lineTotal] as double,
    );
  }
}

