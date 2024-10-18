class LocationResult {
  bool status;
  String? message;
  double? latitude;
  double? longitude;

  LocationResult({
    required this.status,
    this.message,
    this.latitude,
    this.longitude,
  });

  @override
  String toString() {
    return 'LocationResult(status: $status, message: $message, latitude: $latitude, longitude: $longitude)';
  }
}
