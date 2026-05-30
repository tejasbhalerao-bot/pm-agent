# [PRD] DMS Integration — Milestone 7: Driver App & Execution Setup

**Version:** v2
**Date:** 2026-05-30
**Author:** Tejas Bhalerao
**Status:** In Review

---

## Changelog (v1 → v2)

| # | Section | Change |
|---|---|---|
| A | UC 1.1 Happy Path | Added manual AWB entry option for torn or damaged barcodes |
| 1 | — | Edit lock section not included — not required for this release |
| 2 | UC 1.7 | Added driver exit clause for emergency trip completion (vehicle breakdown, receiving driver scenarios) |
| 3 | UC 1.1 EC1 | 3 scan failures → manual AWB entry (not ops intervention) |
| 4 | UC 1.1 EC3 | Clarified block condition: applies to plan mismatch only, not active trip reassignment |
| 5 | UC 1.1 EC7 | Added that departure before all orders scanned is a prohibited on-ground practice |
| 6 | UC 1.2 EC1 | Failed-sync orders must be moved to another plan/trip; complete trip block not acceptable |
| 7 | UC 1.2 EC6 | Removed "ops manually advances trip state" line |
| 8 | UC 1.2 EC2 | Trip Start permitted with alert; Locus escalated offline for resolution |
| 9 | UC 1.2 EC3 | Rejected orders must be removed or reassigned before button is enabled |
| 10 | UC 1.3 Happy Path | Driver must explicitly move order to first position before navigation is enabled |
| 11 | UC 1.3 EC1 | Order list failure treated as P0; Locus steps in |
| 12 | UC 1.3 EC3 | Customer contact available in unmasked format on Locus dashboard |
| 13 | UC 1.3 EC4 | Only valid fallback is contacting ops; removed printed route sheet |
| 14 | UC 1.3 EC5 | Driver coordinates with customer and ops; orders flagged to Locus for coordinate resolution |
| 15 | UC 1.3 EC6 | Driver reschedules directly; Locus sends Delivery Failed event; order enters Open state; does not block trip |
| 16 | UC 1.3 | Removed EC7 (customer with no phone number — this scenario does not occur) |
| 17 | UC 1.4 Flow 2 | Driver has single option: Reschedule Delivery, triggering NDR flow |
| 18 | UC 1.4 | Reschedule moves order to Open state (not Parked); 3 attempts → Truemeds sends cancellation → RTO flow |
| 19 | UC 1.4 | Payment method remains fixed; prepaid-to-COD conversion at driver arrival if payment not completed |
| 20 | UC 1.4 EC2 | Ops manually selects rescheduling reason and moves order to Open state |
| 21 | UC 1.4 | Removed Cancel Delivery geofence edge case (Cancel Delivery option no longer exists) |
| 22 | UC 1.5 | POD method is singular per order (barcode OR OTP); skip is the fallback for both; skips audited by ops |
| 23 | UC 1.5 Flow 2 | OTP delivery via SMS or WhatsApp (channel determined at implementation) |
| 24 | UC 1.5 EC1 | 3 failures → skip prompt; if skip fails → dispatcher manually marks |
| 25 | UC 1.5 EC4 | OTP not received by Truemeds → driver delivers parcel; dispatcher manually moves status |
| 26 | UC 1.5 EC5 | OTP SMS/WhatsApp failure → dispatcher manually moves status (customer not contacted) |
| 27 | UC 1.5 EC6 | OTP visible to ops; coordinate with ops; ops moves order along if all else fails |
| 28 | UC 1.5 EC9 | Customer absence reason renamed to "Customer Unavailable" |
| 29 | UC 1.5 | Removed OTP expiry edge case |
| 30 | UC 1.6 Happy Path | Updated Prepaid payment handling with prepaid-to-COD conversion scenario |
| 31 | UC 1.6 EC6 | Locus must ensure dispatcher can see reason for order entering Parked state |
| 32 | UC 1.8 | Removed battery warning edge case |
| 33 | UC 1.8 EC4 | Driver blocked from all Locus actions until GPS access is restored |
| 34 | UC 1.8 EC5 | Dispatcher view shows driver's phone number only; dispatcher dials manually |
| 35 | UC 2 Happy Path | Earnings window extended to 6 months minimum |
| 36 | UC 2 Happy Path | Earnings for current day finalised at end of day (not shift end) |
| 37 | UC 2 | All shift references removed |
| 38 | UC 3 | All shift references removed; UC renamed to App Login Experience |
| 39 | UC 3 EC1 | App installation failure escalated to Locus |
| 40 | UC 3 EC4 | OTP generation failure escalated to Locus |
| 41 | UC 3 EC5 | OTP delivery failure → Locus steps in; no manual access provision |
| 42 | UC 5 Happy Path | Termination takes effect on next app interaction (no propagation window) |
| 43 | UC 5 EC1 | Mid-trip termination takes effect after trip completion (not shift boundary) |
| 44 | — | UC 8 (Multi-Device & Session Management) removed; not in scope for this release |

