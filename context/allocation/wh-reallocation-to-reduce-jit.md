---
title: WH Reallocation to Reduce JIT
source: https://docs.google.com/document/d/12kL_Qt65PNFDAEtjs41DbmHO_s-5RxfDMxci_64L5UA/edit
type: past-prd
verticals: [hyperlocal-forward, courier-forward]
systems: [allocation]
updated: 2026-09-27
---

# 1 Pager

# **WH allocation to reduce JIT**

### Hypothesis:

Today, order allocation only checks the pincode's mapped primary FC & primary MFC. If neither WHs holds inventory of all items in the cart, the order is created as a JIT order in the FC (assuming the non-inventory items are JIT procureable), even when another warehouse in the network might already have the items in inventory.

- JIT is currently at 15% of OP and can be reduced to **~7.5%** if we service orders from warehouses where the entire cart is non-JIT
- July simulation: Out of the 15%, **4pp** of orders could be reallocated to another WH with the same/better promise and ~3.5pp of orders could be reallocated with an 1 day increased buffer on promise
- Impact this fix is expected to create:
    - OP2OD improvement 5pp within the reallocated orders [L0: **0.2pp**],
    - Margins improvement of **20 INR/order** [CoGS reduction: 15 + Deletions reduction: 5]
        - Analytics backed sizing highlight potential TAM of only **UE** **~3-4 Rs**

