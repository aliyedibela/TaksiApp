import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/animated_button.dart';
import 'verification_screen.dart';

final List<Map<String, String>> _taxiStands = [
  {
    'id': 'yildizkent_zirve_tokiler',
    'name': 'Yildizkent Zirve Tokiler Taksi Durağı',
    'lat': '39.868547',
    'lng': '41.248158',
    'phone': '+90 555 016 84 84',
    'address': 'Yildizkent Zirve Tokiler Taksi Durağı',
  },
  {
    'id': 'yildizkent_selimiye_taksi',
    'name': 'Yıldızkent Selimiye Taksi',
    'lat': '39.877818',
    'lng': '41.245135',
    'phone': '+90 535 296 08 97',
    'address': 'Hüseyin Avni Ulaş, Alparslan Türkeş Blv, 25070 Palandöken/Erzurum',
  },
  {
    'id': 'erzurum_merkez_nobetci_taksi',
    'name': 'Erzurum Merkez Nöbetçi Taksi ',
    'lat': '39.886708',
    'lng': '41.261948',
    'phone': '+90 552 643 25 25',
    'address': 'Yavuz Sultan Selim Bulvarı, Alvarlı Mehmet Efendi Cd., 25100 Palandöken/Erzurum',
  },
  {
    'id': 'yildizkent_polis_lojmanlari',
    'name': 'Yıldızkent Tokiler Ve Polis Lojmanları Taksi Savcı Deniz',
    'lat': '39.881345',
    'lng': '41.231538',
    'phone': '+90 442 342 32 32',
    'address': 'Hüseyin Avni Ulaş Mahallesi Çat Yolu, 112 ACİL KARŞISI Üzeri, 25000 Palandöken/Erzurum',
  },
  {
    'id': 'yildizkent_huzur',
    'name': 'Yildizkent Huzur Taksi',
    'lat': '39.873277',
    'lng': '41.250409',
    'phone': '+90 545 600 25 00',
    'address': 'Yıldızkent, Hüseyin Avni Ulaş, Alparslan Türkeş Blv, 25080 Palandöken/Erzurum',
  },
  {
    'id': 'esh_taksi',
    'name': 'Erzurum Şehir Hastanesi Taksi Durağı',
    'lat': '39.888078',
    'lng': '41.241082',
    'phone': '+90 537 562 99 25',
    'address': 'Çat Yolu Cad., Eğitim Sk. No:13, 25080 Palandöken/Erzurum',
  },
  {
    'id': 'yildizkent_akasya',
    'name': 'Yıldızkent Akasya Taksi',
    'lat': '39.884974',
    'lng': '41.241254',
    'phone': '+90 534 238 37 37',
    'address': 'Ramizefendi, Cami Yanı, 25000',
  },
  {
    'id': 'bilkent',
    'name': 'Bilkent Taksi Durağı',
    'lat': '39.885895',
    'lng': '41.222099',
    'phone': '+90 530 022 03 29',
    'address': 'Anka Siteleri, Üniversite, Prof. Dr. İhsan Doğramacı Blv. Üzeri, 25070 Palandöken/Erzurum',
  },
  {
    'id': 'kayakyolu',
    'name': 'Kayakyolu Taksi',
    'lat': '39.885214',
    'lng': '41.271285',
    'phone': '+90 442 316 36 36',
    'address': 'Düzgün 1 market yanı Kayakyolu, Osmanbektaş Mah, 1. Kayakyolu cad, 25000 Palandöken/Erzurum',
  },
  {
    'id': 'maxroyal',
    'name': 'Kayakyolu Max Royal Taksi',
    'lat': '39.889360',
    'lng': '41.275021',
    'phone': '+90 549 151 25 00',
    'address': 'Osman Bektaş, Öz Meral Sk. No:6, 25080 Palandöken/Erzurum',
  },
  {
    'id': 'abdurrahmangazi_dortyol',
    'name': 'Abdurrahman Gazi Dörtyol Taksi',
    'lat': '39.893163',
    'lng': '41.285225',
    'phone': '+90 537 346 65 35',
    'address': 'Ertuğrul Gazi, Sultan Alparslan Cd. No:41, 25080 Palandöken/Erzurum',
  },
  {
    'id': 'erzurum_taksi',
    'name': 'Erzurum Taksi',
    'lat': '39.897784',
    'lng': '41.275235',
    'phone': '+90 542 225 24 05',
    'address': 'Nöbetçi 7/24 Gece Taksi Durağı erzurumtaksi.com.tr, 25000 Yakutiye',
  },
  {
    'id': 'kosk_taksi',
    'name': 'Köşk Taksi',
    'lat': '39.898775',
    'lng': '41.268778',
    'phone': '+90 442 315 98 93',
    'address': 'Yukarı Köşk Mh., 25080 Palandöken/Erzurum',
  },
  {
    'id': 'emniyet_taksi',
    'name': 'Emniyet Taksi',
    'lat': '39.897357',
    'lng': '41.272227',
    'phone': '+90 538 050 03 25',
    'address': 'Palandöken Kavşağı, Fatih Sultan Mehmet Blv., Palandöken',
  },
  {
    'id': 'erz_merkez_724',
    'name': 'Erzurum Merkez Taksi 7/24',
    'lat': '39.899544',
    'lng': '41.268198',
    'phone': '+90 542 455 24 77',
    'address': 'Hüseyin Avni Ulaş Mahallesi, Koşar Evler, 25100 Yakutiye/Erzurum',
  },
  {
    'id': 'yeni_muratpasa',
    'name': 'Yeni Muratpaşa Taksi',
    'lat': '39.901078',
    'lng': '41.269256',
    'phone': '+90 533 452 97 25',
    'address': 'Muratpaşa, Sabunhane Sk. No:7 D:1, 25200 Yakutiye/Erzurum',
  },
  {
    'id': 'erz_cadde',
    'name': 'Erzurum Cadde Taksi',
    'lat': '39.905783',
    'lng': '41.268493',
    'phone': '+90 535 368 45 00',
    'address': 'Yukarı Mumcu, Çaykara Cd. Çaykara İş Merkezi, 25100 Yakutiye/Erzurum',
  },
  {
    'id': 'erz_gez',
    'name': 'Erzurum Gez Taksi Durağı',
    'lat': '39.912019',
    'lng': '41.266165',
    'phone': '+90 538 898 95 69',
    'address': 'Lalapaşa, Kuşkay Binasi Yanı, 25000 Yakutiye/Erzurum',
  },
  {
    'id': 'erz_ornek',
    'name': 'Erzurum Örnek Taksi',
    'lat': '39.910910',
    'lng': '41.270160',
    'phone': '+90 554 014 00 25',
    'address': 'Kazım Karabekir Cad, Lalapaşa, İnönü ilköğretim okulu önü, 25000 Yakutiye/Erzurum',
  },
  {
    'id': 'kongre',
    'name': 'Kongre Taksi Durağı',
    'lat': '39.914161',
    'lng': '41.276630',
    'phone': '+90 534 557 06 58',
    'address': 'Alipaşa, Kongre Cd. No:81, 25040 Yakutiye/Erzurum',
  },
  {
    'id': 'akbulut',
    'name': 'Şükrüpaşa Akbulut Taksi Durağı',
    'lat': '39.925187',
    'lng': '41.260922',
    'phone': '+90 532 289 76 75',
    'address': 'Şükrüpaşa, Korgeneral fevzi çakmak caddesi, 25200 Yakutiye/Erzurum',
  },
  {
    'id': 'sukrupasa_caykur',
    'name': 'Şükrüpaşa Çaykur Taksi Erzurum',
    'lat': '39.926420',
    'lng': '41.272678',
    'phone': '+90 538 854 04 76',
    'address': 'Aile Sağlık Merkezi Önü, Şükrüpaşa, Çaykur Cd., 25030 Yakutiye/Erzurum',
  },
  {
    'id': 'sanayi_taksi',
    'name': 'Sanayi Taksi Erzurum',
    'lat': '39.928961',
    'lng': '41.282193',
    'phone': '+90 442 244 04 14',
    'address': 'Erzurum Oto Sanayi, Şükrüpaşa, 25000 Yakutiye/Erzurum',
  },
  {
    'id': 'hilalkent_pasakonagi',
    'name': 'Hilalkent Paşakonağı Taksi',
    'lat': '39.943387',
    'lng': '41.295815',
    'phone': '+90 543 714 25 00',
    'address': 'Hilalkent, 25200 Yakutiye/Erzurum',
  },
  {
    'id': 'tashan',
    'name': 'Erzurum Taşhan Taksi',
    'lat': '39.908376',
    'lng': '41.273495',
    'phone': '+90 539 891 15 15',
    'address': 'Rabia Ana, Adnan Menderes Caddesi, 25000 Yakutiye/Erzurum',
  },
  {
    'id': 'dadaskent_lokka',
    'name': 'Dadaşkent Lokka Taksi',
    'lat': '39.905959',
    'lng': '41.198132',
    'phone': '+90 532 569 65 48',
    'address': 'Tepsi Börek Karşısı, Saltuklu, 25000 Aziziye/Erzurum',
  },
  {
    'id': 'diyanet_egitim',
    'name': 'Diyanet Eğitim Taksi',
    'lat': '39.914496',
    'lng': '41.192061',
    'phone': '+90 535 659 88 45',
    'address': 'Selçuklu Mahallesi, Aziziye/Erzurum',
  },
  {
    'id': 'dadaskent_tariktar',
    'name': 'Dadaşkent Taksi Tarıktar Durağı',
    'lat': '39.905959',
    'lng': '41.198132',
    'phone': '+90 537 937 35 05',
    'address': 'Selçuklu, Milli Egemenlik Cd. no: 19/2, 25090 Aziziye/Erzurum',
  },
  {
    'id': 'dadaskent_aziziye',
    'name': 'Dadaşkent Taksi Aziziye',
    'lat': '39.917861',
    'lng': '41.188714',
    'phone': '+90 536 312 25 65',
    'address': 'Saltuklu, Emir Şeyh Cd., 25030 Aziziye/Erzurum',
  },
  {
    'id': 'azel_park',
    'name': 'Azel Park Taksi',
    'lat': '39.924292',
    'lng': '41.182855',
    'phone': '+90 507 220 82 25',
    'address': 'GezKöy Azel Park Taksi, Saltuklu, Dadaşkent Yolu, 25030 Aziziye/Erzurum',
  },
  {
    'id': 'aziziye_bel',
    'name': 'Aziziye Belediyesi Taksi Durağı Dadaşkent',
    'lat': '39.905959',
    'lng': '41.198132',
    'phone': '+90 544 685 16 76',
    'address': 'Selçuklu, Lale Sk., 25090 Aziziye/Erzurum',
  },
  {
    'id': 'teknik_uni',
    'name': 'Teknik Üniversite Taksi Durağı',
    'lat': '39.918930',
    'lng': '41.224756',
    'phone': '+90 530 412 05 72',
    'address': 'Ömer Nasuhi Bilmen, Havaalanı yolu üzeri, 25000 Yakutiye/Erzurum',
  },
  {
    'id': 'arastirma',
    'name': 'Yakutiye Araştırma Hastanesi Taksi',
    'lat': '39.898612',
    'lng': '41.238411',
    'phone': '+90 442 321 14 50',
    'address': 'Atatürk Mh., 25240 Yakutiye/Erzurum',
  },
  {
    'id': 'mng',
    'name': 'Erzurum MNG Avm Taksi',
    'lat': '39.910399',
    'lng': '41.249668',
    'phone': '+90 553 759 90 90',
    'address': 'Erzurum MNG, 25100 Yakutiye/Erzurum',
  },
  {
    'id': 'sukrupasa_kombina',
    'name': 'Şükrüpaşa Kombina Elit Taksi',
    'lat': '39.918472',
    'lng': '41.262068',
    'phone': '+90 533 230 28 25',
    'address': 'Ömer Nasuhi Bilmen, Kombina Cd., 25100 Yakutiye/Erzurum',
  },
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