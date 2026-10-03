---
title: Courier Allocation Revamp
source: https://docs.google.com/document/d/1HxILz8W8_UxLKXkaaoACFW8WPpAHTxESysn6Rjaq-Bc/edit
type: past-prd
verticals: [courier-forward]
systems: [allocation, eta]
updated: 2026-07-10
---

# PRD

# [PRD] Courier Allocation Revamp

---

## RACI

| **RACI** | **SPOC** |
| :-: | :-: |
| Accountable | Tejas Bhalerao<br>Kartik Mittal |
| Responsible | Tejas Bhalerao<br>Mohammed Fahad<br>Ashish Ranjan |
| Consulted | Anbu Dhileepan |
| Informed | Ajit Murkar |

---

## Objective

Replace unreliable lane-level adherence scores on thin-traffic lanes with geographically pooled adherence — so that the courier allocation formula runs on statistically meaningful inputs for every order.

---

## Why Now?

The courier allocation formula scores couriers as TAT / adherence. A courier's adherence score for a lane is computed from deliveries it made on that specific WH × courier × pincode combination in the past 7 days.

**The core problem:** The threshold to qualify as a "data lane" is just 1 delivery. A single on-time delivery gives a courier 100% adherence — the best possible score. But 100% based on one delivery is statistically meaningless. At 20+ deliveries, a single delay shifts adherence by less than 5pp — a margin small enough that it won't change which courier wins allocation. Below 20, one bad delivery is decisive.

**What this looks like today** (based on April 1, 2026 — representative of a normal operating day):

- Of 25,716 active data-lanes, **94.7% have fewer than 20 deliveries** in the 7-day window. The median lane has just 2 deliveries.
- Every lane with 1–2 deliveries shows **100% adherence** — not because those couriers are perfect, but because 2 deliveries isn't enough to catch a single failure.
- **56.6% of all orders** were promised to a courier whose lane had fewer than 20 recent deliveries. On those same orders, 93.8% of competing couriers were also on thin lanes.

The entire scoring system is running on thin data. The right fix is to pool adherence upward geographically when a lane lacks enough observations. The right minimum threshold — 10, 15, or 20 deliveries — will be determined empirically through a shadow-mode experiment before any live change is made.

---

## Use Cases

### Use Case 1: Changes to Base Adherence Calculation Logic

- Currently the system calculates the following:

| **Parameter** | **Definition** |
| :-: | :-: |
| Base Adherence Percentage | % of orders delivered on-time or early |
| SLA Breach1day | % of orders delivered 1 day late |
| SLA Breach2day | % of orders delivered 2 days late |
| SLA Breach3day | % of orders delivered 3 days late |
| SLA Breach4plusday | % of orders delivered >=4 days late |

- Instead of the above, the system starts maintaining the following:

**Note:** The below is only for logistics TAT.

| **Parameter** | **Definition** |
| :-: | :-: |
| Orders OnTime | % of orders delivered on-time |
| SLA Breach1day | % of orders delivered 1 day late |
| SLA Breach2day | % of orders delivered 2 days late |
| SLA Breach3day | % of orders delivered 3 days late |
| SLA Breach4plusday | % of orders delivered >=4 days late |
| Early 1day | % of orders delivered 1 day early |
| Early 2day | % of orders delivered 2 days early |
| Early 3day | % of orders delivered 3 days early |
| Early 4plusday | % of orders delivered >=4 days early |

- System starts running the summation of % of orders in the following priority order:
    - Early 4plusday
    - Early 3day
    - Early 2day
    - Early 1day
    - Orders OnTime
    - SLA Breach1day
    - SLA Breach2day
    - SLA Breach3day
    - SLA Breach4plusday
- System runs 2 computations at this stage:
    - **Computation 1 - Adjusting till >=80%:** Starting from Early 4plusday, keep adding values till >=80% adherence is reached in the following order of summation => Early 3day, Early 2day, Early 1day, Orders On-time, SLA Breach1day, SLA Breach2day, SLA Breach3day, SLA Breach4plusday. This value is stored as adherence_adjusted_80_perc_plus.
    - **Computation 2 - Taking base adherence:** base_adherence_percentage is calculated as the same as computation 1 till >=80%. However, here the system stops summation at Orders On-Time irrespective of whether 80% adherence was reached or not. The following are never considered for adherence calculation => SLA Breach1day, SLA Breach2day, SLA Breach3day, SLA Breach4plusday.
