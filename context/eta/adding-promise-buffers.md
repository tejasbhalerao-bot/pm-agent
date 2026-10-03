---
title: Adding Promise Buffers
source: https://docs.google.com/document/d/1qVdscFo53zqgHznemuNnx_GnxdBlzxTIAQtQEaS_76I/edit
type: past-prd
verticals: [courier-forward, hyperlocal-forward]
systems: [eta]
updated: 2026-04-13
---

# [PRD] Adding Promise Buffers

## RACI

|  |  |
| :-: | :-: |
| **Accountable** | Tejas Bhalerao<br>Kartik Mittal |
| **Responsible** | Tejas Bhalerao<br>Kartik Mittal<br>Mohammed Fahad<br>Shivam Madaan<br>Siva Pilla |
| **Consulted** | Anbu Dhileepan<br>Dinesh Penta |
| **Informed** | Ajit Murkar<br>Mukeshkumar Jaiswar<br>Sumit Goyal |

## Timeline View

**Walkthrough Link:** [[PRD Walkthrough] Adding Promise Buffers - 2026/02/26 18:25 GMT+05:30 – Recording](https://drive.google.com/file/d/1kjpbHRqtr-EoTIFWESXprN2KoTXRKy0H/view?usp=sharing)

| **Stage** | **SPOC** | **Date** |
| :-: | :-: | :-: |
| Business Signoff | Kartik Mittal | 17/02/2026 |
| Product Peer Signoff | Anbu Dhileepan<br>Himanshu Bhomia | 17/02/2026 |
| Analytics | Shivam Madaan<br>Ashish Ranjan | 24/02/2026 |
| Engineering Walkthrough | Mohammed Fahad | 26/02/2026 |
| Engineering Scoping | Mohammed Fahad |   |
| Development Start | Mohammed Fahad |   |
| Development End | Mohammed Fahad |   |
| QA Walkthrough | Siva Pilla | 26/02/2026 |
| QA Handover |   |   |
| Release |   |   |

## Objective

As part of this document, we will covering the following:

- Why we need a proactive mechanism to adding promise buffers
- What breaks as a consequence of not having this control
- How this promise buffer if present will function

**Explicit Out of Scope:**

- Buffers will not be applied on placed orders. These will only be applied on created orders. Teams are expected to plan well in advance to avoid the need for buffers to be applied on placed orders.
- System does not support buffer application on ~~already~~ placed orders due to ETA immutability constraints.
- Warehouse JIT related or otherwise buffers are out of scope for this document.
- ~~Solving for early pickups by 3PLs on exception days.~~

## Why Now?

During holidays such as Sundays, Republic Day, New Years, etc. courier partners operate much differently than what they do on normal days. Primarily 2 things change:

- Skeleton crew operates in the network as opposed to a full fledged crew.
- The entire network does not remain operational - some nodes remain closed or at very minimal capacity.
- Pickups are also done at different times than normal due to the driver's operational hours.
- Deliveries are also done at a different pace as compared to normal day deliveries to customers.

This way of working ends up affecting us as well. While promising customers an ETA, we do not end up considering this nuance. As a result, customers do not see the right promised delivery date and we end up breaching the over-committed delivery date to them. This expectation setting mismatch is exactly what we want to tackle at this stage.

The above is validated when we end up looking at the delayed orders distribution in the below time frame. Consistently high delay (~3-4pp from baseline) is observed for Sundays. Additionally, the same is also visible on 26th January (~10pp from baseline).

This is further validated by the fact that when Sunday falls in between an order’s journey or promised delivery date is Sunday, these orders see a markedly higher breach as compared to orders that did not have Sunday anywhere in their journey.

If this nuance on the courier partner’s side is properly addressed, then we will be able to improve promise adherence by a significant amount. To understand the estimate of the same, let’s consider the time period of 2nd Feb to 8th Feb.

| **02/02 - 08/02** |  |
| :-: | :-: |
| Overall Current Delay | 13.72% |
| Sunday Delay | 19.1% |
| Non-Sunday Delay | 12.84% |
| Projected Delay | 12.84% |
| Adherence Improvement Delta | 0.88% |

**What this means:**

- If inflated delays on deliveries due to Sunday are controlled to levels that we see on deliveries of non-Sunday days, we will be able to shift the adherence baseline by ~0.88%.
- This is the maximum attainable improvement based on the analysis period considered under the assumption that Sundays end up being operationally similar to non-Sundays.
- Impact will be higher if we were to loop in holidays such as 26th January as well.

Detailed Analysis here - [Adding Promise Buffers Analysis Sheet](https://docs.google.com/spreadsheets/d/1I6ySdgyfmjLboWhgx5HKfuQVPNWnHqjj00-mfEJ8pAk/edit?usp=sharing) and [Promise Buffer](https://docs.google.com/document/d/1c0QRfIluEaT0FMqBwIzPAnD6aFBiYgJ-sgiYBMJists/edit?usp=sharing).

## Expected Workflow

- Business stakeholders will have access to add buffers to the customer’s promise via the Admin portal.
- Business stakeholders will be uploading the buffers to the customer’s promise based upon existing bulk upload functionality present on the portal. While designing this, there should be no FE dependency.
- Based on the uploaded promise buffers, the system will run validations and reject the file with the appropriate errors against each erroneous line item.
- If there are no errors in the file uploaded, then the system will accept the promise buffers and add them to the relevant orders.
- System should consume the uploaded file in the least amount of time possible. SLA: <5 minutes.
- Buffers should start applying when a particular batch of the uploaded file is processed.
- Uploaded buffers should go into effect as per the configurations present.
- **Note:** System will have minimal validations if multiple buffers are applied on a single day. Stakeholders are expected to be cognizant to account for such cases while devising additional controls.
  The same also applies to conflicting buffers applied (positive and negative). These validations are covered below in Use Case 3.

## Use Case 1: One-time Use Case Promise Buffers

- These are configurations which are bound for execution only once in the defined period. ]
- System provides the user with the following different configurations.

| **Configuration** | **Definition** | **Data Type** | **Sample Values** |
| :-: | :-: | :-: | :-: |
| Warehouse | The warehouse from which orders are being dispatched | Integer | 20, 19, 18 |
| Pincode | Pincode to which the orders are being delivered | Integer | 400607, 400615 |
| Delivery Partner Code | The delivery partner code for which the buffer should be applied | Integer | 26 (Delhivery Surface), 27 (Delhivery Express), 92 (Shipsy) |
| Pickup / Drop | For what the buffer is being designed for.<br><br>Pickup => Orders that have dispatch date as in configuration. Drop => Orders that have delivery date as per configuration. | String | Pickup, Drop |
| Start Date | ~~Created date of orders from which buffer should be applied~~.<br>Pickup => Orders that have dispatch date as >= Start Date.<br>Drop => Orders that have dropdelivery date as >= Start Date. | Datetime | 2026-02-08 |
| End Date | ~~Created date of orders from which buffer should stop being applied.~~<br>Pickup => Orders that have dispatch date as <= End Date.<br>Drop => Orders that have dropdelivery date as <= End Date. | Datetime | 2026-02-09 |
| Start Timestamp | ~~Time of created orders from which buffer should be applied~~. Pickup =>Orders that have dispatch time as >= Start Timestamp<br>Drop => Orders that have delivery time as >= Start Timestamp. | Timestamp | 13:01:59 |
| End Timestamp | ~~Time of created orders from which buffer should stop being applied~~.<br>Pickup => Orders that have dispatch time as <= End Timestamp<br>Drop => Orders that have delivery time as <= End Timestamp. | Timestamp | 16:12:40 |
| Buffer Days Duration | Number of days of buffer to be added | Integer | 4 |
| Buffer Hour Duration | Number of hours of buffer to be added | Integer | 5 |
| Reason for Buffer | Explainer column for why the buffer is being added. | String | String - Buffer is applied due to holiday.<br><br>Reason should be among the fixed list:<br>1. State Holiday<br>2. National Holiday<br>3. Weekly Holiday<br>4. Unplanned Exigencies<br>5. Others |
| Address Type | Type of address location selected by the customer. | List | Office, Home, Others |

- To understand how configurations will go into effect, please visit [here](#appendix---sample-buffers).
- If a pickup configuration is created, the system should automatically add the buffer to the promised dispatch date. Essentially,

  New Promised Dispatch Date = Calculated Existing Logic Promised Dispatch Date + Buffer

- If a drop configuration is created, the system should automatically add the buffer to the promised delivery date. Essentially,

  New Promised Delivery Date = Calculated Promised Delivery Date + Buffer

## Use Case 2: Recurring Use Case Promise Buffers

- These are configurations which are bound for execution on a repetitive basis.
- Over here, the user is also provided with a kill switch for the buffer uploaded on the system.
- System provides the user with the following configurations.

| **Configuration** | **Definition** | **Data Type** | **Sample Values** |
| :-: | :-: | :-: | :-: |
| Warehouse | The warehouse from which orders are being dispatched | Integer | 20, 19, 18 |
| Pincode | Pincode to which the orders are being delivered | Integer | 400607, 400615 |
| Delivery Partner Code | The delivery partner code for which the buffer should be applied | Integer | 26 (Delhivery Surface), 27 (Delhivery Express), 92 (Shipsy) |
| Action | What is the action that is to be performed for the inputted configuration | String | Create / Update / Delete |
| Pickup / Drop | For what the buffer is being designed for.<br><br>Pickup => Orders that have dispatch date as in configuration. Drop => Orders that have delivery date as per configuration. | String | Pickup, Drop |
| Day of Week | Day of week on which buffer should be applied. | String | Saturday |
| Day of Month | Day of month on which buffer should be applied. | String | 1st Saturday |
| Date of Month | Date of month on which buffer should be applied. | Integer | 5, 6 |
| Start Timestamp | ~~Time of created orders from which buffer should be applied~~. Pickup => Orders that have dispatch time >= Start Timestamp<br>Drop => Orders that have delivery time >= Start Timestamp | Timestamp | 13:01:59 |
| End Timestamp | ~~Time of created orders from which buffer should stop being applied~~. Pickup => Orders that have dispatch time <= End Timestamp<br>Drop => Orders that have delivery time <= End Timestamp | Timestamp | 16:12:40 |
| Buffer Days Duration | Number of days for which buffer should be added | Integer | 4 |
| Buffer Hours Duration | Number of hours for which buffer should be added | Integer | 5 |
| Reason for Buffer | Explainer column for why the buffer is being added. | String | String - Buffer is applied due to holiday.<br>Reason should be among the fixed list:<br>1. State Holiday<br>2. National Holiday<br>3. Weekly Holiday<br>4. Unplanned Exigencies<br>5. Others |
| Address Type | Type of address location selected by the customer. | List | Office, Home, Others |

- To understand how configurations will go into effect, please visit [here](#appendix---sample-buffers).
- If a pickup configuration is created, the system should automatically add the buffer to the promised dispatch date. Essentially,

  New Promised Dispatch Date = Calculated Existing Logic Promised Dispatch Date + Buffer

- If a drop configuration is created, the system should automatically add the buffer to the promised delivery date. Essentially,

  New Promised Delivery Date = Calculated Promised Delivery Date + Buffer

## Use Case 3: System Validations

- At least one among Warehouse, Pincode, Delivery Partner must be provided in the configuration.
  If one is missing, for example, delivery partner, all orders flowing through that warehouse for that pincode will be impacted irrespective of the chosen delivery partner.
- Pickup / Drop field should be non NULL.
- Reason for Buffer should be a mandatory field. Reason for buffer should be from the provided list.
- Start & End Timestamps should be between 00:00:00 and 23:59:59. However, none of these fields are mandatory.
  If one is provided, then configuration applies either from the start of the timestamp or to the end of the timestamp.
- Buffer Days Duration and Buffer Hours should be able to accept negative and 0 values as well.
  This is included to support early pickups or early drops happening in specific cases.
- If Buffer Days Duration + Original overall promise TAT calculated <= 0, then the subsequent buffer should not be applied to the order.
- If Buffer Hours Duration + Original overall promise TAT calculated <= 2 hours, then the subsequent buffer should not be applied to the order.
- **Constraint:** Buffer Days Duration < 10. => Only 10 days or less worth of duration is allowed.
- **Constraint:** Buffer Hours Duration <= 24. => Only 24 hours of buffer allowed via this configuration. If more is required, please use the Buffer Days Duration.
- Address Type is a non-mandatory field and can have NULL values.
  If not provided configuration applies on all types of addresses.
- Every buffer is applied sequentially. \<attach example\>

**Validations specific to Use Case 1:**

- Start Date and End Date >= Current Date.

**Validations specific to Use Case 2:**

- Day of the week and Day of month should be valid days between Monday and Sunday.
- 0 < Date of month <= 31.
- If action = create and configuration already exists, the operation should be ~~ignored~~ updated.
- If action = update and there is no update to the configuration, the operation should be ~~ignored~~ inserted.
- If action = delete and there is no configuration to delete, the operation should be ignored.
- In every case, if action is provided, the action goes into effect immediately.
- One single configuration will not accept more than one of Day of Week, Day of Month, Date of Month.

## Use Case 4: TAT / Adherence Logic Changes

- Adjusted Actual TAT gets calculated in the following manner:
    - Actual TAT = Dispatch date - Delivery date
    - Adjusted Actual TAT = Actual TAT - Drop Buffer (if applied on historic orders under consideration)
- Adjusted Actual TAT gets used to calculate Adherence %
- Calculation of TAT / Adherence happens as is (based on adjusted actual TAT)
- Courier Selection Logic changes to:

- Minimum of (TAT/Adherence + Pickup Buffer (if applied) + Drop Buffer (if applied))

- This logic compares this value across all courier partners before selecting.
- Once courier is selected, the buffer applied ETA (if buffer applicable), gets passed to the customer as the promise.

## Metrics

| **Metric Type** | **Metric** |
| :-: | :-: |
| Success (L1) | Promise Adherence Uplift on Known Exception Days |
| Success (L2) | Promise Adherence |
| Guardrails | ETA Promise distribution in duration of added buffers |
| Guardrails | Conversion Rate on duration of added buffers |
| Guardrails | Maximum buffer value added to promise |
| Guardrails | % of orders with promise buffer added |
| Guardrails | % of sessions with added buffers |

## Instrumentation

- Each and every buffer applied should be cleanly traceable to every order_id it was applied on.
- Each order_id should be cleanly recognisable if a buffer was applied on it or not.
- One should be able to cleanly trace which buffer configuration was applied on the order_id.

System must store per order:

- buffer_applied_flag (boolean)
- buffer_total_days
- buffer_total_hours
- buffer_config_ids (ids of buffer configs if they were applied)

## Rollout Plan

### Product Rollout

- No staged rollouts.
- Rollouts to be controlled operationally.
- Configuration releases controlled through use case specific testing.
- Shadow mode testing unnecessary - rollout on specific use cases, experiment and see what happens.

**Operational Rollout Signoff will be given only if product rollout stage does not result in any production issues that interrupt normal flow of business.**

### Operational Rollout

| **Stage** | **Description** | **Scope of Product Involvement** | **Hold / Scale / Kill Criteria** |
| :-: | :-: | :-: | :-: |
| Pilot - Pickup Delay | Running a pilot across different time frames to identify whether we can arrest pickup delays in a predictive fashion. | Product Signoff required on impact achieved before further experimentation. | Scale => Impact achievement % Impact achieved >= 75% of expected.<br>Hold & Refine Strategy => 30% < Impact achievement % < 75% of expected.<br>Kill => Impact achievement <= 30% of expected. |
| Pilot - Drop Delay | Running a pilot across different time frames to identify whether we can arrest drop delays in a predictive fashion. | Product Signoff required on impact achieved before further experimentation. | Scale => Impact achievement % >= 75% of expected.<br>Hold & Refine Strategy => 30% < Impact achievement % < 75% of expected.<br>Kill => Impact achievement <= 30% of expected. |
| BAU | Control fully over to the team to deploy configurations as and when situations demand. | Observational capacity to call out potential disruptions to customers. | Hold & Refine Strategy => Customer conversion on buffer applied days is [-1pp, -3pp]. Adherence uplift < 1pp.<br>Kill Criteria => Customer conversion on buffer applied days is <= -3pp vs Adherence uplift < 1pp |

## Appendix - Sample Buffers

### Example 1: One Time Use Case Promise Buffers

| **Configuration** | **Values** | **Interpretation** |
| :-: | :-: | :-: |
| Warehouse | 20 | This configuration gets applied only for Warehouse ID = 20 and delivery pincode as 400607 when the courier is Delhivery. This configuration is applied only for orders scheduled for promised delivery between 8th February and 10th February. This configuration is applied only for orders scheduled for promised delivery on above dates between 2PM and 3PM. This configuration adds 2.5 days to the promised delivery date. This configuration gets applied only when the address of the customer is of type “Office”. |
| Pincode | 400607 |  |
| Delivery Partner | Delhivery |  |
| Pickup / Drop | Drop |  |
| Start Date | 2026-02-08 |  |
| End Date | 2026-02-10 |  |
| Start Timestamp | 14:00:00 |  |
| End Timestamp | 15:00:00 |  |
| Buffer Days Duration | 2 |  |
| Buffer Hour Duration | 12 |  |
| Reason for Buffer | Holiday Season |  |
| Address Type | Office |  |

### Example 2: Recurring Use Case Promise Buffers

| **Configuration** | **Values** | **Interpretation** |
| :-: | :-: | :-: |
| Warehouse | 20 | This configuration gets applied only on warehouse id = 20 for destination pincode 400607 only for orders that have Delhivery as a courier partner. This configuration is applied only on Sundays for orders scheduled to be picked on Sunday. Buffer duration of 1 day gets added to the Promised Dispatched Date. |
| Pincode | 400607 |  |
| Delivery Partner | Delhivery |  |
| Action | Create |  |
| Pickup / Drop | Pickup |  |
| Day of Week | Sunday |  |
| Day of Month | - |  |
| Date of Month | - |  |
| Start Timestamp | - |  |
| End Timestamp | - |  |
| Buffer Days Duration | 1 |  |
| Buffer Hours Duration | - |  |
| Reason for Buffer | Sunday Holiday. Operations on Skeleton Crew |  |
| Address Type | - |  |

- **Note:** One single configuration will not accept more than one of Day of Week, Day of Month, Date of Month.
