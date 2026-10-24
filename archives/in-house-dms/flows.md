# Flows

The flows of the system. Each flow is a sequence of activities. Under each activity, the events of the happy path come first, followed by exceptions. Events point to the actions they cover as Actor: Action.

## 1. Geography and Rules Setup

**Band:** Setup · **Vertical:** Both

**Starts:** Central Logistics Ops sets up a new city or changes a rule.

**Ends:** The System holds the setup and applies it.

### Set up the network

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Central Logistics Ops | Creates a city and its serving locations | Central Logistics Ops: Creates a city and its serving locations |
| Event | Central Logistics Ops | Defines the serviced locations each serving location covers | Central Logistics Ops: Defines the serviced locations each serving location covers |
| Event | Central Logistics Ops | Links warehouses and DCs | Central Logistics Ops: Links warehouses and DCs |
| Event | Central Logistics Ops | Sets whether a location uses the direct flow or the DC flow | Central Logistics Ops: Sets whether a location uses the direct flow or the DC flow |
| Event | System | Holds the locations, the links and the flow per location | System: Holds serving and serviced locations; System: Holds the links and the flow per location |

### Define the rules

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Central Logistics Ops | Defines SLAs | Central Logistics Ops: Defines SLAs |
| Event | Central Logistics Ops | Defines batching and allocation rules | Central Logistics Ops: Defines batching and allocation rules |
| Event | Central Logistics Ops | Defines delivery attempts and cut-offs | Central Logistics Ops: Defines delivery attempts and cut-offs |
| Event | Central Logistics Ops | Defines pay, incentives and penalties | Central Logistics Ops: Defines pay, incentives and penalties |
| Event | System | Applies the rules | System: Applies the rules |

## 2. User Management

**Band:** Setup · **Vertical:** Both

**Starts:** A new user is needed, or a role or access changes.

**Ends:** The user has the right access.

### Define roles

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Central Logistics Ops | Defines roles and what each can do | Central Logistics Ops: Defines roles and what each can do |
| Event | Central Logistics Ops | Assigns roles to users | Central Logistics Ops: Assigns roles to users |

### Add users

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Team Lead | Creates a user and assigns a role | Team Lead: Creates a user and assigns a role |
| Event | System | Holds the user's details | System: Holds users, drivers and Customers |

### Change access

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Team Lead | Changes or removes a user's access | Team Lead: Changes or removes a user's access |
| Event | System | Enforces who can do what | System: Enforces who can do what |

## 3. Vendor Management

**Band:** Setup · **Vertical:** Both

**Starts:** A new vendor is engaged, or an existing vendor changes.

**Ends:** The vendor record is current.

### Onboard the vendor

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Team Lead | Onboards a vendor | Team Lead: Onboards a vendor |
| Event | System | Holds the vendor and its vehicles | System: Holds vendors and their vehicles |

### Keep the vendor current

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Team Lead | Updates or deactivates a vendor | Team Lead: Updates or deactivates a vendor |

## 4. Driver Management

**Band:** Setup · **Vertical:** Both

**Starts:** A new Last Mile Driver joins.

**Ends:** The driver exits.

### Onboard the driver

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | DC Executive / Dispatcher | Onboards a Last Mile Driver | DC Executive: Onboards a Last Mile Driver |
| Event | Team Lead | Checks the driver's documents | Team Lead: Checks a driver's documents |

### Keep details current

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | DC Executive / Dispatcher | Updates the driver's details | DC Executive: Updates a driver's details |

### Review performance

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Team Lead | Reviews the driver's performance | Team Lead: Reviews a driver's performance |

### Suspend or exit

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Team Lead | Suspends a driver | Team Lead: Suspends a driver |
| Event | Team Lead | Exits a driver | Team Lead: Exits a driver |

## 5. Asset Management

**Band:** Setup · **Vertical:** Both

**Starts:** A driver needs a device and a vehicle.

