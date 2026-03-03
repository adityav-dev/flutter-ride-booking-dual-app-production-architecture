import 'enums.dart';

class Driver {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final double rating;
  final DriverStatus status;
  final StripeStatus stripeStatus;
  final String? stripeAccountId;
  final bool isVerified;
  final String vehicleDetails;

  Driver({
    required this.id,
    required this.name,
    required this.email,
    this.status = DriverStatus.OFFLINE,
    this.stripeStatus = StripeStatus.NOT_STARTED,
    this.isVerified = false,
    required this.vehicleDetails,
    this.phoneNumber,
    this.profileImageUrl,
    this.rating = 5.0,
    this.stripeAccountId,
  });
}
