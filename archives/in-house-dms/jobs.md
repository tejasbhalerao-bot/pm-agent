# Jobs to be done

The outcomes each actor needs to achieve. Actions are derived from these.

The system starts at AWB generation.

The Dispatcher runs two flows: sending orders to a DC for last-mile delivery, and sending orders directly from the warehouse to the Customer. "Cutover" jobs apply while locations move from Shipsy to the new system.

## WH Ops
- Print the AWB for every shipment.
- Hand every shipment that is ready for dispatch to the Dispatcher with a scanned handover.
- Receive every returned parcel back into the warehouse, and report damage or mismatch on arrival.

## Dispatcher
**Both flows, before dispatch**
- Add gel packs to every order that needs them, so medicines do not spoil.

**Flow 1: via DC**
- Plan mid-mile trips with the Team Lead so consignments leave on time.
- Sort ready shipments by destination DC, scan them into the consignments the system creates, and send them on time. Record the vendor, vehicle number, and the driver's name and phone against each consignment, load it and scan the handover.
- See the live location of mid-mile vehicles on a portal.
- Flag any loss, damage or delay of a consignment in transit.

**Flow 2: direct from the warehouse**
In the direct flow, the Dispatcher does the same jobs as the DC Executive, for the warehouse's drivers. The exceptions are receiving forward consignments and releasing returns as consignments, since the warehouse is where returns end.

**Both flows, returns**
- Schedule return pickups and failed-delivery returns without delay.
- Receive returned consignments from the mid-mile vehicle, scan and unload them, catch anything missing, damaged or mismatched, and hand the parcels to WH Ops.

## DC Executive
- Onboard the DC's Last Mile Drivers with their vehicles and devices, tag each to a vendor, and keep their details current.
- Set each driver's serviceability: the zones and pincodes they serve, and the pincodes within them that they do not.
- Assign each driver a pay structure, with the Team Lead and Central Logistics Ops.
- Recover devices and vehicles, and handle a lost or broken device.
- Keep the DC's Last Mile Drivers ready and accounted for each day.
- See the live location of mid-mile vehicles on a portal.
- Receive consignments arriving on the mid-mile vehicle, scan and unload them, and catch anything missing, damaged or mismatched.
- Flag any loss, damage or delay of a consignment in transit.
- Sort every shipment into the right bin, and scan on the portal the orders each Last Mile Driver brings from the bin.
- Be the first point of contact for drivers at the DC.
- Trigger a replan for the DC's drivers when a driver can't complete their batch, or an order is cancelled or changed after dispatch, and accept the new plan or rearrange it as the situation on the ground needs.
- Receive returns and failed deliveries from drivers, and release them towards the warehouse as consignments.
- Trigger a replan for the next day when one of the DC's failed deliveries needs to be reattempted, and accept the new plan or rearrange it as the situation on the ground needs.
- Collect, record and bank the cash handed in, and escalate any mismatch.
- Settle payout disputes raised by the DC's drivers.

## Team Lead (one city)
- Manage the city's users and their access.
- Onboard and manage vendors.
- Manage the city's drivers: document checks and renewals, suspension and exit, and performance.
- Confirm each driver's pay structure with the DC Executive, Dispatcher and Central Logistics Ops.
- Keep the city's vehicles and devices accounted for.
- Keep enough drivers on shift for each location's expected orders, with cover for leave and absences.
- Plan mid-mile trips with the Dispatcher.
- Spot and fix delivery problems in the city before they become complaints.
- Give drivers their incentives under the schemes set by Central Logistics Ops, including ad-hoc incentives.
- Settle payout disputes raised by the city's drivers.
- Investigate loss, fraud and cash anomalies in the city.
- Plan the city's capacity as new locations open.
- Cutover: train drivers on the new app.

## Mid-Mile Driver
- Show up and drive consignments between locations, safely and on time.

## Last Mile Driver
- Cutover: move to the new app with minimal disruption.
- Start each shift ready, with attendance marked and a working device and vehicle.
- Know what to pick up and from where (warehouse or DC), pick the assigned orders from the bin, and take them to the DC Executive to scan.
- Call the Customer, and be reachable by them, without exposing personal numbers.
- Deliver each shipment on time, by an efficient route, with proof of delivery.
- Collect payment accurately and hand cash in with a clear record.
- When a delivery fails or is cancelled, record why and bring the parcel back safely to the DC or warehouse.
- Collect returns from Customers safely, checking the medicine against the order details at the doorstep before taking it back.
- Keep working with poor or no network.
- Get help fast in an accident, breakdown or emergency.
- See earnings and progress towards incentives.
- Raise a payout dispute when pay looks wrong.