**Ends:** The device and vehicle are back, or replaced.

### Assign

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | DC Executive / Dispatcher | Assigns a device and a vehicle to a driver | DC Executive: Assigns a device and a vehicle to a driver |
| Event | System | Registers the device and records its holder | System: Registers a device and records its holder |

### Recover

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | DC Executive / Dispatcher | Recovers the device and vehicle | DC Executive: Recovers the device and vehicle |

### Keep accounted for

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Team Lead | Reviews the city's vehicles and devices | Team Lead: Reviews the city's vehicles and devices |
| Exception | DC Executive / Dispatcher | Handles a lost or broken device | DC Executive: Handles a lost or broken device |

## 6. Capacity Planning

**Band:** Setup · **Vertical:** Both

**Starts:** A planning cycle begins, or a new location is planned.

**Ends:** A capacity plan is ready.

### Forecast demand

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Central Logistics Ops | Forecasts demand by location | Central Logistics Ops: Forecasts demand by location |

### Plan capacity

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Central Logistics Ops | Plans drivers and DC capacity | Central Logistics Ops: Plans drivers and DC capacity |
| Event | Team Lead | Plans drivers and DC capacity for a new location | Team Lead: Plans drivers and DC capacity for a new location |

## 7. Daily Shift

**Band:** Daily operations · **Vertical:** Both

**Starts:** A shift begins.

**Ends:** The shift ends and every driver is accounted for.

### Plan the shift

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Team Lead | Reviews drivers on shift against the city's expected orders | Team Lead: Reviews drivers on shift against the city's expected orders |
| Event | DC Executive / Dispatcher | Checks the drivers on duty | DC Executive: Checks the drivers on duty |
| Exception | Team Lead | Arranges cover for leave and absences | Team Lead: Arranges cover for leave and absences |

### Start duty

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Last Mile Driver | Marks duty start | Last Mile Driver: Marks duty start |
| Event | Last Mile Driver | Confirms the device and vehicle in use | Last Mile Driver: Confirms the device and vehicle in use |

### Work the shift

| Type | Actor | Event | Actions |
|---|---|---|---|
| Flow |  | Forward via DC: deliveries from a DC |  |
| Flow |  | Forward Direct: deliveries from the warehouse |  |
| Flow |  | Customer Return: pickups from Customers |  |
| Exception | Last Mile Driver | Continues working in the app without a network | Last Mile Driver: Continues working in the app without a network |
| Exception | Last Mile Driver | Syncs held actions when the network returns | Last Mile Driver: Syncs held actions |
| Exception | System | Holds actions taken offline and syncs them | System: Holds actions taken offline and syncs them |

### End duty

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Last Mile Driver | Marks duty end | Last Mile Driver: Marks duty end |
| Event | DC Executive / Dispatcher | Confirms each driver is accounted for | DC Executive: Confirms each driver is accounted for |

## 8. Forward via DC

**Band:** Daily operations · **Vertical:** Forward

**Starts:** The System generates the AWB for an order routed via a DC.

**Ends:** The order is delivered with proof of delivery.

### Receive the order

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | System | Receives the order and creates the shipment | System: Receives an order with its details; System: Creates a shipment |
| Exception | Customer | Updates the delivery address or phone number | Customer: Updates the delivery address or phone number |
| Exception | Customer | Cancels the order | Customer: Cancels an order |
| Exception | System | Applies the cancellation or change | System: Applies a cancellation or change |
| Flow |  | Replanning: an order cancelled or changed after dispatch |  |

### Prepare for dispatch

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | System | Generates the barcode and the AWB, and decides the path (via DC) | System: Generates a barcode; System: Generates the AWB; System: Decides the path |
| Event | WH Ops | Prints the AWB | WH Ops: Prints the AWB |
| Event | Dispatcher | Adds gel packs to orders that need them | Dispatcher: Adds gel packs to orders that need them |

