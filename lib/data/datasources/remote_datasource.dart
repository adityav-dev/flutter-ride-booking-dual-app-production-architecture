import '../../domain/entities/driver.dart';

abstract class RemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<void> uploadDocument(String driverId, String filePath);
  Future<List<Map<String, dynamic>>> fetchAvailableRides(double lat, double lng);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  // Use Dio or Http client here
  
  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    return {'token': 'jwt_token_here'};
  }

  @override
  Future<void> uploadDocument(String driverId, String filePath) async {
    // Implementation: Multi-part form upload
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAvailableRides(double lat, double lng) async {
    return [];
  }
}
