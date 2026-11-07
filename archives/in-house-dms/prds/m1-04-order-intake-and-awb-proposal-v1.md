---
**Document:** Order Intake, AWB Generation & Print (milestone M1.4)
**Type:** PRD proposal (not yet a PRD)
**Version:** v1
**Date:** 2026-11-07
**Status:** Draft for discussion
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-11-07 | First proposal |
---

# [PRD Proposal] Order Intake, AWB Generation & Print

**Systems:** Tracking · Allocation · Serviceability · Payments (new in-house shipment state machine and AWB, built for the In-House DMS) · **Verticals:** Hyperlocal Forward, Hyperlocal Reverse

## How I read your ask

Engineering builds two things in this milestone. The PRD hands them what they need:

1. **The journey of a shipment, every scenario on the ground.** Engineering builds the shipment state machine from it. I took a stab at it: 98 scenarios in 12 groups, 29 states, in Part 1. Each scenario is also a transition of the state machine, so the catalogue is the main lookup of the PRD.
2. **The AWB as a PDF.** Engineering makes the format and prints it. Part 2 follows the Shipsy sample you attached (`success_awb.pdf`), element by element, with the exact text.

Nothing else is in the PRD: no portal screens, no rider app, no notices to the Customer. The repo's PRD format also asks for Metrics and Rollout; I kept them to one short table each, and you can tell me to drop them. The state machine is built once for the whole journey, so it also covers what later milestones scan (handover, trip, return). Each scenario says which milestone sends its event.

## What I need from you

Five questions. Each has my recommendation, so "yes to all" is a valid answer.

| # | Question | My recommendation |
|---|---|---|
| Q1 | **AWB number format.** The sample is 7 digits ("4573928"). What length, which characters, any prefix per warehouse or per type (forward, return)? | Digits only, one unique number for each shipment, never reused, readable by our handheld scanners. Length is yours to set. |
| Q2 | **What the label says for in-house shipments.** The sample prints "Courier Name: SHIPSY" and "Handover to SHIPSY", and a second barcode "999010939-Stage". What prints for us? | Courier Name "TRUEMEDS". "Handover to" shows the next stop: the DC name for a via-DC shipment, "Last mile" for a direct one. The second barcode is the Truemeds Order ID without the "-Stage" suffix, which I take to be a staging mark. |
| Q3 | **Changes after the AWB is generated.** Which are allowed? | Phone, items, weight, payment mode, and an address on the same path: accepted, and the label is reprinted before the box leaves. An address on another path or one we do not serve: refused, the Customer can cancel. After the box leaves, changes update the System and the driver's app only; the label is not reprinted. The Shipsy-era DMS Integration doc has the same lock on serviceability after AWB generation. |
| Q4 | **The path cannot be decided** (pincode has no zone, zone has no hub, or two paths found). Block or go ahead? | Block, with an alert to Central Logistics Ops. The sort code PRD let the AWB go out without the code, because the code only helps sorting. Here the path decides whether the box goes via a DC or direct, so a box with no path cannot be routed. |
| Q5 | **Customer return pickups.** Does the pickup carry a printed AWB, and who prints it? | The return pickup gets its own AWB number, as the courier reverse flow does today (a new ID and a new AWB for the pickup). WH Ops prints it and gives it to the driver with the pickup. Same format as Part 2. I need a sample of a Shipsy reverse AWB to settle the differences. |

One input I still need for the PRD itself: **the Success metric.** I propose some in the Metrics section; the PRD needs one from you.

## Defaults I applied (tell me if any is wrong)

| # | Default | Why |
|---|---|---|
| R1 | A cancellation after the shipment left the warehouse is an **RTO with the reason "cancelled"**. One return path, not a second one. | The parcel is physically out. It must come back whatever the reason. |
| R2 | Only a failed attempt on the Customer's side counts as an **attempt**: not available, unreachable, address, refused, cannot pay. A reschedule the Customer asks for does not. A failure on the driver's side (breakdown, shift ended) does not. The maximum number of attempts is the value Central Logistics Ops sets. | A driver's breakdown must not push a Customer towards an RTO. |
| R3 | A scan that does not fit the shipment's state is **rejected** with a message naming the current state. No manual override in this milestone. | A silent jump hides a ground mistake. Who may correct a state is a later question. |
| R4 | A COD parcel is not handed over until the driver records how the Customer paid. **Delivered does not wait for the bank or the QR confirmation.** Matching cash and QR stays with COD Reconciliation. | Keeps the state machine independent of payments. |
| R5 | **One shipment and one AWB for each order.** | The story map has no split shipments. |
| R6 | **A shipment finishes in the system that created it.** Neither Shipsy nor the new System takes over a shipment in flight. | Both systems cannot own one parcel. |
| R7 | **The ground wins.** If the driver delivered offline and the Customer cancelled online before the sync, the delivery stands and the clash is flagged. | The parcel is already with the Customer. |
| R8 | A voided AWB, a duplicate, an unknown barcode and a hub the user does not hold are scan rejections. The message for the hub is the one already in the Driver Management PRD: "You don't have access to this location." | One wording for one situation. |
| R9 | A shipment on hold or lost that turns up **continues from the state it left.** Damaged beyond delivery goes back as an RTO. | Nothing is lost from the journey. |
| R10 | A prepaid order prints **"PREPAID"** on the payment bar. The sample shows only the COD case. | A blank bar would look like an error. |
| R11 | The Customer's phone number prints **masked, as in the sample** ("XXXXXXXXXX"). The driver calls through the app. | The job list has "mask phone numbers between Customers and Drivers". The box is carried by the driver. |
| R12 | Every field of the label is mandatory except the PATH code. If one is missing, the AWB is not generated. | A label with a missing GSTIN or weight is worse than a wait. |

