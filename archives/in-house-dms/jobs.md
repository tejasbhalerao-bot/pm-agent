# Jobs to be done

The outcomes each actor needs to achieve. Actions are derived from these.

The system starts at AWB generation.

The Dispatcher runs two flows: sending orders to a DC for last-mile delivery, and sending orders directly from the warehouse to the Customer. "Cutover" jobs apply while locations move from Shipsy to the new system.

## WH Ops
- Print the AWB for every shipment.
- Hand every shipment that is ready for dispatch to the Dispatcher with a scanned handover.
- Receive every returned parcel back into the warehouse, and report damage or mismatch on arrival.

## Dispatcher
**Flow 1: via DC**
- Sort ready shipments by destination DC, scan them into the consignments the system creates, and send them on time. Record the vendor, vehicle number, and the driver's name and phone against each consignment, load it and scan the handover.
- Plan mid-mile trips with the Team Lead so consignments leave on time.
- Flag any loss, damage or delay of a consignment in transit.
- See the live location of mid-mile vehicles on a portal.

**Flow 2: direct from the warehouse**
- Hand each batch to its Last Mile Driver with a scan.
- Collect, record and bank the cash handed in by the warehouse's drivers, and escalate any mismatch.

**Both flows**
- Add gel packs to every order that needs them, so medicines do not spoil.
- Schedule return pickups and failed-delivery returns without delay.
- Trigger a replan for the next day when a failed delivery needs to be reattempted, and accept the new plan or rearrange it as the situation on the ground needs.
- Trigger a replan when a driver can't complete their batch, or an order is cancelled or changed after dispatch, and accept the new plan or rearrange it as the situation on the ground needs.
- Keep a healthy pool of drivers at the warehouse.
- Onboard the warehouse's Last Mile Drivers and keep their details current.
- Settle payout disputes raised by the warehouse's drivers.
- Be the first point of contact for drivers on the road in the direct flow.

## DC Executive
- Receive consignments arriving on the mid-mile vehicle, scan and unload them, and catch anything missing, damaged or mismatched.
- Flag any loss, damage or delay of a consignment in transit.
- See the live location of mid-mile vehicles on a portal.
- Sort every shipment into the right bin, and hand sorted batches to Last Mile Drivers with a scanned handover.
- Keep the DC's Last Mile Drivers ready and accounted for each day.
- Trigger a replan for the DC's drivers when a driver can't complete their batch, or an order is cancelled or changed after dispatch, and accept the new plan or rearrange it as the situation on the ground needs.
- Trigger a replan for the next day when one of the DC's failed deliveries needs to be reattempted, and accept the new plan or rearrange it as the situation on the ground needs.
- Receive returns and failed deliveries from drivers, and release them towards the warehouse as consignments.
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
- Onboard and manage vendors.
- Keep the city's vehicles and devices accounted for.
- Plan the city's capacity as new locations open.
- Investigate loss, fraud and cash anomalies in the city.
- Cutover: train drivers, run the new system alongside Shipsy, and roll back if needed.

## Mid-Mile Driver
- Show up and drive consignments between locations, safely and on time.

## Last Mile Driver
- Start each shift ready, with attendance marked and a working device and vehicle.
- Know what to pick up and from where (warehouse or DC), and collect it with a scanned handover.
- Deliver each shipment on time, by an efficient route, with proof of delivery.
- Reach the Customer, and be reachable, without exposing personal numbers.
- Collect payment accurately and hand cash in with a clear record.
- When a delivery fails or is cancelled, record why and bring the parcel back safely to the DC or warehouse.
- Collect returns from Customers safely, checking the medicine against the order details at the doorstep before taking it back.
- Keep working with poor or no network.
- Raise a payout dispute when pay looks wrong.
- Get help fast in an accident, breakdown or emergency.
- Cutover: move to the new app with minimal disruption.