---

## RACI

| Function | R | A | C | I |
|---|---|---|---|---|
| Product | Tejas | Tejas | — | — |
| Engineering | Eng Lead | — | Tejas | Fahad |
| Ops | Ops Lead | — | Tejas | Kartik |
| Locus | Locus CSM | — | Eng Lead | — |
| Analytics | Analytics Lead | — | Tejas | — |

---

## Objective

Enable delivery executives to execute their full shift — from handover to trip completion — through the Locus driver app, with complete digitisation of proof of delivery, COD collection, sequence management, and earnings visibility.

---

## Why Now?

Hyperlocal delivery execution is currently untracked from the moment an order leaves the warehouse. There is no digital record of handover, delivery sequence, POD, or COD collection. This creates reconciliation gaps, no recourse on disputes, and zero ops visibility once the driver departs. M7 closes this gap by making the Locus driver app the single system of record for all last-mile execution events.

---

## Use Cases

---

### Use Case 1: Trip Execution

---

#### Use Case 1.1: Handover from Dispatcher

**Happy path:**

When the dispatcher hands an order to a driver, the driver opens the Locus app and scans the barcode on the box. Locus calls Truemeds to resolve the barcode to an order_id and confirms acceptance. A successful scan is treated as the driver accepting that order.

If the barcode is torn or otherwise damaged and cannot be scanned, the driver has the option to manually enter the AWB number (i.e., the Order_ID). The AWB number must be available with the dispatcher for reference at all times. Manual entry carries the same weight as a successful scan for order acceptance purposes.

Once all orders in the plan are accepted by the driver — via scan or manual entry — ops enables departure.

**Edge cases:**

1. Barcode scan fails on the driver's app → the driver may manually enter the AWB number directly from the scan failure screen. The dispatcher provides the AWB number if the driver does not have it.
2. Barcode resolution returns an order_id that does not match the expected order for this driver and trip → Locus blocks acceptance and displays an error. Ops is alerted. The physical box is held at the hub for investigation.
3. Driver scans a barcode that belongs to another driver's plan → Locus blocks acceptance, notifies the scanning driver and the dispatcher. Exception: cross-driver order handover from an active trip to another driver is permitted in exigent circumstances at dispatcher discretion and must not be system-blocked.
4. Driver scans the same order barcode twice → Locus deduplicates silently. Second scan has no effect. No duplicate acceptance event is created.
5. Truemeds system is unavailable when Locus calls to resolve the barcode → Locus retries up to 3 times (default: 10 seconds per attempt). If all retries fail, the order enters "Resolution Pending — Truemeds Unavailable" state. Ops is alerted. The order is not counted as accepted until resolution succeeds.
6. Driver explicitly refuses to accept a specific order → ops selects an eligible receiving driver and reassigns the order. The refused order is removed from the original driver's plan and the receiving driver's route is recomputed. If no eligible driver exists, the order is moved to the Open queue for the next planning cycle.
7. Ops allows the driver to depart before all orders are scanned → all unaccepted orders must be moved to the Open queue before the Trip Start button is enabled. Locus surfaces the count of unaccepted orders on the dispatcher dashboard before enabling departure. **This practice is prohibited on-ground.** Ops must be trained to never permit departure before all orders are scanned. Locus must surface a clear warning and require explicit dispatcher acknowledgement before enabling any departure override.

---

#### Use Case 1.2: Trip Start Flow & Order List on App

**Happy path:**

After all orders in the plan are accepted via barcode scan or manual AWB entry, each accepted order is reflected in the driver's app in the planned sequence — regardless of the scan sequence at handover. When the driver taps "Trip Start", the trip is officially recorded as started in Locus. The driver can then begin navigation to the first stop.

**Edge cases:**

