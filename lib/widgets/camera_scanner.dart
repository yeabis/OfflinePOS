import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class CameraScanner extends StatefulWidget {
  const CameraScanner({super.key});

  @override
  State<CameraScanner> createState() => _CameraScannerState();
}

class _CameraScannerState extends State<CameraScanner> {
  bool _isFlashlightOn = false;

  Future<void> _toggleFlashlight() async {
    try {
      final bool isTorchAvailable = await TorchLight.isTorchAvailable();

      if (isTorchAvailable) {
        if (_isFlashlightOn) {
          await TorchLight.disableTorch();
          setState(() => _isFlashlightOn = false);
        } else {
          await TorchLight.enableTorch();
          setState(() => _isFlashlightOn = true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No flashlight found on this device")),
          );
        }
      }
    } catch (e) {
      debugPrint("Flashlight error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          const Center(
            child: Text(
              'Point camera at barcode or item',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
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
                    child: IconButton(
                      style: IconButton.styleFrom(
                        shape: const CircleBorder(
                          side: BorderSide(color: Colors.white54, width: 1.2),
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        padding: EdgeInsets.zero,
                        fixedSize: const Size(50, 50),
                      ),
                      onPressed: _toggleFlashlight,
                      icon: Icon(
                        _isFlashlightOn ? Icons.flash_off : Icons.flash_on,
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
                    child: IconButton(
                      style: IconButton.styleFrom(
                        shape: const CircleBorder(
                          side: BorderSide(color: Colors.white54, width: 1.2),
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        padding: EdgeInsets.zero,
                        fixedSize: const Size(50, 50),
                      ),
                      onPressed: () {},
                      icon: Icon(
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
    );
  }
}
