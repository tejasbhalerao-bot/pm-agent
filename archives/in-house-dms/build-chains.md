# Build chains

Each milestone is built as a chain, worked out backwards from what a driver does in the app. A chunk is the smallest piece someone can use and demonstrate. Build each milestone top to bottom; every chunk names what it needs first. Every chunk that goes live ships with its own monitoring and reporting, and with any rules the business can adjust. Initiatives and card numbers match [milestones.md](milestones.md) and [story-map.md](story-map.md).

38 chunks: 21 in Milestone 1, 10 in Milestone 2, 7 in Milestone 3.

## Milestone 1: Cutover Parity & Foundational Capabilities

Starts from: Network setup (locations, zones and pincodes) is already built.

### Chain 1. The driver logs in and starts the shift

Backwards: The driver starts the shift ← logs in to the app ← has a driver record ← created in the portal by a Dispatcher or DC Executive ← who has portal access

| # | Someone can | Initiative | Needs first | Build | Done when |
|---|---|---|---|---|---|
| M1.1 | A Team Lead, Dispatcher and DC Executive can log in to the portal and see only what their role allows. | User Management #4 | Locations, zones and pincodes, already built. | **Portal:** Create users, assign roles, change or remove access. **System:** Enforce who can do what. | A Team Lead creates a Dispatcher for one location. The Dispatcher logs in and sees only that location. |
| M1.2 | A Team Lead can onboard a vendor. A Dispatcher or DC Executive can create a driver with a vehicle, a vendor and the pincodes they serve. | Driver Management #5, #6, #7 | M1.1: nobody can create a driver without portal access. | **Portal:** Onboard or deactivate vendors. Create a driver, register the vehicle, tag the vendor, set serviceable zones and pincodes. The Team Lead checks the documents. **System:** Hold vendors, drivers, vehicles, documents and serviceability. | A new driver appears in the portal with a vehicle, a vendor and serviceable pincodes, and their documents are checked. |
| M1.3 | A driver can log in to the app and start the shift. | Duty Start & End #12 | M1.2: a driver must exist before they can log in. | **App:** Log in. Mark duty start. **System:** Record duty status. | A driver created in M1.2 logs in on their phone and starts duty. The portal records the duty status. |
| M1.4 | A Dispatcher can update a driver's details. A Team Lead can suspend or exit a driver. | Driver Management #9 | M1.2: a driver must exist. | **Portal:** Update a driver's details. The Team Lead reviews performance, suspends or exits a driver, and reviews the city's vehicles. Recover the vehicle on exit. **System:** Hold the driver's status and document check results. | A Team Lead suspends one driver and exits another. Both statuses show in the portal. |

### Chain 2. The driver sees orders in the app

Backwards: The driver sees orders in the app ← the Dispatcher assigned them from the portal ← the Dispatcher has the shipments ← the shipments have AWBs ← the orders exist in the system

| # | Someone can | Initiative | Needs first | Build | Done when |
|---|---|---|---|---|---|
| M1.5 | An order placed on Truemeds becomes a shipment with an AWB, and WH Ops can print the label. | Order Intake, AWB Generation & Print #13, #14, #15 | Nothing from the first chain. Can be built in parallel. | **System:** Receive the order and its details, create the shipment, generate the barcode and AWB, decide the path (direct or via a DC). Apply cancellations and address or phone changes. **Portal:** WH Ops prints the AWB. | An order placed on Truemeds appears in the portal as a shipment, and WH Ops prints its AWB. |
| M1.6 | WH Ops can hand shipments to the Dispatcher with a scan. | Handover Validation #16 | M1.5: shipments must exist to be scanned. M1.1: the Dispatcher needs portal access. | **Portal:** WH Ops hands over the shipments and scans each one. **System:** Generate the manifest and record scans against it. | Each scanned shipment shows as handed to the Dispatcher, recorded against the manifest. |
| M1.7 | DC locations only: a Dispatcher can scan shipments onto a mid-mile vehicle, and a DC Executive can scan them in at the DC and sort each into its bin. | Handover Validation #22, #24, #25 | M1.6: the Dispatcher must hold the shipments first. The drive itself stays outside the system until Milestone 3. | **Portal:** The Dispatcher scans each shipment at loading. The DC Executive scans shipments in and unloads, then sorts each into its bin. **System:** Show which bin a shipment belongs in. Track bin contents. | A shipment scanned at loading and scanned in at the DC shows its bin. |
| M1.8 | A Dispatcher or DC Executive can give orders to the driver in front of them from the portal, and the driver sees them in the app. | System Assisted Driver Allocation #26; Trip Flow #27 | M1.3: a driver on duty. M1.2: the pincodes the driver serves. M1.6 or M1.7: the shipments in hand. | **Portal:** Create a batch by hand and give it to the driver, with the system assisting. **System:** Send the orders to the driver's app. **App:** The driver views the assigned batch and the pickup point. | Three orders assigned in the portal appear in the assigned driver's app, with the pickup point. |

