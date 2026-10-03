---
title: Multiple Cutoffs v2
source: https://docs.google.com/document/d/1FQvJZN1o9vM9XdMZlTHxffwSdFCIVmfpAQGScjqXRPU/edit
type: past-prd
verticals: [hyperlocal-forward]
systems: [eta]
updated: 2026-03-25
---

# PRD

# Multiple Cutoffs v2

## RACI

|  |  |
| :-: | :-: |
| **Accountable** | Tejas Bhalerao<br>Kartik Mittal |
| **Responsible** | Tejas Bhalerao<br>Kartik Mittal<br>Mohammed Fahad |
| **Consulted** | Anbu Dhileepan<br>Dinesh Penta |
| **Informed** | Ajit Murkar<br>Mukeshkumar Jaiswar<br>Himanshu Bhomia<br>Sumit Goyal<br>Rajendran KRR |

## Timeline Log

| **Stage** | **SPOC** | **Date** |
| :-: | :-: | :-: |
| Logistics Signoff | Kartik Mittal |   |
| Analytics Walkthrough | Shivam Madaan<br>Ashish Ranjan<br>Dinesh Penta |   |
| Engineering Walkthrough | Mohammed Fahad |   |
| Engineering Scoping | Mohammed Fahad |   |
| Development Start | Mohammed Fahad |   |
| Development End | Mohammed Fahad |   |
| QA Walkthrough |   |   |
| QA Handover |   |   |
| Release |   |   |

## Objective

As part of this document, we will be covering what we will be pursuing as part of the second milestone of Multiple Cutoffs, why we are taking the below actions, what we will be testing, and how it will inform our decisions going forward.

## Why Now?

With the first milestone of multiple cutoffs now hitting production, we will be able to generate gains in speed of delivery improvements for customers. However, this holds true only for courier orders and not hyperlocal orders.

As part of this milestone, we want to extend the same capabilities to hyperlocal orders as well. This capability, once present in hyperlocal, will enable operations to have multiple different pickup waves present in the warehouse. These pickup waves can be tuned going forward to ensure streamlined dispatch strategies from the warehouse.

Additionally, this will also serve as an input to the warehouse team for packing completion to sync with planned dispatch.

Overall, having multiple cutoffs for hyperlocal does not necessarily enable faster speed for customers, but enables internal teams to optimise their processes to run smoother operations. The reason for a lack of speed improvement is simple - the warehouse team currently packs all hyperlocal orders with the highest sense of urgency and that too within 30 minutes even if planned dispatch may be happening 4 hours later. With internal teams now working backward from the dispatch cutoff, this same rigor will be lost and speed will reduce.

## Use Case: Adding New Cutoffs

- User logs in to the Admin Portal and navigates to the Upload Pincode section in Warehouse Management module.
- In this section, the user selects the SDD Courier Partner Cutoff module.
- User downloads the sample CSV, adds the configurations in CSV and uploads it back to the platform.
- System functionality in processing this file continues to remain the same as it is today.
- Once the uploaded file is processed, the cutoffs start getting applied to orders.

## Use Case: System Validations on New Cutoff Addition

- User uploading the new cutoff must compulsorily provide the following fields:
    - Warehouse_id
    - Courier_partner_id
    - Pincode
    - Cutoff_time_in_hh_mm
    - Action (insert / update / delete)
- For the above combination of data, if an entry already exists against an action of insert, the system will perform an update action instead. In this case, the system retains the active status of the entry as it was earlier present.
- For the above combination of data, if an entry to be deleted does not exist in active state or does not exist at all, the delete action is ignored by the system. In cases where the entry exists, the system will instead change the active status from 0 to 1.
- For the above combination of data, if an entry does not exist against an action of update, the system considers this as an insert action and inserts the new record.

## Flow of Events for Promise Construction

- The customer lands on the PDP and a promise is shown to the customer.
- This promise is constructed using the following:
    - Promised Doctor Call TIme is fetched upstream from the doctor service.
    - Promised Warehouse Processing Time is fetched upstream from the warehouse service.
    - Promised Dispatch Date is set according to the chosen cutoff for that order’s warehouse, pincode, and courier partner.
    - Promised Delivery Date is set according to the logistics TAT added to the Promised Dispatch Date.
- To choose the cutoff, the system refers to the promised warehouse processing time. Based on the promised warehouse processing time, the system chooses the nearest cutoff for the warehouse, pincode and delivery partner combination.
- Once the cutoff is chosen, this cutoff gets applied to the promise as the promised dispatch date.

## Rollout Plan

Detailed Rollout Plan can be found [here](#rollout-plan-2).

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

# Rollout Plan

# **Rollout Plan**
