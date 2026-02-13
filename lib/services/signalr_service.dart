import 'package:signalr_netcore/signalr_client.dart';
import '../models/taxi_request.dart';

class SignalRService {
  static const String hubUrl = 'https://jannette-acrogynous-allene.ngrok-free.dev/taxiHub'; 
  
  late HubConnection _hubConnection;
  bool _isConnected = false;

  Function(TaxiRequest)? onNewRequest;
  Function(String)? onRequestClosed;
  Function(String)? onDriverRegistered;

  Future<void> connect(String driverId) async {
    try {
      _hubConnection = HubConnectionBuilder()
          .withUrl(hubUrl)
          .withAutomaticReconnect()
          .build();

      _hubConnection.on('NewTaxiRequest', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          final request = TaxiRequest.fromJson(arguments[0] as Map<String, dynamic>);
          onNewRequest?.call(request);
        }
      });

      _hubConnection.on('RequestClosed', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          final requestId = arguments[0] as String;
          onRequestClosed?.call(requestId);
        }
      });

      _hubConnection.on('DriverRegistered', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          final message = (arguments[0] as Map<String, dynamic>)['message'] as String;
          onDriverRegistered?.call(message);
        }
      });

      await _hubConnection.start();
      _isConnected = true;
      await _hubConnection.invoke('RegisterDriver', args: [driverId]);
      
      print('✅ SignalR bağlantısı kuruldu');
    } catch (e) {
      print('❌ SignalR bağlantı hatası: $e');
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