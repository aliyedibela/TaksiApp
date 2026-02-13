import 'package:flutter/material.dart';
import '../services/auth_service.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuickTestSignupScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuickTestSignupScreen extends StatefulWidget {
  const QuickTestSignupScreen({super.key});

  @override
  State<QuickTestSignupScreen> createState() => _QuickTestSignupScreenState();
}

class _QuickTestSignupScreenState extends State<QuickTestSignupScreen> {
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _testSignup() async {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🧪 TEST BUTONU BASILDI!');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    setState(() => _isLoading = true);

    final result = await _authService.signup(
      email: 'flutter-test@example.com',
      password: 'Test123456',
      taxiStandId: 'diyanet_egitim',
      taxiStandName: 'Diyanet Eğitim Taksi',
      driverName: 'Flutter Test',
      vehiclePlate: '25 FLT 999',
    );

    setState(() => _isLoading = false);

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📨 SONUÇ:');
    print('Success: ${result['success']}');
    print('Message: ${result['message'] ?? result['error']}');
    if (result['driverId'] != null) {
      print('Driver ID: ${result['driverId']}');
    }
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(result['success'] ? '✅ Başarılı' : '❌ Hata'),
          content: Text(result['success'] 
              ? 'Driver ID: ${result['driverId']}\n\nConsole\'u kontrol et!'
              : 'Hata: ${result['error']}\n\nConsole\'u kontrol et!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Signup Test'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🧪 SIGNUP TEST',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _testSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'TEST SIGNUP',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Bu butona basınca:\n'
                '1. Console\'da logları gör\n'
                '2. API\'ye istek gider\n'
                '3. Sonuç dialog\'da gösterilir\n\n'
                'Console\'u mutlaka aç!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}