# Milestones

Each milestone is a complete slice that can run in production. A card that is not built in a milestone is either handled manually, handled with a system-assisted workaround, or not needed yet, and every manual or assisted card has an owner. How each card is handled in each milestone is recorded on the card in [story-map.md](story-map.md).

## Overview

- **M1 · Pilot.** One DC and its warehouse run Forward orders end to end, via a DC and directly from the warehouse, including failed deliveries and cash. Workarounds cover what is not built yet.
- **M2 · Complete the loop.** Returns, cash reconciliation, serviceability and driver management move into the system.
- **M3 · Pay and support.** Driver pay, incentives, vendor payouts, tickets and Customer tracking move into the system.
- **M4 · Scale.** Capacity planning, monitoring, reporting and vehicle tracking.

## M1. Pilot

One DC and its warehouse run Forward orders end to end, via a DC and directly from the warehouse, including failed deliveries and cash. Workarounds cover what is not built yet.

Built 22 · System-assisted 11 · Manual 28 · Not needed 4

**Built**

- *Ready the drivers:* Onboards a driver; Starts the shift
- *Receive and prepare the order:* Receives the order and creates the shipment; Generates the AWB and decides the path; Prints the AWB; Hands the shipments to the Dispatcher
- *Dispatch via a DC:* Sorts shipments by destination DC; Builds the consignment; Records the vendor, vehicle and driver; Loads the consignment and scans the handover
- *Receive and sort at the DC:* Receives and unloads the consignment; Sorts each shipment into its bin
- *Pick up the batch:* Views the batch and picks the orders from the bin; Scans the orders the driver brings
- *Deliver:* Follows the route to the Customer; Receives the order and confirms; Collects proof of delivery; Pays for the order; Ends the shift
- *Reconcile the cash:* Hands cash in; Records and banks the cash
- *When a delivery fails:* Marks the delivery failed

**Workarounds**

| Card | Handling | Owner | Built in |
|---|---|---|---|
| Creates the locations | System-assisted | Central Logistics Ops | M2 |
| Defines the rules the system runs on | System-assisted | Central Logistics Ops | M3 |
| Defines driver pay and incentives | Manual | Central Logistics Ops | M3 |
| Sets up users and their access | System-assisted | Central Logistics Ops / Team Lead | M2 |
| Onboards vendors | System-assisted | Team Lead | M2 |
| Sets the driver's serviceability | System-assisted | DC Executive / Dispatcher | M2 |
| Agrees the driver's pay structure | Manual | DC Executive / Dispatcher / Team Lead / Central Logistics Ops | M3 |
| Looks after the driver | Manual | Team Lead | M2 |
| Keeps enough drivers on shift | Manual | Team Lead | M3 |
| Adds gel packs where needed | Manual | Dispatcher | M2 |
| Plan the trip together | Manual | Dispatcher / Team Lead | M3 |
| Drives the consignment to the DC | Manual | Mid-Mile Driver | M4 |
| Creates batches and routes and allocates drivers | System-assisted | System | M2 |
| Tracks the order | System-assisted | Customer | M3 |
| Matches and approves the cash | System-assisted | Finance | M2 |
| Decides between a reattempt and an RTO | Manual | System | M3 |
| Replans the delivery for the next day | Manual | DC Executive / Dispatcher | M2 |
| Schedules the return | Manual | Dispatcher | M2 |
| Requests a return | Manual | Customer | M3 |
| Schedules the pickup | Manual | Dispatcher | M2 |
| Collects the return | Manual | Last Mile Driver | M2 |
| Receives the returns and sends them on | Manual | DC Executive | M2 |
| Drives the consignment to the warehouse | Manual | Mid-Mile Driver | M4 |
| Receives the returned consignment and hands it over | Manual | Dispatcher | M2 |
| Receives the returned parcel | Manual | WH Ops | M2 |
| Computes earnings and tracks incentive progress | Manual | System | M3 |
| Grants incentives to drivers | Manual | Team Lead | M3 |
| Rolls driver earnings up per vendor | Manual | System | M3 |
| Calculates what each vendor is owed | Manual | Finance | M3 |
| Pays the vendor | Manual | Finance | M3 |
| Asks for help on the road | Manual | Last Mile Driver | M3 |
| Raises a payout dispute | Manual | Last Mile Driver | M3 |
| Settles the dispute | Manual | DC Executive / Dispatcher / Team Lead | M3 |
| Raises a ticket | Manual | Customer | M3 |
| Resolves the ticket | Manual | Grievance & Escalation Management Team | M3 |
| Watches live deliveries and calls out failures | System-assisted | Control Tower | M4 |
| Reviews performance and fixes problems | System-assisted | Team Lead / Central Logistics Ops | M4 |
| Investigates loss, fraud and anomalies | Manual | Team Lead / Central Logistics Ops | M4 |
| Shares reports and data | System-assisted | Central Logistics Ops | M4 |

**Not needed yet**

- Plans the capacity; Sees earnings and incentive progress; Keeps tickets within their time limits; Fixes the root cause

## M2. Complete the loop

Returns, cash reconciliation, serviceability and driver management move into the system.

