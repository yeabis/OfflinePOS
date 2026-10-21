import 'package:flutter/material.dart';
import '../screens/casherpage.dart';



class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1326),
        
        
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(), 
          children: [
            CasherPage(), 
            Center(child: Text("History Screen", style: TextStyle(color: Colors.white))),
            Center(child: Text("Inventory Screen", style: TextStyle(color: Colors.white))),
          ],
        ),

       
        bottomNavigationBar: Container(
          color: const Color(0xFF1E2738),
          child: const SafeArea(
            child: TabBar(
              indicatorColor: Colors.cyanAccent,
              labelColor: Colors.cyanAccent,
              unselectedLabelColor: Colors.white54,
              indicatorWeight: 3,
              tabs: [
                Tab(icon: Icon(Icons.point_of_sale), text: "Checkout"),
                Tab(icon: Icon(Icons.receipt_long), text: "History"),
                Tab(icon: Icon(Icons.inventory_2), text: "Inventory"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}