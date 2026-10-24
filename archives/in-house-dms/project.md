---
title: In-House DMS
systems: [All existing systems, plus new systems to be created as the project progresses]
verticals: [Hyperlocal Forward, Hyperlocal Reverse]
created: 2026-10-24
---

# In-House DMS

## Background (as told by the PM, 2026-10-24)

**Decision:** Leadership has decided to build the entire rider app and the supporting portals (CRM dashboard etc.) in house, removing the third-party dependency on Shipsy and moving everything internal.

**Why:**
- Shipsy has many more clients and much larger scale than Truemeds. When Truemeds approaches Shipsy, responsiveness, bias to action and resolution are low.
- Leadership's view is that what Shipsy offers is rudimentary and can be built internally.
- Third-party dependency hurts more as Truemeds scales. Serving locations (FCs, MFCs, DCs) are planned to grow from 39 to 150 in the next 15 months.
- Over the same 15 months, the share of orders on Shipsy is projected to grow from 30% to above 50%, from both organic order growth and the inorganic growth that follows from the expansion.

- Leadership also sees that the non-rudimentary parts of Shipsy are promises that may not be delivered. Integrating and getting them running, then finding them useless, is wasted effort. Building 0 to 1 may take longer but has a higher chance of getting it right.

**Scope:** Rider app plus supporting portals, built in house. All systems are affected and new systems will be created as the project progresses.

**Framing:** This is a completely new 0 to 1 journey. No other existing context needs to be considered or carried in.

**What Shipsy handles today (the parity baseline):**
- Rider creation
- Rider allocation to orders
- Rider execution flow via the app
- Tracking and reporting via the Shipsy portal

**Migration approach:** Build a parity version, then cut over location by location.

## Actors (step 1, updated by the PM, 2026-10-24)

