import 'enums.dart';
import 'rider.dart';
import 'driver.dart';

class Ride {
  final String id;
  final Rider rider;
  final Driver? driver;
  final Location pickupLocation;
  final Location dropLocation;
  final double fare;
  final RideStatus status;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  Ride({
    required this.id,
    required this.rider,
    this.driver,
    required this.pickupLocation,
    required this.dropLocation,
    required this.fare,
    required this.status,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
  });
}

class Location {
  final double latitude;
  final double longitude;
  final String address;

  Location({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}
