---
title: Warehouse Processing Time Revamp
source: https://docs.google.com/document/d/1YGonOss1mISMWd5yvogl1G8H_nEhQeYLpJhq5PC_HKY/edit
type: past-prd
verticals: [courier-forward, hyperlocal-forward]
systems: [eta]
updated: 2026-07-10
---

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
