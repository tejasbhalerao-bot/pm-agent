---
**Document:** Driver Login, Duty Start & End
**Type:** Executable PRD
**Version:** v2
**Date:** 2026-11-08
**Status:** Under Review
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-11-08 | Initial draft |
| v2 | 2026-11-08 | An app opened with no connection shows the last duty status the phone received (Use Case 2.3, Step 5). Going on duty again after ending a duty starts a new duty (Terms). Two wording fixes. |
---

# [PRD] Driver Login, Duty Start & End

**Systems:** Rider app (new, no Context) · Driver Management · Communications (the OTP message; Context holds customer notices only) · **Verticals:** Hyperlocal Forward, Hyperlocal Reverse

**Contents**

- [1. Objective](#1-objective)
- [2. Why Now](#2-why-now)
- [3. Use Cases](#3-use-cases)
  - [Use Case 1: Log in to the rider app](#use-case-1-log-in-to-the-rider-app)
  - [Use Case 2: Go on and off duty](#use-case-2-go-on-and-off-duty)
  - [Side effects](#side-effects)
  - [Open points](#open-points)
- [4. Metrics](#4-metrics)
- [5. Rollout & Stage Gates](#5-rollout--stage-gates)
- [6. Decisions](#6-decisions)

## 1. Objective

Every driver created in Driver Management logs in to the rider app on the first attempt, and the System knows at every moment which drivers are on duty.

## 2. Why Now

Shipsy handles Truemeds' rider creation, rider allocation, the rider's flow in the app, and tracking and reporting today. Leadership has decided to build the rider app in house and end the dependency on Shipsy. Drivers are created in the Hyperlocal Fleet Management Portal (Driver Management), but the in-house rider app does not exist yet: no driver can log in, and the System has no record of who is on duty. None of this is measured today.

Every later part of the rider app starts here. An order cannot appear in a driver's app, or be given to a driver, until the driver is logged in and on duty. Automated allocation needs to know who is on duty, and attendance and payout need the start and end of each duty. Serving locations grow from 39 to 150 in the next 15 months, and the first cutover location cannot cut over until its drivers can log in and go on duty.

## 3. Use Cases

This PRD adds two things to the rider app: login with an OTP (Use Case 1) and going on and off duty with a swipe (Use Case 2). It applies to every driver in Driver Management, in both verticals. Creating drivers is in the Driver Management PRD. The portal, order assignment, the rest of the home screen and logging out are not in this PRD.

**Terms**

- A driver is a person created in Driver Management. The driver's mobile number there is the number the driver logs in with. It is unique across drivers.
- An OTP is a one-time code the System sends to a mobile number (Open points). It works once. A new OTP sent to a number replaces the earlier one. The OTP validity time counts from the moment the System sends it.
- A driver is on duty or off duty. A new driver is off duty. The duty status belongs to the driver, not to a phone: a swipe on any phone changes it.
- The System records the time of every duty start and end from its own clock, when it receives the swipe. A duty is a start and, once the driver ends it, an end. Going on duty again after ending a duty starts a new duty. A duty can cross midnight.

**Messages and limits**

- A message in quotes is shown on the screen. A message about the mobile number or the OTP shows under that field.
- Six values are fixed in the System and are not set yet (Open points): the length of the OTP, the OTP validity time, the resend wait, the wrong-OTP limit (wrong OTPs allowed for one OTP), the OTP request limit (OTPs sent to one number in one period) and that period.

### Use Case 1: Log in to the rider app

Who: a driver who is logged out. Precondition: the driver is created in Driver Management. Applies to Hyperlocal Forward and Hyperlocal Reverse.

#### Use Case 1.1: Happy Case — a registered driver logs in

**Step 1:** Driver opens the rider app.

**Step 2:** System shows the login screen with the field "Mobile number" and the button "Get OTP".

**Step 3:** Driver enters their mobile number and selects "Get OTP".

**Step 4:** System checks the number (Use Case 1.2). All checks pass.

**Step 5:** System sends an OTP to the number and shows the OTP screen: "Enter the OTP sent to <mobile number>", the field "OTP", the buttons "Log in" and "Change number", and "Resend OTP in <n> seconds" counting down from the resend wait. When this OTP is the last one the OTP request limit allows in the period, System shows no "Resend OTP" (Use Case 1.4, Step 5).

**Step 6:** Driver enters the OTP and selects "Log in".

**Step 7:** System checks the OTP (Use Case 1.3). A driver still has the number, and the OTP is the latest one sent to it, has not been used, has not expired and matches.

**Step 8:** System logs the driver in and shows the home screen with the driver's duty status (Use Case 2).

Result: the driver is logged in on this phone. The OTP is used and cannot be used again.

#### Use Case 1.2: Edge Case — the mobile number fails a check

**Step 1:** Driver selects "Get OTP".

**Step 2:** System finds that a check fails.

**Step 3:** System sends no OTP, stays on the login screen, keeps the number and shows the message under the field:

| Check that fails | Message |
|---|---|
| The mobile number is empty, or is not 10 digits starting with 6, 7, 8 or 9 (spaces are ignored) | "Enter a valid 10-digit mobile number." |
| No driver has this mobile number | "This number is not registered. Ask your DC or warehouse to register you." |
| The System has already sent this number as many OTPs in the period as the OTP request limit allows | "Too many OTP requests. Try again later." |

**Step 4:** Driver corrects the number and selects "Get OTP" again. For a number that is not registered, a user whose role holds Driver management creates the driver (Driver Management PRD, Use Case 2) first.

#### Use Case 1.3: Edge Case — the OTP is wrong or expired

**Step 1:** Driver selects "Log in".

**Step 2:** System finds that a check fails. System checks in this order: the number, expiry, the wrong-OTP limit, the code.

**Step 3:** System does not log the driver in. It stays on the OTP screen and shows the message under the field "OTP":

| Check that fails | Message | What System does |
|---|---|---|
| No driver has this mobile number any more: a user changed it after the OTP was sent | "This number is not registered. Ask your DC or warehouse to register you." | The OTP stops working |
| The OTP validity time has passed since the OTP was sent | "This OTP has expired. Get a new OTP." | The OTP stops working |
| The wrong OTPs entered for this OTP have reached the wrong-OTP limit | "Too many wrong attempts. Get a new OTP." | The OTP stops working, even for the right code |
| The code does not match the latest OTP sent to this number, or the OTP was already used | "The OTP is not correct. Try again." | Counts one wrong OTP for this OTP |

**Step 4:** Driver enters the OTP again, or gets a new OTP (Use Case 1.4).

#### Use Case 1.4: Edge Case — the driver needs a new OTP

**Step 1:** The driver did not receive the OTP, typed another number, or the OTP expired or stopped working (Use Case 1.3).

**Step 2:** Driver waits until "Resend OTP in <n> seconds" reaches zero. "Resend OTP" is then selectable. Selecting it earlier does nothing.

**Step 3:** Driver selects "Resend OTP".

**Step 4:** System checks the OTP request limit (Use Case 1.2). Under the limit, System sends a new OTP. The earlier OTP stops working, the count of wrong OTPs starts again, and the validity time and the resend wait start again.

**Step 5:** At the limit, System sends no OTP and shows "Too many OTP requests. Try again later." On this screen that happens only when the number was asked for from another phone since the last OTP, because the screen shows no "Resend OTP" once the last OTP allowed is sent. Driver can ask for an OTP again once the period of the limit has ended.

**Step 6:** A driver who typed another number selects "Change number". System shows the login screen with the number kept.

#### Use Case 1.5: Edge Case — the OTP cannot be sent or the System cannot be reached

**Step 1:** Driver selects "Get OTP", "Resend OTP" or "Log in".

**Step 2:** System cannot send the OTP, or the phone cannot reach the System.

**Step 3:** The app stays on the same screen with what the driver entered and shows:

| When | Message |
|---|---|
| The System fails to send the OTP | "We couldn't send the OTP. Try again." |
| The phone cannot reach the System | "No internet connection. Connect and try again." |

**Step 4:** Driver selects the button again. An OTP the System failed to send does not count towards the OTP request limit.

### Use Case 2: Go on and off duty

Who: a logged-in driver. Applies to Hyperlocal Forward and Hyperlocal Reverse. A swipe needs a connection: the System records it when it receives it.

#### Use Case 2.1: Happy Case — a driver goes on duty

**Step 1:** Driver opens the rider app. System shows the home screen with "You are off duty." and the swipe control "Swipe to go on duty".

**Step 2:** Driver swipes the control to its end.

**Step 3:** System sets the driver's duty status to on duty and records the time as the duty start.

**Step 4:** System shows "You are on duty.", "On duty since <date and time>" and the swipe control "Swipe to go off duty".

Result: the driver is on duty. The System holds the status and the duty start for later use.

#### Use Case 2.2: Happy Case — a driver goes off duty

**Step 1:** Driver opens the rider app. System shows the home screen with "You are on duty.", "On duty since <date and time>" and the swipe control "Swipe to go off duty".

**Step 2:** Driver swipes the control to its end.

**Step 3:** System sets the driver's duty status to off duty and records the time as the duty end. The duty that started at the recorded start is closed.

**Step 4:** System shows "You are off duty." and the swipe control "Swipe to go on duty".

Result: the duty has a start and an end. The driver is off duty until the next swipe.

#### Use Case 2.3: Edge Case — the swipe does not complete, or the System cannot be reached

**Step 1:** Driver swipes the control.

**Step 2:** The swipe stops before its end. The control returns to its start. Nothing is recorded and no message shows.

**Step 3:** The swipe reaches its end, but the phone cannot reach the System, or the System cannot record it. The control returns to its start, the duty status does not change, and the screen shows: "We couldn't update your duty. Check your internet and try again."

**Step 4:** Driver swipes again.

**Step 5:** When the driver opens the app and the phone cannot reach the System, the home screen shows the last duty status the phone received, with the swipe control for it. A swipe then follows Steps 3 and 4.

#### Use Case 2.4: Edge Case — the screen is out of date

**Step 1:** Driver swipes to go on duty, but the System already holds the driver as on duty: the driver went on duty on another phone, or an earlier swipe reached the System after the screen showed off duty.

**Step 2:** System changes nothing, keeps the first duty start and shows "You are already on duty." The screen then shows the on-duty home screen (Use Case 2.1, Step 4).

**Step 3:** The same applies to a swipe to go off duty when the driver is already off duty: "You are already off duty." The screen then shows the off-duty home screen (Use Case 2.2, Step 4).

#### Use Case 2.5: Edge Case — the driver does not end the duty

**Step 1:** The shift is over and the driver does not swipe to go off duty.

**Step 2:** System does not end the duty. It stays open, across midnight and across days. The next time the driver opens the app, the home screen shows "You are on duty." with the duty start, and the driver can swipe to go off duty (Use Case 2.2). The System records the duty end at that swipe.

**Step 3:** Nobody is told. In this release nobody notices an open duty, and no one else can end it. What happens next is an Open point.

### Side effects

- Later features read the duty status: allocation treats an on-duty driver as available, and attendance and payout use the start and end of each duty. This PRD records the status and the times only.
- Showing who is on duty in the portal, a user confirming each driver is accounted for, confirming the device and vehicle at duty start, and attendance reports are not in this PRD.
- When order assignment ships, it decides what happens when a driver ends duty with orders in hand. Nothing in this PRD stops it.
- A change in Driver Management applies from the next login. A changed mobile number is the number the driver logs in with from then on, and a driver already logged in stays logged in. A change of the driver's hub or type does not change the duty status.
- When suspension and exit ship in Driver Management, a suspended or exited driver must not log in or go on duty, and must be taken off duty. That is not in this PRD.
- Each login costs one OTP message, and each resend costs one more. The cost of a message is not known.

### Open points

| Question | Decides |
|---|---|
| What are the six values: OTP length, OTP validity time, resend wait, wrong-OTP limit, OTP request limit and its period? | Tejas |
| Does a login expire, can the driver log out, and can a driver be logged in on two phones? | Tejas |
| What happens to a duty the driver never ends: does it end by itself at a set time, or does a portal user end it, and who is told? | Tejas |
| The Order Intake PRD says a Mid-Mile Driver has no app, and Driver Management creates drivers of type Mid mile. May a Mid mile driver log in and go on duty? | Tejas |
| How is the OTP sent (SMS or WhatsApp), and through which provider? | Tejas, with engineering |

## 4. Metrics

| Metric Type | Metric | Definition |
|---|---|---|
| Success | First-attempt login success | OTPs sent whose first code entered is accepted ÷ OTPs sent against which at least one code is entered |
| Success | Duty swipes recorded | Swipes to go on or off duty completed in the app after which the System holds the duty status the swipe asked for ÷ swipes to go on or off duty completed in the app |
| Lead | Time to log in | Median time from a registered driver selecting "Get OTP" to being logged in, for completed logins |
| Lead | OTPs sent per login | OTPs sent ÷ logins completed |
| Lead | Numbers rejected as not registered | "Get OTP" selections rejected as not registered ÷ all "Get OTP" selections |
| Check | Logins outside the rules | Count of logins completed with a mobile number that no driver has, or with an OTP that was not the latest, was already used, had expired or did not match |
| Check | OTPs that fail to send | OTP sends that fail ÷ OTP sends |
| Check | Duty starts on an open duty | Swipes to go on duty received while the driver is on duty ÷ swipes to go on duty received |
| Check | Duty records out of order | Count of duty ends with no open duty, and of drivers with more than one open duty |

## 5. Rollout & Stage Gates

| Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria |
|---|---|---|---|---|
| 1 | Prove login and duty with a few drivers | A user whose role holds Driver management creates a few drivers of the first cutover location in the portal. They log in to the rider app and swipe on and off duty. No order is involved. How many drivers is not yet decided. | First-attempt login success: target to be set from baseline. Duty swipes recorded: target to be set from baseline. | Logins outside the rules: any. OTPs that fail to send: threshold not yet set. Duty starts on an open duty: threshold not yet set. Duty records out of order: any. |
| 2 | Every driver of the first cutover location | The drivers of the location, created in Driver Management before cutover, log in and go on and off duty each day. Shipsy still handles orders. | Same as Stage 1. | Same as Stage 1. |
| 3 | Every cutover location | Each location's drivers log in and go on duty from the location's cutover. | Same as Stage 1. | Same as Stage 1. |

## 6. Decisions

| # | Decision | Where in this PRD |
|---|---|---|
| 1 | A driver logs in with the mobile number held in Driver Management and an OTP. Any driver created there can log in, whatever the driver's type (Open points). | Use Case 1 |
| 2 | The System sends an OTP only to a number that a driver has. A number that no driver has gets a message and no OTP. | Use Case 1.2 |
| 3 | A new OTP replaces the earlier one. An OTP works once, and stops working when it expires or when too many wrong OTPs are entered. | Use Cases 1.3, 1.4 |
| 4 | An OTP the System failed to send does not count towards the OTP request limit. | Use Case 1.5 |
| 5 | The duty status belongs to the driver, not to a phone. A swipe on any phone changes it. | Terms, Use Case 2.4 |
| 6 | The System records the duty start and end from its own clock when it receives the swipe. No duty is recorded without a connection in this release. | Terms, Use Case 2.3 |
| 7 | The System never ends a duty by itself in this release. | Use Case 2.5 |
| 8 | A duty can cross midnight. There is no end of day. | Terms, Use Case 2.5 |
| 9 | Not in this PRD: the portal view of who is on duty, a user confirming each driver is accounted for, confirming the device and vehicle at duty start, and attendance reports. Attendance Tracking and Device Assignment are separate initiatives. | Side effects |
