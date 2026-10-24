# Actions

The actions each actor performs, derived from [jobs.md](jobs.md). Each action sits under the job it serves.

## Last Mile Driver

*Job: Start each shift ready, with attendance marked and a working device and vehicle.*

**Marks duty start** (Both)

- Entity: People
- Trigger: Shift begins
- Output: Attendance recorded; driver becomes available for batching and allocation

**Confirms the device and vehicle in use** (Both)

- Entity: Device, Vehicle
- Trigger: Duty start
- Output: Device and vehicle recorded against the driver for the shift

**Marks duty end** (Both)

- Entity: People
- Trigger: Shift ends
- Output: Attendance closed

*Job: Know what to pick up and from where (warehouse or DC), and collect it with a scanned handover.*

**Views the assigned batch and the pickup point** (Both)

- Entity: Shipment
- Trigger: Batch allocated to the driver
- Output: Driver sees what to collect and where

**Scans each shipment on collection** (Both)

- Entity: Shipment, Barcode, Manifest
- Trigger: Handover from the Dispatcher or DC Executive
- Output: Handover recorded against the manifest

*Job: Deliver each shipment on time, by an efficient route, with proof of delivery.*

**Views the route for the batch** (Forward)

- Entity: Shipment, Serviced Location
- Trigger: Batch collected
- Output: Stops shown in route order

**Navigates to the Customer's location** (Forward)

- Entity: Serviced Location
- Trigger: Next stop begins
- Output: Driver reaches the Customer

**Collects proof of delivery** (Forward)

- Entity: Shipment
- Trigger: Shipment handed to the Customer
- Output: Proof recorded; shipment marked delivered

*Job: Reach the Customer, and be reachable, without exposing personal numbers.*

**Calls the Customer through the app** (Both)

- Entity: People
- Trigger: Driver needs to reach the Customer
- Output: Call connects with both numbers masked

*Job: Collect payment accurately and hand cash in with a clear record.*

**Collects payment from the Customer** (Forward)

- Entity: Money, Shipment
- Trigger: Delivery of an order with payment due
- Output: Amount recorded against the shipment

**Hands cash in** (Forward)

- Entity: Money
- Trigger: End of the driver's duty
- Output: Cash handover recorded

*Job: When a delivery fails or is cancelled, record why and bring the parcel back safely to the DC or warehouse.*

**Marks the delivery as failed, with a reason** (Forward)

- Entity: Shipment
- Trigger: Delivery cannot be completed or is cancelled
- Output: Shipment marked failed with the reason; Dispatcher informed

**Brings the parcel back to the DC or warehouse and scans the handover** (Reverse)

- Entity: Shipment, Barcode, Manifest
- Trigger: Delivery failed or cancelled
- Output: Parcel returned; handover recorded

*Job: Collect returns from Customers safely, checking the medicine against the order details at the doorstep before taking it back.*

**Views the return pickup and the medicine details** (Reverse)

- Entity: Shipment, Order
- Trigger: Return pickup assigned
- Output: Driver sees what to collect and the medicine details

**Checks the medicine against the order details** (Reverse)

- Entity: Shipment, Order
- Trigger: Driver is with the Customer
- Output: Result of the check recorded

**Takes the parcel and scans it** (Reverse)

- Entity: Shipment, Barcode
- Trigger: Check complete
- Output: Return collected; handover recorded

*Job: Keep working with poor or no network.*

**Continues working in the app without a network** (Both)

- Entity: Device
- Trigger: Network is lost
- Output: Actions held on the device

**Syncs held actions** (Both)

- Entity: Device, Shipment
- Trigger: Network returns
- Output: Held actions sent; statuses updated

*Job: Raise a payout dispute when pay looks wrong.*

**Raises a payout dispute** (Both)

- Entity: Ticket, Money
- Trigger: Pay looks wrong
- Output: Dispute sent to the Dispatcher or DC Executive

*Job: Get help fast in an accident, breakdown or emergency.*

**Raises a help request** (Both)

- Entity: Ticket
- Trigger: Accident, breakdown or emergency
- Output: Request reaches the first point of contact (Dispatcher or DC Executive)

*Job: Cutover: move to the new app with minimal disruption.*

**Starts using the new app** (Both)

- Entity: People, Device
- Trigger: Driver's location is cut over
- Output: Driver active on the new app

## Mid-Mile Driver

*Job: Show up and drive consignments between locations, safely and on time.*

**Drives the consignment from the origin to the destination** (Both)

- Entity: Consignment, Vehicle
- Trigger: Consignment loaded on the vehicle
- Output: Consignment arrives at the destination

## WH Ops

*Job: Hand every shipment that is ready for dispatch to the Dispatcher with a scanned handover.*

