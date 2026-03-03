import 'dart:async';
import '../../domain/entities/enums.dart';
import '../socket/socket_service.dart';

class LocationService {
  final ISocketService _socketService;
  Timer? _locationTimer;
  DriverStatus _currentStatus = DriverStatus.OFFLINE;

  LocationService(this._socketService);

  void updateThrottling(DriverStatus status) {
    if (_currentStatus == status) return;
    _currentStatus = status;
    _startTracking();
  }

  void _startTracking() {
    _locationTimer?.cancel();

    Duration? interval;
    switch (_currentStatus) {
      case DriverStatus.OFFLINE:
        interval = null; // No emit
        break;
      case DriverStatus.ONLINE_IDLE:
        interval = const Duration(seconds: 60);
        break;
      case DriverStatus.DRIVER_ASSIGNED:
        interval = const Duration(seconds: 5);
        break;
      case DriverStatus.RIDE_STARTED:
        interval = const Duration(seconds: 3);
        break;
      default:
        interval = null;
    }

    if (interval != null) {
      _locationTimer = Timer.periodic(interval, (timer) {
        _emitCurrentLocation();
      });
    }
  }

  void _emitCurrentLocation() {
    // Mock getting current location coordinates
    final locationData = {
      'lat': 12.9716,
      'lng': 77.5946,
      'timestamp': DateTime.now().toIso8601String(),
      'status': _currentStatus.toString(),
    };

    _socketService.emit('update_location', locationData);
  }

  void stopTracking() {
    _locationTimer?.cancel();
    _currentStatus = DriverStatus.OFFLINE;
  }
}
