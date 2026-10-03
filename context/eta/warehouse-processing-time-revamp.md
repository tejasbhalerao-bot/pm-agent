---
title: Warehouse Processing Time Revamp
source: https://docs.google.com/document/d/1YGonOss1mISMWd5yvogl1G8H_nEhQeYLpJhq5PC_HKY/edit
type: past-prd
verticals: [courier-forward, hyperlocal-forward]
systems: [eta]
updated: 2026-07-10
---

# v1

# [PRD] Warehouse Processing Time Revamp v1

---

## RACI

| **RACI** | **SPOC** |
| :-: | :-: |
| Accountable | Tejas Bhalerao<br>Kartik Mittal |
| Responsible | Tejas Bhalerao<br>Mohammed Fahad<br>Ashish Ranjan |
| Consulted | Anbu Dhileepan<br>Rajendran KRR<br>Atul Nanda<br>Sumit Goyal<br>Kunal Wani |
| Informed | Ajit Murkar<br>Himanshu Bhomia |

## Objective

Replace the current warehouse processing time calculation logic with what on-ground operations currently follow – so that system calculations are consistent with the on-ground reality.

## Why Now?

Warehouse processing time is systematically miscalculated in the system today and is not representative of how on-ground operations run today. Due to these misconfigurations, ETA promises to the customer also get affected. Specific instances of these are captured below.

**Instance #1: Warehouse’s configured working hours.**

- Most warehouses have their working hours configured between 10am and 7pm. Some are exceptions with working hours configured as 11am to 8pm.
- In reality, almost all warehouses operate from 7am to 10pm.
- Based on current understanding, operational buffers are taken here to reduce the load on the warehouse during closing and opening to effectively clear order backlog.
- However, such assumptions create cascading effects in promise ETA due to SDD cutoff logic. For example, mid-mile deliveries have a dispatch cutoff at 10am. If the warehouse itself opens at 10am for the system, promises get unnecessarily pushed to the next day since according to the system, the warehouse cannot possibly process the order.
- However, in reality, the warehouse has spent time packing the order between 7am and 10am. When we look into actuals, the order actually gets delivered early since the pseudo promise buffer to warehouse time is not applied in reality.

**Instance #2: No audit trails in their system which makes traceability inferential and not deterministic. => Handled as part of a separate initiative (ETA Revamp)**

- Every configuration in the warehouse - processing times, week off schedule, work start, and work end - directly gets updated in the system without knowing what their previous values were or there is no linkage between an order and its corresponding configuration.
- As a result, when stakeholders try to explain the behaviour of the system, they have available with them - today’s configurations and yesterday’s values.
- Explaining a system's behaviour in such cases makes it entirely impossible deterministically. Only best guess judgements or inferences can be made here.

**Instance #3: Non-Inventory Processing Logic deviates drastically from operational reality.**

- **Today the system identifies Non-inventory order processing time as ranging from 11 hours to 13.5 hours depending on the warehouse.**
- **This gets counted only during working hours.**
- **However, the operational reality is that an order has to run through 2 JIT cycles before it can be committed to be marked as warehouse processed.**
- Today, we want the order to pass through 2 JIT cycles since the warehouse reaches a fill rate of 90% within 2 JIT cycles.

## Use Cases

### Use Case 1: Changing Warehouse Working Hours

- Warehouse work start and work end times need to be updated to the following values:

| **Work Start** | **Work End** |
| :-: | :-: |
| 6:00 AM | 11:00 PM |

- Today, the system also uses a default value of warehouse operating hours as 10AM to 7PM. This configuration now gets revised to the above.

### Use Case 2: Warehouse Processing Time Calculation Logic

System will take into consideration the following factors while deciding the promised warehouse processing time for an order:

