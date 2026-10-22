import 'package:flutter/material.dart';
import '../core/database/pos_database.dart';
import 'Receipt.dart'; 

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Map<String, dynamic>>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _refreshHistory();
  }

  void _refreshHistory() {
    setState(() {
      _transactionsFuture = PosDatabase.instance.getAllTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2738),
        title: const Text("Transaction History", style: TextStyle(color: Colors.white, fontSize: 18)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.cyanAccent),
            onPressed: _refreshHistory, 
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
        
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
          } 
          
          else if (snapshot.hasError) {
            return Center(child: Text("Database Error: ${snapshot.error}", style: const TextStyle(color: Colors.redAccent)));
          } 
         
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No past transactions found.",
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            );
          }

         
          final transactions = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final cartList = List<Map<String, dynamic>>.from(transaction['cart'] ?? []);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceiptPage(
                          cart: cartList,
                          subtotal: transaction['subtotal'],
                          tax: transaction['tax'],
                          grandTotal: transaction['grandTotal'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2738),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction['billNo'].toString(),
                              style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transaction['date'].toString(),
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${cartList.length} Items",
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "\$${(transaction['grandTotal'] as double).toStringAsFixed(2)}",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}