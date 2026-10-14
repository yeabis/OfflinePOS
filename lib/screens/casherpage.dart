import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/camera_scanner.dart';

class CasherPage extends StatelessWidget {
  const CasherPage({super.key});

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
              padding: EdgeInsets.only( 30.0),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.all(1.0)),
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
                  const Positioned.fill(
                    child: CameraScanner(),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(
                                  side: BorderSide(color: Colors.white54, width: 1.2),
                                ),
                                backgroundColor: Colors.white.withValues(alpha: 0.15),
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 50),
                              ),
                              onPressed: () {},
                              child: Icon(
                                Icons.flash_on,
                                size: 30,
                                color: Colors.cyanAccent.shade400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(
                                  side: BorderSide(color: Colors.white54, width: 1.2),
                                ),
                                backgroundColor: Colors.white.withValues(alpha: 0.15),
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 50),
                              ),
                              onPressed: () {},
                              child: Icon(
                                Icons.vibration,
                                size: 30,
                                color: Colors.cyanAccent.shade400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}