- **Warehouse type** (FC / MFC): For the next set of configurations look up.
- **Delivery Type** (SDD / non-SDD): For the next set of configurations look up.
- **Order’s Inventory State** (Inventory / Non-Inventory)
- **Warehouse Packing Time**: Replaces legacy terminology of Warehouse Processing Time.
- **Warehouse Weekoff Schedule**: Retains the existing behaviour of the weekoff schedule.
- **JIT Cutoff**: Time where the ops team starts the JIT process.
- **JIT Lead Time:** Time that the ops team takes to complete the JIT process.

When the promise engine is invoked at any stage of the lifecycle, the system first resolves the pre-requisite order classification criteria: Warehouse type, delivery type, Order’s inventory state.

#### Use Case 2.1: Warehouse Packing Time

- Warehouse systems refer to the following configurations of: SDD_Inventory and NonSDD_Inventory.
- These configurations are used as the source of truth for how long the warehouse will take to “pack” an order.
- Take the example of an inventory order. Every inventory order will refer to its respective configuration (SDD/NonSDD) to check what is the configured warehouse packing time against it.
- This “packing” time is applied as the warehouse processing time in all ETA calculations.
- The same packing time is also referenced for non-inventory orders. Warehouse processing time computation of non-inventory orders will be covered later.

#### Use Case 2.2: JIT Cutoff Time & JIT Lead Time

- The system maintains the configurations of JIT cutoff times. These are times when the JIT “cycle” officially begins. Maintained in HH:MM (24 hour format).
- The system also maintains a configuration of JIT lead time. These are times when the JIT “cycle” officially completes. Maintained in the unit of hours.
- Lead time runs irrespective of working hours of the warehouse.
- Inputted configurations look like the below:

| **Parameter** | **Requirement** | **Data Type** | **Sample Value** |
| :-: | :-: | :-: | :-: |
| Config ID | NA (created by system) | Integer | 12 |
| Warehouse ID | Mandatory | Integer | 37 |
| JIT Cutoff | Mandatory | Timestamp | 22:00 |
| JIT Lead Time (Hours) | Mandatory | Integer | 14 |
| Applicable SKU ID List | Optional | List | [1234, 5678, 9012] |
| Order Delivery Type | Optional | String | SDD, Non-SDD |

- If a SKU ID list is provided, the system must always use those cutoff configurations for that order provided the SKU is present in the order.
- If the SKUs in order do not have any SKU ID list level configurations attached in the configurations, the system must fetch the global config (config without any SKU IDs).
- **Guardrail:** If at any point in time, the system is not able to fetch the JIT Lead times or JIT Cutoffs applicable for that warehouse, or there is no cutoff configured, the system uses existing Non_SDD_Non_Inventory, and SDD_Non_Inventory as fallbacks.
- Finally the system adds warehouse packing time configuration to the time elapsed and commits the net warehouse processing hours.
- **Note:** The system must always choose the worst possible lead time based on the SKU present. For example, an order can have 2 SKUs - one with 12 hours of lead time, another with 2 hours of lead time. For this order, the lead time must always reflect the lead time as 12 hours.
- **Note:** The system can have multiple cutoffs configured with lead times against each. The system must always choose the best possible ETA considering these lead times. For example, an order with a doctor call promised at 11:30 PM, and configured cutoffs and lead times as - 12AM & 23 hours, 4AM and 12 hours. For this order, the lead time must be cal culated as 12 hours starting from 4AM since that is the shorter time. In essence, lead time ends at 4PM (the other cutoff would have lead time ending at 11PM).
- Validations on creation of above:
    - Warehouse_id must be from the list of warehouses present in warehouse_details. Everything else gets rejected.
    - Applicable SKU ID List must accept only valid product codes from the Truemeds database. Everything else gets rejected.
    - Applicable Order Delivery Type must accept only “SDD” or “Non-SDD” as values. Everything else gets rejected.
- The above must be available to ops for insertion / updation / deletion via the Bulk Upload mechanism on Admin Portal.
- For the above acts of insertion / updation / deletion, the ops team has to input the Action column with “Insert”, “Update”, or “Delete”.
- For “Insert” action, all mandatory fields must be provided. If the inserted record already exists in the system, the system will silently not execute the action.
- For “Update” action, the config id must be provided to help the system understand which configuration needs to be updated.
- On an “Update” action, the system must not overwrite records. The system will treat this update as a soft delete and insert action.
- For “Delete” action, the system simply marks the configuration as Active = false.

