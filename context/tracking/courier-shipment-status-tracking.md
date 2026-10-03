---
title: Courier Shipment Status Tracking
source: https://docs.google.com/document/d/1ubztUOoAqEB1u6fHuZSTk8hGwaXN9qgMz4tLbdXc1Dg/edit
type: past-prd
verticals: [courier-forward, courier-reverse, hyperlocal-forward, hyperlocal-reverse]
systems: [tracking]
updated: 2026-04-06
---

# [PRD] Courier Shipment Status Tracking & Alerting

## RACI

|  |  |
| :-: | :-: |
| **Accountable** | Tejas Bhalerao<br>Kartik Mittal |
| **Responsible** | Tejas Bhalerao<br>Kartik Mittal<br>Mohammed Fahad<br>Ashish Ranjan<br>Siva Pilla |
| **Consulted** | Anbu Dhileepan<br>Dinesh Penta<br>Kishor Kumar |
| **Informed** | Ajit Murkar<br>Mukeshkumar Jaiswar<br>Sumit Goyal |

## Timeline View

**Walkthrough Link:**

| **Stage** | **SPOC** | **Date** |
| :-: | :-: | :-: |
| Business Signoff | Kartik Mittal |   |
| Product Peer Signoff | Anbu Dhileepan |   |
| Analytics Walkthrough | Ashish Ranjan |   |
| Engineering Walkthrough | Mohammed Fahad |   |
| QA Walkthrough | Siva Pilla |   |

## Objective

Enable real-time courier shipment tracking visibility across systems with a mechanism to take actions operationally on at-risk promises.

## Why Now?

Today, our instrumentation present relies on 2 simple data points after handover to the courier, i.e., dispatched and out for delivery. In between these two states, we capture only 1 state, i.e., in-transit. Truemeds as an organisation is completely blind as to what is happening to this order while it is in-transit.

In reality, couriers are transporting this order from origin hub to middle hubs and then finally to destination hubs. It is from these destination hubs that the “out for delivery” state is achieved. To understand this better, refer to the below screenshot of a sample order (Order ID: 44338694) from Clickpost.

Every courier partner provides us with this detailed information of order status at a given point in time. However, we are currently under-utilising this information already present with us from Clickpost.

If utilised, this information can unblock several different use cases for us.

| **Stakeholder** | **Decision Enabled** |
| :-: | :-: |
| Logistics Ops | Identify hub-level delays |
| Courier Management | Negotiate SLA breaches |
| Product + Analytics | Build ETA prediction models (for ETA revisions) |

## Use Case 1: Capturing In-transit Shipment Status for New Orders

- An order is created in Clickpost for a specific courier partner.
- Operations continue and on-ground actors continue to take actions such as pickup, delivery, etc.
- Every time an action is performed, shipment status gets updated on Clickpost. This shipment status comes with multiple other metadata. Metadata captured is the following:
    - Shipment Status
    - Date & Time (of shipment status update)
    - Location (of where shipment status was recorded)
    - Remark added
