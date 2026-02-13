import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/animated_button.dart';
import 'verification_screen.dart';

final List<Map<String, String>> _taxiStands = [
  {'id': 'diyanet_egitim', 'name': 'Diyanet Eğitim Taksi'},
  {'id': 'aziziye', 'name': 'Aziziye Taksi'},
  {'id': 'yakutiye', 'name': 'Yakutiye Taksi'},
  {'id': 'palandoken', 'name': 'Palandöken Taksi'},
  {'id': 'dadaskent', 'name': 'Dadaşkent Taksi'},
];

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _driverNameController = TextEditingController();
  final _plateController = TextEditingController();

  String? _selectedStandId;
  String? _selectedStandName;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _authService = AuthService();

  Future<void> _signup() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      _showError('Lütfen tüm alanları doğru doldurun');
      return;
    }
    if (_selectedStandId == null) {
      _showError('Lütfen bir taksi durağı seçin');
      return;
    }

    setState(() => _isLoading = true);
    final result = await _authService.signup(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      taxiStandId: _selectedStandId!,
      taxiStandName: _selectedStandName!,
      driverName: _driverNameController.text.trim(),
      vehiclePlate: _plateController.text.trim().toUpperCase(),
    );
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VerificationScreen(
            driverId: result['driverId'],
            email: _emailController.text.trim(),
          ),
        ),
      );
    } else {
      _showError(result['error']);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFA726), Color(0xFFFF6F00), Color(0xFFE65100)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Sürücü Kaydı',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildCard(
                  title: 'Kişisel Bilgiler',
                  children: [
                    _buildField(
                      controller: _driverNameController,
                      hint: 'Ad Soyad',
                      icon: Icons.person_outline,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Bu alan zorunlu' : null,
                    ),
                    _buildField(
                      controller: _emailController,
                      hint: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Bu alan zorunlu';
                        if (!v.contains('@')) return 'Geçerli bir email girin';
                        return null;
                      },
                    ),
                    _buildField(
                      controller: _passwordController,
                      hint: 'Şifre',
                      icon: Icons.lock_outline,
                      obscure: _obscurePassword,
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Bu alan zorunlu';
                        if (v.length < 6) return 'En az 6 karakter olmalı';
                        return null;
                      },
                    ),
                    _buildField(
                      controller: _confirmPasswordController,
                      hint: 'Şifre Tekrar',
                      icon: Icons.lock_outline,
                      obscure: _obscureConfirmPassword,
                      suffix: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () => setState(
                            () => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Bu alan zorunlu';
                        if (v != _passwordController.text)
                          return 'Şifreler eşleşmiyor';
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildCard(
                  title: 'Araç Bilgileri',
                  children: [
                    _buildField(
                      controller: _plateController,
                      hint: 'Plaka (örn: 25 ABC 123)',
                      icon: Icons.directions_car_outlined,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Bu alan zorunlu' : null,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedStandId,
                              hint: Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      color: Colors.white70),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Taksi Durağı Seçin',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.6)),
                                  ),
                                ],
                              ),
                              isExpanded: true,
                              dropdownColor: const Color(0xFFFF6F00),
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.white),
                              style: const TextStyle(color: Colors.white),
                              items: _taxiStands
                                  .map((s) => DropdownMenuItem(
                                        value: s['id'],
                                        child: Text(s['name']!),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() {
                                _selectedStandId = v;
                                _selectedStandName = _taxiStands
                                    .firstWhere((s) => s['id'] == v)['name'];
                              }),
                            ),
                          ),
                        ),
                        if (_isLoading == false && _selectedStandId == null)
                          const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : AnimatedButton(
                        text: 'Kayıt Ol',
                        onPressed: _signup,
                        icon: Icons.person_add,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, 
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children
              .expand((w) => [w, const SizedBox(height: 12)])
              .toList()
            ..removeLast(), 
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Colors.white70, fontSize: 12),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _driverNameController.dispose();
    _plateController.dispose();
    super.dispose();
  }
}