#### Use Case 2.3: Warehouse Weekoff Schedule

- Warehouse also manages a JIT Holiday / Warehouse Weekoff Schedule.
- This is available through the existing functionality itself and weekoff continues to operate in the same manner it does today.
- Weekoff is applied only if the lead time end falls on a weekoff day. Assume that week off is on Sunday, and doctor confirmation is at 11AM with cutoff at 12PM and lead time of 20 hours. Ideally, the lead time would end at 8AM on Sunday. However, since Sunday is a week off, this gets pushed to Monday 8AM.

### Use Case 3: Updating Promise Instrumentation

- Promise Instrumentation gets updated with the following details.
- Updates are made to the following section: Delivery_Date_Tracker -> Metadata -> Instrumentation Details -> Warehouse Attributes.
- In the above section, the following JSON is added for non-inventory cases:

```
{

{config_id:....., Cutoff: …., Lead Time: ….., selected: TRUE, applicable SKUs: {....}},

{config_id:....., Cutoff: …., Lead Time: ….., selected: FALSE, applicable SKUs: {....}},

{config_id:....., Cutoff: …., Lead Time: ….., selected: FALSE, applicable SKUs: {....}},

{config_id:....., Cutoff: …., Lead Time: ….., selected: FALSE, applicable SKUs: {....}}

}
```

- The above should also support the updates when append_only_delivery_date_tracker is used.
- For all orders, inventory or non-inventory, the following should be present in Delivery_Date_Tracker -> Metadata -> Instrumentation Details -> Warehouse Attributes.

```
{

WH_Processing_Time_config_id: ….., WH_Processing_Time_in_mins_used: …., WH_Processing_Time_in_mins: ….., Non_Inventory_Fallback_Config_used: TRUE/FALSE

}
```

- Definitions of above fields:
    - WH_Processing_Time_config_id: Config ID fetched from WH Processing Times table
    - WH_Processing_Time_in_mins_used: Configuration in minutes fetched from WH Processing Times table
    - WH_Processing_Time_in_mins: The final calculated value of warehouse processing time.
    - Non_Inventory_Fallback_Config_used: Boolean flag to signify whether the fallback configurations of SDD_Non_Inventory, or Non_SDD_Non_Inventory were used or not.

## Worked Examples

### Worked Examples: JIT Cutoff and Lead Time Configuration Creation

- Configure JIT Cycles via Bulk Upload. Assume the following JIT Cutoffs and Lead Times are created by Ops.

| **Cutoff** | **Lead Time** |
| :-: | :-: |
| 00:00 | 22 hours |
| 12:00 | 20 hours |

- These can be created against each warehouse for a specific SKU List and order delivery type as per requirement.

Worked Example of how Lead Times and Cutoffs can come into play. Take the following manner in which operations understand their processes today.

| **Header** | **Subheader** | **Mumbai** | **Delhi** | **Kolkata** | **Bangalore** | **Lucknow** |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| JIT Cycle 1 | BO Download Time | 12:00 AM | 12:00 AM | 12:00 AM | 6:00 AM | 7:00 AM |
| JIT Cycle 1 | Inward Completion Time | 2:30 PM | 3:00 PM | 5:00 PM | 2:00 PM | 6:00 PM |
| JIT Cycle 2 | BO Download Time | 2:00 PM | 2:00 PM | 2:00 PM | 2:30 PM | 2:00 PM |
| JIT Cycle 2 | Inward Completion Time | 7:30 PM | 8:00 PM | 9:00 PM | 8:00 PM | 10:00 PM |

From the above, let’s construct the cutoffs and lead time for the Mumbai warehouse with the assumption that each order must go through 2 JIT Cycles.