Built 37 · System-assisted 5 · Manual 19 · Not needed 4

**Built in this milestone**

- *Set up the network:* Creates the locations; Sets up users and their access; Onboards vendors
- *Ready the drivers:* Sets the driver's serviceability; Looks after the driver
- *Receive and prepare the order:* Adds gel packs where needed
- *Plan the deliveries:* Creates batches and routes and allocates drivers
- *Reconcile the cash:* Matches and approves the cash
- *When a delivery fails:* Replans the delivery for the next day; Schedules the return
- *A Customer returns an order:* Schedules the pickup; Collects the return
- *Bring it back to the warehouse:* Receives the returns and sends them on; Receives the returned consignment and hands it over; Receives the returned parcel

**Workarounds**

| Card | Handling | Owner | Built in |
|---|---|---|---|
| Defines the rules the system runs on | System-assisted | Central Logistics Ops | M3 |
| Defines driver pay and incentives | Manual | Central Logistics Ops | M3 |
| Agrees the driver's pay structure | Manual | DC Executive / Dispatcher / Team Lead / Central Logistics Ops | M3 |
| Keeps enough drivers on shift | Manual | Team Lead | M3 |
| Plan the trip together | Manual | Dispatcher / Team Lead | M3 |
| Drives the consignment to the DC | Manual | Mid-Mile Driver | M4 |
| Tracks the order | System-assisted | Customer | M3 |
| Decides between a reattempt and an RTO | Manual | System | M3 |
| Requests a return | Manual | Customer | M3 |
| Drives the consignment to the warehouse | Manual | Mid-Mile Driver | M4 |
| Computes earnings and tracks incentive progress | Manual | System | M3 |
| Grants incentives to drivers | Manual | Team Lead | M3 |
| Rolls driver earnings up per vendor | Manual | System | M3 |
| Calculates what each vendor is owed | Manual | Finance | M3 |
| Pays the vendor | Manual | Finance | M3 |
| Asks for help on the road | Manual | Last Mile Driver | M3 |
| Raises a payout dispute | Manual | Last Mile Driver | M3 |
| Settles the dispute | Manual | DC Executive / Dispatcher / Team Lead | M3 |
| Raises a ticket | Manual | Customer | M3 |
| Resolves the ticket | Manual | Grievance & Escalation Management Team | M3 |
| Watches live deliveries and calls out failures | System-assisted | Control Tower | M4 |
| Reviews performance and fixes problems | System-assisted | Team Lead / Central Logistics Ops | M4 |
| Investigates loss, fraud and anomalies | Manual | Team Lead / Central Logistics Ops | M4 |
| Shares reports and data | System-assisted | Central Logistics Ops | M4 |

**Not needed yet**

- Plans the capacity; Sees earnings and incentive progress; Keeps tickets within their time limits; Fixes the root cause

## M3. Pay and support

Driver pay, incentives, vendor payouts, tickets and Customer tracking move into the system.

Built 57 · System-assisted 3 · Manual 3 · Not needed 2

**Built in this milestone**

- *Set up the network:* Defines the rules the system runs on; Defines driver pay and incentives
- *Ready the drivers:* Agrees the driver's pay structure; Keeps enough drivers on shift
- *Dispatch via a DC:* Plan the trip together
- *Deliver:* Tracks the order
- *When a delivery fails:* Decides between a reattempt and an RTO
- *A Customer returns an order:* Requests a return
- *Track driver earnings:* Computes earnings and tracks incentive progress; Grants incentives to drivers; Sees earnings and incentive progress
- *Pay the vendors:* Rolls driver earnings up per vendor; Calculates what each vendor is owed; Pays the vendor
- *Support drivers and Customers:* Asks for help on the road; Raises a payout dispute; Settles the dispute; Raises a ticket; Resolves the ticket; Keeps tickets within their time limits

**Workarounds**

| Card | Handling | Owner | Built in |
|---|---|---|---|
| Drives the consignment to the DC | Manual | Mid-Mile Driver | M4 |
| Drives the consignment to the warehouse | Manual | Mid-Mile Driver | M4 |
| Watches live deliveries and calls out failures | System-assisted | Control Tower | M4 |
| Reviews performance and fixes problems | System-assisted | Team Lead / Central Logistics Ops | M4 |
| Investigates loss, fraud and anomalies | Manual | Team Lead / Central Logistics Ops | M4 |
| Shares reports and data | System-assisted | Central Logistics Ops | M4 |

**Not needed yet**

- Plans the capacity; Fixes the root cause

## M4. Scale

Capacity planning, monitoring, reporting and vehicle tracking.

Built 65 · System-assisted 0 · Manual 0 · Not needed 0

**Built in this milestone**

- *Ready the drivers:* Plans the capacity
- *Move it:* Drives the consignment to the DC
- *Bring it back to the warehouse:* Drives the consignment to the warehouse
- *Support drivers and Customers:* Fixes the root cause
- *Watch and improve:* Watches live deliveries and calls out failures; Reviews performance and fixes problems; Investigates loss, fraud and anomalies; Shares reports and data

**Workarounds**

- None

**Not needed yet**

- None