**Hands ready shipments to the Dispatcher** (Forward)

- Entity: Shipment
- Trigger: Shipments ready for dispatch
- Output: Shipments with the Dispatcher

**Scans each shipment at handover** (Forward)

- Entity: Shipment, Barcode, Manifest
- Trigger: Handover to the Dispatcher
- Output: Handover recorded against the manifest

*Job: Receive every returned parcel back into the warehouse, and report damage or mismatch on arrival.*

**Receives the returned parcel** (Reverse)

- Entity: Shipment
- Trigger: Parcel arrives at the warehouse
- Output: Parcel received

**Scans the parcel on receipt** (Reverse)

- Entity: Shipment, Barcode, Manifest
- Trigger: Parcel received
- Output: Receipt recorded against the manifest

**Reports damage or mismatch** (Reverse)

- Entity: Shipment, Manifest
- Trigger: Damage or mismatch found on arrival
- Output: Reported against the shipment

## Dispatcher

**Flow 1: via DC**

*Job: Collate and sort ready shipments by destination DC, create consignments and send them on time. Record the vendor, vehicle number, and the driver's name and phone against each consignment, load it and scan the handover.*

**Collates ready shipments by destination DC** (Forward)

- Entity: Shipment
- Trigger: Shipments received from WH Ops
- Output: Shipments grouped by destination DC

**Sorts shipments into bins by destination** (Forward)

- Entity: Sorting Bin, Shipment
- Trigger: Shipments collated
- Output: Shipments held in the right bin

**Scans shipments into a consignment** (Forward)

- Entity: Consignment, Shipment, Barcode
- Trigger: Shipments sorted for a destination DC
- Output: Consignment and manifest created

**Records the vendor, vehicle number, and the driver's name and phone** (Forward)

- Entity: Consignment, Vendor, Vehicle
- Trigger: Mid-mile vehicle arrives for loading
- Output: Details recorded against the consignment

**Loads the consignment and scans the handover** (Forward)

- Entity: Consignment, Barcode, Manifest
- Trigger: Details recorded
- Output: Consignment dispatched; handover recorded

*Job: Plan mid-mile trips with the Team Lead so consignments leave on time.*

**Plans mid-mile departures with the Team Lead** (Both)

- Entity: Consignment, Vendor
- Trigger: Consignments due to move
- Output: Departure plan agreed

*Job: Flag any loss, damage or delay of a consignment in transit.*

**Flags a consignment as lost, damaged or delayed** (Both)

- Entity: Consignment
- Trigger: Consignment is late, damaged or missing
- Output: Flag raised against the consignment, its vendor and driver

*Job: See the live location of mid-mile vehicles on a portal.*

**Views the live location of a mid-mile vehicle** (Both)

- Entity: Vehicle, Consignment
- Trigger: Consignment in transit
- Output: Dispatcher sees where the vehicle is

**Flow 2: direct from the warehouse**

*Job: Batch shipments, plan routes and allocate Last Mile Drivers, and hand over with a scan.*

**Batches shipments** (Forward)

- Entity: Shipment
- Trigger: Shipments ready for direct delivery
- Output: Delivery batches formed

**Plans the route for each batch** (Forward)

- Entity: Shipment, Serviced Location
- Trigger: Batches formed
- Output: Route set for each batch

**Allocates a Last Mile Driver to each batch** (Forward)

- Entity: People, Shipment
- Trigger: Routes planned and drivers on duty
- Output: Batch assigned to a driver

**Hands the batch to the driver and scans the handover** (Forward)

- Entity: Shipment, Barcode, Manifest
- Trigger: Driver arrives at the warehouse
- Output: Handover recorded

**Both flows**

*Job: Make sure each shipment takes the right path, via DC or direct.*

**Confirms the path for each shipment** (Forward)

- Entity: Shipment, Serving Location
- Trigger: Shipment arrives for dispatch
- Output: Shipment goes via DC or direct

*Job: Add gel packs to every order that needs them, so medicines do not spoil.*

**Adds gel packs to orders that need them** (Forward)

- Entity: Order, Shipment
- Trigger: Order needing cold-chain protection is ready
- Output: Gel packs added

*Job: Schedule return pickups and failed-delivery returns without delay.*

**Schedules a return pickup from the Customer** (Reverse)

- Entity: Shipment, Order
- Trigger: Customer return requested
- Output: Pickup scheduled

**Schedules the return of a failed delivery** (Reverse)

- Entity: Shipment
- Trigger: Delivery failed
- Output: Return scheduled

*Job: Reassign shipments quickly when a driver can't complete their batch, a delivery fails, or an order is cancelled or changed after dispatch.*

**Reassigns the batch to another driver** (Forward)

