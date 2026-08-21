# [PRD] Modular Payment Pending

## Table of Contents

- [Objective](#objective)
- [Why Now?](#why-now)
- [Use Case 1: Configurability of Elements in Payment Pending](#use-case-1-configurability-of-elements-in-payment-pending)
- [Use Case 2: Eligibility & Exception Lists](#use-case-2-eligibility--exception-lists)
- [Use Case 3: Converting Orders from Prepaid to COD](#use-case-3-converting-orders-from-prepaid-to-cod)
- [Use Case 4: Reallocation of Courier Partner](#use-case-4-reallocation-of-courier-partner)
- [Use Case 5: COD Conversion for Primary Courier Orders](#use-case-5-cod-conversion-for-primary-courier-orders)
- [Use Case 6: Visibility of Scheduler Runs](#use-case-6-visibility-of-scheduler-runs)
- [Metrics](#metrics)
- [Rollout & Stage Gates](#rollout--stage-gates)
- [Worked Examples](#worked-examples)

---

## Objective

Rethink the way payment pending schedulers are executed today to dispatch orders for Bluedart, Shiprocket, Shiprocket Courier, and Shiprocket NDD.

---

## Why Now?

**Current Process:**

1. Run courier allocation at invoice generation / order confirmed.
2. If selected courier = Bluedart / Shiprocket, and the payment method = Prepaid, push the order into the Payment Pending bucket.
3. This selected courier is locked at this stage.
4. Scheduler runs at a defined time period currently hardcoded as 1 hour before the cutoff of Bluedart and Shiprocket respectively.
5. This scheduler considers all orders that entered payment pending up to 3 hours before the scheduler's run time.
6. If the customer pays before this scheduler runs for the order, then the payment method remains as Prepaid, else the scheduler changes the payment method to COD.
7. Once the scheduler has run, the ops starts generating the AWBs for each order. AWBs are created against the same courier for which the payment pending state was entered.

This process repeats daily.

The above process is broken in the following places:

| Sr. No. | Problem | Consequence |
|:---:|:---:|:---:|
| 1. | The courier selected at the time of order confirmation remains the same. | An order remains in the payment pending stage for any time between 3 to 24 hours during which courier performance changes and courier allocation decision would change. |
| 2. | Scheduler run time is a hard coded value in the database. | Tomorrow if the ops team changes or wants to change the schedule time for a payment pending scheduler eligible courier, the team has to reach out to engineering to change the scheduler's run time to align with the new schedule time. |
| 3. | Orders considered for scheduler run are hard-coded at 3 hours before. | All orders across all warehouses get considered for scheduler run even though customers may exhibit different behaviour. |

Due to these problems, and the nature of payment pending, customer experience is manifested in the following manner:

| | |
|:---:|:---:|
| Delayed Dispatch | 7.2% |
| Delayed Dispatch & Delayed Delivery Attempt | 3.6% |
| Delayed Dispatch (Bluedart) | 17.2% |
| Delayed Dispatch (excluding Bluedart) | 6.4% |

---

## Use Case 1: Configurability of Elements in Payment Pending

- System maintains a configurable parameter of when the following elements are executed with the following specifications:

| Element | Definition | Data Type | Condition | Example State |
|:---:|:---:|:---:|:---:|:---:|
| Reminder Message Trigger | Time in hours when reminder messages are triggered before scheduler execution | Float | Configurable at a warehouse level. | WH 20 has reminders triggered 1 hour before scheduler run-time. WH 40 has reminders triggered 2 hours before scheduler run-time. |
| Scheduler Run-Time | Time in hours when the payment pending scheduler is run before dispatch time | Float | Configurable at a courier level. | WH 20 has scheduler run time 1 hour before schedule time. WH 40 has scheduler run time 0.5 hours before schedule time. |
| Order Cutoff | Time in hours till when the orders should be considered before scheduler run-time. | Float | Configurable at a courier level. | WH 20 has order cutoff as 3 hours before the scheduler run-time. WH 40 has order cutoff as 4 hours before the scheduler run-time. |
| Reminder Message Frequency | Frequency at which reminder messages are triggered. | Integer | Configurable at a warehouse level. | WH 20 has reminders triggered 3 times. WH 40 has reminders triggered 4 times. |

- Each of the above elements should be configuration driven with changes possible in-flight at any point in time via a bulk upload mechanism.

---

## Use Case 2: Eligibility & Exception Lists

### Use Case 2.1: Changes to Existing Exception List

- Whenever a prepaid order reaches the check of Payment Pending, the system refers to an exception list.
- This exception list corresponds to the list of courier partners for whom Payment Pending state is excluded.
- The system migrates the existing list of couriers for which Payment Pending is excluded. Any new courier that gets introduced in the system is automatically added to the exception list without manual intervention from the engineering team.
- The new courier is only removed from the exception list only if specific requests are received from the product and business team.
- This process of removal and the corresponding addition of eligibility list should be completely config driven without the need for a deployment.
- Addition / Readdition of a courier to the exception list should also be completely config driven without the need for a deployment.
- If a courier is present in the exception list, the existence of its eligibility list is subsequently ignored by the system.

### Use Case 2.2: Introduction of Eligibility Lists

- Every courier who is not part of the exception list, automatically has an eligibility list created against it.
- In such cases, eligibility lists are created automatically without engineering involvement.
- This eligibility list represents all couriers to whom reallocation is eligible to run for.
- When an order of the courier not in the exception list enters the Payment Pending stage, the system refers to the eligibility list of the courier.
- The creation and modification of the eligibility list is powered through a bulk upload mechanism.
- Eligibility list is mandated to have at least 1 courier. This one mandated courier has to be the same as the courier for whom the eligibility list is being created for.
- The above remains true for the system irrespective of whether the users have configured this through the bulk upload mechanism or not.

---

## Use Case 3: Converting Orders from Prepaid to COD

- **Step 1:** For all the couriers in the eligibility list, the system fetches the respective schedule times specific to that warehouse.
- **Step 1.A — Multiple Cutoff Handling:** In case of multiple cutoffs, the system fetches all the cutoffs of that courier.
- **Step 1.B — Pincode Specific Cutoff Handling:** In case of cutoffs specific to that pincode, the system will ignore these cutoffs. This workflow will be applied only for cutoffs applicable at a warehouse level.
- **Step 2:** Based on the pickup buffers, the system adjusts the schedule times to calculate the dispatch times.
- **Step 3:** For each of these values of dispatch times, the system then calculates the times at which the scheduler is supposed to run.
  - This is done by referring to the "Scheduler Run-Time" element configuration present in Use Case 1.
  - Scheduler Run-Times are configured separately for each courier — one for whom the eligibility list is built and another for those that are part of the eligibility list.
  - At these defined scheduler runs, the system selects the eligible list of orders for which the scheduler should run.
  - **Eligibility Criteria for selecting orders for scheduler run:**
    - Order's Payment Method is Prepaid and Payment is not yet completed.
    - Order entered Payment Pending stage "Order Cutoff" hours before the scheduler is supposed to run.
    - Order's destination pincode is eligible for the schedule time on which the scheduler is selected to run.
  - For couriers who are part of the eligibility list and different from the courier for whom the eligibility list is created, "Order Cutoff" must be set to 0 hours.
- In each scheduler run, the system executes Use Case 4.

---

## Use Case 4: Reallocation of Courier Partner

- Reallocation of courier happens at every scheduler run.
- Following from Use Case 3, a scheduler run occurs "Scheduler Run-Time" hours before the dispatch time.
- At each scheduler run, the system fetches all orders that are currently in the Payment Pending stage.
- For each order, the system calls Clickpost to receive the recommended courier partner list.
- Once this list is received, the system evaluates the best courier partner through the following allocation flows:
  - Legacy TAT/Adherence Logic
  - PBA
  - Courier Allocation Experiments

- **TAT/Adherence Adjustment:** Prior to running the above flows, the system derives the **Order Cutoff Time** for each courier in the consideration set individually:
  - Order Cutoff Time of a courier = Scheduler Run Time of that courier − "Order Cutoff" of that courier (as configured in Use Case 1).
- If the order entered Payment Pending **after** the Order Cutoff Time of a given courier, the system applies a **+1 day adjustment** to that courier's TAT/Adherence score.
- If the order entered Payment Pending **on or before** the Order Cutoff Time of a given courier, no adjustment is applied.
- This evaluation is performed independently for each courier in the consideration set.
- The existing logic of applying promise buffers at each stage of courier allocation for courier selection remains unchanged.
- Once the courier is selected, the process proceeds to Use Case 5.

**\*\*Note:\*\* The following things continue to work as expected during allocation — Pickup Buffer, Drop Buffer, and Schedule Time adjustment.**

---

## Use Case 5: COD Conversion for Primary Courier Orders

For the purposes of this use case, the courier for whom the eligibility list is created is referred to as the **Primary Courier** (e.g., Bluedart). Couriers within the eligibility list who are different from the Primary Courier are referred to as **Eligibility List Couriers** (e.g., Delhivery, XpressBees).

- **Step 1:** Once a courier is selected in Use Case 4, the system checks whether the selected courier is the Primary Courier or an Eligibility List Courier.
  - If the selected courier is an **Eligibility List Courier**: the payment method remains unchanged. These couriers can dispatch prepaid orders without a change in payment method. The order proceeds to AWB generation.
  - If the selected courier is the **Primary Courier**: the system proceeds to Step 2.

- **Step 2:** The system checks whether the order entered Payment Pending on or before the Primary Courier's **Order Cutoff Time**.
  - Order Cutoff Time = Scheduler Run Time of Primary Courier − Order Cutoff of Primary Courier (as configured in Use Case 1).

  - **If the order entered Payment Pending on or before the Order Cutoff Time:**
    - The customer has had sufficient time to complete the payment.
    - If payment has not been completed, the system converts the payment method to COD.
    - The order proceeds to AWB generation and is dispatched via the Primary Courier on the same day.

  - **If the order entered Payment Pending after the Order Cutoff Time:**
    - The customer has not had sufficient time to complete the payment.
    - The system does **not** convert the payment method to COD.
    - The order is held in Payment Pending and is **not** dispatched via the Primary Courier today.
    - **Step 2.A — Continuous Reallocation Window:** The held order remains eligible for evaluation in all subsequent scheduler runs — both same-day and on following days — for Eligibility List Couriers. If an Eligibility List Courier is selected for this order at any point, it is assigned to that courier and dispatched without a COD conversion.
    - **Step 2.B — Primary Courier Next-Day Run:** If no Eligibility List Courier scheduler takes the order before the Primary Courier's next scheduled run, the Primary Courier's next-day scheduler will process the order. At that point, the order will satisfy the Order Cutoff eligibility (having been in Payment Pending for 24+ hours) and will be converted to COD and dispatched via the Primary Courier.

**\*\*Note:\*\* If the customer completes payment at any point while the order is held in Payment Pending, the payment method remains Prepaid and the order proceeds without any COD conversion.**

---

## Use Case 6: Visibility of Scheduler Runs

- Operations team is provided with a Metabase view which gives them the following inputs:
  - Date
  - Warehouse ID
  - Courier for which the scheduler will be run
  - Time of day when the scheduler will be run
- Metabase view should allow the ops team to select Date Range and Warehouse ID as filters.
- To prepare for the upcoming days, the warehouse team will also be able to see the schedulers which will be run on subsequent days.
- This view should be capable of supporting scheduler run times for both legacy as well as new systems.

---

## Metrics

TBD

---

## Rollout & Stage Gates

| Rollout | Stage | Scale Criteria |
|:---:|:---:|:---:|
| Warehouse [TBD] | Production & Ops Sanity | — Capability works as intended · Operations is able to follow set SOPs |
| Full Scale | — | — |

---

## Worked Examples

Link to Worked Examples [here](https://claude.ai/code/artifact/49e103a5-ffc2-4930-a9f2-cd0ac04f8eea).