1. An accepted order fails to reflect in the driver's app after a successful scan → the order must be moved to another plan or trip before Trip Start is enabled. A complete block on trip start is not acceptable — the affected order must be extracted and handled separately via reassignment or moved to Open state. Ops is alerted to resolve.
2. The order sequence displayed in the app diverges from the plan sequence → Trip Start is permitted but an alert fires immediately. Locus must be escalated offline for resolution. The discrepancy is logged against the trip_id.
3. The Trip Start button must remain disabled until all orders in the plan are accepted and reflected in the app. If the driver has rejected orders, those orders must be removed from the plan and reassigned to another driver or moved to Open state before the button is enabled.
4. All unaccepted orders must be removed from the plan before Trip Start is enabled. The dispatcher confirms this action explicitly on the dashboard.
5. When the driver taps Trip Start but is outside the hub's geofence → the app displays a warning: "You appear to be outside the hub. Please confirm your location before starting." The driver may proceed after acknowledging, but the out-of-geofence event is logged for ops review.
6. Trip Start is tapped but Locus fails to record the event (server error) → the app displays an error and prompts the driver to retry. The trip is not considered started until Locus confirms the event.
7. Driver's GPS is off or permissions are denied when Trip Start is tapped → the app prompts the driver to enable location services before proceeding. Trip Start is blocked until location is available.

---

#### Use Case 1.3: Navigation to Customer's Location

**Happy path:**

When the driver opens the order list on the app, all orders are visible in the current planned sequence. To navigate to any specific order, the driver must first explicitly move that order to the first position in the sequence. The Navigate action is enabled only for the order currently at position one. Once the order is at position one, the driver taps "Navigate" to open Google Maps directed to the customer's resolved delivery location, or taps "Call Customer" to open the dialler with the customer's number pre-filled.

**Edge cases:**

1. The order list fails to load on the driver's app → Locus must treat this as a P0 issue and step in for immediate resolution. The driver must not attempt navigation or delivery until the order list is available.
2. The Navigate action is enabled for an order that is not at position one in the sequence → Locus must block this. Only the order at the first position may have navigation enabled.
3. Call Customer action fails to open the dialler → the customer's location and contact number must be available on the Locus dispatcher dashboard in unmasked format at all times so that ops can relay the number directly to the driver.
4. Navigate action fails to open Google Maps → the driver must contact ops. The dispatcher has the customer's address and contact in unmasked format and can assist the driver in reaching the delivery location.
5. Navigate action opens Google Maps but routes to a location that differs from Locus's resolved delivery coordinates → the driver has no independent means to know the correct location. The driver must coordinate with the customer and the ops team to reach the right address. Orders where the navigation coordinates are incorrect must be flagged to Locus for immediate resolution.
6. Customer does not answer the call → the driver waits at the customer's location for the configurable hold time (default: 5 minutes). The driver selects "Customer Unavailable" from the reason list and initiates the reschedule flow directly from the app (see UC 1.4). The rescheduled order is removed from the active sequence and does not block Trip Completion.
7. While the driver is navigating to a stop, a real-time sequence update is pushed (emergency injection or dispatcher resequence) → the driver's app displays an in-app notification: "Your route has been updated. Tap to view the new sequence." Navigation to the current stop continues uninterrupted. The updated sequence takes effect when the driver completes the current delivery and moves to the next stop.

---

#### Use Case 1.4: Reordering and Rescheduling Orders

**Happy path — Flow 1: Delivery sequence reordering:**

When the driver opens the order list on the app, they can select an order and drag it to a new position in the queue. Before persisting the change, Locus prompts the driver to select a resequencing reason from a pre-configured list. On selection, the order is moved to the new position. All resequencing events are logged with driver ID, timestamp, original position, new position, and reason, and are surfaced on the ops monitoring dashboard in real time.

**Happy path — Flow 2: Rescheduling an order:**

When the driver opens the order list and taps the Edit icon on an order, the driver is presented with a single option: **Reschedule Delivery**. The driver selects a mandatory reason from the pre-configured list. Selecting Reschedule Delivery automatically triggers the NDR (Non-Delivery Report) flow as currently defined by Truemeds.

- The order is removed from the active delivery sequence. An alert is sent to the dispatcher.
- The rescheduled order enters **Open** state and is eligible for re-dispatch in the next planning cycle.
- The rescheduled order does not block Trip Completion for the current driver.
- Once an order has undergone **3 reschedule attempts**, Truemeds automatically sends a cancellation event to Locus. Cancelled orders follow the RTO (Return to Origin) flow as currently defined.

