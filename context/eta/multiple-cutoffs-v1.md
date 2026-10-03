---
title: Multiple Cutoffs v1
source: https://docs.google.com/document/d/1ANVaG9M4TEHKSjTPUH--2xwaNoRjwaAttuKmODRuqZo/edit
type: past-prd
verticals: [courier-forward]
systems: [eta]
updated: 2026-03-07
---

# PRD

## DARCI

| DARCI | SPOC | Signoff Date |
| :-: | :-: | :-: |
| Decider | Rahul Gupta<br>Kartik Mittal | 26 Dec 2025 |
| Accountable | Tejas Bhalerao<br>Kartik Mittal<br>Rajesh Vishwakarma | 31 Dec 2025 |
| Responsible | Tejas Bhalerao<br>Kartik Mittal<br>Mohammed Fahad<br>Pavithran Sethuraman | 31 Dec 2025 |
| Consulted | Anbu Dhileepan | 26 Dec 2025 |
| Informed | Rajendran KRR | - |

## Objective

Enable business stakeholders to set multiple cut-off configurations from the same warehouse.

## Rationale

Our current system limits us to choose only a single cut-off time per courier partner. For example, if Bluedart has to pick up inventory from a designated warehouse, they have to do it before 2pm (Bluedart’s designated cut-off time for that warehouse).

Even if Bluedart is capable of making a second run to the warehouse to pick up additional inventory, our current system blocks them from doing so.

How this impacts us:

- **Higher Delivery ETA on orders not meeting pickup cut-off:** For orders placed with warehouse processing time + doctor / pharmacist callback time beyond 2pm (as per above example), the orders would automatically be classified as NDD for hyperlocal and add an additional day to ETA for courier orders.
- **ETA SLA Breaches due to Missed Pick-ups:** If a courier misses a pickup for a particular order during the pickup cutoff period, pickup can only happen only on the next day. This increases the delivery TAT by 1 day which could be avoided if the courier partner supports multiple pickups from the same warehouse during the day.
- **Higher Delivery Cost:** Currently, this functionality of multiple pickups from the same warehouse is provided by Delhivery which has lower logistics cost at an aggregate level compared to other courier partners.

Given the above, we are proposing that we break this constraint of single cut-off time per courier partner per warehouse to enable better planning for warehouse management and logistics teams to meet SLA adherence.

## Technical Requirements

- Stakeholders should be able to define cut-off times at the following cascading levels:
    - **Warehouse:** From where inventory is expected to be dispatched
    - **Drop Pincode:** To where the inventory is expected to reach
    - **Courier Partner:** Respective courier partner who will be picking up the inventory
- There should be no constraint present in the system that a particular warehouse x drop x courier partner needs to have only one configuration. For example, Bluedart can have 2pm, 3pm, 4pm as cutoffs for Mumbai to Pune lane.
- Each of the above configurations should be updated independent of engineering bandwidth via a script / rake/ API call that can be directly utilised by QA Support teams under request. Business stakeholders should not have to reach out to engineering teams for update requests in the configurations.
- The above process should also take into account the fact that business stakeholders would want to do multiple configuration updates in one go.
- The above capability should also be able to alter existing configurations present in the system. Supported operations - add and delete.
    - Business teams are expected to be aware of the existing configurations present in the system and pass on the correct instructions pertaining to addition or deletion of configurations.
    - **Note:** Delete operation should only remove the configuration from consideration from ETA calculation and not remove the record of configuration being added. Primarily useful for historical metric tracking purposes.
- The cut-off times in the table should adhere to the following constraints as highlighted in the expected workflow section.

## Expected Workflow

- System checks all configurations available for that warehouse.
- If drop pincode specific configuration exists and the drop pincode matches with the customer’s drop pincode, then that specific configuration is also taken into consideration.
- Based on all the eligible configurations present, the system calculates the ETA for the customer, and any other internal portals.
- From here on, the system uses the existing logic for soft and hard allocation.
- For each order, the system stores the cut-off time used for that order.

For example, let’s consider an order ready for hard allocation at 2:00 pm for which inventory is to be dispatched from the Mumbai warehouse to a customer in Pune pincode.

