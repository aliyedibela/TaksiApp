class TaxiRequest {
  final String requestId;
  final String userId;
  final String taxiStandId;
  final double fromLat;
  final double fromLng;
  final double toLat;
  final double toLng;
  final double estimatedFare;
  final DateTime requestTime;
  String status;
  final String? driverName;
  final String? driverPlate;

  TaxiRequest({
    required this.requestId,
    required this.userId,
    required this.taxiStandId,
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
    required this.estimatedFare,
    required this.requestTime,
    this.status = 'Pending',
    this.driverName,
    this.driverPlate,
  });

  factory TaxiRequest.fromJson(Map<String, dynamic> json) {
    return TaxiRequest(
      requestId: json['requestId'] ?? '',
      userId: json['userId'] ?? '',
      taxiStandId: json['taxiStandId'] ?? '',
      fromLat: (json['fromLat'] ?? 0.0).toDouble(),
      fromLng: (json['fromLng'] ?? 0.0).toDouble(),
      toLat: (json['toLat'] ?? 0.0).toDouble(),
      toLng: (json['toLng'] ?? 0.0).toDouble(),
      estimatedFare: (json['estimatedFare'] ?? 0.0).toDouble(),
      requestTime: DateTime.tryParse(json['requestTime'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'Pending',
      driverName: json['driverName'],
      driverPlate: json['driverPlate'],
    );
  }
}