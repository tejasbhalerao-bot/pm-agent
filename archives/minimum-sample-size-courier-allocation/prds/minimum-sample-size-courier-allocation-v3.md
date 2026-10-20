---
**Document:** Minimum Sample Size in Courier Allocation
**Type:** Executable PRD
**Version:** v3
**Date:** 2026-10-20
**Status:** Under Review
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-10-20 | Initial draft |
| v2 | 2026-10-20 | Use Case 1 rewritten as a step-by-step if / else flow with a counting rule and a window table |
| v3 | 2026-10-20 | All use cases rewritten in the PM's explicit Step N / Step N.A / N.B style, with Happy Case first |
---

# [PRD] Minimum Sample Size in Courier Allocation

## 1. Objective

Raise Adherence % on Courier Forward orders by allocating couriers only on lane data large enough to trust.

## 2. Why Now

Customers and Logistics Ops are affected. Every Courier Forward order is promised and shipped with the courier that scores lowest on lane TAT ÷ lane adherence. These values come from past deliveries on each warehouse × pincode × courier lane.

How it works today:

1. A nightly job (3:00 AM for FCs, 3:30 AM for MFCs) computes lane TAT and lane adherence from deliveries in the last 7 days.
2. A lane with at least 1 order in those 7 days uses its own values. A lane with none uses the ops-configured TAT and `tat_adherence_master`.
3. At every allocation stage, the system scores each serviceable courier and allocates the lowest score. The winner's TAT becomes the promise.

One order is enough to set a lane's values. One on-time delivery gives a lane 100% lane adherence.

Measured impact (courier allocation analysis, Jul–Sep 2026; 58 decision dates from 29 Jul to 24 Sep; couriers 185, 195, 225, 246, 247, 286):

- On an average day, 98.6% of 1,742,038 lanes had no order in the last 7 days. 99.95% had fewer than 20.
- Of the 23,784 lanes with any order, 96.4% had fewer than 20 orders and 72.7% had 1 to 4.
- Of 4,816,812 courier evaluations at order placed, 70.6% used the ops config. 22.6% used a lane with 1 to 19 orders. 6.8% used a lane with 20 or more.
- 81.0% of 940,480 orders were delivered within the real promise. How much of the other 19.0% comes from thin lane data is not measured.

The analysis completed on 20 Oct 2026. Waiting costs about 16,200 orders a day allocated and promised on these scores (941,213 orders over 58 days).

## 3. Use Cases

All use cases apply to Courier Forward only. Hyperlocal Forward is unchanged.

| Term | Definition |
|---|---|
| Live Lane | A warehouse × delivery pincode that Product has turned on in Use Case 4. Every courier that serves it follows the rules in this PRD. |
| Pool | The set of past orders that a courier's lane TAT and lane adherence are calculated from. |
| Window | The last N days (7, 14, 21 or 28) before the nightly job runs. The window ends on the day before the run date. A longer window contains the shorter ones. |
| Micro-cluster | All pincodes with the same state, district and division in the GOI directory. Each pincode takes one value per field, chosen by the majority of its post offices. |
| Macro-cluster | All pincodes that share the first three digits. |
| Minimum Sample Size (x) | 20 orders. Fixed value. |

Windows for a nightly run on 22 Sep:

| Window | Dates counted |
|---|---|
| 7 days | 15 Sep to 21 Sep |
| 14 days | 8 Sep to 21 Sep |
| 21 days | 1 Sep to 21 Sep |
| 28 days | 25 Aug to 21 Sep |

### Use Case 1: Pool Selection

- Use Case runs once per night, for every courier that serves a live lane.
- Warehouse and courier stay the same on every step. Only the geography and the window widen.
- An order is counted in a pool only when all of these are true:
  - The order's warehouse is the lane's warehouse.
  - The order's courier is this courier.
  - The order's delivery pincode is inside the geography being checked.
  - The date of the order's first delivery attempt is inside the window.

#### Use Case 1.1: Happy Case