Actors that exist today, irrespective of location:
1. Last Mile Driver
2. Mid-Mile Driver
3. DC Executive
4. Dispatcher
5. Team Lead
6. Finance
7. Central Logistics Ops
8. Grievance & Escalation Management Team
9. Customer
10. System (automated actor: acts without a human triggering it; added 2026-10-24)
11. WH Ops (added 2026-10-24; appeared in the PM's flow board legend; likely owns Pick & Pack and AWB Print)

Clarifications:
- Hyperlocal Reverse uses the same actors as Forward.
- Driver onboarding and lifecycle is handled by the Dispatcher and the DC Executive.
- Admin (system configuration) is handled by Central Logistics Ops and the Team Lead.

Actions per actor: pending (PM drafting, five columns: Actor, Action, Trigger, Output, Vertical).

## Entities (as finalised by the PM, 2026-10-24)

1. Order
2. Shipment
3. Barcode (renamed from Scanning Barcode)
4. Sorting Bin
5. Manifest
6. Consignment
7. Serving Location
8. Serviced Location
9. Vehicle
10. Device
11. People
12. Money
13. Ticket (added 2026-10-24)

Note: AWB was dropped on purpose; Shipment carries the AWB.
Open: whether Barcode stays a separate entity (Shipment and Consignment ideally carry different barcodes).

## Scope boundaries (PM, 2026-10-24)
- The system stops at delivering returned orders back to the warehouse (failed-delivery returns and customer returns). Nothing after the warehouse receive is in scope.
- Refunds are out of scope.
- Central Logistics Ops (whole country) owns geography setup (cities and locations). A Team Lead handles one city.

## Jobs to be done per actor (step 2, draft v2, 2026-10-24)

Dispatcher has two flows: (1) send orders to a DC for last-mile delivery (warehouse to DC via Mid-Mile, then DC to Customer); (2) send orders directly from the warehouse to the Customer. Items marked † are assumptions to confirm.

### Last Mile Driver
- Start every shift ready: attendance marked, working device and vehicle in hand.
- Know exactly what to pick up and from where (warehouse or DC), and collect it with a scanned handover.
- Deliver each shipment to the Customer on time, by an efficient route, with proof of delivery.
- Reach the Customer easily, and be reachable by them, without exposing personal numbers.
- Collect payment accurately and hand cash in with a clear record.
- When a delivery fails or is cancelled, record why and bring the parcel back safely to the DC or warehouse.
- Collect returns from Customers safely, with a record.
- Keep working with poor or no network.
- Get help fast in an accident, breakdown or emergency.
- Get paid correctly, see how pay was worked out, and raise a dispute if it is wrong.
- (Cutover) Move to the new app with minimal disruption.

### Mid-Mile Driver
- Start every shift ready: attendance marked, working device and vehicle in hand.
- Know the trip: what to carry, from where to where, by when.
- Show clearly what was handed over and received at each point, with scans.
- Move consignments safely and on time; when delayed, broken down or damaged in transit, report it and get help.
- Move returned parcels back to the warehouse with the same handover tracking as Forward.
- Get help fast in an accident or emergency.
- Get paid correctly, see how pay was worked out, and raise a dispute if it is wrong.
- (Cutover) Move to the new app with minimal disruption.

### WH Ops
- † Get every order picked, packed and labelled (AWB printed) correctly, ready for dispatch.
- Catch and fix a wrong or missing item before it leaves the warehouse.
- Hand every ready shipment to the Dispatcher with a scanned handover.
- Receive every returned parcel back into the warehouse correctly, and report damage or mismatch on arrival. (The system's scope ends here.)

### Dispatcher
Flow 1, via DC:
- Collate and sort ready shipments by destination DC, create consignments, and hand them to the Mid-Mile Driver on time.
- † Plan mid-mile trips so consignments leave on time.

Flow 2, direct from the warehouse:
- Batch shipments, plan routes and allocate Last Mile Drivers at the warehouse, and hand over with a scan.

Both flows:
- Make sure each shipment takes the right path (via DC or direct).
- Schedule return pickups and failed-delivery returns without delay.
- Re-plan quickly when a driver drops off, a shipment fails, or an order is cancelled or changed after dispatch.
- Keep a healthy pool of drivers available at the warehouse.
- † Onboard drivers for the warehouse's direct flow and keep their details current.
- Be the first point of contact for drivers on the road in the direct flow.

### DC Executive
- Receive consignments from the Mid-Mile Driver with a scanned handover, and catch anything missing, damaged or mismatched.
- Sort every shipment into the right bin, and hand sorted batches to Last Mile Drivers with a scanned handover.
- Keep the DC's Last Mile Drivers ready and accounted for each day.
- Receive returns and failed deliveries from drivers, and release them back towards the warehouse.
- Collect, record and bank the cash handed in, and escalate any mismatch.
- † Onboard drivers for the DC and keep their details current.
- Assign and recover devices and vehicles, and handle a lost or broken device.
- Be the first point of contact for drivers at the DC.

### Team Lead (one city)
- Keep the right number of drivers on shift for the city's orders, with cover for leave and absences.
- Watch live deliveries in the city and fix problems before they become complaints.
- Manage the city's drivers: document checks and renewals, suspension and exit, performance, and first-line dispute handling.
- Manage the city's users and their access.
- Keep the city's vehicles and devices accounted for.
- Plan the city's capacity as new locations open.
- Investigate loss, fraud and cash anomalies in the city.
- (Cutover) Train drivers, run the new system alongside Shipsy, and roll back if needed for the city's locations.

### Central Logistics Ops (whole country)
- See country-wide performance and step in where it drops.
- Set up cities, locations, serviceable areas and the links between warehouses and DCs, including which locations use the direct flow and which use the DC flow.
- Define the rules the system runs on: SLAs, batching, allocation, number of delivery attempts, cut-offs, and driver pay, incentives and penalties.
- Manage roles and access across the whole system.
- Forecast demand and plan drivers and DC capacity for growth from 39 to 150 locations.
- Detect and act on fraud and leakage patterns across the country.
- Give leadership and analytics the reports and data they need.
- (Cutover) Own the location-by-location cutover plan: readiness criteria, go or no-go, and rollback.
- † Absorb today's Control Tower monitoring role.

### Finance
- Make sure every rupee collected matches what was owed and is banked, and approve cash deposits.
- Close cash discrepancies.
- Pay drivers accurately and on time under the pay rules, including incentives and penalties.
- Resolve payout disputes with the Grievance team.
- Keep a trustworthy record of every money movement.
- Refunds are out of scope.

### Grievance & Escalation Management Team
- Resolve every Customer ticket quickly and fairly, with clear escalation when needed.
- † Resolve driver tickets too, such as payout disputes, penalties, app problems and incidents.
- Investigate incidents such as loss, damage, fraud and accidents, with the Team Lead.
- Spot patterns in tickets so recurring problems get fixed at the root.
- Keep tickets within their time limits.

### Customer
- Know when the order will arrive, track it, and be told about changes.
- Receive the order securely and confirm it. † Prescription or ID checks, if required.
- Reschedule, cancel or reject a delivery without hassle.
- Correct an address or phone number before delivery.
- Reach the Driver, and be reached, without sharing personal numbers.
- Pay easily.
- Return an order easily and know when it will be collected.
- Get quick help when something goes wrong, and raise a ticket.

### System (responsibilities, not jobs)
- Decide each shipment's path (via DC or direct) from the rules, and create consignments and manifests.
- Create batches and routes, and allocate drivers.
- Keep every shipment's status and location current, and keep a full audit trail of every scan and change.
- Send the right notices to the right people at the right time.
- Detect failures and fraud signals: missed scans, delays, mismatches, cash anomalies, and delivery marked from the wrong place.
- Keep the Driver apps working offline, and sync when the network returns.
- Mask phone numbers between Customers and Drivers.
- Enforce who can do what.
- Hold and apply the rules (SLAs, attempts, batching, pay).
- Provide reports and a data feed.
- Switch a location between Shipsy and the new system, and roll back, during cutover.

### Open assumptions and questions
1. Where does the system start: are Order Placed and Pick & Pack in scope, or does it start at "ready for dispatch"?
2. Is the Control Tower folded into Central Logistics Ops and the Team Lead?
3. Who does which part of driver onboarding (Dispatcher and DC Executive)?
4. Who plans mid-mile trips?
5. Does the Grievance team handle driver tickets too?
6. Do medicine deliveries need prescription or ID checks, cold chain, or tamper-proof custody?
7. Are drivers employees, or supplied by fleet partners? This affects payouts and onboarding.