### Chain 3. The driver delivers an order

Backwards: The Customer has the order, with proof of delivery and payment ← the driver reached the Customer ← the driver picked up the orders ← the driver has an assigned batch

| # | Someone can | Initiative | Needs first | Build | Done when |
|---|---|---|---|---|---|
| M1.9 | The driver can pick up the assigned orders, and the handover is scanned. | Trip Flow #27; Handover Validation #28 | M1.8: the driver needs an assigned batch. | **App:** The driver picks the assigned orders from the bin and takes them to the DC Executive. **Portal:** The DC Executive or Dispatcher scans the orders the driver brings. **System:** Resolve each scan to its order. Reject an invalid or duplicate scan. | Scanning the driver's orders marks them as with that driver. A wrong or repeated scan is rejected. |
| M1.10 | The driver can navigate to the Customer and call them from the app. | Trip Flow #29 | M1.9: the driver must hold the orders. | **App:** View the route for the batch, navigate to the Customer, call through the app. Keep working offline and sync later. **System:** Mask phone numbers on a call. Save and sync offline work. | A driver opens an order, navigates to the address and calls the Customer without seeing their number. |
| M1.11 | The driver can hand over the order, take payment in cash and capture proof of delivery. | Trip Flow #31, #32, #33 | M1.10: the driver must reach the Customer. | **App:** The Customer receives the order and confirms, or rejects it at the door. The driver collects proof of delivery and the cash payment. **System:** Keep the proof of delivery. Record the payment. Note: Address Quality Interventions (no cards) rides on this chunk: the delivery location is stored against the address. | An order is delivered with proof of delivery, and the cash payment is recorded against it. |
| M1.12 | A Customer can pay by QR when the driver arrives. | Dynamic QR #33 | M1.11: the payment step must exist. | **System:** Give each order its own payment QR. Record the payment. **App:** Show the QR to the Customer. | A Customer scans an order's QR, pays, and the payment shows against the order. |

### Chain 4. A delivery does not go to plan

Backwards: The Dispatcher replans the delivery ← the delivery failed, or the Customer asked to reschedule ← the driver is at the door

| # | Someone can | Initiative | Needs first | Build | Done when |
|---|---|---|---|---|---|
| M1.13 | The driver can mark a delivery failed with a reason and bring the parcel back. | Delivery Failed & RTO Management #38 | M1.10: the driver must be on a delivery. | **App:** Mark the delivery failed with a reason. Bring the parcel back to the DC or warehouse. **System:** Record the failed delivery and inform the Dispatcher. | A failed delivery shows its reason, and the Dispatcher is told. |
| M1.14 | A failed delivery gets a decision, a reattempt or a return to origin, and a plan for what happens next. | Delivery Failed & RTO Management #39, #40, #41 | M1.13: there must be a failed delivery. M1.8: the planning tools. | **System:** Decide between a reattempt and a return to origin. Replan the failed delivery for the next day. **Portal:** A DC Executive or Dispatcher triggers the replan and accepts or rearranges the plan. The Dispatcher schedules the return. **Rules:** The business can adjust delivery attempts and cut-offs. | A failed order is either on tomorrow's plan or scheduled for return. |
| M1.15 | A Dispatcher can change a driver's trip by hand, and a Customer's request to reschedule is applied. | Manual Trip Replanning #26; Delivery Reschedule Flow #31, #40 | M1.8: trips to change. M1.14: replanning for a new day. | **Portal:** Trigger a replan, then accept the new plan or rearrange it. **System:** Apply the Customer's reschedule and replan the delivery for the new day. | An order moved between two drivers appears in the new driver's app. A rescheduled order appears on its new day. |