- Calculation of key fields:

| **Field** | **Definition** | **Reference Table** |
| :-: | :-: | :-: |
| Ideal TAT | Picked from the value configured by the business team. | TAT Adherence Data, TAT Adherence Data MFC |
| Final TAT | Calculated as Ideal TAT (from on-time orders) + SLA Breach delays counted (or) Calculated as Ideal TAT (from on-time orders) - Early days counted. | TAT Adherence Data, TAT Adherence Data MFC |
| Promise TAT | Stores the same value as Ideal TAT | Order TAT Details |
| Delay Days | Calculated as Final TAT - Ideal TAT | Order TAT Details |
| Drop Buffer | Stores the value of the drop buffer added to the order. | Order TAT Details |
| Pickup Buffer | Stores the value of the pickup buffer added to the order. | Order TAT Details |

- Due to the above change, Final TAT can now go lower than the Ideal TAT.
- **Worked Example 1 (Computation 1 - adherence_adjusted_80_perc):**
    - Adherence Percentage = 85%
    - % of orders at which 85% was reached = Early 4plusday + Early 3day + Early 2day + Early 1day
    - Final TAT = Ideal TAT - 1
    - Promise TAT = Ideal TAT
    - Delay Days = -1
    - TAT / Adherence = Final TAT / 85%
- **Worked Example 2 (Computation 1 - adherence_adjusted_80_perc):**
    - Adherence Percentage = 85%
    - % of orders at which 85% was reached = Early 4plusday + Early 3day + Early 2day + Early 1day + Order On-time + SLA Breach1day + SLA Breach2day
    - Final TAT = Ideal TAT + 2
    - Promise TAT = Ideal TAT
    - Delay Days = 2
- TAT / Adherence = Final TAT / 85%
- **Worked Example (Computation 2 - base_adherence_percentage):**
    - Adherence Percentage = 78%
    - % of orders at which 78% was reached = Early 4plusday + Early 3day + Early 2day + Early 1day + Orders On-Time
    - Final TAT = Ideal TAT
    - Delay Days = 0
    - TAT / Adherence = Final TAT / 78%
- **Worked Example (Computation 2 - base_adherence_percentage):**
    - Adherence Percentage = 85%
    - % of orders at which 85% was reached = Early 4plusday + Early 3day + Early 2day + Early 1day
    - Final TAT = Ideal TAT - 1
    - Delay Days = -1
    - TAT / Adherence = Final TAT / 85%
- ETA shown to the customer has the component of Logistics TAT passed as the Final TAT.
- Everything above continues to run at a combination of: pincode x warehouse x courier partner based on the data of the last 7 days.

### Use Case 2: Introducing Adherence Fallbacks

- The above execution does not happen for allocation decisions if the number of orders for that pincode x warehouse x courier partner < n in the last 7 days.
- **Cascade 1 - City:** If at a pincode level the number of orders < n, then the system considers all orders for the city. Essentially computation now happens at a warehouse x city x courier partner. This cascade is only executed if the number of orders for that city x warehouse x courier partner >= n in the last 7 days.
- **Cascade 2 - State:** If at a city level, the number of orders < n, then the system considers all orders for the state. Essentially computation now happens at a warehouse x state x courier partner. This cascade is only executed if the number of orders for that state x warehouse x courier partner >= n in the last 7 days.
- **Cascade 3 - Warehouse:** If at a state level, the number of orders < n, then the system considers all orders flowing from the warehouse. Essentially computation now happens at a warehouse x courier partner level. This cascade is only executed if the number of orders at a warehouse x courier >= n in the last 7 days.
- **Cascade 4 - Courier:** If at a warehouse level, the number of orders < n, then the system considers all orders flowing from the courier. Essentially computation now happens at a courier level. This cascade is only executed if the number of orders for that courier >= n in the last 7 days.
- **Cascade 5 - Default:** If at a courier level, the number of orders < n, then the system considers a default adherence percentage of 80%.
- This cascade is used to calculate the adherence percentage.
- At each cascade level, the system calculates each of the fields listed in Use Case 1.
- Worked Example: (n=10)
    - At a pincode level, n=5. => Not used since 5 < 10.
    - At a city level, n=15. => Computation happens at a city level.
    - At a city level, the system calculates all the following fields: Early 4plusday, Early 3day, Early 2day, Early 1day, Orders OnTime, SLA Breach1day, SLA Breach2day, SLA Breach3day, SLA Breach4plusday.
    - Final adherence percentage at a city level is calculated using the same logic as in Use Case 1.
    - The system considers the Final TAT of that pincode and the adherence percentage of the city cascade to compute TAT / Adherence for this courier.
    - All fields and parameters described in Use Case 1, get calculated at the city level cascade.