## Proposed outline of the PRD

| Section | What it holds |
|---|---|
| Objective | One sentence: every order that reaches a cut-over location becomes a shipment with a printed AWB, and its state is known at every step of its journey. |
| Why Now | Leadership has decided to end the Shipsy dependency. Locations grow from 39 to 150 in 15 months, and Shipsy's share of orders rises from 30% to above 50%. No order can reach a driver until it exists as a shipment with an AWB, and every later milestone reads or writes the shipment's state. |
| Use Case 1: The journey of a shipment | Part 1 below, written in your Step N style: the happy cases first (forward via a DC, forward direct, customer return), then each group of scenarios as edge cases. The state table is the main lookup. |
| Use Case 2: The AWB | Part 2 below: the sample attached to the PRD, the element table with exact text, the print rules. |
| Metrics, Rollout | Short, in the repo format. Proposed below. |
| Not in the PRD | Portal and app screens, notices to the Customer, the order system's interface, logging (the ARD). |

# Part 1. The shipment state machine

## The states


| Leg | State | What it means |
|---|---|---|
| Forward | **Created** | The order was received and a shipment exists. No AWB yet. |
| Forward | **AWB Generated** | The AWB number, barcode and path exist. Not yet printed. |
| Forward | **Ready for Dispatch** | The AWB is printed and on the box. The box waits at the warehouse. |
| Forward | **With Dispatcher** | WH Ops handed it to the Dispatcher with a scan. |
| Forward | **In Consignment** | Scanned into a consignment for a DC. Via-DC only. |
| Forward | **In Transit to DC** | The consignment is loaded and the handover is scanned. Via-DC only. |
| Forward | **At DC** | Scanned in at the DC. Via-DC only. |
| Forward | **In Bin** | Sorted into its bin at the DC. Via-DC only. |
| Forward | **Assigned to Driver** | In a batch given to a Last Mile Driver. Not yet with the driver. |
| Forward | **Out for Delivery** | The driver took it, with a scan. |
| Forward | **Delivered** (end) | Handed to the Customer, with proof of delivery. |
| Forward | **Delivery Failed** | The driver recorded a failed attempt with a reason. The parcel is still with the driver. |
| Forward and return | **Returned to Hub** | A driver brought the parcel back and it was scanned in at the DC or the warehouse. After a failed attempt or after a customer return pickup. |
| Forward | **Reattempt Scheduled** | A new attempt is planned for a new day. |
| Forward | **RTO Initiated** | The shipment is going back to the warehouse: attempts used up, or cancelled after it left the warehouse. |
| Forward | **Cancelled** (end) | Cancelled before it left the warehouse. Never dispatched. |
| Customer return | **Return Requested** | The Customer asked to return a delivered order. A return pickup exists. |
| Customer return | **Pickup Scheduled** | A pickup time is set. |
| Customer return | **Assigned for Pickup** | The pickup is in a driver's batch. |
| Customer return | **Picked Up** | The driver took the parcel from the Customer. |
| Customer return | **Pickup Failed** | The driver could not collect the parcel. A reason is recorded. |
| Customer return | **Pickup Closed** (end) | No pickup after the allowed attempts. |
| Customer return | **Return Cancelled** (end) | The Customer cancelled the return before pickup. |
| Return leg | **In Return Consignment** | Scanned into a consignment going back to the warehouse. |
| Return leg | **Return In Transit** | The return consignment is loaded and the handover is scanned. |
| Return leg | **Received at WH** | The Dispatcher scanned it in at the warehouse. |
| Return leg | **Returned** (end) | WH Ops scanned it in. The journey is over. |
| Any | **On Hold** | Something is missing, damaged or does not match. Waits for a decision. |
| Any | **Lost** (end) | Confirmed lost. |

The journeys in one line each:

