---
title: Reverse Leg Revamp
source: https://docs.google.com/document/d/10hVeJEH197EXzDKeNdGughSMZSXyh1hhVuImXFFYm7o/edit
type: past-prd
verticals: [courier-reverse, hyperlocal-reverse]
systems: [serviceability, allocation]
updated: 2026-04-06
---

# Milestone View

## Objective

As part of this document, we will be establishing different milestones to enable the reverse leg of logistics in a more effective manner than it is operating today.

The scope of this document will be restricted to enabling additional capabilities to support efficient reverse logistics.

**Note:** Timeline View and Signoffs are being captured as part of individual PRDs below.

## Scope

Out of scope items are listed below:

- Customer journey improvements to enable seamless return experience.
- Improving customer experience loop via communications when returns & refunds are successfully processed.
- Reverse leg journey improvements for RTO.

The above can be taken up as fast follower milestones basis priority.

## Why Now?

Current Ways of Working for Return Journeys:

- Customers have the option to raise a return request (partial or full) via the app or CSR.
- Once a return request has been raised, Delhivery is selected as the default courier for all cases.
- Other accounts, even though configured (Shadowfax and Xpressbees), are not operational.
- The current setup also forces us to use only 3PLs for return requests.
- Moreover, by default, each return request goes back to the origin warehouse which serviced the order.

Manifestation of Problems with the current state:

- Delhivery does not service all pincodes within the geographical boundaries of Truemeds. As a result, Rs. 1.08 Lakh worth of refunds are processed without collecting inventory from customers monthly. This was across 150 different shipments.
- Couriers have notoriously high TATs. Currently it takes about 8 days for the order to return to the warehouse. If we had Shipsy as a partner, we would have been able to process the entire return in only 2 days.
- Moreover, we always need to move the order to the warehouse which originally serviced the order even if there is a warehouse much closer. This ends up inflating the cost to serve a return order.

Larger systemic problems:

- No data for reverse shipments is stored except for order_id. The entire operation is running blind.
- The entire organisation of Truemeds runs on a single list of priorities for couriers irrespective of customer or warehouse location context.
- Shipsy Reverse even though activated previously operates at a sub-optimal level. Even if Shipsy cannot possibly service the order in the forward journey, we still allocate Shipsy for the reverse journey. (Imagine cases such as Ahmedabad pincode -> Mumbai FC).