- **Step 1:** System starts the nightly job at 3:00 AM for FCs and 3:30 AM for MFCs.
- **Step 2:** System fetches every live lane of the warehouses in that run, and the couriers that serve each lane's pincode.
- **Step 3:** For each courier on each live lane, system runs Steps 4 to 16 until a pool is selected.
- **Step 4:** System counts the orders in the **pincode**, over **7 days**.
  - **Step 4.A:** If the count is 20 or more, system selects this pool and moves to Use Case 2.
  - **Step 4.B:** If the count is less than 20, system moves to Step 5.
- **Step 5:** System counts the orders in the **pincode**, over **14 days**.
  - **Step 5.A:** If the count is 20 or more, system selects this pool and moves to Use Case 2.
  - **Step 5.B:** If the count is less than 20, system moves to Step 6.
- **Step 6:** System counts the orders in the **pincode**, over **21 days**.
  - **Step 6.A:** If the count is 20 or more, system selects this pool and moves to Use Case 2.
  - **Step 6.B:** If the count is less than 20, system moves to Step 7.
- **Step 7:** System counts the orders in the **pincode**, over **28 days**.
  - **Step 7.A:** If the count is 20 or more, system selects this pool and moves to Use Case 2.
  - **Step 7.B:** If the count is less than 20, the pincode alone does not have enough orders. System moves to Step 8.
- **Step 8:** System checks whether the lane's pincode is in the GOI directory.
  - **Step 8.A:** If yes, system moves to Step 9.
  - **Step 8.B:** If not, system follows Use Case 1.2.
- **Step 9:** System counts the orders in the **micro-cluster**, over **7 days**.
  - **Step 9.A:** If the count is 20 or more, system selects this pool and moves to Use Case 2.
  - **Step 9.B:** If the count is less than 20, system moves to Step 10.
- **Step 10:** System counts the orders in the **micro-cluster**, over **14 days**.
  - **Step 10.A:** If the count is 20 or more, system selects this pool and moves to Use Case 2.
  - **Step 10.B:** If the count is less than 20, system moves to Step 11.
- **Step 11:** System counts the orders in the **micro-cluster**, over **21 days**.
  - **Step 11.A:** If the count is 20 or more, system selects this pool and moves to Use Case 2.
  - **Step 11.B:** If the count is less than 20, system moves to Step 12.
- **Step 12:** System counts the orders in the **micro-cluster**, over **28 days**.
  - **Step 12.A:** If the count is 20 or more, system selects this pool and moves to Use Case 2.
  - **Step 12.B:** If the count is less than 20, system moves to Step 13.
- **Step 13:** System counts the orders in the **macro-cluster**, over **7 days**.
  - **Step 13.A:** If the count is 20 or more, system selects this pool and moves to Use Case 2.
  - **Step 13.B:** If the count is less than 20, system moves to Step 14.
- **Step 14:** System counts the orders in the **macro-cluster**, over **14 days**.
  - **Step 14.A:** If the count is 20 or more, system selects this pool and moves to Use Case 2.
  - **Step 14.B:** If the count is less than 20, system moves to Step 15.
- **Step 15:** System counts the orders in the **macro-cluster**, over **21 days**.
  - **Step 15.A:** If the count is 20 or more, system selects this pool and moves to Use Case 2.
  - **Step 15.B:** If the count is less than 20, system moves to Step 16.
- **Step 16:** System counts the orders in the **macro-cluster**, over **28 days**. This is the widest pool.
  - **Step 16.A:** If the count is 20 or more, system selects this pool and moves to Use Case 2.
  - **Step 16.B:** If the count is between 1 and 19, system follows Use Case 1.3.
  - **Step 16.C:** If the count is 0, system follows Use Case 1.4.

#### Use Case 1.2: Edge Case — Pincode is not in the GOI directory

- **Step 1:** System finds at Step 8 that the lane's pincode is not in the GOI directory.
- **Step 2:** System cannot build a micro-cluster for this pincode. System skips Steps 9 to 12.
- **Step 3:** System continues at Step 13. The macro-cluster needs only the first three digits of the pincode.