- After this updated status is received in Clickpost, it gets stored in the backend.
- To view samples of how Clickpost shares order status information with us, please refer [here](#appendix-samples-of-courier-shipment-tracking-status-from-clickpost).
- Clickpost shares this status with us via Fetch Tracking Details. The source for this is shared [here](https://docs.clickpost.ai/docs/shipment-tracking). These status are also currently visible on Pharmacist Portal under the Track Order section.

## Use Case 2: Capturing In-transit Shipment Status for Old Orders

- For the orders created since October 2025, we will use the Fetch Tracking Details as listed above.
- For all these orders, the system stores these statuses as present on Clickpost.
- To view samples of how Clickpost shares order status information with us, please refer [here](#appendix-samples-of-courier-shipment-tracking-status-from-clickpost).
- Clickpost shares this status with us via Fetch Tracking Details. The source for this is shared [here](https://docs.clickpost.ai/docs/shipment-tracking).

## Use Case 3: Analytics Alerts

**Proactive Identification of Potential Delays (Post Dispatch)**

- For every lane, analytics identifies and defines the “ideal time” an order should take at each individual leg of delivery (origin hub, in-transit, destination hub, out for delivery, etc.) based on the courier allocated.
- Wherever, this “ideal time” is breached ~~and promise commitment to customers is at risk~~, it should be highlighted to Central Logistics as an alert.
- Each such breach should be communicated in the perspective of risk profiles - “ultra high risk”, “high risk”, “low risk”, “medium risk”.
- While defining risk profiles, analytics should also account for the probability that a particular leg’s delay may be absorbed by subsequent legs.
- Against each defined risk profile, analytics should record a confidence score as well as a remark for the confidence and risk profile.
- Analytics continuously iterates to improve the accuracy of risk profile by ensuring a feedback loop from actual on-ground realities.
- Against each order, analytics also shares action required - immediate attention required, monitor closely, monitor, no action required.
- Against each order, analytics also shares action required based on yesterday’s order state.

**Identifying Courier’s Network Allocation Errors**

- For every lane, analytics identifies orders that did not follow the typical network path of the courier or required network reallocation by the couriers.
- Each such order gets highlighted to Central Logistics for immediate action if this is going to contribute to the risk profile of the order.
- To start with, orders that entered “Re-way” status can be used as a benchmark for these errors.
- However, over time analytics should refine the methodology of identifying these orders.

**Identifying Missing States**

- Analytics identifies orders where key statuses are missing. These can be missing in origin hub, destination hub, etc.
- Over time, product and business will be having conversations with Clickpost and courier partners to reduce the instances of these cases.

**Note:** Each alert captured above is sent out as an email script to stakeholders on a daily basis at a fixed time.

**Identifying Last Mile Hub In-Scan Orders for OFD**

- Orders that have reached Last Mile Hub do not reach Out for Delivery State.
- Over time, Ops team will keep escalating to courier partners to resolve such dispatch delays from Last Mile Hub.

## Use Case 4: Ops Usage of Analytics Alerts

**Proactive Identification of Potential Delays (Post Dispatch)**

- Analytics shares the risk profile and action required for each order depending on its current state.
- Ops is expected to work on all orders that are ultra high risk, high risk, and need immediate attention.
- Ops is expected to maintain a tracker of orders that were classified as “monitor closely” and “monitor” and how their status is changing over time.
- For each of the above orders, ops will get in touch with courier partners at a defined time frame and actively work on resolving these orders.

## Metrics

| **Metric Type** | **Metric** | **Definition** |
| :-: | :-: | :-: |
| Success (L1) | Logistics Adherence % | % of orders with 1st attempt on time |
| Success (L2) | High Risk → Low Risk Resolution Rate | % of orders moving from High risk to Low to No Risk |
| Success (L2) | Risk Intervention TAT | TAT for orders to move from High Risk to Low to No Risk |
| Success (L2) | Operational Efficiency | Contribution Trend of High Risk orders |
| Guardrail | Alert Precision | % Orders flagged high risk that later breached promise |
| Guardrail | Alert Coverage of Delays | % of delayed orders that were flagged as high risk before breach. |
| Guardrail | False Positive Rate | % of orders flagged High Risk that eventually delivered well within promise without intervention. |
| Guardrail | Alert Volume Per Day | Total Number of Alerts Generated Daily |

## Rollout Plan

| **Stage** | **Description** | **Hold / Scale / Kill Criteria** |
| :-: | :-: | :-: |
| Data Sanity | Verifying whether the right set of data flows in for past orders. | Hold => If order states present on Clickpost are missing.<br>Scale => If all order states are present for orders as per Clickpost. |
| Data Sanity 2 | Verifying whether the data flows in for order status updates on time. Start with 10 orders. | Hold => If order states present on Clickpost are missing.<br>Scale => If all order states are present for orders as per Clickpost. |
| Full Rollout | Start capturing order states for every order as shared by Clickpost. | - |

## Appendix: Samples of Courier Shipment Tracking Status from Clickpost

**Order ID:** 44432450 | **Courier Partner:** Bluedart Surface

## Open Points

- Delivery related issues are 31%. Under complaint bucket (50%), Before SLA = 15%, After SLA = 5%.
- Which portal does the CSR team use currently when talking to customers?
    - Pharmacist Portal to talk to customers.
    - Kapture to raise it to internal teams across WH and Logistics.
- Where do they navigate on the portal to get to these cases?
    - Go to Post Orders
    - Search by order id, name, phone number, or email id.
- Which are the touchpoints we need to address?
    - CSR Feature Module in Pharmacist Portal.
- How do they know which order the customer has raised a query for?
    - To be checked
- What kind of delivery related questions do CSR agents: tackle today, what is their quantum, and verbatim for the same? Focus majorly on the problems raised here.
    - Will require a detailed conversation here.
- What is the resolution path that agents provide in these cases?
    - Will require a detailed conversation here.
- What are the different order statuses currently visible to CSR agents?
    - In exact detail as present on Clickpost.
- Where do you see the above solution fitting in? Is this solution currently accessible to CSR agents? Do we see this solution creating some value on resolution - FCR, AHT, Tickets per order, etc.?
    - No. All these statuses are already visible to CSR agents. The problem is not in communication with customers but with the resolution they are able to provide with this information. Problems need to be resolved upstream.
    - Need to talk in detail with Kishor on detailed problems.