| **Warehouse** | **Courier Partner** | **Drop Pincode** | **Cut-off Time** |
| :-: | :-: | :-: | :-: |
| Mumbai | BlueDart | NULL (Global config) | 4:00 PM |
| Mumbai | XpressBees | NULL (Global config) | 5:00 PM |
| Mumbai | Delhivery | NULL (Global config) | 4:00 PM |
| Mumbai | Delhivery | 400607 | 3:00 PM |
| Mumbai | Delhivery | 400607 | 1:00 PM |

In this case, the system considers Delhivery as an eligible courier partner since for Pune pincode, Delhivery supports 3:00 PM as a cut-off time.

For example, let’s consider an order ready for hard allocation at 2:00 PM for which inventory is to be dispatched from the Mumbai warehouse to a customer in Mumbai pincode (Airoli / Mira - Bhayandar).

| **Warehouse** | **Courier Partner** | **Drop Pincode** | **Cut-off Time** |
| :-: | :-: | :-: | :-: |
| Mumbai | BlueDart | NULL | 4:00 PM |
| Mumbai | XpressBee | NULL | 5:00 PM |
| Mumbai | Delhivery | NULL | 3:00 PM |
| Mumbai | Shipsy | Mira-Bhayandar (400615) | 1:00 PM |
| Mumbai | Shipsy | Mira-Bhayandar (400615) | 4:00 PM |
| Mumbai | Shipsy | Airoli (400607) | 12:00 PM |
| Mumbai | Shipsy | Airoli (400607) | 1:01 PM |
| Mumbai | Shiprocket | Airoli (400607) | 12:30 PM |

In this case, the system considers Shipsy as an eligible courier partner since Shipsy supports 4:00 PM as a cut-off time.

If in case, both global and drop pincode cut-offs are eligible for consideration for ETA calculation during soft or hard allocation, then the system takes both into account along with other courier partners and does allocation based on the existing logic.

Similar concepts as above should also be extended to soft allocation to ensure that all the cut-off time configurations are accounted for in ETA calculations.

## Risks and Mitigation

| **Risk** | **Mitigation** |
| :-: | :-: |
| A courier partner has only lane specific configurations present from a particular warehouse.<br>**Consequence:** Courier partner does not get considered for allocation (soft/hard) if order lane is not in specified configuration. | System will not maintain any validation on its side currently to ensure that such situations do not occur. Business stakeholders should ensure that while setting cut-off times such situations do not arise. |

## Acceptance Criteria

**Configuration Management**

1. **Multi-level Cut-off Support**
    - System supports cut-off configurations at:
        - Warehouse level
        - Warehouse × Courier Partner level
        - Warehouse × Courier Partner × Drop City level
    - Drop city–specific configuration can coexist with a global (NULL drop city) configuration for the same courier.
2. **Independent Configuration Updates**
    - Authorized QA/Support users can **add and delete** cut-off configurations via script / rake / API without engineering intervention.
    - Configuration changes take effect **without service downtime**.
3. **Configuration Integrity**
    - System correctly persists multiple cut-off records per courier per warehouse.
    - Deleting a configuration removes it from **all subsequent ETA calculations and allocations**.

### ETA Calculation & Allocation Logic

1. **Eligibility Determination**
    - During soft and hard allocation, the system:
        - Fetches all cut-off configurations applicable to the warehouse.
        - Applies drop city–specific cut-off if present and eligible.
        - Applies global (NULL drop city) cut-off if present and eligible.
    - Courier partner is considered eligible if **any applicable cut-off time is valid** for the order readiness timestamp.
2. **Precedence Handling**
    - If both global and drop city cut-offs exist:
        - Both are evaluated independently for eligibility.
        - Courier partner is included in allocation if **at least one cut-off qualifies**.
    - If multiple cut-offs exist for a specific lane, the system chooses the cut-off which will help prioritise the lowest ETA for the customer. For example, if 2PM and 6PM configurations exist, and the order will be packed and ready by 1PM, ETA shown to the customer will be based on the 2PM cutoff.