### Chain 5. The driver ends the day and hands in cash

Backwards: Finance approves the cash ← the DC Executive recorded and banked it ← the driver handed it in ← the driver ended the shift ← the driver collected it at the door

| # | Someone can | Initiative | Needs first | Build | Done when |
|---|---|---|---|---|---|
| M1.16 | The driver can end the shift, and a DC Executive can confirm every driver is accounted for. | Duty Start & End #34 | M1.3: the shift was started. | **App:** Mark duty end. **Portal:** Confirm each driver is accounted for. | At the end of the day every driver is marked off duty and the DC Executive confirms each one. |
| M1.17 | The driver can hand cash in, and a DC Executive can record it and bank it. | COD Reconciliation Module #35, #36 | M1.11: cash collected at the door. M1.16: the shift has ended. | **Portal:** The DC Executive receives cash from drivers, records the cash collected and deposits it in the bank. **System:** Record each handover and each deposit. | The cash a driver collected can be compared with the cash recorded as handed in, and the deposit is recorded. |
| M1.18 | Finance can match the cash against what was owed and approve the deposit. | COD Reconciliation Module #37 | M1.17: cash must be handed in and banked. | **System:** Match deposits against what was owed. **Portal:** Finance reviews cash against what was owed, approves deposits and reviews money movements. A DC Executive escalates a mismatch and Finance closes it. | A day's cash for a location is matched and approved. A mismatch is escalated and closed. |

### Chain 6. A Customer returns an order

Backwards: The parcel is back at the warehouse ← it passed the DC and the Dispatcher ← the driver collected it from the Customer ← a pickup was scheduled ← the Customer asked for a return

| # | Someone can | Initiative | Needs first | Build | Done when |
|---|---|---|---|---|---|
| M1.19 | A Customer can request a return, and a Dispatcher can schedule the pickup. | Return Flow #42, #43 | M1.8: pickups are planned with forward deliveries. | **System:** Create the return pickup. **Portal:** The Dispatcher schedules the pickup. The Customer views the pickup time. | A return request becomes a pickup with a time the Customer can see. |
| M1.20 | The driver can collect a return from the Customer. | Return Flow #44 | M1.19: there must be a pickup. M1.10: getting to the Customer. | **App:** View the return pickup. The Customer hands the return over and the driver takes the parcel. | A driver completes a return pickup in the app. The medicine details and the medicine check arrive in Milestone 3. |
| M1.21 | Returned and undelivered parcels can travel back to the warehouse, scanned at each handover. | Return Flow #45, #47, #48; Handover Validation #45, #47, #48 | M1.20 and M1.13: parcels to return. M1.7: scanning at the DC. | **Portal:** The DC Executive receives returned parcels and scans them. The Dispatcher receives them, scans and unloads, hands them to WH Ops and scans the handover. WH Ops receives and scans each parcel and reports damage or mismatch. **Note:** The drive back stays outside the system until Milestone 3. | A returned parcel is scanned in at the DC, at the Dispatcher and at the warehouse, and ends as received. |

## Milestone 2: Payout & Allocation

Starts from: Milestone 1 is done. The two chains below do not depend on each other.

### Chain 1. The driver's orders arrive batched, routed and allocated

Backwards: The driver sees a ready batch in the app ← the system allocated it to a driver on duty ← its stops are in a route ← orders and return pickups are grouped into batches