#### Use Case 1.3: Edge Case — No pool reaches 20 orders, but the widest pool has some

- **Step 1:** System counts 1 to 19 orders in the macro-cluster over 28 days (Step 16.B).
- **Step 2:** System selects the macro-cluster pool over 28 days, even though it has fewer than 20 orders.
- **Step 3:** System moves to Use Case 2.

#### Use Case 1.4: Edge Case — The widest pool has no orders

- **Step 1:** System counts 0 orders in the macro-cluster over 28 days (Step 16.C).
- **Step 2.A:** If the ops config has a TAT for this warehouse × pincode × courier (tables `pincode_delivery_tat` and `pincode_delivery_tat_mfc`), system uses that TAT.
- **Step 2.B:** If not, system uses 3 days (Supposed TAT).
- **Step 3:** System reads lane adherence from `tat_adherence_master`.
- **Step 4:** System moves to Use Case 2.

### Use Case 2: Lane TAT and Lane Adherence Calculation

- Use Case runs after Use Case 1, for every courier on every live lane.

#### Use Case 2.1: Happy Case

- **Step 1:** System receives the selected pool from Use Case 1.
- **Step 2:** System fetches `percentile_value` for the lane.
  - **Step 2.A:** If a configuration exists for warehouse × pincode × courier, system uses it.
  - **Step 2.B:** Else, if one exists for warehouse × pincode, system uses it.
  - **Step 2.C:** Else, if one exists for the warehouse, system uses it.
  - **Step 2.D:** Else, system uses the default `percentile_value`.
- **Step 3:** For each order in the pool, system calculates actual days as `DATE(delivery_attempt_time) - DATE(pickup_time)`.
- **Step 4:** System calculates lane TAT as `ROUNDUP(PERCENTILE(actual days, percentile_value))`.
- **Step 5:** For each order in the pool, system calculates delay days as the order's actual days minus the promise given to that order. Delay days can be negative.
- **Step 6:** System places each order in one of nine buckets by its delay days.

| Delay Days | Bucket |
|---|---|
| -4 or lower | Early 4+ Days |
| -3 | Early 3 Days |
| -2 | Early 2 Days |
| -1 | Early 1 Day |
| 0 | On-Time |
| 1 | Late 1 Day |
| 2 | Late 2 Days |
| 3 | Late 3 Days |
| 4 or higher | Late 4+ Days |

- **Step 7:** System adds up the buckets from Early 4+ Days down to Late 4+ Days. After each bucket, it divides the running total by the number of orders in the pool.
- **Step 8:** System stops at the first bucket where the running share is equal to or greater than `percentile_value`. Lane adherence is the running share at that bucket.
- **Step 9:** System stores lane TAT and lane adherence for the courier on the lane.

#### Use Case 2.2: Edge Case — Pool came from the ops config

- **Step 1:** System receives the ops-config TAT (or 3 days) and the `tat_adherence_master` adherence from Use Case 1.4.
- **Step 2:** System skips Steps 2 to 8 of Use Case 2.1.
- **Step 3:** System stores these two values as lane TAT and lane adherence.

#### Use Case 2.3: Edge Case — Nightly job does not complete

- **Step 1:** The nightly job fails before storing values for a lane.
- **Step 2:** System keeps using the values stored the previous night. Allocation is never blocked.
- Who is alerted when the job fails is not yet defined.

### Use Case 3: Courier Allocation at Every Stage

- Use Case runs at every stage where the system allocates a courier. Known stages: PDP, Cart, Summary, Order Placed and hard allocation at invoice.
- The scoring formula, the schedule time adjustment and the buffers do not change.

#### Use Case 3.1: Happy Case

- **Step 1:** System receives an allocation request with the warehouse and the delivery pincode.
- **Step 2:** System fetches the couriers that serve this warehouse × pincode.
- **Step 3:** System checks whether the warehouse × pincode is a live lane.
  - **Step 3.A:** If yes, system fetches each courier's stored lane TAT and lane adherence from Use Case 2.
  - **Step 3.B:** If not, system fetches each courier's values as it does today: the last 7 days, with 1 order enough.