**Payment method on rescheduling:**

The payment method for an order is fixed at the time of order creation and does not change on rescheduling. The one exception is:

- If an order is created as Prepaid but the customer has not completed payment by the time the order is dispatched, and the customer completes payment while the order is in transit → the payment method remains Prepaid.
- If the customer has still not completed payment by the time the driver marks "Arrived" at the customer's location → the payment method automatically changes to COD for that delivery. The customer must then pay via the COD collection flow (digital QR or cash).

For COD orders, the payment method remains COD regardless of rescheduling or re-dispatch.

**Edge cases:**

1. Driver is unable to select the order to drag it to a new position → ops is alerted. The dispatcher can manually override the sequence from the Locus dashboard.
2. Locus fails to load the list of resequencing or rescheduling reasons → ops must manually select the applicable reason from the dispatcher dashboard and move the order to Open state.
3. Driver attempts to submit the resequence without selecting a reason → Locus blocks the action and prompts reason selection.
4. Order resequencing fails to persist → the order returns to its original position. The app displays an error and the driver must retry or contact ops.
5. Ops is unable to view resequencing activities on the monitoring dashboard → Tech is alerted.
6. Driver is unable to tap the Edit icon → ops is alerted. The dispatcher manages the order from the Locus dashboard as a fallback.
7. Order is rescheduled without the driver selecting a reason → Locus must block this action. Reason selection is mandatory before rescheduling is persisted.
8. Driver marks Reschedule Delivery while outside the delivery location's geofence → the app displays a warning: "You appear to be outside the delivery location. Please confirm you are at the customer's address." The driver may proceed after acknowledging; the out-of-geofence event is logged.
9. Order rescheduling fails to persist → the order remains in the active sequence. The app displays an error and the driver must retry or contact ops.
10. Alert to dispatcher on order rescheduling fails to fire → Tech is alerted. Ops must check the unresolved orders queue manually.
11. Order fails to transition to Open state after rescheduling → Tech is alerted. The order must not remain in the active delivery sequence in an ambiguous state.
12. Driver attempts to resequence the order they are currently navigating to → Locus permits the drag but the change does not take effect until the driver completes the current delivery. The resequencing reason is still required.

---

#### Use Case 1.5: Proof of Delivery

**POD method assignment:**

Each order is assigned exactly one POD method: barcode scan or OTP. Both methods cannot be active simultaneously for the same order. The POD method is configurable by ops at the hub level.

For either method, if the driver is unable to complete the POD after repeated failures, the fallback is a **skip option**. All skip events must be recorded and regularly audited by ops.

**Happy path — Flow 1: Barcode scan handover:**

When the driver reaches the customer's location and the customer is present, the driver opens the active order on the app and scans the barcode on the parcel. Locus records this as a confirmed handover event. The delivery is logged as complete.

**Happy path — Flow 2: OTP-based handover:**

When the driver completes a prior delivery (or when the trip starts, depending on ops configuration), Locus generates an OTP and passes it to Truemeds. Truemeds delivers the OTP to the customer via SMS or WhatsApp (channel selected at implementation). When the driver reaches the customer's location, the customer shares the OTP verbally. The driver inputs the OTP in the app. Locus validates the OTP and logs the delivery as complete.

**Edge cases:**

1. Barcode scan fails after 3 consecutive attempts → the driver is presented with a skip option. The skip event is recorded and flagged for ops audit. If the skip option itself fails, the dispatcher manually marks the order as delivered once the driver reaches out. The same 3-failure → skip → dispatcher marks flow applies to OTP-based handovers.
2. Locus incorrectly identifies the order based on the scanned barcode → Locus must block the handover and surface the mismatch. The driver must not mark the order as delivered until the correct barcode is scanned.
3. OTP generation fails → the driver and dispatcher are alerted. The driver must hold the parcel and wait for ops to resolve.
4. Generated OTP is not received by Truemeds systems → the driver delivers the parcel to the customer. The driver highlights the failure to the dispatcher. The dispatcher manually moves the order status to reflect delivery from the Locus dashboard.
5. Truemeds is unable to pass the OTP to the customer (SMS or WhatsApp failure) → the driver highlights the failure to the dispatcher. The dispatcher manually moves the order status to reflect delivery from the Locus dashboard. The customer is not contacted separately to relay the OTP.
6. Driver inputs a wrong OTP, or customer shares a wrong OTP → the driver and dispatcher must coordinate. The OTP is visible to ops on the dispatcher dashboard so that the correct OTP can be verified against what the driver is entering. If coordination fails, ops manually moves the order along.
7. Handover logging fails after a successful scan or OTP input → the delivery event is not recorded. Tech is alerted. The order must not be shown as delivered in Truemeds until the event is re-logged.
8. OTP or barcode scan is attempted outside the delivery location's geofence → the app displays a warning: "You appear to be outside the delivery location. Confirm you are at the customer's address before completing handover." The warning is logged. The driver may proceed after acknowledgement, but the out-of-geofence event is flagged for ops review. The system does not hard-block the handover.
9. Customer is absent at the delivery location → the driver waits for the configurable hold time (default: 5 minutes), attempts to call the customer, and if unreachable selects "Customer Unavailable" from the reason list. The driver initiates the reschedule flow directly (see UC 1.4). The order does not block Trip Completion.

