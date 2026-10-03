---
title: Promise Instrumentation
source: https://docs.google.com/document/d/19kbdIHmiKU6qSZZTKZLQMt7_HNBG5K-krCk7DX5Whl0/edit
type: past-prd
verticals: [hyperlocal-forward, courier-forward]
systems: [eta]
updated: 2026-04-06
---

# [PRD] Promise Instrumentation v1

## RACI

|  |  |
| :-: | :-: |
| **Accountable** | Tejas Bhalerao<br>Kartik Mittal |
| **Responsible** | Tejas Bhalerao<br>Kartik Mittal<br>Mohammed Fahad<br>Shivam Madaan<br>Siva Pilla |
| **Consulted** | Anbu Dhileepan<br>Dinesh Penta |
| **Informed** | Ajit Murkar<br>Mukeshkumar Jaiswar<br>Sumit Goyal |

## Timeline View

**Walkthrough Link:**

| **Stage** | **SPOC** | **Date** |
| :-: | :-: | :-: |
| Business Signoff | Kartik Mittal |   |
| Product Peer Signoff | Anbu Dhileepan<br>Himanshu Bhomia |   |
| Analytics | Shivam Madaan<br>Ashish Ranjan |   |
| Engineering Walkthrough | Mohammed Fahad |   |
| Engineering Scoping | Mohammed Fahad |   |
| Development Start | Mohammed Fahad |   |
| Development End | Mohammed Fahad |   |
| QA Walkthrough | Siva Pilla |   |
| QA Handover |   |   |
| Release |   |   |

## Objective

Capture the different attributes related to order, promise and actuals for every order and every stage the order passes through.

## Why Now?

Each scenario where promise changes, ends up creating significant blind spots for us whenever we try to answer the question - “What happened with this order in reality?”

Furthermore, this lack of visibility prevents us from unlocking strong use cases such as reliably updating ETA, etc.

The first step to solve before thinking about future growth initiatives is to set up a single source of truth for our data. This data will then be referenced to ensure that we build the next set of initiatives the right way.

As the first step, we will be unlocking only the forward leg of the journey.

## Guiding Principles

- For each order, we will store snapshots of attributes against each order stage.
- Attributes will be classified into 3 buckets: promise, order, actual.
- **Order Attributes:** These are attributes that are unique characteristics to the order and cannot change. For example: order_id, order_placed_time, order_created_time, etc.
- **Note:** Order Attributes since immutable, are populated irrespective of order stage.
- **Promise Attributes:** These are attributes that influence promise computation or are outputs of promise computation. For example: is_sdd, is_inventory, promised_delivery_date, etc.
- **Actual Attributes:** These are attributes that act as a mirror to the promise giving us a window of reality vs expectation. For example: actual_delivery_date, actual_wh_processing_time.
- List of attributes can be found [here](https://docs.google.com/spreadsheets/d/19UFHzSrFDpRv-i3-V7ui9yYgalpVXjyhTm0z-GpyJcY/edit?usp=sharing).

## Use Case 1: Promise Snapshots

- For each order, a snapshot of promise attributes is stored.
- These attributes are stored against each order stage where the promise calculation logic is invoked.
- If a particular order stage invokes promise calculation logic multiple times, multiple snapshots are stored against it.
- This snapshot gets stored against the following order stages:

| **Order Stage** |
| :-: |
| Cart |
| Summary |
| Order Placed |
| Order Confirmed |
| WH Assigned |
| WH Fulfilled |
| AWB Generation |

- For each snapshot, there is an identifier in place which helps us identify against which order stage is the promise being stored.

## Use Case 2: Actual Attributes

- Unlike Promise Attributes, Actual Attributes are event based. That is, these get stored every time an actual event occurs.
- Whenever an event occurs, the actuals attribute gets updated in the same record.
- **Exceptional Cases:** Number of attempts attributes do not overwrite. For instance, attributes corresponding to attempts corresponding to attempt #1 get populated when the first attempt happens. If and when the 2nd attempt happens, then the data corresponding to the same is stored as a separate entity. The same also applies to doctor attempts.

## Use Case 3: Order Attributes

- These are attributes that get stored against the order once the order is created.
- These attributes are populated against the final state of the order.
- For example, during HA call, attributes like invoice_value, order_weight, and item_count may change. Far as Logistics and promise is concerned these changes need not be stored as snapshots. We can store the final state of the order alone as is received by logistics.