- **Step 4:** For each courier, system calculates the score: `Buffer Adjusted Lane TAT / lane adherence + schedule time adjustment + pickup buffer + drop buffer`.
- **Step 5:** System allocates the courier with the lowest score.
- **Step 6:** System sets the promise from the allocated courier's Logistics TAT.
- **Note:** Every stage reads the same stored values on a given day.

### Use Case 4: Turn Lanes On and Off

- Use Case is performed by Product, to roll out or pause lanes.
- Product uses the same bulk upload that sets `percentile_value`.

| Parameter | Definition | Eligible Values |
|---|---|---|
| Warehouse ID | Warehouse the orders ship from | Active warehouses |
| Delivery Pincode | Pincode the orders are delivered to | 6-digit integer |
| Action | What happens to the lane | Insert, Delete |

#### Use Case 4.1: Happy Case

- **Step 1:** Product user opens the bulk upload.
- **Step 2:** User uploads a file with one row per lane: Warehouse ID, Delivery Pincode, Action = Insert.
- **Step 3:** System checks every row against the eligible values above.
- **Step 4:** System accepts the file.
- **Step 5:** The lane is live from the next nightly run. Until then, the lane keeps the existing rule.

#### Use Case 4.2: Edge Case — A row has an invalid value

- **Step 1:** User uploads a file.
- **Step 2.A:** If a row's Warehouse ID is not an active warehouse, the upload screen shows the error against that row: “Warehouse is not active.”
- **Step 2.B:** If a row's Delivery Pincode is not a 6-digit integer, the upload screen shows the error against that row: “Pincode must be a 6-digit number.”
- **Step 3:** System rejects the whole file. No lane in the file goes live.
- **Step 4:** User corrects the rows and uploads the file again.

#### Use Case 4.3: Edge Case — Turning a lane off

- **Step 1:** User uploads a file with the lane's row and Action = Delete.
- **Step 2:** From the next nightly run, system stops calculating pooled values for the lane.
- **Step 3:** The lane returns to the existing rule: its own last 7 days, with 1 order enough.

### Side effects

- Courier volumes move between couriers on live lanes. In the simulation at x = 20, with a state step in the ladder, 195 lost 12.5 points of invoice-stage orders, 286 gained 6.6 and 247 gained 5.6.
- The promise lengthens on some orders. In the simulation, the average promise rose 0.08 days. 21% of orders got a longer promise and 12% a shorter one.
- The nightly job reads up to 28 days of deliveries instead of 7.
- Orders where the courier changes cannot be compared with history. The effect on them is unmeasured.

### Open points

| # | Question | Decider |
|---|---|---|
| 1 | Which `percentile_value` do live lanes use? The simulation used 0.85. The existing default is 0.8. | Tejas |
| 2 | What is the full list of stages where a courier is allocated? | Engineering |
| 3 | Is the GOI directory available to the nightly job, and who refreshes it? | Engineering |
| 4 | How is Adherence % on live lanes compared: with non-live lanes in the same period, or with the same lanes before go-live? | Analytics |

## 4. Metrics

| Metric Type | Metric | Definition |
|---|---|---|
| Success | Adherence % | Orders on live lanes whose first delivery attempt is within the promise, in days from pickup ÷ orders on live lanes with a first delivery attempt. |
| Lead | Ops-Config Evaluations % | Courier evaluations on live lanes resolved on the ops config ÷ all courier evaluations on live lanes. |
| Lead | Sufficient-Sample Evaluations % | Courier evaluations on live lanes resolved on a pool of 20 or more orders ÷ all courier evaluations on live lanes. |
| Check | Courier Allocation Mix | Orders allocated to each courier ÷ all orders on live lanes, at each allocation stage. |
| Check | Average Promise (days) | Sum of promise days ÷ orders on live lanes, at order placed. |

## 5. Rollout & Stage Gates

