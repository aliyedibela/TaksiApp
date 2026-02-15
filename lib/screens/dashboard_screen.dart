import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'login_screen.dart';
import 'dart:async';
import 'package:taxi_driver_app/models/driver.dart';

class DashboardScreen extends StatefulWidget {
  final Driver driver;
  const DashboardScreen({super.key, required this.driver});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  HubConnection? _hub;
  bool _isOnline = false;
  bool _isConnecting = false;
  bool _isDark = true; 
  String _statusText = "Çevrimdışı";
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _totalRequests = 0;
  int _acceptedRequests = 0;

  Color get _bg => _isDark ? const Color(0xFF111111) : const Color(0xFFFFF8F0);
  Color get _card => _isDark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _txt => _isDark ? Colors.white : const Color(0xFF1A1A1A);
  Color get _txt2 => _isDark ? Colors.white54 : Colors.black45;
  Color get _txt3 => _isDark ? Colors.white38 : Colors.black38;
  Color get _txt4 => _isDark ? Colors.white70 : Colors.black54;
  Color get _border => _isDark ? Colors.white12 : Colors.black12;
  Color get _offIcon => _isDark ? Colors.white30 : Colors.black26;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _connectAndRegister();
  }

  Future<void> _connectAndRegister() async {
    setState(() {
      _isConnecting = true;
      _statusText = "Bağlanıyor...";
    });
    try {
      _hub = HubConnectionBuilder()
          .withUrl("https://jannette-acrogynous-allene.ngrok-free.dev/taxiHub")
          .withAutomaticReconnect()
          .build();

      _hub!.on("DriverRegistered", (args) {
        if (!mounted) return;
        setState(() {
          _isOnline = true;
          _statusText = "Çevrimiçi";
          _isConnecting = false;
        });
      });

      _hub!.on("NewTaxiRequest", (args) {
        if (!_isOnline || !mounted) return;
        final data = Map<String, dynamic>.from(args?[0] as Map);
        setState(() => _totalRequests++);
        _showIncomingRequest(data);
      });

      _hub!.on("RequestClosed", (args) {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).maybePop();
          _showSnack("Bu istek başka sürücü tarafından alındı.", Colors.orange);
        }
      });

      _hub!.onreconnected(({connectionId}) => _registerDriver());

      await _hub!.start();
      await _registerDriver();
    } catch (e) {
      setState(() {
        _isConnecting = false;
        _statusText = "Bağlantı hatası";
      });
    }
  }

  Future<void> _registerDriver() async {
    try {
      await _hub!.invoke("RegisterDriver", args: [widget.driver.id]);
      if (mounted) {
        setState(() {
          _isOnline = true;
          _isConnecting = false;
          _statusText = "Çevrimiçi";
        });
      }
    } catch (e) {
      print("RegisterDriver hatası: $e");
      if (mounted) setState(() => _isConnecting = false);
    }
  }

  void _toggleAvailability() {
    if (!mounted) return;
    final newState = !_isOnline;
    setState(() => _isOnline = newState);
    _showSnack(
      newState ? "✅ Müsait durumundasınız" : "⏸ Meşgul moduna geçildi",
      newState ? const Color(0xFF2E7D32) : Colors.orange,
    );
  }

 void _showIncomingRequest(Map<String, dynamic> data) {
  final requestId = data['requestId'] as String? ?? '';
  final fare = (data['estimatedFare'] as num?)?.toStringAsFixed(0) ?? '?';
  int remainingSeconds = 60; 
  Timer? countdownTimer;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setDialogState) {

          countdownTimer?.cancel();
          countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (remainingSeconds > 0) {
              setDialogState(() => remainingSeconds--);
            } else {

              timer.cancel();
              Navigator.pop(ctx);
              _hub!.invoke("RejectRequest", args: [requestId, widget.driver.id]);
              _showSnack("⏱️ İstek süresi doldu (otomatik red)", Colors.orange);
            }
          });

          return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: const Color(0xFF1C1C1E),
                  border: Border.all(
                      color: const Color(0xFFFF6F00).withOpacity(0.6), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFFFF6F00).withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 2)
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6F00).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.notifications_active,
                            color: Color(0xFFFF6F00), size: 26),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Yeni İstek",
                              style: TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 1)),
                          Text("MÜŞTERİ BEKLİYOR",
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ]),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFFFF8F00), Color(0xFFFF6F00)]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(children: [
                        const Icon(Icons.account_balance_wallet, color: Colors.white70, size: 22),
                        const SizedBox(height: 8),
                        const Text("Tahmini Kazanç",
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text("$fare ₺",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 36,
                                fontWeight: FontWeight.bold, letterSpacing: -1)),
                      ]),
                    ),
                    
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer, color: Colors.white70, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "$remainingSeconds saniye",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    Row(children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFEF5350), width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () async {
                            countdownTimer?.cancel();
                            Navigator.pop(ctx);
                            await _hub!.invoke("RejectRequest", args: [requestId, widget.driver.id]);
                          },
                          icon: const Icon(Icons.close, color: Color(0xFFEF5350), size: 20),
                          label: const Text("Reddet",
                              style: TextStyle(color: Color(0xFFEF5350), fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6F00),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            countdownTimer?.cancel();
                            Navigator.pop(ctx);
                            await _hub!.invoke("AcceptRequest", args: [requestId, widget.driver.id]);
                            setState(() => _acceptedRequests++);
                            _showSnack("✅ Müşteriye gidiliyor!", const Color(0xFF2E7D32));
                          },
                          icon: const Icon(Icons.check, color: Colors.white, size: 20),
                          label: const Text("Kabul Et",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  ).then((_) {
    countdownTimer?.cancel();
  });
}

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _hub?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      color: _bg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFFFFA726), Color(0xFFFF6F00)]),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.local_taxi, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text("Sürücü Paneli",
                            style: TextStyle(color: _txt2, fontSize: 12, letterSpacing: 0.8)),
                        Text(widget.driver.driverName ?? 'Sürücü',
                            style: TextStyle(color: _txt, fontSize: 18, fontWeight: FontWeight.bold)),
                      ]),
                    ]),

                    Row(children: [

                      GestureDetector(
                        onTap: () => setState(() => _isDark = !_isDark),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          width: 50, height: 26,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: _isDark ? const Color(0xFF2C2C2E) : const Color(0xFFFFE0B2),
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                              color: _isDark
                                  ? Colors.white12
                                  : const Color(0xFFFF6F00).withOpacity(0.4),
                            ),
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 280),
                            alignment: _isDark ? Alignment.centerLeft : Alignment.centerRight,
                            child: Container(
                              width: 20, height: 20,
                              decoration: BoxDecoration(
                                color: _isDark ? const Color(0xFF636366) : const Color(0xFFFF6F00),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                                color: Colors.white, size: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _isConnecting
                                ? Colors.orange.withOpacity(0.5)
                                : _isOnline
                                    ? Colors.green.withOpacity(0.5)
                                    : Colors.red.withOpacity(0.3),
                          ),
                          boxShadow: _isDark ? [] : [
                            BoxShadow(color: Colors.black.withOpacity(0.06),
                                blurRadius: 8, offset: const Offset(0, 2))
                          ],
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              color: _isConnecting
                                  ? Colors.orange
                                  : _isOnline ? Colors.greenAccent : Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(_statusText,
                              style: TextStyle(color: _txt4, fontSize: 12, fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ]),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFF6F00).withOpacity(0.2)),
                    boxShadow: _isDark ? [] : [
                      BoxShadow(color: Colors.black.withOpacity(0.06),
                          blurRadius: 12, offset: const Offset(0, 4))
                    ],
                  ),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6F00).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.directions_car, color: Color(0xFFFF6F00), size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(widget.driver.vehiclePlate ?? '-',
                            style: TextStyle(color: _txt, fontSize: 20,
                                fontWeight: FontWeight.bold, letterSpacing: 3)),
                        const SizedBox(height: 3),
                        Text(widget.driver.taxiStandName ?? '-',
                            style: TextStyle(color: _txt2, fontSize: 13)),
                      ]),
                    ),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text("$_acceptedRequests",
                          style: const TextStyle(color: Color(0xFFFF6F00),
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Text("sefer", style: TextStyle(color: _txt3, fontSize: 12)),
                    ]),
                  ]),
                ),
              ),

              const Spacer(),
              GestureDetector(
                onTap: _toggleAvailability,
                child: AnimatedBuilder(
                  animation: _isOnline ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
                  builder: (context, child) => Transform.scale(
                    scale: _isOnline ? _pulseAnimation.value : 1.0,
                    child: child,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    width: 200, height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _card,
                      border: Border.all(
                        color: _isOnline ? const Color(0xFFFF6F00) : _offIcon,
                        width: 3,
                      ),
                      boxShadow: _isOnline
                          ? [BoxShadow(color: const Color(0xFFFF6F00).withOpacity(0.35),
                              blurRadius: 40, spreadRadius: 8)]
                          : _isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.07),
                              blurRadius: 20, spreadRadius: 2)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            _isOnline ? Icons.wifi_tethering : Icons.wifi_tethering_off,
                            key: ValueKey(_isOnline),
                            color: _isOnline ? const Color(0xFFFF6F00) : _offIcon,
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _isOnline ? "MÜSAİTİM" : "MEŞGULÜM",
                            key: ValueKey(_isOnline),
                            style: TextStyle(
                              color: _isOnline ? const Color(0xFFFF6F00) : _offIcon,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isOnline ? "İstek almaya hazır" : "Dokunarak aktif et",
                          style: TextStyle(color: _txt3, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: GestureDetector(
                  onTap: () {
                    _hub?.stop();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _border),
                      boxShadow: _isDark ? [] : [
                        BoxShadow(color: Colors.black.withOpacity(0.05),
                            blurRadius: 8, offset: const Offset(0, 2))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded, color: _txt3, size: 20),
                        const SizedBox(width: 8),
                        Text("Çıkış Yap",
                            style: TextStyle(color: _txt3, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}