Detailed note here - [BRD](https://docs.google.com/document/d/1KMpYSmyGstaX2iCAFGfTEl7OJNMl0z_mfzGrT3UD37c/edit?usp=sharing)

## Milestones

| **Milestone** | **Description** | **Outcome** |
| :-: | :-: | :-: |
| Milestone 1 | Ability to consider more than 1 delivery partner for reverse pickup allocation. | Truemeds will have the capability to choose from multiple delivery partners for reverse leg. |
| Milestone 2 | Enabling reverse accounts for other courier partners. | Truemeds will have an option to choose courier partners for reverse pickup apart from Delhivery. |
| Milestone 3 | Enabling Shipsy Reverse as an eligible reverse delivery partner. | Truemeds will have the capability to run not just forward journeys with Shipsy but also reverse journeys. |
| Milestone 4 | Enabling return processing at the nearest warehouse. | Truemeds will have the capability to return orders to other warehouses apart from the origin warehouse. |

## Milestone 1: Priority Based Selection of Reverse Partners

## Milestone 2: Enabling Reverse Accounts for Courier Partners

## Milestone 3: Enabling Shipsy Reverse

## Milestone 4: Reverse Destination to Nearest Warehouse

## Overall Reverse Process Workflow

# Draft

## Redirection to Individual PRDs

[Milestone 1: Priority Based Selection of Reverse Partners](https://docs.google.com/document/d/16X0NGrzhscQq4S2e1XMcwR7GGdVH6T1dnZpTc-BtXuQ/edit?usp=sharing)

[Milestone 2: Enabling Reverse Accounts for Courier Partners](https://docs.google.com/document/d/1Lb6-bKIVXD624UHnLjs8j7mz87xZ2kIaON4FhR8e0Yo/edit?usp=sharing)

[Milestone 3: Enabling Shipsy Reverse](https://docs.google.com/document/d/1XVDe2gnPB_dyl_xlKeNkwBoD5ooxcpjYEmoM2mIfNsg/edit?usp=sharing)

\[WIP\] [Milestone 4: Reverse Destination to Nearest Warehouse](https://docs.google.com/document/d/1rBAI_BRO-XCjBy8GZUwI9rpqRNpMMielMNilIUUghEI/edit?usp=sharing)

# Milestone 1

# Milestone 1: Priority Based Selection of Reverse Partners

## RACI

| **Accountable** | Tejas Bhalerao<br>Kartik Mittal |
| :-: | :-: |
| **Responsible** | Tejas Bhalerao<br>Kartik Mittal<br>Mohammed Fahad<br>Shivam Madaan \<QA\> |
| **Consulted** | Anbu Dhileepan<br>Dinesh Penta |
| **Informed** | Ajit Murkar<br>Mukeshkumar Jaiswar<br>Sumit Goyal |

## Timeline Log

| **Stage** | **SPOC** | **Date** |
| :-: | :-: | :-: |
| Logistics Signoff | Kartik Mittal |   |
| Analytics | Shivam Madaan<br>Ashish Ranjan<br>Dinesh Penta |   |
| Engineering Walkthrough | Mohammed Fahad |   |
| Engineering Scoping | Mohammed Fahad |   |
| Development Start | Mohammed Fahad |   |
| Development End | Mohammed Fahad |   |
| QA Walkthrough |   |   |
| QA Handover |   |   |
| Release |   |   |

## Use Cases

### Use Case 1: Priority Based Selection

- Customer reaches out to the CSR team or initiates a return for the delivered order via the app.
- For the selected order, system fetches the origin warehouse and drop pincode of the customer.
- Based on the drop pincode, the system refers to an internal priority mapping of delivery partners eligible for reverse pickup.
- This internal priority mapping is maintained at a pincode level.
- Depending on the serviceability of the pincode and warehouse by the priority of delivery partners, the highest priority delivery partner is selected for pickup from the customer’s location.
- For example, if Delhivery is priority 1 but does not service the customer’s pincode, then the system will fallback to the 2nd priority, which is, Xpressbees.
- **Note:** Deciding priority for delivery partners at a pincode level will be the responsibility of the business team.
- **Note:** Current Fallback Logic of moving to secondary / tertiary priorities for reverse pickups will be designed only on the basis of serviceability. Based on the focus that we want to dedicate to return journeys in the future, we will evaluate whether we want to build a TAT Adherence Logic / PBA similar to forward journeys. Till then, courier allocation logic will have to be handled operationally based on priority set.
- ~~For courier partners, it will be assumed that the serviceability for reverse is the same as that of forward.~~ Serviceability is defined separately at an account level for each courier partner.

Use Case 2: Priority Delivery Partner is non-serviceable

- If a priority courier partner is non-serviceable, the system should automatically fallback to the next priority courier partner.
- If after serviceability checks for courier partners, we are unable to come up with any courier partners eligible for pickup from customer’s pincode or drop to warehouse, the order will not be picked up and full refund to the customer will be processed. Subsequently, the order status should also reflect as Reverse Cancelled NSZ.
- This is the existing flow which will continue as is for the time being.

Use Case 3: AWB Print for Reverse Courier Leg

- Once delivery partner is selected, then the system generates a new order_id and Clickpost generates an AWB number for arranging pickup.
- **Note:** AWB will be created considering that the pickup will be from the customer’s delivered location and drop will at the origin warehouse from where the order was originally serviced.
- For example, if an order was serviced from Mumbai FC -> Pune pincode, and a return request was raised, the return journey will be traced from Pune pincode -> Mumbai FC.
- **Note:** AWB Printing will be the responsibility of the respective courier partners.
- Once AWB is printed, then the courier partner will pick the order from the customer and return it to the warehouse.
- The warehouse team will be responsible for performing the QC and initiating a full (or) partial refund to the customer. Expectation will be to continue adherence to the same process as of today.

### Use Case 4: System Exception Handling

| **Scenario** | **System Action** | **Ops Action** |
| :-: | :-: | :-: |
| All partners non-serviceable | Show NSZ | Manual intervention |
| API timeout | Retry 2x → Fail. Try the next priority courier partner. | None |

### Use Case 5: Operational Handling on No Courier Partner Available

- Operations team checks Reverse cases in the following buckets - Pickup pending for too long, Clickpost showing NSZ status.
- Orders of above buckets are filtered and acted upon by the CSR team.
- Given the current low volumes of such return requests, the expectation is that the current operational process will hold.

## Rollout Plan

### Product Rollout

- No staged rollouts.
- Control Rollout Operationally.

### Operational Rollout Strategy

| **Rollout Stage** | **Rollout %** | **Rationale** | **Time Frame** |
| :-: | :-: | :-: | :-: |
| Production Sanity | For 1 WH introduce Priority 2 courier partner. | Check for system stability and whether the system is able to pick priority 2 partners without breaking any downstream flows. | 7 days |
| Full Scale Rollout | Introduce a full-fledged list of priority courier partners integrated with Clickpost. | Full scale rollout for operations. | - |

## Metrics

| **Metric Tye** | **Metric** |
| :-: | :-: |
| Success | % of return orders being processed at courier partner level. |
| Success | % of return orders where the system was successfully able to fallback to priority 2 or beyond. |
| Guardrail | % of orders where the system fails to fallback to priority 2 or beyond. |
| Guardrail | % of orders where AWB generation fails. |
| Guardrail | % of orders where no courier partner is selected. |

## Analysis Strategy

| **Theme** | **Question to Answer** |
| :-: | :-: |
| Return Request Processing | Do our changes interrupt the flow of customers raising return requests? |
| Courier Partner Selection | Are we able to successfully select courier partners beyond the first priority? |
| Courier Partner Selection | Does the distribution of courier partners selected change? |
| AWB Generation | Are we able to successfully generate new order ids for selected return journeys? |
| AWB Generation | Are we able to successfully generate the AWB for selected courier partner? |
| AWB Generation | Are generated AWBs reflecting the right details as per customer’s raised request? |
| AWB Generation | Are we able to successfully retry AWB generation if failed? |
| Reverse Pickup | Are we able to successfully pickup the return order using the selected courier partner? |
| Reverse Drop | Are successfully picked up orders successfully returned to the warehouse? |
| Reverse Inwarding | Are we able to successfully continue processing the return order QC? |
| Refund Processing | Are we able to successfully process returns for the customers based on QC results? |
| NSZ Reverse Request | Are we able to successfully process refunds and returns when we are not able to find serviceable courier partners? |

## Instrumentation Needed

\<ARD to be added\>

Analytics should be able to track:

- When the request for a return was raised.
- Medium through which request for return was raised - app / CSR / etc.
- Order for which return was raised and its subsequent details such as source, destination, invoice value, etc. along with customer and courier details of forward leg.
- Whether return was raised for partial (or) full order.
- Items in order for which return was raised.
- Order ID and AWB number of the return request. This should be identifiable with the original Order ID and AWB number.
- When AWB was generated.
- Selected courier partner and its ranking in priority.
- Where no courier partner was selected due to non-serviceability.
- When the courier partner was scheduled to pick up the order from the customer.
- When the courier partner picked up the order from the customer.
- TAT which the courier takes to operate in forward journey of the same lane.
- TAT which the courier takes to operate in the reverse journey of the lane.
- Actual TAT taken by courier partner to return order to warehouse.
- Time when QC for returned order was completed.
- QC status at an SKU level - discarded, racked, etc.
- Time when refund was initiated to the customer.
- Amount of refund.
- Whether the refund initiated was complete or partial or null.
- Reverse account ID used.
- API success/failure rate per courier at the time of AWB generation.
- AWB generation latency.
- Allocation skip reason (non-serviceable vs account error vs API failure).
- Courier-level pickup success rate.

# Milestone 2

# Milestone 2: Enabling Reverse Accounts for Courier Partners

## RACI

| **Accountable** | Tejas Bhalerao<br>Kartik Mittal |
| :-: | :-: |
| **Responsible** | Tejas Bhalerao<br>Kartik Mittal<br>Mohammed Fahad<br>Shivam Madaan \<QA\> |
| **Consulted** | Anbu Dhileepan<br>Dinesh Penta |
| **Informed** | Ajit Murkar<br>Mukeshkumar Jaiswar<br>Sumit Goyal |

## Timeline Log

| **Stage** | **SPOC** | **Date** |
| :-: | :-: | :-: |
| Logistics Signoff | Kartik Mittal |   |
| Analytics | Shivam Madaan<br>Ashish Ranjan<br>Dinesh Penta |   |
| Engineering Walkthrough | Mohammed Fahad |   |
| Engineering Scoping | Mohammed Fahad |   |
| Development Start | Mohammed Fahad |   |
| Development End | Mohammed Fahad |   |
| QA Walkthrough |   |   |
| QA Handover |   |   |
| Release |   |   |

## Use Cases

### Use Case 1: Reverse Account Activation via Clickpost

For each courier partner (Xpressbees, Bluedart, Shadowfax, etc.):

- Reverse account credentials must be configured in Clickpost.
- Reverse service must be explicitly enabled (separate from forward account).
- Account-level restrictions if any, must be configured.
- Reverse-specific API endpoints must be validated.
- **Note:** Ownership on the Business team to get this enabled.

### Use Case 2: Eligibility to Participate in Priority Engine

A courier partner will only be considered eligible in Milestone 1 allocation if:

- The reverse account is active in Clickpost.
- Serviceability API returns success for:
    - Pickup pincode
    - Delivery-to-origin warehouse
- AWB generation API is functional.
- The account is marked “Reverse Enabled” in the internal config.

If any of the above fail, the partner is excluded from allocation for that request.

### Use Case 3: Reverse AWB & Label Handling

For each integrated courier:

- Reverse AWB must be generated via Clickpost.
- AWB number must be stored against reverse order_id.
- AWB must be traceable to original forward order.
- If AWB generation fails:
    - Retry up to 2 times.
    - On failure, fallback to the next priority partner (Milestone 1 logic).

**Note:** AWB printing remains the responsibility of the courier partner (as defined in Milestone 1).

### Use Case 4: Status Synchronisation

For all enabled reverse accounts:

System must store:

- Pickup scheduled
- Pickup attempted but failed
- Picked up
- In transit
- Delivered
- Cancelled

If status webhook fails:

- The system must retry ingestion.
- Alert engineering only if failure persists beyond threshold.

### Use Case 5: Failure Isolation

Failure in reverse account of one courier partner must not:

- Impact allocation to other partners.
- Block reverse flow for serviceable partners.
- Trigger NSZ prematurely.
- Prevent return processing for the customer.

**Example:** If Xpressbees account is misconfigured, the system should automatically skip it and move to the next priority partner.

## Rollout Plan

| **Stage** | **Ownership** |
| :-: | :-: |
| Sourcing Credentials for Activating Reverse Accounts on Clickpost | Business |
| Creating Courier Partner Accounts in Truemeds System | Product + Engineering |
| Setting Priorities for Courier Partner Accounts for Order Allocation | Business |
| Enabling Order Allocation Flow for Reverse Accounts in Production | Product + Engineering |

| **Stage** | **Description** | **Hold / Scale / Kill Criteria** |
| :-: | :-: | :-: |
| Pilot for 1 courier partner |   |   |
|   |   |   |
|   |   |   |

## Metrics

| **Metric Type** | **Metric** |
| :-: | :-: |
| **Success** | % of reverse requests where newly enabled courier partners are successfully allocated. |
| **Success** | % of reverse requests where AWB is successfully generated for newly enabled courier partners. |
| **Success** | % of reverse requests where status synchronisation is successfully received for newly enabled courier partners. |
| **Success** | % of reverse requests where fallback due to reverse account failure is successfully recovered via the next priority partner. |
| **Guardrail** | % of reverse requests where allocation fails due to reverse account misconfiguration. |
| **Guardrail** | % of reverse requests where AWB generation fails for newly enabled courier partners. |
| **Guardrail** | % of reverse requests where duplicate AWBs are generated for the same reverse order. |
| **Guardrail** | % of reverse requests incorrectly marked NSZ due to reverse account errors (not true non-serviceability). |
| **Guardrail** | % of reverse requests where status updates are not received within defined SLA. |

## Analysis Strategy

| **Theme** | **Question to Answer** |
| :-: | :-: |
| Reverse Account Activation | Are newly integrated courier partners successfully participating in reverse allocation? |
| Allocation Stability | Are reverse account-level failures impacting allocation success? |
| AWB Generation | Are we able to successfully generate AWBs for newly enabled courier partners? |
| AWB Integrity | Are generated AWBs correctly mapped to the original forward order? |
| Fallback Behaviour | When a reverse account fails (API error / misconfiguration), does the system correctly fallback to the next priority courier? |
| Status Synchronisation | Are reverse shipment status updates being received and stored correctly for newly enabled partners? |
| NSZ Accuracy | Are orders being marked NSZ only due to genuine non-serviceability and not reverse account-level issues? |
| Downstream Continuity | After allocation via newly enabled courier partners, does the reverse journey continue without breaking pickup → drop → QC → refund? |

## Instrumentation Needed

Analytics should be able to track:

- Reverse account ID used for each allocation.
- Whether the reverse account was active/inactive at time of allocation.
- Reverse account eligibility check result (active / disabled / API failure).
- Allocation attempt sequence (P1 attempted → failed → P2 selected).
- Allocation skip reason (non-serviceable vs account disabled vs API timeout vs AWB failure).
- AWB generation attempt count per reverse request.
- AWB generation latency per courier partner.
- API response code received from Clickpost per attempt.
- Whether AWB generation required retry.
- Whether fallback occurred due to AWB failure.
- Reverse order_id to forward order_id mapping validation flag.
- Timestamp of status webhook received from courier partner.
- Missing status detection (no update beyond X hours).
- Orders marked NSZ with reason classification (true NSZ vs system-induced NSZ).
- Duplicate AWB detection flag for reverse order.

# Milestone 3

# Milestone 3: Enabling Shipsy Reverse

## RACI

| **Accountable** | Tejas Bhalerao<br>Kartik Mittal |
| :-: | :-: |
| **Responsible** | Tejas Bhalerao<br>Kartik Mittal<br>Mohammed Fahad<br>Shivam Madaan \<QA\> |
| **Consulted** | Anbu Dhileepan<br>Dinesh Penta |
| **Informed** | Ajit Murkar<br>Mukeshkumar Jaiswar |

## Timeline Log

| **Stage** | **SPOC** | **Date** |
| :-: | :-: | :-: |
| Logistics Signoff | Kartik Mittal | 27/02/2026 |
| Analytics Walkthrough | Shivam Madaan<br>Ashish Ranjan<br>Dinesh Penta |   |
| Engineering Walkthrough | Mohammed Fahad |   |
| Engineering Scoping | Mohammed Fahad |   |
| Development Start | Mohammed Fahad |   |
| Development End | Mohammed Fahad |   |
| QA Walkthrough |   |   |
| QA Handover |   |   |
| Release |   |   |

## Use Cases

### Use Case 1: Creation of Shipsy Reverse Carrier Account in Clickpost

- Reverse account credentials must be configured in Clickpost.
- Reverse service must be explicitly enabled (separate from forward account).
- Account-level restrictions if any, must be configured.
- Reverse-specific API endpoints must be validated.
- After this setup, ~~the system~~ Clickpost should be able to successfully generate AWB numbers against Shipsy reverse.

### Use Case 2: Creation of Serviceability for Shipsy Reverse

- System maintains a list of serviceable pincodes for Shipsy separate from forward logic.
- Serviceability checks for Shipsy are run after Shipsy is selected as the delivery partner based on the priority logic defined [here](#milestone-1-priority-based-selection-of-reverse-partners-1).
- Serviceability for Shipsy Reverse is decided based on the following parameters:
    - Warehouse selected for the return order.
    - Customer’s Pickup Pincode
    - Is_sdd_reverse_serviceable Flag (True/False)
- Warehouse selection happens upstream. Warehouse is selected based on the original warehouse which serviced the forward order.
- If Shipsy does not service the forward journey combination of warehouse x pincode, Shipsy is rejected as a feasible partner for delivery.
- Flow of events:
    - Customer generates a return request.
    - System selects a delivery partner based on priority defined as per [here](#milestone-1-priority-based-selection-of-reverse-partners-1).
    - Against Shipsy as the selected delivery partner, system checks whether Shipsy can service the pincode in reverse flow.
    - If not, Shipsy is rejected as the delivery partner and system flows back to the priority list to choose another.
    - If yes, Shipsy is selected as the chosen delivery partner and system proceeds with validating warehouse serviceability.
    - If Shipsy services the warehouse x pincode combination in the forward journey, Shipsy is selected as the chosen delivery partner and the system flows ahead. Else, Shipsy is rejected as a feasible delivery partner and the system flows back to the priority list to choose another.
    - O1: Mum FC -> Ahm Pincode. Ahm Pincode -> Shipsy reverse is serviceable. But for WH X Pincode in forward journey, Shipsy is not serviceable. So Shipsy gets discarded.
    - O2: Ahm MFC -> Ahm Pincode.

### Use Case 3: Updating Shipsy Reverse Serviceability

- Serviceability for Shipsy Reverse is updatable through the bulk upload mechanism on Admin Portal.
- In the bulk upload for Shipsy reverse serviceability, stakeholders upload the drop pincode, is_sdd_reverse_serviceable flag, action to be taken on record.
- Access for Admin Portal serviceability changes remains with the Central Logistics team in HO. It will be this team’s responsibility to ensure that Shipsy serviceability is configured appropriately in the system. Additionally, all such config changes should happen post 10PM.
- **System Validations:**
    - If delete action is provided but there is no such configuration to be deleted, system ignores the delete operation.
    - If update action is provided but there is no such configuration, system performs an insert action.
    - If insert action is provided but there is a duplicate configuration, system performs an update action.
    - If Shipsy reverse serviceability is inputted as true, but Shipsy forward serviceability is not present for that pincode, then system rejects that configuration as an erroneous configuration with the appropriate error message in the error file.

### Use Case 4: Selecting Shipsy Based on Priority

- Shipsy selection should happen based on the internal priority set of delivery partners and not Clickpost’s recommendation.
- How internal priority selection will work is covered [here](#milestone-1-priority-based-selection-of-reverse-partners-1).

### Use Case 5: Updating Priority of Delivery Partners

- Update existing priority of reverse delivery partners to the following:
    - Priority 1: Shipsy
    - Priority 2: Shadowfax
    - Priority 3: Delhivery

### Use Case 6: AWB Print for Shipsy Reverse

- Once Shipsy is chosen as the delivery partner, system creates a new order_id against it. This order_id is tied back to the forward order_id with a clean trace.
- For every reverse order_id, the system calls Clickpost to generate an AWB number. This is done immediately after Shipsy is selected.
- Dispatcher logs into the Admin portal and navigates to the Warehouse Management section. Under Warehouse Management, the dispatcher navigates to the “Reverse AWB Print” section.
- Access is controlled for Dispatchers at a module level. This means that a particular dispatcher can access only the Reverse AWB Print section (apart from existing access).
- Once Reverse AWB Print section is opened, the dispatcher has to select his warehouse via a drop down mechanism. The warehouse selection happens through a drop-down mechanism where Warehouse names are provided. (Mumbai, Lucknow, Delhi, etc.)
- In this section, the dispatcher sees a list of return requests allocated to Shipsy. This list is configured in a descending order of raised requests, i.e., an order for Today will be shown first, an order from yesterday will be shown further down in the list.
- This list will have all orders except those that have been delivered to the warehouse.
- Dispatchers can filter these orders based on the following parameters - date range (start and end both inclusive), order status, pincode.
- Dispatchers are expected to select the date range to have orders populated in the portal.
- Pincode filter will populate values only after the warehouse is selected. This is provided as a list of Shipsy Reverse serviceable pincodes in a drop down fashion. Dispatchers can select a single pincode, multiple pincodes or select all pincodes.
- Dispatchers can filter on the following order status - pickup to be planned, driver assigned. By default, both order status should remain selected.
- For each order, the dispatcher can see the following information - order_id, drop pincode, return_request_raised_datetime, last_AWB_printed_time, status.
- Dispatcher selects the orders for which he wants to print the AWB. This is provided as a multi-select option / select all option.
- Once the orders are selected, dispatchers can click on the “Download AWB” button.
- This action generates a download action with which the dispatcher will receive a PDF document with all the AWBs attached.
- AWB format should include the customer's phone number and address.
- Once AWBs get downloaded, the Admin portal should automatically refresh the last_AWB_printed_time for those order_ids.
- **Note:** The PDF should be generated keeping in mind the size proportions of an actual AWB.
- Dispatcher is expected to connect his device to the printer already present in the warehouse to complete AWB print.
- Dispatcher will then handover these AWBs to the delivery executive with bags for collection.

#### Unhappy Case Scenario: Download Initiation Failure

- Each time a download action is triggered by the dispatcher, the system waits for a confirmation for whether the download was initiated or not.
- If the above confirmation is not received, the system then sends an error message pop-up with the following message - “Download Failed! Please try again.”
- The system waits for a maximum of 30 seconds before triggering the above workflow.
- Dispatcher dismisses the pop-up and retries downloading action.

#### Unhappy Case Scenario: AWB PDF Creation Failure in System

- Each time a download action is triggered by the dispatcher, the system waits for a confirmation for whether the AWB PDF was created in the system or not.
- If the above confirmation is not received, the system then sends an error message pop-up with the following message - “Download Failed! Please try again.”
- The system waits for a maximum of 15 seconds before triggering the above workflow.
- Dispatcher dismisses the pop-up and retries downloading action.

### Use Case 7: Passing Return Pickup Information to Shipsy’s Driver Application

- Once order_id is created for Shipsy and AWB is also printed, the order should also be visible to the driver on the Shipsy application. How this will work is covered below.
- All Shipsy allocated orders are visible in the Shipsy portal.
- Dispatcher will assign the reverse order to the driver using the existing process via the Shipsy portal.
- Dispatcher is expected to be aware of the order_ids for reverse which will be visible on Shipsy portal.
- Dispatcher will then assign each order to a driver using the Shipsy Portal.
- Once assigned to the driver, each order should be clearly visible in the Shipsy application.
- Driver should be able to navigate to the customer’s location as he does currently for the forward journey.
- For understanding Shipsy’s current portal and app experience, please refer [here](#appendix-current-shipsy-portal--app-ui).

### Use Case 8: Doorstep Pickup & QC

- Driver takes the AWB and bag from the dispatcher and proceeds to the customer’s doorstep for pickup.
- Driver is expected to take photos of the return item using the existing functionality of POD on Shipsy driver application.
- Driver will also forward these photos to a WhatsApp group along with the order_id. This group will have WH ops POC, and dispatchers who will confirm the correctness of pickup in real-time.
- Driver proceeds forward with the collection from the customer and returns back to the warehouse and hands over the bag to the dispatcher.
- Driver marks the order as delivered on Shipsy. After this action, Clickpost recognises the order as DTO delivered and status gets updated.

### Use Case 9: Inward QC & Refund Processing

- Dispatcher hands over the received return orders to the warehouse operations.
- Warehouse operations continue the inward QC and refund processing as per the current process.

## Rollout Plan

| **Stage** | **Rollout** | **Scale Criteria** | **Release Specific Details** |
| :-: | :-: | :-: | :-: |
| Production Sanity | 10 orders serviced through Shipsy via bypassing other courier priorities. | 1. System is able to successfully allocate orders to Shipsy.<br>2. Dispatcher is able to print AWBs.<br>3. Dispatchers are able to successfully pass AWBs, bags, and instructions to drivers.<br>4. Drivers are successfully able to receive order information on the Shipsy application.<br>5. Returns, QC and refunds are being processed as expected. | WH = Mumbai<br>WH = Guwahati<br>\<pincodes TBA\> |
| Pilot | Rollout Shipsy Reverse for all WHs but specific pincodes. | **Track 1: Uninterrupted Operations**<br>1. System is able to successfully allocate orders to Shipsy.<br>2. Ops is able to print AWBs without delays in reverse pickup initiation.<br>3. All drivers receive bags, AWBs and are able to clearly operate on instructions provided.<br>4. Shipsy application continues to receive information for all return requests.<br>5. Returns, QC and refunds are being processed as expected.<br>**Track 2: Success Criteria Improvement**<br>1. TAT for return delivered is within 1 day for Shipsy.<br>2. TAT for return pickup is within 1 day for Shipsy. | WH x Pincode List = \<TBA\> |
| Staged Rollout | Selectively keep onboarding pincodes. | Monitor Success & Check Metrics | Sequence of rollout \<TBA\>: |

## Metrics

| **Metric Type** | **Metric** | **Definition** |
| :-: | :-: | :-: |
| Success (L1) | Reverse Pickup TAT | Return request -> Return pickup |
| Success (L1) | Reverse Delivered TAT | Return pickup -> Return Delivered |
| Success (L2) | Reverse Processing TAT | Return request -> Refund Processed |
| Guardrail | Shipsy Reverse Allocation Failure % | Instances where Shipsy Reverse Allocation Fails |
| Guardrail | Shipsy Reverse Allocation in non-Serviceable Pincodes | Pincode not serviceable by Shipsy but Shipsy allocated |
| Guardrail | AWB Generation Failure % | Instances where Shipsy Reverse AWB Generation Fails |
| Guardrail | ABW Print TAT | Return Request -> AWB Print Time |
| Guardrail | AWB Download Failure % | Instances where Shipsy Reverse AWB Download Fails |
| Guardrail | AWB PDF Creation Failure % | Instances where AWB PDF was not created in the system |
| Guardrail | AWB Print Latency | Download Initiated -> AWB Print Time |
| Guardrail | Driver Assignment Failure % | Instances where driver assignment of Shipsy Reverse failed |
| Guardrail | Quality of QC done by Driver | - |

## Instrumentation Needed

\<to be added by analytics\>

## Appendix: Current Shipsy Portal & App UI

[SOP For Hyperlocation Operation](https://docs.google.com/document/d/1EG9KimxQmw2br62ghs9B0AmHjKyNFiZsv5VX61U4UEo/edit?tab=t.0)

# Milestone 4

# Milestone 4: Enabling Return to Nearest Warehouse

## RACI

| **Accountable** | Tejas Bhalerao<br>Kartik Mittal |
| :-: | :-: |
| **Responsible** | Tejas Bhalerao<br>Kartik Mittal<br>Mohammed Fahad<br>Shivam Madaan \<QA\> |
| **Consulted** | Anbu Dhileepan<br>Dinesh Penta<br>Sumit Goyal<br>Rajendran KRR |
| **Informed** | Ajit Murkar<br>Mukeshkumar Jaiswar |

## Timeline Log

| **Stage** | **SPOC** | **Date** |
| :-: | :-: | :-: |
| Logistics Signoff | Kartik Mittal |   |
| Warehouse Signoff | Sumit Goyal<br>Rajendran KRR |   |
| Analytics | Shivam Madaan<br>Ashish Ranjan<br>Dinesh Penta |   |
| Engineering Walkthrough | Mohammed Fahad |   |
| Engineering Scoping | Mohammed Fahad |   |
| Development Start | Mohammed Fahad |   |
| Development End | Mohammed Fahad |   |
| QA Walkthrough |   |   |
| QA Handover |   |   |
| Release |   |   |

## Use Cases
