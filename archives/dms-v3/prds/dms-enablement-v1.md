# [PRD] DMS Enablement

**Status:** Under Review
**Author:** Tejas Bhalerao
**Version:** v1
**Scope of this draft:** Objective, Why Now and Milestones. Execution Priority and Metrics are not yet filled.

---

## Objective

Give Ops systematic visibility and control over the hyperlocal delivery leg, from the warehouse through DCs and hubs to the customer's door, so that the network can scale from 20 to 70 DCs without depending on tribal knowledge, manual coordination, or proxy signals.

## Why Now?

### Hyperlocal is the growth push, and the network behind it is about to multiply

The organisation is pushing hyperlocal hard. It will expand serviceable pincodes through the hub-and-spoke model, where deliveries run through DCs. Hyperlocal's share of deliveries is expected to rise from 30% to 40% while order volumes also grow. We run 20 DCs today, and we expect 35 by October 2026 and 70 by January 2027. Shipsy order share is expected to move from 25% to 35% between September 2026 and March 2027.

The push rests on two premises:

- **Conversion:** hyperlocal converts about 4pp higher than non-hyperlocal.
- **Control:** delivery executives are contracted and work under dispatchers, so we can manage the promise and the delivery experience far more tightly than in the non-hyperlocal model.

### The control premise does not hold today

Control needs visibility into the delivery leg, and we do not have it. Today:

- Dispatchers sort orders manually from their knowledge of pincode proximity, which leads to inefficient batching.
- Delivery executives call customers to get exact addresses.
- Delivery executives plan their own routes and sequences from knowledge of the ground.
- Payouts, attendance, shifts, and incentives are tracked manually.
- Nothing is monitored once an order leaves the warehouse. Operations run blind.
- There are no handover validation layers, so we judge delivery experience from proxy signals.
- On-ground operations also perform multiple other actions which keep us systematically blind: re-triggering attempts, initiating RTOs, and handling cash reconciliation over Excel sheets.

The network itself is also run from memory. Which DC feeds which warehouse, which zone a hub serves, and where a box goes next live in people's heads and in spreadsheets. When the executives who hold that knowledge leave, their replacements relearn it from scratch, repeat the same mistakes, and work slower.

### Why this cannot wait

Each of these gaps is tolerable at 20 DCs with short, well-known routes. Each gets more expensive as DCs, routes, and volume multiply, and together they erase the control advantage that justifies the hyperlocal push. The manual-error cost of the expanded network is locked in the day it goes live, and fixing it after volume has ramped costs more than building before.

The foundations are being laid already. Mid-Mile Entity Introduction makes Zones and DCs governed entities with resolvable paths, and the AWB Sort Identifier Code puts that resolution on the physical box. DMS is the layer that has to run delivery operations on top of them, and it needs to be ready before the expanded network goes live.

## Milestones

Each sub-milestone is an executable chunk. A milestone with no sub-milestone is executed as one chunk.

| Sr. No. | Milestone | Sub-Milestone | Dependent on Integration? | Integration Dependency | Execution Priority |
|---|---|---|---|---|---|
| 1 | Geography Setup | - | Yes | Fully | |
| 2 | Vehicle Setup | - | Yes | Partial | |
| 3 | Earnings Setup | - | Yes | Partial | |
| 4 | Driver Onboarding | Personal Details | Yes | Partial | |
| 4 | Driver Onboarding | Vehicle Details | Yes | Partial | |
| 4 | Driver Onboarding | Engagement Details | Yes | Partial | |
| 4 | Driver Onboarding | Serviceability (Hub, Route, Pincode) | Yes | Partial | |
| 4 | Driver Onboarding | Earnings Setup | Yes | Partial | |
| 5 | Driver Management | Suspension | Yes | Partial | |
| 5 | Driver Management | Incentives | No | Independent | |
| 5 | Driver Management | Availability | Yes | Fully | |
| 6 | Order Management | Order Creation | Yes | Fully | |
| 6 | Order Management | Mid-Mile Orchestration | Yes | Fully | |
| 6 | Order Management | Order Rescheduling | Yes | Fully | |
| 6 | Order Management | RTO Initiation | Yes | Fully | |
| 6 | Order Management | RTO Orchestration | Yes | Fully | |
| 6 | Order Management | Return Order Creation | Yes | Fully | |
| 6 | Order Management | Return Order Orchestration | Yes | Fully | |
| 7 | Execution Planning | Route Optimisation Setup | Yes | Fully | |
| 7 | Execution Planning | Planning Engine Setup | Yes | Fully | |
| 7 | Execution Planning | Order Batching | Yes | Fully | |
| 7 | Execution Planning | Driver Allocation | Yes | Fully | |
| 8 | Order Execution | Order Assignment | Yes | Fully | |
| 8 | Order Execution | Navigation | Yes | Fully | |
| 8 | Order Execution | Driver Tracking | Yes | Fully | |
| 8 | Order Execution | Handover Mechanics | Yes | Fully | |
| 8 | Order Execution | Dynamic QR | Yes | Fully | |
| 8 | Order Execution | Reverse Journey QC | Yes | Fully | |
| 8 | Order Execution | Customer Rating | Yes | Fully | |
| 8 | Order Execution | OTP Based Cancellations | Yes | Fully | |
| 8 | Order Execution | Order Rescheduling | Yes | Fully | |
| 9 | Driver App | Incentives Visibility | Yes | Fully | |
| 9 | Driver App | Earnings Visibility | Yes | Fully | |
| 9 | Driver App | Suspension / Termination | Yes | Fully | |

## Metrics

Not yet written.