- **Forward, via a DC:** Created → AWB Generated → Ready for Dispatch → With Dispatcher → In Consignment → In Transit to DC → At DC → In Bin → Assigned to Driver → Out for Delivery → **Delivered**.
- **Forward, direct:** Created → AWB Generated → Ready for Dispatch → With Dispatcher → Assigned to Driver → Out for Delivery → **Delivered**.
- **Failed delivery:** Out for Delivery → Delivery Failed → Returned to Hub → Reattempt Scheduled → Assigned to Driver (again), or → RTO Initiated → In Return Consignment → Return In Transit → Received at WH → **Returned**.
- **Customer return:** Return Requested → Pickup Scheduled → Assigned for Pickup → Picked Up → Returned to Hub → In Return Consignment → Return In Transit → Received at WH → **Returned**.

Other facts about a shipment are **flags**, not states: COD or prepaid, cold chain (gel packs), the number of attempts, and the reason on a failure, hold or cancellation.

## Every scenario on the ground

How to read the tables: **From** and **To** are states. "no change" means the event is recorded and the state stays. **Event arrives with** is the milestone that builds the screen or scan that sends the event; the state machine itself is built here, in M1.4. Q and R point to the questions and the defaults above.


### A. The order arrives

| # | What happens on the ground | Event | From | To | Arrives with | Note |
|---|---|---|---|---|---|---|
| A1 | An order is placed for a location that has cut over. The order system sends it. | Order received | none | Created | M1.4 |  |
| A2 | The same order is sent twice (a retry). | Order received again | no change | no change | M1.4 | One shipment only. The second message is ignored. |
| A3 | An order is placed for a location that has not cut over. | Order received | none | no shipment | M1.4 | The order stays on Shipsy. See L1. |
| A4 | An order arrives with a detail that cannot be used: no pincode, a pincode we do not serve, no address, no phone, no weight. | Order received, refused | none | no shipment | M1.4 | The reason is recorded. The order system can send it again once it is corrected. |
| A5 | The System is down when the order is placed. | Order received late | none | Created | M1.4 | No order is lost. The shipment is created when the order reaches the System. |
| A6 | The address, phone, items or payment mode change before the AWB is generated. | Order updated | Created | Created | M1.4 | The details are replaced. Nothing was printed. |
| A7 | The Customer cancels before the AWB is generated. | Order cancelled | Created | Cancelled | M1.4 |  |
| A8 | The order is moved to another warehouse before the AWB is generated. | Order moved | Created | Cancelled | M1.4 | The old shipment closes. A new shipment is created at the new warehouse (A1). See B11 for after the AWB. |

### B. The AWB is generated and printed

| # | What happens on the ground | Event | From | To | Arrives with | Note |
|---|---|---|---|---|---|---|
| B1 | The System generates the AWB number and barcode, and decides the path: direct from the warehouse, or via a DC. | AWB generated | Created | AWB Generated | M1.4 | The path comes from the location's flow setting and the zone, hub and DC mappings. The PATH bar of the label carries it. |
| B2 | The path cannot be decided: the pincode has no zone, the zone has no hub, or more than one path is found. | AWB not generated | Created | Created | M1.4 | Q4. The shipment waits and an alert goes out, because the path decides how the box moves. |
| B3 | WH Ops prints the AWB and sticks it on the box. | AWB printed | AWB Generated | Ready for Dispatch | M1.4 |  |
| B4 | The label is torn or smudged, or the printer was offline. WH Ops prints it again. | AWB reprinted | no change | no change | M1.4 | Same AWB number, same content. Each reprint is recorded. |
| B5 | The phone number changes after the AWB is generated. | Order updated | AWB Generated or Ready for Dispatch | no change | M1.4 | Q3. The AWB is reprinted before the box is handed over. |
| B6 | The address changes to another place on the same path (same zone, same hub). | Order updated | AWB Generated or Ready for Dispatch | no change | M1.4 | Q3. The AWB is reprinted. Same AWB number. |
| B7 | The address changes to a pincode on another path, or to a pincode we do not serve. | Order updated, refused | AWB Generated or Ready for Dispatch | no change | M1.4 | Q3. The change is refused. The Customer can cancel. |
| B8 | Items or weight change because some medicines were removed, so the COD amount changes too. | Order updated | AWB Generated or Ready for Dispatch | no change | M1.4 | The AWB is reprinted with the new quantity, weight and COD amount. If every item is removed, it is a cancellation (B9). |
| B9 | The Customer cancels after the AWB is generated, with or without the label on the box. | Order cancelled | AWB Generated or Ready for Dispatch | Cancelled | M1.4 | The AWB number is voided. WH Ops is told to take the box off the dispatch pile. |
| B10 | The payment mode changes from prepaid to COD, or back, after the AWB is generated. | Order updated | AWB Generated or Ready for Dispatch | no change | M1.4 | The payment line changes, so the AWB is reprinted. |
| B11 | The order is moved to another warehouse after the AWB is generated. | Order moved | AWB Generated or Ready for Dispatch | Cancelled | M1.4 | The AWB is voided. A new shipment is created at the new warehouse. |

### C. Handover at the warehouse

