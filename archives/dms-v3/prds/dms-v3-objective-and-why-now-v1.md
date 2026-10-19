# DMS v3 — Objective and Why Now

**Status:** Under Review
**Author:** Tejas Bhalerao
**Version:** v1
**Scope of this draft:** Objective, Why Now and Milestones. Other sections are not yet written.

---

## Objective

Give Ops systematic visibility and control over the hyperlocal delivery leg, from the warehouse through DCs and hubs to the customer's door, so that the network can scale from 20 to 70 DCs without depending on tribal knowledge, manual coordination, or proxy signals.

## Why Now?

### Hyperlocal is the growth push, and the network behind it is about to multiply

The organisation is pushing hyperlocal hard. It will expand serviceable pincodes through the hub-and-spoke model, where deliveries run through DCs. Hyperlocal's share of deliveries is expected to rise from 30% to 40% while order volumes also grow. We run 20 DCs today, and we expect 35 by October 2026 and 70 by January 2027. Shipsy order share is expected to move from 25% to 35% between September 2026 and March 2027.

The push rests on two premises:

- **Conversion:** hyperlocal converts about 4pp higher than non-hyperlocal.
- **Control:** delivery executives are contracted and work under dispatchers, so we can manage the promise and the delivery experience far more tightly than in the non-hyperlocal model.

### The control premise does not hold today

Control needs visibility into the delivery leg, and we do not have it. Today:

- Dispatchers sort orders manually from their knowledge of pincode proximity, which leads to inefficient batching.
- Delivery executives call customers to get exact addresses.
- Delivery executives plan their own routes and sequences from knowledge of the ground.
- Payouts, attendance, shifts, and incentives are tracked manually.
- Nothing is monitored once an order leaves the warehouse. Operations run blind.
- There are no handover validation layers, so we judge delivery experience from proxy signals.

The network itself is also run from memory. Which DC feeds which warehouse, which zone a hub serves, and where a box goes next live in people's heads and in spreadsheets. When the executives who hold that knowledge leave, their replacements relearn it from scratch, repeat the same mistakes, and work slower.

### Why this cannot wait

Each of these gaps is tolerable at 20 DCs with short, well-known routes. Each gets more expensive as DCs, routes, and volume multiply, and together they erase the control advantage that justifies the hyperlocal push. The manual-error cost of the expanded network is locked in the day it goes live, and fixing it after volume has ramped costs more than building before.

The foundations are being laid already. Mid-Mile Entity Introduction makes Zones and DCs governed entities with resolvable paths, and the AWB Sort Identifier Code puts that resolution on the physical box. DMS is the layer that has to run delivery operations on top of them, and it needs to be ready before the expanded network goes live.

---

## Milestones

DMS v3 covers the 16 initiatives in the DC Expansion Plan that DMS powers. Each initiative is its own milestone, because an initiative is the smallest unit that ships and delivers value on its own. Each milestone is an Executable PRD in itself, and each one assigns its own systems and verticals.

| # | Milestone | What it delivers | Needs |
|---|---|---|---|
| M1 | Driver Onboarding Module | Collect driver details and set the driver as mid-mile or last-mile | Mid-Mile Entity |
| M2 | Driver Earnings Module | Define earnings structures and tag each driver to one | M1 |
| M3 | Driver Serviceability Module | Set up hubs and delivery zones, tag drivers to them, and blacklist pincodes per driver | M1, Mid-Mile Entity |
| M4 | Driver Availability Tracker | Drivers mark arrival at the hub, which records attendance | M1 |
| M5 | Serviceability Based Vanilla Driver Allocation | Group open orders by delivery zone and allocate each batch to an available, serviceable driver within carrying capacity | M3, M4 |
| M6 | Previous Delivery Location Consumption | Use a customer's previous delivery locations as the address input | None |
| M7 | Route Optimisation Module | Sequence the drops in a batch from resolved lat-longs, with priority orders ranked first, and assign the route to the driver | M5, M6 |
| M8 | Navigation Module | Driver accepts the trip, sees orders in sequence and navigates to each | M7 |
| M9 | Proof of Delivery | Capture proof at handover and update order status | M8 |
| M10 | Driver's Rescheduling Initiation | Driver reschedules an order when the customer is unavailable; the order leaves the trip and a reschedule plan is triggered | M8 |
| M11 | Driver Earnings Visibility | Driver sees earnings per trip in the app | M2, M9 |
| M12 | Driver Incentive Module | Define incentive structures and qualification criteria, and assign incentives to drivers | M1 |
| M13 | Driver Incentive Visibility | Driver sees active and past incentives, qualification criteria and progress in the app | M12, M9 |
| M14 | Dynamic QR | Driver collects COD through a QR code | M9 |
| M15 | OTP Based Deliveries | Generate a delivery OTP, send it to the customer, and complete handover when the driver enters it | M9 |
| M16 | Delivery Location Geofence | Enforce driver-initiated reschedules against the driver's location at the delivery address | M6, M10 |

### Sequencing

The order follows the delivery leg. A driver has to exist before they can be allocated (M1 to M5), an allocated driver needs a route (M6 to M8), and a driver on a route needs to complete, reschedule, or get paid for the delivery (M9 onward).

M1, M6 and M12 have no dependency on other DMS milestones beyond M1, so they can start in parallel. M14 already exists as its own project, `dynamic-qr-code`, so that milestone should point to that PRD, not duplicate it.

### Scope notes

- M16 is what enforces the location check on M10. Until M16 ships, M10 runs without it.
- Fixing address quality itself is a separate project and is not part of M6.
- Prerequisites outside DMS, as the plan lists them: Mid-Mile Entity (JAS), Handover Validation, and the AWB Sort Identifier Code.
- The remaining 30 initiatives in the plan are not powered by DMS: reschedule and reattempt journeys, RTO flows, order tracking and ETA communication, and hour-level delivery slots. They are not milestones here.
