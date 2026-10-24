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

## Jobs to be done per actor (step 2, draft v1, 2026-10-24)

| Actor | Jobs |
|---|---|
| Last Mile Driver | Deliver every assigned shipment to the Customer on time and with proof. Collect and hand in cash accurately. Know where to go next with minimum effort. Record why a delivery couldn't be completed and get the parcel back safely. Get unstuck on the road, for example when the Customer is unreachable. Bring every undelivered parcel back to the DC. Collect returns from the Customer safely. Get paid correctly for the work done. |
| Mid-Mile Driver | Move consignments safely between locations on time. Show clearly what was handed over and received at each point. Move returned parcels back to the warehouse with the same handover tracking as Forward. Get paid correctly for the work done. |
| WH Ops | Get every order picked, packed and labelled correctly, ready for dispatch. Receive every returned parcel back into the warehouse correctly. |
| Dispatcher | Get every ready shipment out of the origin to the right place on time. Schedule return pickups and failed-delivery returns without delay. Re-plan quickly when a driver drops off or a shipment fails. Keep a healthy pool of drivers available at the origin. Bring new drivers onboard and keep their details current. |
| DC Executive | Receive, sort and release every consignment accurately at the DC. Receive returned parcels accurately and release them onward. Catch and report missing, damaged or mismatched consignments at the DC. Keep the day's Last Mile Drivers ready and accounted for. Collect, record and bank the cash handed in. Bring new drivers onboard and keep their details current. |
| Team Lead (one city) | Keep enough drivers on shift to cover the city's orders. Spot and fix delivery problems in the city before they become complaints. Keep the city's locations, users and drivers up to date. |
| Central Logistics Ops (whole country) | See country-wide performance and step in where it drops. Set up new cities and locations and the rules they run on. Manage roles and access for the whole system. |
| Finance | Make sure every rupee collected matches what was owed and is banked. Pay drivers accurately and on time. Catch and close cash discrepancies. |
| Grievance & Escalation Management Team | Resolve every complaint or ticket quickly and fairly. Spot patterns in complaints so recurring problems get fixed at the root. |
| Customer | Receive the order when promised. Know where the order is and when it will arrive. Reschedule, cancel or reject a delivery without hassle. Return an order easily and know when it will be collected. Get quick help when something goes wrong. Pay easily. |

System responsibilities (no jobs):
- Allocate drivers and plan routes and batches.
- Keep every shipment's status and location current.
- Send the right notices to the right people at the right time.
- Detect failures such as missed scans, delays and mismatches, and alert the right person.
- Enforce who can do what.
