---
**Document:** Driver Login, Duty Start & End
**Type:** Executable PRD
**Version:** v6
**Date:** 2026-11-09
**Status:** Under Review
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-11-08 | Initial draft |
| v2 | 2026-11-08 | An app opened with no connection shows the last duty status the phone received (Use Case 2.3, Step 5). Going on duty again after ending a duty starts a new duty (Terms). Two wording fixes. |
| v3 | 2026-11-09 | The OTP has 4 digits, is valid for 30 minutes and goes by SMS in the customer app's template. A driver can ask for a new OTP after 10 seconds, only by selecting "Resend OTP". There is no limit on wrong OTPs, so "Too many wrong attempts." is removed (Terms, Use Cases 1.3, 1.4). A login never expires, the driver logs out (Use Case 1.6), and a driver is logged in on one phone at a time (Use Case 1.7). Only a driver of type Last mile or Both can log in (Terms, Use Cases 1.2, 1.3). The OTP request limit and the forgotten duty remain Open points. |
| v4 | 2026-11-09 | Login is three screens, each asking one thing: a welcome screen with "Log in", a number screen ("What's your mobile number?") and an OTP screen ("Enter your OTP"). The last two have the button "Next" and a back arrow. "Get OTP", the OTP screen's "Log in" and "Change number" are gone. The resend countdown sits in the line under the heading. Going back and selecting "Next" with the same number sends no new OTP while its OTP is valid. Logged-out messages show on the welcome screen (Terms, Use Cases 1.1 to 1.7, Side effects, Metrics, Decisions 4 and 14). |
| v5 | 2026-11-09 | Review comments on Use Case 1. A resend within the OTP's 30 minutes sends the same OTP, and after it the System generates a new one (Terms, Use Cases 1.1, 1.4). Messages: a Mid mile number gets the not-registered message, now "This number is not registered. Please register yourself at a Truemeds Hub."; "Too many OTP requests. Please try again after <x> minutes."; "OTP Expired. Request Again."; "Incorrect OTP. Try again." (Use Cases 1.2, 1.3). The number screen no longer has the line "We'll send you an OTP by SMS.". "Log out" is out of Use Case 1.5 and has its own no-connection step in Use Case 1.6. The welcome screen never shows a message, and phone A is logged out immediately after phone B logs in (Use Case 1.7). What the OTP request limit counts is an Open point. |
| v6 | 2026-11-09 | The OTP request limit is set: 10 OTP messages to one mobile number in any 60 minutes. It counts messages sent, a resend included, and not OTPs generated. The message "Too many OTP requests. Please try again after <x> minutes." shows <x> from 1 to 60. The Open point on the limit is closed (Terms, Messages and limits, Use Cases 1.1, 1.2, Open points, Decision 16). |
---

# [PRD] Driver Login, Duty Start & End

**Systems:** Rider app (new, no Context) · Driver Management · Communications (the OTP message; Context holds customer notices only) · **Verticals:** Hyperlocal Forward, Hyperlocal Reverse

**Contents**