### Hand over to the Dispatcher

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | WH Ops | Hands ready shipments to the Dispatcher | WH Ops: Hands ready shipments to the Dispatcher |
| Event | WH Ops | Scans each shipment at handover | WH Ops: Scans each shipment at handover |
| Event | System | Generates the manifest and records the scans | System: Generates a manifest; System: Records scans against the manifest |
| Exception | System | Rejects an invalid or duplicate scan | System: Rejects an invalid or duplicate scan |
| Exception | System | Flags missing or mismatched items | System: Flags missing or mismatched items |

### Build the consignment

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Dispatcher | Sorts shipments into bins by destination DC | Dispatcher: Sorts shipments into bins by destination |
| Event | Dispatcher | Scans shipments into a consignment | Dispatcher: Scans shipments into a consignment |
| Event | System | Creates the consignment with its manifest | System: Creates a consignment |

### Dispatch

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Dispatcher | Records the vendor, vehicle, and the driver's name and phone | Dispatcher: Records the vendor, vehicle number, and the driver's name and phone; System: Records the vendor, vehicle and driver details |
| Event | Dispatcher | Loads the consignment and scans the handover | Dispatcher: Loads the consignment and scans the handover |

### Travel to the DC

| Type | Actor | Event | Actions |
|---|---|---|---|
| Flow |  | Mid-Mile Movement: the consignment travels to the DC |  |

### Receive at the DC

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | DC Executive | Receives the consignment from the vehicle | DC Executive: Receives the consignment from the vehicle |
| Event | DC Executive | Scans and unloads the consignment | DC Executive: Scans and unloads the consignment |
| Exception | DC Executive | Flags anything missing, damaged or mismatched | DC Executive: Flags anything missing, damaged or mismatched |
| Flow |  | Monitoring and Investigation: a missing, damaged or mismatched consignment |  |

### Sort at the DC

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | DC Executive | Sorts each shipment into its bin | DC Executive: Sorts each shipment into its bin |
| Event | System | Shows which bin each shipment belongs in and tracks bin contents | System: Shows which bin a shipment belongs in; System: Tracks bin contents |

### Plan the deliveries

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | System | Creates batches and routes, allocates drivers, and sends the orders to the driver's app | System: Creates delivery batches; System: Creates routes; System: Allocates Last Mile Drivers; System: Sends the orders to the driver's app |
| Flow |  | Replanning: a driver who cannot complete their batch |  |

### Pick up the batch

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Last Mile Driver | Views the assigned batch and the pickup point | Last Mile Driver: Views the assigned batch and the pickup point |
| Event | Last Mile Driver | Picks the assigned orders from the bin | Last Mile Driver: Picks the assigned orders from the bin |
| Event | Last Mile Driver | Takes the orders to the DC Executive | Last Mile Driver: Takes the orders to the DC Executive |
| Event | DC Executive | Scans the orders the driver brings | DC Executive: Scans the orders the driver brings |

### Deliver

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Last Mile Driver | Views the route for the batch | Last Mile Driver: Views the route for the batch |
| Event | Customer | Tracks the order and receives notices | Customer: Views the expected arrival and status of the order; Customer: Receives notices about changes |
| Event | Last Mile Driver | Navigates to the Customer's location | Last Mile Driver: Navigates to the Customer's location |
| Event | Last Mile Driver | Calls the Customer through the app | Last Mile Driver: Calls the Customer through the app; Customer: Calls the driver through the app; System: Masks phone numbers on a call |
| Event | Customer | Receives the order and confirms receipt | Customer: Receives the order from the driver; Customer: Confirms receipt |
| Event | Last Mile Driver | Collects proof of delivery | Last Mile Driver: Collects proof of delivery |
| Exception | Customer | Reschedules the delivery | Customer: Reschedules a delivery |
| Exception | Customer | Rejects the delivery at the door | Customer: Rejects a delivery at the door |
| Flow |  | Failed Delivery: a delivery that cannot be completed |  |

