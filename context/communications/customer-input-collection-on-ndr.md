---
title: Customer Input Collection on NDR
source: https://docs.google.com/document/d/15rNnmaPzvT0Ailu1CBI-eqhoEurZirTG_Yt2xfyWI2M/edit
type: past-prd
verticals: [courier-forward, hyperlocal-forward]
systems: [communications]
updated: 2026-04-03
---

# PRD

# Customer Input Collection on NDR

## Objective

Build an input collection mechanism of customer issues on NDR scenarios.

## Rationale

Truemeds relies on several different courier partners to fulfil the last leg of the fulfillment journeys. At the same time, for the delivery to be fulfilled, it requires an implicit collaboration from the customer as well in terms of availability - presence at address for driving collection, availability of correct address, availability over call, etc.

In the current ecosystem, at any time if this collaboration between the courier and customer breaks down, the experience for both breaks down. This experience breakdown manifests in any or more of the following issues:

1. Multiple Delivery Attempts
2. Higher Delivery TAT
3. RTO
4. Customer escalations

As a result of the above experience breakdowns, we are losing out on potential revenue, burning an additional amount on logistics costs, & creating a frictional experience for delivery.

However, the above argument implicitly assumes that both customer and courier are operating in an ideal setup with the best of intentions. From what we currently understand, there are multiple instances of courier marking NDRs fraudulently.

| **Metric** | **% of orders** |
| :-: | :-: |
| RTO | 8.5 |
| NDR marked by courier | 4.275 |
| Fraudulent NDRs marked by courier | 2.565 |

Given the above, we have acknowledged that fraudulent NDRs contribute to RTOs, but we are limited by our current monitoring capabilities.

1. **No timely customer confirmation:** System has no automated mechanism to capture such issues. Current capabilities are limited to the team's calling bandwidth and are able to reach only a selected set of cases.
2. **No mechanism to verify fraudulent cases:** The current system lacks any mechanism to validate fraudulent cases limiting us from taking action against couriers.
3. **No mechanism to resolve customer issues:** Given no mechanism currently exists, we are not able to collect inputs from customers for resolution and are not able to subsequently pass them to courier for resolution.
4. **Choked team bandwidth:** Given the complete absence of a redressal mechanism, the team has to manually manage each scenario and provide required resolution.

As the first step to start reducing customer and courier friction, we are proposing to set up a collection mechanism to capture customer inputs on different scenarios and escalate the same to courier partners. Once we have this in place, it opens the doors for us to address each of the limitations above.

## Expected Workflow

### Happy Case Scenario

