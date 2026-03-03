# System Architecture Overview

## Clean Architecture Structure
```text
lib/
├── core/
│   ├── config/ (EnvConfig)
│   ├── network/ (Dio/Rest Client)
│   ├── socket/ (SocketService abstraction)
│   ├── location/ (Throttling logic)
│   ├── services/ (Notification, Crashlytics)
│   ├── logger/ (Log management)
│   └── utils/ (FareCalculator)
│
├── data/
│   ├── models/ (RiderModel, DriverModel)
│   ├── datasources/ (RemoteDataSource)
│   └── repositories/ (Data implementation)
│
├── domain/
│   ├── entities/ (Rider, Driver, Ride)
│   ├── repositories/ (Interface definition)
│   └── usecases/ (MatchingEngine, RequestRide)
│
├── presentation/
│   ├── rider/
│   │   ├── auth/
│   │   ├── ride_request/
│   │   ├── ride_tracking/
│   │   └── payment/
│   │
│   ├── driver/
│   │   ├── onboarding/
│   │   ├── stripe_connect/
│   │   ├── dashboard/
│   │   ├── ride_management/
│   │   └── earnings/
│   │
│   └── shared/ (Common UI widgets)
│
└── injection_container.dart (DI)
```

## High-Level Data Flow
1. **UI Layer** triggers a `UseCase`.
2. **Domain Layer** (UseCase) calls a method in the `Repository` interface.
3. **Data Layer** (Repository implementation) fetches data from `RemoteDataSource`.
4. `RemoteDataSource` calls the `NetworkClient` (API or Socket).
5. Data flows back upstream, converted from `Model` (Data) to `Entity` (Domain).

## Distributed Matching Workflows
```mermaid
sequenceDiagram
    participant Rider
    participant Server
    participant Redis_Geo
    participant Driver_Pool
    
    Rider->>Server: Create Ride Request
    Server->>Redis_Geo: Search nearest drivers (5km)
    Redis_Geo-->>Server: List of online drivers
    Server->>Server: Sort by Rating/Proximity
    loop Until Accepted
        Server->>Driver_Pool: Emit 'new_ride_request' (Socket)
        Driver_Pool-->>Server: Accepted / Timeout / Rejected
    end
    Server-->>Rider: Driver Assigned
```

## Payment Webhook Flow
```mermaid
sequenceDiagram
    participant Stripe
    participant Backend
    participant DB
    participant Apps
    
    Stripe->>Backend: account.updated (Webhook)
    Backend->>Backend: Validate signature
    Backend->>DB: Update Driver Stripe Status
    Backend->>Apps: Notify Driver (Socket/Push)
```