### Collect payment

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Customer | Pays for the order | Customer: Pays for the order |
| Event | Last Mile Driver | Collects payment from the Customer | Last Mile Driver: Collects payment from the Customer |
| Flow |  | Cash Handling and Reconciliation: the driver hands cash in |  |

## 9. Mid-Mile Movement

**Band:** Daily operations · **Vertical:** Both

**Starts:** Consignments are due to move between locations.

**Ends:** The consignment arrives at its destination.

### Plan the trip

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Dispatcher / Team Lead | Plan mid-mile departures together | Dispatcher: Plans mid-mile departures with the Team Lead; Team Lead: Plans mid-mile departures with the Dispatcher |

### Load and send

| Type | Actor | Event | Actions |
|---|---|---|---|
| Flow |  | Forward via DC: the Dispatcher loads the consignment |  |
| Flow |  | RTO Return: the DC Executive releases the consignment towards the warehouse |  |

### Travel

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Mid-Mile Driver | Drives the consignment from the origin to the destination | Mid-Mile Driver: Drives the consignment from the origin to the destination |
| Event | System | Shows the live location of the vehicle | System: Shows the live location of a vehicle |
| Event | Dispatcher / DC Executive | View the live location of the vehicle | Dispatcher: Views the live location of a mid-mile vehicle; DC Executive: Views the live location of a mid-mile vehicle |
| Exception | Dispatcher / DC Executive | Flag a consignment as lost, damaged or delayed | Dispatcher: Flags a consignment as lost, damaged or delayed; DC Executive: Flags a consignment as lost, damaged or delayed |
| Flow |  | Monitoring and Investigation: a lost, damaged or delayed consignment |  |

### Arrive

| Type | Actor | Event | Actions |
|---|---|---|---|
| Flow |  | Forward via DC: the DC receives the consignment |  |
| Flow |  | RTO Return: the warehouse receives the consignment |  |

## 10. Forward Direct

**Band:** Daily operations · **Vertical:** Forward

**Starts:** The System routes an order to be delivered directly from the warehouse.

**Ends:** The order is delivered with proof of delivery.

### Receive, prepare and hand over

| Type | Actor | Event | Actions |
|---|---|---|---|
| Flow |  | Forward via DC: receiving the order, preparing it for dispatch and handing it to the Dispatcher |  |

### Plan the deliveries

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | System | Creates batches and routes, allocates drivers, and sends the orders to the driver's app | System: Creates delivery batches; System: Creates routes; System: Allocates Last Mile Drivers; System: Sends the orders to the driver's app |
| Flow |  | Replanning: a driver who cannot complete their batch |  |

### Pick up the batch

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Last Mile Driver | Views the assigned batch and the pickup point | Last Mile Driver: Views the assigned batch and the pickup point |
| Event | Last Mile Driver | Picks the assigned orders | Last Mile Driver: Picks the assigned orders from the bin |
| Event | Last Mile Driver | Takes the orders to the Dispatcher | Last Mile Driver: Takes the orders to the DC Executive |
| Event | Dispatcher | Scans the orders the driver brings | DC Executive: Scans the orders the driver brings |

### Deliver and collect payment

| Type | Actor | Event | Actions |
|---|---|---|---|
| Flow |  | Forward via DC: delivering the order and collecting payment |  |
| Flow |  | Failed Delivery: a delivery that cannot be completed |  |

### Hand cash in

| Type | Actor | Event | Actions |
|---|---|---|---|
| Flow |  | Cash Handling and Reconciliation: the driver hands cash in to the Dispatcher |  |

## 11. Replanning

**Band:** Daily operations · **Vertical:** Forward

**Starts:** A driver cannot complete their batch, or an order is cancelled or changed after dispatch.

**Ends:** The updated plan is confirmed.

### Trigger the replan

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | DC Executive / Dispatcher | Triggers a replan | DC Executive: Triggers a replan |
| Exception | System | Applies the cancellation or change to the order | System: Applies a cancellation or change |

