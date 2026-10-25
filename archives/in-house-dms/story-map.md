# Story map

The end-to-end story of the system, in the style of Jeff Patton's user story mapping. Chapters tell the story in order. Under each chapter, activities run left to right in the order they happen. Each activity holds tasks, and each task holds the stories (actions) beneath it. Exceptions are marked. Tasks carry the flows they belong to. Stories point to their actions as Actor: Action.

## Chapter 1. Get ready

*Before the first order, Central Logistics Ops sets up the network, the Team Lead and the DC Executives ready the people, and every driver starts the day equipped.*

### Row 1

#### Activity 1. Set up the network

*Central Logistics Ops builds the map the system runs on.*

##### Creates the locations

**Actors:** Central Logistics Ops · **Flows:** Geography and Rules Setup

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Central Logistics Ops | Creates the serving locations | Central Logistics Ops: Creates the serving locations |
| Story | Central Logistics Ops | Creates the zones of a serving location | Central Logistics Ops: Creates the zones of a serving location |
| Story | Central Logistics Ops | Maps each zone to a hub | Central Logistics Ops: Maps each zone to a hub |
| Story | Central Logistics Ops | Maps pincodes to zones | Central Logistics Ops: Maps pincodes to zones |
| Story | Central Logistics Ops | Links warehouses and DCs | Central Logistics Ops: Links warehouses and DCs |
| Story | Central Logistics Ops | Sets whether a location uses the direct flow or the DC flow | Central Logistics Ops: Sets whether a location uses the direct flow or the DC flow |
| Story | System | Holds serving locations, zones and serviced locations | System: Holds serving locations, zones and serviced locations |
| Story | System | Holds the links and the flow per location | System: Holds the links and the flow per location |

##### Defines the rules the system runs on

**Actors:** Central Logistics Ops · **Flows:** Geography and Rules Setup

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Central Logistics Ops | Defines SLAs | Central Logistics Ops: Defines SLAs |
| Story | Central Logistics Ops | Defines batching and allocation rules | Central Logistics Ops: Defines batching and allocation rules |
| Story | Central Logistics Ops | Defines delivery attempts and cut-offs | Central Logistics Ops: Defines delivery attempts and cut-offs |
| Story | Central Logistics Ops | Defines penalties | Central Logistics Ops: Defines penalties |
| Story | System | Applies the rules | System: Applies the rules |

##### Defines driver pay and incentives

**Actors:** Central Logistics Ops · **Flows:** Driver Pay and Incentives

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Central Logistics Ops | Defines salary structures | Central Logistics Ops: Defines salary structures |
| Story | Central Logistics Ops | Defines incentive schemes | Central Logistics Ops: Defines incentive schemes |
| Story | System | Holds driver pay structures and incentive schemes | System: Holds driver pay structures and incentive schemes |

##### Sets up users and their access

**Actors:** Central Logistics Ops / Team Lead · **Flows:** User Management

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Central Logistics Ops | Defines roles and what each can do | Central Logistics Ops: Defines roles and what each can do |
| Story | Central Logistics Ops | Assigns roles to users | Central Logistics Ops: Assigns roles to users |
| Story | Team Lead | Creates a user and assigns a role | Team Lead: Creates a user and assigns a role |
| Story | Team Lead | Changes or removes a user's access | Team Lead: Changes or removes a user's access |
| Story | System | Holds users, drivers and Customers | System: Holds users, drivers and Customers |
| Story | System | Enforces who can do what | System: Enforces who can do what |

##### Onboards vendors

**Actors:** Team Lead · **Flows:** Vendor Management

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Team Lead | Onboards a vendor | Team Lead: Onboards a vendor |
| Story | Team Lead | Updates or deactivates a vendor | Team Lead: Updates or deactivates a vendor |
| Story | System | Holds vendors, their vehicles and their drivers | System: Holds vendors, their vehicles and their drivers |

### Row 2

#### Activity 2. Ready the drivers

*Drivers are onboarded, equipped and planned for.*

##### Onboards a driver

