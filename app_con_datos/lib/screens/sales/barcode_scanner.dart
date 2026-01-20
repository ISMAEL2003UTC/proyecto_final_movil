import 'package:flutter/material.dart';

class BarcodeScanner extends StatelessWidget {
  final Widget scannerWidget;
  final Function() onFlashToggle;
  final bool isFlashOn;

  const BarcodeScanner({
    Key? key,
    required this.scannerWidget,
    required this.onFlashToggle,
    required this.isFlashOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const topRadius = BorderRadius.vertical(top: Radius.circular(12));

    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: topRadius,
      ),
      child: ClipRRect(
        borderRadius: topRadius,
        child: Stack(
          children: [
            _buildScannerView(),
            _buildFlashToggleButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerView() {
    const scannerSize = Size(280, 160);
    final scannerBorderRadius = BorderRadius.circular(8);

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Center(
        child: SizedBox.fromSize(
          size: scannerSize,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: scannerBorderRadius,
                child: scannerWidget,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: scannerBorderRadius,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlashToggleButton() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: onFlashToggle,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isFlashOn ? Colors.amber : Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: isFlashOn ? Colors.black : Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}