### Replan

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | System | Replans the affected batches and routes | System: Replans the affected batches and routes |

### Confirm the plan

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | DC Executive / Dispatcher | Accepts the new plan or rearranges it | DC Executive: Accepts the new plan or rearranges it |

## 12. Failed Delivery

**Band:** Daily operations · **Vertical:** Forward

**Starts:** A delivery cannot be completed.

**Ends:** A reattempt is planned, or an RTO is initiated.

### Record the failure

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Last Mile Driver | Marks the delivery as failed, with a reason | Last Mile Driver: Marks the delivery as failed, with a reason |
| Event | Last Mile Driver | Brings the parcel back to the DC or warehouse | Last Mile Driver: Brings the parcel back to the DC or warehouse |

### Decide

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | System | Decides between a reattempt and an RTO | System: Decides between a reattempt and an RTO |

### Reattempt the next day

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | DC Executive / Dispatcher | Triggers a replan for the next day | DC Executive: Triggers a replan for the next day |
| Event | System | Replans the delivery for the next day | System: Replans a failed delivery for the next day |
| Event | DC Executive / Dispatcher | Accepts the new plan or rearranges it | DC Executive: Accepts the new plan or rearranges it |

### Initiate the RTO

| Type | Actor | Event | Actions |
|---|---|---|---|
| Flow |  | RTO Return: the parcel returns to the warehouse |  |

## 13. RTO Return

**Band:** Daily operations · **Vertical:** Reverse

**Starts:** An RTO is initiated for a failed delivery.

**Ends:** The warehouse has received the parcel.

### Schedule the return

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Dispatcher | Schedules the return of the failed delivery | Dispatcher: Schedules the return of a failed delivery |

### Bring the parcel back

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Last Mile Driver | Brings the parcel back to the DC or warehouse | Last Mile Driver: Brings the parcel back to the DC or warehouse |

### Receive at the DC

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | DC Executive | Receives the returned parcels from drivers and scans them | DC Executive: Receives returned parcels from drivers and scans them |
| Event | DC Executive | Scans the returned shipments into a consignment and releases it towards the warehouse | DC Executive: Scans returned shipments into a consignment and releases it towards the warehouse |
| Event | System | Creates the consignment with its manifest | System: Creates a consignment |

### Travel to the warehouse

| Type | Actor | Event | Actions |
|---|---|---|---|
| Flow |  | Mid-Mile Movement: the consignment travels to the warehouse |  |

### Receive at the warehouse

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | WH Ops | Receives the returned parcel | WH Ops: Receives the returned parcel |
| Event | WH Ops | Scans the parcel on receipt | WH Ops: Scans the parcel on receipt |
| Exception | WH Ops | Reports damage or mismatch | WH Ops: Reports damage or mismatch |
| Flow |  | Monitoring and Investigation: damage or a mismatch at the warehouse |  |

## 14. Customer Return

**Band:** Daily operations · **Vertical:** Reverse

**Starts:** A Customer wants to return a delivered order.

**Ends:** The warehouse has received the parcel.

### Request the return

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Customer | Requests a return | Customer: Requests a return |

### Schedule the pickup

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Dispatcher | Schedules a return pickup from the Customer | Dispatcher: Schedules a return pickup from the Customer |
| Event | Customer | Views the pickup time | Customer: Views the pickup time |

### Collect from the Customer

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Last Mile Driver | Views the return pickup and the medicine details | Last Mile Driver: Views the return pickup and the medicine details |
| Event | System | Shows the medicine details on the return pickup | System: Shows medicine details on a return pickup |
| Event | Last Mile Driver | Checks the medicine against the order details | Last Mile Driver: Checks the medicine against the order details |
| Event | Customer | Hands the return to the driver | Customer: Hands the return to the driver |
| Event | Last Mile Driver | Takes the parcel from the Customer | Last Mile Driver: Takes the parcel from the Customer |