**Actors:** DC Executive / Dispatcher · **Flows:** Driver Management; Asset Management

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | DC Executive / Dispatcher | Onboards a Last Mile Driver | DC Executive: Onboards a Last Mile Driver |
| Story | DC Executive / Dispatcher | Registers the driver's vehicle | DC Executive: Registers the driver's vehicle |
| Story | DC Executive / Dispatcher | Assigns a device to the driver | DC Executive: Assigns a device to the driver |
| Story | DC Executive / Dispatcher | Tags the driver to a vendor | DC Executive: Tags the driver to a vendor |
| Story | Team Lead | Checks a driver's documents | Team Lead: Checks a driver's documents |
| Story | System | Holds a driver's documents | System: Holds a driver's documents |
| Story | System | Registers a device and records its holder | System: Registers a device and records its holder |

##### Sets the driver's serviceability

**Actors:** DC Executive / Dispatcher · **Flows:** Driver Management

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | DC Executive / Dispatcher | Assigns the zones and pincodes a driver serves | DC Executive: Assigns the zones and pincodes a driver serves |
| Story | DC Executive / Dispatcher | Excludes pincodes a driver does not serve | DC Executive: Excludes pincodes a driver does not serve |
| Story | System | Holds a driver's serviceability | System: Holds a driver's serviceability |

##### Agrees the driver's pay structure

**Actors:** DC Executive / Dispatcher / Team Lead / Central Logistics Ops · **Flows:** Driver Pay and Incentives

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | DC Executive / Dispatcher | Assigns a pay structure to a driver | DC Executive: Assigns a pay structure to a driver |
| Story | Team Lead | Confirms a driver's pay structure | Team Lead: Confirms a driver's pay structure |
| Story | Central Logistics Ops | Confirms a driver's pay structure | Central Logistics Ops: Confirms a driver's pay structure |

##### Looks after the driver

**Actors:** Team Lead · **Flows:** Driver Management; Asset Management

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | DC Executive / Dispatcher | Updates a driver's details | DC Executive: Updates a driver's details |
| Story | Team Lead | Reviews a driver's performance | Team Lead: Reviews a driver's performance |
| Story | Team Lead | Suspends a driver | Team Lead: Suspends a driver |
| Story | Team Lead | Exits a driver | Team Lead: Exits a driver |
| Story | DC Executive / Dispatcher | Recovers the device and vehicle | DC Executive: Recovers the device and vehicle |
| Story | Team Lead | Reviews the city's vehicles and devices | Team Lead: Reviews the city's vehicles and devices |
| Exception | DC Executive / Dispatcher | Handles a lost or broken device | DC Executive: Handles a lost or broken device |
| Story | System | Holds a driver's status and document check results | System: Holds a driver's status and document check results |

##### Plans the capacity

**Actors:** Central Logistics Ops / Team Lead · **Flows:** Capacity Planning

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Central Logistics Ops | Forecasts demand by location | Central Logistics Ops: Forecasts demand by location |
| Story | Central Logistics Ops | Plans drivers and DC capacity | Central Logistics Ops: Plans drivers and DC capacity |
| Story | Team Lead | Plans drivers and DC capacity for a new location | Team Lead: Plans drivers and DC capacity for a new location |

##### Keeps enough drivers on shift

**Actors:** Team Lead · **Flows:** Daily Shift

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Team Lead | Reviews drivers on shift against each location's expected orders | Team Lead: Reviews drivers on shift against each location's expected orders |
| Story | DC Executive / Dispatcher | Checks the drivers on duty | DC Executive: Checks the drivers on duty |
| Exception | Team Lead | Arranges cover for leave and absences | Team Lead: Arranges cover for leave and absences |

##### Starts the shift

**Actors:** Last Mile Driver · **Flows:** Daily Shift

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Last Mile Driver | Marks duty start | Last Mile Driver: Marks duty start |
| Story | Last Mile Driver | Confirms the device and vehicle in use | Last Mile Driver: Confirms the device and vehicle in use |
| Story | System | Records attendance and duty status | System: Records attendance and duty status |

## Chapter 2. From order to doorstep

*An order is prepared in the warehouse, travels to a DC (or leaves the warehouse directly), is planned and picked up, and reaches the Customer.*