| # | What happens on the ground | Event | From | To | Arrives with | Note |
|---|---|---|---|---|---|---|
| C1 | WH Ops hands ready shipments to the Dispatcher and scans each one. The System generates the manifest. | Handover scanned | Ready for Dispatch | With Dispatcher | M1.5 | A cold-chain order is flagged, and the Dispatcher adds gel packs. This is a flag on the shipment, not a state. |
| C2 | WH Ops scans a shipment that is not ready: the AWB is not printed, or the order is cancelled. | Scan rejected | no change | no change | M1.5 | A message says why. |
| C3 | The same shipment is scanned twice. | Scan rejected | no change | no change | M1.5 | The second scan is refused as a duplicate. |
| C4 | A shipment is on the manifest but was never scanned. | Manifest closed with a shortfall | Ready for Dispatch | no change | M1.5 | The shipment stays at the warehouse and is flagged. |

### D. Via a DC: consignment, drive and sorting

| # | What happens on the ground | Event | From | To | Arrives with | Note |
|---|---|---|---|---|---|---|
| D1 | The Dispatcher sorts shipments by destination DC and scans them into a consignment. The System creates the consignment. | Scanned into consignment | With Dispatcher | In Consignment | M1.5 |  |
| D2 | A shipment is scanned into a consignment for a DC other than the one on its path. | Scan rejected | no change | no change | M1.5 |  |
| D3 | A shipment is taken out of a consignment before loading: cancelled, or scanned in by mistake. | Removed from consignment | In Consignment | With Dispatcher | M1.5 | A cancelled shipment follows B9 or I1. |
| D4 | The vendor, vehicle and driver are recorded, the consignment is loaded and the handover is scanned. | Consignment loaded | In Consignment | In Transit to DC | M1.5 |  |
| D5 | The vehicle leaves late, breaks down, or the driver changes. | Vehicle details updated | no change | no change | M1.5, drive tracked in M3 | Until Milestone 3 the drive is outside the System. The shipment stays In Transit to DC until it is scanned in. |
| D6 | The consignment reaches the DC. The DC Executive scans and unloads every shipment, and all match the manifest. | Scanned in at DC | In Transit to DC | At DC | M1.5 |  |
| D7 | A shipment on the manifest is not in the consignment at the DC. | Shortfall flagged | In Transit to DC | On Hold | M1.5 | Reason: missing. See K2 and K3. |
| D8 | A shipment arrives damaged. | Damage reported | In Transit to DC | On Hold | M1.5 | Reason: damaged. See K3. |
| D9 | A shipment that is not on the manifest is scanned in, for example one meant for another DC. | Mismatch flagged | In Transit to DC | On Hold | M1.5 | Reason: not on the manifest. See K3. |
| D10 | The DC Executive sorts each shipment. The System shows its bin. | Sorted into bin | At DC | In Bin | M1.5 |  |

### E. Planning the delivery and handing over to the driver

| # | What happens on the ground | Event | From | To | Arrives with | Note |
|---|---|---|---|---|---|---|
| E1 | Direct flow: the shipment goes from the Dispatcher into a batch at the warehouse. There is no DC. | Batch assigned | With Dispatcher | Assigned to Driver | M1.6 |  |
| E2 | Via a DC: the System, or the Dispatcher or DC Executive by hand, puts the shipment in a batch and gives it to a driver. | Batch assigned | In Bin | Assigned to Driver | M1.6 |  |
| E3 | No driver serves the pincode, or none is on duty. | none | In Bin or With Dispatcher | no change | M1.6 | The shipment shows as unassigned until a batch is made by hand. |
| E4 | A driver goes on leave or the vehicle breaks down. The batch is replanned and given to another driver. | Batch replanned | Assigned to Driver | no change | M1.7 | The shipment now belongs to the new driver. |
| E5 | The driver picks the batch from the bin, or at the warehouse. The DC Executive or Dispatcher scans each shipment. | Handover to driver scanned | Assigned to Driver | Out for Delivery | M1.5 |  |
| E6 | The driver brings a shipment that is not in the batch. | Scan rejected | no change | no change | M1.5 |  |

### F. At the door

