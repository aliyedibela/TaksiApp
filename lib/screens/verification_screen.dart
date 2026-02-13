import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../services/auth_service.dart';
import '../widgets/animated_button.dart';
import '../widgets/glass_container.dart';
import 'login_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String driverId;
  final String email;

  const VerificationScreen({
    super.key,
    required this.driverId,
    required this.email,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  final _codeController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _verify() async {
    if (_codeController.text.length != 6) {
      _showError('Lütfen 6 haneli kodu girin');
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.verify(
      widget.driverId,
      _codeController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      _showSuccess('Hesabınız doğrulandı! Giriş yapabilirsiniz.');
      
      await Future.delayed(const Duration(seconds: 2));
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } else {
      _showError(result['error']);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFFA726),
              const Color(0xFFFF6F00),
              const Color(0xFFE65100),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mark_email_unread_outlined,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Email Doğrulama',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    '${widget.email} adresine\ngönderilen 6 haneli kodu girin',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),

                  GlassContainer(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        PinCodeTextField(
                          appContext: context,
                          length: 6,
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.scale,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(12),
                            fieldHeight: 55,
                            fieldWidth: 45,
                            activeFillColor: Colors.white.withOpacity(0.2),
                            inactiveFillColor: Colors.white.withOpacity(0.1),
                            selectedFillColor: Colors.white.withOpacity(0.25),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white.withOpacity(0.3),
                            selectedColor: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          enableActiveFill: true,
                          onCompleted: (code) => _verify(),
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 24),
                        
                        _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : AnimatedButton(
                                text: 'Doğrula',
                                onPressed: _verify,
                                icon: Icons.verified_user,
                              ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () async {

                      _showSuccess('Yeni kod gönderildi!');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: const Text(
                        'Kodu Tekrar Gönder',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}