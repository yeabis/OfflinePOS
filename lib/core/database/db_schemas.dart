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
}