---
**Document:** Minimum Sample Size in Courier Allocation
**Type:** Executable PRD
**Version:** v2
**Date:** 2026-10-20
**Status:** Under Review
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-10-20 | Initial draft |
| v2 | 2026-10-20 | Use Case 1 rewritten as a step-by-step if / else flow with a counting rule and a window table |
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

**Terms.**
- **Live lane:** a warehouse × pincode that Product has turned on (Use Case 4). Every courier on it is scored with the rules below.
- **Pool:** the deliveries a lane's TAT and lane adherence are calculated from. A pool is the deliveries of one warehouse × one courier in a geography, with a first delivery attempt inside a window. A window of N days ends the day before the nightly job runs. All deliveries count, whether or not their pincodes are live.
- **Micro-cluster:** pincodes in the same state, district and division in the GOI directory. Each pincode takes one value per field, chosen by the majority of its post offices.
- **Macro-cluster:** pincodes that share the first three digits.
- **Minimum sample size (x):** 20 orders. Fixed value.

### Use Case 1: Choose the pool for a courier on a live lane

**Who and when:** the nightly job (3:00 AM for FCs, 3:30 AM for MFCs). It runs this once for every courier that serves a live lane. The inputs are the lane's warehouse, its delivery pincode and the courier.

**What the job is deciding:** which past deliveries to learn this courier's speed from. The job wants at least 20 orders. It starts with the narrowest, most local set of orders. Each time that set has fewer than 20, it moves to a wider set. It stops at the first set with 20 or more.

**How to count orders in a pool.** The job counts orders with all four of these true:
- The order's warehouse is the lane's warehouse.
- The order's courier is this courier.
- The order's delivery pincode is inside the geography being checked (the pincode, its micro-cluster or its macro-cluster).
- The date of the order's first delivery attempt falls inside the window. A window of N days starts N days before the run date and ends the day before the run date, both dates included.

**Windows are cumulative.** The 14-day window contains the 7-day window. It is a wider look, not extra orders. For a run on 22 Sep, the windows are:

| Window | Dates counted |
|---|---|
| 7 days | 15 Sep to 21 Sep |
| 14 days | 8 Sep to 21 Sep |
| 21 days | 1 Sep to 21 Sep |
| 28 days | 25 Aug to 21 Sep |

**Main flow.** Do the steps in order. At every step, count the orders first, then follow the branch.

1. Count orders in the **pincode** over **7 days**.
   - If the count is 20 or more, use this pool and stop. Go to Use Case 2.
   - Else, go to step 2.
2. Count orders in the **pincode** over **14 days**.
   - If the count is 20 or more, use this pool and stop. Go to Use Case 2.
   - Else, go to step 3.
3. Count orders in the **pincode** over **21 days**.
   - If the count is 20 or more, use this pool and stop. Go to Use Case 2.
   - Else, go to step 4.
4. Count orders in the **pincode** over **28 days**.
   - If the count is 20 or more, use this pool and stop. Go to Use Case 2.
   - Else, the pincode alone does not have enough orders. Go to step 5.
5. Check whether the lane's pincode is in the GOI directory.
   - If it is, go to step 6.
   - Else, go to Use Case 1.3. It skips steps 6 to 9 and continues at step 10.
6. Count orders in the **micro-cluster** over **7 days**. The micro-cluster is every pincode with the same state, district and division as the lane's pincode.
   - If the count is 20 or more, use this pool and stop. Go to Use Case 2.
   - Else, go to step 7.
7. Count orders in the **micro-cluster** over **14 days**.
   - If the count is 20 or more, use this pool and stop. Go to Use Case 2.
   - Else, go to step 8.
8. Count orders in the **micro-cluster** over **21 days**.
   - If the count is 20 or more, use this pool and stop. Go to Use Case 2.
   - Else, go to step 9.
9. Count orders in the **micro-cluster** over **28 days**.
   - If the count is 20 or more, use this pool and stop. Go to Use Case 2.
   - Else, go to step 10.
10. Count orders in the **macro-cluster** over **7 days**. The macro-cluster is every pincode that shares the first three digits with the lane's pincode.
    - If the count is 20 or more, use this pool and stop. Go to Use Case 2.
    - Else, go to step 11.
11. Count orders in the **macro-cluster** over **14 days**.
    - If the count is 20 or more, use this pool and stop. Go to Use Case 2.
    - Else, go to step 12.
12. Count orders in the **macro-cluster** over **21 days**.
    - If the count is 20 or more, use this pool and stop. Go to Use Case 2.
    - Else, go to step 13.
13. Count orders in the **macro-cluster** over **28 days**. This is the widest pool.
    - If the count is 20 or more, use this pool and stop. Go to Use Case 2.
    - Else if the count is between 1 and 19, go to Use Case 1.1.
    - Else (the count is 0), go to Use Case 1.2.

**Result:** the courier has one pool. Use Case 2 calculates lane TAT and lane adherence from it. The warehouse and the courier never change from step to step. Only the geography and the window widen.