- All pincodes must be found in m_city_master and m_state_master. Currently we do not know if this is the case. It needs to be verified, else if possibilities of errors exist we will design fallbacks.
- **Job failure fallback:** if the nightly job does not complete, the system continues using the previous night’s pooled scores. Allocation is never blocked pending a nightly run.
- For orders placed within the job window (3:00 AM for FCs, 3:30 AM for MFCs), the system uses the previous night’s pooled scores.
- **Guardrail:** While implementing the cascade logic, the system must always ensure that the Final TAT >= 0. Instrument how many cases we actually apply this guardrail.

### Use Case 3: Shadow Mode Implementation

- TAT / Adherence changes as above will be calculated as part of a shadow mode implementation instead of a direct production rollout.
- There will be 6 shadow modes running in parallel, i.e., for each order we will be running the allocation engine a total of 8 times (6 for the individual shadow modes, 1 for existing TAT / Adherence algorithm, and 1 for PBA).
- Structure of the shadow mode will be as follows:
    - **Mode 1:** Computation 1 AND n=10
    - **Mode 2:** Computation 1 AND n=15
    - **Mode 3:** Computation 1 AND n=20
    - **Mode 4:** Computation 2 AND n=10
    - **Mode 5:** Computation 2 AND n=15
    - **Mode 6:** Computation 2 AND n=20

### Use Case 4: Handling for Promise Buffers

- Similar to how promise buffers are handled, the same will continue here.
- Before adherence percentage is ever calculated, all orders with drop buffer applied (as per the final courier selected), must undergo the following operation:
    - Adjusted Actual TAT = Actual TAT - Drop Buffer
- Additionally, same as in Promise Buffers, the courier selection logic should depend on the following:
    - (TAT / Adherence) + 1 (if after schedule time) + Pickup Buffer + Drop Buffer

### Use Case 5: Allocation Instrumentation

- For every run of the allocation engine, the system should store the following information.
- The following information should also be captured in PBA allocation run as well as existing system run.

| **Field** | **Description** |
| :-: | :-: |
| order_id | Order identifier. |
| warehouse_id | Warehouse identifier from which this order is being allocated. |
| pincode | Customer delivery pincode. |
| city | City resolved from m_city_master for pincode. |
| state | State resolved from m_state_master for pincode. |
| Order_stage | Order Placed, Order Confirmed, Picking, Invoice Generated. |
| computation_variant | Variant for which computation is run (Computation 1 / Computation 2). |
| N_threshold | Number of orders for which cascade is triggered (10/15/20). |
| recommendation_metadata | Array of partners received from recommendation API. |
| cascade_level_reached | Cascade level applied to order: pincode, city, state, warehouse, courier, default |
| orders_per_cascade | {pincode: x, city: y, state: z, warehouse: a, courier: b, default: c} |
| Adherence_metadata | {<br>Courier_partner: x {<br>Early 4plusday: a, Early 3day: b, Early 2day: c, Early 1day: d, Orders On-Time: e, SLA Breach1day: f, SLA Breach2day: g, SLA Breach3day: h, SLA Breach 4plusday: i}} |
| final_adherence_considered | {courier_partner_A: a, courier_partner_B: b, ….} |
| Ideal_TAT | {courier_partner_A: a, courier_partner_B: b, ….} |
| Final_TAT | {courier_partner_A: a, courier_partner_B: b, ….} |
| Delay_days | {courier_partner_A: a, courier_partner_B: b, ….} |
| Supposed_TAT_flag | {courier_partner_A: a, courier_partner_B: b, ….} |
| TAT_Adherence_score | {courier_partner_A: a, courier_partner_B: b, ….} |
| schedule_time_flag | {courier_partner_A: a, courier_partner_B: b, ….} |
| drop_buffer | {courier_partner_A: a, courier_partner_B: b, ….} |
| pickup_buffer | {courier_partner_A: a, courier_partner_B: b, ….} |
| TAT_adherence_score_with_buffer | {courier_partner_A: a, courier_partner_B: b, ….} |
| rank_in_allocation | {courier_partner_A: a, courier_partner_B: b, ….} |
| selected_courier_partner | courier_partner_id |