| # | What happens on the ground | Event | From | To | Arrives with | Note |
|---|---|---|---|---|---|---|
| F1 | The Customer takes the order. The driver collects proof of delivery. A COD order is paid in cash. | Delivered | Out for Delivery | Delivered | M1.8 | R4: how the Customer paid is recorded before the parcel is handed over. |
| F2 | A prepaid order is handed over. | Delivered | Out for Delivery | Delivered | M1.8 |  |
| F3 | A COD order is paid by QR. | Delivered | Out for Delivery | Delivered | M1.10 | The QR payment is matched later by COD Reconciliation (R4). |
| F4 | Someone other than the Customer takes the parcel: a family member or the security guard. | Delivered | Out for Delivery | Delivered | M1.8 | Who received it is recorded with the proof. |
| F5 | The parcel is handed over at a place other than the address on the order. | Delivered | Out for Delivery | Delivered | M1.14 | The place is recorded against the address. |
| F6 | The Customer asks to reschedule, by call or at the door. | Rescheduled | Out for Delivery | Returned to Hub | M1.9 | The parcel comes back and G3 plans the new day. R2: a reschedule the Customer asks for is not a failed attempt. |
| F7 | The Customer is not there: door locked, nobody at the address. | Delivery failed | Out for Delivery | Delivery Failed | M1.12 | Reason: customer not available. Counts as an attempt. |
| F8 | The Customer cannot be reached by phone. | Delivery failed | Out for Delivery | Delivery Failed | M1.12 | Reason: customer unreachable. Counts as an attempt. |
| F9 | The address is wrong or incomplete, or the driver cannot find it. | Delivery failed | Out for Delivery | Delivery Failed | M1.12 | Reason: address. Counts as an attempt. See G7 and G8. |
| F10 | The Customer refuses the order at the door. | Delivery failed | Out for Delivery | Delivery Failed | M1.12 | Reason: refused. Counts as an attempt. |
| F11 | A COD Customer cannot or will not pay. | Delivery failed | Out for Delivery | Delivery Failed | M1.12 | Reason: cannot pay. Counts as an attempt. |
| F12 | The driver cannot finish: breakdown, accident, heavy rain, or the shift ends. | Delivery failed | Out for Delivery | Delivery Failed | M1.12 | Reason: driver unable. R2: not counted as an attempt. |
| F13 | Proof of delivery cannot be collected: no OTP, the photo fails. | none | Out for Delivery | no change | M1.8 | The parcel is not marked Delivered. The driver can mark the attempt failed. |
| F14 | The driver works offline, delivers, and syncs later. | Delivered (synced) | Out for Delivery | Delivered | M1.8 | The time of the delivery is the time the driver acted, not the time of the sync. |
| F15 | The driver delivers offline. Before the sync, the Customer cancelled online. | Delivered (synced) | Out for Delivery | Delivered | M1.8 | R7: the delivery stands. The clash is flagged. |
| F16 | The same delivery is reported twice. | Delivered again | no change | no change | M1.8 | The second report is ignored. |

### G. After a failed attempt

| # | What happens on the ground | Event | From | To | Arrives with | Note |
|---|---|---|---|---|---|---|
| G1 | The driver brings the parcel back. The DC Executive, or the Dispatcher in the direct flow, scans it in. | Scanned back at hub | Delivery Failed | Returned to Hub | M1.12, M1.5 |  |
| G2 | The driver does not bring the parcel back by the end of the shift. | Time limit crossed | Delivery Failed | no change | M1.12 | An alert goes to the DC Executive or Dispatcher and the Control Tower. |
| G3 | The System decides on a reattempt: attempts are left and the reason allows it. Or the Customer asked to reschedule (F6). | Reattempt decided | Returned to Hub | Reattempt Scheduled | M1.12, M1.9 | The maximum number of attempts is set by Central Logistics Ops. |
| G4 | The System decides on an RTO: attempts are used up, the Customer refused, or the cut-off has passed. | RTO decided | Returned to Hub | RTO Initiated | M1.12 |  |
| G5 | The new day comes. The shipment is replanned into a batch. | Batch assigned | Reattempt Scheduled | Assigned to Driver | M1.9 |  |
| G6 | The Customer answers the message after a failed delivery and picks a new date. | Reschedule | Reattempt Scheduled | no change | M1.9 | The planned day changes. |
| G7 | The Customer gives a corrected address on the same path. | Order updated | Returned to Hub or Reattempt Scheduled | no change | M1.12 | Q3. The driver's app shows the new address. The label on the box is not reprinted. |
| G8 | The Customer gives an address on another path, or one we do not serve. | Order updated, refused | Returned to Hub or Reattempt Scheduled | no change | M1.12 | Q3. Refused. The Customer can cancel (G9). |
| G9 | The Customer cancels instead. | Order cancelled | Returned to Hub or Reattempt Scheduled | RTO Initiated | M1.12 | R1. A prepaid refund is outside the shipment. |
| G10 | A driver marks the delivery failed far from the address, or without any call to the Customer. | Fraud signal | no change | no change | M1.12 | The Control Tower is alerted. The state does not change. |

### H. The parcel goes back to the warehouse (RTO)