Analysis Document [link](https://docs.google.com/document/d/1ckICBQjLg6PNxNJz4NZKTKJEASe5gfPhGQ32XeaCxDg/edit?usp=sharing)

### Success/ Check metrics

**[Shared by Analytics on Sep 22]**

- **JIT%:** 3.5pp reduction @ X=1 [12.60% --> 9.02%]
- **OP2OD:** +0.35pp [76.70% --> 77.05%]
- **Inc OPD**: ~100
- **GM inc:** ₹2.85 UE [24L/month]
- **Latency increase:** To be measured post go live

Estimation analysis doc attached [here](https://docs.google.com/document/d/1RbrFhtwsDUFix3SjD1kVcLzhAAVeVMqtEsKMHn29uGY/edit?usp=sharing)

### Proposed Changes

High level summary of expected touch points which require changes

- **Current system:** Build on top of WH Allocation Experiment Test 2 (planned to scale up by Sep 11). All changes in WH allocation logic in Order Summary page. No change in cart (to be confirmed by tech).
- **New system:** Changes in WH allocation logic on the new merged cart.
- **WH Allocation logic:**
    - Add a new additional WH search step, triggered only when primary FC/MFC cannot fulfill the items in inventory.
    - Search all shortlisted WHs for full cart availability on inventory
    - Shortlist all WH with same ETA + buffer X
    - Based on the reallocation criteria, assign the final WH
    - JIT reallocated WH - Tie break criteria:
        - If more than 1 WH has the items in inventory and passes the ETA criteria, allocate the WH based on following priority
            - Best ETA
            - Lowest crow fly distance between the pincodes
- **Additional WH check guardrails:** For WH allocation at summary, compute ETA and compare it to the fetched other WHs which can cater to the cart with Promise TAT of *current promise + X* *days*. Assign only if it clears the gate; otherwise falls back to existing JIT flow in FC.
- **WH reallocation buffer config:** *X* (buffer threshold) days to be checked against to shortlist the additional WH shortlist. Product will own the buffer config. ETA for change 0.5 days
- **Inventory check:** Additional Inventory checks to be enabled for WHs other than the primary WHs before the final WH selection
- **Invoicing/GST:** Invoice must be generated against the actual WH from which items are shipped. GST nuances should change as required
- **Pricing:** Confirmed price stays fixed once past cart/summary; WH reallocation happens after that point. Cart will have price shock
- **Subs:** Recommend subs from the final allocated WH, No check for portal subs before OP
- **Refresh:** Re-run WH allocation logic for all user actions defined in cart revamp - add, remove product, change quantity, change address/pincode
- **New logging/instrumentation:** [ARD - WH Reallocation - Field Reference](https://docs.google.com/spreadsheets/d/1NNBWxogwOdK7xZr8mzIAk00jjbrw6JmUUauEMQUslvg/edit?usp=sharing)

**Assumptions:**

- WH allocation is done only based on items in the cart. Subs blocking allocation scenario is not handled. If experiments for 0 blocking is not scaled, we will do this reallocation exercise only for the variant with 0 blocking
- Subs that will be pitched at cart/summary/HA portals will only be selected from the selected WH
- System driven reallocation of WH is possible only before cart/summary. Reallocation at OP or post OP is not covered in this scope.
- Pre-cart - no change

**Risks:**

- Subs may change if allocated WH changes based on the user action (adds/removes/changes quantity/changes address)
- Prices may change on cart in more no. of instances compared to current world
- If we go ahead with current promise + X days - risk of ETA increasing with product add/qty increase
- Subs edge case: Cart is assigned to WH 3, user sees WH3 subs and selects, adds new OG not present in WH3, cart falls back to primary FC. If WH3 subs is not present in FC - show OOS

### User Stories

| **#** | **Charter** | **Description** |
| :-: | :-: | :-: |
| US1 | WH allocation | As a customer, I am able to order products from inventory present in WHs which are not my FC or MFC |
| US2 | Cart experience | As a customer, I am allocated a WH on cart which is not my primary FC or MFC and I am able to perform all cart actions as is in old & new cart |
| US3 | Logistics | Logistics systems to furnish the details to WH allocation logic to enable it to evaluate the best WH from the larger possible list |
| US4 | Inventory | IMS is enabled to provide the right source of truth if inventory to WH allocation logic for reallocation |
| US5 | Substitution | As a customer, I am able to substitute at all the existing touch points even post the WH reallocation fix |
| US6 | GTM | Experiment details & dependencies on other features in GTM |

#### **US1**

**As a customer, I am able to order products from inventory present in WHs which are not my FC or MFC (only in selected cases)**

**Description**

Currently the pre cart journey (search, catalog) exploration happens on FC inventory. With this fix, we will continue to show the FC inventory to customers till summary.

At summary, WH allocation logic allocates orders with at least one JIT item to the designated FC for the pincode [15% of OP]

The proposal is to change this final WH allocation logic differently for JIT and non - JIT orders

If the order is non-JIT, continue WH allocation as is (current implementation).

If the order is JIT,

1. Search all shortlisted WHs for full cart availability on inventory
2. Shortlist all WH with same ETA + buffer X
3. **Additional WH check guardrails:** For WH allocation at summary, compute ETA and compare it to the fetched other WHs which can cater to the cart with Promise TAT of *current promise + X* *days*. Assign only if it clears the gate; otherwise falls back to existing JIT flow in FC.
4. **WH reallocation buffer config:** *X* (buffer threshold) days to be checked against to shortlist the additional WH shortlist. Product will own the buffer config. ETA for change 0.5 days
5. Based on the reallocation criteria below, assign the final WH
6. JIT reallocated WH - Tie break criteria:
    1. If more than 1 WH has the items in inventory and passes the ETA criteria, allocate the WH based on following priority
        - Best ETA
        - Lowest crow fly distance between the pincodes [Long term would change it to lowest Logistics cost]

Price jumps at summary are expected.

**Related Docs**

ARD

#### **US2**

**As a customer, I am allocated a WH on summary which is not my primary FC or MFC and I am able to perform all cart actions as is in old & new cart**

**Description**

NO CHANGES EXPECTED

All actions on the cart should not change post this fix is live. Changes happen only at the time of WH allocation step.

WH allocation to be refreshed on summary for the same set of usecases [listing below, might not be exhaustive]

- Item addition [incl widgets]
- Quantity addition
- Substitution
- Address change/addition
- Patient change/addition
- Prescription upload
- Coupon addition

**Related Docs**

#### **US3**

**Logistics systems to furnish the details to WH allocation logic to enable it to evaluate the best WH from the larger possible list**

**Description**

**For every WH allocation request**:

1. Pincode is received from the app / website / Portal.
2. For this pincode, Logistics checks the serviceability configurations.
3. In serviceability configurations, ops maintains a list of WH in ascending priority. (**Pre-requisite:** Before going live, all existing non-priority 1 configurations have to be cleaned by ops and upload correct priority configurations).
4. For the pincode’s serviceability configurations, the system fetches all WHs (across MFCs and FCs).
5. The system applies a filtering logic on this list to select the WH candidates to be sent to the Allocation module.
6. Filtering logic is powered by the following configurations: cap (number of WHs that must be passed to allocation module), mfc_to_fc_ratio (of the WH candidates, how many should be MFCs and FCs).
7. For each WH x pincode, the system calculates the ETA using the existing logic. (**Pre-requisite:** Before going live, operations provide the delivery TAT for each WH x pincode combination).
8. Logistics passes the following information to WH allocation module: ETA & WH.

**Illustration:**

**Additional conditions:**

1. Allocation module should decide WH at each stage - Home page, PDP, Cart, Summary, OP, Dr Order Confirmed.
2. When MFC is non-inventory, ETA should not get calculated and is passed as NULL.
3. Filtering logic will apply a hard check of always passing the priority 1 FC in the WH candidate list.
4. WH Priority list updated by ops will be governed for all CRUD operations. Each CRUD operation will be accepted only if the final priority list that will be created will have at least 1 FC. Else, the CRUD operation will be rejected.

**Related Docs**

Instrumentation: ARD

#### **US4**

**Live Inventory/IA is enabled to provide the right source of truth if inventory to WH allocation logic for reallocation**

**Description**

Inventory availability at WH logic should check for the inventory based on the latest source of truth [IA or Live inventory]

Dependent on IMS scaleup. To be planned in cut over if this feature goes live before IMS scaleup

**Related Docs**

#### **US5**

**As a customer, I am able to substitute at all the existing touch points even post the WH reallocation fix**

**Description**

NO CHANGES EXPECTED

Substitution flows at Cart, Summary and HA are expected to be impacted with this fix. In HA flow, since the candidate subs are always shown from a pre-selected WH, we will end up showing substitutes from the non primary WH even in cases where the end cart (post substitution) becomes serviceable from primary FC/MFC. In the current release, we do not handle this use case. For cart & summary, any substitution reruns the WH allocations and this scenario is handled automatically.

**Related Docs**

#### **US6**

**GTM**

**Description**

The proposal is to run this behind an experiment

- Random 50%-50% split based on userid
- Exposure to be controlled
    - 0-2 days: 1%
    - 1-2 weeks: 10%
    - Full scaleup

Other projects in GTM:

Pre Cart Revamp - Allocation logic to be created. Impact only on Summary

Post Cart Revamp - Allocation to impact cart experience.

This project is expected to go live before Cart and hence the ask is to build a reconfigurable one time fix.

**Related Docs**

**Open Points:**

1. What happens if HA adds items post OP ? Do we run WH allocation there ? Yes
2. What happens if the address gets changed at Doctor/HA ? Same answer as above. WH allocation check needs to be run each time address change happens.
3. Do we need to handle anything extra on MinMax ?

There can be a second order impact on overstocking and stockouts. Simulation will help predict the impact in a better way. Overall this introduces a difference in replenishment logic (direct demand to available FC/mFC) and WH allocation which uses different serviceability leading us into an unknown domain for a couple of replenishment cycles

1. What is the impact on CAB ?
2. What happens if the order is allocated to an MFC and it turns out that the cart is not in inventory by the time Picker is assigned ? In MVP, this case will not be handled differently. There is chance an order can go from FC to a 3rd WH (an MFC) and gets moved to another different FC as JIT (corresponding FC to the 3rd WH)
3. How to reduce the candidate list for the eligible FC check ? Detailed in Logistics US
4. What should be the WH allocation outcome if the customer moves from Summary to Cart ? Temporary problem.
5. What is the efficient way to provide a pincode level preferred WH list ? Tejas Bhalerao to share
6. Price change - add instrumentation and track in experiment