### Row 1

#### Activity 3. Receive and prepare the order

*An order arrives and is made ready to leave the warehouse.*

##### Receives the order and creates the shipment

**Actors:** System · **Flows:** Forward via DC; Forward Direct

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | System | Receives an order with its details | System: Receives an order with its details |
| Story | System | Creates a shipment | System: Creates a shipment |
| Exception | Customer | Updates the delivery address or phone number | Customer: Updates the delivery address or phone number |
| Exception | Customer | Cancels an order | Customer: Cancels an order |
| Exception | System | Applies a cancellation or change | System: Applies a cancellation or change |

##### Generates the AWB and decides the path

**Actors:** System · **Flows:** Forward via DC; Forward Direct

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | System | Generates a barcode | System: Generates a barcode |
| Story | System | Generates the AWB | System: Generates the AWB |
| Story | System | Decides the path | System: Decides the path |

##### Prints the AWB

**Actors:** WH Ops · **Flows:** Forward via DC; Forward Direct

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | WH Ops | Prints the AWB | WH Ops: Prints the AWB |

##### Hands the shipments to the Dispatcher

**Actors:** WH Ops · **Flows:** Forward via DC; Forward Direct

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | WH Ops | Hands ready shipments to the Dispatcher | WH Ops: Hands ready shipments to the Dispatcher |
| Story | WH Ops | Scans each shipment at handover | WH Ops: Scans each shipment at handover |
| Story | System | Generates a manifest | System: Generates a manifest |
| Story | System | Records scans against the manifest | System: Records scans against the manifest |

##### Adds gel packs where needed

**Actors:** Dispatcher · **Flows:** Forward via DC; Forward Direct

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Dispatcher | Adds gel packs to orders that need them | Dispatcher: Adds gel packs to orders that need them |
| Story | System | Flags orders that need gel packs | System: Flags orders that need gel packs |

#### Activity 4. Dispatch via a DC

*Shipments bound for a DC are sorted, packed into a consignment and loaded.*

**Note:** Orders delivered directly from the warehouse skip to Plan the deliveries.

##### Sorts shipments by destination DC

**Actors:** Dispatcher · **Flows:** Forward via DC

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Dispatcher | Sorts shipments into bins by destination | Dispatcher: Sorts shipments into bins by destination |

##### Builds the consignment

**Actors:** Dispatcher · **Flows:** Forward via DC

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Dispatcher | Scans shipments into a consignment | Dispatcher: Scans shipments into a consignment |
| Story | System | Creates a consignment | System: Creates a consignment |

##### Plan the trip together

**Actors:** Dispatcher / Team Lead · **Flows:** Mid-Mile Movement

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Dispatcher | Plans mid-mile departures with the Team Lead | Dispatcher: Plans mid-mile departures with the Team Lead |
| Story | Team Lead | Plans mid-mile departures with the Dispatcher | Team Lead: Plans mid-mile departures with the Dispatcher |
| Story | System | Shows the consignments ready to move | System: Shows the consignments ready to move |

##### Records the vendor, vehicle and driver

**Actors:** Dispatcher · **Flows:** Forward via DC

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Dispatcher | Records the vendor, vehicle number, and the driver's name and phone | Dispatcher: Records the vendor, vehicle number, and the driver's name and phone |
| Story | System | Records the vendor, vehicle and driver details | System: Records the vendor, vehicle and driver details |

##### Loads the consignment and scans the handover

**Actors:** Dispatcher · **Flows:** Forward via DC

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Dispatcher | Loads the consignment and scans the handover | Dispatcher: Loads the consignment and scans the handover |

### Row 2

#### Activity 5. Move it

*The consignment travels to the DC.*

##### Drives the consignment to the DC

