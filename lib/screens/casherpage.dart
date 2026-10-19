import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/camera_scanner.dart';
import 'package:flutter/services.dart';
import '../core/database/pos_database.dart';

class CasherPage extends StatefulWidget {
  const CasherPage({super.key});

  @override
  State<CasherPage> createState() => _CasherPageState();
}

class _CasherPageState extends State<CasherPage> {
  final TextEditingController _barcodeController = TextEditingController();

  final List<Map<String, dynamic>> _cart = [];

  double get _subtotal => _cart.fold(0.0, (sum, item) => sum + (item['price'] * item['qty']));
  double get _tax => _subtotal * 0.15;
  double get _grandTotal => _subtotal + _tax;
  int get _cartItems => _cart.fold(0, (sum, item) => sum + (item['qty'] as int));
  @override
  void dispose() {
  _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _handleScan(String barcode) async {
    if (barcode.isEmpty) return;

    final product = await PosDatabase.instance.getProductByBarcode(barcode);

  
    if (product != null) {
      HapticFeedback.lightImpact();
      
      setState(() {
        int existingIndex = _cart.indexWhere((item) => item['id'] == product.id);
        
        if (existingIndex >= 0) {
          _cart[existingIndex]['qty'] += 1; 
        } else {
          _cart.add({
            'id': product.id,
            'name': product.name,
            'price': product.defaultPrice, 
            'qty': 1,
          });
        }
      });
      _barcodeController.clear(); 
      
    } else {
      if (mounted) {
        HapticFeedback.vibrate(); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Item not found in database"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ),
        );
      }
      _barcodeController.clear();
    }
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 150,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 1.0),
              child: Text(
                "Cashier : Almaz",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "offline",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CameraScanner(
                          onBarcodeScanned: (scannedCode) {
                            _barcodeController.text = scannedCode;
                            _handleScan(scannedCode);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _barcodeController, 
                  style: const TextStyle(color: Colors.white), 
                  onFieldSubmitted: (value) {
                    _handleScan(value.trim());
                  },
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(4.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(60, 60),
                            backgroundColor: const Color(0xFF102E4A),
                            foregroundColor: const Color(0xFF121617),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            _handleScan(_barcodeController.text.trim());
                          },
                          child: const Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Item name...',
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  
                ),
                SizedBox(height: 20,),
                Text("Cart Items: $_cartItems", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 150),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05), 
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _cart.isEmpty 
                        ? const Center(
                            child: Text("Cart is empty", style: TextStyle(color: Colors.white54)),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(), 
                            itemCount: _cart.length,
                            itemBuilder: (context, index) {
                              final item = _cart[index];
                              
                              return Dismissible(
                                key: Key(item['id']),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.redAccent,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(Icons.delete, color: Colors.white),
                                ),
                                onDismissed: (direction) {
                                  setState(() {
                                    _cart.removeAt(index);
                                  });
                                  HapticFeedback.mediumImpact();
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFF102E4A),
                                    child: Text("${item['qty']}", style: const TextStyle(color: Colors.white)),
                                  ),
                                  title: Text(item['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                                        onPressed: () {
                                          setState(() {
                                            if (_cart[index]['qty'] > 1) {
                                              _cart[index]['qty'] -= 1; 
                                            } else {
                                              _cart.removeAt(index); 
                                            }
                                          });
                                          HapticFeedback.lightImpact();
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "\$${(item['price'] * item['qty']).toStringAsFixed(2)}", 
                                        style: const TextStyle(color: Color(0xFF00EAEA), fontSize: 18)
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF102E4A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Subtotal: \$${_subtotal.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Tax (15%): \$${_tax.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(color: Colors.white54, height: 24),
                      Text("Grand Total: \$${_grandTotal.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CD7F6), 
                    foregroundColor: const Color(0xFF121617), 
                    minimumSize: const Size(double.infinity, 55), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    if (_cart.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Cart is empty!")),
                      );
                      return;
                    }

                    
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF00EAEA))),
                    );

                
                    await Future.delayed(const Duration(seconds: 1));

                  
                    if (context.mounted) Navigator.pop(context);
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF102E4A),
                          title: const Icon(Icons.check_circle, color: Colors.greenAccent, size: 50),
                          content: Text(
                            "Payment Successful!\n\nTotal Paid: \$${_grandTotal.toStringAsFixed(2)}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); 
                                setState(() {
                                  _cart.clear();
                                });
                              },
                              child: const Text("Next Customer", style: TextStyle(color: Color(0xFF00EAEA), fontSize: 16)),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  child: Center(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Checkout",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),

                      Icon(Icons.arrow_forward),
                    ],),
                  ),
                ),),
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}