- Cutoff 1 = 00:00 (12AM BO Download Time), Lead Time = 19.5 hours (12:00AM -> 7:30PM same day)
- Cutoff 2 = 14:00 (2:00PM BO Download Time), Lead Time = 24.5 hours (2:00PM -> 2:30PM next day)

### Worked Examples: Inventory Order

| **Parameter** | **Value** |
| :-: | :-: |
| Warehouse Work Start | 10:00 |
| Warehouse Work End | 19:00 |
| SDD_Inventory (in mins) | 60 |
| Non_SDD_Inventory (in mins) | 55 |

| **Scenario** | **Warehouse Processing Completion Time** |
| :-: | :-: |
| Dr. Call Complete = 7:00, SDD | 11:00 |
| Dr. Call Complete = 13:00, SDD | 14:00 |
| Dr. Call Complete = 14:00, Non-SDD | 14:55 |

### Worked Examples: Non-Inventory Order (Without Weekoff Nuance)

| **Parameter** | **Value** |
| :-: | :-: |
| Warehouse Work Start | 10:00 |
| Warehouse Work End | 19:00 |
| SDD_Inventory (in mins) | 60 |
| Non_SDD_Inventory (in mins) | 55 |
| Cutoffs & Lead Times | C1 = 12AM, L1 = 19.5 hours<br>C2 = 2PM, L2 = 24.5 hours |

| **Scenario** | **Warehouse Processing Completion Time** | **Calculation Explanation** |
| :-: | :-: | :-: |
| Dr. Call Complete = 7:00, SDD | 3:30 PM (next day) | If C1 is selected => Lead Time ends at 19:30 next day<br>If C2 is selected => Lead Time ends at 14:30 next day.<br>Hence, C2 gets selected. + 60 mins of Packing time. |
| Dr. Call Complete = 11:30, SDD | 3:30 PM next day) | If C1 is selected => Lead Time ends at 19:30 next day<br>If C2 is selected => Lead Time ends at 14:30 next day.<br>Hence, C2 gets selected. + 60 mins of Packing time. |
| Dr. Call Complete = 15:00, SDD | 7:30 PM, Next Day | If C1 is selected => Lead time ends at 19:30 next day.<br>If C2 is selected => Lead time ends at 14:30 day after next day.<br>Hence C1 gets selected + 60 minutes of packing time. |
| Dr. Call Complete = 22:30, SDD | 7:30 PM, Next Day | If C1 is selected => Lead time ends at 19:30 next day.<br>If C2 is selected => Lead time ends at 14:30 day after next day.<br>Hence C1 gets selected + 60 minutes of packing time. |

### Worked Examples: Non-Inventory Order (With Weekoff Nuance)

| **Parameter** | **Value** |
| :-: | :-: |
| Warehouse Work Start | 10:00 |
| Warehouse Work End | 19:00 |
| SDD_Inventory (in mins) | 60 |
| Non_SDD_Inventory (in mins) | 55 |
| Cutoffs & Lead Times | C1 = 12AM, L1 = 19.5 hours<br>C2 = 2PM, L2 = 24.5 hours |
| Week off Day | Sunday |

| **Scenario** | **Warehouse Processing Completion Time** | **Calculation Explanation** |
| :-: | :-: | :-: |
| Dr. Call Complete = 7:00, SDD, Saturday | 3:30 PM, Monday | If C1 is selected => Lead Time ends at 19:30 Sunday.<br>If C2 is selected => Lead Time ends at 14:30 Sunday.<br>Hence, C2 gets selected. + 60 mins of Packing time.<br>However, 24 hours have been added since C2 ends on Sunday, which is a week off. |
| Dr. Call Complete = 15:00, SDD, Saturday | 7:30 PM, Monday | If C1 is selected => Lead time ends at 19:30 next day.<br>If C2 is selected => Lead time ends at 14:30 day after next day.<br>Hence C1 gets selected + 60 minutes of packing time.<br>However, 24 hours have been added since C1 ends on Sunday, which is a week off. |
| Dr. Call Complete = 7:00, SDD, Sunday | 3:30 PM, Monday | If C1 is selected => Lead Time ends at 19:30 Sunday.<br>If C2 is selected => Lead Time ends at 14:30 Sunday.<br>Hence, C2 gets selected. + 60 mins of Packing time.<br>24 hours are not added since C2 end time is on Monday. |
| Dr. Call Complete = 15:00, SDD, Sunday | 7:30 PM, Monday | If C1 is selected => Lead time ends at 19:30 next day.<br>If C2 is selected => Lead time ends at 14:30 day after next day.<br>Hence C1 gets selected + 60 minutes of packing time.<br>24 hours are not added since C1 end time is on Monday. |

