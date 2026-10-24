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
- Linking each driver to a vendor.

## Decisions
- The Control Tower is a separate actor.
- Drivers are supplied by vendors (fleet partners). Payouts go to the vendor, who disburses to drivers outside our flow. Finance pays vendors, not drivers.
- At loading, the Dispatcher records the vendor, vehicle number, and the driver's name and phone against each consignment. No driver profile is kept.
- The driver and the vendor are accountable for loss, damage and delay in transit.