| # | What happens on the ground | Event | From | To | Arrives with | Note |
|---|---|---|---|---|---|---|
| H1 | Via a DC: the DC Executive scans RTO shipments into a consignment going back to the warehouse. | Scanned into return consignment | RTO Initiated | In Return Consignment | M1.5 |  |
| H2 | The return consignment is loaded and the handover is scanned. | Return consignment loaded | In Return Consignment | Return In Transit | M1.5 |  |
| H3 | The Dispatcher at the warehouse receives the consignment and scans each shipment. | Scanned in at WH | Return In Transit | Received at WH | M1.5 |  |
| H4 | The Dispatcher hands the parcels to WH Ops, who scan each on receipt. | Received by WH Ops | Received at WH | Returned | M1.5 |  |
| H5 | Direct flow: the driver brings the RTO parcel to the warehouse. WH Ops scans it on receipt. | Received by WH Ops | RTO Initiated | Returned | M1.5 |  |
| H6 | A returned parcel is missing, damaged or does not match at the warehouse. | Discrepancy reported | Return In Transit or Received at WH | On Hold | M1.5 | See K3. |
| H7 | The Customer wants the same order again after an RTO. | none | Returned | no change | none | It is a new order and a new shipment (A1). |

### I. Cancelled after the shipment left the warehouse

| # | What happens on the ground | Event | From | To | Arrives with | Note |
|---|---|---|---|---|---|---|
| I1 | The Customer cancels while the shipment is With Dispatcher, In Consignment, In Transit to DC, At DC, In Bin, or Assigned to Driver. | Order cancelled | any of these states | RTO Initiated | M1.4, M1.5 | R1. The parcel keeps moving until its next scan, which sends it on the return leg (H1 to H4). The driver or DC is told in the portal. |
| I2 | The Customer cancels while the driver has the parcel. | Order cancelled | Out for Delivery | RTO Initiated | M1.4, M1.8 | The driver sees the cancellation in the app, does not deliver, and brings the parcel back. |
| I3 | The Customer cancels at the door, as the driver hands the parcel over. | Order cancelled | Out for Delivery | Delivered or RTO Initiated | M1.8 | R7. If the Customer already has the parcel, it is Delivered and the return path is J1. If not, it is I2. |
| I4 | A cancellation arrives for a shipment already Delivered. | Order cancelled, refused | Delivered | no change | M1.4 | It cannot be cancelled. The Customer returns it (J1). |

### J. The Customer returns an order

| # | What happens on the ground | Event | From | To | Arrives with | Note |
|---|---|---|---|---|---|---|
| J1 | The Customer asks to return a delivered order, in full or in part, in the app or through CSR. | Return requested | none | Return Requested | M1.13 | A new return pickup is created, linked to the original order. It carries its own AWB number (Q5). |
| J2 | A return is requested for an order that is not Delivered, or past the return window. | Return requested, refused | none | no return pickup | M1.13 | The window is set by the order system. |
| J3 | The Dispatcher schedules the pickup. The Customer sees the time. | Pickup scheduled | Return Requested | Pickup Scheduled | M1.13 |  |
| J4 | The pickup is put in a driver's batch, with the forward deliveries. | Batch assigned | Pickup Scheduled | Assigned for Pickup | M1.6, M1.13 |  |
| J5 | The driver checks the medicines against the order, the Customer hands them over, and the driver takes the parcel. | Picked up | Assigned for Pickup | Picked Up | M1.8 |  |
| J6 | The Customer is not there, will not hand it over, or the medicines do not match the order. | Pickup failed | Assigned for Pickup | Pickup Failed | M1.13 | A reason is recorded. |
| J7 | A new pickup time is set. | Pickup scheduled | Pickup Failed | Pickup Scheduled | M1.13 |  |
| J8 | The allowed attempts are used up. | Pickup closed | Pickup Failed | Pickup Closed | M1.13 | Whether a refund follows is outside the shipment. |
| J9 | The Customer cancels the return before the driver comes. | Return cancelled | Return Requested, Pickup Scheduled or Assigned for Pickup | Return Cancelled | M1.13 |  |
| J10 | The driver brings the parcel to the DC, or to the warehouse in the direct flow, and it is scanned in. | Scanned in at hub | Picked Up | Returned to Hub | M1.5 |  |
| J11 | Via a DC: the parcel goes back as a return consignment, as H1 to H4. | Scanned into return consignment | Returned to Hub | In Return Consignment | M1.5 | Then Return In Transit, Received at WH and Returned. |
| J12 | Direct flow: WH Ops scans the parcel on receipt at the warehouse. | Received by WH Ops | Returned to Hub | Returned | M1.5 |  |

### K. When something goes wrong with the parcel or a scan