No shadow mode. Lanes go live from Stage 1, and each stage widens the set.

| Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria |
|---|---|---|---|---|
| 1. Pilot lanes | Confirm the nightly values and the lane switch work on live orders. | Product turns on warehouse × pincode lanes covering about 5% of Courier Forward orders. Monitor for 7 days. | Adherence %: target to be set from baseline. Ops-Config Evaluations % and Sufficient-Sample Evaluations % move as designed on live lanes: target to be set from baseline. | Average Promise (days): threshold to be set from baseline. Courier Allocation Mix: threshold to be set from baseline. |
| 2. Wider lanes | Confirm the gain holds across warehouses and couriers. | Live lanes cover about 25% of Courier Forward orders. Monitor for 7 days. | Adherence %: target to be set from baseline. | Average Promise (days) and Courier Allocation Mix: thresholds to be set from baseline. |
| 3. All lanes | Make the minimum sample size the only rule. | All warehouse × pincodes go live. After 7 days without a kill trigger, the existing 1-order rule and the lane switch are removed. | Adherence %: target to be set from baseline. | Average Promise (days) and Courier Allocation Mix: thresholds to be set from baseline. |

## 6. Worked Examples

### Example 1: Pool selection and allocation (Use Cases 1.1 and 3.1)

**Scenario:** order 55590586, warehouse 37 → pincode 271604, placed 21 Sep 2026 13:57. All couriers are on a live lane. `percentile_value` is 0.85 (simulation setting).

**Starting state:** couriers 195, 225, 246 and 247 serve the pincode. Pools below 20 orders are skipped.

| Courier | Pool used | Orders in pool |
|---|---|---|
| 195 | Micro-cluster, 7 days (pincode pool has 1 order in every window) | 44 |
| 225 | Pincode, 14 days (7 days has 1 order) | 48 |
| 246 | Pincode, 7 days | 45 |
| 247 | Macro-cluster, 7 days (pincode has 0 orders over 7 days; no pincode or micro-cluster window reaches 20) | 39 |

**Steps:**
1. 195: lane TAT 3 days, lane adherence 95.45%. Score 3 ÷ 0.9545 = 3.1429.
2. 225: lane TAT 4, lane adherence 91.67%. Score 4.3636.
3. 246: lane TAT 2, lane adherence 93.33%. Score 2.1429.
4. 247: lane TAT 3, lane adherence 100%. Score 3.0.
5. The system allocates 246, the lowest score, and promises 2 days.

**Result:** 246 is allocated. The existing rule scored 195 and 225 at 2.0 each, on 1 order and 100% lane adherence, ahead of 246 at 2.1429.

### Example 2: No pool reaches 20, and no pool has an order (Use Cases 1.3 and 1.4) (illustrative)

**Scenario:** a courier on a live lane in another warehouse.

**Steps:**
1. Courier A: no pool reaches 20. The macro-cluster pool over 28 days has 12 orders. The job uses those 12 orders.
2. Courier B: the macro-cluster pool over 28 days has 0 orders. The ops config gives TAT 4 days. `tat_adherence_master` gives lane adherence 88.15%. Score 4 ÷ 0.8815 = 4.5377.

**Result:** both couriers get values. Courier A's rest on fewer than 20 orders. Courier B's rest on the ops config.

### Example 3: Turning a lane on, and a rejected file (Use Cases 4.1 and 4.2) (illustrative)

**Steps:**
1. On 21 Sep, Product uploads a file with two rows, both with Action = Insert: warehouse 37 × 271604, and warehouse 37 × 27160.
2. The system rejects the whole file. The upload screen shows “Pincode must be a 6-digit number.” against the second row.
3. Product removes the second row and uploads the file again. The system accepts it.
4. The nightly job on 22 Sep calculates pooled values for warehouse 37 × 271604.
5. Orders allocated on 22 Sep read the pooled values. Orders allocated on 21 Sep keep the existing values.

**Result:** warehouse 37 × 271604 is live from the 22 Sep run.