- [1. Objective](#1-objective)
- [2. Why Now](#2-why-now)
- [3. Use Cases](#3-use-cases)
  - [Use Case 1: Log in and out of the rider app](#use-case-1-log-in-and-out-of-the-rider-app)
  - [Use Case 2: Go on and off duty](#use-case-2-go-on-and-off-duty)
  - [Side effects](#side-effects)
  - [Open points](#open-points)
- [4. Metrics](#4-metrics)
- [5. Rollout & Stage Gates](#5-rollout--stage-gates)
- [6. Decisions](#6-decisions)

## 1. Objective

Every Last mile or Both driver created in Driver Management logs in to the rider app on the first attempt, and the System knows at every moment which of them are on duty.

## 2. Why Now

Shipsy handles Truemeds' rider creation, rider allocation, the rider's flow in the app, and tracking and reporting today. Leadership has decided to build the rider app in house and end the dependency on Shipsy. Drivers are created in the Hyperlocal Fleet Management Portal (Driver Management), but the in-house rider app does not exist yet: no driver can log in, and the System has no record of who is on duty. None of this is measured today.

Every later part of the rider app starts here. An order cannot appear in a driver's app, or be given to a driver, until the driver is logged in and on duty. Automated allocation needs to know who is on duty, and attendance and payout need the start and end of each duty. Serving locations grow from 39 to 150 in the next 15 months, and the first cutover location cannot cut over until its drivers can log in and go on duty.

## 3. Use Cases

This PRD adds two things to the rider app: login and logout with an OTP (Use Case 1), and going on and off duty with a swipe (Use Case 2). It applies to every driver of type Last mile or Both, in both verticals. A Mid mile driver does not use the rider app, which is for last-mile work. Creating drivers is in the Driver Management PRD. The portal, order assignment and the rest of the home screen are not in this PRD.

**Terms**

- A driver is a person created in Driver Management. Only a driver whose type is Last mile or Both can use the rider app. The driver's mobile number there is the number the driver logs in with. It is unique across drivers.
- An OTP is a 4-digit code the System sends to a mobile number by SMS, in the same template as the customer app. A number has one OTP at a time. It is valid for 30 minutes from the moment the System generates it, and it works once. There is no limit on wrong OTPs.
- The System sends an OTP in two cases. When a driver selects "Next" on the number screen for a number that has no valid, unused OTP, it generates a new OTP and sends it. When a driver selects "Resend OTP", it sends the number's OTP again if that OTP is still valid and unused, and the 30 minutes do not start again; if the OTP has expired, been used or stopped working, it generates a new OTP and sends it. "Resend OTP" can be selected 10 seconds after the last send. The System never resends by itself. Selecting "Next" for a number whose OTP is valid and unused sends nothing (Use Case 1.4, Step 7).
- The OTP request limit is 10 OTP messages to one mobile number in any 60 minutes. It counts each message the System sends, a resend included, and not the OTPs it generates. A message the System failed to send does not count (Use Case 1.5).
- A driver is logged in on one phone at a time. A login never expires. It ends when the driver logs out (Use Case 1.6) or logs in on another phone (Use Case 1.7).
- A driver is on duty or off duty. A new driver is off duty. The duty status belongs to the driver: logging in, logging out and logging in on another phone do not change it.
- The System records the time of every duty start and end from its own clock, when it receives the swipe. A duty is a start and, once the driver ends it, an end. Going on duty again after ending a duty starts a new duty. A duty can cross midnight.

**Messages and limits**

- A message in quotes is shown on the screen. A message about the mobile number or the OTP shows under that field.
- The OTP length, the OTP validity time, the resend wait and the OTP request limit are fixed values.
- In "Too many OTP requests. Please try again after <x> minutes.", <x> is the minutes left until the System can send the number an OTP again, rounded up to whole minutes, from 1 to 60.

### Use Case 1: Log in and out of the rider app

Who: a driver of type Last mile or Both. Precondition: the driver is created in Driver Management.

Login is three screens, each asking one thing: the welcome screen, the number screen and the OTP screen. The number screen and the OTP screen have a back arrow that goes back one screen and keeps what the driver typed. The phone's number keypad opens on both. There is no sign-up: a driver is created in Driver Management.

#### Use Case 1.1: Happy Case — a registered driver logs in

**Step 1:** Driver opens the rider app, logged out.

**Step 2:** System shows the welcome screen with the button "Log in".

**Step 3:** Driver selects "Log in". System shows the number screen: the heading "What's your mobile number?", the fixed prefix "+91", the field "Mobile number", the button "Next" and a back arrow to the welcome screen. The number keypad opens.

**Step 4:** Driver enters their mobile number and selects "Next".

**Step 5:** System checks the number (Use Case 1.2). All checks pass.

**Step 6:** System generates an OTP for the number, sends it and shows the OTP screen: the heading "Enter your OTP", the line "We sent an OTP to <mobile number>. Resend OTP in <n> seconds" with <n> counting down from 10, the field "OTP", the button "Next" and a back arrow to the number screen. The number keypad opens. When this is the 10th OTP message to the number in the last 60 minutes, the line has no "Resend OTP" (Use Case 1.4, Step 5). When the number already has an OTP that is valid and unused, System sends nothing and shows this screen (Use Case 1.4, Step 7).

**Step 7:** Driver enters the OTP and selects "Next".

**Step 8:** System checks the OTP (Use Case 1.3). A driver of type Last mile or Both still has the number, and the code matches the number's OTP, which has not been used and has not expired.

**Step 9:** System logs the driver in, logs out any other phone the driver is logged in on (Use Case 1.7), and shows the home screen with the driver's duty status (Use Case 2).

Result: the driver is logged in on this phone. The OTP is used and cannot be used again.

#### Use Case 1.2: Edge Case — the mobile number fails a check

**Step 1:** Driver selects "Next" on the number screen.

**Step 2:** System finds that a check fails.

**Step 3:** System sends no OTP, stays on the number screen, keeps the number and shows the message under the field:

| Check that fails | Message |
|---|---|
| The mobile number is empty, or is not 10 digits starting with 6, 7, 8 or 9 (spaces are ignored) | "Enter a valid 10-digit mobile number." |
| No driver has this mobile number, or the driver's type is Mid mile | "This number is not registered. Please register yourself at a Truemeds Hub." |
| An OTP is about to be sent, and the System has already sent this number 10 OTP messages in the last 60 minutes | "Too many OTP requests. Please try again after <x> minutes." |

**Step 4:** Driver corrects the number and selects "Next" again. For a number that is not registered, a user whose role holds Driver management creates the driver (Driver Management PRD, Use Case 2) first.

#### Use Case 1.3: Edge Case — the OTP is wrong or expired

**Step 1:** Driver selects "Next" on the OTP screen.

**Step 2:** System finds that a check fails. System checks in this order: the number, the driver's type, expiry, the code.

**Step 3:** System does not log the driver in. It stays on the OTP screen and shows the message under the field "OTP":

| Check that fails | Message | What System does |
|---|---|---|
| No driver has this mobile number any more, or the driver's type is Mid mile now: a user changed it after the OTP was sent | "This number is not registered. Please register yourself at a Truemeds Hub." | The OTP stops working |
| 30 minutes have passed since the OTP was generated | "OTP Expired. Request Again." | The OTP stops working |
| The code does not match the number's OTP, or the OTP was already used | "Incorrect OTP. Try again." | Nothing else. The driver can enter an OTP again, with no limit, until the OTP expires |

**Step 4:** Driver enters the OTP again, or asks for the OTP again (Use Case 1.4).

#### Use Case 1.4: Edge Case — the driver needs the OTP again

**Step 1:** The driver did not receive the OTP, typed another number, or the OTP expired or stopped working (Use Case 1.3).

**Step 2:** Driver waits until "Resend OTP in <n> seconds" in the line under the heading reaches zero, 10 seconds after the last send. "Resend OTP" is then selectable. Selecting it earlier does nothing.

**Step 3:** Driver selects "Resend OTP".

**Step 4:** System checks the number and the OTP request limit (Use Case 1.2). When both pass: if the number's OTP is still valid and unused, System sends the same OTP again, and the 30 minutes do not start again. If the OTP has expired, been used or stopped working, System generates a new OTP and sends it, and its 30 minutes start. The 10 seconds start again.

**Step 5:** When a check fails, System sends no OTP and shows the message from Use Case 1.2 under the field "OTP". The limit message shows here only when the number was asked for from another phone since the last send, because the screen shows no "Resend OTP" once the last send the limit allows is made. Driver can ask for an OTP again after the <x> minutes in the message. A driver who sees "OTP Expired. Request Again." on a screen with no "Resend OTP" selects the back arrow and then "Next" (Step 7).

**Step 6:** A driver who typed another number selects the back arrow. System shows the number screen with the number kept.

**Step 7:** Driver corrects the number and selects "Next". System checks the number (Use Case 1.2). If the number's OTP is valid and unused, System sends nothing and shows the OTP screen, with the wait counted from the last send: the OTP is sent again only by "Resend OTP". Otherwise System checks the OTP request limit (Use Case 1.2), generates a new OTP and sends it.

#### Use Case 1.5: Edge Case — the OTP cannot be sent or the System cannot be reached

**Step 1:** Driver selects "Next" on the number screen or the OTP screen, or "Resend OTP".

**Step 2:** System cannot send the OTP, or the phone cannot reach the System.

**Step 3:** The app stays on the same screen with what the driver entered and shows:

| When | Message |
|---|---|
| The System fails to send the OTP | "We couldn't send the OTP. Try again." |
| The phone cannot reach the System | "No internet connection. Connect and try again." |

**Step 4:** Driver selects the button again. An OTP the System failed to send does not count towards the OTP request limit.

#### Use Case 1.6: Happy Case — a driver logs out

**Step 1:** A logged-in driver selects "Log out" on the home screen.

**Step 2:** System logs the driver out on this phone and shows the welcome screen (Use Case 1.1, Step 2).

**Step 3:** When the phone cannot reach the System, Step 2 does not happen: the driver stays logged in and the screen shows "No internet connection. Connect and try again." (Use Case 1.5). The driver selects "Log out" again once connected.

Result: the phone is logged out. The duty status does not change: a driver who logs out while on duty stays on duty.

#### Use Case 1.7: Edge Case — the driver logs in on a second phone

**Step 1:** The driver is logged in on phone A and logs in on phone B (Use Case 1.1).

**Step 2:** System logs phone A out immediately after phone B is logged in, in the same step. From that moment phone A cannot act as the driver.

**Step 3:** Phone A shows the welcome screen as soon as it can be told: at once when it is open and connected, otherwise the next time it is opened and reaches the System. The welcome screen is the same as always, with no message. A swipe made on phone A after phone B logged in is not recorded.

**Step 4:** Phone B shows the duty status the driver had. The login changed nothing.

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

**Step 5:** When the driver opens the app and the phone cannot reach the System, the home screen shows the last duty status the phone received, with the swipe control for it. A swipe then follows Steps 3 and 4. When the phone reaches the System, it follows Use Case 1.7 if the driver has logged in on another phone since.

#### Use Case 2.4: Edge Case — the screen is out of date

**Step 1:** Driver swipes to go on duty, but the System already holds the driver as on duty: an earlier swipe reached the System after the screen showed off duty, or the driver swiped twice.

**Step 2:** System changes nothing, keeps the first duty start and shows "You are already on duty." The screen then shows the on-duty home screen (Use Case 2.1, Step 4).

**Step 3:** The same applies to a swipe to go off duty when the driver is already off duty: "You are already off duty." The screen then shows the off-duty home screen (Use Case 2.2, Step 4).

#### Use Case 2.5: Edge Case — the driver does not end the duty

**Step 1:** The shift is over and the driver does not swipe to go off duty.

**Step 2:** System does not end the duty. It stays open, across midnight and across days. The next time the driver opens the app, the home screen shows "You are on duty." with the duty start, and the driver can swipe to go off duty (Use Case 2.2). The System records the duty end at that swipe.

**Step 3:** Nobody is told. In this release nobody notices an open duty, and no one else can end it, except that a change of the driver's type to Mid mile takes the driver off duty (Side effects). What happens next is an Open point.

### Side effects

- Later features read the duty status: allocation treats an on-duty driver as available, and attendance and payout use the start and end of each duty. This PRD records the status and the times only.
- Showing who is on duty in the portal, a user confirming each driver is accounted for, confirming the device and vehicle at duty start, and attendance reports are not in this PRD.
- When order assignment ships, it decides what happens when a driver ends duty with orders in hand. Nothing in this PRD stops it.
- A change in Driver Management applies from the next login. A changed mobile number is the number the driver logs in with from then on, and a driver already logged in stays logged in, because a login never expires. A change of the driver's hub does not change the duty status.
- A driver whose type is changed to Mid mile is taken off duty, and the phone shows the welcome screen at its next action, with no message. The driver can log in again only after the type is Last mile or Both.
- When suspension and exit ship in Driver Management, a suspended or exited driver must not log in or go on duty, and must be logged out and taken off duty. That is not in this PRD.
- Each login costs one OTP SMS, and each resend costs one more. The cost of an SMS is not known.

### Open points

| Question | Decides |
|---|---|
| What happens to a duty the driver never ends: does it end by itself at a set time or after a set length, or does a portal user end it, and who is told? | Tejas |

## 4. Metrics

| Metric Type | Metric | Definition |
|---|---|---|
| Success | First-attempt login success | OTPs generated whose first code entered is accepted ÷ OTPs generated against which at least one code is entered |
| Success | Duty swipes recorded | Swipes to go on or off duty completed in the app after which the System holds the duty status the swipe asked for ÷ swipes to go on or off duty completed in the app |
| Lead | Time to log in | Median time from a driver selecting "Next" on the number screen to being logged in, for completed logins |
| Lead | OTP messages sent per login | OTP messages sent ÷ logins completed |
| Lead | Numbers rejected on the number screen | "Next" selections on the number screen rejected because no driver has the number, or the driver's type is Mid mile ÷ all "Next" selections on the number screen |
| Check | Logins outside the rules | Count of logins completed with a mobile number that no driver has, with a Mid mile driver's number, or with an OTP that was already used, had expired or did not match |
| Check | OTP messages that fail to send | OTP sends that fail ÷ OTP sends |
| Check | Drivers logged in on more than one phone | Count of drivers with more than one phone logged in at the same moment |
| Check | Duty starts on an open duty | Swipes to go on duty received while the driver is on duty ÷ swipes to go on duty received |
| Check | Duty records out of order | Count of duty ends with no open duty, and of drivers with more than one open duty |

## 5. Rollout & Stage Gates

| Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria |
|---|---|---|---|---|
| 1 | Prove login and duty with a few drivers | A user whose role holds Driver management creates a few Last mile drivers of the first cutover location in the portal. They log in to the rider app and swipe on and off duty. No order is involved. How many drivers is not yet decided. | First-attempt login success: target to be set from baseline. Duty swipes recorded: target to be set from baseline. | Logins outside the rules: any. OTP messages that fail to send: threshold not yet set. Drivers logged in on more than one phone: any. Duty starts on an open duty: threshold not yet set. Duty records out of order: any. |
| 2 | Every driver of the first cutover location | The Last mile and Both drivers of the location, created in Driver Management before cutover, log in and go on and off duty each day. Shipsy still handles orders. | Same as Stage 1. | Same as Stage 1. |
| 3 | Every cutover location | Each location's drivers log in and go on duty from the location's cutover. | Same as Stage 1. | Same as Stage 1. |

## 6. Decisions

| # | Decision | Where in this PRD |
|---|---|---|
| 1 | A driver logs in with the mobile number held in Driver Management and an OTP. Only a driver whose type is Last mile or Both can log in: the rider app is for last-mile work. | Terms, Use Cases 1.2, 1.3 |
| 2 | The System sends an OTP only to a number that belongs to a Last mile or Both driver. Any other number, a Mid mile driver's included, gets "This number is not registered. Please register yourself at a Truemeds Hub." and no OTP. | Use Cases 1.2, 1.3 |
| 3 | The OTP has 4 digits and is valid for 30 minutes from when the System generates it. It goes by SMS, in the same template as the customer app. A number has one OTP at a time, and an OTP works once. | Terms, Use Cases 1.1, 1.4 |
| 4 | A driver can select "Resend OTP" 10 seconds after the last send. While the number's OTP is valid and unused, a resend sends the same OTP and the 30 minutes do not start again. After the OTP has expired, been used or stopped working, a request generates a new OTP. Selecting "Next" for a number whose OTP is valid and unused sends nothing. | Terms, Use Case 1.4 |
| 5 | There is no limit on wrong OTPs. Each wrong OTP is rejected until the OTP expires. | Terms, Use Case 1.3 |
| 6 | An OTP the System failed to send does not count towards the OTP request limit. | Use Case 1.5 |
| 7 | A login never expires. The driver logs out with "Log out", and logging out does not change the duty status. | Terms, Use Case 1.6 |
| 8 | A driver is logged in on one phone at a time. A login on a second phone logs out the first immediately. | Terms, Use Case 1.7 |
| 9 | The duty status belongs to the driver. Logging in and logging out do not change it. | Terms |
| 10 | The System records the duty start and end from its own clock when it receives the swipe. No duty is recorded without a connection in this release. | Terms, Use Case 2.3 |
| 11 | The System never ends a duty by itself in this release, except when a driver's type is changed to Mid mile. A duty the driver forgot is an Open point. | Use Case 2.5, Side effects |
| 12 | A duty can cross midnight. There is no end of day. | Terms, Use Case 2.5 |
| 13 | Not in this PRD: the portal view of who is on duty, a user confirming each driver is accounted for, confirming the device and vehicle at duty start, and attendance reports. Attendance Tracking and Device Assignment are separate initiatives. | Side effects |
| 14 | Login is three screens: a welcome screen, a number screen and an OTP screen. The welcome screen has one button, "Log in", and no sign-up, because a driver is created in Driver Management. The number screen and the OTP screen have "Next" and a back arrow, which replaces "Change number". | Use Cases 1, 1.1, 1.4 |
| 15 | The welcome screen is the same every time and never shows a message, including after a login on another phone or a change of the driver's type to Mid mile. | Use Cases 1.6, 1.7, Side effects |
| 16 | The OTP request limit counts OTP messages sent, a resend included, not OTPs generated, because messages are what cost money and what can flood a driver's phone. It is 10 per mobile number in any 60 minutes. | Terms, Use Cases 1.1, 1.2, 1.4 |
