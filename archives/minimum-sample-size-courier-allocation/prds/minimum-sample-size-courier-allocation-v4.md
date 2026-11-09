---
**Document:** Minimum Sample Size in Courier Allocation
**Type:** Executable PRD
**Version:** v4
**Date:** 2026-11-09
**Status:** Under Review
**Author:** Tejas Bhalerao
---

# [PRD] Minimum Sample Size in Courier Allocation

## Contents

- Objective
- Why Now
- Use Case 1: Pool Selection
- Use Case 2: Lane TAT and Lane Adherence Calculation
- Use Case 3: Courier Allocation at Every Stage
- Use Case 4: Turn Lanes On and Off
- Metrics
- Rollout & Stage Gates
- Worked Examples

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
| Window | The last N days (7, 14, 21 or 28) before the nightly job runs. It ends on the day before the run date. A longer window contains the shorter ones. |
| Micro-cluster | All pincodes with the same state, district and division in the GOI directory. Each pincode takes one value per field, chosen by the majority of its post offices. |
| Macro-cluster | All pincodes that share the first three digits. |
| Minimum Sample Size (x) | 20 orders. Fixed value. |

### Use Case 1: Pool Selection

- Use Case runs once per night, for every courier that serves a live lane.
- Warehouse and courier stay the same in every check. Only the geography and the window widen.
- An order is counted in a pool only when all of these are true:
  - The order's warehouse is the lane's warehouse.
  - The order's courier is this courier.
  - The order's delivery pincode is inside the geography being checked.
  - The date of the order's first delivery attempt is inside the window.

**The 12 checks.** Numbers show the order. Check 1 is first, check 12 is last.

| Geography | 7 days | 14 days | 21 days | 28 days |
|---|---|---|---|---|
| Pincode | 1 | 2 | 3 | 4 |
| Micro-cluster | 5 | 6 | 7 | 8 |
| Macro-cluster | 9 | 10 | 11 | 12 |

For a run on 22 Sep, the windows are: 7 days = 15 Sep to 21 Sep; 14 days = 8 Sep to 21 Sep; 21 days = 1 Sep to 21 Sep; 28 days = 25 Aug to 21 Sep.

#### Use Case 1.1: Happy Case

- **Step 1:** System starts the nightly job at 3:00 AM for FCs and 3:30 AM for MFCs.
- **Step 2:** System fetches every live lane of the warehouses in that run, and the couriers that serve each lane's pincode.
- **Step 3:** For each courier on each live lane, system starts at check 1.
- **Step 4:** System counts the orders in the pool for the current check.
  - **Step 4.A:** If the count is 20 or more, system selects this pool, skips the remaining checks and moves to Use Case 2.
  - **Step 4.B:** If the count is less than 20, system moves to the next check and repeats Step 4.
- **Step 5:** If check 12 also has fewer than 20 orders, system follows Use Case 1.3 (1 to 19 orders) or Use Case 1.4 (0 orders).
- **Note:** Checks 5 to 8 need the lane's pincode in the GOI directory. If it is not there, system follows Use Case 1.2.

#### Use Case 1.2: Edge Case — Pincode is not in the GOI directory

- **Step 1:** System cannot build a micro-cluster for this pincode, so it skips checks 5 to 8.
- **Step 2:** System goes from check 4 to check 9. The macro-cluster needs only the first three digits of the pincode.

#### Use Case 1.3: Edge Case — No pool reaches 20 orders, but check 12 has some

- **Step 1:** System counts 1 to 19 orders at check 12.
- **Step 2:** System selects the pool from check 12, even though it has fewer than 20 orders.
- **Step 3:** System moves to Use Case 2.

#### Use Case 1.4: Edge Case — Check 12 has no orders

- **Step 1:** System counts 0 orders at check 12.
- **Step 2.A:** If the ops config has a TAT for this warehouse × pincode × courier (tables `pincode_delivery_tat` and `pincode_delivery_tat_mfc`), system uses that TAT.
- **Step 2.B:** If not, system uses 3 days (Supposed TAT).
- **Step 3:** System reads lane adherence from `tat_adherence_master`.
- **Step 4:** System moves to Use Case 2.

### Use Case 2: Lane TAT and Lane Adherence Calculation

- Use Case runs after Use Case 1, for every courier on every live lane.

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

| Priority | `percentile_value` configuration |
|---|---|
| 1 | Warehouse × pincode × courier |
| 2 | Warehouse × pincode |
| 3 | Warehouse |
| 4 | Default value |