- Entity: Shipment, People
- Trigger: Driver cannot complete the batch
- Output: Batch moved to another driver

**Reassigns a shipment after a failed delivery** (Forward)

- Entity: Shipment
- Trigger: Delivery failed
- Output: Shipment reassigned

**Removes or updates a shipment** (Forward)

- Entity: Order, Shipment
- Trigger: Order cancelled or changed after dispatch
- Output: Shipment taken off or updated in its batch

*Job: Keep a healthy pool of drivers at the warehouse.*

**Reviews the drivers on duty against the day's shipments** (Forward)

- Entity: People, Shipment
- Trigger: Start of day
- Output: Shortfall or surplus of drivers known

*Job: Onboard the warehouse's Last Mile Drivers and keep their details current.*

**Onboards a Last Mile Driver** (Both)

- Entity: People
- Trigger: New driver joins
- Output: Driver record created and activated

**Updates a driver's details** (Both)

- Entity: People
- Trigger: Driver's details change
- Output: Record updated

*Job: Settle payout disputes raised by the warehouse's drivers.*

**Reviews a payout dispute** (Both)

- Entity: Ticket, Money
- Trigger: Driver raises a dispute
- Output: Dispute understood

**Settles the dispute and informs the driver** (Both)

- Entity: Ticket, Money
- Trigger: Review complete
- Output: Dispute closed with an outcome

**Escalates a dispute to Central Logistics Ops** (Both)

- Entity: Ticket
- Trigger: Dispute cannot be settled
- Output: Dispute passed on

*Job: Be the first point of contact for drivers on the road in the direct flow.*

**Responds to a driver's help request** (Forward)

- Entity: Ticket
- Trigger: Driver raises a help request
- Output: Driver supported

## DC Executive

*Job: Receive consignments arriving on the mid-mile vehicle, scan and unload them, and catch anything missing, damaged or mismatched.*

**Receives the consignment from the vehicle** (Forward)

- Entity: Consignment, Vehicle
- Trigger: Mid-mile vehicle arrives
- Output: Consignment received

**Scans and unloads the consignment** (Forward)

- Entity: Consignment, Shipment, Barcode, Manifest
- Trigger: Consignment received
- Output: Receipt recorded against the manifest

**Flags anything missing, damaged or mismatched** (Forward)

- Entity: Shipment, Consignment, Manifest
- Trigger: Scan does not match the manifest, or damage is seen
- Output: Discrepancy recorded

*Job: Flag any loss, damage or delay of a consignment in transit.*

**Flags a consignment as lost, damaged or delayed** (Both)

- Entity: Consignment
- Trigger: Consignment is late, damaged or missing
- Output: Flag raised against the consignment, its vendor and driver

*Job: See the live location of mid-mile vehicles on a portal.*

**Views the live location of a mid-mile vehicle** (Both)

- Entity: Vehicle, Consignment
- Trigger: Consignment in transit to the DC
- Output: DC Executive sees where the vehicle is

*Job: Sort every shipment into the right bin, and hand sorted batches to Last Mile Drivers with a scanned handover.*

**Sorts each shipment into its bin** (Forward)

- Entity: Sorting Bin, Shipment
- Trigger: Shipment unloaded
- Output: Shipment held in the bin the system shows

**Hands the sorted batch to a driver and scans the handover** (Forward)

- Entity: Shipment, Barcode, Manifest
- Trigger: Driver arrives at the DC
- Output: Handover recorded

*Job: Keep the DC's Last Mile Drivers ready and accounted for each day.*

**Checks the drivers on duty** (Both)

- Entity: People
- Trigger: Start of day
- Output: Drivers ready for batching

**Confirms each driver is accounted for** (Both)

- Entity: People
- Trigger: End of day
- Output: Every driver accounted for

*Job: Receive returns and failed deliveries from drivers, and release them back towards the warehouse.*

**Receives returned parcels from drivers and scans them** (Reverse)

- Entity: Shipment, Barcode, Manifest
- Trigger: Driver brings a parcel back
- Output: Receipt recorded

**Releases returned parcels towards the warehouse** (Reverse)

- Entity: Shipment
- Trigger: Returned parcels held at the DC
- Output: Parcels sent back

*Job: Collect, record and bank the cash handed in, and escalate any mismatch.*

**Receives cash from drivers** (Forward)

- Entity: Money
- Trigger: Driver hands cash in
- Output: Cash received

**Records the cash collected** (Forward)

- Entity: Money
- Trigger: Cash received
- Output: Amount recorded against the driver and shipments

**Deposits the cash in the bank** (Forward)

- Entity: Money
- Trigger: Cash recorded
- Output: Deposit made and recorded for Finance approval

**Escalates a mismatch** (Forward)

