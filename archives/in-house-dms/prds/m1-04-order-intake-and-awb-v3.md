---
**Document:** Order Intake, AWB Generation & Print
**Type:** Executable PRD
**Version:** v3
**Date:** 2026-11-08
**Status:** Under Review
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-11-08 | Initial draft |
| v2 | 2026-11-08 | Every failed delivery counts as an attempt, whatever the reason and whoever caused it (Terms, F6, F12, Decision 9). The System has no concept of a consignment: handovers are scanned one shipment at a time, and no mid-mile vendor, vehicle or driver is recorded (Terms, Use Cases 1.1, 1.3, 2.4, 2.8, J11, Decision 18). |
| v3 | 2026-11-08 | Seven scenarios that cannot happen are removed (B8, B9, B12, B13, C2, D3, D4) and the groups are renumbered. A Dispatcher's handover scan of a cancelled shipment is rejected (D3, E7). D5 and G2 have no time limit. The return pickup label follows the Shipsy reverse sample (Use Case 3.2). The label font is Lato. |
---

# [PRD] Order Intake, AWB Generation & Print

**Systems:** Tracking · Allocation · Serviceability · Payments (the new in-house shipment and AWB; Payments has no Context yet) · **Verticals:** Hyperlocal Forward, Hyperlocal Reverse

**Contents**

