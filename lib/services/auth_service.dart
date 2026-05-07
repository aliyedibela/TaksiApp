import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/driver.dart';

class AuthService {

  static const String baseUrl = 'https://taksiappbackendnet-production.up.railway.app/api/auth';

  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String taxiStandId,
    required String taxiStandName,
    required String driverName,
    required String vehiclePlate,
  }) async {
    try {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🚀 FLUTTER: SIGNUP İSTEĞİ BAŞLADI');
      print('📧 Email: $email');
      print('🚖 Durak: $taxiStandName');
      print('👤 Sürücü: $driverName');
      print('🚗 Plaka: $vehiclePlate');
      print('🌐 URL: $baseUrl/signup');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final requestBody = {
        'Email': email,                  
        'Password': password,            
        'TaxiStandId': taxiStandId,     
        'TaxiStandName': taxiStandName, 
        'DriverName': driverName,        
        'VehiclePlate': vehiclePlate,    
      };

      print('📦 Request Body:');
      print(jsonEncode(requestBody));

      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          print('⏰ TIMEOUT - 30 saniye içinde cevap gelmedi');
          throw Exception('Sunucu yanıt vermiyor');
        },
      );

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📨 Response Status Code: ${response.statusCode}');
      print('📨 Response Body: ${response.body}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ KAYIT BAŞARILI!');
        print('🆔 Driver ID: ${data['driverId']}');
        if (data['debugCode'] != null) {
          print('🔐 Debug Code: ${data['debugCode']}');
        }
        return {
          'success': true,
          'driverId': data['driverId'],
          'debugCode': data['debugCode'],
          'message': data['message'],
        };
      } else {
        final data = jsonDecode(response.body);
        print('❌ KAYIT BAŞARISIZ: ${data['error']}');
        return {'success': false, 'error': data['error'] ?? 'Kayıt başarısız'};
      }
    } catch (e, stackTrace) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('💥 HATA OLUŞTU!');
      print('❌ Hata: $e');
      print('📍 Stack Trace:');
      print(stackTrace);
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      return {'success': false, 'error': 'Bağlantı hatası: $e'};
    }
  }

  Future<Map<String, dynamic>> verify(String driverId, String code) async {
    try {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🔐 FLUTTER: VERIFY İSTEĞİ BAŞLADI');
      print('🆔 Driver ID: $driverId');
      print('🔢 Code: $code');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final response = await http.post(
        Uri.parse('$baseUrl/verify'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          'DriverId': driverId,
          'Code': code,
        }),
      ).timeout(const Duration(seconds: 30));

      print('📨 Response Status: ${response.statusCode}');
      print('📨 Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('✅ DOĞRULAMA BAŞARILI');
        return {'success': true, 'message': data['message']};
      } else {
        print('❌ DOĞRULAMA BAŞARISIZ: ${data['error']}');
        return {'success': false, 'error': data['error'] ?? 'Doğrulama başarısız'};
      }
    } catch (e, stackTrace) {
      print('💥 VERIFY HATASI: $e');
      print('📍 Stack Trace: $stackTrace');
      return {'success': false, 'error': 'Bağlantı hatası: $e'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🔑 FLUTTER: LOGIN İSTEĞİ BAŞLADI');
      print('📧 Email: $email');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          'Email': email,
          'Password': password,
        }),
      ).timeout(const Duration(seconds: 30));

      print('📨 Response Status: ${response.statusCode}');
      print('📨 Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('✅ GİRİŞ BAŞARILI');
        final driver = Driver.fromJson(data);
        await _saveDriver(driver);
        return {'success': true, 'driver': driver};
      } else {
        print('❌ GİRİŞ BAŞARISIZ: ${data['error']}');
        return {'success': false, 'error': data['error'] ?? 'Giriş başarısız'};
      }
    } catch (e, stackTrace) {
      print('💥 LOGIN HATASI: $e');
      print('📍 Stack Trace: $stackTrace');
      return {'success': false, 'error': 'Bağlantı hatası: $e'};
    }
  }

  Future<void> _saveDriver(Driver driver) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('driver', jsonEncode(driver.toJson()));
    print('💾 Sürücü bilgisi kaydedildi');
  }

  Future<Driver?> getSavedDriver() async {
    final prefs = await SharedPreferences.getInstance();
    final driverJson = prefs.getString('driver');
    if (driverJson != null) {
      print('💾 Kaydedilmiş sürücü bulundu');
      return Driver.fromJson(jsonDecode(driverJson));
    }
    print('💾 Kaydedilmiş sürücü bulunamadı');
    return null;
  }

  Future<Map<String, dynamic>> resendCode(String driverId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/resend-code'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({'DriverId': driverId}),
      ).timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Kod gönderilemedi'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Bağlantı hatası: $e'};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('driver');
    print('👋 Çıkış yapıldı');
  }
}
