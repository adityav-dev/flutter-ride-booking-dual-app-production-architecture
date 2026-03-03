# Stripe Connect Onboarding & Payment Flow

## Overview
We use **Stripe Connect Express** for driver onboarding and automatic payment splits. This allows the platform to collect a 20% commission and transfer 80% directly to the driver's bank account.

## Driver Onboarding Flow

1. **Create Stripe Account**: The app calls the backend to create a Stripe Express account for the driver.
   ```javascript
   const account = await stripe.accounts.create({ type: 'express' });
   ```
2. **Store Account ID**: Store `stripe_account_id` in the Driver record (Status: `PENDING_STRIPE`).
3. **Generate Account Link**: Create a link for the driver to complete onboarding.
   ```javascript
   const accountLink = await stripe.accountLinks.create({
     account: driver.stripe_account_id,
     refresh_url: 'https://rideapp.com/reauth',
     return_url: 'https://rideapp.com/return',
     type: 'account_onboarding',
   });
   ```
4. **Redirect Driver**: The Flutter app opens the `accountLink.url` in a WebView or browser.
5. **Webhook Verification**: Listen for `account.updated`.
   - If `payouts_enabled` && `charges_enabled` -> Set `stripe_status = VERIFIED`.

## Payment Execution (Ride Completion)

1. **Create PaymentIntent**: When a rider books, create a PaymentIntent on behalf of the driver.
   ```javascript
   const paymentIntent = await stripe.paymentIntents.create({
     amount: totalFare * 100, // In cents
     currency: 'usd',
     payment_method_types: ['card'],
     transfer_data: {
       destination: driver.stripe_account_id,
       amount: driverEarnings * 100, // 80% split
     },
   });
   ```
2. **Capture Payment**: Upon ride completion, capture the funds.
3. **Commission**: The remaining 20% stays in the platform's Stripe balance as the application fee.

## Webhook Handler Example (Node.js)

```javascript
app.post('/stripe-webhook', (req, res) => {
  const event = req.body;

  switch (event.type) {
    case 'account.updated':
      const account = event.data.object;
      if (account.payouts_enabled && account.charges_enabled) {
        updateDriverStripeStatus(account.id, 'VERIFIED');
      }
      break;
    
    case 'payment_intent.succeeded':
      const paymentIntent = event.data.object;
      updateRideStatus(paymentIntent.metadata.ride_id, 'PAID');
      break;

    default:
      console.log(`Unhandled event type ${event.type}`);
  }

  res.json({received: true});
});
```