- Entity: Money, Ticket
- Trigger: Cash differs from what was owed
- Output: Mismatch raised

*Job: Onboard the DC's Last Mile Drivers and keep their details current.*

**Onboards a Last Mile Driver** (Both)

- Entity: People
- Trigger: New driver joins
- Output: Driver record created and activated

**Updates a driver's details** (Both)

- Entity: People
- Trigger: Driver's details change
- Output: Record updated

*Job: Settle payout disputes raised by the DC's drivers.*

**Reviews a payout dispute** (Both)

- Entity: Ticket, Money
- Trigger: Driver raises a dispute
- Output: Dispute understood

**Settles the dispute and informs the driver** (Both)

- Entity: Ticket, Money
- Trigger: Review complete
- Output: Dispute closed with an outcome

**Escalates a dispute to Central Logistics Ops** (Both)

- Entity: Ticket
- Trigger: Dispute cannot be settled
- Output: Dispute passed on

*Job: Assign and recover devices and vehicles, and handle a lost or broken device.*

**Assigns a device and a vehicle to a driver** (Both)

- Entity: Device, Vehicle, People
- Trigger: Driver joins or starts duty
- Output: Recorded against the driver

**Recovers the device and vehicle** (Both)

- Entity: Device, Vehicle, People
- Trigger: Driver leaves or returns the equipment
- Output: Recorded as returned

**Handles a lost or broken device** (Both)

- Entity: Device
- Trigger: Device is lost or broken
- Output: Device marked and a replacement assigned

*Job: Be the first point of contact for drivers at the DC.*

**Responds to a driver's help request** (Both)

- Entity: Ticket
- Trigger: Driver raises a help request
- Output: Driver supported

## Team Lead

*Job: Keep enough drivers on shift for the city's orders, with cover for leave and absences.*

**Reviews drivers on shift against the city's expected orders** (Both)

- Entity: People, Order
- Trigger: Before each shift
- Output: Gaps identified

**Arranges cover for leave and absences** (Both)

- Entity: People
- Trigger: Driver on leave or absent
- Output: Cover arranged

*Job: Spot and fix delivery problems in the city before they become complaints.*

**Reviews delivery problems in the city** (Both)

- Entity: Shipment
- Trigger: Delays or failures arise
- Output: Problems identified

**Takes action on a delivery problem** (Both)

- Entity: Shipment
- Trigger: Problem identified
- Output: Problem resolved

*Job: Plan mid-mile trips with the Dispatcher.*

**Plans mid-mile departures with the Dispatcher** (Both)

- Entity: Consignment, Vendor
- Trigger: Consignments due to move
- Output: Departure plan agreed

*Job: Manage the city's drivers: document checks and renewals, suspension and exit, and performance.*

**Checks a driver's documents** (Both)

- Entity: People
- Trigger: Onboarding or renewal due
- Output: Documents verified or flagged

**Suspends a driver** (Both)

- Entity: People
- Trigger: Reason to suspend
- Output: Driver cannot take work

**Exits a driver** (Both)

- Entity: People
- Trigger: Driver leaves
- Output: Record closed

**Reviews a driver's performance** (Both)

- Entity: People, Shipment
- Trigger: Periodic review
- Output: Performance known

*Job: Settle payout disputes raised by the city's drivers.*

**Reviews a payout dispute** (Both)

- Entity: Ticket, Money
- Trigger: Driver raises a dispute
- Output: Dispute understood

**Settles the dispute and informs the driver** (Both)

- Entity: Ticket, Money
- Trigger: Review complete
- Output: Dispute closed with an outcome

**Escalates a dispute to Central Logistics Ops** (Both)

- Entity: Ticket
- Trigger: Dispute cannot be settled
- Output: Dispute passed on

*Job: Manage the city's users and their access.*

**Creates a user and assigns a role** (Both)

- Entity: People
- Trigger: New user needed
- Output: User active with the role's access

**Changes or removes a user's access** (Both)

- Entity: People
- Trigger: Role change or exit
- Output: Access updated

*Job: Onboard and manage vendors.*

**Onboards a vendor** (Both)

- Entity: Vendor
- Trigger: New vendor engaged
- Output: Vendor record created

**Updates or deactivates a vendor** (Both)

- Entity: Vendor
- Trigger: Details change or engagement ends
- Output: Record updated

*Job: Keep the city's vehicles and devices accounted for.*

**Reviews the city's vehicles and devices** (Both)

- Entity: Vehicle, Device
- Trigger: Periodic review
- Output: Anything missing identified

*Job: Plan the city's capacity as new locations open.*

**Plans drivers and DC capacity for a new location** (Both)

- Entity: Serving Location, People
- Trigger: New location planned
- Output: Capacity plan ready