- [1. Objective](#1-objective)
- [2. Why Now](#2-why-now)
- [3. Use Cases](#3-use-cases)
  - [Use Case 1: The journey of a shipment](#use-case-1-the-journey-of-a-shipment)
  - [Use Case 2: Every scenario on the ground](#use-case-2-every-scenario-on-the-ground)
  - [Use Case 3: The AWB](#use-case-3-the-awb)
  - [Open points](#open-points)
- [4. Metrics](#4-metrics)
- [5. Rollout & Stage Gates](#5-rollout--stage-gates)
- [6. Decisions](#6-decisions)

## 1. Objective

Every order placed for a cut-over location becomes a shipment with a printed AWB, and the System knows where the shipment is at every step until it is delivered or back at the warehouse.

## 2. Why Now

Shipsy handles Truemeds' rider creation, rider allocation, the rider's flow in the app, and tracking and reporting today. For a Shipsy order, Truemeds allocates the courier, builds the sort code and calls Clickpost to generate the AWB. WH Ops prints it and sticks it on the box.

Leadership has decided to end the dependency on Shipsy. Serving locations grow from 39 to 150 in the next 15 months, and the share of orders on Shipsy is projected to rise from 30% to above 50%. The in-house rider app and portal cannot run a single order until the order exists in the System as a shipment with an AWB. Every later piece reads or writes the shipment: handover scans, trips, delivery, failed delivery, RTO and customer returns. The first location cannot cut over without this.

The number of orders per location per day, and how often Shipsy's shipments need a manual correction, are not yet measured.

## 3. Use Cases

This PRD holds two things. Use Case 1 and Use Case 2 list every scenario on the ground in the life of a shipment. Engineering builds the shipment's life cycle from them: this PRD defines no states and no transitions. Use Case 3 is the AWB, taken from the Shipsy sample `success_awb.pdf`. It applies to Hyperlocal Forward and Hyperlocal Reverse. Portal screens, the rider app, notices to the Customer, the order system's interface and logging (the ARD) are not in this PRD. The portal is the Hyperlocal Fleet Management Portal.

**Terms**

- A shipment is what the System creates from one order. It carries one AWB. A return pickup is a shipment of its own, linked to the delivered order.
- A hub is a warehouse or a DC. A path is how the box moves: direct (warehouse, delivery zone), via a DC (warehouse, DC, delivery zone) or via two DCs (warehouse, DC, DC, delivery zone). The System resolves it from the pincode, as set up in Mid-Mile Entity Introduction.
- A batch is the group of shipments given to a Last Mile Driver for one trip.
- An attempt is a delivery that did not happen after the driver took the shipment out for delivery. It counts whatever the reason and whoever caused it.
- An RTO is a shipment going back to the warehouse that sent it, with a reason.
- A shipment on hold is one the System has flagged as missing, damaged or not matching, and that waits for the user at that hub to settle it.
- A cut-over location is a location whose new orders go to the System, not to Shipsy.

**Rules for every scenario**

- Each order has one shipment and one AWB. A shipment finishes in the system that created it. A shipment never moves between Shipsy and the System.
- The System has no concept of a consignment in this release. Every handover between two people is one scan of one shipment. The System records no mid-mile vendor, vehicle or driver.
- The ground wins. The System records what the person on the ground did, at the time they did it, even when a sync arrives later.
- A scan that does not fit where the System believes the shipment is gets rejected. The System tells the user why and where it believes the shipment is. No user can override this in this release.
- Central Logistics Ops sets two values, not this PRD: the maximum number of attempts, and the time a shipment may stay at each step before an alert. Neither is set yet.

### Use Case 1: The journey of a shipment

Who: WH Ops, Dispatcher, DC Executive, Mid-Mile Driver, Last Mile Driver, Customer and the System. After each step the System knows what is stated in it.

#### Use Case 1.1: Happy Case — a forward order via a DC

**Step 1:** The order system sends an order for a cut-over location. It carries the details in "What the System receives with an order". The System creates one shipment. The System knows the order has a shipment and no AWB.

**Step 2:** The System generates the AWB number and barcode, and resolves the path and the PATH code (Use Case 3). The System knows the AWB.

**Step 3:** WH Ops prints the AWB and sticks it on the box. The System knows the AWB is printed and the box is ready at the warehouse.

**Step 4:** WH Ops hands ready shipments to the Dispatcher and scans each one. The System generates the manifest and knows each shipment is with the Dispatcher.

**Step 5:** For an order that needs cold-chain protection, the Dispatcher adds gel packs after the handover.

**Step 6:** The Dispatcher sorts the shipments by the DC on their path, hands them to a Mid-Mile Driver, and scans each handover. The System knows each shipment is on its way to the DC.

**Step 7:** The Mid-Mile Driver drives to the DC. The driver has no app, and nothing is scanned on the drive.

**Step 8:** The DC Executive unloads the vehicle and scans each shipment at the DC. The System knows each shipment is at the DC.

**Step 9:** The DC Executive sorts each shipment into a bin. The System shows the bin.

**Step 10:** The Dispatcher or DC Executive creates a batch and gives it to a Last Mile Driver. The System knows the shipment is in the batch and which driver has it.

**Step 11:** The Last Mile Driver collects the batch from the bin. The DC Executive scans each shipment on the portal. The System knows the shipment is out for delivery with that driver.

**Step 12:** The Last Mile Driver reaches the Customer. For a COD order the driver records how the Customer paid before handing the parcel over. The driver collects proof of delivery and marks the shipment delivered.

**Step 13:** The System knows the shipment is delivered, with the time, the place and the proof. The journey is over.

#### Use Case 1.2: Happy Case — a forward order direct from the warehouse

**Step 1:** The order system sends an order for a cut-over location. The System creates one shipment. The System knows the order has a shipment and no AWB.

**Step 2:** The System generates the AWB number and barcode, and resolves the path and the PATH code (Use Case 3). The System knows the AWB.

**Step 3:** WH Ops prints the AWB and sticks it on the box. The System knows the AWB is printed and the box is ready at the warehouse.

**Step 4:** WH Ops hands ready shipments to the Dispatcher and scans each one. The System knows each shipment is with the Dispatcher. For an order that needs cold-chain protection, the Dispatcher adds gel packs after the handover.

**Step 5:** The Dispatcher creates a batch at the warehouse and gives it to a Last Mile Driver. The System knows the shipment is in the batch and which driver has it.

**Step 6:** The Dispatcher hands the batch to the driver and scans each shipment. The System knows the shipment is out for delivery with that driver.

**Step 7:** The Last Mile Driver reaches the Customer. For a COD order the driver records how the Customer paid before handing the parcel over. The driver collects proof of delivery and marks the shipment delivered.

**Step 8:** The System knows the shipment is delivered, with the time, the place and the proof. The journey is over.

#### Use Case 1.3: Happy Case — a Customer returns a delivered order

**Step 1:** The Customer asks to return a delivered order, in full or in part, in the app or through CSR. The System creates a return pickup, linked to the order, with its own AWB number.

**Step 2:** The Dispatcher schedules the pickup. The System knows the pickup time.

**Step 3:** The Dispatcher or DC Executive creates a batch with the pickup in it, together with forward deliveries, and gives it to a Last Mile Driver. The System knows which driver has the pickup.

**Step 4:** The Last Mile Driver reaches the Customer, checks the medicines against the order, and takes the parcel. The System knows the parcel is picked up.

**Step 5:** The driver takes the parcel to the DC. The DC Executive scans it in. The System knows the parcel is at the DC. In the direct flow the driver takes it to the warehouse instead, and WH Ops scans it in (J12).

**Step 6:** The DC Executive hands the parcel to a Mid-Mile Driver and scans the handover. The System knows the parcel is on its way to the warehouse.

**Step 7:** The Dispatcher at the warehouse scans each parcel as it arrives. The System knows the parcel is at the warehouse.

**Step 8:** The Dispatcher hands the parcels to WH Ops, who scan each one on receipt. The System knows the parcel is back. The journey is over.

### Use Case 2: Every scenario on the ground

Each row is one thing that can happen to a shipment and what the System does. A row that says the System rejects a scan means the System refuses the scan, records nothing else, and tells the user why. "The driver's app" means the rider app. The screens that send these events are built in later milestones: handover scans in Handover Validation, trips in Trip Flow, failed deliveries in Delivery Failed & RTO Management, rescheduling in Delivery Reschedule Flow, returns in Return Flow.

#### Use Case 2.1: Edge Case — A. The order arrives

| # | What happens on the ground | What the System does |
|---|---|---|
| A1 | An order is placed for a cut-over location. The order system sends it. | Creates one shipment. |
| A2 | The order system sends the same order twice. | Ignores the second message. The order keeps one shipment. |
| A3 | An order is placed for a location that has not cut over. | Creates no shipment. The order stays on Shipsy. |
| A4 | An order arrives without a detail the AWB needs: pincode, address, phone, payment mode, number of items or weight. | Refuses the order and records which detail is missing. The order system can send it again once corrected. |
| A5 | The System is down when the order is placed. | Creates the shipment when the order reaches it. |
| A6 | The address, phone, items or payment mode change while the shipment has no AWB yet. | Replaces the details on the shipment. |
| A7 | The Customer cancels while the shipment has no AWB yet. | Cancels the shipment. No AWB is made. |
| A8 | The order is moved to another warehouse while the shipment has no AWB yet. | Cancels the shipment and creates a new one at the new warehouse (A1). |

#### Use Case 2.2: Edge Case — B. The AWB is generated and printed

| # | What happens on the ground | What the System does |
|---|---|---|
| B1 | The System generates the AWB for a shipment. | Makes the AWB number and the barcode, resolves the path, builds the PATH code and the PDF (Use Case 3). |
| B2 | The path cannot be resolved or the code cannot be built: the pincode has no zone, the zone has no hub, an alias is missing, or more than one path is found. | Generates the AWB with the PATH bar blank. WH Ops prints it. The shipment continues. |
| B3 | A seller detail of the warehouse is missing: legal name, address or GSTIN. | Does not generate the AWB. Alerts Central Logistics Ops with the missing detail. The shipment waits, and the System generates the AWB as soon as the detail exists. |
| B4 | WH Ops prints the AWB and sticks it on the box. | Records the print. |
| B5 | The label is torn or smudged, or the printer was offline. WH Ops prints again. | Prints the same AWB number and the same content. Records each reprint. |
| B6 | The phone number changes after the AWB is generated, and the box has not left the warehouse. | Accepts the change. WH Ops reprints the AWB before the box is handed over. |
| B7 | The address changes to another place on the same path (same zone and hub), and the box has not left the warehouse. | Accepts the change. WH Ops reprints the AWB. The AWB number and the PATH code stay the same. |
| B8 | The Customer cancels after the AWB is generated, with or without the label on the box, and the box has not left the warehouse. | Cancels the shipment and voids the AWB number. Tells WH Ops to take the box off the dispatch pile. |
| B9 | The payment mode changes between prepaid and COD after the AWB is generated, and the box has not left the warehouse. | Accepts the change. WH Ops reprints the AWB with the new payment bar. |
| B10 | The phone, the address on the same path or the payment mode change after the box left the warehouse. | Accepts the change. Does not reprint. The driver's app shows the new details, and the System's values govern over the label. |

#### Use Case 2.3: Edge Case — C. Handover at the warehouse

| # | What happens on the ground | What the System does |
|---|---|---|
| C1 | WH Ops hands ready shipments to the Dispatcher and scans each one. | Generates the manifest. Knows each scanned shipment is with the Dispatcher. Flags a cold-chain order so the Dispatcher adds gel packs. |
| C2 | WH Ops scans the same shipment twice. | Rejects the second scan as a duplicate. |
| C3 | A shipment is on the manifest but was never scanned. | Keeps it at the warehouse and flags it as missing from the handover. |

#### Use Case 2.4: Edge Case — D. Via a DC: the drive and sorting

| # | What happens on the ground | What the System does |
|---|---|---|
| D1 | The Dispatcher sorts shipments by the DC on their path, hands them to a Mid-Mile Driver and scans each handover. | Knows each scanned shipment is on its way to the DC. |
| D2 | The Dispatcher scans a handover to a Mid-Mile Driver for a shipment whose path has no DC. | Rejects the scan. The shipment goes direct. |
| D3 | The Dispatcher scans a shipment that was cancelled, for handover to a Mid-Mile Driver. | Rejects the scan and says the shipment is cancelled. The Dispatcher gives the shipment back to WH Ops, who scan it on receipt (H3). |
| D4 | The shipments reach the DC. The DC Executive scans each one in. | Knows each scanned shipment is at the DC. |
| D5 | A shipment handed to a Mid-Mile Driver does not arrive at the DC. | Nothing automatic. The shipment stays on its way to the DC until the DC Executive scans it in. A user can report it lost (K1). |
| D6 | A shipment arrives damaged. | Puts the shipment on hold with the reason "damaged". |
| D7 | The DC Executive scans in a shipment meant for another DC. | Puts the shipment on hold with the reason "not for this DC". |
| D8 | The DC Executive sorts each shipment into a bin. | Shows the bin. Knows the shipment is in that bin. |
| D9 | The path has two DCs. At the first DC the DC Executive hands the shipment to a Mid-Mile Driver and scans the handover. At the second DC the DC Executive scans it in and sorts it into a bin. | Knows the shipment is on its way to the second DC, then at the second DC, then in a bin, as D1, D4 and D8. See Open points. |

#### Use Case 2.5: Edge Case — E. Planning the delivery and handing over to the driver

| # | What happens on the ground | What the System does |
|---|---|---|
| E1 | Direct flow: the Dispatcher creates a batch at the warehouse and gives it to a Last Mile Driver. | Knows the shipment is in the batch and which driver has it. |
| E2 | Via a DC: the Dispatcher or DC Executive creates a batch from the bin and gives it to a Last Mile Driver. | Knows the shipment is in the batch and which driver has it. |
| E3 | No driver serves the pincode, or none is on duty. | Shows the shipment as unassigned until the Dispatcher or DC Executive makes a batch for it. |
| E4 | A driver goes on leave or the vehicle breaks down. The Dispatcher or DC Executive replans the batch and gives it to another driver. | Knows the shipment now belongs to the new driver. |
| E5 | The driver collects the batch from the bin or at the warehouse. The DC Executive or Dispatcher scans each shipment. | Knows each shipment is out for delivery with that driver. |
| E6 | The driver brings a shipment that is not in the batch. | Rejects the scan. |
| E7 | The Dispatcher or DC Executive scans a shipment that was cancelled, for handover to a driver. | Rejects the scan and says the shipment is cancelled. The shipment goes back (H1 to H3). |

#### Use Case 2.6: Edge Case — F. At the door

| # | What happens on the ground | What the System does |
|---|---|---|
| F1 | The Customer takes a COD order and pays in cash. | Records how the Customer paid, which the driver does before handing the parcel over. Knows the shipment is delivered, with the proof. |
| F2 | The Customer takes a prepaid order. | Knows the shipment is delivered, with the proof. |
| F3 | The Customer pays a COD order by QR. | Knows the shipment is delivered. It does not wait for the bank. COD Reconciliation matches the payment later. |
| F4 | Someone other than the Customer takes the parcel: a family member or the security guard. | Knows the shipment is delivered. Records who received it with the proof. |
| F5 | The parcel is handed over at a place other than the address on the order. | Knows the shipment is delivered. Records the place against the address (Address Quality Interventions). |
| F6 | The Customer asks to reschedule, by call or at the door. | Knows the shipment is coming back to the hub. Counts as an attempt. G3 plans the new day. |
| F7 | The Customer is not there: the door is locked or nobody is at the address. | Records a failed attempt with the reason "customer not available". Counts as an attempt. |
| F8 | The Customer cannot be reached by phone. | Records a failed attempt with the reason "customer unreachable". Counts as an attempt. |
| F9 | The address is wrong or incomplete, or the driver cannot find it. | Records a failed attempt with the reason "address". Counts as an attempt. See G7 and G8. |
| F10 | The Customer refuses the order at the door. | Records a failed attempt with the reason "refused". Counts as an attempt. |
| F11 | A COD Customer cannot or will not pay. | Records a failed attempt with the reason "cannot pay". Counts as an attempt. |
| F12 | The driver cannot finish: breakdown, accident, heavy rain, or the shift ends. | Records a failed attempt with the reason "driver unable". Counts as an attempt. |
| F13 | Proof of delivery cannot be collected: no OTP, or the photo fails. | Does not mark the shipment delivered. The driver can mark the attempt failed (F7 to F11). |
| F14 | The driver works offline, delivers, and syncs later. | Records the delivery at the time the driver acted, not the time of the sync. |
| F15 | The driver delivers offline. Before the sync, the Customer cancelled online. | The delivery stands. Flags the clash. |
| F16 | The driver's app reports the same delivery twice. | Ignores the second report. |
| F17 | A driver marks a delivery from far from the address. | Raises a signal for the Control Tower. The shipment is unchanged. |

#### Use Case 2.7: Edge Case — G. After a failed attempt

| # | What happens on the ground | What the System does |
|---|---|---|
| G1 | The driver brings the parcel back. The DC Executive, or the Dispatcher in the direct flow, scans it in. | Knows the shipment is back at the hub. |
| G2 | The driver does not bring the parcel back by the end of the shift. | Nothing automatic. The shipment stays with the driver until a hub user scans it in (G1). A user can report it lost (K1). |
| G3 | The rules of Delivery Failed & RTO Management allow another attempt, or the Customer asked to reschedule (F6). | Decides a reattempt for a new day. |
| G4 | The rules of Delivery Failed & RTO Management allow no further attempt. | Decides an RTO. |
| G5 | The new day comes. | Puts the shipment in a batch again (E1 or E2). |
| G6 | The Customer answers the message after a failed delivery and picks a new date. | Changes the planned day. |
| G7 | The Customer gives a corrected address on the same path. | Accepts it. The driver's app shows the new address. The label on the box is not reprinted. |
| G8 | The Customer gives an address on another path, or one we do not serve. | Refuses it. The Customer can cancel (G9). |
| G9 | The Customer cancels instead of a reattempt. | Decides an RTO with the reason "cancelled". |

#### Use Case 2.8: Edge Case — H. The parcel goes back to the warehouse (RTO)

| # | What happens on the ground | What the System does |
|---|---|---|
| H1 | Via a DC: the DC Executive hands the RTO shipments to a Mid-Mile Driver and scans each handover. | Knows each scanned shipment is on its way to the warehouse. |
| H2 | The Dispatcher at the warehouse scans each shipment as it arrives. | Knows each scanned shipment is at the warehouse. |
| H3 | The Dispatcher hands the parcels to WH Ops, who scan each on receipt. | Knows the shipment is back. The journey is over. |
| H4 | Direct flow: the driver brings the RTO parcel to the warehouse. WH Ops scans it on receipt. | Knows the shipment is back. The journey is over. |
| H5 | A returned parcel is missing, damaged or does not match at the warehouse. | Puts the shipment on hold (K3). |
| H6 | The Customer wants the same order again after an RTO. | Nothing on this shipment. It is a new order and a new shipment (A1). |

#### Use Case 2.9: Edge Case — I. The Customer cancels after the shipment left the warehouse

| # | What happens on the ground | What the System does |
|---|---|---|
| I1 | The Customer cancels while the shipment is with the Dispatcher, on its way to the DC, at the DC, in a bin, or in a batch not yet collected. | Decides an RTO with the reason "cancelled". Rejects any forward handover scan of it (D3, E7). The portal shows the cancellation to the Dispatcher or DC Executive who holds the shipment, who sends it back (H1 to H3). |
| I2 | The Customer cancels while the driver has the parcel. | Decides an RTO with the reason "cancelled". The driver's app shows the cancellation. The driver does not deliver and brings the parcel back (G1). |
| I3 | The Customer cancels at the door as the driver hands the parcel over. | If the Customer already has the parcel, the delivery stands and the Customer returns it (J1). If not, as I2. |
| I4 | A cancellation arrives for a shipment already delivered. | Refuses it. The Customer returns the order (J1). |
| I5 | A cancellation arrives for a shipment that is already going back to the warehouse. | Records the cancellation. The return continues. |

#### Use Case 2.10: Edge Case — J. The Customer returns an order

| # | What happens on the ground | What the System does |
|---|---|---|
| J1 | The Customer asks to return a delivered order, in full or in part, in the app or through CSR. | Creates a return pickup, linked to the order, with its own AWB number and label (Use Case 3.2). |
| J2 | A return is requested for an order that is not delivered, or past the return window. | Refuses it. The window is set by the order system. |
| J3 | The Dispatcher schedules the pickup. | Records the pickup time. |
| J4 | The Dispatcher or DC Executive puts the pickup in a driver's batch, with the forward deliveries. | Knows which driver has the pickup. |
| J5 | The driver checks the medicines against the order, the Customer hands them over, and the driver takes the parcel. | Knows the parcel is picked up. |
| J6 | The Customer is not there, will not hand it over, or the medicines do not match the order. | Records a failed pickup with the reason. |
| J7 | A new pickup time is set after a failed pickup. | Records the new time. |
| J8 | The allowed pickup attempts are used up. | Closes the pickup. A refund is outside the shipment. |
| J9 | The Customer cancels the return before the driver comes. | Cancels the return pickup. |
| J10 | The driver brings the parcel to the DC, or to the warehouse in the direct flow, and it is scanned in. | Knows the parcel is at that hub. |
| J11 | Via a DC: the DC Executive hands the parcel to a Mid-Mile Driver and scans the handover. The Dispatcher at the warehouse scans it in and hands it to WH Ops, who scan it on receipt. | Knows the parcel is on its way to the warehouse, at the warehouse, and then back. The journey is over. |
| J12 | Direct flow: WH Ops scans the parcel on receipt at the warehouse. | Knows the parcel is back. The journey is over. |

#### Use Case 2.11: Edge Case — K. Something goes wrong with the parcel or a scan

| # | What happens on the ground | What the System does |
|---|---|---|
| K1 | The Dispatcher, a DC Executive, WH Ops or the Control Tower reports a shipment lost. | Records it as lost. |
| K2 | A shipment on hold or reported lost turns up. | Knows the shipment is where it was before, and the journey carries on from there. |
| K3 | The user at the hub settles a hold: the shipment is fine, or too damaged to deliver, or confirmed lost. | Fine: the journey carries on from where it was. Too damaged: decides an RTO. Confirmed lost: records it as lost. |
| K4 | A shipment shows no movement for longer than the time limit for where it is. | Alerts the Control Tower. |
| K5 | A scan does not fit where the System believes the shipment is. For example, a delivery scan for a shipment still at the warehouse. | Rejects the scan. The message says where the System believes the shipment is. |
| K6 | A barcode matches no shipment. | Rejects the scan. |
| K7 | A user scans a shipment of a hub that is not on their own list. | Rejects the scan with "You don't have access to this location." |
| K8 | Two people scan the same shipment at the same time. | Counts the first scan. Rejects the second as a duplicate. |

#### Use Case 2.12: Edge Case — L. Cutover from Shipsy

| # | What happens on the ground | What the System does |
|---|---|---|
| L1 | A location cuts over. | From the cutover time, its new orders become shipments in the System. Orders already on Shipsy finish on Shipsy. |
| L2 | A location is rolled back to Shipsy. | Its new orders go to Shipsy again. Shipments already in the System finish in the System. |

#### Use Case 2.13: Edge Case — M. Outside the journey

| # | What happens on the ground | What the System does |
|---|---|---|
| M1 | A Customer says an order marked delivered did not arrive. | Nothing on the shipment. The Grievance & Escalation Management Team handles it. |
| M2 | A refund is due after a cancellation, an RTO or a return. | Nothing on the shipment. Refunds are outside. |
| M3 | The cash a driver collected is deposited and matched to the bank. | Nothing on the shipment. COD Reconciliation handles it. |

**What the System receives with an order**

Intake captures exactly this. The AWB prints these and the path decision reads some of them.

| Detail | Used for | On the AWB |
|---|---|---|
| Order ID | Links the shipment to the order | Yes, second barcode |
| Order type (forward or return pickup) | First part of the PATH code | In the PATH bar |
| Serving warehouse | The path, the seller details, the return address | Sold By, GSTIN, Return Address |
| Customer name | Delivery | Yes |
| Delivery address, in lines | Delivery, the zone | Yes |
| Delivery pincode | Zone, hub, DC | Yes |
| Customer phone | Calls through the app, messages after a failed delivery | Yes, masked |
| Payment mode and COD amount | What the driver collects | Yes |
| Number of items and total weight | Batch planning | Yes |
| Cold-chain flag | Gel packs | No |

**What the System reads and does not own**

Set by others: each location's flow (direct, via a DC or via two DCs), the zone, hub and DC mappings and aliases, the maximum number of attempts, the time limit before an alert at each step, and the lists of reasons.

Reasons for a failed delivery: customer not available, customer unreachable, address, refused, cannot pay, driver unable. For a hold: missing, damaged, not for this DC, does not match. For a cancellation: by the Customer, order moved to another warehouse, after dispatch.

### Use Case 3: The AWB

Who: the System generates the AWB as a PDF. WH Ops prints it. The samples are `success_awb.pdf`, the Shipsy AWB, and `reverse_awb.pdf`, the Shipsy reverse AWB. Use Case 3 copies their format. Part of the sample's values change for the in-house label (Decisions).

#### Use Case 3.1: Happy Case — the forward label

**Step 1:** The System generates the AWB for the shipment (B1). It builds one PDF page with the elements below, in the order below.

**Step 2:** WH Ops prints the page and sticks it on the box (B4).

The label follows these rules.

| Item | Rule |
|---|---|
| Page | One AWB is one page. A6 portrait, 105 × 148 mm. The label starts at 14 mm from the top and ends at 122 mm. The bottom 26 mm of the page stays empty. |
| Colour | Black, white and two greys only: light grey (#EBEBEB) for the payment bar and the courier band, dark grey (#333333) for lines. The logo is black at 50% opacity. |
| Type | Lato Regular and Bold, the face embedded in the reverse sample. Sizes are measured from the sample and are approximate: the PATH bar text 12 pt bold, the pincode 11 pt bold, the AWB number and the second barcode text 8 pt bold, everything else 6 pt, with the labels ("Delivery Address:", "Sold By:", "Courier Name:") in bold. |
| Margins | The label is 95.8 mm wide, from 4.5 mm to 100.3 mm from the left edge. Content runs 5.3 mm to 99.5 mm. |
| Border | A dashed line runs down the left and right sides of the label, from the top of the PATH bar to the bottom of the Return Address block: 0.4 mm line, 1.2 mm dash, 1.2 mm gap, dark grey. A solid dark grey rule closes the bottom. |
| Barcodes | Both are Code 128, as in the sample (it uses subset C for digit pairs and switches subset for an odd digit or text). The narrowest bar is 0.4 mm and the bars are 10 mm tall. A scan reads only the text printed under it. |

```awb
┌ - - - - - - - - - - - - - - - - - - - - - - - ┐
 [1]               logo
 ┌─────────────────────────────────────────────┐
 │ [2] PATH: FWD_MUM_BHW_MUE   (white on black)│
 └─────────────────────────────────────────────┘
 [3] CASH ON DELIVERY || COD Amount: 160.73 INR   (grey bar)
 [4] Delivery Address:                      [5] 400079
     abc xyz
     flatnear seanear sea
     Contact Number: XXXXXXXXXX
 [6] Courier Name: Truemeds   Courier AWB No: 4573928  (grey band)
 [7]          ||||| barcode of the AWB number |||||
                          4573928
 [8] Sold By: <legal name and address>
 [9] GSTIN: 27ABBCA6074H1ZN
 [10] Product | Qty | Total Wt(Kg)
      Medicine(s) | 1 | 0.01
 [11] Handover to Truemeds   (white on black)
      ||||| barcode of the Order ID |||||
                    999010939
 [12] Return Address: <legal name and address>
└ - - - - - - - - - - - - - - - - - - - - - - - ┘
```

The elements, top to bottom. Positions are measured from the top edge of the page.

| # | Element | Exact text and look | Value comes from | Rule | Position (mm) |
|---|---|---|---|---|---|
| 1 | Logo | The Truemeds logo, centred. Use the logo image of the sample. | Fixed | Never edited, recoloured or stretched. | 5 to 13, 31 wide |
| 2 | PATH bar | Full-width black bar, 9.4 mm tall, white bold text centred: "PATH: " then the code. | The sort code of the AWB Sort Identifier Code PRD: `<OrderType>_<Warehouse>_<DC>_<Delivery_Zone>`, or `<OrderType>_<Warehouse>_<Delivery_Zone>` when there is no DC. OrderType is FWD or RVP. Aliases exactly as configured. | The bar prints even when the code is blank (B2). A reprint keeps the code built at generation. | 14 to 23.5 |
| 3 | Payment bar | Full-width light grey bar, bold text at the left. COD: "CASH ON DELIVERY \|\| COD Amount: " then the amount with two decimals, then " INR". Prepaid: "PREPAID". | The order | The amount is what the driver collects. | 23.5 to 28.5 |
| 4 | Delivery address | "Delivery Address:" in bold. Then the Customer's name, the address lines, and "Contact Number: " with the number. | The order | The number prints masked as ten X, as in the sample. The address wraps over as many lines as it needs. | 28.5 to 41.5 |
| 5 | Pincode | Large bold digits at the top right of the address block. | The order | Six digits. Printed only here. | 29.5 to 33 |
| 6 | Courier line | Light grey band: "Courier Name: " then "Truemeds", then "Courier AWB No: " and the AWB number. The two labels are bold. | The System | The AWB number is 7 digits. | 41.5 to 47 |
| 7 | AWB barcode | Code 128 centred (36.6 mm wide for a 7-digit number), with the AWB number in bold under it. | The AWB number | Scans to the AWB number and nothing else. | 50 to 63 |
| 8 | Sold By | A box with "Sold By: " in bold and the seller's legal name and registered address as one paragraph. | The serving warehouse's seller entity | One seller entity for each warehouse. | 66 to 75 |
| 9 | GSTIN | A row of the same box: "GSTIN: " and the 15 characters. | The serving warehouse's seller entity | | 75 to 78 |
| 10 | Product table | Three columns: "Product" (36 mm), "Qty" (17 mm), "Total Wt(Kg)" (41 mm). One header row and one row of values. | The order | The Product cell is always "Medicine(s)". No medicine name prints. Weight has two decimals. | 78 to 84 |
| 11 | Handover | A black chip, 20 mm wide, white text: "Handover to Truemeds". Under it a Code 128 barcode centred, with its text in bold under it. | The order | The barcode holds the Order ID, for example 999010939, with no "-Stage". | 85.5 to 103.5 |
| 12 | Return Address | A solid grey rule, then "Return Address:" in bold, then the legal name and the address. | The serving warehouse | In the sample it is the same as Sold By. | 106.5 to 122 |

**Print rules**

| Item | Rule |
|---|---|
| Number | The AWB number is 7 digits. The System never issues the same number to two shipments and never reuses a voided one. |
| Mandatory fields | Every element has a value, except the PATH code (B2). If a seller detail is missing, the AWB is not generated (B3). |
| Reprint | A reprint has the same AWB number and the same content, unless a printed field changed (B6, B7, B9). Each reprint is recorded. |
| Void | A voided AWB (B8) is never printed again. |
| Number formats | COD amount and weight with two decimals. Pincode with six digits. |
| Return pickup | A return pickup has its own AWB number and label (Use Case 3.2). |

#### Use Case 3.2: Happy Case — the return pickup label

**Step 1:** The System generates the return pickup's AWB when it creates the return pickup (J1). It builds one A6 PDF page with the elements below, in the order below.

The label has the colour, type, border and barcodes of Use Case 3.1. The sample is `reverse_awb.pdf`. It has no Sold By, no GSTIN and no Return Address block at the bottom. The label runs from 14.5 mm to 118 mm from the top, and its content from 5.4 mm to 95.5 mm from the left.

| # | Element | Exact text and look | Value comes from | Rule | Position (mm) |
|---|---|---|---|---|---|
| 1 | Logo | As on the forward label. | Fixed | Never edited, recoloured or stretched. | 5 to 13 |
| 2 | PATH bar | Full-width black bar, white bold text centred: "PATH: " then the code, for example RVP_MUM_BHW_MUE. | The sort code of the AWB Sort Identifier Code PRD, with OrderType RVP | Blank when the path cannot be resolved (B2). | 14.5 to 24 |
| 3 | Reason bar | Full-width light grey bar, bold text at the left: "REVERSE- Customer requested return". | Fixed for a Customer return pickup | Replaces the payment bar. The hyphen and the space are as in the sample. | 24 to 29 |
| 4 | Return Address | "Return Address:" in bold. Then the Customer's name, the pickup address lines, and "Contact Number: " with the Customer's number. | The return pickup | The number prints masked as ten X, as on the forward label. The sample prints it in full. | 29 to 42.5 |
| 5 | Pincode | Large bold digits at the top right of the block. | The pickup address | Six digits. | 29.5 to 33 |
| 6 | Courier line | Light grey band: "Courier Name: " then "Truemeds", then "Courier AWB No: " and the AWB number. The two labels are bold. | The System | The AWB number is 7 digits. | 42.5 to 48.5 |
| 7 | AWB barcode | Code 128 centred, with the AWB number in bold under it. | The AWB number | Scans to the AWB number and nothing else. | 51 to 64 |
| 8 | Product table | Three columns: "Product", "Qty", "Total Wt(Kg)". One header row and one row of values: "Medicine(s)", the quantity, the total weight. | The return pickup | Sits above the Delivery Address. Weight has two decimals. The sample prints 0.2. | 68 to 75 |
| 9 | Delivery Address | "Delivery Address:" in bold. Then the warehouse's legal name; the legal name, the warehouse name and the address on one line; "Contact Number: " with the warehouse's number; and the warehouse pincode in bold. | The serving warehouse | The parcel goes back here. | 76.5 to 96.5 |
| 10 | Handover | "Handover to Truemeds" as plain text, with no black chip. | The System | | 97 to 100 |
| 11 | Order ID barcode | A solid grey rule, then a Code 128 barcode centred, with its text in bold under it. | The return pickup's Order ID followed by "-R", as in the sample ("999011103-R") | A scan reads the text printed under it. | 100 to 115 |

### Open points

| # | Question | Who decides |
|---|---|---|
| 1 | The in-house AWB number is 7 digits, as is Shipsy's. Shipsy numbers and in-house numbers exist side by side during cutover. Which range of 7-digit numbers does the System use, so that none matches a number Shipsy has issued? | PM, with Engineering |
| 2 | A path can have two DCs (Mid-Mile Entity Introduction, Path Type 3). Does the first release support it (D9), and what does the PATH bar show, as the code holds one DC? | PM |
| 3 | Who prints a return pickup's AWB, and when, before the driver reaches the Customer? | PM |
| 4 | What happens when an address or a seller text is too long for one page, or holds characters other than English letters and digits? The longest address in the last 30 days is not yet measured. | Analytics, with Engineering |
| 5 | Which system holds each warehouse's seller legal name, registered address, GSTIN and phone number? What does "Qty" count: items, units or boxes? Is the first line under "Delivery Address:" in the forward sample the Customer's name? | Engineering |

## 4. Metrics

| Metric Type | Metric | Definition |
|---|---|---|
| Success | Orders with a printed AWB | Orders received for a cut-over location whose AWB was printed ÷ orders received for a cut-over location that were not cancelled before the AWB was generated |
| Success | Scans accepted | Scans accepted by the System ÷ all scans received for shipments of cut-over locations |
| Lead | Time to AWB | Median time from the System receiving an order to generating its AWB |
| Lead | Shipments on hold | Shipments put on hold ÷ shipments created |
| Check | Orders received with no shipment | Orders received from the order system for a cut-over location that were not refused and have no shipment ÷ all such orders |
| Check | Shipments past their time limit | Shipments with no new scan for longer than the time limit for where they are ÷ shipments in progress |
| Check | AWBs not generated for a missing seller detail | AWB generations stopped for a missing seller detail ÷ all AWB generations |
| Check | AWBs printed with a blank PATH bar | AWBs printed with no PATH code ÷ all AWBs printed |
| Check | AWB numbers on more than one shipment | Count of AWB numbers issued to more than one shipment |

## 5. Rollout & Stage Gates

| Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria |
|---|---|---|---|---|
| 1 | Prove intake and the AWB at the first cutover location, next to Shipsy | The System receives a copy of every order of the location and creates the shipment and the AWB. WH Ops keeps using the Shipsy label and prints nothing from the System. | Time to AWB: target to be set from baseline. | Orders received with no shipment: threshold to be set from baseline. AWB numbers on more than one shipment: any. |
| 2 | Go live at the first location | WH Ops prints the System's AWB. Shipsy stops receiving this location's orders. | Orders with a printed AWB: target to be set from baseline. Scans accepted: target to be set from baseline. | Orders received with no shipment: threshold to be set from baseline. Shipments past their time limit: threshold to be set from baseline. AWBs not generated for a missing seller detail: threshold to be set from baseline. AWBs printed with a blank PATH bar: threshold to be set from baseline. AWB numbers on more than one shipment: any. |
| 3 | Every cutover location | Each location, at its cutover. Shipsy stops receiving its orders from that day. | Same as Stage 2. | Same as Stage 2. |

## 6. Decisions

| # | Decision | Where in this PRD |
|---|---|---|
| 1 | Engineering builds the shipment's states and transitions from the scenarios. This PRD defines none. | Use Cases 1 and 2 |
| 2 | The AWB is a PDF in the format of the Shipsy sample. Engineering builds the format and the print. | Use Case 3 |
| 3 | The AWB number stays a 7-digit number. | Use Case 3 |
| 4 | The label says "Truemeds" where the samples say "SHIPSY" and "SHIPSY_REVERSE", in the courier line and in the Handover line. The forward second barcode holds the Order ID without the sample's "-Stage". The return pickup's second barcode keeps the sample's "-R". | Use Case 3 |
| 5 | After the AWB is generated, a change of phone, payment mode or an address on the same path is accepted and the label is reprinted before the box leaves. Items, weight and the serving warehouse cannot change after the AWB is generated. After the box leaves, changes update the System and the driver's app only. | B6, B7, B9, B10, G7, G8 |
| 6 | A path that cannot be resolved does not block the shipment. The AWB prints with the PATH bar blank. | B2 |
| 7 | A return pickup has its own AWB number and label, in the format of the Shipsy reverse sample. | J1, Use Case 3.2 |
| 8 | A cancellation after the shipment left the warehouse is an RTO with the reason "cancelled". | I1 to I3, G9 |
| 9 | Every failed delivery counts as an attempt, whatever the reason and whoever caused it. | Terms, F6 to F12 |
| 10 | A COD parcel is handed over only after the driver records how the Customer paid. Delivered does not wait for the bank or the QR. | F1 to F3 |
| 11 | The ground wins. A delivery made offline stands over a cancellation made before the sync. | F14, F15 |
| 12 | A shipment on hold or lost that turns up carries on from where it was. A shipment too damaged to deliver goes back as an RTO. | K2, K3 |
| 13 | A shipment finishes in the system that created it. | Terms, L1, L2 |
| 14 | The Customer's phone number prints masked, as in the sample. The driver calls through the app. | Use Case 3 |
| 15 | A prepaid order prints "PREPAID" on the payment bar. | Use Case 3 |
| 16 | An order that arrives without a detail the AWB needs is refused at intake. A missing seller detail stops the AWB. | A4, B3 |
| 17 | Pick and pack are outside this PRD. The System starts at the shipment. | Use Case 1 |
| 18 | The System has no concept of a consignment in this release, and records no mid-mile vendor, vehicle or driver. Every handover between two people is one scan of one shipment. | Terms, Use Cases 1.1, 1.3, D1 to D9, H1 to H3, J11 |
| 19 | A handover scan of a cancelled shipment is rejected, so a cancelled shipment never goes forward to a Mid-Mile Driver or a Last Mile Driver. | D3, E7, I1 |
