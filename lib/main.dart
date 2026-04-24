import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'payment_screen.dart'; // Ensure this matches your file name
import 'api/api_service.dart';

void main() => runApp(const MaterialApp(home: HomeScreen()));

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  String _statusText = "Scan or Upload a QR";
  bool _isLoading = false;

  // Function to navigate to payment screen
  void _navigateToPayment(Map<String, dynamic> parsedData) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentScreen(data: parsedData)),
    );
  }

  // Handle Gallery Upload
  Future<void> _handleUpload() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
        _statusText = "Processing image...";
      });

      // API returns: {'raw': '...', 'parsed': { '59': 'Merchant', ... }}
      final result = await _apiService.parseImage(File(pickedFile.path));

      setState(() {
        _isLoading = false;
        if (result != null && result['parsed'] != null) {
          _statusText = "Parsed Successfully";
          _navigateToPayment(result['parsed']);
        } else {
          _statusText = "Upload failed. Check console/network.";
        }
      });
    }
  }

  // Handle Live Camera Scan
  // Note: Live scan results usually need to be sent to your API to be parsed
  // because the phone doesn't know how to split TLV tags yet.
  Future<void> _handleLiveScan(String rawQrData) async {
    setState(() {
      _isLoading = true;
    });

    // We send the raw string from the camera to your API to get the same 'parsed' Map
    // Create a new method in ApiService called 'parseRawString'
    final result = await _apiService.parseRawString(rawQrData);

    setState(() {
      _isLoading = false;
      if (result != null && result['parsed'] != null) {
        _navigateToPayment(result['parsed']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Scanner")),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: MobileScanner(
                  // onDetect: (capture) {
                  //   final barcode = capture.barcodes.first;
                  //   if (barcode.rawValue != null && !_isLoading) {
                  //     _handleLiveScan(barcode.rawValue!);
                  //   }
                  // },
                  // Inside your MobileScanner widget in main.dart:
                  onDetect: (capture) async {
                    final barcode = capture.barcodes.first;
                    if (barcode.rawValue != null && !_isLoading) {
                      setState(() => _isLoading = true);

                      // Call the new parse method
                      final result = await _apiService.parseRawString(
                        barcode.rawValue!,
                      );

                      setState(() => _isLoading = false);

                      if (result != null) {
                        // Navigate to PaymentScreen with the parsed tags
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(data: result),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to parse QR code"),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_statusText),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _handleUpload,
                        icon: const Icon(Icons.cloud_upload),
                        label: const Text("Upload from Gallery"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
