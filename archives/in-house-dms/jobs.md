# Jobs to be done per actor (step 2, draft v8, 2026-10-24)

Dispatcher has two flows: (1) send orders to a DC for last-mile delivery (warehouse to DC via Mid-Mile, then DC to Customer); (2) send orders directly from the warehouse to the Customer. Items marked † are assumptions to confirm.

### Last Mile Driver
- Start every shift ready: attendance marked, working device and vehicle in hand.
- Know exactly what to pick up and from where (warehouse or DC), and collect it with a scanned handover.
- Deliver each shipment to the Customer on time, by an efficient route, with proof of delivery.
- Reach the Customer easily, and be reachable by them, without exposing personal numbers.
- Collect payment accurately and hand cash in with a clear record.
- When a delivery fails or is cancelled, record why and bring the parcel back safely to the DC or warehouse.
- Collect returns from Customers safely, with a record, and check the medicine against the order details at the doorstep (QC) before taking it back.
- Keep working with poor or no network.
- Get help fast in an accident, breakdown or emergency.
- Get paid correctly, see how pay was worked out, and raise a dispute if it is wrong.
- (Cutover) Move to the new app with minimal disruption.

### Mid-Mile Driver
- Show up and drive consignments from one location to another, safely and on time. That is the whole job. No app, no scans, no attendance, no trip start or end, no loading or unloading.

### WH Ops
- Hand every shipment that is ready for dispatch to the Dispatcher with a scanned handover. (The system starts here; picking and packing are outside it.)
- Receive every returned parcel back into the warehouse correctly, and report damage or mismatch on arrival. (The system's scope ends here.)
- WH Ops is limited to giving and receiving parcels for this project.

### Dispatcher
Flow 1, via DC:
- Collate and sort ready shipments by destination DC, create consignments, and send them out on the mid-mile vehicle on time: tag each consignment to a vendor and to the vehicle registered at that moment (vehicle number, driver's name and phone), load it, and scan the handover.
- Flag any loss, damage or delay of a consignment in transit.
- (Later) See the live location of mid-mile vehicles on a portal, once IoT devices are fitted.
- Plan mid-mile trips, together with the Team Lead, so consignments leave on time.

Flow 2, direct from the warehouse:
- Batch shipments, plan routes and allocate Last Mile Drivers at the warehouse, and hand over with a scan.

Both flows:
- Make sure each shipment takes the right path (via DC or direct).
- Add gel packs to every order that needs them so medicines do not spoil (this is the cold-chain proofing).
- Schedule return pickups and failed-delivery returns without delay.
- Reassign shipments quickly when a driver can't complete their batch, a delivery fails, or an order is cancelled or changed after dispatch. († PM to challenge this job when actions are drafted.)
- Keep a healthy pool of drivers available at the warehouse.
- Onboard the Last Mile Drivers who deliver from the warehouse, and keep their details current.
- Be the first point of contact for drivers on the road in the direct flow.

### DC Executive
- Receive consignments arriving on the mid-mile vehicle with a scan, unload it, and catch anything missing, damaged or mismatched.
- Flag any loss, damage or delay of a consignment in transit.
- (Later) See the live location of mid-mile vehicles on a portal, once IoT devices are fitted.
- Sort every shipment into the right bin, and hand sorted batches to Last Mile Drivers with a scanned handover.
- Keep the DC's Last Mile Drivers ready and accounted for each day.
- Receive returns and failed deliveries from drivers, and release them back towards the warehouse.
- Collect, record and bank the cash handed in, and escalate any mismatch.
- Onboard the Last Mile Drivers who deliver from the DC, and keep their details current.
- Assign and recover devices and vehicles, and handle a lost or broken device.
- Be the first point of contact for drivers at the DC.

### Team Lead (one city)
- Keep the right number of drivers on shift for the city's orders, with cover for leave and absences.
- Watch live deliveries in the city (the Control Tower role is folded in) and fix problems before they become complaints.
- Plan mid-mile trips together with the Dispatcher.
- Manage the city's drivers: document checks and renewals, suspension and exit, performance, and first-line dispute handling.
- Manage the city's users and their access.
- Onboard and manage mid-mile vendors.
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
- Absorb the Control Tower's monitoring role.

### Finance
- Make sure every rupee collected matches what was owed and is banked, and approve cash deposits.
- Close cash discrepancies.
- Pay drivers accurately and on time under the pay rules, including incentives and penalties.
- Pay mid-mile vendors accurately and on time.
- Resolve payout disputes with the Grievance team.
- Keep a trustworthy record of every money movement.
- Refunds are out of scope.

### Grievance & Escalation Management Team
(Scoped in later, not in the first release. Jobs kept here for completeness.)
- Resolve every Customer ticket quickly and fairly, with clear escalation when needed.
- Resolve driver tickets too, such as payout disputes, penalties, app problems and incidents. (Not done today; will come later and stays in scope.)
- Investigate incidents such as loss, damage, fraud and accidents, with the Team Lead.
- Spot patterns in tickets so recurring problems get fixed at the root.
- Keep tickets within their time limits.

### Customer
- Know when the order will arrive, track it, and be told about changes.
- Receive the order securely and confirm it.
- Reschedule, cancel or reject a delivery without hassle.
- Correct an address or phone number before delivery.
- Reach the Driver, and be reached, without sharing personal numbers.
- Pay easily.
- Return an order easily and know when it will be collected.
- (Later) Get quick help when something goes wrong, and raise a ticket. Nothing on tickets in the first release.

### System (responsibilities, not jobs)
- Decide each shipment's path (via DC or direct) from the rules, and create consignments and manifests.
- Create batches and routes, and allocate drivers.
- Keep every shipment's status and location current, and keep a full audit trail of every scan and change.
- Send the right notices to the right people at the right time.
- Detect failures and fraud signals: missed scans, delays, mismatches, cash anomalies, and delivery marked from the wrong place.
- Keep the Driver apps working offline, and sync when the network returns.
- Mask phone numbers between Customers and Drivers.
- Hold the mid-mile vendors, and let a vehicle be registered at run-time against each consignment, with the vehicle number and the driver's name and phone. No driver profile is kept.
- (Later) Show live mid-mile vehicle location from IoT devices.
- Show medicine details to the Last Mile Driver only in the returns flow, to enable doorstep QC.
- Enforce who can do what.
- Hold and apply the rules (SLAs, attempts, batching, pay).
- Provide reports and a data feed.
- Switch a location between Shipsy and the new system, and roll back, during cutover.
