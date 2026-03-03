class EnvConfig {
  final String apiBaseUrl;
  final String socketUrl;
  final String stripePublishableKey;
  final bool isProduction;

  EnvConfig({
    required this.apiBaseUrl,
    required this.socketUrl,
    required this.stripePublishableKey,
    this.isProduction = false,
  });

  static EnvConfig development = EnvConfig(
    apiBaseUrl: 'https://dev-api.rideapp.com/v1',
    socketUrl: 'wss://dev-socket.rideapp.com',
    stripePublishableKey: 'pk_test_sample',
    isProduction: false,
  );

  static EnvConfig production = EnvConfig(
    apiBaseUrl: 'https://api.rideapp.com/v1',
    socketUrl: 'wss://socket.rideapp.com',
    stripePublishableKey: 'pk_live_sample',
    isProduction: true,
  );
}