**Actors:** Mid-Mile Driver · **Flows:** Mid-Mile Movement; Forward via DC

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Mid-Mile Driver | Drives the consignment from the origin to the destination | Mid-Mile Driver: Drives the consignment from the origin to the destination |
| Story | System | Shows the live location of a vehicle | System: Shows the live location of a vehicle |
| Story | Dispatcher / DC Executive | Views the live location of a mid-mile vehicle | Dispatcher: Views the live location of a mid-mile vehicle; DC Executive: Views the live location of a mid-mile vehicle |
| Exception | Dispatcher / DC Executive | Flags a consignment as lost, damaged or delayed | Dispatcher: Flags a consignment as lost, damaged or delayed; DC Executive: Flags a consignment as lost, damaged or delayed |

#### Activity 6. Receive and sort at the DC

*The DC takes the consignment in and sorts every shipment.*

##### Receives and unloads the consignment

**Actors:** DC Executive · **Flows:** Forward via DC

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | DC Executive | Receives the consignment from the vehicle | DC Executive: Receives the consignment from the vehicle |
| Story | DC Executive | Scans and unloads the consignment | DC Executive: Scans and unloads the consignment |
| Exception | DC Executive | Flags anything missing, damaged or mismatched | DC Executive: Flags anything missing, damaged or mismatched |
| Exception | System | Flags missing or mismatched items | System: Flags missing or mismatched items |

##### Sorts each shipment into its bin

**Actors:** DC Executive · **Flows:** Forward via DC

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | DC Executive | Sorts each shipment into its bin | DC Executive: Sorts each shipment into its bin |
| Story | System | Shows which bin a shipment belongs in | System: Shows which bin a shipment belongs in |
| Story | System | Tracks bin contents | System: Tracks bin contents |

#### Activity 7. Plan the deliveries

*The System plans deliveries and return pickups together, and people adjust.*

##### Creates batches and routes and allocates drivers

**Actors:** System · **Flows:** Forward via DC; Forward Direct; Customer Return; Replanning

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | System | Creates delivery batches | System: Creates delivery batches |
| Story | System | Creates routes | System: Creates routes |
| Story | System | Allocates Last Mile Drivers | System: Allocates Last Mile Drivers |
| Story | System | Sends the orders and pickups to the driver's app | System: Sends the orders and pickups to the driver's app |
| Exception | DC Executive / Dispatcher | Triggers a replan | DC Executive: Triggers a replan |
| Exception | System | Replans the affected batches and routes | System: Replans the affected batches and routes |
| Exception | DC Executive / Dispatcher | Accepts the new plan or rearranges it | DC Executive: Accepts the new plan or rearranges it |

#### Activity 8. Pick up the batch

*The driver collects their orders from the bin and the DC Executive scans them out.*

##### Views the batch and picks the orders from the bin

**Actors:** Last Mile Driver · **Flows:** Forward via DC; Forward Direct

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Last Mile Driver | Views the assigned batch and the pickup point | Last Mile Driver: Views the assigned batch and the pickup point |
| Story | Last Mile Driver | Picks the assigned orders from the bin | Last Mile Driver: Picks the assigned orders from the bin |
| Story | Last Mile Driver | Takes the orders to the DC Executive | Last Mile Driver: Takes the orders to the DC Executive |

##### Scans the orders the driver brings

**Actors:** DC Executive / Dispatcher · **Flows:** Forward via DC; Forward Direct

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | DC Executive / Dispatcher | Scans the orders the driver brings | DC Executive: Scans the orders the driver brings |
| Story | System | Resolves a scan to its entity | System: Resolves a scan to its entity |
| Exception | System | Rejects an invalid or duplicate scan | System: Rejects an invalid or duplicate scan |

### Row 3

#### Activity 9. Deliver

*The driver reaches the Customer and hands the order over.*

##### Follows the route to the Customer

**Actors:** Last Mile Driver · **Flows:** Forward via DC; Forward Direct

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Last Mile Driver | Views the route for the batch | Last Mile Driver: Views the route for the batch |
| Story | Last Mile Driver | Navigates to the Customer's location | Last Mile Driver: Navigates to the Customer's location |
| Story | Last Mile Driver / Customer | Calls the Customer through the app | Last Mile Driver: Calls the Customer through the app; Customer: Calls the driver through the app |
| Story | System | Masks phone numbers on a call | System: Masks phone numbers on a call |
| Exception | Last Mile Driver | Works offline | Last Mile Driver: Works offline |
| Exception | Last Mile Driver | Syncs offline work | Last Mile Driver: Syncs offline work |
| Exception | System | Saves and syncs offline work | System: Saves and syncs offline work |

