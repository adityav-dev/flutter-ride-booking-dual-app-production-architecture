# Admin Monitoring & Management Structure

The Admin Panel is a critical component for system integrity, driver verification, and revenue monitoring.

## Core Responsibilities
1. **Driver Approval**: Reviewing uploaded documents (License, Vehicle Registration) and Stripe status.
2. **Real-time Monitoring**: Viewing active rides, driver distribution (Heatmaps), and system load.
3. **Revenue Dashboard**: Tracking platform commission, total volume, and payout statuses.
4. **User Management**: Suspending/Banning drivers or riders for policy violations.

## Architecture & Integration

### Verification Flow
- **Webhook**: Admin listens for `driver_document_uploaded` events (Socket/SNS).
- **Approval API**: `POST /admin/drivers/:id/approve`
    - Sets `is_verified = true` in DB.
    - Triggers push notification to Driver.

### Monitoring Engine
- **Active Ride Stream**: A specific WebSocket namespace `/admin` streams aggregate ride data.
- **Geo-Visualization**: Admin frontend uses Mapbox/Google Maps to show:
    - Pins for `ONLINE_IDLE` drivers.
    - Routes for `RIDE_STARTED` status.

### Revenue Logic
- **Commission Tracker**: Aggregates the 20% platform fee from each transaction.
- **Payout Controls**: Ability to trigger manual payouts or hold funds for investigation via Stripe API.

## API Endpoints (Internal)
- `GET /admin/dashboard/stats`: High-level Metrics (Daily Active Users, Revenue).
- `GET /admin/drivers/pending`: List of drivers needing verification.
- `PATCH /admin/drivers/:id/status`: Update status (Approve/Suspend).
- `GET /admin/rides/active`: Real-time view of current rides.

## Security
- **Role-Based Access Control (RBAC)**: Ensure only users with `ADMIN` role can access these endpoints.
- **Audit Logs**: Every admin action (Approve/Suspend) is logged with timestamp and admin ID.
