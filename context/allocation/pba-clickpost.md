---
title: PBA (Clickpost)
source: https://docs.google.com/document/d/1pV4RYHdP2a6yfpOBdDBJPL7RZMBwf9xZYRpGEzI-Jvc/edit
type: past-prd
verticals: [courier-forward]
systems: [allocation]
updated: 2025-12-08
---

# PRD

# PBA integration with clickpost

## Context

Clickpost is the 3rd party partner who handles our courier partner orders across all vendors. In addition to being a single point of solution, clickpost also has advanced capabilities including customizable prioritization of delivery partners, shipment tracking, ETA projection etc. Clickpost is capable of providing a more advanced ETA for orders.

### Overview of PBA powered ETA

When requesting ETA for an order, we provide the order level details including the pin codes of pickup and drop locations. Using these, clickpost performs the following actions:

- Shortlist serviceable courier partners from the list of onboarded courier partners
- Prioritize the list of courier partner into recommendation; This recommendation can happen on the basis one of the following logics:
    - [Static] A set of rules and order lists are provided in clickpost as configuration; These configurations are translated into a list of prioritised courier partners
        - These configurations are relatively static in nature
    - [Dynamic] Prioritization of serviceable courier partners to consider the most recent information of ETA commitments (and adherence) along with relative pricing
        - These rules provide priority to courier partners based on their recent performance for similar shipments

### Impact / expectations

Implementation of performance based courier partner selection provides us with two major advantages over the current partner selection logic:

- Higher adherence to ETA promise made to customers
- Cost optimization

With these intangible benefits in mind, we have aligned to incorporate PBA insights in the ETA logic and optimize our courier partner allocation.

## Brief summary of user stories