**Use Case 1.1: Edge Case — no pool reaches 20 orders, but the widest pool has some**
1. This case starts from step 13 with a count between 1 and 19.
2. The job uses the macro-cluster pool over 28 days, even though it has fewer than 20 orders.
3. Go to Use Case 2.

**Use Case 1.2: Edge Case — the widest pool has no orders**
1. This case starts from step 13 with a count of 0.
2. If the ops config has a TAT for this warehouse × pincode × courier, the job uses that TAT. The ops config tables are `pincode_delivery_tat` and `pincode_delivery_tat_mfc`.
3. Else, the job uses 3 days (Supposed TAT).
4. In both cases, the job reads lane adherence from `tat_adherence_master`.
5. Go to Use Case 2.

**Use Case 1.3: Edge Case — the pincode is not in the GOI directory**
1. The job cannot build a micro-cluster for this pincode, so it skips steps 6 to 9.
2. The job continues at step 10 with the macro-cluster. The macro-cluster needs only the pincode's first three digits.

### Use Case 2: Calculate lane TAT and lane adherence from the pool

**Who and when:** the nightly job, after Use Case 1.

If Use Case 1.2 applied, skip steps 1 to 3. The job stores the ops-config TAT, or 3 days, and the lane adherence from `tat_adherence_master`.

1. The job reads `percentile_value` for the lane from the existing configuration, by warehouse, pincode and courier.
2. The job calculates lane TAT as `ROUNDUP(PERCENTILE(actual days, percentile_value))`. Actual days are `DATE(delivery_attempt_time) - DATE(pickup_time)`.
3. The job calculates lane adherence over the nine delay-day buckets (Early 4+ days to Late 4+ days), as in Performance Based Speed Calculation & Allocation. Delay days are each order's actual days minus its own promise.
4. The job stores lane TAT and lane adherence for the lane.

**Result:** every courier on a live lane has a lane TAT and lane adherence from its pool.

**Use Case 2.1: Edge Case — the nightly job does not complete**
1. The system keeps the previous night's values. Allocation is never blocked.

### Use Case 3: Allocate a courier at any stage

**Who and when:** the system, at every stage where it allocates a courier. Known stages: PDP, Cart, Summary, Order Placed and hard allocation at invoice.

1. The system keeps the couriers that serve the warehouse × pincode.
2. If the warehouse × pincode is a live lane, the system reads each courier's stored values from Use Case 2. Otherwise it reads the existing values.
3. The system scores each courier with the existing formula: Buffer Adjusted Lane TAT ÷ lane adherence + schedule time adjustment + pickup buffer + drop buffer.
4. The system allocates the lowest score. The winner's Logistics TAT is the promise.

**Result:** every stage reads the same nightly values for a lane.

### Use Case 4: Turn lanes on and off

**Who and when:** Product, to roll out or pause a lane.

1. Product uploads a list of warehouse × pincode through the same bulk upload used for `percentile_value`.
2. The system rejects a row whose warehouse is not active or whose pincode is not a 6-digit integer. It shows the error against that row.
3. From the next nightly run, each accepted lane follows Use Cases 1 and 2. Until then it keeps the existing values.
4. To turn a lane off, Product deletes its row. From the next nightly run the lane returns to the existing rule: its own last 7 days, with 1 order enough.

**Result:** only live lanes use the minimum sample size.

**Side effects**
- Courier volumes move between couriers on live lanes. In the simulation at x = 20, with a state step in the ladder, 195 lost 12.5 points of invoice-stage orders, 286 gained 6.6 and 247 gained 5.6.
- The promise lengthens on some orders. In the simulation, the average promise rose 0.08 days. 21% of orders got a longer promise and 12% a shorter one.
- The nightly job reads up to 28 days of deliveries instead of 7.
- Orders where the courier changes cannot be compared with history. The effect on them is unmeasured.

**Open points**

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

### Example 1: Pool selection and allocation (Use Cases 1 and 3)

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

### Example 2: No pool reaches 20, and no pool has an order (Use Cases 1.1 and 1.2) (illustrative)

**Scenario:** a courier on a live lane in another warehouse.

**Steps:**
1. Courier A: no pool reaches 20. The macro-cluster pool over 28 days has 12 orders. The job uses those 12 orders.
2. Courier B: the macro-cluster pool over 28 days has 0 orders. The ops config gives TAT 4 days. `tat_adherence_master` gives lane adherence 88.15%. Score 4 ÷ 0.8815 = 4.5377.

**Result:** both couriers get values. Courier A's rest on fewer than 20 orders. Courier B's rest on the ops config.

### Example 3: Turning a lane on, and a rejected row (Use Case 4) (illustrative)

**Steps:**
1. On 21 Sep, Product uploads two rows: warehouse 37 × 271604, and warehouse 37 × 27160.
2. The system accepts the first row. It rejects the second row because the pincode is not a 6-digit integer.
3. The nightly job on 22 Sep calculates pooled values for warehouse 37 × 271604.
4. Orders allocated on 22 Sep read the pooled values. Orders allocated on 21 Sep keep the existing values.

**Result:** warehouse 37 × 271604 is live from the 22 Sep run.