### Bring back to the warehouse

| Type | Actor | Event | Actions |
|---|---|---|---|
| Flow |  | RTO Return: the parcel goes back to the warehouse |  |

## 15. Cash Handling and Reconciliation

**Band:** Money · **Vertical:** Forward

**Starts:** A driver has cash to hand in.

**Ends:** The deposit is approved and matched.

### Hand cash in

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Last Mile Driver | Hands cash in | Last Mile Driver: Hands cash in |
| Event | DC Executive / Dispatcher | Receives cash from drivers | DC Executive: Receives cash from drivers |

### Record the cash

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | DC Executive / Dispatcher | Records the cash collected | DC Executive: Records the cash collected |
| Event | System | Records payments, cash handovers and deposits | System: Records payments, cash handovers and deposits |

### Bank the cash

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | DC Executive / Dispatcher | Deposits the cash in the bank | DC Executive: Deposits the cash in the bank |

### Reconcile

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | System | Matches the cash against what was owed | System: Matches them against what was owed |
| Event | Finance | Reviews cash collected against what was owed | Finance: Reviews cash collected against what was owed |
| Event | Finance | Approves the cash deposit | Finance: Approves a cash deposit |
| Event | Finance | Reviews the record of money movements | Finance: Reviews the record of money movements |
| Exception | DC Executive / Dispatcher | Escalates a mismatch | DC Executive: Escalates a mismatch |
| Exception | Finance | Closes the discrepancy | Finance: Closes a discrepancy |
| Flow |  | Monitoring and Investigation: a cash anomaly |  |

## 16. Vendor Payouts

**Band:** Money · **Vertical:** Both

**Starts:** A month ends.

**Ends:** Each vendor is paid and the payment is recorded.

### Calculate

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Finance | Calculates the amount owed to each vendor | Finance: Calculates the amount owed to each vendor |

### Pay

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Finance | Pays the vendor | Finance: Pays the vendor |
| Event | System | Records the vendor payment | System: Records a vendor payment |

## 17. Driver Support and Payout Disputes

**Band:** Support and oversight · **Vertical:** Both

**Starts:** A driver needs help, or thinks their pay is wrong.

**Ends:** The driver is supported, or the dispute is closed.

### Get help on the road

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Last Mile Driver | Raises a help request | Last Mile Driver: Raises a help request |
| Event | DC Executive / Dispatcher | Responds to the help request | DC Executive: Responds to a driver's help request |

### Raise a payout dispute

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Last Mile Driver | Raises a payout dispute | Last Mile Driver: Raises a payout dispute |

### Settle the dispute

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | DC Executive / Dispatcher / Team Lead | Review the dispute, settle it and inform the driver | DC Executive: Reviews a payout dispute; DC Executive: Settles the dispute and informs the driver; Team Lead: Reviews a payout dispute; Team Lead: Settles the dispute and informs the driver |
| Exception | DC Executive / Dispatcher / Team Lead | Escalate a dispute they cannot settle | DC Executive: Escalates a dispute to Central Logistics Ops; Team Lead: Escalates a dispute to Central Logistics Ops |
| Exception | Central Logistics Ops | Settles an escalated payout dispute | Central Logistics Ops: Settles an escalated payout dispute |

## 18. Grievance Addressal

**Band:** Support and oversight · **Vertical:** Both

**Starts:** A Customer or driver raises a ticket.

**Ends:** The ticket is closed with an outcome.

### Raise the ticket

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Customer | Raises a ticket | Customer: Raises a ticket |
| Event | System | Raises and routes the ticket | System: Raises and routes a ticket |