| Sr No | Description |
| :-: | :-: |
| [US1](#user-story-1-integration-of-pba-logic-in-eta-check) | Integration of PBA logic in ETA |
| [US2](#user-story-2-analytics-requirements) | Analytics on ETA and adherence |
| [US3](#user-story-3-gtm) | GTM |

### User story 1: Integration of PBA logic in ETA check

**Story:** Integration of PBA logic in ETA

**Description:**

PBA capability of clickpost should be consumable with the new configurations requested with the clickpost team.

Performance evaluation criteria (clickpost):

- Delivery ETA from actual shipments should be used for performance based evaluation
- ETAs considered should be in number of days
- Data for shipments delivered in last 30 days rolling window should be considered for evaluation
    - We should be able to change the window of performance evaluation in future
- Delivery ETA should be evaluated by considering both pickup pincode and delivery pincode
    - 80th percentile of the delivery TAT should be considered as ETA for the courier partners
    - For details, please refer [here](#eta-promise-logic).
- Costing can be used as tie breaker if more than 1 courier partners have the same ETA for a set of pin codes

PBA powered ETA should be evaluated on the following touch points:

- Summary page of pre-order - To show an expected delivery date to customers
- Warehouse allocation of order - To finalize courier partner and picker assignment sequencing
- Order creation with courier partner - Final ETA expectations for the order

Note: For the rest of the touch points, the latest available ETA can be used to get an updated delivery time.

E.g:

- ETA on internal portals (Doctor’s portal / Pharmacist portal) can be the same number of days as registered requested for the summary page
- Delivery updates for consumer tracking
    - Before pickup: A delivery date calculated using the latest available ETA from clickpost can be used. As and when updated ETA details.
    - After pickup: No change. Same status updates on track screen as shown to user

Fallback logic for failures:

- ETA data to be cached for using it as a fallback mechanism in case of clickpost failure
- For more details, please refer [here](#eta-promise-logic).

### User story 2: Analytics requirements

**Story:** Analytics requirements for PBA integration

**Description:**

Analysis:

- Feasibility of pin code clustering for fallback projected ETA

Reporting / Success tracking:

- % Order with ETA changes
- PBA accuracy
- Delivery TAT adherence
    - RTO%
- Delivery partner assignment %

Detailed Metrics - [here](#metrics).

Analytics Requirements: [ARD:- PBA Integration Setup](https://docs.google.com/document/d/16b_ATSAihXd6DMoL2FNXiXJOcrU5VLM4jHLJ85jDg2Q/edit?usp=sharing)

### User story 3: GTM

**Story:** GTM rollout of PBA integration

**Description:**

PBA integration should be rolled out in 3 phases:

- [Production Sanity] 1% orders across all warehouses should use PBA powered ETA.
- [Pilot] 5% orders across all warehouses should use PBA powered ETA for testing stability and accuracy of the ETAs in the new setup
- [Scale up] After stability signoff, PBA can be scaled up for 100% orders

## ETA Promise Logic

### Soft Allocation - Used for ETA visibility at Cart, Summary

**Priority: Use API Level Cache**

- System creates unique lanes. Lanes are defined for a unique combination of warehouse_id, drop_pincode, courier_partner, before_after_cutoff. Additional information to be included - delivery_mode (air/surface).
- Each lane will be designated a unique lane_key.
- For every lane_key, Clickpost should be hit once in a day.
- For lane_key with before_after_cutoff = before, Clickpost should be hit before pickup cutoff time of the courier.
- For lane_key with before_after_cutoff = after, Clickpost should be hit after pickup cutoff time of the courier.
- API Cache should be ready and available for usage for every lane before go-live.
- Based on the current time of the customer’s session, we take a decision to choose either before cutoff TAT or after cutoff TAT.
- System should refer to only (current date - 1)’s context for fetching ETA to be shown to the customer. This window of time should be kept configurable at a lane level through a script/rake update system to be executed by QA Support on request basis.
- ETA shown to the customer is the best ETA available among all couriers.

**Fallback 1: API call to Clickpost**

- In case API Cache is not available for the selected lane, system should directly hit Clickpost API to fetch the latest available courier partners and their respective TAT.
- System chooses the highest priority courier which has the lowest TAT to display ETA to the consumer.
- If Clickpost API call fails, then fallback to the existing logic.

**Fallback 2: Use Existing Logic**

- In case, Clickpost API call fails, then revert back to the existing logic to display ETA to the consumer.

### Hard Allocation - Used for ETA visibility at Live Order, Doctor & Pharmacist Portal

**Priority: API call to Clickpost**

- System makes an API call to Clickpost to fetch the latest available courier partners based on eligibility for order fulfilment and ETA visibility.
- Clickpost returns a sorted list of couriers along with their TAT.
- System chooses the top-most courier from the list and displays the ETA based on this courier partner’s TAT.

**Fallback 1: Use API level Cache**

- If Clickpost API call fails, system keeps on retrying until a courier partner is allocated.
- Until a time that a courier partner is allocated, system refers to the API cache to determine the ETA to be shown to the customer.
- API Cache ETA selection works in a similar fashion to as described above.
- Once the courier is allocated, the ETA updates to reflect the realistic TAT.

**Fallback 2: Existing Logic**

- If API Cache layer fails, then the system falls back to the existing logic, to display ETA.

## Metrics

| **Metric Type** | **Metric** | **Definition** |
| :-: | :-: | :-: |
| Success (L1) | SLA Adherence % | Whether an order was delivered early / on-time / late |
| Success (L2) | PBA Accuracy & Efficacy | Whether PBA consistently makes better decisions and in how many cases - **measured through Shadow Mode** |
| Guardrails | % Orders with ETA Changes | Where ETA changed pre and post order creation |
| Guardrails | RTO % | Cases where RTO was initiated |
| Guardrails | Delivery Partner Assignment % | How many cases where delivery partner was successfully assigned |
| Guardrails | Delivery Promise TAT | Delivery TAT being considered in promise |
| Guardrails | % instances where PBA returned 0 couriers | Cases where we are not able to find even a single courier partner |
| Guardrails | % instances where API call to Clickpost was made | Cases where API Cache failed |
| Guardrails | % instances where existing logic was used | Cases where API call to Clickpost failed |

[Metric Measurement Framework](https://docs.google.com/document/d/1Cwom3vdvUB5R7G3BQLalO2lca8wvwHEKpvExwMuXG2I/edit?usp=sharing)

### Shadow Mode Implementation - PBA Accuracy & Efficacy

- For every order that is created, system runs both the PBA logic as well as the existing logic.
- For assignment, system chooses PBA only.
- Courier Partner selected through existing logic is only logged.
- Data Capture Requirements:
    - Order_id
    - Lane_key
    - PBA Courier Partner
    - Existing Logic Courier Partner

# Post Release @ 5%

# Post Release Analysis

## Presentation Methodology

To start with, we first explore a few individual themes - PBA funnel, Customer Promise, and Delivery Partner selection. Post this, we move to adherence metrics, where we will incorporate the earlier themes if analysis shows undesirable results.

## PBA Funnel Overview

- Since 5% scale up, a total of 1816 placed orders have flowed through PBA strategy.
- Of the 100% orders placed on the platform, 59.24% have a different delivery partner than what our internal logic suggested.

| **Metric** | **Absolute Value** | **Relative Value** |
| :-: | :-: | :-: |
| Total Orders | 37906 | 100% |
| Internal Logic Allocated Orders | 36090 | 95.21% |
| PBA Allocated Orders | 1816 | 4.79% |
| Orders where PBA Partner = Internal Logic Partner | 15452 | 41.76% |
| Orders where PBA Partner != Internal Logic Partner | 22454 | 59.24% |

## Customer Promise - PBA vs Internal

- In 28.95% of cases (PBA + Internal Logic), PBA ends up giving a faster promise to the customer than our internal logic. Notably the majority of this fast promise, translates only to 1 day of promise acceleration as present in 22.21% cases.
- PBA promise deviates from the internal logic promise by 1 day (either high or low), in 43.21% cases.

| **Internal Logic Orders** | **PBA Orders** |  |  |
| :-: | :-: | :-: | :-: |
| Total Quantum | 95.21% | Total Quantum | 4.79% |
| TAT Equal | 45.66% | TAT Equal | 2.29% |
| PBA Faster | 27.58% | PBA Faster | 1.38% |
| PBA Faster by 1 day | 21.19% | PBA Faster by 1 day | 1.02% |
| PBA - Internal Logic Promise Delta = 1 day | 41.17% | PBA to Internal Logic Promise Delta = 1 day | 2.04% |

Detailed Data - [here](https://docs.google.com/spreadsheets/d/1f_jeJtBggJ51MHRstbsrz6UhKJtbLlvu4VC7-f-NgL0/edit?usp=sharing).

## Delivery Partner Selection - PBA vs Internal

- Through PBA, we end up selecting a different delivery partner majority of the time irrespective of whether we consider inside rollout (58.97%) or outside rollout (59.24%).

| **Rollout** | **Same / Different** | **Absolute** | **Relative** |
| :-: | :-: | :-: | :-: |
| Inside PBA | Different | 1071 | 58.97% |
| Inside PBA | Same | 745 | 41.03% |
| Outside PBA | Different | 21383 | 59.24% |
| Outside PBA | Same | 14707 | 40.76% |

- Following presents a distribution of where internal logic selected delivery partner lies in the preference of PBA. For example, if Internal Logic said choose Bluedart, then which priority did PBA say Bluedart should be at.
- In most of the cases where internal logic selected a different delivery partner from PBA, the rank of partner in PBA preference was in position 2 or position 3.

| **PBA Preference Rank** | **Inside PBA (Test = 4.79%)** | **Outside PBA (Control = 95.3%)** |
| :-: | :-: | :-: |
| 1 | 41.33% | 40.92% |
| 2 | 28.82% | 30.07% |
| 3 | 14.18% | 14.56% |
| > 3 | 15.67% | 14.45% |

- Within PBA routed orders, the courier selection mix also changes drastically. Couriers favoured by internal logic fall out of favour with PBA. This is purely for the hard allocation stage.

| **Courier** | ***hard_internal_partner_id*** | ***hard_PBA_partner_id*** |
| :-: | :-: | :-: |
| 185 | 23.51% | 17.90% |
| 195 | 36.85% | 19.99% |
| 225 | 9.86% | 16.18% |
| 246 | 9.12% | 16.06% |
| 247 | 10.43% | 18.99% |
| 286 | 8.80% | 10.78% |
| 608 | 1.15% | 0.09% |
| 638 | 0.21% | 0% |
| 639 | 0.06% | 0% |

## Promise Adherence - PBA vs Internal

- PBA has consistently given poor logistics promise adherence as compared to our own internal logic. The same is also reflected in the overall promise adherence to the customer based on actual delivery dates.

| **Adherence** | **Internal Logic** | **PBA** | **Delta** |
| :-: | :-: | :-: | :-: |
| Logistics Promise | 88.02% | 85.05% | -2.96% |
| Overall Promise | 77.51% | 71.09% | -6.42% |

- The above is an extremely undesirable state which warrants further exploration. In lieu of the same, the following diagnostic questions were asked:
    - Is adherence delta driven by courier selection differences?
    - Is faster promises committed by PBA leading to higher breach rates?
    - Do differences arise even when PBA and internal logic select the same courier?
    - Whether promise source influences breach outcomes?

Each was validated using slices of PBA order data.

**Definition of PBA_Adjusted_Status:** When the attempt for delivery was made to the customer, what was the status of the order.

**Insight #1: Faster promises by PBA significantly increase breach probability**

| *COUNTUNIQUE of order_id* | *PBA TAT < Internal TAT Flag* |  |  |
| :-: | :-: | :-: | :-: |
| *pba_adjusted_status* | FALSE | TRUE | Grand Total |
| BREACH_DELIVERED_LATE | 10.62% | 15.73% | 12.36% |
| BREACH_NOT_DELIVERED | 2.71% | 4.36% | 3.27% |
| NOT_DELIVERED_NOT_BREACHED_YET | 24.30% | 28.77% | 25.82% |
| ON_TIME | 62.38% | 51.14% | 58.55% |

Orders where **PBA committed a faster delivery promise than internal logic** experienced a **higher breach rate**.

This indicates that **PBA’s faster commitments are often optimistic relative to actual courier execution performance**.

**Insight #2: Breach increases sharply when PBA hard allocation also commits faster promise**

| *COUNTUNIQUE of order_id* | *PBA Hard Allocation TAT < Internal Hard Allocation TAT Flag* |  |  |
| :-: | :-: | :-: | :-: |
| *pba_adjusted_status* | FALSE | TRUE | Grand Total |
| BREACH_DELIVERED_LATE | 8.91% | 18.60% | 12.36% |
| BREACH_NOT_DELIVERED | 2.53% | 4.62% | 3.27% |
| NOT_DELIVERED_NOT_BREACHED_YET | 23.46% | 30.09% | 25.82% |
| ON_TIME | 65.10% | 46.69% | 58.55% |

When **PBA both selects a courier and commits a faster promise than internal logic**, breach rate rises dramatically.

This suggests that **PBA's lane-level courier performance assumptions may be optimistic for certain courier-lane combinations.**

Execution failures are concentrated in cases where **PBA simultaneously changes courier selection and tightens the promise window.**

**Insight #3: Courier partner mix differs materially between PBA and internal allocation**

Blue => Bluedart

Red => Delhivery

Green => Xpressbees

| **Courier** | ***hard_internal_partner_id*** | ***hard_PBA_partner_id*** |
| :-: | :-: | :-: |
| 185 | 23.51% | 17.90% |
| 195 | 36.85% | 19.99% |
| 225 | 9.86% | 16.18% |
| 246 | 9.12% | 16.06% |
| 247 | 10.43% | 18.99% |
| 286 | 8.80% | 10.78% |
| 608 | 1.15% | 0.09% |
| 638 | 0.21% | 0% |
| 639 | 0.06% | 0% |

PBA significantly shifts volume away from courier 195 and redistributes it across 225, 246 and 247.

If the internal system historically prioritizes courier 195 due to stronger performance in certain lanes, this shift alone could contribute to adherence decline.

The adherence delta may be partly explained by **changes in courier partner mix introduced by PBA.**

**Insight #4: Adherence differences persist even when courier partner remains the same**

| *COUNTUNIQUE of order_id* | *PBA Hard Partner != Internal Hard Partner* |  |  |
| :-: | :-: | :-: | :-: |
| *pba_adjusted_status* | FALSE | TRUE | Grand Total |
| BREACH_DELIVERED_LATE | 10.77% | 13.49% | 12.36% |
| BREACH_NOT_DELIVERED | 2.28% | 3.98% | 3.27% |
| NOT_DELIVERED_NOT_BREACHED_YET | 24.88% | 26.50% | 25.82% |
| ON_TIME | 62.08% | 56.03% | 58.55% |

Even when **PBA and internal logic allocate the same courier**, PBA orders show slightly worse adherence.

This suggests that **promise construction differences (rather than courier choice alone) influence breach outcomes.**

The same also holds true when we look at soft allocation in isolation as below.

| *COUNTUNIQUE of order_id* | *PBA Soft Partner != Internal Soft Partner* |  |  |
| :-: | :-: | :-: | :-: |
| *pba_adjusted_status* | FALSE | TRUE | Grand Total |
| BREACH_DELIVERED_LATE | 11.33% | 12.95% | 12.36% |
| BREACH_NOT_DELIVERED | 2.39% | 3.78% | 3.27% |
| NOT_DELIVERED_NOT_BREACHED_YET | 23.00% | 27.44% | 25.82% |
| ON_TIME | 63.28% | 55.84% | 58.55% |

**Insight #5: Allocation Inconsistency across Soft and Hard also contributes to Adherence Breaches**

| *COUNTUNIQUE of order_id* | *PBA Soft != Hard Flag* |  |  |
| :-: | :-: | :-: | :-: |
| *pba_projected_status* | FALSE | TRUE | Grand Total |
| BREACH_DELIVERED_LATE | 21.22% | 22.34% | 21.84% |
| BREACH_NOT_DELIVERED | 4.83% | 5.33% | 5.10% |
| NOT_DELIVERED_NOT_BREACHED_YET | 22.64% | 25.07% | 23.99% |
| ON_TIME | 51.31% | 47.26% | 49.07% |

When courier partners mismatch across soft and hard allocation, adherence breaches spike. This indicates that we are penalising PBA when it has made disconnected decisions across order stages even though that is an internal inefficiency we are dealing with.

## Next Steps

The current analysis identifies a measurable adherence gap between PBA and the internal allocation logic. However, the analysis is primarily attempt-based and focused on PBA orders in isolation. To accurately diagnose the root cause and determine whether the adherence delta arises from promise construction, courier allocation, or operational execution, the following additional analyses will be conducted.

**#1: Benchmark Diagnostic Patterns Against Non-PBA Orders**

The current diagnostic analysis evaluates patterns only within PBA orders. While this helps identify behaviors inside the experiment cohort, it does not reveal whether these patterns are unique to PBA or also present in the baseline allocation system.

To address this, the same diagnostic dimensions will be computed for orders outside the PBA rollout and compared directly against PBA orders.

Rather than analyzing both cohorts independently, the focus will be on measuring incremental deltas between PBA and non-PBA orders across the same parameters.

**#2: Evaluate Promise to Actual Tradeoff**

- Compare actual delivery timelines for orders where PBA commits faster promises than internal logic
- Measure whether actual delivery speed also improved under PBA allocation
- Quantify the gap between promise acceleration and actual delivery acceleration

This analysis will determine whether PBA is successfully pushing the network toward faster deliveries, but experiencing temporary adherence degradation because operational execution has not fully caught up with the tighter promises.

If actual delivery performance also improves under PBA, the adherence gap may reflect a transitional adjustment rather than a structural weakness in the allocation engine.

**#3: Control for Lane Distribution Bias**

The adherence comparison between PBA and internal allocation may be influenced by differences in lane distribution across the two cohorts.

Certain lanes may inherently have lower operational reliability due to factors such as transit complexity, courier coverage, or first-mile variability. If PBA orders are disproportionately concentrated in these lanes, the overall adherence comparison may be distorted.

To address this, adherence will be recomputed only for lanes that are common across both PBA and non-PBA orders.

**#4: Evaluate Delivery Level Adherence**

The current analysis evaluates adherence based on delivery attempts, as defined by the *PBA Adjusted Status* (where adherence is measured relative to the first delivery attempt rather than the final delivery event).

However, customers ultimately experience successful delivery outcomes rather than attempt events. As a result, attempt-level adherence may not fully capture customer experience.

To address this, adherence will also be evaluated using: Final delivery date vs promised delivery date.

Moreover, we will also attribute the delta in logistics adherence and promise adherence between PBA and non-PBA orders to specific legs in the journey.