*Job: Investigate loss, fraud and cash anomalies in the city.*

**Investigates a loss, fraud or cash anomaly** (Both)

- Entity: Shipment, Consignment, Money
- Trigger: Flag raised by the system or by staff
- Output: Findings recorded

*Job: Cutover: train drivers, run the new system alongside Shipsy, and roll back if needed.*

**Trains drivers on the new app** (Both)

- Entity: People
- Trigger: Location nears cutover
- Output: Drivers trained

**Runs the location on the new system alongside Shipsy** (Both)

- Entity: Serving Location
- Trigger: Cutover begins
- Output: Both systems run in parallel

**Rolls the location back to Shipsy** (Both)

- Entity: Serving Location
- Trigger: Cutover does not meet its criteria
- Output: Location back on Shipsy

## Central Logistics Ops

*Job: See country-wide performance and step in where it drops.*

**Views performance across the country** (Both)

- Entity: Shipment, Serving Location
- Trigger: Any time
- Output: Performance visible by location

**Steps in where performance drops** (Both)

- Entity: Serving Location
- Trigger: Performance drops
- Output: Action taken at the location

*Job: Set up cities, locations, serviceable areas and the links between warehouses and DCs, including which locations use the direct flow and which use the DC flow.*

**Creates a city and its serving locations** (Both)

- Entity: Serving Location
- Trigger: Expansion to a new city
- Output: City and locations set up

**Defines the serviced locations each serving location covers** (Both)

- Entity: Serviced Location, Serving Location
- Trigger: Location set up or coverage changes
- Output: Coverage recorded

**Links warehouses and DCs** (Both)

- Entity: Serving Location
- Trigger: Locations set up
- Output: Links recorded

**Sets whether a location uses the direct flow or the DC flow** (Forward)

- Entity: Serving Location
- Trigger: Location set up
- Output: Flow recorded for the location

*Job: Define the rules the system runs on: SLAs, batching, allocation, delivery attempts, cut-offs, and pay, incentives and penalties.*

**Defines SLAs** (Both)

- Entity: Shipment
- Trigger: New or changed SLA
- Output: SLAs applied by the system

**Defines batching and allocation rules** (Forward)

- Entity: Shipment, People
- Trigger: New or changed rule
- Output: Rules applied by the system

**Defines delivery attempts and cut-offs** (Both)

- Entity: Shipment
- Trigger: New or changed rule
- Output: Rules applied by the system

**Defines pay, incentives and penalties** (Both)

- Entity: Money
- Trigger: New or changed rule
- Output: Rules applied by the system

*Job: Manage roles and access across the system.*

**Defines roles and what each can do** (Both)

- Entity: People
- Trigger: New role needed
- Output: Role available

**Assigns roles to users** (Both)

- Entity: People
- Trigger: New user or role change
- Output: Access updated

*Job: Forecast demand and plan drivers and DC capacity for growth from 39 to 150 locations.*

**Forecasts demand by location** (Both)

- Entity: Order, Serving Location
- Trigger: Planning cycle
- Output: Demand forecast

**Plans drivers and DC capacity** (Both)

- Entity: People, Serving Location
- Trigger: Forecast ready
- Output: Capacity plan

*Job: Detect and act on fraud and leakage patterns.*

**Reviews fraud and leakage patterns** (Both)

- Entity: Shipment, Money
- Trigger: Periodic review or system flag
- Output: Patterns identified

**Acts on a pattern** (Both)

- Entity: Shipment, Money
- Trigger: Pattern identified
- Output: Action taken

*Job: Settle payout disputes that the Dispatcher, DC Executive and Team Lead cannot.*

**Settles an escalated payout dispute** (Both)

- Entity: Ticket, Money
- Trigger: Dispute escalated
- Output: Dispute closed with an outcome

*Job: Give leadership and analytics the reports and data they need.*

**Shares reports with leadership** (Both)

- Entity: Shipment, Money
- Trigger: Reporting cycle or request
- Output: Report delivered

**Provides data to analytics** (Both)

- Entity: Shipment, Money
- Trigger: Request from analytics
- Output: Data provided

*Job: Cutover: own the location-by-location plan, including readiness criteria, go or no-go, and rollback.*

**Sets readiness criteria for a location** (Both)

- Entity: Serving Location
- Trigger: Location planned for cutover
- Output: Criteria defined

**Decides go or no-go** (Both)

- Entity: Serving Location
- Trigger: Location assessed against criteria
- Output: Decision recorded

**Decides on a rollback** (Both)

- Entity: Serving Location
- Trigger: Cutover does not meet its criteria
- Output: Rollback decided

## Finance

*Job: Make sure every rupee collected matches what was owed and is banked, approve cash deposits and close discrepancies.*