| # | Someone can | Initiative | Needs first | Build | Done when |
|---|---|---|---|---|---|
| M2.1 | The system groups orders and return pickups into batches, so a Dispatcher no longer builds them by hand. | Batch Creation #26 | M1.5 and M1.19: orders and return pickups. M1.8: the by-hand batch this replaces. | **System:** Create delivery batches. **Rules:** The business can adjust batching rules. | A location's morning orders and return pickups appear as batches in the portal without the Dispatcher grouping them. |
| M2.2 | Each batch has a route, and the driver sees the stops in order. | Route Optimisation #26 | M2.1: a route needs a batch. | **System:** Create routes. **App:** The driver views the route for the batch. | A driver opens a batch and sees its stops in sequence. |
| M2.3 | The system allocates each batch to a driver, and the driver sees it without a Dispatcher assigning it. | Automated Driver Allocation #26 | M2.1 and M2.2: routed batches. M1.3: who is on duty. M1.2: the pincodes each driver serves. | **System:** Allocate Last Mile Drivers and send the batches to their apps. **Rules:** The business can adjust allocation rules. **Portal:** The Dispatcher can still rearrange, as in M1.15. | On-duty drivers receive their batches at the start of the day with no Dispatcher assigning them. |
| M2.4 | The system replans the affected batches and routes when a delivery fails or plans change. | Automated Replanning #26, #40 | M2.3: a plan to replan. M1.13 and M1.14: failed deliveries. | **System:** Replan the affected batches and routes. Replan a failed delivery for the next day. **Portal:** The Dispatcher or DC Executive accepts the new plan or rearranges it, as in M1.15. | Marking a delivery failed produces a new plan that the Dispatcher accepts or rearranges. |

### Chain 2. The driver sees what they have earned

Backwards: The driver sees earnings and incentive progress in the app ← the system computed their earnings ← they have a pay structure ← attendance and deliveries are recorded

| # | Someone can | Initiative | Needs first | Build | Done when |
|---|---|---|---|---|---|
| M2.5 | A Team Lead can see who was on duty against each location's expected orders and arrange cover for absences. | Attendance Tracking #11 | M1.3 and M1.16: duty start and end. Payout calculation depends on this chunk. | **Portal:** The Team Lead reviews drivers on shift against expected orders and arranges cover. The DC Executive checks the drivers on duty. **System:** Show who is on duty. | For one location and day, the Team Lead sees who was on duty against expected orders, and a cover is arranged. |
| M2.6 | Every driver has a confirmed pay structure. | Driver & Vendor Payout #3, #8 | M1.2: the driver must exist. | **Portal:** Central Logistics Ops defines salary structures. A DC Executive or Dispatcher assigns one to a driver. The Team Lead and Central Logistics Ops confirm it. **System:** Hold the pay structures. | Every driver in a location has a confirmed pay structure. |
| M2.7 | The system computes each driver's earnings from attendance and deliveries. | Driver & Vendor Payout #49 | M2.5: attendance. M2.6: pay structure. M1.11: delivered orders. | **System:** Compute a driver's earnings. | A driver's earnings for a period match a manual calculation. |
| M2.8 | Finance can see what each vendor is owed. | Driver & Vendor Payout #52, #53 | M2.7: earnings per driver. | **System:** Roll driver earnings up per vendor. **Portal:** Finance calculates the amount owed to each vendor. Paying the vendor stays a manual exercise. | Finance sees the amount owed to each vendor for the month. |
| M2.9 | A driver can raise a pay dispute in the app, and it is settled in the system. | Driver & Vendor Payout #56, #57 | M2.7: earnings to dispute. | **App:** The driver raises a payout dispute. **Portal:** A DC Executive or Team Lead reviews and settles it, or escalates it to Central Logistics Ops. **System:** Adjust the driver's earnings. | A dispute raised in the app is settled and the driver's earnings change. |
| M2.10 | The driver sees their earnings and incentive progress in the app, and a Team Lead can grant an incentive. | Incentives #3, #49, #50, #51 | M2.7: earnings. | **Portal:** Central Logistics Ops defines incentive schemes. The Team Lead grants an incentive to a driver. **System:** Track incentive progress. **App:** The driver views earnings and incentive progress. | A driver sees earnings and incentive progress in the app, and the Team Lead grants an incentive. |