- Courier partner marks an order as non-delivered.
- The system captures the courier's input reason and updates order status in the backend.
- The system triggers a WhatsApp message workflow. For detailed workflow, please refer [here](#detailed-whatsapp-workflow).
- The customer selects from the options provided.
- Every customer response gets stored in the backend.
- If the customer chooses to reattempt delivery by changing the delivery date, ETA on the customer app should be recalculated correctly.
- If the customer chooses to cancel the order, order status should be updated as cancelled and an RTO should be initiated along with the refund in case of prepaid orders.
- ~~At 8am and 10pm daily, system generates a report of non-delivered reports to the courier partner’s email. For format of email and details to be included, please refer [here](#courier-notification-on-non-delivered-orders).~~
- ~~At the time of report generation, we should only include orders that have a non-delivered state and have not been escalated to the courier partner. Examples:~~
    - ~~1st OFD attempt fails at 7 am and order is marked as non-delivered. Such orders should be included in the 8am report but not in the 10pm report.~~
    - ~~1st OFD attempt fails at 8pm and order is marked as non-delivered. Such orders should be included in the 10pm report but not in the 8am report.~~
    - ~~1st OFD attempt fails at 8pm, non-delivery is recorded in the 10pm report. Order goes for 2nd OFD attempt at 9am and it is successful. Order should no longer be included in the 10pm report.~~
    - ~~1st OFD attempt fails at 8pm, non-delivery is recorded in the 10pm report. Order goes for 2nd OFD attempt at 10am and is unsuccessful. Order should be included in the 10pm report.~~

**Note:** If the customer responds to the message workflow after a delay (within the re-trigger window), the system should still be able to capture the relevant information from the customer response.

~~**Note:**~~ ~~Input needed from Business team on courier ids to trigger emails. POC:~~ ~~Kartik Mittal~~

### Negative Case Scenario - Lack of customer response

- The system triggers a WhatsApp message workflow.
- Customer fails to respond to the message sent (irrespective of L1 or Lx).
- System resends the last sent message to the customer after a period of 3 hours.
- System attempts resending a maximum of 2 times in one day.
- If the customer responds after the message has been resent, the conversation flow is expected to continue.
- If the customer fails to respond even after 2 resend attempts, the system quits further resend operations for that day.
- System resends the last non-responsed message again the next day. This is repeated for a maximum of 3 days.
- System never sends the message after a cut-off time of 10pm. This is only true for re-trigger of messages in case the customer is not responding. If the customer responds to a message after 10pm, the normal chat workflow should resume.
- If at the time of customer response, the next OFD attempt has been initiated, the system should disregard customer’s inputs and discontinue triggering the workflow.
- The system should again re-trigger the workflow from start if the next OFD attempt also fails.

### Negative Case Scenario - Customer Responds to Multiple Options

- System triggers a WhatsApp chat workflow with relevant options provided.
- Customer selects Option 1 (example) first.
- Post Option 1 selection, customer reselects Option 2 (example).
- System does not persist the information on the backend for Option 2 selection.
- System does not trigger a new workflow based on Option 2 selection.
- ~~System moves ahead with the assumption that customer’s decision making parameters were for Option 2 and triggers relevant workflow.~~
- ~~Additionally, system also updates the option selected by the customer in the database with the latest selected option.~~

### Negative Case Scenario - Customer Responds Outside of Provided Options (if type in option not provided)

- System triggers a WhatsApp chat workflow with relevant options provided.
- Customer inputs a response outside of provided options.
- System registers an event in the backend as customer responding outside of
- System does not consume this response as sent by the customer and waits for the customer to respond with the provided options.
- If the customer fails to respond with the re-trigger window, system falls back to the above negative case scenario.

### Negative Case Scenario - WhatsApp workflow trigger failure

- Courier partner marks the order as non-delivered.
- System updates the order status to reflect as non-delivered.
- System attempts to trigger WhatsApp chat workflow.
- WhatsApp chat workflow is not triggered by the system due to any of the possible reasons:
    - Truemeds system failure
    - WhatsApp endpoint failure
- System records the failure to trigger WhatsApp workflow as an event.
- System re-tries to trigger the WhatsApp workflow until successful.
- Once successful, the system records another successful regeneration event.

### Negative Case Scenario - WhatsApp workflow continuation failure

- System triggers WhatsApp chat workflow.
- Customer inputs his responses based on options provided.
- System fails to generate the required WhatsApp chat workflow beyond customer’s last response.
- System registers a failure event in the backend.
- System keeps on retrying to generate the workflow continuation until successful.
- System waits for successful response on WhatsApp trigger.
- At no point does the system trigger the same message multiple times.
- Once successful, system triggers a successful regeneration event.

### Negative Case Scenario - Failure to Capture Customer Responses in Backend

- System triggers WhatsApp chat workflow.
- Customer inputs options as required.
- System fails to capture the required input as sent by the customer.
- System generates an event to record a failure of input capture.

### ~~Negative Case Scenario - Failure to Generate Courier Partner Reports~~

- ~~Customer inputs on WhatsApp chat are recorded as inputs to the system.~~
- ~~At 8am or 10pm, the system tries to generate a courier partner report with the required information.~~
- ~~If the system fails to generate the report for any courier partner,~~

### ~~Negative Case Scenario - Failure to Send Courier Partner Reports~~

- ~~System successfully generates the courier partner report of non-delivered orders.~~
- ~~System fails to send an email to the courier partner regarding the non-delivered orders in the specified format.~~
- ~~System records a failure to generate a report event.~~
- ~~System retries sending the report to the courier partner until successful.~~
- ~~Once successfully delivered, system generates a successful delivery event.~~

## Risks & Mitigation

| **Risk** | **Mitigation** |
| :-: | :-: |
| Customer provides inaccurate information on the WhatsApp chat workflow | 1. Continuous verification by the courier partner.<br>2. Continuous internal audits to be done by internal teams. |
| Courier Partner fails to take action on escalated NDRs | 1. Continuous internal audits by internal teams on actions taken on escalated cases.<br>2. Continuous communication to courier partners to improve SLAs and adherence. |
| Incorrect phone number input by customer | Currently this will have to be handled manually via business team / courier partner if and when identified. In the meantime, these orders might continue to result in NDRs. We will handle this case as part of the next iteration. |
| Incorrect address input by customer | Currently this will have to be handled manually via the business team.<br>1. If a customer inputs location in a different pin code.<br>2. If a customer inputs location incorrectly. |

## Data Capture Requirements

Full Requirements here - [NDR ARD](https://docs.google.com/spreadsheets/d/1KOzYN2VA4SuHDidSbkf9BGg5E76iqVFXmWUq5E6iywQ/edit?usp=sharing)

| **Field** | **Description** |
| :-: | :-: |
| order_id | Internal Order ID |
| customer_id | Customer UID |
| customer_name | For template |
| phone_number | Messaging number |
| courier_partner | Partner name |
| undelivered_reason | From courier |
| undelivered_timestamp | Event timestamp |
| message_sent_timestamp | Timestamp for when each message was sent |
| customer_response | As provided in options (capture each response) |
| customer_response_branch | Branch in workflow where customer selection option (capture each response’s branch) |
| customer_response_timestamp | Timestamp for when customer responded to provided question (capture each response’s timestamp) |
| cancellation_reason | If cancelled |
| corrected_address | If provided |
| alternate_phone | If provided |
| preferred_delivery_date | If chosen |
| delivery_attempt_count | Which delivery attempt this was - 1st, 2nd, 3rd |

**Need some other metrics -**

- **customer response count, specially to capture the cases of two fake NDRs**

## Acceptance Criteria

- WhatsApp messages trigger instantly upon undelivered event
- Correct conversation flow based on customer inputs
- All customer inputs stored accurately
- Daily partner emails generated with correct cases
- Error handling for invalid date formats
- No messages after 10 PM
- No duplicate messages for same order within 3 hours

## Rollout Plan

| **Stage** | **Rollout** | **Scale Criteria** |
| :-: | :-: | :-: |
| Production Sanity | Launch only for internal customers | 1. Data Sanity check on Production passes.<br>2. Engineering system stability holds.<br>3. Chatbot behaves as expected. |
| Staged Rollout 1 | **Release for 10% order volume.**<br>10% of orders placed will be eligible for NDR chatbot to be triggered in case of delivery failed. | 1. Response Accuracy on Chatbot >= 75%.<br>2. Response Rate on Chatbot > 50%. |
| Staged Rollout 2 | **Release for 35% order volume.**<br>35% of orders placed will be eligible for NDR chatbot to be triggered in case of delivery failed. | 1. Response Accuracy on Chatbot >= 70%.<br>2. Response Rate on Chatbot > 50%.<br>3. Ops Load on manual callbacks reduces by at least 25%.<br>4. Couriers are able to take actions on all highlighted cases with instances of 2 failed deliveries reducing.<br>5. Orders with Chatbot initiated to have lower total failed deliveries than orders with Chatbot not initiated. |
| Staged Rollout 3 | **Release for 70% order volume.**<br>70% of orders placed will be eligible for NDR chatbot to be triggered in case of delivery failed. | 1. Response Accuracy holds at >=70%.<br>2. Response Rate on Chatbot > 50%.<br>3. Ops Load on manual callbacks reduces by at least 50%.<br>4. Couriers are able to take actions on all highlighted cases with instances of 2 failed deliveries reducing.<br>5. Orders with Chatbot initiated to have lower total failed deliveries than orders with Chatbot not initiated. |
| Staged Rollout 4 | **Release for 100% order volume.**<br>100% of orders placed will be eligible for NDR chatbot to be triggered | 1. Response Accuracy holds at >=70%.<br>2. Response Rate on Chatbot > 50%.<br>3. Ops Load on manual callbacks reduces by at least 75%.<br>4. Couriers are able to take actions on all highlighted cases with instances of 2 failed deliveries reducing. |

## Metrics

| **Metric Type** | **Metric** |
| :-: | :-: |
| Success (L1) | RTO % |
| Success (L1) | NDR % |
| Success (L2) | Delivery TAT |
| Success (L2) | Customer Complaint % |
| Success (L2) | Delivery Reattempt TAT |
| Success (L2) | Operations Cost |
| Guardrail | Number of Workflows triggered per order |
| Guardrail | Order Cancellation % |
| Guardrail | Response Rate to 1st message % |
| Guardrail | % of raised issues reaching last node |
| Guardrail | Number of days reminder message is triggered |
| Guardrail | Number of times reminder message is triggered |
| Guardrail | Number of times reminder message is triggered per day |
| Guardrail | Time to trigger workflow after order status update |
| Guardrail | WhatsApp Workflow Trigger Failure Rate |
| Guardrail | WhatsApp Workflow Continuation Failure Rate |
| Guardrail | Backend Response Capture Failure Rate |
| Guardrail | Report Generation Failure Rate |
| Guardrail | Report Trigger Failure Rate |
| Leading | WhatsApp Chat Workflow Trigger to Customer Response Time |
| Leading | WhatsApp Chat Workflow Message Trigger to Customer Response Time |
| Leading | % Workflows triggered on 1st, 2nd, 3rd NDR |
| Leading | Time taken to reach last node |

## Detailed WhatsApp Workflow

### Message 1

**Hi {{customer_name}},**

We’re writing regarding your medicine order **{{order_id}}**.

Today’s delivery could not be completed. The delivery partner has reported the following reason:
**“{{reason}}.”**

We’re reviewing this and want to ensure we take the right next step to deliver your order safely and on priority.

To help us proceed, could you please confirm:

**Did a delivery agent contact you today?**

**1️⃣**Yes, they contacted me

**2️⃣**No, nobody contacted me

**Branch 1: If customer is contacted by delivery agent**

**Branch 1.1:**

Thank you for confirming.

We can arrange a reattempt for your medicine order and will coordinate this with our delivery partner at the earliest possible time.

Please let us know how you’d like to proceed:

**1️⃣**Yes, please reattempt the delivery

**2️⃣**No, I want to cancel the delivery

**Branch 1.1.1 - Customer still wants the delivery**

Redirect to Message 2.

**Branch 1.1.2 - Customer does not want the delivery**

Thank you for letting us know.

Before we process the cancellation, it would help us improve our delivery experience if you could share the reason for cancelling this medicine order.

Please select the option that best applies:

1️⃣ Delivery was delayed
2️⃣ Purchased from a local shop at a better price
3️⃣ Purchased from a local shop because it was immediately needed

4️⃣Purchased from another online pharmacy
5️⃣I don’t need the medicines now (health condition resolved)
6. Other — type your reason (not mandatory to fill in unless selected)

If Delivery was delayed (1), redirect to branch 1.1.2.1, else redirect to message 5.

**Branch 1.1.2.1 - Customer selects delivery delayed as cancellation reason**

We apologise for the delay.

We can prioritise a reattempt for your medicine order and coordinate this closely with our delivery partner.

If you’re comfortable proceeding, please let us know your preference:

1️⃣ Yes, please re-attempt delivery.
2️⃣ No, I would like to cancel.

If yes, redirect to Message 2.

If no, cancel the order, redirect to Message 5.

**Branch 2: If customer is not contacted by delivery agent**

Thank you for confirming.

We’re escalating this with the delivery partner and arranging the next delivery on priority.

Please let us know how you’d like to proceed:

**1️⃣** ~~Yes,~~ Please re-attempt delivery
2️⃣ ~~I do not want it anymore .~~ I would like to cancel.

If yes, redirect to message 2

If no, redirect to branch 1.1.2

### Message 2

Great!
To help us schedule your delivery, please choose your preferred delivery date from the below

Step 1 — Preferred Delivery Date

~~D (not in Batch 2)~~

D+1: Display exact date

D+2: Display exact date

~~Other=> Type in DD-MM-YYYY~~
~~Example: 18-12-2025~~

~~→ After customer responds: validate format~~

Reply with:

Thank you! Your delivery will be reattempted on {{date}}.

Redirect to Message 3.

### Message 3

Help us to serve you better. Please let us know if you want to share an alternate phone number.

**1️⃣** Yes
2️⃣ No

**Branch 1: Customer wants to update phone number**

Reply with,

“Please enter your 10-digit phone number - please enter in the following format only e.g., 9876543210”

Reply with,

“Got it!

Store the updated phone number in the backend.

**Branch 2: Customer does not want to update phone number**

Reply with,

“Got it!

Redirect to Message 4.

### Message 4

As a last step, please help us in case of any edits to address. Your current address as per records is **{current address},** do you want us to update your address? *Please note that the item will be delivered only if the revised address is in the* *same pincode*

**1️⃣** Yes
2️⃣ No

**Branch 1: Customer wants to update address**

Reply with,

“Please enter your updated address in the form of House number, locality, landmark, city.”

**Store the updated address in the backend.**

“Please enter your pincode”

**Store the updated address in the backend.**

Reply with,

We’ve received your updated details and will schedule a quick reattempt. You’ll receive updates soon

**Branch 2: Customer does not want to update address**

Reply with,

“Got it!
We’ve received your updated details and will schedule a quick reattempt.
You’ll receive updates soon.”

### Message 5

“Your order has been successfully cancelled. If any amount was charged, the refund will be processed as per our policy. We appreciate you considering Truemeds, and we’ll be here whenever you need us again.”

## ~~Courier Notification on Non-Delivered Orders~~

~~**Daily Automated File Types (per partner)**~~

1. ~~Fake Attempt Suspected [selected on basis of customer selection – all cases including corresponding address/ phone number updates]~~
2. ~~Genuine attempt cases [Rescheduled cases/ Customer needs delivery – all cases including corresponding address/ phone number updates]~~
3. ~~Escalated Cases [with all details about updated address/ phone number etc.]~~

~~**Bifurcation of Different File Types Based on Customer Selection**~~

1. ~~Fake Attempt Suspected: Orders in this file are populated only if the customer has chosen that the courier partner did not initiate contact.~~
2. ~~Genuine Attempt Cases: Orders in this file are populated only if the customer has chosen that the courier partner initiated contact.~~
3. ~~Escalated Cases: Orders in this file are populated only if the customer has chosen to update their contact details.~~

~~**Parameters to be included as part of the Daily Automated Files**~~

1. ~~Customer Name~~
2. ~~Customer Phone Number~~
3. ~~Latest Available Delivery Address~~
4. ~~Delivery Date~~

~~**File Format**~~

- ~~XLSX~~
- ~~Naming convention: partnername_category_YYYYMMDD_hhmm.xlsx~~

~~**Email Automation**~~

- ~~Batch 1 - triggered at 10 PM~~
- ~~Batch 2- triggered at 8 AM~~
- ~~Preloaded partner email lists~~
- ~~Email Subject: **“Daily Delivery Issue Report – {{Partner Name}} – {{Date}}”**~~

# Metrics

### **Customer Interactions**

| **Category** | **Metric** | **Definition** | **Priority** |
| :-: | :-: | :-: | :-: |
| Cancel | Cancel Intent Rate per attempt | # of attempts with Cancel selected in at least 1 triggered workflow / Total attempts with Workflows triggered | P0 |
| Cancel | Cancel Intent Time | Average (Cancel selection time - Workflow trigger time) | P0 |
| Interactions | Response Rate per workflow | # of workflows with at least 1 response / Total workflows triggered | P0 |
| Interactions | Response Rate per attempt | # of attempts with at least 1 workflow responded with at least 1 response / Total Attempts with Workflows triggered | P0 |
| Interactions | Workflow Response Time | Average (1st message response time - workflow trigger time) | P0 |
| Interactions | Workflow Trigger Rate | Average # of times with workflow triggered per NDR | P0 |
| Reattempt | Reattempt Intent Rate per order | # of attempts with Reattempt selected in at least 1 triggered workflow / Total Attempts with Workflows triggered | P0 |
| Reattempt | Reattempt Intent Time | Average (Reattempt selection time - Workflow trigger time) | P0 |
| Workflow Delivery | Workflow Delivery Rate | # of workflows with successfully delivery / # of workflows triggered | P0 |
| Workflow Delivery | Workflow Read Rate | # of workflows with successfully read / # of workflows triggered | P0 |
| Workflow Delivery | Workflow Send Rate | # of workflows successfully sent / # of workflows triggered | P0 |
| Interactions | Courier Contact Rate | # of attempts where courier did not call customers / # of attempts with workflow response | P0 |
| Interactions | Response Rate by Delivery Attempt | Distribution of response rate plotted against attempt count | P1 |
| Interactions | Response Rate by Retry Attempt | Distribution of response rate plotted against same attempt workflow re-trigger count | P1 |
| Additional Details | Alternate Number Intent Rate per attempt | # of attempts where alternate phone number was shared / Total Attempts with Workflows triggered | P1 |
| Additional Details | Address Change Intent Rate per attempt | # of attempts where alternate address was shared / Total Attempts with Workflows triggered | P1 |
| Cancel | Cancellation Reason Selection Rate | # of workflows where cancel reason was selected / # of workflows where cancel was selected | P1 |
| Additional Details | Alternate Phone Number Validity | # of cases where number was not 10 digits / # of cases where number was entered | P2 |
| Additional Details | Pincode Change Rate | # of cases where pincode was changed from original / # of cases where pincode was entered | P1 |
| Cancel | Cancel to Reattempt Switch Rate | # of workflows where cancel was selected initially but reattempt selected later / # of workflows where cancel was selected | P2 |
| Interactions | Workflow Completion Rate | # of workflows with last node reached / # of workflows triggered | P2 |
| Interactions | Workflow Completion Time | Average (Workflow completed time - workflow trigger time) | P2 |
| Interactions | Intent Change Rate per attempt | # of attempts with Intent changed from Reattempt to Cancel across workflows / Total Attempts with Workflows triggered | P2 |
| Interactions | Intent Change Rate per order | # of orders with Intent changed from Reattempt to Cancel across Attempts / Total Orders with Workflows triggered | P2 |
| Reattempt | Reattempt Date Intent | Orders with D+1 date selected / Total Orders with workflows triggered<br>Orders with D+2 date selected / Total Orders with workflows triggered | P2 |
| Workflow Delivery | Workflow x Attempt Distribution | % of workflows triggered for 1st NDR<br>% of workflows triggered for 2nd NDR<br>% of workflows triggered for 3rd NDR and beyond | P2 |

### **Impact Metrics**