##### Tracks the order

**Actors:** Customer · **Flows:** Forward via DC; Forward Direct

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Customer | Views the expected arrival and status of the order | Customer: Views the expected arrival and status of the order |
| Story | Customer | Receives notices about changes | Customer: Receives notices about changes |
| Story | System | Updates status and location | System: Updates status and location |
| Story | System | Sends a notice | System: Sends a notice |

##### Receives the order and confirms

**Actors:** Customer · **Flows:** Forward via DC; Forward Direct

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Customer | Receives the order from the driver | Customer: Receives the order from the driver |
| Story | Customer | Confirms receipt | Customer: Confirms receipt |
| Exception | Customer | Reschedules a delivery | Customer: Reschedules a delivery |
| Exception | Customer | Rejects a delivery at the door | Customer: Rejects a delivery at the door |

##### Collects proof of delivery

**Actors:** Last Mile Driver · **Flows:** Forward via DC; Forward Direct

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Last Mile Driver | Collects proof of delivery | Last Mile Driver: Collects proof of delivery |
| Story | System | Keeps the proof of delivery | System: Keeps the proof of delivery |

##### Pays for the order

**Actors:** Customer / Last Mile Driver · **Flows:** Forward via DC; Forward Direct

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Customer | Pays for the order | Customer: Pays for the order |
| Story | Last Mile Driver | Collects payment from the Customer | Last Mile Driver: Collects payment from the Customer |
| Story | System | Records payments, cash handovers and deposits | System: Records payments, cash handovers and deposits |

##### Ends the shift

**Actors:** Last Mile Driver · **Flows:** Daily Shift

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Last Mile Driver | Marks duty end | Last Mile Driver: Marks duty end |
| Story | DC Executive / Dispatcher | Confirms each driver is accounted for | DC Executive: Confirms each driver is accounted for |

#### Activity 10. Reconcile the cash

*Cash collected at the door is handed in, banked and matched. Reconciliation usually happens the next day.*

##### Hands cash in

**Actors:** Last Mile Driver · **Flows:** Cash Handling and Reconciliation

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Last Mile Driver | Hands cash in | Last Mile Driver: Hands cash in |
| Story | DC Executive / Dispatcher | Receives cash from drivers | DC Executive: Receives cash from drivers |

##### Records and banks the cash

**Actors:** DC Executive / Dispatcher · **Flows:** Cash Handling and Reconciliation

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | DC Executive / Dispatcher | Records the cash collected | DC Executive: Records the cash collected |
| Story | DC Executive / Dispatcher | Deposits the cash in the bank | DC Executive: Deposits the cash in the bank |

##### Matches and approves the cash

**Actors:** Finance · **Flows:** Cash Handling and Reconciliation

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | System | Matches them against what was owed | System: Matches them against what was owed |
| Story | Finance | Reviews cash collected against what was owed | Finance: Reviews cash collected against what was owed |
| Story | Finance | Approves a cash deposit | Finance: Approves a cash deposit |
| Story | Finance | Reviews the record of money movements | Finance: Reviews the record of money movements |
| Exception | DC Executive / Dispatcher | Escalates a mismatch | DC Executive: Escalates a mismatch |
| Exception | Finance | Closes a discrepancy | Finance: Closes a discrepancy |

## Chapter 3. When it does not go to plan

*A delivery fails, or a Customer sends an order back. Either way the parcel finds its way back to the warehouse.*

### Row 1

#### Activity 11. When a delivery fails

*A delivery cannot be completed, and the System decides what happens next.*

##### Marks the delivery failed

**Actors:** Last Mile Driver · **Flows:** Failed Delivery

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Last Mile Driver | Marks the delivery as failed, with a reason | Last Mile Driver: Marks the delivery as failed, with a reason |
| Story | Last Mile Driver | Brings the parcel back to the DC or warehouse | Last Mile Driver: Brings the parcel back to the DC or warehouse |

