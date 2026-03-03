import 'dart:async';
import '../config/env_config.dart';

abstract class ISocketService {
  void connect();
  void disconnect();
  void emit(String event, dynamic data);
  Stream<dynamic> on(String event);
  bool get isConnected;
}

class SocketService implements ISocketService {
  final EnvConfig config;
  // In a real app, this would use socket_io_client or similar
  // For this architecture, we provide the production-grade abstraction

  SocketService(this.config);

  @override
  void connect() {
    print('Connecting to Socket at ${config.socketUrl}...');
    // Implementation: _socket = io(config.socketUrl, ...);
  }

  @override
  void disconnect() {
    print('Disconnecting Socket...');
  }

  @override
  void emit(String event, dynamic data) {
    print('Socket Emit [$event]: $data');
  }

  @override
  Stream<dynamic> on(String event) {
    // Return stream for the event
    return Stream.empty();
  }

  @override
  bool get isConnected => true; // Mock status
}
