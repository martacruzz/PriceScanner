import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'dart:io';
import '../widgets/camera_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? _capturedImage;

  // TODO: We'll add state variables for the image, prices, and total later.
  // For now, we'll use placeholder data.
  List<Map<String, dynamic>> _extractedPrices = [
    {'value': 2.99, 'quantity': 1},
    {'value': 1.50, 'quantity': 1},
    {'value': 3.20, 'quantity': 1},
  ];

  double get _total => _extractedPrices.fold(
      0.0, (sum, item) => sum + (item['value'] * item['quantity']));

  // TODO: We'll implement the camera functionality here.
  void _takePricePhoto() async {
    final XFile? image = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CameraWidget()),
    );

    if (image != null) {
      print("Image captured: ${image.path}");

      setState(() {
        _capturedImage = image;
      });
    } else {
      print("No image captured or capture cancelled.");
    }
  }

  void _resetTotal() {
    setState(() {
      _extractedPrices.clear();
      _capturedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Scanner'),
        backgroundColor: Colors.lightBlue[50], // Soft light blue
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Large 'Take Price Photo' Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _takePricePhoto,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue, // Background color
                foregroundColor: Colors.white, // Text color
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                elevation: 4, // Add some shadow
                minimumSize: const Size(double.infinity, 50), // Full width
              ),
              child: const Text('Take Price Photo'),
            ),
          ),

          // 2. Central Image Area - Updated to show captured image
          Expanded(
            flex: 2, // Takes 2 parts of the available space
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade50, // Light background
              ),
              child: Center(
                // Display the captured image or the placeholder icon
                child: _capturedImage != null
                    ? Image.file(File(_capturedImage!.path),
                        fit: BoxFit.contain)
                    : const Icon(
                        Icons.image, // Placeholder icon
                        size: 80,
                        color: Colors.grey,
                      ),
              ),
            ),
          ),

          const SizedBox(height: 16), // Spacing

          // 3. & 4. List of Extracted Prices and Total
          Expanded(
            flex: 3, // Takes 3 parts of the available space
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Extracted Prices',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          _extractedPrices.length + 1, // +1 for the total line
                      itemBuilder: (context, index) {
                        if (index == _extractedPrices.length) {
                          // This is the last item - the Total
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1.5,
                            ),
                          );
                        }
                        // Regular price items
                        final priceItem = _extractedPrices[index];
                        return ListTile(
                          title: Text(
                            '€${priceItem['value'].toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: Text(
                            'x${priceItem['quantity']}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        );
                      },
                    ),
                  ),
                  // Total Display (outside the ListView for simplicity)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '€${_total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16), // Spacing

          // 5. 'Reset Total' Button
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
            child: OutlinedButton(
              onPressed: _resetTotal,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.grey), // Border color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
              ),
              child: const Text(
                'Reset Total',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey, // Text color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
