import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Receipt & Print",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F2), 
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E2738),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "suk",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "SUK STORES RETAIL",
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "4 Kilo, Addis Ababa, Ethiopia",
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  const Text(
                    "Tel: +251 91 111 1111",
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.black26, thickness: 1),
                  const SizedBox(height: 8),
                  _buildMetaRow("BILL NO:", "#SK-2026-001"),
                  const SizedBox(height: 6),
                  _buildMetaRow("DATE / TIME:", "21 OCT 2026 • 20:59"),
                  const SizedBox(height: 6),
                  _buildMetaRow("CASHIER:", "Almaz (ID: #402)"),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.black26, thickness: 1),
                  const SizedBox(height: 8),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("DESCRIPTION", style: TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.bold)),
                      Text("TOTAL", style: TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  _buildReceiptItem("Small Notebook", 2, 15.0),
                  _buildReceiptItem("Nescafe 3-in-1", 3, 5.0),
                  _buildReceiptItem("Big Notebook", 1, 25.0),

                  const SizedBox(height: 12),
                  const Divider(color: Colors.black26, thickness: 1),
                  const SizedBox(height: 8),

                  _buildSummaryRow("SUBTOTAL:", "\$70.00"),
                  const SizedBox(height: 6),
                  _buildSummaryRow("TAX (15% VAT):", "\$10.50"),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "GRAND TOTAL:",
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        "\$80.50",
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Icon(Icons.qr_code_2, size: 70, color: Colors.black87),
                  const SizedBox(height: 6),
                  const Text(
                    "Thank you for shopping with Suk Stores!",
                    style: TextStyle(color: Colors.black54, fontSize: 12, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: 'assets/icons/thermal_printer.svg',
                    label: "Print Receipt",
                    sublabel: "By Thermal",
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildActionButton(
                    icon: null,
                    fallbackIcon: Icons.mail_outline,
                    label: "Send Receipt",
                    sublabel: "By Email or SMS",
                    onTap: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C7E5),
                foregroundColor: const Color(0xFF0B1326),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.refresh, size: 24),
              label: const Text(
                "New Sale (Reset Scanner)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildReceiptItem(String title, int qty, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text("$qty × \$${price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.black45, fontSize: 12)),
            ],
          ),
          Text(
            "\$${(qty * price).toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActionButton({
    String? icon,
    IconData? fallbackIcon,
    required String label,
    required String sublabel,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2738),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            if (icon != null)
              SvgPicture.asset(
                icon,
                width: 26,
                height: 26,
                colorFilter: const ColorFilter.mode(Color(0xFF00EAEA), BlendMode.srcIn),
              )
            else if (fallbackIcon != null)
              Icon(fallbackIcon, size: 26, color: const Color(0xFF00EAEA)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 2),
            Text(sublabel, style: const TextStyle(color: Color(0xFF00EAEA), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