### Use Case 6: Handling with PBA rollout

- If PBA is fully scaled up, the entirety of this capability should continue to run in shadow mode for all orders.
- For instance, when PBA is at 5%, 95% of orders will flow through existing methodology. 100% of orders will run through 6 parallel shadow modes.
- When PBA is at 100%, 100% of orders will flow through shadow mode in existing methodology. Moreover, 100% of orders will run through 6 parallel shadow modes.
- Computation variant and N_threshold should be built in a manner that tomorrow, it is very easy to add another computation variant or N_threshold.

---

## Metrics

| **Metric Type** | **Metric** |
| :-: | :-: |
| Success | Adherence % |
| Guardrail | Logistics TAT |
| Guardrail | Courier Allocation Mix |

---

## Rollout & Stage Gates

| **Stage** | **Objective** | **Scope** | **Validation** | **Exit Criteria** |
| :-: | :-: | :-: | :-: | :-: |
| **Stage 1A — Shadow Experiment** | Run all three threshold variants in parallel without touching live allocation. Measure impact and build confidence before any courier switch happens in production. | All data-lane orders on April 1+ days. Nightly job computes pooled adherence for N=10, N=15, and N=20 simultaneously. Three instrumentation rows written per courier per order (threshold_variant = 10, 15, 20). No live allocation changed. | Pooled scores for lanes ≥ 20 deliveries match raw scores exactly (zero regression). ≥ 95% of data-lane orders have scores available before the job's 45-minute deadline on ≥ 12 of 14 nights. Instrumentation write success ≥ 99.9%. % Active Couriers with Recent National Data baselined. | All four validation criteria met. 14 days completed. |
| **Stage 1B — Threshold Selection** | Pick one threshold from {10, 15, 20} based on shadow evidence. | Analysis of 14-day shadow data. Three variants compared on: % Orders Switching Courier, Avg Adherence Score Correction, and % Switched Orders with Worse Promise. | Decision rule: lowest % Switched Orders with Worse Promise wins. If two variants are within 1pp, prefer the lower threshold. Outcome documented in a threshold decision note. | Selected threshold's % Switched Orders with Worse Promise in shadow data < 5%. |
| **Stage 2 — Live Rollout** | Gradually roll out pooled adherence to live allocation, expanding only when each step is stable. Baseline for all guardrail checks = Stage 1A 14-day averages. | **5% of orders** → monitor for 2 days → **25% of orders** → monitor for 3 days → **50% of orders** → monitor for 3 days → **100% of orders** → monitor for 7 days. At each step, check: % Switched Orders with Worse Promise, % Orders Switching Courier vs. shadow baseline (±5pp), % Nights Pooling Job Completes On Time (≥ 99%). Rollout pauses and rolls back if any guardrail breaches. | Rollback trigger: % Switched Orders with Worse Promise exceeds 5% on any 3-day rolling window, OR net promise turns negative by > 0.1h vs. Stage 1A baseline. | All four steps completed without rollback trigger firing. % Switched Orders with Worse Promise has not exceeded 3% on any single day. % Orders Switching Courier is within ±5pp of Stage 1A shadow result. |
| **Stage 3 — Full Production** | Pooled adherence is the permanent input for all allocation decisions. | All orders. Shadow-mode multi-variant instrumentation rows retired (threshold_variant always NULL going forward). | Nightly job SLA alert active (FC and MFC separately). % Active Couriers with Recent National Data alert active (flag if < 80%). % Courier Evaluations Falling to 80% Default alert active (flag if > 5%). | No exit criteria — ongoing steady state. |