**Reviews cash collected against what was owed** (Forward)

- Entity: Money, Shipment
- Trigger: Deposit recorded
- Output: Match or discrepancy identified

**Approves a cash deposit** (Forward)

- Entity: Money
- Trigger: Deposit matches what was owed
- Output: Deposit approved

**Closes a discrepancy** (Forward)

- Entity: Money
- Trigger: Discrepancy explained or resolved
- Output: Discrepancy closed

*Job: Pay vendors accurately and on time, every month, under the pay rules.*

**Calculates the amount owed to each vendor** (Both)

- Entity: Money, Vendor
- Trigger: Month end
- Output: Monthly amount per vendor

**Pays the vendor** (Both)

- Entity: Money, Vendor
- Trigger: Amount ready
- Output: Payment made

*Job: Keep a trustworthy record of every money movement.*

**Reviews the record of money movements** (Both)

- Entity: Money
- Trigger: Periodic review
- Output: Record confirmed complete and traceable

## Grievance & Escalation Management Team

*Job: Resolve every Customer ticket quickly and fairly, escalating when needed.*

**Reviews a Customer ticket** (Both)

- Entity: Ticket
- Trigger: Customer raises a ticket
- Output: Issue understood

**Resolves the ticket and informs the Customer** (Both)

- Entity: Ticket
- Trigger: Review complete
- Output: Ticket closed with an outcome

**Escalates a ticket** (Both)

- Entity: Ticket
- Trigger: Ticket cannot be resolved
- Output: Ticket passed on

*Job: Resolve driver tickets, such as penalties, app problems and incidents.*

**Reviews a driver ticket** (Both)

- Entity: Ticket, People
- Trigger: Driver raises a ticket
- Output: Issue understood

**Resolves the ticket and informs the driver** (Both)

- Entity: Ticket
- Trigger: Review complete
- Output: Ticket closed with an outcome

*Job: Investigate incidents such as loss, damage, fraud and accidents, with the Team Lead.*

**Investigates an incident with the Team Lead** (Both)

- Entity: Ticket, Shipment, Consignment
- Trigger: Incident reported
- Output: Findings recorded

*Job: Spot patterns in tickets so recurring problems get fixed at the root.*

**Reviews tickets for recurring problems** (Both)

- Entity: Ticket
- Trigger: Periodic review
- Output: Patterns identified

**Raises a root-cause fix with the owning team** (Both)

- Entity: Ticket
- Trigger: Pattern identified
- Output: Fix requested

*Job: Keep tickets within their time limits.*

**Tracks tickets against their time limits** (Both)

- Entity: Ticket
- Trigger: Ticket open
- Output: Tickets near or past the limit identified

**Follows up on a ticket near its limit** (Both)

- Entity: Ticket
- Trigger: Ticket near its limit
- Output: Ticket moved forward

## Control Tower

*Job: Watch live deliveries independently of Logistics Ops, and call out operational failures so none are hidden.*

**Watches live deliveries** (Both)

- Entity: Shipment
- Trigger: Continuous
- Output: Operational failures spotted

**Calls out an operational failure** (Both)

- Entity: Shipment, Ticket
- Trigger: Failure spotted
- Output: Failure raised to its owner and recorded

## Customer

*Job: Know when the order will arrive, track it, and be told about changes.*

**Views the expected arrival and status of the order** (Forward)

- Entity: Order, Shipment
- Trigger: Order placed
- Output: Customer sees status

**Receives notices about changes** (Both)

- Entity: Order
- Trigger: Order changes
- Output: Customer informed

*Job: Receive the order securely and confirm it.*

**Receives the order from the driver** (Forward)

- Entity: Shipment
- Trigger: Driver arrives
- Output: Order handed over

**Confirms receipt** (Forward)

- Entity: Shipment
- Trigger: Order handed over
- Output: Delivery confirmed

*Job: Reschedule, cancel or reject a delivery easily.*

**Reschedules a delivery** (Forward)

- Entity: Shipment
- Trigger: Customer unavailable
- Output: New delivery time set

**Cancels an order** (Forward)

- Entity: Order
- Trigger: Customer no longer wants the order
- Output: Order cancelled

**Rejects a delivery at the door** (Forward)

- Entity: Shipment
- Trigger: Driver arrives
- Output: Delivery marked failed with the reason

*Job: Correct an address or phone number before delivery.*

**Updates the delivery address or phone number** (Forward)

- Entity: Order, Serviced Location
- Trigger: Details are wrong
- Output: Details updated and the driver informed

*Job: Reach the Driver, and be reached, without sharing personal numbers.*

**Calls the driver through the app** (Both)