##### Decides between a reattempt and an RTO

**Actors:** System · **Flows:** Failed Delivery

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | System | Decides between a reattempt and an RTO | System: Decides between a reattempt and an RTO |

##### Replans the delivery for the next day

**Actors:** DC Executive / Dispatcher · **Flows:** Failed Delivery

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | DC Executive / Dispatcher | Triggers a replan for the next day | DC Executive: Triggers a replan for the next day |
| Story | System | Replans a failed delivery for the next day | System: Replans a failed delivery for the next day |
| Story | DC Executive / Dispatcher | Accepts the new plan or rearranges it | DC Executive: Accepts the new plan or rearranges it |

##### Schedules the return

**Actors:** Dispatcher · **Flows:** Failed Delivery; RTO Return

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Dispatcher | Schedules the return of a failed delivery | Dispatcher: Schedules the return of a failed delivery |

#### Activity 12. A Customer returns an order

*A Customer sends back a delivered order. The pickup is planned together with forward deliveries.*

##### Requests a return

**Actors:** Customer · **Flows:** Customer Return

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Customer | Requests a return | Customer: Requests a return |
| Story | System | Creates the return pickup | System: Creates the return pickup |

##### Schedules the pickup

**Actors:** Dispatcher · **Flows:** Customer Return

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Dispatcher | Schedules a return pickup from the Customer | Dispatcher: Schedules a return pickup from the Customer |
| Story | Customer | Views the pickup time | Customer: Views the pickup time |

##### Collects the return

**Actors:** Last Mile Driver · **Flows:** Customer Return

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Last Mile Driver | Views the return pickup and the medicine details | Last Mile Driver: Views the return pickup and the medicine details |
| Story | System | Shows medicine details on a return pickup | System: Shows medicine details on a return pickup |
| Story | Last Mile Driver | Checks the medicine against the order details | Last Mile Driver: Checks the medicine against the order details |
| Story | Customer | Hands the return to the driver | Customer: Hands the return to the driver |
| Story | Last Mile Driver | Takes the parcel from the Customer | Last Mile Driver: Takes the parcel from the Customer |

#### Activity 13. Bring it back to the warehouse

*Returned parcels travel back to the warehouse.*

##### Receives the returns and sends them on

**Actors:** DC Executive · **Flows:** RTO Return

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | DC Executive | Receives returned parcels from drivers and scans them | DC Executive: Receives returned parcels from drivers and scans them |
| Story | DC Executive | Scans returned shipments into a consignment and releases it towards the warehouse | DC Executive: Scans returned shipments into a consignment and releases it towards the warehouse |

##### Drives the consignment to the warehouse

**Actors:** Mid-Mile Driver · **Flows:** RTO Return; Mid-Mile Movement · **Same as:** Drives the consignment to the DC

##### Receives the returned consignment and hands it over

**Actors:** Dispatcher · **Flows:** RTO Return

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Dispatcher | Receives the returned consignment from the vehicle | Dispatcher: Receives the returned consignment from the vehicle |
| Story | Dispatcher | Scans and unloads the returned consignment | Dispatcher: Scans and unloads the returned consignment |
| Story | Dispatcher | Hands the returned parcels to WH Ops and scans the handover | Dispatcher: Hands the returned parcels to WH Ops and scans the handover |
| Exception | Dispatcher | Flags anything missing, damaged or mismatched on receipt | Dispatcher: Flags anything missing, damaged or mismatched on receipt |

##### Receives the returned parcel

**Actors:** WH Ops · **Flows:** RTO Return

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | WH Ops | Receives the returned parcel | WH Ops: Receives the returned parcel |
| Story | WH Ops | Scans the parcel on receipt | WH Ops: Scans the parcel on receipt |
| Exception | WH Ops | Reports damage or mismatch | WH Ops: Reports damage or mismatch |

## Chapter 4. Keep it running

*Vendors are paid, drivers and Customers get help, and the people who watch the operation find and fix what is going wrong.*

### Row 1

#### Activity 14. Track driver earnings

*Every driver earns a salary and incentives, and the System keeps count.*