---

#### Use Case 1.6: COD Collection

**Pre-requisite:**

Locus maintains an active integration with Truemeds' payment vendors. Initially, Locus is expected to have integrations with Cashfree, Juspay, Razorpay, PayU, and PineLabs and to orchestrate payment collection across all Truemeds accounts on these gateways as required.

**Happy path:**

After the driver completes the handover procedure (barcode scan or OTP), Locus calls Truemeds to determine the payment method and gateway for that order.

- **Prepaid (payment confirmed):** the driver marks the order delivered and proceeds to the next stop.
- **Prepaid (payment not yet confirmed at dispatch, customer pays in transit):** the payment method remains Prepaid. The driver marks the order delivered and proceeds.
- **Prepaid (customer has not paid by the time the driver marks "Arrived" at the delivery location):** the payment method automatically changes to COD for this delivery. Locus generates a dynamic QR code. The customer must pay before the order can be marked delivered — either by scanning the QR code digitally or by paying cash to the driver.
- **COD:** Locus generates a dynamic QR code for that order. The customer may either scan the QR code to pay digitally, or hand over cash to the driver.
  - If paid by QR code: the driver's app transitions to a payment success state. Locus sends a payment success event to Truemeds. Truemeds runs reconciliation against the received payment.
  - If paid by cash: the driver marks the order delivered. Cash is recorded against the order for hub reconciliation at trip completion.

**Cash reconciliation at trip completion:** When the driver marks the trip complete at the hub, the driver hands over all collected cash to the hub ops agent. The hub ops agent reconciles cash received against the Locus-recorded COD order list for that trip. Any discrepancy is flagged to the dispatcher and logged in Truemeds.

**Edge cases:**

1. Locus does not have Truemeds' payment gateway partners integrated → Locus accepts a dynamic order-level QR code generated by Truemeds. Locus displays the QR code on the driver app. The payment collection flow proceeds as in the happy path.
2. Locus fails to fetch payment method and status from Truemeds → the driver is prompted to hold and retry. If the failure persists after two retries, the dispatcher is alerted. The driver must not proceed with delivery until payment method is confirmed.
3. Locus fails to generate the dynamic QR code → the driver is prompted to retry. If QR generation fails after two retries, the driver must collect cash as the fallback. The failure event is logged and Tech is alerted.
4. Payment gateway timeout or failure → Locus retries the payment call up to 3 times with exponential backoff. If all retries fail, the driver is prompted to collect cash. The payment failure event is logged and Tech is alerted.
5. Locus fails to send the payment success event to Truemeds → Locus retries up to 3 times. If all retries fail, the event is queued for asynchronous delivery. Tech is alerted. Truemeds reconciliation flags the order for manual review.
6. Customer refuses to pay COD (neither cash nor QR) → the driver selects "Customer Refused Payment" from the reason list. The order enters "Parked" state and the parcel is returned to the hub. Locus must ensure the reason for the order entering Parked state is clearly visible to the dispatcher. Ops contacts the customer. The order is not marked delivered.
7. Customer offers to pay only a partial cash amount → the driver must not accept partial payment. The driver selects "Partial Payment Offered — Refused" from the reason list. The order enters "Parked" state. Locus must ensure the reason is visible to the dispatcher. Ops contacts the customer to resolve.

---

#### Use Case 1.7: Trip Completion Flow

**Happy path:**

After completing all deliveries, the driver begins the return journey to the hub. On arrival at the hub, the driver taps "Mark Trip Complete" on the app. The trip is recorded as complete in Locus. Cash handover reconciliation is performed with the hub ops agent (see UC 1.6 cash reconciliation).