- Entity: People
- Trigger: Customer needs to reach the driver
- Output: Call connects with both numbers masked

*Job: Pay easily.*

**Pays for the order** (Forward)

- Entity: Money, Order
- Trigger: Payment due
- Output: Payment recorded against the order

*Job: Return an order easily and know when it will be collected.*

**Requests a return** (Reverse)

- Entity: Order, Shipment
- Trigger: Customer wants to return an order
- Output: Return pickup requested

**Views the pickup time** (Reverse)

- Entity: Shipment
- Trigger: Pickup scheduled
- Output: Pickup time shown

**Hands the return to the driver** (Reverse)

- Entity: Shipment
- Trigger: Driver arrives
- Output: Return handed over

*Job: Get help when something goes wrong and raise a ticket.*

**Raises a ticket** (Both)

- Entity: Ticket
- Trigger: Something goes wrong
- Output: Ticket created

## System

*Responsibility: Receive each order with its details, and apply cancellations and changes, including after dispatch.*

**Receives an order with its details** (Both)

- Entity: Order
- Trigger: Order sent to the system
- Output: Order held

**Applies a cancellation or change** (Both)

- Entity: Order, Shipment
- Trigger: Order cancelled or changed
- Output: Order and shipment updated

*Responsibility: Create a shipment for each order and generate its AWB.*

**Creates a shipment** (Forward)

- Entity: Shipment
- Trigger: Order received
- Output: Shipment created

**Generates the AWB** (Forward)

- Entity: Shipment
- Trigger: Shipment created
- Output: AWB assigned to the shipment

*Responsibility: Decide each shipment's path (via DC or direct) from the rules.*

**Decides the path** (Forward)

- Entity: Shipment, Serving Location
- Trigger: Shipment created
- Output: Shipment routed via DC or direct

*Responsibility: Keep every shipment's status and location current.*

**Updates status and location** (Both)

- Entity: Shipment
- Trigger: Every scan or event
- Output: Status and location current

*Responsibility: Generate barcodes for shipments and consignments.*

**Generates a barcode** (Both)

- Entity: Barcode, Shipment, Consignment
- Trigger: Shipment or consignment created
- Output: Barcode available to print or display

*Responsibility: Resolve every scan to the right entity, and reject invalid or duplicate scans.*

**Resolves a scan to its entity** (Both)

- Entity: Barcode
- Trigger: Scan received
- Output: Entity identified

**Rejects an invalid or duplicate scan** (Both)

- Entity: Barcode
- Trigger: Scan is invalid or a duplicate
- Output: Scan rejected and the user told

*Responsibility: Generate a manifest for every handover, record the scans against it, and flag anything missing or mismatched.*

**Generates a manifest** (Both)

- Entity: Manifest
- Trigger: Handover begins
- Output: Manifest lists the items to hand over

**Records scans against the manifest** (Both)

- Entity: Manifest, Barcode
- Trigger: Scan during handover
- Output: Scan recorded

**Flags missing or mismatched items** (Both)

- Entity: Manifest
- Trigger: Handover ends with differences
- Output: Differences flagged to the people involved

*Responsibility: Create consignments by grouping shipments by destination DC.*

**Creates a consignment** (Forward)

- Entity: Consignment, Shipment
- Trigger: Shipments scanned into a consignment
- Output: Consignment created with its manifest

*Responsibility: Record the vendor, vehicle number, and the driver's name and phone against each consignment. No driver profile is kept.*

**Records the vendor, vehicle and driver details** (Forward)

- Entity: Consignment, Vendor, Vehicle
- Trigger: Dispatcher enters the details at loading
- Output: Details held against the consignment

*Responsibility: Show live mid-mile vehicle location from IoT devices.*

**Shows the live location of a vehicle** (Both)

- Entity: Vehicle
- Trigger: Consignment in transit
- Output: Location visible to the Dispatcher and DC Executive

*Responsibility: Tell the DC Executive which bin each shipment belongs in, and keep track of what each bin holds.*

**Shows which bin a shipment belongs in** (Forward)

- Entity: Sorting Bin, Shipment
- Trigger: Shipment scanned at the DC
- Output: Bin shown

**Tracks bin contents** (Forward)

- Entity: Sorting Bin
- Trigger: Shipment placed in or taken from a bin
- Output: Bin contents current

*Responsibility: Create delivery batches and routes, allocate Last Mile Drivers, and send the orders to the Driver's app.*

**Creates delivery batches** (Forward)

- Entity: Shipment
- Trigger: Shipments ready and drivers on duty
- Output: Batches formed

**Creates routes** (Forward)

- Entity: Shipment, Serviced Location
- Trigger: Batches formed
- Output: Route set for each batch

**Allocates Last Mile Drivers** (Forward)

