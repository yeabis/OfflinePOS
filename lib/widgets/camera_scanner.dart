import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; 

class CameraScanner extends StatefulWidget {
  final Function(String)? onBarcodeScanned;

  const CameraScanner({super.key, this.onBarcodeScanned});

  @override
  State<CameraScanner> createState() => _CameraScannerState();
}

class _CameraScannerState extends State<CameraScanner> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );

  String _lastScannedCode = '';

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect( 
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            
            MobileScanner(
              controller: _scannerController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final code = barcode.rawValue;
                  
                  if (code != null && code != _lastScannedCode) {
                    _lastScannedCode = code; 

                    HapticFeedback.heavyImpact();
                    
                    if (widget.onBarcodeScanned != null) {
                      widget.onBarcodeScanned!(code);
                    }

                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) setState(() => _lastScannedCode = '');
                    });
                  }
                }
              },
            ),

            const Center(
              child: Icon(Icons.fullscreen, color: Colors.white54, size: 150),
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
                      child: ValueListenableBuilder(
                        valueListenable: _scannerController,
                        builder: (context, state, child) {
                          final isOn = _scannerController.value.torchState == TorchState.on;
                          return IconButton(
                            style: IconButton.styleFrom(
                              shape: const CircleBorder(side: BorderSide(color: Colors.white54, width: 1.2)),
                              backgroundColor: Colors.white.withValues(alpha: 0.15),
                              padding: EdgeInsets.zero,
                              fixedSize: const Size(50, 50),
                            ),
                            onPressed: () => _scannerController.toggleTorch(),
                            icon: Icon(
                              isOn ? Icons.flash_on : Icons.flash_off,
                              size: 30,
                              color: isOn ? Colors.cyanAccent.shade400 : Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  
                  ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: IconButton(
                        style: IconButton.styleFrom(
                          shape: const CircleBorder(side: BorderSide(color: Colors.white54, width: 1.2)),
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                          padding: EdgeInsets.zero,
                          fixedSize: const Size(50, 50),
                        ),
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                        },
                        icon: Icon(Icons.vibration, size: 30, color: Colors.cyanAccent.shade400),
                      ),
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