**Edge cases:**

1. Driver taps "Mark Trip Complete" while outside the hub's geofence → the app displays a warning: "You appear to be outside the hub. Confirm your location before completing the trip." The driver may proceed after acknowledgement, but the out-of-geofence event is logged for ops review.
2. Driver attempts to mark trip complete while one or more orders are in a non-terminal state (not delivered, not rescheduled, not parked, not cancelled) → Locus must block trip completion. The app displays a list of unresolved orders. The driver must resolve each order before trip completion is permitted.
3. App functionality of marking trip complete fails (server error) → the app displays an error and prompts retry. If the failure persists, the dispatcher reviews and resolves the trip state from the Locus dashboard.
4. Driver's phone dies mid-trip → on restart and re-login, the app restores the last confirmed trip state from Locus. Orders already marked as delivered retain their status. The driver resumes from the last unresolved order. No delivered orders are re-queued.
5. Driver has a vehicle breakdown or other emergency mid-trip with pending orders → the driver contacts the dispatcher and requests emergency trip exit. The dispatcher identifies an eligible receiving driver. All pending orders are moved to the receiving driver's plan and the receiving driver's route is recomputed. The original driver marks trip complete with explicit dispatcher approval. If no eligible receiving driver exists at the time of emergency exit, all pending orders are moved to Open state and re-enter the planning queue for the next cycle.
6. Receiving driver is unwilling or unable to deliver some of the transferred orders → the receiving driver can mark trip complete for those undelivered orders with explicit dispatcher approval. The undelivered orders return to Open state and re-enter the planning queue for the next cycle.

---

#### Use Case 1.8: On-Trip Driver Tracking

**Happy path:**

When a trip is in an active state, the driver's real-time location is visible to ops on the Locus dispatcher dashboard. The ops agent can see: current driver location, the planned route, the next stop in sequence, and the estimated arrival time at each remaining stop. Location is updated at a configurable frequency (default: every 30 seconds).

**Edge cases:**

1. Driver's location has not updated for more than 5 minutes while the trip is active → the dispatcher dashboard flags the driver as "Location Stale." The dispatcher is prompted to call the driver to confirm status. This event is logged as a Location Gap against the trip.
2. Driver's app is sent to the background (phone locked, switched to another app) for more than 2 minutes while the trip is active → Locus attempts to maintain background location tracking. If background tracking is unavailable (OS-level restriction), the location is recorded as unavailable for that interval. The dispatcher is notified of the gap.
3. Driver's location deviates significantly from the planned route (more than a configurable threshold, default: 500 metres) for more than 3 minutes → the dispatcher dashboard flags a "Route Deviation" event. The dispatcher is prompted to review and optionally call the driver.
4. Driver revokes location permissions mid-trip → the app prompts the driver to re-enable location permissions. The driver is blocked from performing any further actions on the Locus application — including marking orders delivered, rescheduling, or completing the trip — until GPS access is restored.
5. The driver's phone number is accessible to the dispatcher from the driver tracking view. The dispatcher must manually dial the number using their own device.

---

### Use Case 2: Viewing Earnings & Incentives

**Happy path:**

When the driver opens the Earnings section of the app, they can view their earnings for the current day and for the past 6 months. The earnings breakdown shows: base earnings (Fixed Income + Rs. per Km × actual distance), incentive line items (attendance, route, order-level, holiday), and total payout for each day. Earnings for the current day are finalised at the end of the day and updated in the app within 30 minutes. Past earnings are read-only.

**Edge cases:**

1. Earnings for the current day are not updated within 30 minutes of day end → the driver sees a "Pending Calculation" label. If earnings remain uncalculated for more than 2 hours after day end, Tech is alerted.
2. Earnings display fails to load → the app prompts retry. If the failure persists, the driver must contact ops for manual confirmation of earnings. The underlying data is available in Redshift regardless of display failures.
3. Driver believes an earnings entry is incorrect → the driver can tap a "Report Issue" button on any earnings line item. The issue is logged against the driver_id, date, and line_item type and surfaced to ops for manual review. The driver receives an in-app confirmation that the issue has been reported. Resolution is managed outside the app.
4. An incentive the driver expects to see is not reflected in earnings → the driver must use the "Report Issue" flow. Incentive eligibility is determined by Locus based on configurations set in M4 (Payout Manager). Disputes are resolved by ops cross-referencing the M4 incentive config.

