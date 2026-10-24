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