#### Use Case 2.1: Happy Case

- **Step 1:** System receives the selected pool from Use Case 1.
- **Step 2:** System fetches `percentile_value` using the first configuration that exists, in the priority order above.
- **Step 3:** For each order in the pool, system calculates actual days as `DATE(delivery_attempt_time) - DATE(pickup_time)`.
- **Step 4:** System calculates lane TAT as `ROUNDUP(PERCENTILE(actual days, percentile_value))`.
- **Step 5:** For each order in the pool, system calculates delay days as the order's actual days minus the promise given to that order. Delay days can be negative.
- **Step 6:** System places each order in a bucket using the Delay Days table.
- **Step 7:** System adds up the buckets from Early 4+ Days down to Late 4+ Days. After each bucket, it divides the running total by the number of orders in the pool. It stops at the first bucket where this share is at least `percentile_value`. Lane adherence is the share at that bucket.
- **Step 8:** System stores lane TAT and lane adherence for the courier on the lane.

#### Use Case 2.2: Edge Case — Pool came from the ops config

- **Step 1:** System receives the ops-config TAT (or 3 days) and the `tat_adherence_master` adherence from Use Case 1.4.
- **Step 2:** System skips Steps 2 to 7 of Use Case 2.1 and stores these two values as lane TAT and lane adherence.

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
- **Step 3:** System checks every row against the eligible values above and accepts the file.
- **Step 4:** The lane is live from the next nightly run. Until then, the lane keeps the existing rule.

#### Use Case 4.2: Edge Case — A row has an invalid value

- **Step 1:** User uploads a file.
- **Step 2.A:** If a row's Warehouse ID is not an active warehouse, the upload screen shows the error against that row: “Warehouse is not active.”
- **Step 2.B:** If a row's Delivery Pincode is not a 6-digit integer, the upload screen shows the error against that row: “Pincode must be a 6-digit number.”
- **Step 3:** System rejects the whole file. No lane in the file goes live.
- **Step 4:** User corrects the rows and uploads the file again.

#### Use Case 4.3: Edge Case — Turning a lane off

- **Step 1:** User uploads a file with the lane's row and Action = Delete.
- **Step 2:** From the next nightly run, system stops calculating pooled values for the lane. The lane returns to the existing rule.

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

| Courier | Check that selected the pool | Orders in pool | Lane TAT | Lane adherence | Score |
|---|---|---|---|---|---|
| 195 | Check 5 (micro-cluster, 7 days). Checks 1 to 4 each had 1 order. | 44 | 3 | 95.45% | 3 ÷ 0.9545 = 3.1429 |
| 225 | Check 2 (pincode, 14 days). Check 1 had 1 order. | 48 | 4 | 91.67% | 4.3636 |
| 246 | Check 1 (pincode, 7 days) | 45 | 2 | 93.33% | 2.1429 |
| 247 | Check 9 (macro-cluster, 7 days). Checks 1 to 8 were below 20. | 39 | 3 | 100% | 3.0 |

**Result:** system allocates 246, the lowest score, and promises 2 days. The existing rule scored 195 and 225 at 2.0 each, on 1 order and 100% lane adherence, ahead of 246 at 2.1429.

### Example 2: No pool reaches 20, and no pool has an order (Use Cases 1.3 and 1.4) (illustrative)

**Scenario:** two couriers on a live lane in another warehouse.

- Courier A: checks 1 to 11 are below 20. Check 12 has 12 orders. System uses those 12 orders.
- Courier B: check 12 has 0 orders. The ops config gives TAT 4 days. `tat_adherence_master` gives lane adherence 88.15%. Score 4 ÷ 0.8815 = 4.5377.

**Result:** both couriers get values. Courier A's rest on fewer than 20 orders. Courier B's rest on the ops config.

### Example 3: Turning a lane on, and a rejected file (Use Cases 4.1 and 4.2) (illustrative)

1. On 21 Sep, Product uploads a file with two rows, both Action = Insert: warehouse 37 × 271604, and warehouse 37 × 27160.
2. System rejects the whole file. The upload screen shows “Pincode must be a 6-digit number.” against the second row.
3. Product removes the second row and uploads the file again. System accepts it.
4. The nightly job on 22 Sep calculates pooled values for warehouse 37 × 271604.
5. Orders allocated on 22 Sep read the pooled values. Orders allocated on 21 Sep keep the existing values.

**Result:** warehouse 37 × 271604 is live from the 22 Sep run.
