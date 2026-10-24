# Scope

## In scope
- Hyperlocal Forward and Reverse, from "ready for dispatch" (after AWB print) until a returned order is delivered back to the warehouse.
- Two dispatch flows: via a DC, and directly from the warehouse to the Customer.

## Out of scope
- Picking, packing, AWB generation and AWB print.
- Anything after the warehouse receives a returned parcel.
- Refunds.
- Tamper-proof custody.

## Scoped in later
- Grievance & Escalation Management, and ticket handling.
- Mid-mile vehicle tracking through IoT devices and a portal. Today, vehicles are tracked through WhatsApp live location.

## Decisions
**Roles**
- Central Logistics Ops manages the whole country, including geography. A Team Lead manages one city.
- The Control Tower is a separate actor.
- Payout disputes are settled by Team Leads, DC Executives, Dispatchers and Central Logistics Ops, not by the Grievance team.
- The DC Executive onboards Last Mile Drivers who deliver from the DC. The Dispatcher onboards those who deliver from the warehouse.
- The Dispatcher and the Team Lead plan mid-mile trips together.
- WH Ops only gives and receives parcels.

**Mid-mile**
- Mid-Mile Drivers have no app. They only drive.
- Vendors are onboarded, not drivers. The Team Lead onboards and manages vendors.
- At loading, the Dispatcher records the vendor, vehicle number, and the driver's name and phone against each consignment. No driver profile is kept.
- The Dispatcher loads and scans at the origin. The DC Executive unloads and scans at the DC.
- The driver and the vendor are accountable for loss, damage and delay in transit. The Dispatcher and DC Executive flag it.
- Finance pays mid-mile vendors.

**Medicines**
- Cold-chain proofing means the Dispatcher adds gel packs to orders that need them.
- Medicine details are shown to the Last Mile Driver only in the returns flow, for doorstep quality checks.

**Other**
- Drivers are supplied by fleet partners today. The jobs do not change.