| # | What happens on the ground | Event | From | To | Arrives with | Note |
|---|---|---|---|---|---|---|
| K1 | A shipment is reported lost by the Dispatcher, a DC Executive, WH Ops or the Control Tower. | Reported lost | any state after With Dispatcher | Lost | M1.5 |  |
| K2 | A shipment on hold or reported lost turns up. | Found | On Hold or Lost | the state it left | M1.5 | R9. It carries on from where it was. |
| K3 | A hold is settled: the shipment is fine, or too damaged to deliver, or confirmed lost. | Hold settled | On Hold | the state it left, RTO Initiated, or Lost | M1.5 | R9. Damaged beyond delivery goes back to the warehouse as an RTO. |
| K4 | A shipment shows no movement for longer than the time limit of its state. | Time limit crossed | no change | no change | M1.5 | An alert goes to the Control Tower. The limits are set by Central Logistics Ops. |
| K5 | A scan does not fit the shipment's state. For example, a delivery scan for a shipment still In Consignment. | Scan rejected | no change | no change | M1.5 | R3. The message names the shipment's current state. |
| K6 | A barcode matches no shipment. | Scan rejected | no change | no change | M1.5 |  |
| K7 | A user scans a shipment of a hub that is not on their list. | Scan rejected | no change | no change | M1.5 | "You don't have access to this location." |
| K8 | Two people scan the same shipment at the same time. | Scan rejected | no change | no change | M1.5 | The first scan counts. The second is refused as a duplicate. |

### L. Cutover from Shipsy

| # | What happens on the ground | Event | From | To | Arrives with | Note |
|---|---|---|---|---|---|---|
| L1 | A location cuts over. From the cutover time, its new orders become shipments in the System. Orders already on Shipsy finish on Shipsy. | none | none | none | Cutover | R6. No shipment moves between the two systems. |
| L2 | A location is rolled back to Shipsy. Its new orders go to Shipsy again. Shipments already in the System finish in the System. | none | none | none | Cutover | R6. |

## What the System must receive with the order

The AWB prints these, and the path decision reads some of them. Intake has to capture exactly this, no more.

| Detail | Used for | On the AWB |
|---|---|---|
| Order ID | Links the shipment to the order | Yes, second barcode |
| Order type (forward or return pickup) | The first part of the path code | In the PATH bar |
| Serving warehouse | The path, the seller details, the return address | Sold By, GSTIN, Return Address |
| Customer name | Delivery | Yes |
| Delivery address, in lines | Delivery, the zone | Yes |
| Delivery pincode | Zone, hub, DC, serviceability | Yes |
| Customer phone | Calls through the app, messages after a failed delivery | Yes, masked |
| Payment mode and COD amount | What the driver collects | Yes |
| Number of items and total weight | Batch planning | Yes |
| Cold-chain flag | Gel packs | No |

## What the machine reads and does not own

Set by others, read here: each location's flow (direct or via a DC), the zone, hub and DC mappings, the maximum number of attempts, the time limit of each state before an alert, and the lists of reasons.

Reasons proposed for a failed delivery: customer not available, customer unreachable, address wrong or not found, refused at the door, cannot pay, driver unable. For a hold: missing, damaged, not on the manifest, does not match. For a cancellation: by the Customer, order moved to another warehouse, after dispatch.

# Part 2. The AWB

Source: the Shipsy AWB sample `success_awb.pdf`. The PRD will attach it, so engineering has the exact look.

## The label

- One AWB is one page. The sample is **A6 portrait** (105 × 148 mm), produced as a PDF. Content starts at the top. The sample leaves about the bottom sixth empty.
- Black, white and grey only. No other colour.
- Text in a plain sans-serif face, as in the sample. Bold where the sample is bold.
- A **dashed line** runs around the label.
- The two barcodes are 1D barcodes. The sample's look is Code 128, but I could not decode it. Engineering should scan the sample before building.

```
┌ - - - - - - - - - - - - - - - - - - - - - - ┐
 [1]            truemeds (grey)
 ┌──────────────────────────────────────────┐
 │ [2] PATH: FWD_MUM_BHW_MUE  (white on black) │
 └──────────────────────────────────────────┘
 [3] CASH ON DELIVERY || COD Amount: 160.73 INR   (grey bar)
 [4] Delivery Address:                        [5] 400079
     abc xyz
     flatnear seanear sea
     Contact Number: XXXXXXXXXX
 [6] Courier Name: SHIPSY   Courier AWB No: 4573928  (grey band)
 [7]        ||||| barcode of the AWB number |||||
                       4573928
 [8] Sold By: <legal name and address>
 [9] GSTIN: 27ABBCA6074H1ZN
 [10] Product | Qty | Total Wt(Kg)
      Medicine(s) | 1 | 0.01
 [11] Handover to SHIPSY   (white on black)
      ||||| barcode of the Order ID |||||
                  999010939-Stage
 [12] Return Address: <legal name and address>
└ - - - - - - - - - - - - - - - - - - - - - - ┘
```

## The elements, top to bottom

