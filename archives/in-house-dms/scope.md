# Scope

## Boundaries (PM, 2026-10-24)
- The system stops at delivering returned orders back to the warehouse (failed-delivery returns and customer returns). Nothing after the warehouse receive is in scope.
- Refunds are out of scope.
- Central Logistics Ops (whole country) owns geography setup (cities and locations). A Team Lead handles one city.

## Phasing (PM, 2026-10-24)
Scoped in later, not in the first release:
- Grievance & Escalation Management (its jobs, and the ticket handling that goes with them).
- Mid-mile vehicle tracking (the IoT devices and portal).

## Decisions applied to the jobs

Decisions applied in v3: the system starts at "ready for dispatch", which is after AWB print (so AWB generation, AWB print and picking and packing are outside it); the Control Tower is folded into Central Logistics Ops and the Team Lead; tamper-proof custody is out of scope; Mid-Mile Drivers get no app and only show up and drive (loading, unloading, handover, tracking, attendance, trip start and end do not fall on them); the Mid-Mile Driver and his vendor are accountable for loss, damage and delay in transit, and the Dispatcher and DC Executive flag it; mid-mile vendors are onboarded, not drivers, and each consignment is tagged to a vehicle registered at run-time; mid-mile vehicles are tracked operationally today by WhatsApp live location, with IoT devices and a portal to follow; drivers are supplied by fleet partners today but the jobs are unchanged.
