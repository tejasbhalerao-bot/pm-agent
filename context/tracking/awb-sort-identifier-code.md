---
title: AWB Sort Identifier Code
source: https://docs.google.com/document/d/1VBvx4bxb0WFBV2lZCnbsPKKaUWNk1fKlrNmb4J0Y0fI/edit
type: past-prd
verticals: [hyperlocal-forward, hyperlocal-reverse]
systems: [tracking]
updated: 2026-09-29
---

# [PRD] AWB Sort Identifier Code

## Objective

Print a Sort Code on every Shipsy AWB — human-readable for at-a-glance manual sorting — derived directly from the canonical DC/Hub/Zone mapping, so that Ops at every Warehouse, DC, and Hub in the network can identify a box's next physical destination without a per-box system lookup.

## Why Now?

Mid-Mile Entity Introduction establishes Zone, DC, and Hub as governed entities and resolves each order's full path at creation. But that resolution today lives only in the system — nothing about it reaches the physical box. Ops at a DC dock still decides, by memory or a paper list, which zone/DC a box belongs to.

That gap is tolerable at 20 DCs with shallow, well-known routes. It stops being tolerable as the network nearly doubles to 35 DCs by October 2026 and 70 DCs by January 2027: more DCs means more distinct outbound routes for a sorter to hold in memory. Solving this before the expanded network goes live avoids compounding manual sortation errors into a much larger cost once volume ramps.

Moreover, this problem compounds when we also consider that your warehouse executives keep on changing. As a result, if someone with tribal knowledge of which zone is mapped to which DC and which DC is mapped to which warehouse leaves the organization. The new hire will have to relearn everything from scratch and is prone to making the same mistakes all over again. Even if this person does not make the same mistakes, the efficiency and the speed at which that person will operate are going to be much slower than what we normally desire.

## Use Cases

### Happy Case

- Format specification (if DC is not in order’s path):

`<OrderType>_<Warehouse>_<Delivery_Zone>`

- Format specification (if DC is in order’s path):

`<OrderType>_<Warehouse>_<DC>_<Delivery_Zone>`

| **Segment** | **Value** |
| :-: | :-: |
| OrderType | FWD (forward) or RVP (reverse pickup) |
| Warehouse | Warehouse alias |
| DC | DC alias |
| Delivery_Zone | Zone alias |

- Delimiter: underscore _ only. No spaces, no other special characters.
- OrderType must be exactly FWD or RVP.
- Warehouse, LM_Hub, and Delivery_Zone use the alias exactly as configured in their respective source system — this PRD does not reformat, truncate, or re-case an alias.
- If order is not going through a DC, then the DC alias is left blank.

**Process Flow:**

- **Step 1:** Just before AWB Generation, resolve the allocated courier. If the courier is Shipsy, proceed forward with Sort Identifier Code generation. Else, stop.
- **Step 2:** Resolve the order type - Forward / Reverse.
- **Step 3:** Resolve the order’s path: WH -> DC -> Delivery Zone or WH -> Delivery Zone.
- **Step 4:** Fetch the alias for each of WH, DC, and Delivery Zone.
- **Step 5:** Generate the sort identifier code as per the above format specification.
- **Step 6:** After the sort identifier code is generated in the above step, call Clickpost to generate the AWB.
- **Step 7:** In this call, pass the Sort Identifier Code as per the above format specifications.
- **Step 8:** Generate AWB with the Code present and all existing elements of the AWB.

### Edge Cases

- **Pincode-to-Zone mapping is missing:** System cannot resolve a Pincode to Zone. Outcome: code construction blocked, AWB generation not blocked. AWB generated without code.
- **Warehouse has no alias configured:** Outcome: Code construction is not blocked. Proceeds forward without a warehouse alias. AWB generation not blocked. AWB generated without code.
- **Zone-to-Hub mapping is missing:** System cannot resolve a Zone to Hub (DC / WH). Outcome: code construction blocked, AWB generation not blocked. AWB generated without code.
- **DC has no alias configured:** Outcome: Code construction blocked. AWB generated without Sort Identifier Code. AWB generation not blocked. AWB generated without code.
- **Zone has no Zone Alias configured:** Outcome: Code construction blocked. AWB generated without Sort Identifier Code. AWB generation not blocked. AWB generated without code.
- **WH-to-DC Mapping is missing:** System cannot resolve a DC to a WH. Outcome: Code Construction blocked, AWB generation not blocked. AWB generated without code.
- **Aliases or Mappings are changed after a Sort Code is derived:** The printed label is not reprinted or recalled. The Sort Code on an in-flight box always reflects the alias in effect at the moment the code was constructed. New orders constructed after the alias change use the new alias immediately.
- **Multiple paths resolved for an order:** If a system fetches multiple paths for an order, then do not block AWB generation. Keep Sort Identifier Code as blank and allow the order to proceed forward in the order journey.

## Metrics

| **Metric Type** | **Metric** |
| :-: | :-: |
| Success (L0) | Packed Order Sorting Speed |
| Success (L1) | Packed Order Sorting Error % |
| Success (L2) | Shipsy Order Share % |
| Guardrails | Code Print Failure % |
| Guardrails | Code Creation Failure % -> Attributed to System Failures |
| Guardrails | Code Creation Failure % -> Attributed to Missing WH Alias |
| Guardrails | Code Creation Failure % -> Attributed to Missing DC Alias |
| Guardrails | Code Creation Failure % -> Attributed to Missing Delivery Zone Alias |
| Guardrails | Code Creation Failure % -> Attributed to Missing Pincode <> Zone Mapping |
| Guardrails | Code Creation Failure % -> Attributed to Missing Zone <> Hub Mapping |
| Guardrails | Code Creation Failure % -> Attributed to Missing WH <> DC Mapping |

## Rollout & Stage Gates

| **Stage** | **Entry Criteria** | **Scale Criteria** |
| :-: | :-: | :-: |
| Stage 1 — Pilot | Delivery Zones serviced by 1 WH. Delivery Zones serviced by 1 DC. | 1. The system is able to generate the Sort Code correctly for all cases. 2. Sort Code is readable and consumable by on-ground ops. |
| Stage 2 — Existing Network (current ~20 DCs) | Full Scale Up to the existing Shipsy network. | - |