---

### Use Case 3: App Login Experience

**Happy path — Login:**

When the driver installs the Locus app and opens it, the driver inputs their registered mobile number. Locus sends an OTP to that number via SMS. The driver logs in via OTP. On successful login, the driver lands on the home screen showing their assigned plans and orders.

**Edge cases:**

1. Driver app installation fails → the case must be escalated to Locus for immediate resolution.
2. Driver inputs a wrong phone number → OTP is sent to the wrong number. The driver must re-enter their correct number and request a new OTP.
3. Driver inputs an invalid phone number format (not 10 digits) → Locus displays a format validation error before sending the OTP.
4. Locus fails to generate the OTP → the driver is prompted to retry. If OTP generation fails after two retries, the case is escalated to Locus for resolution.
5. Locus fails to deliver the OTP to the driver's number (SMS failure) → the driver is prompted to retry. If delivery fails after two retries, Locus must step in for resolution. There is no manual access provision pathway.
6. Driver login after OTP submission fails → the driver is prompted to retry. If login fails persistently, Tech is alerted.

---

### Use Case 4: Suspended Driver Experience

**Happy path:**

When a driver is suspended, the driver opens the app and is able to view their earnings and incentives history (read-only). The app displays a suspension banner with the reason for suspension as recorded in the Driver Module. All order-acceptance and scanning actions are disabled. The driver is not included in any planning roster while suspended. When the driver is unsuspended, the suspension banner is removed, order-acceptance and scanning actions are re-enabled, and the driver becomes eligible for planning from the next planning cycle.

**Edge cases:**

1. Driver is unable to see the full app after suspension (app becomes entirely inaccessible) → this is incorrect behaviour. Suspended drivers must retain read-only access to earnings. Tech is alerted.
2. Suspended driver is still able to accept orders or is included in planning → this is a P0 integrity failure. Tech is alerted immediately and the affected plan must be reviewed.
3. Driver is unsuspended but remains unable to accept orders or is still excluded from planning → Tech is alerted. Ops manually verifies the driver status in the Driver Module and forces a resync if needed.
4. Driver is mid-trip when the suspension is applied → the suspension takes effect at the next trip boundary. Active trips are not interrupted. Locus surfaces a banner to the driver indicating that their account is pending a status change effective after the current trip. Ops ensures the driver completes the trip and returns to the hub before the suspension is enforced.
5. The reason for suspension is not displayed on the driver's app → Tech is alerted. Ops communicates the reason to the driver through an external channel as a fallback.

---

### Use Case 5: Terminated Driver Experience

**Happy path:**

When a driver is terminated, the driver is automatically signed out of the Locus app on their next app interaction. The driver cannot log back in. The app displays: "Your account has been deactivated. Please contact your fleet manager." The driver retains read-only access to their historical earnings for a 90-day window after termination, accessible via a separate earnings access link provided by ops.

**Edge cases:**

1. Driver is mid-trip when termination is applied → termination takes effect after trip completion. The active trip is not interrupted. Locus notifies ops to ensure the driver completes the trip, returns to the hub, and hands over all undelivered parcels and collected cash before termination is enforced. Ops receives an alert: "Driver [name] — termination pending. Active trip in progress."
2. Termination does not take effect on the driver's app at the next interaction → Tech is alerted. Until termination propagates, the driver's access must be manually revoked from the Locus admin dashboard as an immediate override.
3. Driver has undelivered orders when termination is enforced → all undelivered orders in the driver's plan are surfaced as Stranded Orders on the dispatcher dashboard. Ops must reassign them before the next dispatch cycle.
4. Driver has cash collected from COD orders when termination is enforced → ops ensures cash reconciliation is completed at the hub before the driver departs. A manual reconciliation record is created and logged against the driver_id and trip_id.
5. Terminated driver attempts to access earnings history after the 90-day window → access is removed. The driver must contact ops if earnings records are needed beyond this window.

---

### Use Case 6: Connectivity Loss & Offline Behaviour

**Happy path:**

The driver app maintains a local state cache for the active trip. When connectivity is lost mid-trip, the driver can continue to view the order list and their current sequence. Scan events, delivery markings, and POD actions are queued locally and synced to Locus automatically when connectivity is restored. The driver receives an in-app indicator when offline. All locally queued events are timestamped at the time of the action, not at the time of sync.

**Edge cases:**

