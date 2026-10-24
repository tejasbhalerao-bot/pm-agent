# Jobs to be done

The outcomes each actor needs to achieve. Actions are derived from these.

The Dispatcher runs two flows: sending orders to a DC for last-mile delivery, and sending orders directly from the warehouse to the Customer. "Cutover" jobs apply while locations move from Shipsy to the new system. "Later" jobs are scoped in after the first release.

## Last Mile Driver
- Start each shift ready, with attendance marked and a working device and vehicle.
- Know what to pick up and from where (warehouse or DC), and collect it with a scanned handover.
- Deliver each shipment on time, by an efficient route, with proof of delivery.
- Reach the Customer, and be reachable, without exposing personal numbers.
- Collect payment accurately and hand cash in with a clear record.
- When a delivery fails or is cancelled, record why and bring the parcel back safely to the DC or warehouse.
- Collect returns from Customers safely, checking the medicine against the order details at the doorstep before taking it back.
- Keep working with poor or no network.
- Get help fast in an accident, breakdown or emergency.
- Get paid correctly, see how pay was worked out, and raise a dispute if it is wrong.
- Cutover: move to the new app with minimal disruption.

## Mid-Mile Driver
- Show up and drive consignments between locations, safely and on time. The driver has no app and does no scanning, attendance, trip start or end, loading or unloading.

## WH Ops
- Hand every shipment that is ready for dispatch to the Dispatcher with a scanned handover.
- Receive every returned parcel back into the warehouse, and report damage or mismatch on arrival.

## Dispatcher
**Flow 1: via DC**
- Collate and sort ready shipments by destination DC, create consignments and send them on time. Record the vendor, vehicle number, and the driver's name and phone against each consignment, load it and scan the handover.
- Plan mid-mile trips with the Team Lead so consignments leave on time.
- Flag any loss, damage or delay of a consignment in transit.
- Later: see the live location of mid-mile vehicles on a portal.

**Flow 2: direct from the warehouse**
- Batch shipments, plan routes and allocate Last Mile Drivers, and hand over with a scan.

**Both flows**
- Make sure each shipment takes the right path, via DC or direct.
- Add gel packs to every order that needs them, so medicines do not spoil.
- Schedule return pickups and failed-delivery returns without delay.
- Reassign shipments quickly when a driver can't complete their batch, a delivery fails, or an order is cancelled or changed after dispatch.
- Keep a healthy pool of drivers at the warehouse.
- Onboard the warehouse's Last Mile Drivers and keep their details current.
- Settle payout disputes raised by the warehouse's drivers.
- Be the first point of contact for drivers on the road in the direct flow.

## DC Executive
- Receive consignments arriving on the mid-mile vehicle, scan and unload them, and catch anything missing, damaged or mismatched.
- Flag any loss, damage or delay of a consignment in transit.
- Later: see the live location of mid-mile vehicles on a portal.
- Sort every shipment into the right bin, and hand sorted batches to Last Mile Drivers with a scanned handover.
- Keep the DC's Last Mile Drivers ready and accounted for each day.
- Receive returns and failed deliveries from drivers, and release them back towards the warehouse.
- Collect, record and bank the cash handed in, and escalate any mismatch.
- Onboard the DC's Last Mile Drivers and keep their details current.
- Settle payout disputes raised by the DC's drivers.
- Assign and recover devices and vehicles, and handle a lost or broken device.
- Be the first point of contact for drivers at the DC.

## Team Lead (one city)
- Keep enough drivers on shift for the city's orders, with cover for leave and absences.
- Spot and fix delivery problems in the city before they become complaints.
- Plan mid-mile trips with the Dispatcher.
- Manage the city's drivers: document checks and renewals, suspension and exit, and performance.
- Settle payout disputes raised by the city's drivers.
- Manage the city's users and their access.
- Onboard and manage mid-mile vendors.
- Keep the city's vehicles and devices accounted for.
- Plan the city's capacity as new locations open.
- Investigate loss, fraud and cash anomalies in the city.
- Cutover: train drivers, run the new system alongside Shipsy, and roll back if needed.

## Central Logistics Ops (whole country)
- See country-wide performance and step in where it drops.
- Set up cities, locations, serviceable areas and the links between warehouses and DCs, including which locations use the direct flow and which use the DC flow.
- Define the rules the system runs on: SLAs, batching, allocation, delivery attempts, cut-offs, and driver pay, incentives and penalties.
- Manage roles and access across the system.
- Forecast demand and plan drivers and DC capacity for growth from 39 to 150 locations.
- Detect and act on fraud and leakage patterns.
- Settle payout disputes that the Dispatcher, DC Executive and Team Lead cannot.
- Give leadership and analytics the reports and data they need.
- Cutover: own the location-by-location plan, including readiness criteria, go or no-go, and rollback.

## Finance
- Make sure every rupee collected matches what was owed and is banked, approve cash deposits and close discrepancies.
- Pay drivers and mid-mile vendors accurately and on time under the pay rules.
- Keep a trustworthy record of every money movement.

## Grievance & Escalation Management Team
Scoped in later.
- Resolve every Customer ticket quickly and fairly, escalating when needed.
- Resolve driver tickets, such as penalties, app problems and incidents.
- Investigate incidents such as loss, damage, fraud and accidents, with the Team Lead.
- Spot patterns in tickets so recurring problems get fixed at the root.
- Keep tickets within their time limits.

## Control Tower
- Watch live deliveries and step in on problems before they become complaints.

## Customer
- Know when the order will arrive, track it, and be told about changes.
- Receive the order securely and confirm it.
- Reschedule, cancel or reject a delivery easily.
- Correct an address or phone number before delivery.
- Reach the Driver, and be reached, without sharing personal numbers.
- Pay easily.
- Return an order easily and know when it will be collected.
- Later: get help when something goes wrong and raise a ticket.

## System
Responsibilities, not jobs.
- Decide each shipment's path (via DC or direct) from the rules, and create consignments and manifests.
- Create batches and routes, and allocate drivers.
- Keep every shipment's status and location current, with a full audit trail of every scan and change.
- Send the right notices to the right people at the right time.
- Detect failures and fraud signals: missed scans, delays, mismatches, cash anomalies, and deliveries marked from the wrong place.
- Keep driver apps working offline and sync when the network returns.
- Mask phone numbers between Customers and Drivers.
- Hold mid-mile vendors, and record the vehicle number and the driver's name and phone against each consignment. No driver profile is kept.
- Show medicine details to the Last Mile Driver only in the returns flow.
- Enforce who can do what.
- Hold and apply the rules.
- Provide reports and a data feed.
- Switch a location between Shipsy and the new system, and roll back, during cutover.
- Later: show live mid-mile vehicle location from IoT devices.
