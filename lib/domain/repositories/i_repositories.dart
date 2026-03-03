import '../entities/ride.dart';
import '../entities/enums.dart';

abstract class IRideRepository {
  Future<List<Ride>> getRideHistory(String userId);
  Future<Ride> getRideDetails(String rideId);
  Future<void> requestRide(Ride ride);
  Future<void> cancelRide(String rideId);
  Future<void> updateRideStatus(String rideId, RideStatus status);
}

abstract class IDriverRepository {
  Future<void> updateDriverStatus(String driverId, DriverStatus status);
  Future<void> goOnline(String driverId);
  Future<void> goOffline(String driverId);
  Future<void> updateEarnings(String driverId, double amount);
}