1. Connectivity is lost while a scan or delivery event is being submitted → the event is queued locally. The app confirms to the driver that the action has been captured and will sync when connectivity is restored. The driver proceeds normally.
2. Connectivity is restored and local event queue fails to sync → Tech is alerted. Ops must manually resolve the state discrepancy from the Locus dashboard before the trip can be closed.
3. Driver attempts to generate a COD QR code while offline → QR generation requires a live Locus call and cannot function offline. The driver is prompted to collect cash instead. The fallback is logged.
4. Driver is offline for the entire duration of a delivery and marks it complete locally → the event syncs on connectivity restoration. If the order is already in a terminal state in Locus (e.g., cancelled while the driver was offline), a conflict is surfaced to the dispatcher for resolution.
5. Navigation (Google Maps) is unavailable offline → this is a Google Maps limitation. The driver must use the last cached route or contact the customer for directions.

---

### Use Case 7: App Crash Recovery

**Happy path:**

When the driver's app crashes mid-trip and the driver relaunches it, the app restores the last confirmed trip state from Locus on reconnection. The driver lands on the current active order in the sequence. Orders already marked as delivered retain their delivered status. No delivered orders are re-queued.

**Edge cases:**

1. App crash occurs during a scan event → the scan event may or may not have been recorded by Locus. On relaunch, the app checks Locus for the current state of the order. If the scan was recorded, the order is shown as accepted/delivered. If not, the driver must rescan.
2. App crash occurs during a COD payment flow → on relaunch, the app queries Locus for the payment status of the order. If payment was confirmed by the gateway, the order is shown as paid. If payment was not confirmed, the driver must restart the payment flow.
3. App state after crash does not match Locus's server state → the server state is authoritative. The app adopts the server state on relaunch. Any discrepancy is logged for Tech review.
4. App crashes repeatedly (three or more crashes within a single trip) → Tech is alerted. The dispatcher is notified. Ops may need to manually advance the trip state from the Locus dashboard if the driver cannot use the app.

---

## Metrics

| Metric | Definition | Baseline | Target | Timeframe |
|---|---|---|---|---|
| POD Capture Rate | % of delivered orders with a scan or OTP event recorded before "Mark Delivered" | Unknown — to be established at Stage 2 | ≥ 95% | Stage 2 exit |
| Login Compliance Rate | % of login events where driver location = warehouse geofence | Unknown | ≥ 90% | Stage 3a |
| Arrived Compliance Rate | % of "Arrived" events marked within customer delivery location geofence | Unknown | ≥ 85% | Stage 3a |
| Scan Compliance Rate | % of delivery scans where GPS = planned delivery location | Unknown | ≥ 85% | Stage 3a |
| Driver Re-prioritisation Rate | % of trips where driver manually resequences at least one stop | Unknown — directional goal: minimise | < 15% | Stage 3a |
| COD Collection Success Rate | % of COD orders where payment is collected digitally (QR) vs cash | Unknown | Directional: increase digital % over time | Stage 4 |
| Skip Rate | % of POD events completed via skip (barcode or OTP method) | Unknown — directional goal: minimise | < 5% | Stage 2 exit |

---

## Rollout & Stage Gates

| Stage | Entry Criteria | Success Criteria | Action on Failure |
|---|---|---|---|
| Stage 1 — Sanity | M6 Planning Engine stable. 1 driver, 1 trip, test orders only | Driver completes end-to-end trip on app. All events logged in Locus with no data gaps. POD captured | Fix event logging gaps before proceeding |
| Stage 2 — Minimal Rollout | Stage 1 passed. 1 zone, 1 warehouse, 1 driver | POD Capture Rate ≥ 95%. Login and Arrived Compliance within acceptable range. No P0 app failures. Ops sign-off on driver behaviour | Do not expand zones until Stage 2 criteria met for 3 consecutive days |
| Stage 3a — Phased Non-DC Expansion | Stage 2 passed. Ops training complete per zone | Guardrail metrics stable for 3 days post each zone activation. No regression in POD Capture Rate | Roll back affected zone to manual process. Investigate before re-expansion |
| Stage 3b — DC Expansion | All non-DC zones on Locus app. Stage 3a guardrails stable | All DC zones live. Mid-mile trip events logging correctly | Pause DC expansion. Fix mid-mile event logging before proceeding |
| Stage 4 — Full Rollout | Stage 3b passed | 100% of hyperlocal forward orders on Locus driver app. Reverse flow live | — |