##### Computes earnings and tracks incentive progress

**Actors:** System · **Flows:** Driver Pay and Incentives

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | System | Computes a driver's earnings | System: Computes a driver's earnings |
| Story | System | Tracks incentive progress | System: Tracks incentive progress |

##### Grants incentives to drivers

**Actors:** Team Lead · **Flows:** Driver Pay and Incentives

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Team Lead | Grants an incentive to a driver | Team Lead: Grants an incentive to a driver |

##### Sees earnings and incentive progress

**Actors:** Last Mile Driver · **Flows:** Driver Pay and Incentives

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Last Mile Driver | Views earnings and incentive progress | Last Mile Driver: Views earnings and incentive progress |

#### Activity 15. Pay the vendors

*Vendors are paid every month for the drivers they supply.*

##### Rolls driver earnings up per vendor

**Actors:** System · **Flows:** Vendor Payouts; Driver Pay and Incentives

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | System | Rolls driver earnings up per vendor | System: Rolls driver earnings up per vendor |

##### Calculates what each vendor is owed

**Actors:** Finance · **Flows:** Vendor Payouts

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Finance | Calculates the amount owed to each vendor | Finance: Calculates the amount owed to each vendor |

##### Pays the vendor

**Actors:** Finance · **Flows:** Vendor Payouts

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Finance | Pays the vendor | Finance: Pays the vendor |
| Story | System | Records a vendor payment | System: Records a vendor payment |

### Row 2

#### Activity 16. Support drivers and Customers

*Drivers and Customers get help, and disputes are settled.*

##### Asks for help on the road

**Actors:** Last Mile Driver · **Flows:** Driver Support and Payout Disputes

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Last Mile Driver | Raises a help request | Last Mile Driver: Raises a help request |
| Story | DC Executive / Dispatcher | Responds to a driver's help request | DC Executive: Responds to a driver's help request |

##### Raises a payout dispute

**Actors:** Last Mile Driver · **Flows:** Driver Support and Payout Disputes

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Last Mile Driver | Raises a payout dispute | Last Mile Driver: Raises a payout dispute |

##### Settles the dispute

**Actors:** DC Executive / Dispatcher / Team Lead · **Flows:** Driver Support and Payout Disputes; Driver Pay and Incentives

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | DC Executive / Team Lead | Reviews a payout dispute | DC Executive: Reviews a payout dispute; Team Lead: Reviews a payout dispute |
| Story | DC Executive / Team Lead | Settles the dispute and informs the driver | DC Executive: Settles the dispute and informs the driver; Team Lead: Settles the dispute and informs the driver |
| Story | System | Adjusts a driver's earnings after a dispute | System: Adjusts a driver's earnings after a dispute |
| Exception | DC Executive / Team Lead | Escalates a dispute to Central Logistics Ops | DC Executive: Escalates a dispute to Central Logistics Ops; Team Lead: Escalates a dispute to Central Logistics Ops |
| Exception | Central Logistics Ops | Settles an escalated payout dispute | Central Logistics Ops: Settles an escalated payout dispute |

##### Raises a ticket

**Actors:** Customer · **Flows:** Grievance Addressal

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Customer | Raises a ticket | Customer: Raises a ticket |
| Story | System | Raises and routes a ticket | System: Raises and routes a ticket |

##### Resolves the ticket

**Actors:** Grievance & Escalation Management Team · **Flows:** Grievance Addressal

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Grievance & Escalation Management Team | Reviews a Customer ticket | Grievance & Escalation Management Team: Reviews a Customer ticket |
| Story | Grievance & Escalation Management Team | Resolves the ticket and informs the Customer | Grievance & Escalation Management Team: Resolves the ticket and informs the Customer |
| Story | Grievance & Escalation Management Team | Reviews a driver ticket | Grievance & Escalation Management Team: Reviews a driver ticket |
| Story | Grievance & Escalation Management Team | Resolves the ticket and informs the driver | Grievance & Escalation Management Team: Resolves the ticket and informs the driver |
| Exception | Grievance & Escalation Management Team | Escalates a ticket | Grievance & Escalation Management Team: Escalates a ticket |
| Exception | Grievance & Escalation Management Team | Investigates an incident with the Team Lead | Grievance & Escalation Management Team: Investigates an incident with the Team Lead |