## Customer
- Know when the order will arrive, track it, and be told about changes.
- Correct an address or phone number before delivery.
- Reschedule, cancel or reject a delivery easily.
- Call the Driver, and be reachable by them, without sharing personal numbers.
- Receive the order securely and confirm it.
- Pay easily.
- Return an order easily and know when it will be collected.
- Get help when something goes wrong and raise a ticket.

## Finance
- Make sure every rupee collected matches what was owed and is banked, approve cash deposits and close discrepancies.
- Pay vendors accurately and on time, every month, from the earnings of the drivers they supply.
- Keep a trustworthy record of every money movement.

## Central Logistics Ops (whole country)
- Set up locations, their zones and the pincodes in each zone, and the links between warehouses and DCs, including which locations use the direct flow and which use the DC flow.
- Define the rules the system runs on: SLAs, batching, allocation, delivery attempts, cut-offs, and penalties.
- Define the salary structures and incentive schemes drivers can be on.
- Manage roles and access across the system.
- Confirm each driver's pay structure with the DC Executive, Dispatcher and Team Lead.
- Forecast demand and plan drivers and DC capacity for growth from 39 to 150 locations.
- See country-wide performance and step in where it drops.
- Detect and act on fraud and leakage patterns.
- Settle payout disputes that the Dispatcher, DC Executive and Team Lead cannot.
- Give leadership and analytics the reports and data they need.

## System
Responsibilities, not jobs. Grouped by the entities the System manages.

**Locations**
- Hold serving locations, the zones mapped to each hub, and the serviced locations (pincodes) in each zone. In Forward, serving locations are warehouses and DCs, and serviced locations are Customers' pincodes. In Reverse, they flip.
- Hold the links between warehouses and DCs, and which flow each location uses.

**People, devices and access**
- Hold users, drivers, Customers and their details, and enforce who can do what.
- Hold each driver's documents.
- Hold each driver's serviceability: the zones and pincodes they serve and the pincodes within them that they do not.
- Hold each driver's status (active, suspended, exited, on duty or off duty) and the result of their document checks.
- Record each driver's attendance and duty status.
- Show who is on duty, on leave or absent for each location.
- Register devices and record which driver holds each one.
- Mask phone numbers between Customers and Drivers.

**Vendors**
- Hold vendors, their vehicles and their drivers.

**Orders and shipments**
- Receive each order with its details, and apply cancellations and changes, including after dispatch.
- Create a shipment for each order.
- Flag the orders that need cold-chain protection.
- Generate the AWB for each shipment and make it available to print.
- Decide each shipment's path (via DC or direct) from the rules.
- Keep every shipment's status and location current.
- Keep the proof of delivery against each shipment.
- Record a failed delivery with its reason, and tell the Dispatcher.
- Receive a Customer's return request and create the return pickup.

**Barcodes and scanning**
- Generate barcodes for shipments and consignments.
- Resolve every scan to the right entity, and reject invalid or duplicate scans.

**Manifests and handovers**
- Generate a manifest for every handover, record the scans against it, and flag anything missing or mismatched.

**Consignments and mid-mile**
- Create consignments by grouping shipments by destination.
- Show the consignments ready to move, by destination.
- Record the vendor, vehicle number, and the driver's name and phone against each consignment. No driver profile is kept.
- Show live mid-mile vehicle location from IoT devices.

**Sorting**
- Tell the Dispatcher or DC Executive which bin each shipment belongs in, and keep track of what each bin holds.

**Allocation and delivery**
- Create delivery batches and routes that combine forward deliveries and return pickups, allocate Last Mile Drivers whose serviceability covers each pincode, and send the orders and pickups to the Driver's app.
- Replan the affected batches and routes, including reattempts for the next day, when the Dispatcher or DC Executive triggers it.
- After a failed delivery, decide from the rules whether to reattempt it or initiate an RTO.
- Show medicine details to the Last Mile Driver only in the returns flow.
- Keep driver apps working offline, and sync when the network returns.

**Driver pay**
- Hold each driver's salary structure (per order delivered, or fixed with fuel expenses) and the incentive schemes that apply to them.
- Compute each driver's earnings from their salary structure and incentives.
- Track each driver's progress against incentive schemes (attendance-based, order-based, ad-hoc and others), and show the Team Lead what each driver has earned.
- Adjust a driver's earnings, and the amount payable to their vendor, when a payout dispute is settled.
- Roll driver earnings up into the amount payable to each vendor.

**Money**
- Record every payment collected, every cash handover and every deposit, and match them against what was owed.
- Record vendor payments.

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
