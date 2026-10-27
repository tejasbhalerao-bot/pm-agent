# Milestones

The milestone plan. Each initiative sits under the milestone that builds it and carries a one-line description, a category and the story-map cards it delivers. Cutover Parity matches what Shipsy does today; Enhancement goes beyond Shipsy. A card that an initiative only partly delivers is marked with the part it covers. Card numbers match the story map page.

## Milestone 1

14 initiatives: 9 Cutover Parity, 5 Enhancement.

| # | Initiative | Description | Category | Cards on story map |
|---|---|---|---|---|
| M1.1 | User Management | Create users, assign roles and control what each can do. | Cutover Parity | #4 Sets up users and their access |
| M1.2 | Driver Management | Create and manage drivers with their vehicles, vendors and serviceable areas, including suspension and exit. | Cutover Parity | #5 Onboards vendors; #6 Onboards a driver; #7 Sets the driver's serviceability; #9 Looks after the driver |
| M1.3 | Duty Start & End | Drivers mark when they start and end their shift, and DC Executives confirm each driver is accounted for. | Enhancement | #12 Starts the shift; #34 Ends the shift |
| M1.4 | Order Intake, AWB Generation & Print | Receive orders from the order system, create the shipment, generate the AWB and print it. | Cutover Parity | #13 Receives the order and creates the shipment; #14 Generates the AWB and decides the path; #15 Prints the AWB |
| M1.5 | Handover Validation | Scan every handover from the warehouse to the Customer, forward and return, so each shipment's whereabouts are known. | Enhancement | #16 Hands the shipments to the Dispatcher; #22 Loads the consignment and scans the handover (only: Scans the handover); #24 Receives and unloads the consignment (only: Scans in at the DC); #25 Sorts each shipment into its bin; #28 Scans the orders the driver brings; #45 Receives the returns and sends them on (only: Scans returned parcels in); #47 Receives the returned consignment and hands it over (only: Scans at each handover); #48 Receives the returned parcel (only: Scans the parcel on receipt) |
| M1.6 | System Assisted Driver Allocation | A Dispatcher or DC Executive creates a batch by hand and gives it to the driver in front of them from the CRM portal, with the system assisting. | Cutover Parity | #26 Creates batches and routes and allocates drivers (only: Creates batches by hand, allocates drivers, sends the orders to the driver's app) |
| M1.7 | Manual Trip Replanning | A Dispatcher or DC Executive changes a driver's trip by hand when plans change. | Cutover Parity | #26 Creates batches and routes and allocates drivers (only: Triggers a replan, accepts the new plan or rearranges it) |
| M1.8 | Trip Flow | Drivers view their orders, navigate, call the Customer, complete deliveries and capture proof of delivery. | Cutover Parity | #27 Views the batch and picks the orders from the bin; #29 Follows the route to the Customer; #31 Receives the order and confirms; #32 Collects proof of delivery; #33 Pays for the order |
| M1.9 | Delivery Reschedule Flow | Reschedule a delivery when the Customer asks and replan it for the new day. | Cutover Parity | #31 Receives the order and confirms (only: Reschedules a delivery); #40 Replans the delivery for the next day (only: Replans the delivery for the new day) |
| M1.10 | Dynamic QR | Give each order its own payment QR so a Customer can pay by QR. | Enhancement | #33 Pays for the order (only: Pays for the order by QR) |
| M1.11 | COD Reconciliation Module | Record the cash drivers collect, track it to the bank and match it against what was owed. | Enhancement | #35 Hands cash in; #36 Records and banks the cash; #37 Matches and approves the cash |
| M1.12 | Delivery Failed & RTO Management | Record why a delivery failed, decide between a reattempt and a return to origin, and replan or schedule the return. | Cutover Parity | #38 Marks the delivery failed; #39 Decides between a reattempt and an RTO; #40 Replans the delivery for the next day; #41 Schedules the return |
| M1.13 | Return Flow | Take a Customer's return from request to pickup to the parcel back at the warehouse. | Cutover Parity | #42 Requests a return; #43 Schedules the pickup; #44 Collects the return; #45 Receives the returns and sends them on; #47 Receives the returned consignment and hands it over; #48 Receives the returned parcel |
| M1.14 | Address Quality Interventions | Capture where each order was delivered and store it against the address. | Enhancement | None |

## Milestone 2

8 initiatives: 0 Cutover Parity, 8 Enhancement.

