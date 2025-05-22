import 'package:flutter/material.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class UnityLauncherPage extends StatelessWidget {
  const UnityLauncherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Launch Unity App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Replace with your Unity app's package name
            const packageName ='com.HAM.HoloHola';
            try {
              await LaunchApp.openApp(
                androidPackageName: packageName,
                openStore: false,
              );
            } catch (e) {
              print('Error opening app: $e');
            }
          },
          child: const Text('Open Unity App'),
        ),
      ),
    );
  }
}