- Entity: People, Shipment
- Trigger: Batches and routes ready
- Output: Batch assigned to a driver

**Sends the orders to the driver's app** (Forward)

- Entity: Shipment, Device
- Trigger: Batch allocated
- Output: Orders appear on the driver's app

*Responsibility: Show medicine details to the Last Mile Driver only in the returns flow.*

**Shows medicine details on a return pickup** (Reverse)

- Entity: Order, Shipment
- Trigger: Return pickup assigned
- Output: Medicine details visible to the driver

*Responsibility: Keep driver apps working offline, and sync when the network returns.*

**Holds actions taken offline and syncs them** (Both)

- Entity: Device, Shipment
- Trigger: Network lost, then restored
- Output: Actions sent and statuses updated

*Responsibility: Hold serving locations and serviced locations. In Forward, serving locations are warehouses and DCs, and serviced locations are Customers' locations. In Reverse, they flip.*

**Holds serving and serviced locations** (Both)

- Entity: Serving Location, Serviced Location
- Trigger: Locations set up
- Output: Locations available, flipped for Reverse

*Responsibility: Hold the links between warehouses and DCs, and which flow each location uses.*

**Holds the links and the flow per location** (Both)

- Entity: Serving Location
- Trigger: Central Logistics Ops sets them
- Output: Links and flows available

*Responsibility: Hold users, drivers, Customers and their details, and enforce who can do what.*

**Holds users, drivers and Customers** (Both)

- Entity: People
- Trigger: Record created or updated
- Output: Details held

**Enforces who can do what** (Both)

- Entity: People
- Trigger: Any access attempt
- Output: Allowed or blocked by role

*Responsibility: Register devices and record which driver holds each one.*

**Registers a device and records its holder** (Both)

- Entity: Device, People
- Trigger: Device assigned to a driver
- Output: Device and holder recorded

*Responsibility: Mask phone numbers between Customers and Drivers.*

**Masks phone numbers on a call** (Both)

- Entity: People
- Trigger: Call between a Customer and a driver
- Output: Call connects without exposing numbers

*Responsibility: Record every payment collected, every cash handover and every deposit, and match them against what was owed.*

**Records payments, cash handovers and deposits** (Forward)

- Entity: Money
- Trigger: Each money movement
- Output: Movement recorded

**Matches them against what was owed** (Forward)

- Entity: Money, Shipment
- Trigger: Deposit recorded
- Output: Match or discrepancy shown

*Responsibility: Record vendor payments.*

**Records a vendor payment** (Both)

- Entity: Money, Vendor
- Trigger: Finance pays a vendor
- Output: Payment recorded

*Responsibility: Hold vendors and their vehicles.*

**Holds vendors and their vehicles** (Both)

- Entity: Vendor, Vehicle
- Trigger: Vendor onboarded or vehicle recorded
- Output: Records held

*Responsibility: Raise, route and track tickets to resolution within their time limits.*

**Raises and routes a ticket** (Both)

- Entity: Ticket
- Trigger: Ticket created
- Output: Ticket reaches the right owner

**Tracks a ticket to resolution** (Both)

- Entity: Ticket
- Trigger: Ticket open
- Output: Status and time limit tracked

*Responsibility: Send the right notices to the right people at the right time.*

**Sends a notice** (Both)

- Entity: Order, Shipment, Ticket
- Trigger: Event that needs a notice
- Output: Notice reaches the right person

*Responsibility: Detect failures and fraud signals: missed scans, delays, mismatches, cash anomalies, and deliveries marked from the wrong place.*

**Detects a failure or fraud signal** (Both)

- Entity: Shipment, Money
- Trigger: Missed scan, delay, mismatch, cash anomaly or delivery marked from the wrong place
- Output: Flag raised to the right actor

*Responsibility: Keep a full audit trail of every scan and change.*

**Records every scan and change** (Both)

- Entity: Shipment, Barcode, People
- Trigger: Any scan or change
- Output: Audit entry recorded

*Responsibility: Hold and apply the rules.*

**Applies the rules** (Both)

- Entity: Shipment, Money
- Trigger: Any event the rules cover
- Output: Rule applied

*Responsibility: Provide reports and a data feed.*

**Provides reports and a data feed** (Both)

- Entity: Shipment, Money
- Trigger: Report or data requested
- Output: Report or data delivered

*Responsibility: Switch a location between Shipsy and the new system, and roll back, during cutover.*

**Switches a location between Shipsy and the new system** (Both)

- Entity: Serving Location
- Trigger: Go decision for a location
- Output: Location runs on the new system

**Rolls a location back to Shipsy** (Both)

- Entity: Serving Location
- Trigger: Rollback decision
- Output: Location runs on Shipsy again
