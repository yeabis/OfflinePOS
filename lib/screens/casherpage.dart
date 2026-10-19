import 'package:flutter/material.dart';
import '../widgets/camera_scanner.dart';
import 'package:flutter/services.dart';

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

  @override
  void dispose() {
  _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _handleScan(String barcode) async {
    if (barcode.isEmpty) return;
    Map<String, dynamic>? product;
    if (barcode == "123456789") {
      product = {'id': 'prod_1', 'name': 'Bottled Water', 'price': 15.0};
    } else {
      product = {'id': 'prod_2', 'name': 'Unknown Scanned Item', 'price': 99.0};
    }

    if (product != null) {
      HapticFeedback.lightImpact();
      setState(() {
        int existingIndex = _cart.indexWhere((item) => item['id'] == product!['id']);
        if (existingIndex >= 0) {
          _cart[existingIndex]['qty'] += 1; 
        } else {
          _cart.add({
            'id': product!['id'],
            'name': product!['name'],
            'price': product!['price'],
            'qty': 1,
          });
        }
      });
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
              padding: const EdgeInsets.all(2.0),
              child: Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 150,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
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
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CameraScanner(
                          onBarcodeScanned: (scannedCode) {
                            setState(() {
                              _barcodeController.text = scannedCode;
                            });
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
                Text("Cart Items: ${_cart.length}", style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold,)),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 150),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
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
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF102E4A),
                              child: Text("${item['qty']}", style: const TextStyle(color: Colors.white)),
                            ),
                            title: Text(item['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            trailing: Text("\$${(item['price'] * item['qty']).toStringAsFixed(2)}", style: const TextStyle(color: Color(0xFF00EAEA), fontSize: 18)),
                          );
                        },
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