class Driver {
  final String id;
  final String email;
  final String taxiStandId;
  final String taxiStandName;
  final String driverName;
  final String vehiclePlate;
  final String? token;

  Driver({
    required this.id,
    required this.email,
    required this.taxiStandId,
    required this.taxiStandName,
    required this.driverName,
    required this.vehiclePlate,
    this.token,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['driverId'] ?? '',
      email: json['email'] ?? '',
      taxiStandId: json['taxiStandId'] ?? '',
      taxiStandName: json['taxiStandName'] ?? '',
      driverName: json['driverName'] ?? '',
      vehiclePlate: json['vehiclePlate'] ?? '',
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'taxiStandId': taxiStandId,
      'taxiStandName': taxiStandName,
      'driverName': driverName,
      'vehiclePlate': vehiclePlate,
      'token': token,
    };
  }
}