| # | Element | Exact text and look | Value comes from | Rule |
|---|---|---|---|---|
| 1 | Logo | The Truemeds logo, grey, centred at the top | Fixed | The logo file is never edited |
| 2 | PATH bar | Full-width black bar, white bold text, "PATH: " then the sort code | The sort code of the AWB Sort Identifier Code PRD: `<OrderType>_<Warehouse>_<DC>_<Delivery_Zone>`, or `<OrderType>_<Warehouse>_<Delivery_Zone>` when there is no DC. Aliases exactly as configured. Example FWD_MUM_BHW_MUE | If the path cannot be built the AWB is not generated (Q4) |
| 3 | Payment bar | Full-width grey bar, bold text | COD: "CASH ON DELIVERY \|\| COD Amount: " amount with two decimals, " INR". Prepaid: "PREPAID" (R10) | The amount is the amount the driver collects |
| 4 | Delivery address | "Delivery Address:" in bold, then the Customer's name, then the address lines, then "Contact Number: " and the number | The order | The number is masked (R11). The address wraps over as many lines as it needs and the label stays on one page |
| 5 | Pincode | Large bold digits at the top right of the address block | The order | Six digits |
| 6 | Courier line | Grey band: "Courier Name: " and the name, then "Courier AWB No: " and the AWB number | The System (Q1, Q2) | Both labels stay as in the sample |
| 7 | AWB barcode | A barcode centred under the band, with the AWB number in large bold digits below | The AWB number | Scans to the AWB number only |
| 8 | Sold By | A box. "Sold By:" in bold, then the seller's legal name and registered address as one paragraph | The serving warehouse's seller entity | One seller for each warehouse |
| 9 | GSTIN | A row of the same box: "GSTIN: " and the 15 characters | The serving warehouse's seller entity | |
| 10 | Product table | Three columns: "Product", "Qty", "Total Wt(Kg)". One row: "Medicine(s)", the quantity, the total weight with two decimals | The order | The product text is always "Medicine(s)". No medicine name is printed |
| 11 | Handover | A black chip, white text: "Handover to " and the name. Under it a second barcode, and its text below in bold | The System (Q2) | The sample's barcode text is "999010939-Stage" |
| 12 | Return Address | "Return Address:" in bold, then the legal name and address | The serving warehouse | In the sample it is the same as Sold By |

## Print rules

- **Generate and print.** The System generates the AWB as a PDF in this format when the shipment reaches AWB Generated (B1). WH Ops prints it (B3).
- **Reprint** gives the same AWB number and the same content, unless a printed field changed (B5 to B10). Each reprint is recorded.
- **A voided AWB** (B9, B11) is never printed again, and a scan of it is rejected.
- **Mandatory fields.** If any element except the PATH bar has no value, the AWB is not generated and an alert says which (R12).
- **Number formats.** COD amount and weight with two decimals. Pincode six digits.

## What is different from the Shipsy label

1. "SHIPSY" no longer applies in the courier line and in the Handover chip (Q2).
2. The AWB number comes from the System, not from a courier (Q1).
3. The System builds the whole label, including the PATH bar. Today it builds the code and calls Clickpost for the rest.

## Facts to confirm with engineering and analytics before the PRD is final

- The longest delivery address in the last 30 days, and whether any address or name has characters other than English letters and digits.
- The barcode type of the sample, by scanning it.
- Which system holds each warehouse's seller legal name, registered address and GSTIN today.
- What "Qty" counts in the sample: items, units or boxes.

# Metrics (proposed, the Success metric is yours to set)

| Metric Type | Metric | Definition |
|---|---|---|
| Success | Shipments closed without a manual correction | Shipments that reach Delivered, Cancelled, Returned, Pickup Closed or Return Cancelled with no state corrected by a person ÷ shipments that reached one of those states in the period |
| Lead | Scans rejected as out of sequence | Scans rejected because they do not fit the shipment's state ÷ all scans |
| Check | Orders received with no shipment | Orders received from the order system for a cut-over location that have no shipment ÷ all such orders |
| Check | Shipments past the time limit of their state | Shipments in a state longer than that state's limit ÷ shipments in that state |
| Check | AWBs not generated for a missing field | AWB generations refused for a missing field ÷ all AWB generations |

# Rollout and stage gates (proposed)

| Stage | Intent | Rollout | Scale | Kill |
|---|---|---|---|---|
| 1 | Prove the state machine and the label at the first cutover location, next to Shipsy | The System receives every order of the location and creates the shipment and the AWB. WH Ops keeps using the Shipsy label. The state each shipment reaches is compared with Shipsy's status | Shipments past the time limit: threshold to be set from baseline. Orders received with no shipment: threshold to be set from baseline | Orders received with no shipment: threshold to be set from baseline |
| 2 | Go live at the first location | WH Ops prints the new AWB. Shipsy stops for this location | Same as Stage 1, plus shipments closed without a manual correction: target to be set from baseline | AWBs not generated for a missing field: threshold to be set from baseline |
| 3 | Every cutover location | Each location, at its cutover | Same as Stage 2 | Same as Stage 2 |

# Where this proposal is weakest

- The scenarios come from the story map, the NDR and reverse-leg Context documents and what I know of how medicines are delivered. No one on the ground has checked them. **A walk-through with a DC Executive and a Dispatcher would find the gaps.**
- The time limits, the number of attempts and the reason lists are placeholders for values that Central Logistics Ops owns.
- The reverse AWB (Q5) needs a sample.
