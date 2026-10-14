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
      child: const Center(
        child: Text(
          'Point camera at barcode or item',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