3. **Backward Compatibility**
    - Existing single cut-off configurations continue to behave exactly as before when no additional configurations are present.
4. **Soft & Hard Allocation Consistency**
    - Same cut-off logic is applied consistently across:
        - ETA shown to customer
        - Internal ETA surfaces
        - Soft allocation
        - Hard allocation

### Failure & Edge Case Handling

1. **Missing Lane Configuration**
    - If a courier has only lane-specific configurations and none match the order lane:
        - Courier is excluded from allocation.
        - System does not error or fallback automatically.
2. **System Stability**
    - No increase in allocation failures, ETA calculation errors, or order drops post-deployment.

## Metrics

| **Metric Type** | **Metric** |
| :-: | :-: |
| Success (L1) | Delivery TAT |
| Success (L2) | Promise ETA |
| Guardrail | ETA Promise vs Actual Variance |
| Guardrail | Missed Pickup % |
| Guardrail | Number of orders going in early cutoff |
| Guardrail | Delivery Partner Level Order Distribution |
| Leading | % of warehouses with more than 1 cut-off time per courier partner |
| Leading | % of courier partners with more than 1 cut-off |
| Leading | % of ETA calculations where multiple courier partner cut-offs are being considered |
| Leading | % of ETA calculations where lane specific cut-off is considered |
| Leading | Median number of courier partners eligible per order |

## Appendix

### Analytics Brief

**Problem Validation: Warehouse Readiness**

- How much time do orders spend inside the warehouse today?
    - From Warehouse processing start -> Box verified -> AWB Printed
    - From AWB Printed -> Dispatch
- The above needs to be quantified as a % of orders as well as time spent.
- Does the above distribution change when we consider different types of orders among inventory / JIT?
- Does the above distribution shift materially for orders which hit the warehouse the same time as JIT inventory is received in the warehouse?

**Problem Validation: Warehouse / Courier Problem Pinpoint**

- Is any courier partner (or) warehouse (or) courier x warehouse materially affected more than others or more than overall? Stack-rank the impact by volumes flowing through courier and warehouse.

**Projected Impact on Promise**

- If we were to input X PM as a new cut-off for courier x warehouse combination, what would be the projected reduction in customer’s promise?
- What are the best fit combinations of cutoffs for courier x warehouse that will move the needle most for customer’s promise?
- Best fit cutoff configuration should account not just for promise reduction but also to understand how many orders will be sent with the courier. Account for daily moving averages and weekly moving averages.

# Rollout Plan

## Rollout Plan

| **Stage** | **Description** | **Hold / Scale / Kill Criteria** |
| :-: | :-: | :-: |
| Sanity | Verify whether multi-cutoffs operate as expected when it comes to customer promise around dispatch & delivery. | System correctly calculates the promised dispatch datetime. |
| Pilot | Verify whether multi-cutoffs impact speed of delivery to the customer. | - Speed of delivery improves<br>- Minimal to none impact on warehouse operation processes.<br>- Maintained enough order volumes flowing in each cutoff.<br>- Minimal to none impact on customer promise.<br>- Order allocation distribution change does not impact customer promise and adherence metrics. |
| Staged Rollout | Continuous experimentation with the right set of cutoffs to balance speed and order volumes across each combination of warehouse x pincode. | - Speed of delivery improves<br>- Minimal to none impact on warehouse operation processes.<br>- Maintained enough order volumes flowing in each cutoff.<br>- Minimal to none impact on customer promise.<br>- Order allocation distribution change does not impact customer promise and adherence metrics. |

Guiding principles of cutoff rollout:

- Minimum 200 orders available on average per pickup.
- Cutoff designed in a way that optimises for the courier's first mile connectivity and speed.

## Rollout Sequence

**Rollout 0:**

- Warehouse: Calcutta
- Courier: Bluedart
- New Cutoff: 2pm

**Rollout 1:**

- Date: 7th March
- Courier: Xpressbees
- New Cutoff: 12pm
    - Warehouses: Bangalore, Lucknow
- New Cutoff: 2pm
    - Warehouses: Calcutta, Patna

At this stage, configurations will be for all pincodes.