### Resolve the ticket

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Grievance & Escalation Management Team | Reviews a Customer ticket | Grievance & Escalation Management Team: Reviews a Customer ticket |
| Event | Grievance & Escalation Management Team | Resolves the ticket and informs the Customer | Grievance & Escalation Management Team: Resolves the ticket and informs the Customer |
| Event | Grievance & Escalation Management Team | Reviews a driver ticket | Grievance & Escalation Management Team: Reviews a driver ticket |
| Event | Grievance & Escalation Management Team | Resolves the ticket and informs the driver | Grievance & Escalation Management Team: Resolves the ticket and informs the driver |
| Exception | Grievance & Escalation Management Team | Escalates a ticket | Grievance & Escalation Management Team: Escalates a ticket |
| Exception | Grievance & Escalation Management Team | Investigates an incident with the Team Lead | Grievance & Escalation Management Team: Investigates an incident with the Team Lead |

### Keep within time limits

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | System | Tracks the ticket to resolution | System: Tracks a ticket to resolution |
| Event | Grievance & Escalation Management Team | Tracks tickets against their time limits | Grievance & Escalation Management Team: Tracks tickets against their time limits |
| Event | Grievance & Escalation Management Team | Follows up on a ticket near its limit | Grievance & Escalation Management Team: Follows up on a ticket near its limit |

### Fix the root cause

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Grievance & Escalation Management Team | Reviews tickets for recurring problems | Grievance & Escalation Management Team: Reviews tickets for recurring problems |
| Event | Grievance & Escalation Management Team | Raises a root-cause fix with the owning team | Grievance & Escalation Management Team: Raises a root-cause fix with the owning team |

## 19. Monitoring and Investigation

**Band:** Support and oversight · **Vertical:** Both

**Starts:** Operations are running, or something has gone wrong.

**Ends:** The problem is fixed, investigated and reported.

### Watch live operations

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Control Tower | Watches live deliveries | Control Tower: Watches live deliveries |
| Event | Central Logistics Ops | Views performance across the country | Central Logistics Ops: Views performance across the country |

### Call out failures

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Control Tower | Calls out an operational failure | Control Tower: Calls out an operational failure |

### Fix the problem

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Team Lead | Reviews delivery problems in the city | Team Lead: Reviews delivery problems in the city |
| Event | Team Lead | Takes action on a delivery problem | Team Lead: Takes action on a delivery problem |
| Event | Central Logistics Ops | Steps in where performance drops | Central Logistics Ops: Steps in where performance drops |

### Investigate

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Team Lead | Investigates a loss, fraud or cash anomaly | Team Lead: Investigates a loss, fraud or cash anomaly |
| Event | Central Logistics Ops | Reviews fraud and leakage patterns | Central Logistics Ops: Reviews fraud and leakage patterns |
| Event | Central Logistics Ops | Acts on a pattern | Central Logistics Ops: Acts on a pattern |

### Report

| Type | Actor | Event | Actions |
|---|---|---|---|
| Event | Central Logistics Ops | Shares reports with leadership | Central Logistics Ops: Shares reports with leadership |
| Event | Central Logistics Ops | Provides data to analytics | Central Logistics Ops: Provides data to analytics |

## Runs through every flow

| Actor | Event | Actions |
|---|---|---|
| System | Keeps every shipment's status and location current | System: Updates status and location |
| System | Resolves every scan to the right entity | System: Resolves a scan to its entity |
| System | Records every scan and change in the audit trail | System: Records every scan and change |
| System | Sends the right notices to the right people | System: Sends a notice |
| System | Detects failures and fraud signals | System: Detects a failure or fraud signal |
| System | Provides reports and a data feed | System: Provides reports and a data feed |

## Outside the flows: cutover

| Actor | Event | Actions |
|---|---|---|
| Team Lead | Trains drivers on the new app | Team Lead: Trains drivers on the new app |
| Last Mile Driver | Starts using the new app | Last Mile Driver: Starts using the new app |
| System | Switches a location between Shipsy and the new system | System: Switches a location between Shipsy and the new system |
| System | Rolls a location back to Shipsy | System: Rolls a location back to Shipsy |