## Metrics

| **Metric Type** | **Metric** | **Definition** |
| :-: | :-: | :-: |
| Success [L0] | Average Promise | Average promise shown to the customer. |
| Success [L1] | Average Warehouse Promise | Promise committed to the customer as part of the warehouse leg. |
| Guardrails | Warehouse Processing Adherence % | % of orders where the warehouse finishes processing within promised time. |
| Guardrails | Fill Rate % | % of non-inventory orders where inventory was received within expected JIT cycle |
| Guardrails | Promise Computation Correctness | % of orders where the system correctly calculates the warehouse processing promise |
| Guardrails | Config Fallback % | % of orders where the existing config of Non_Inventory was used as a fallback. |

## Rollout & Stage Gates

# v2

# [PRD] Warehouse Processing Time Revamp v2

---

## RACI

| **RACI** | **SPOC** |
| :-: | :-: |
| Accountable | Tejas Bhalerao<br>Kartik Mittal |
| Responsible | Tejas Bhalerao<br>Mohammed Fahad<br>Ashish Ranjan |
| Consulted | Anbu Dhileepan<br>Rajendran KRR<br>Atul Nanda<br>Sumit Goyal<br>Kunal Wani |
| Informed | Ajit Murkar<br>Himanshu Bhomia |

## Objective

Enhance the current mechanism of calculating Non-Inventory Procurement Time by introducing the concept of Urgent Procurement vs Non-Urgent Procurement.

## Why Now?

As part of the organisation’s overall strategy, we want to keep the ETA for the customer as steady as possible depending on the pocket that the customer orders in. This means attacking ETA as a construct in the following manner:

1. Reducing instances of Non-Inventory to keep Warehouse Processing Time consistent.
2. Reducing procurement time for Non-Inventory orders.
3. Keeping Logistics TAT consistent with the ideal expectations for that geography.

Here we will be targeting #2 -> How can we keep procurement time minimal for pincodes serviced by hyperlocal delivery partners to provide a consistent Today / Tomorrow delivery commitment to the maximum number of customers.

In the current construct, due to unpredictability of non-inventory, operations require the order to pass through 2 procurement cycles. However, with 2 procurement cycles, we will typically see a lead time of 20 hours or 25 hours on average depending on the cutoff. With this procurement strategy, we will never be able to achieve a Today / Tomorrow delivery construct for Hyperlocal non-inventory orders.

To reduce these instances, the operations team will be working on finding avenues to reduce the procurement time. Ideas currently under evaluation for feasibility:

1. Air delivery from Faridabad to the respective FC. (3x the speed, but 5x the cost)
2. Improved vendor network to minimise procurement time of SKUs.

Guestimate on impact created if successful:

|  |  |
| :-: | :-: |
| Current Average Lead Time | 21 hours |
| non-SDD Average Lead Time | 21 hours |
| Future SDD Average Lead Time | 13.2 hours |
| Future Average Lead Time | 18.6 hours |
| Impact on SDD Average ETA |   |
| Impact on Overall Average ETA |   |

Assumptions made above:

1. SDD Order Share in Non-Inventory Orders = 30% (mirrors overall SDD share)
2. non-SDD follows a uniform 2 cycle count throughout the country
3. Non-Inventory Order Share = 20%

## Use Case: Addition of Delivery Type Parameter in Procurement Speed

