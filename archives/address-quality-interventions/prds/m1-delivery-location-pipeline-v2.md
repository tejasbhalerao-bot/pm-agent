---
**Document:** Address Quality Interventions — M1: Delivery Location Pipeline
**Type:** Executable PRD
**Version:** v2
**Date:** 2026-10-14
**Status:** Under Review
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-10-14 | Initial draft |
| v2 | 2026-10-14 | Ops SOPs: left blank pending workshop; removed the keep-existing-record rule from the record definition; removed the "nobody acts per row" step from Use Case 1.1; removed the Courier Forward note from the header; removed the ARD pointer from Use Case 3. Open points replaced with two: how Truemeds receives the lat long from Shipsy, and whether Shipsy mandates GPS when marking Delivered. Metrics: definitions trimmed to numerator ÷ denominator only. |
---

# [PRD] Address Quality Interventions — Milestone 1: Capturing Delivery Locations of Shipsy Orders

**Systems:** Address, Tracking · **Verticals:** Hyperlocal Forward (Shipsy) only.

## 1. Objective

Every Shipsy order delivered in the past 2 years, and every one delivered from go-live, has its delivery location stored against the address it was delivered to.

## 2. Why Now

Shipsy route planning and delivery executives depend on customer addresses the system cannot read. Almost every address on Truemeds, new or existing, is typed free text. The system cannot place it on a map, and nothing checks that a person can follow it.

The cost shows up in two places (anecdotal, from the Address Quality Interventions milestone doc):

- **Route planning.** About 40% of Shipsy orders are affected. The planned location and the actual delivery location differ by 500 m to 12 km.
- **Customer and driver coordination.** Delivery executives coordinate with the customer up to three times: before leaving the hub, near the area, and at the location. How often each happens depends on customer availability and address quality.

The network is growing on top of these addresses:

| Measure | Today | Target |
|---|---|---|
| DCs | 20 | 70 (Mar '27) |
| Shipsy order share | 26% | 40% (Mar '27) |
| MFCs (tentative) | 14 | 89 (Mar '28) |

Fixing existing addresses means inferring each customer's real location (Milestone 2). The best source is where past deliveries to that address actually happened. Truemeds does not store these locations today, so Milestone 2 cannot start. Until it does, route planning for a growing network runs on addresses the system cannot read.

## 3. Use Cases

**Pre-condition: Delivery Executive SOP.** Delivery executives mark an order Delivered only at the customer's exact location. Logistics Ops enforces and tracks this SOP.

A **delivery location record** holds three values: Address ID, Order ID and Delivery lat long. The system keeps one record per Order ID.

### Use Case 1: Capture delivery locations of past Shipsy orders

One-time load. Applies to Hyperlocal Forward (Shipsy) delivered orders only.

1. The Shipsy team shares a report of every Shipsy order delivered in the past 2 years, with Order ID and delivery lat long. The 2-year window is fixed.
2. The system looks up each Order ID and resolves the Address ID the order was delivered to.
3. The system stores a delivery location record for the order.
4. The system repeats steps 2–3 for every row in the report.

**Result:** every matched row in the report has a delivery location record.

#### Use Case 1.1: Edge Case — Row cannot be stored

A row is skipped when its Order ID does not match a Shipsy forward order in Delivered state, its Address ID cannot be resolved, or its lat long is missing or not a valid coordinate.

1. The system skips the row and stores no record.
2. The system records the reason for the skip, so it counts toward Delivery Location Capture Failure % or Delivery Location Store Failure %.

### Use Case 2: Capture the delivery location when a Shipsy order is delivered

Ongoing, for every Shipsy forward order. Applies to Hyperlocal Forward (Shipsy) only.

1. The delivery executive marks the order Delivered on the Shipsy driver app, at the customer's location.
2. Shipsy records the Delivered status with the lat long where it was marked.
3. Shipsy sends the Delivered status and lat long to Truemeds.
4. The system updates the order to Delivered, as today.
5. The system resolves the Address ID the order was delivered to and stores a delivery location record.

**Result:** the order is Delivered and has one delivery location record.

#### Use Case 2.1: Edge Case — Delivered status arrives without a usable lat long

1. The system updates the order to Delivered as usual.
2. The system stores no record and records the reason, counted in Delivery Location Capture Failure %.

#### Use Case 2.2: Edge Case — The location cannot be stored

The Address ID cannot be resolved, or the store fails.

1. The order's Delivered update must complete regardless. Storing the location must never block or delay it.
2. The system records the reason, counted in Delivery Location Store Failure %.

#### Use Case 2.3: Edge Case — Delivery executive marks Delivered away from the customer's location

1. The system cannot detect this in Milestone 1. It stores the location as received.
2. Logistics Ops tracks adherence under the Delivery Executive SOP (Section 7).

### Use Case 3: Make delivery locations available for analytics

1. The system makes every delivery location record available to Analytics with Address ID, Order ID and Delivery lat long.
2. For every Shipsy delivered order with no record, the system makes the reason available: lat long missing or invalid, order not matched, Address ID not resolved, or store failed.

### Open points

| Question | Who decides |
|---|---|
| How will Truemeds interact with Shipsy to receive the lat long? | Engineering and Shipsy |
| Does Shipsy mandate GPS location to be on while marking the order delivered? | PM, Engineering and Shipsy |

## 4. Metrics

| Metric Type | Metric | Definition |
|---|---|---|
| Success | % of historical orders with delivery location captured | Shipsy forward orders delivered in the past 2 years with a delivery location record ÷ all Shipsy forward orders delivered in the past 2 years. |
| Success | % of future orders with delivery location captured | Shipsy forward orders delivered since go-live with a delivery location record ÷ all Shipsy forward orders delivered since go-live. |
| Lead | Historical report coverage | Shipsy forward orders delivered in the past 2 years that appear in Shipsy's report ÷ all Shipsy forward orders delivered in the past 2 years. |
| Lead | Lat long presence on Delivered status | Shipsy Delivered statuses received with a valid lat long ÷ all Shipsy Delivered statuses received. |
| Check | Delivery Location Capture Failure % | Shipsy delivered orders received with lat long missing or invalid ÷ all Shipsy delivered orders received. |
| Check | Delivery Location Store Failure % | Shipsy delivered orders with a valid lat long but no delivery location record ÷ all Shipsy delivered orders with a valid lat long. |
| Check | Delivered Status Update Failure % | Shipsy orders marked Delivered on Shipsy but not Delivered in Truemeds ÷ all Shipsy orders marked Delivered on Shipsy. |
| Check | Delivery Executive SOP Adherence % | Shipsy delivered orders not flagged by any SOP verification signal ÷ all Shipsy delivered orders with a delivery location record. |

## 5. Rollout & Stage Gates

No staged percentage rollout. Each stage covers all Shipsy forward orders at once.

| Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria |
|---|---|---|---|---|
| 1. Historical load | Store locations for past Shipsy orders | One-time load of Shipsy's 2-year report (Use Case 1). | % of historical orders with delivery location captured meets target. Target to be set once report coverage is known. | Delivery Location Store Failure % or Delivery Location Capture Failure % above threshold → stop the load, fix, reload. Thresholds not yet set. |
| 2. Live capture | Store a location for every new Shipsy delivery | Use Case 2 live for all Shipsy forward orders from day 1. | % of future orders with delivery location captured meets target. Target to be set from the first week's baseline. | Delivered Status Update Failure % above pre-launch baseline → switch off live capture. Delivery Location Capture Failure % or Store Failure % above threshold → fix before Milestone 2 reads the data. Delivery Executive SOP Adherence % below threshold → Milestone 2 does not read the data until it recovers. Thresholds not yet set. |

## 6. Worked Examples

All values are illustrative.

**Example 1 — Historical row stored (Use Case 1)**
- *Scenario:* a past order is in Shipsy's report.
- *Starting state:* Order 41230055, delivered 2025-03-12 by Shipsy to Address ID 880214. No record exists.
- *Steps:* the report row reads 41230055, 19.1176, 72.9060. The system resolves Address ID 880214 and stores the record.
- *Result:* record {880214, 41230055, 19.1176, 72.9060}.

**Example 2 — Live delivery stored (Use Case 2)**
- *Scenario:* a delivery executive delivers an order today.
- *Starting state:* Order 45518702, Out for Delivery, Address ID 902117.
- *Steps:* the executive marks Delivered at 19.0728, 72.8826. Shipsy sends Delivered with that lat long. The system sets the order to Delivered and stores the record.
- *Result:* order Delivered; record {902117, 45518702, 19.0728, 72.8826}.

**Example 3 — Delivered without lat long (Use Case 2.1)**
- *Scenario:* Shipsy sends Delivered with an empty lat long.
- *Starting state:* Order 45518940, Out for Delivery, Address ID 774031.
- *Steps:* the system sets the order to Delivered. It stores no record and records "lat long missing".
- *Result:* order Delivered; no record; the order counts in Delivery Location Capture Failure %.

## 7. Ops SOPs