##### Keeps tickets within their time limits

**Actors:** Grievance & Escalation Management Team · **Flows:** Grievance Addressal

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | System | Tracks a ticket to resolution | System: Tracks a ticket to resolution |
| Story | Grievance & Escalation Management Team | Tracks tickets against their time limits | Grievance & Escalation Management Team: Tracks tickets against their time limits |
| Story | Grievance & Escalation Management Team | Follows up on a ticket near its limit | Grievance & Escalation Management Team: Follows up on a ticket near its limit |

##### Fixes the root cause

**Actors:** Grievance & Escalation Management Team · **Flows:** Grievance Addressal

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Grievance & Escalation Management Team | Reviews tickets for recurring problems | Grievance & Escalation Management Team: Reviews tickets for recurring problems |
| Story | Grievance & Escalation Management Team | Raises a root-cause fix with the owning team | Grievance & Escalation Management Team: Raises a root-cause fix with the owning team |

### Row 3

#### Activity 17. Watch and improve

*The people who watch the operation call out failures, fix problems and report.*

##### Watches live deliveries and calls out failures

**Actors:** Control Tower · **Flows:** Monitoring and Investigation

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Control Tower | Watches live deliveries | Control Tower: Watches live deliveries |
| Story | Control Tower | Calls out an operational failure | Control Tower: Calls out an operational failure |
| Story | System | Detects a failure or fraud signal | System: Detects a failure or fraud signal |

##### Reviews performance and fixes problems

**Actors:** Team Lead / Central Logistics Ops · **Flows:** Monitoring and Investigation

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Team Lead | Reviews delivery problems in the city | Team Lead: Reviews delivery problems in the city |
| Story | Team Lead | Takes action on a delivery problem | Team Lead: Takes action on a delivery problem |
| Story | Central Logistics Ops | Views performance across the country | Central Logistics Ops: Views performance across the country |
| Story | Central Logistics Ops | Steps in where performance drops | Central Logistics Ops: Steps in where performance drops |

##### Investigates loss, fraud and anomalies

**Actors:** Team Lead / Central Logistics Ops · **Flows:** Monitoring and Investigation

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Team Lead | Investigates a loss, fraud or cash anomaly | Team Lead: Investigates a loss, fraud or cash anomaly |
| Story | Central Logistics Ops | Reviews fraud and leakage patterns | Central Logistics Ops: Reviews fraud and leakage patterns |
| Story | Central Logistics Ops | Acts on a pattern | Central Logistics Ops: Acts on a pattern |
| Story | System | Records every scan and change | System: Records every scan and change |

##### Shares reports and data

**Actors:** Central Logistics Ops · **Flows:** Monitoring and Investigation

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Central Logistics Ops | Shares reports with leadership | Central Logistics Ops: Shares reports with leadership |
| Story | Central Logistics Ops | Provides data to analytics | Central Logistics Ops: Provides data to analytics |
| Story | System | Provides reports and a data feed | System: Provides reports and a data feed |

## Runs underneath every step

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | System | Updates status and location | System: Updates status and location |
| Story | System | Resolves a scan to its entity | System: Resolves a scan to its entity |
| Story | System | Records every scan and change | System: Records every scan and change |
| Story | System | Sends a notice | System: Sends a notice |
| Story | System | Detects a failure or fraud signal | System: Detects a failure or fraud signal |
| Story | System | Provides reports and a data feed | System: Provides reports and a data feed |

## Outside the map: cutover

| Type | Actor | Story | Actions |
|---|---|---|---|
| Story | Team Lead | Trains drivers on the new app | Team Lead: Trains drivers on the new app |
| Story | Last Mile Driver | Starts using the new app | Last Mile Driver: Starts using the new app |
| Story | System | Switches a location between Shipsy and the new system | System: Switches a location between Shipsy and the new system |
| Story | System | Rolls a location back to Shipsy | System: Rolls a location back to Shipsy |