- In the existing construct, the system provides users with another configuration for Order Delivery Type.
- Order Delivery Type is an optional field which accepts only 2 values - SDD, Non-SDD.
- With the introduction of the above field, the final list of configurations under the control of operations looks as follows:

| **Parameter** | **Requirement** | **Data Type** | **Sample Value** |
| :-: | :-: | :-: | :-: |
| Config ID | NA (created by system) | Integer | 12 |
| Warehouse ID | Mandatory | Integer | 37 |
| JIT Cutoff | Mandatory | Timestamp | 22:00 |
| JIT Lead Time (Hours) | Mandatory | Integer | 14 |
| Applicable SKU ID List | Optional | List | [1234, 5678, 9012] |
| Order Delivery Type | Optional | String | SDD, Non-SDD |

- Refer to the below worked examples to visualise how this will play out in different scenarios.
- If at any point in time system is unable to fetch the Lead Time and Cutoff or it is not configured, the system is expected to fallback to the existing Non_Inventory configurations present.

## Worked Examples

### Worked Example 1: Global Lead Time - Inside Working Hours

Inputted configurations:

|  |  |  |  |
| :-: | :-: | :-: | :-: |
| Warehouse ID | 20 | Warehouse ID | 20 |
| Work Start | 10 AM | Work Start | 10 AM |
| Work End | 7 PM | Work End | 7 PM |
| Processing Time | 60 minutes | Processing Time | 60 minutes |
| JIT Cutoff | 12 AM | JIT Cutoff | 12 AM |
| JIT Lead Time | 14 hours | JIT Lead Time | 20 hours |
| JIT Cutoff | 2 PM | JIT Cutoff | 2 PM |
| JIT Lead Time | 6 hours | JIT Lead Time | 25 hours |
| Applicable SKU List | NULL | Applicable SKU List | NULL |
| Order Delivery Type | SDD | Order Delivery Type | Non-SDD |
| Weekoff | Sunday | Weekoff | Sunday |

Order Details:

|  |  |
| :-: | :-: |
| Day of Week | Monday |
| Doctor Confirmation Time | Sunday 11 PM |
| Order Delivery Type | SDD |
| Cutoff Selected | 12 AM |
| Procurement End Time | 2 PM |
| Promised Warehouse Processing Time | Monday 3 PM |

### Worked Example 2: Global Lead Time - Outside Working Hours

Inputted configurations:

|  |  |  |  |
| :-: | :-: | :-: | :-: |
| Warehouse ID | 20 | Warehouse ID | 20 |
| Work Start | 10 AM | Work Start | 10 AM |
| Work End | 7 PM | Work End | 7 PM |
| Processing Time | 60 minutes | Processing Time | 60 minutes |
| JIT Cutoff | 12 AM | JIT Cutoff | 12 AM |
| JIT Lead Time | 14 hours | JIT Lead Time | 20 hours |
| JIT Cutoff | 2 PM | JIT Cutoff | 2 PM |
| JIT Lead Time | 6 hours | JIT Lead Time | 25 hours |
| Applicable SKU List | NULL | Applicable SKU List | NULL |
| Order Delivery Type | SDD | Order Delivery Type | Non-SDD |
| Weekoff | Sunday | Weekoff | Sunday |

Order Details:

|  |  |
| :-: | :-: |
| Day of Week | Monday |
| Doctor Confirmation Time | Monday 1 PM |
| Order Delivery Type | SDD |
| Cutoff Selected | 2 PM |
| Procurement End Time | 8 PM |
| Promised Warehouse Processing Time | Tuesday 11 AM |

### Worked Example 3: SKU Level Lead Time

Inputted configurations:

|  |  |  |  |
| :-: | :-: | :-: | :-: |
| Warehouse ID | 20 | Warehouse ID | 20 |
| Work Start | 10 AM | Work Start | 10 AM |
| Work End | 7 PM | Work End | 7 PM |
| Processing Time | 60 minutes | Processing Time | 60 minutes |
| JIT Cutoff | 12 AM | JIT Cutoff | 12 AM |
| JIT Lead Time | 14 hours | JIT Lead Time | 20 hours |
| JIT Cutoff | 2 PM | JIT Cutoff | 2 PM |
| JIT Lead Time | 6 hours | JIT Lead Time | 25 hours |
| Applicable SKU List | 1234, 2345, 3456 | Applicable SKU List | NULL |
| Order Delivery Type | SDD | Order Delivery Type | Non-SDD |
| Weekoff | Sunday | Weekoff | Sunday |

