import 'package:flutter/material.dart';

class CameraScanner extends StatelessWidget {
  const CameraScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flash_on,
              size: 64,
              color: Colors.cyanAccent.shade400,
            ),
            const SizedBox(height: 16),
            Icon(
              Icons.vibration,
              size: 64,
              color: Colors.cyanAccent.shade400,
            ),
            
            const Text(
              'Point camera at barcode or item',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
