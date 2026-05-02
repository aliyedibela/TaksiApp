import 'package:signalr_netcore/signalr_client.dart';
import '../models/taxi_request.dart';

class SignalRService {
  static const String _baseUrl = 'https://taksiappbackendnet-production.up.railway.app';
  static const String hubUrl = '$_baseUrl/taxiHub';

  late HubConnection _hubConnection;
  bool _isConnected = false;
  String? _currentDriverId;

  Function(TaxiRequest)? onNewRequest;
  Function(String)? onRequestClosed;
  Function(String)? onDriverRegistered;

  void _registerHandlers() {
    _hubConnection.on('NewTaxiRequest', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final request = TaxiRequest.fromJson(arguments[0] as Map<String, dynamic>);
        onNewRequest?.call(request);
      }
    });

    _hubConnection.on('RequestClosed', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        onRequestClosed?.call(arguments[0] as String);
      }
    });

    _hubConnection.on('DriverRegistered', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final message = (arguments[0] as Map<String, dynamic>)['message'] as String;
        onDriverRegistered?.call(message);
      }
    });

    _hubConnection.onreconnected(({connectionId}) async {
      print('🔄 SignalR yeniden bağlandı, sürücü kaydediliyor...');
      if (_currentDriverId != null) {
        try {
          await _hubConnection.invoke('RegisterDriver', args: [_currentDriverId]);
          print('✅ Yeniden kayıt başarılı');
        } catch (e) {
          print('⚠️ Yeniden kayıt hatası: $e');
        }
      }
    });
  }

  Future<void> connect(String driverId) async {
    _currentDriverId = driverId;

    // 1. Önce default transport ile dene (Railway negotiate eder)
    try {
      _hubConnection = HubConnectionBuilder()
          .withUrl(hubUrl)
          .withAutomaticReconnect(retryDelays: [0, 2000, 5000, 10000, 30000])
          .build();

      _registerHandlers();
      await _hubConnection.start();
      _isConnected = true;
      await _hubConnection.invoke('RegisterDriver', args: [driverId]);
      print('✅ SignalR bağlantısı kuruldu (default transport)');
      return;
    } catch (e) {
      print('⚠️ Default transport başarısız: $e');
      _isConnected = false;
    }

    // 2. LongPolling fallback
    try {
      print('🔄 LongPolling ile tekrar deneniyor...');
      _hubConnection = HubConnectionBuilder()
          .withUrl(
            hubUrl,
            options: HttpConnectionOptions(
              transport: HttpTransportType.LongPolling,
            ),
          )
          .withAutomaticReconnect(retryDelays: [0, 3000, 10000, 30000])
          .build();

      _registerHandlers();
      await _hubConnection.start();
      _isConnected = true;
      await _hubConnection.invoke('RegisterDriver', args: [driverId]);
      print('✅ LongPolling bağlantısı kuruldu');
    } catch (e) {
      print('❌ LongPolling da başarısız: $e');
      _isConnected = false;
    }
  }

  Future<void> acceptRequest(String requestId, String driverId) async {
    if (!_isConnected) return;
    
    try {
      await _hubConnection.invoke('AcceptRequest', args: [requestId, driverId]);
      print('✅ İstek kabul edildi: $requestId');
    } catch (e) {
      print('❌ İstek kabul hatası: $e');
    }
  }

  Future<void> rejectRequest(String requestId, String driverId) async {
    if (!_isConnected) return;
    
    try {
      await _hubConnection.invoke('RejectRequest', args: [requestId, driverId]);
      print('✅ İstek reddedildi: $requestId');
    } catch (e) {
      print('❌ İstek red hatası: $e');
    }
  }

  Future<void> disconnect() async {
    if (_isConnected) {
      await _hubConnection.stop();
      _isConnected = false;
      print('🔌 SignalR bağlantısı kesildi');
    }
  }

  bool get isConnected => _isConnected;
}