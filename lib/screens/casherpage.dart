import 'package:flutter/material.dart';

class CasherPage extends StatefulWidget {
  const CasherPage({Key? key}) : super(key: key);

  @override
  _CasherPageState createState() => _CasherPageState();
}

class _CasherPageState extends State<CasherPage> {
  int totalItems = 4;
  double subtotal = 200.00;
  double tax = 30.00;
  double grandTotal = 230.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    color: Colors.grey.shade300,
                    child: const Text('logo', style: TextStyle(fontSize: 24)),
                  ),
                  const Text('cashier:user_name'),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.black),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text('offline'),
            ),

            Container(
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.grey.shade300,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 250,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade600, width: 2),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade400,
                          child: const Icon(Icons.flashlight_on, color: Colors.black),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade400,
                          child: const Icon(Icons.cameraswitch, color: Colors.black),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

           
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(25)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: const Text('Enter the product name or sku', style: TextStyle(color: Colors.black54)),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 80,
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(25)),
                    ),
                    alignment: Alignment.center,
                    child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

           
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Cart(item $totalItems)', style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 8),
            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _buildCartItem();
                },
              ),
            ),

           
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('subtotal(items $totalItems)'),
                      Text(subtotal.toStringAsFixed(2)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('tax(15%)'),
                      Text(tax.toStringAsFixed(2)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: Colors.black54, thickness: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('grand total'),
                      Text(grandTotal.toStringAsFixed(2)),
                    ],
                  ),
                ],
              ),
            ),

            
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey.shade300, Colors.grey.shade100],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: const Text('check out', style: TextStyle(fontSize: 24)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('item 1', style: TextStyle(fontSize: 18)),
              Text('price', style: TextStyle(fontSize: 14)),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  onPressed: () {},
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
                const Text('3'),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  onPressed: () {},
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.delete),
        ],
      ),
    );
  }
}