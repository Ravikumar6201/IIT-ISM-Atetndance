import 'package:flutter/material.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';

class SimNumberScreen extends StatefulWidget {
  const SimNumberScreen({super.key});

  @override
  _SimNumberScreenState createState() => _SimNumberScreenState();
}

class _SimNumberScreenState extends State<SimNumberScreen> {
  String? mobileNumber;
  List<SimCard> simCards = [];

  @override
  void initState() {
    super.initState();
    _initMobileNumber();
  }

  // Request permissions and get mobile number
  Future<void> _initMobileNumber() async {
    try {
      // Request permission for reading phone state
      if (await Permission.phone.request().isGranted) {
        // Get mobile number and SIM info
        mobileNumber = await MobileNumber.mobileNumber;
        simCards = (await MobileNumber.getSimCards)!;

        setState(() {});
      } else {
        // Handle if permission is denied
        print("Permission not granted");
      }
    } catch (e) {
      print("Failed to get mobile number: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIM Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mobileNumber != null) Text("Mobile Number: $mobileNumber"),
            const SizedBox(height: 10),
            if (simCards.isNotEmpty)
              ...simCards.map((SimCard sim) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("SIM Number: ${sim.number ?? "Unknown"}"),
                      Text("Carrier Name: ${sim.carrierName ?? "Unknown"}"),
                      // Text("Country Code: ${sim.countryCode ?? "Unknown"}"),
                      const SizedBox(height: 20),
                    ],
                  )),
            if (simCards.isEmpty)
              const Text(
                  "No SIM card information found or permission not granted."),
          ],
        ),
      ),
    );
  }
}