| # | Initiative | Description | Category | Cards on story map |
|---|---|---|---|---|
| M2.1 | Driver & Vendor Payout | Compute driver earnings, roll them up per vendor and work out what each vendor is owed, with pay disputes settled in the system. | Enhancement | #3 Defines driver pay and incentives (only: Defines salary structures); #8 Agrees the driver's pay structure; #49 Computes earnings and tracks incentive progress (only: Computes a driver's earnings); #52 Rolls driver earnings up per vendor; #53 Calculates what each vendor is owed; #56 Raises a payout dispute; #57 Settles the dispute |
| M2.2 | Incentives | Define incentive schemes, track each driver's progress and grant incentives. | Enhancement | #3 Defines driver pay and incentives (only: Defines incentive schemes); #49 Computes earnings and tracks incentive progress (only: Tracks incentive progress); #50 Grants incentives to drivers; #51 Sees earnings and incentive progress |
| M2.3 | Attendance Tracking | Track who is on duty against each location's expected orders and arrange cover for absences. | Enhancement | #11 Keeps enough drivers on shift |
| M2.4 | Batch Creation | The system groups orders and return pickups into batches. | Enhancement | #26 Creates batches and routes and allocates drivers (only: Creates delivery batches) |
| M2.5 | Route Optimisation | The system sequences each batch's stops into a route. | Enhancement | #26 Creates batches and routes and allocates drivers (only: Creates routes) |
| M2.6 | Automated Driver Allocation | The system allocates batches to drivers without a person choosing. | Enhancement | #26 Creates batches and routes and allocates drivers (only: Allocates Last Mile Drivers) |
| M2.7 | Automated Replanning | The system replans the affected batches and routes when a delivery fails or plans change. | Enhancement | #26 Creates batches and routes and allocates drivers (only: Replans the affected batches and routes); #40 Replans the delivery for the next day (only: Replans a failed delivery for the next day) |
| M2.8 | Reverse QC | The driver checks the returned medicine against the order at pickup. | Enhancement | #44 Collects the return (only: Checks the medicine against the order details) |

## Milestone 3

3 initiatives: 0 Cutover Parity, 3 Enhancement.

| # | Initiative | Description | Category | Cards on story map |
|---|---|---|---|---|
| M3.1 | Mid-Mile Journey Orchestration | Plan, record and track consignments from the warehouse to the DC and back. | Enhancement | #18 Sorts shipments by destination DC; #20 Plan the trip together; #21 Records the vendor, vehicle and driver; #23 Drives the consignment to the DC; #46 Drives the consignment to the warehouse |
| M3.2 | Consignment Capture | Build, load and receive consignments in the system. | Enhancement | #19 Builds the consignment; #22 Loads the consignment and scans the handover (only: Loads the consignment); #24 Receives and unloads the consignment (only: Receives the consignment); #45 Receives the returns and sends them on (only: Sends returned shipments back as a consignment); #47 Receives the returned consignment and hands it over (only: Receives the returned consignment) |
| M3.3 | Geofencing | Check the driver is at the Customer's location when they deliver, mark a delivery failed or collect a return. | Enhancement | #32 Collects proof of delivery (only: At delivery); #38 Marks the delivery failed (only: At a failed delivery); #44 Collects the return (only: At a return pickup) |

## Scoped out for the future

5 initiatives: 0 Cutover Parity, 5 Enhancement.

| # | Initiative | Description | Category | Cards on story map |
|---|---|---|---|---|
| F.1 | Device Assignment | Assign a device to each driver and recover it when they leave. | Enhancement | #6 Onboards a driver (only: Assigns a device, registers a device and its holder); #9 Looks after the driver (only: Recovers the device, handles a lost or broken device) |
| F.2 | Capacity Planning | Forecast demand by location and plan drivers and DC capacity. | Enhancement | #10 Plans the capacity |
| F.3 | Cold Chain Flagging | Flag orders that need gel packs so the Dispatcher adds them. | Enhancement | #17 Adds gel packs where needed |
| F.4 | Customer Tracking & Notices | Customers see where their order is and get notices about changes. | Enhancement | #30 Tracks the order |
| F.5 | Grievance & Driver Support | Customers and drivers raise tickets and ask for help, and the Grievance team resolves them within time limits. | Enhancement | #55 Asks for help on the road; #58 Raises a ticket; #59 Resolves the ticket; #60 Keeps tickets within their time limits; #61 Fixes the root cause |

## Not in any initiative

- #1 Creates the locations: already built.
- #2 Defines the rules the system runs on: rules are set within each initiative, where the business can adjust them.
- #54 Pays the vendor: done manually for the foreseeable future.
- #62 Watches live deliveries and calls out failures: monitoring and reporting ship with each initiative.
- #63 Reviews performance and fixes problems: monitoring and reporting ship with each initiative.
- #64 Investigates loss, fraud and anomalies: monitoring and reporting ship with each initiative.
- #65 Shares reports and data: monitoring and reporting ship with each initiative.
