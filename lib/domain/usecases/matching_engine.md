# Matching Engine Design & Pseudocode

The Matching Engine is responsible for finding the most suitable driver for a ride request based on proximity, rating, and availability.

## Requirements
- Filter **ONLINE** drivers.
- Geo-radius search (initially 5km).
- Sort by:
    - Distance (Proximity)
    - Rating (Quality)
    - Acceptance Rate (Reliability)
- Timeout handling (30s per driver).
- Fallback to the next available driver.

## Pseudocode (Business Logic)

```dart
class MatchingEngine {
  final DriverRepository driverRepository;
  final SocketService socketService;

  MatchingEngine(this.driverRepository, this.socketService);

  Future<void> findDriver(RideRequest request) async {
    double currentRadius = 5.0; // 5km
    List<String> excludedDriverIds = [];

    while (currentRadius <= 15.0) { // Max 15km expansion
      // 1. Get available drivers within radius
      List<Driver> candidateDrivers = await driverRepository.getAvailableDrivers(
        lat: request.pickupLat,
        lng: request.pickupLng,
        radius: currentRadius,
        excludeIds: excludedDriverIds,
      );

      // 2. Sort candidates by score
      // Score = (Proximity * 0.5) + (Rating * 0.3) + (AcceptanceRate * 0.2)
      candidateDrivers.sort((a, b) => b.score.compareTo(a.score));

      for (var driver in candidateDrivers) {
        // 3. Emit matching event to driver via Socket
        bool accepted = await _requestDriver(driver, request);
        
        if (accepted) {
          // 4. Update Ride State to DRIVER_ASSIGNED
          return;
        } else {
          // Driver rejected or timed out, add to excluded list
          excludedDriverIds.add(driver.id);
        }
      }

      // 5. Expand radius if no driver found
      currentRadius += 5.0;
    }

    // 6. Handle "No Driver Found" scenario
    _handleNoDrivers(request);
  }

  Future<bool> _requestDriver(Driver driver, RideRequest request) async {
    Completer<bool> completer = Completer();
    
    // Send socket event
    socketService.emitToDriver(driver.id, 'new_ride_request', request.toJson());

    // Wait for response or timeout (30s)
    Timer(Duration(seconds: 30), () {
      if (!completer.isCompleted) completer.complete(false);
    });

    // Listen for 'ride_response' from this specific driver
    socketService.on('ride_response_${driver.id}').listen((data) {
       if (data['accepted'] == true && !completer.isCompleted) {
         completer.complete(true);
       }
    });

    return completer.future;
  }
}
```

## Why this is Scalable
1. **Redis Geo-Indexing**: The `getAvailableDrivers` call uses Redis `GEORADIUS` or `GEOSEARCH` for O(log(N)) efficiency.
2. **Expansion Cache**: Using an exclusion list prevents re-evaluating rejected drivers during radius expansion.
3. **Stateless Logic**: The engine can be horizontally scaled as a microservice behind a load balancer.
4. **WebSocket Clustering**: Socket events are routed via a message broker (Redis/RabbitMQ) to specific driver connections across multiple server nodes.