Order Details:

|  |  |
| :-: | :-: |
| Day of Week | Monday |
| Product Codes | 1234, 4567, 7890 |
| Doctor Confirmation Time | 11PM |
| Order Delivery Type | SDD |
| Cutoff Selected | 12 AM |
| Procurement End Time | 2 PM |
| Promised Warehouse Processing Time | Tuesday 3PM |

### Worked Example 4: Multi-SKU

Inputted configurations:

|  |  |  |  |
| :-: | :-: | :-: | :-: |
| Warehouse ID | 20 | Warehouse ID | 20 |
| Work Start | 10 AM | Work Start | 10 AM |
| Work End | 7 PM | Work End | 7 PM |
| Processing Time | 60 minutes | Processing Time | 60 minutes |
| JIT Cutoff | 12 AM | JIT Cutoff | 12 AM |
| JIT Lead Time | 14 hours | JIT Lead Time | 20 hours |
| JIT Cutoff | 2 PM | JIT Cutoff | 2 PM |
| JIT Lead Time | 6 hours | JIT Lead Time | 25 hours |
| Applicable SKU List | 1234, 2345, 3456 | Applicable SKU List | 4567, 7890 |
| Order Delivery Type | SDD | Order Delivery Type | SDD |
| Weekoff | Sunday | Weekoff | Sunday |

Order Details:

|  |  |
| :-: | :-: |
| Day of Week | Monday |
| Product Codes | 1234, 4567, 7890 |
| Doctor Confirmation Time | 11PM, Sunday |
| Order Delivery Type | SDD |
| Cutoff Selected | 12 AM |
| Procurement End Time | 8 PM, Monday |
| Promised Warehouse Processing Time | 11 AM, Tuesday |

### Worked Example 5: Weekoff

Inputted configurations:

|  |  |  |  |
| :-: | :-: | :-: | :-: |
| Warehouse ID | 20 | Warehouse ID | 20 |
| Work Start | 10 AM | Work Start | 10 AM |
| Work End | 7 PM | Work End | 7 PM |
| Processing Time | 60 minutes | Processing Time | 60 minutes |
| JIT Cutoff | 12 AM | JIT Cutoff | 12 AM |
| JIT Lead Time | 14 hours | JIT Lead Time | 20 hours |
| JIT Cutoff | 2 PM | JIT Cutoff | 2 PM |
| JIT Lead Time | 6 hours | JIT Lead Time | 25 hours |
| Applicable SKU List | NULL | Applicable SKU List | NULL |
| Order Delivery Type | SDD | Order Delivery Type | Non-SDD |
| Weekoff | Sunday | Weekoff | Sunday |

Order Details:

|  |  |
| :-: | :-: |
| Day of Week | Saturday |
| Doctor Confirmation Time | 11PM |
| Order Delivery Type | SDD |
| Cutoff Selected | 12 AM |
| Procurement End Time | Monday 2 PM |
| Promised Warehouse Processing Time | Monday 3 PM |

## Metrics

| **Metric Type** | **Metric** | **Definition** |
| :-: | :-: | :-: |
| Success [L0] | Average Promise | Average promise shown to the customer. |
| Success [L1] | Average Warehouse Promise | Promise committed to the customer as part of the warehouse leg. |
| Guardrails | Warehouse Processing Adherence % | % of orders where the warehouse finishes processing within promised time. |
| Guardrails | Promise Computation Correctness | % of orders where the system correctly calculates the warehouse processing promise |
| Guardrails | Config Fallback % | % of orders where the existing config of Non_Inventory was used as a fallback. |