## Milestone 3: Visibility & Verification

Starts from: Milestone 1 is done. It needs nothing from Milestone 2. The three chains below do not depend on each other.

### Chain 1. The driver checks the medicine at a return pickup

Backwards: The driver records the check ← the driver sees the medicine details ← a return pickup exists

| # | Someone can | Initiative | Needs first | Build | Done when |
|---|---|---|---|---|---|
| M3.1 | The driver can see the medicine details at a return pickup and check the medicine against the order. | Reverse QC #44 | M1.20: return pickups. | **App:** The driver views the medicine details on the return pickup and checks the medicine against the order details. **System:** Show the medicine details on the pickup. | A driver opens a return pickup, sees the medicine details and completes the pickup with the medicine checked against the order. |

### Chain 2. The system checks the driver is at the Customer's location

Backwards: The system checks the driver's location ← the driver delivers, fails or collects ← the Customer's location is known

| # | Someone can | Initiative | Needs first | Build | Done when |
|---|---|---|---|---|---|
| M3.2 | The system checks the driver is at the Customer's location when they deliver, mark a delivery failed or collect a return. | Geofencing #32, #38, #44 | M1.11, M1.13 and M1.20: the three actions. The Customer's location, from Address Quality Interventions. | **System:** Check the driver's location at each of the three actions. | A delivery, a failed delivery and a return pickup are each checked against the Customer's location. |

### Chain 3. Orders reach a DC as consignments

Backwards: The driver picks orders from the DC bin ← the DC received the consignment ← the vehicle carried it ← the Dispatcher recorded the vendor, vehicle and driver ← the Dispatcher built the consignment

| # | Someone can | Initiative | Needs first | Build | Done when |
|---|---|---|---|---|---|
| M3.3 | A Dispatcher can build a consignment of the shipments bound for one DC. | Mid-Mile Journey Orchestration #18; Consignment Capture #19 | M1.6 and M1.7: shipments in hand and scanned. | **Portal:** The Dispatcher sorts shipments into bins by destination and scans them into a consignment. **System:** Create the consignment. | Shipments for one DC sit under one consignment. |
| M3.4 | A Dispatcher can plan the trip, record the vendor, vehicle and driver, and load the consignment. | Mid-Mile Journey Orchestration #20, #21; Consignment Capture #22 | M3.3: a consignment to move. M1.2: vendors and vehicles. | **Portal:** The Dispatcher plans departures with the Team Lead, records the vendor, vehicle number, and the driver's name and phone, loads the consignment and scans the handover. **System:** Show the consignments ready to move. Record the vendor, vehicle and driver. | A consignment shows its vendor, vehicle and driver, and is marked loaded. |
| M3.5 | A Dispatcher or DC Executive can follow the vehicle's journey and flag a consignment lost, damaged or delayed. | Mid-Mile Journey Orchestration #23 | M3.4: a loaded consignment. | **System:** Show the live location of a vehicle. **Portal:** The Dispatcher or DC Executive views it and flags a consignment as lost, damaged or delayed. | A DC Executive sees a vehicle's location and flags a delayed consignment. |
| M3.6 | A DC Executive can receive the consignment and see anything missing or mismatched. | Consignment Capture #24 | M3.5: the journey. M1.7: scanning at the DC. | **Portal:** The DC Executive receives the consignment from the vehicle, scans and unloads it, and flags anything missing, damaged or mismatched. **System:** Flag missing or mismatched items. | A consignment received one shipment short shows the mismatch. |
| M3.7 | Returned shipments can travel back as a consignment and be received at the warehouse. | Mid-Mile Journey Orchestration #46; Consignment Capture #45, #47 | M3.5: following a journey. M1.21: returned parcels at the DC. | **Portal:** The DC Executive sends returned shipments back as a consignment. The Dispatcher receives the returned consignment. **System:** Show the vehicle's location on the way back, as in M3.5. | A returned consignment is followed from the DC to the warehouse and received by the Dispatcher. |