## Customer
- Know when the order will arrive, track it, and be told about changes.
- Receive the order securely and confirm it.
- Reschedule, cancel or reject a delivery easily.
- Correct an address or phone number before delivery.
- Reach the Driver, and be reached, without sharing personal numbers.
- Pay easily.
- Return an order easily and know when it will be collected.
- Get help when something goes wrong and raise a ticket.

## Finance
- Make sure every rupee collected matches what was owed and is banked, approve cash deposits and close discrepancies.
- Pay vendors accurately and on time, every month, under the pay rules.
- Keep a trustworthy record of every money movement.

## Central Logistics Ops (whole country)
- See country-wide performance and step in where it drops.
- Set up cities, locations, serviceable areas and the links between warehouses and DCs, including which locations use the direct flow and which use the DC flow.
- Define the rules the system runs on: SLAs, batching, allocation, delivery attempts, cut-offs, and pay, incentives and penalties.
- Manage roles and access across the system.
- Forecast demand and plan drivers and DC capacity for growth from 39 to 150 locations.
- Detect and act on fraud and leakage patterns.
- Settle payout disputes that the Dispatcher, DC Executive and Team Lead cannot.
- Give leadership and analytics the reports and data they need.
- Cutover: own the location-by-location plan, including readiness criteria, go or no-go, and rollback.

## System
Responsibilities, not jobs. Grouped by the entities the System manages.

**Orders and shipments**
- Receive each order with its details, and apply cancellations and changes, including after dispatch.
- Create a shipment for each order.
- Generate the AWB for each shipment and make it available to print.
- Decide each shipment's path (via DC or direct) from the rules.
- After a failed delivery, decide from the rules whether to reattempt it or initiate an RTO.
- Keep every shipment's status and location current.

**Barcodes and scanning**
- Generate barcodes for shipments and consignments.
- Resolve every scan to the right entity, and reject invalid or duplicate scans.

**Manifests and handovers**
- Generate a manifest for every handover, record the scans against it, and flag anything missing or mismatched.

**Consignments and mid-mile**
- Create consignments by grouping shipments by destination.
- Record the vendor, vehicle number, and the driver's name and phone against each consignment. No driver profile is kept.
- Show live mid-mile vehicle location from IoT devices.

**Sorting**
- Tell the DC Executive which bin each shipment belongs in, and keep track of what each bin holds.

**Allocation and delivery**
- Create delivery batches and routes, allocate Last Mile Drivers, and send the orders to the Driver's app.
- Replan the affected batches and routes, including reattempts for the next day, when the Dispatcher or DC Executive triggers it.
- Show medicine details to the Last Mile Driver only in the returns flow.
- Keep driver apps working offline, and sync when the network returns.

**Locations**
- Hold serving locations and serviced locations. In Forward, serving locations are warehouses and DCs, and serviced locations are Customers' locations. In Reverse, they flip.
- Hold the links between warehouses and DCs, and which flow each location uses.

**People, devices and access**
- Hold users, drivers, Customers and their details, and enforce who can do what.
- Register devices and record which driver holds each one.
- Mask phone numbers between Customers and Drivers.

**Money**
- Record every payment collected, every cash handover and every deposit, and match them against what was owed.
- Record vendor payments.

**Vendors**
- Hold vendors and their vehicles.

**Tickets**
- Raise, route and track tickets to resolution within their time limits.

**Across the system**
- Send the right notices to the right people at the right time.
- Detect failures and fraud signals: missed scans, delays, mismatches, cash anomalies, and deliveries marked from the wrong place.
- Keep a full audit trail of every scan and change.
- Hold and apply the rules.
- Provide reports and a data feed.
- Switch a location between Shipsy and the new system, and roll back, during cutover.

## Control Tower
- Watch live deliveries independently of Logistics Ops, and call out operational failures so none are hidden.

## Grievance & Escalation Management Team
- Resolve every Customer ticket quickly and fairly, escalating when needed.
- Resolve driver tickets, such as penalties, app problems and incidents.
- Investigate incidents such as loss, damage, fraud and accidents, with the Team Lead.
- Spot patterns in tickets so recurring problems get fixed at the root.
- Keep tickets within their time limits.
