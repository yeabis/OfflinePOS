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

       
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 32, right: 32, bottom: 24),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E2738),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3), 
                  blurRadius: 10, 
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: TabBar(
                  dividerColor: Colors.transparent, 
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Color(0xFF0B1326), 
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  labelColor: Colors.cyanAccent,
                  unselectedLabelColor: Colors.white54,
                  tabs: [
                    Tab(icon: Icon(Icons.point_of_sale)),
                    Tab(icon: Icon(Icons.receipt_long)),
                    Tab(icon: Icon(Icons.inventory_2)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}