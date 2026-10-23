import 'package:flutter/material.dart';
import 'Receipt.dart'; 

class PaymentTenderPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final double subtotal;
  final double tax;
  final double grandTotal;

  const PaymentTenderPage({
    super.key,
    required this.cart,
    required this.subtotal,
    required this.tax,
    required this.grandTotal,
  });

  @override
  State<PaymentTenderPage> createState() => _PaymentTenderPageState();
}

class _PaymentTenderPageState extends State<PaymentTenderPage> {
  String _selectedPaymentMethod = 'Cash';
  String _amountTenderedStr = '';
  
  double get _amountTendered => double.tryParse(_amountTenderedStr) ?? 0.0;
  double get _changeDue => (_amountTendered - widget.grandTotal) > 0 ? (_amountTendered - widget.grandTotal) : 0.0;

  @override
  void initState() {
    super.initState();
    _amountTenderedStr = widget.grandTotal.toStringAsFixed(2);
  }

  void _onKeypadPress(String value) {
    setState(() {
      if (_amountTenderedStr == widget.grandTotal.toStringAsFixed(2) || _amountTenderedStr == '0') {
        _amountTenderedStr = ''; 
      }
      if (value == '.') {
        if (!_amountTenderedStr.contains('.')) {
          _amountTenderedStr = _amountTenderedStr.isEmpty ? '0.' : _amountTenderedStr + value;
        }
      } else {
        if (_amountTenderedStr.contains('.')) {
          final parts = _amountTenderedStr.split('.');
          if (parts.length > 1 && parts[1].length >= 2) return;
        }
        _amountTenderedStr += value;
      }
    });
  }

  void _clearTendered() {
    setState(() {
      _amountTenderedStr = '';
    });
  }

  void _applyQuickCash(double extra) {
    setState(() {
      _amountTenderedStr = (widget.grandTotal + extra).toStringAsFixed(2);
      _selectedPaymentMethod = 'Cash';
    });
  }

  @override
  Widget build(BuildContext context) {
    final int itemsCount = widget.cart.fold(0, (sum, item) => sum + (item['qty'] as int));

    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF1E2738), borderRadius: BorderRadius.circular(6)),
              child: const Text("suk", style: TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Active Tender", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                Text("Checkout", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.purple.shade200,
              radius: 16,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTerminalInfo(),
            const SizedBox(height: 16),
            _buildGrandTotalCard(itemsCount),
            const SizedBox(height: 20),
            
            const Text("SELECT PAYMENT METHOD", style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildPaymentMethods(),
            const SizedBox(height: 20),

            const Text("QUICK CASH DENOMINATIONS", style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildQuickDenominations(),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("AMOUNT TENDERED", style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: _clearTendered,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.cancel, color: Colors.redAccent, size: 14),
                        const SizedBox(width: 4),
                        Text("Clear", style: TextStyle(color: Colors.redAccent.shade100, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            _buildAmountTenderedField(),
            const SizedBox(height: 16),

            _buildChangeDueCard(),
            const SizedBox(height: 16),

            _buildKeypad(),
            const SizedBox(height: 24),


            Row(
              children: [
                const Icon(Icons.save_alt, color: Colors.cyanAccent, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "paymentMethod: ${_selectedPaymentMethod.toUpperCase()} -> Commit to local Transactions table ",
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

          
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CD7F6),
                foregroundColor: const Color(0xFF0B1326),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (_amountTendered >= widget.grandTotal) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReceiptPage(
                        cart: widget.cart,
                        subtotal: widget.subtotal,
                        tax: widget.tax,
                        grandTotal: widget.grandTotal,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Amount tendered is less than total due.")),
                  );
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Complete & Print Receipt", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTerminalInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1E2738), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: Colors.cyanAccent, radius: 18, child: Icon(Icons.point_of_sale, color: Color(0xFF0B1326), size: 20)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("TERMINAL ID: #TK-04", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                Text("Cashier: Almaz", style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.cyanAccent, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                const Text("online", style: TextStyle(color: Colors.cyanAccent, fontSize: 10)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGrandTotalCard(int itemsCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1E2738), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("GRAND TOTAL DUE", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: Text("$itemsCount ITEMS", style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("\$ ", style: TextStyle(color: Colors.cyanAccent, fontSize: 20, fontWeight: FontWeight.bold)),
              Text(widget.grandTotal.toStringAsFixed(2), style: const TextStyle(color: Colors.cyanAccent, fontSize: 36, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.receipt, color: Colors.white54, size: 14),
                  SizedBox(width: 4),
                  Text("Invoice #29841", style: TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
              Text("VAT Inc. (15%)", style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Row(
      children: [
        Expanded(child: _paymentMethodCard('Cash', Icons.money, 'Instant')),
        const SizedBox(width: 10),
        Expanded(child: _paymentMethodCard('Card', Icons.contactless, 'NFC / Chip')),
        const SizedBox(width: 10),
        Expanded(child: _paymentMethodCard('Telebirr', Icons.qr_code_scanner, 'Mobile-QR')),
      ],
    );
  }

  Widget _paymentMethodCard(String title, IconData icon, String subtitle) {
    bool isSelected = _selectedPaymentMethod == title;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00EAEA) : const Color(0xFF1E2738),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF0B1326) : Colors.white70, size: 24),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: isSelected ? const Color(0xFF0B1326) : Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            Text(subtitle, style: TextStyle(color: isSelected ? const Color(0xFF0B1326).withOpacity(0.7) : Colors.white54, fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickDenominations() {
    return Row(
      children: [
        Expanded(child: _quickCashBtn("EXACT", widget.grandTotal)),
        const SizedBox(width: 8),
        Expanded(child: _quickCashBtn("+\$10", widget.grandTotal + 10)),
        const SizedBox(width: 8),
        Expanded(child: _quickCashBtn("+\$20", widget.grandTotal + 20)),
        const SizedBox(width: 8),
        Expanded(child: _quickCashBtn("+\$70", widget.grandTotal + 70)),
      ],
    );
  }

  Widget _quickCashBtn(String label, double amount) {
    bool isSelected = _amountTenderedStr == amount.toStringAsFixed(2);
    return InkWell(
      onTap: () => _applyQuickCash(amount - widget.grandTotal),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CD7F6) : const Color(0xFF1E2738),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: isSelected ? const Color(0xFF0B1326) : Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 11)),
            Text("\$${amount.toStringAsFixed(0)}", style: TextStyle(color: isSelected ? const Color(0xFF0B1326) : Colors.white, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountTenderedField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF121617),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E2738), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("\$", style: TextStyle(color: Colors.white54, fontSize: 24, fontWeight: FontWeight.w500)),
          Text(
            _amountTenderedStr.isEmpty ? "0.00" : _amountTenderedStr,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeDueCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E2738), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.sync, color: Colors.white70, size: 16),
                  SizedBox(width: 6),
                  Text("CHANGE DUE", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.teal.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: const Text("READY", style: TextStyle(color: Colors.tealAccent, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("\$ ", style: TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(_changeDue.toStringAsFixed(2), style: const TextStyle(color: Colors.cyanAccent, fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFF0B1326), borderRadius: BorderRadius.circular(6)),
            child: Row(
              children: [
                const Icon(Icons.money, color: Colors.cyanAccent, size: 14),
                const SizedBox(width: 8),
                Text(
                  _changeDue > 0 ? "Return exact change to customer" : "No change required",
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '00'];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1E2738), borderRadius: BorderRadius.circular(16)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => _onKeypadPress(keys[index]),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: const Color(0xFF0B1326), borderRadius: BorderRadius.circular(8)),
              child: Text(
                keys[index],
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}