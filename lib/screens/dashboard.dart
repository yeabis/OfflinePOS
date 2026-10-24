import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTerminalStatus(),
            const SizedBox(height: 16),
            _buildShiftalmazCard(),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true, 
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85, 
              children: [
                _buildGridCard(
                  icon: Icons.inventory_2_outlined,
                  title: "inventory",
                  subtitle: "1,420 skus mapped",
                  badgeText: "LIVE",
                  badgeColor: const Color(0xFF1E2738),
                  onTap: () {},
                ),
                _buildGridCard(
                  icon: Icons.payments_outlined,
                  title: "Revenue",
                  subtitle: "\$8,492 today",
                  titleSize: 22,
                  onTap: () {},
                ),
                _buildGridCard(
                  icon: Icons.warning_amber_rounded,
                  iconColor: Colors.redAccent,
                  title: "critical items",
                  subtitle: "low stock alert",
                  badgeText: "4 URGENT",
                  badgeColor: Colors.redAccent.withOpacity(0.2),
                  badgeTextColor: Colors.redAccent,
                  onTap: () {},
                ),
                _buildGridCard(
                  icon: Icons.hourglass_empty,
                  title: "Dead Stock",
                  subtitle: "18 idle lines",
                  badgeText: ">45 days",
                  badgeColor: const Color(0xFF1E2738),
                  onTap: () {},
                ),
                _buildGridCard(
                  icon: Icons.tune,
                  title: "Admin\nControls",
                  subtitle: "roles, rates, sync",
                  badgeText: "TIER 1",
                  badgeColor: Colors.blue.withOpacity(0.2),
                  badgeTextColor: Colors.lightBlueAccent,
                  onTap: () {},
                ),
                _buildGridCard(
                  icon: Icons.edit_note,
                  title: "manage items",
                  subtitle: "catalog & tags",
                  showDot: true,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            _buildAutoLedgerCard(),
            const SizedBox(height: 16),
            
            InkWell(
              onTap: () {
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C7E5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.qr_code_scanner, color: Color(0xFF0B1326), size: 32),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("go to sale (scanner)", style: TextStyle(color: Color(0xFF0B1326), fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("Ready", style: TextStyle(color: Color(0xFF0B1326), fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward, color: Color(0xFF0B1326)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40), 
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          const Text("suk", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFF1E2738), borderRadius: BorderRadius.circular(6)),
            child: const Text("POS", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
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
    );
  }

  Widget _buildTerminalStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFF1E2738), borderRadius: BorderRadius.circular(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.cyanAccent, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              const Text("terminal active • lane 01", style: TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFF2A364E), borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Icon(Icons.sync_problem, color: Colors.cyanAccent.shade100, size: 14),
                const SizedBox(width: 4),
                Text("15 PENDING SYNC", style: TextStyle(color: Colors.cyanAccent.shade100, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildShiftalmazCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E2738), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: Colors.cyanAccent),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("SHIFT almaz", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                Text("Peak Velocity (94.2%)", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text("+18.4% vs yday", style: TextStyle(color: Colors.cyanAccent.shade100, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildGridCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Color iconColor = Colors.cyanAccent,
    double titleSize = 18,
    String? badgeText,
    Color? badgeColor,
    Color? badgeTextColor,
    bool showDot = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2738),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFF0B1326), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(12)),
                    child: Text(badgeText, style: TextStyle(color: badgeTextColor ?? Colors.white70, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                if (showDot)
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.cyanAccent, shape: BoxShape.circle)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontSize: titleSize, fontWeight: FontWeight.bold, height: 1.2)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoLedgerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E2738), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.history, color: Colors.cyanAccent),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Auto-ledger synced", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                Text("Last ticket: #SK-8831\n(\$42.50)", style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            height: 30,
            child: CustomPaint(
              painter: _MiniGraphPainter(),
            ),
          )
        ],
      ),
    );
  }
}

class _MiniGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.75, 0, size.width, size.height * 0.2);

    canvas.drawPath(path, paint);
    
   
    Paint dotPaint = Paint()..color = Colors.cyanAccent;
    canvas.drawCircle(Offset(size.width, size.height * 0.2), 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}