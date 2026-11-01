---
**Document:** User Management: Portal Access
**Type:** Executable PRD
**Version:** v6
**Date:** 2026-11-02
**Status:** Under Review
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-11-01 | Initial draft |
| v2 | 2026-11-01 | DCs carry a Physical or Virtual tag. Virtual DCs are never listed or selectable, and nobody can be given access to one. |
| v3 | 2026-11-01 | The tag is required when a DC is created, so the no-tag case is removed. |
| v4 | 2026-11-01 | Why Now no longer explains virtual DCs. The definition stays in the Use Cases. |
| v5 | 2026-11-01 | Eligible domains named (Truemeds, ANKW, ISPL). Location message shortened. Access admin has no automatic locations, stated in Use Case 2. Sign-out and 3-hour configurable session length with automatic sign-out added (Use Cases 1.4, 1.5). Access removal is checked at sign-in only (Use Cases 1.2, 4.1). |
| v6 | 2026-11-02 | The portal is named: Hyperlocal Fleet Management Portal. It shows on the sign-in screen and in the top bar. |
---

# [PRD] User Management: Portal Access

**Systems:** User Management (new, no Context) · **Verticals:** Hyperlocal Forward, Hyperlocal Reverse

## 1. Objective

Every ops user who has been given access signs in to the portal on the first attempt and sees only the serving locations assigned to them.

## 2. Why Now

Dispatchers, DC Executives, Team Leads and other ops users will work in the in-house portal every day. The portal is new. Nothing lets these users sign in, and nothing limits which serving locations each person can see. The impact is not measured: this is a new build with no baseline.

The first cutover location needs its ops users in the portal before any other portal screen can be used. Every later portal screen depends on knowing who the user is and which serving locations they can see. Until this ships, no other portal screen can be built or tested with real users.

## 3. Use Cases

The portal is called the Hyperlocal Fleet Management Portal. The sign-in screen and the top bar of every signed-in screen show this name. This PRD applies to every ops user of the portal, in both verticals. Drivers sign in to the rider app, not the portal; that is out of scope here. This PRD assumes the warehouses and DCs already exist from network setup, and that every DC carries a tag, Physical or Virtual. A Virtual DC has no physical location. It exists only in the path configuration. Warehouses carry no tag.

In this PRD, a serving location is a warehouse or a DC tagged Physical. A Virtual DC is never shown in any list or choice, and nobody can be given access to it.

There are no roles in this PRD. A signed-in user can do everything the portal offers for the locations on their list. The one exception is the Users screen, which only an access admin can open (Use Case 2).

### Use Case 1: Sign in

#### Use Case 1.1: Happy Case — an onboarded user signs in

Precondition: the user's email is onboarded (Use Case 2).

**Step 1:** User opens the portal.

**Step 2:** System shows the sign-in screen with one button, "Sign in with Google".

**Step 3:** User selects "Sign in with Google" and chooses their company Google account.

**Step 4:** Google confirms the user's email to the System.

**Step 5:** System looks for that email in the onboarded list, ignoring letter case.

**Step 6:** System finds the email, signs the user in and starts the session (Use Case 1.5).

**Step 7:** System opens the home screen. It shows the user's email and the serving locations on their list (Use Case 5).

Result: the user is signed in and sees only their serving locations.

#### Use Case 1.2: Edge Case — the email is not onboarded, or its access was removed

**Step 1:** User opens the portal.

**Step 2:** System shows the sign-in screen with one button, "Sign in with Google".

**Step 3:** User selects "Sign in with Google" and chooses a Google account.

**Step 4:** Google confirms the email to the System.

**Step 5:** System looks for the email in the onboarded list, ignoring letter case, and does not find it. The email was never onboarded, or its access was removed.

**Step 6:** System does not sign the user in. It stays on the sign-in screen and shows: "You don't have access to the portal. Ask Central Logistics Ops to add your email."

**Step 7:** User asks Central Logistics Ops. An access admin onboards the email (Use Case 2.1). The user signs in again (Use Case 1.1).

Note: a Google account on a domain that is not eligible (Use Case 2.2) is treated the same way.

#### Use Case 1.3: Edge Case — Google sign-in fails, is cancelled, or the Google account is no longer active

**Step 1:** User selects "Sign in with Google".

**Step 2:** The Google sign-in is cancelled, fails or is unavailable, or Google refuses the account because it is no longer active.

**Step 3:** System keeps the user on the sign-in screen and shows: "We couldn't sign you in with Google. Try again."

**Step 4:** User selects "Sign in with Google" again.

#### Use Case 1.4: Happy Case — a user signs out

**Step 1:** A signed-in user selects "Sign out" in the portal.

**Step 2:** System ends the session and shows the sign-in screen with the button "Sign in with Google".

#### Use Case 1.5: Edge Case — the session reaches its length

| Parameter | Definition | Value |
|---|---|---|
| Session length | Time from sign-in until the System signs the user out. Activity does not extend it. | 3 hours at launch. Configurable: engineering changes it in configuration. The portal has no screen for it. |

**Step 1:** User signs in (Use Case 1.1). System starts the session.

**Step 2:** The session length passes.

**Step 3:** System ends the session, whether or not the user is still working.

**Step 4:** System shows the sign-in screen with: "Your session has ended. Sign in again."

**Step 5:** User selects "Sign in with Google" (Use Case 1.1). Anything the user had not saved, such as a form being filled, is lost.

### Use Case 2: Onboard an email

Who: an access admin, who is a Central Logistics Ops user. Engineering adds the first few users, including the first access admins, directly in the system. Until then nobody can open the Users screen.

Note: the "Access admin" setting only lets a person open the Users screen. It gives no access to any location. An access admin has locations like any other user: at least one location, or "All locations". The Users screen lists every onboarded email, and the form offers every serving location, whatever the admin's own locations.

#### Use Case 2.1: Happy Case — an access admin adds an email

**Step 1:** Access admin signs in (Use Case 1.1) and selects "Users" in the menu.

**Step 2:** System shows the Users list: one row per onboarded email, with columns Email, Locations and Access admin.

**Step 3:** Access admin selects "Add user".

**Step 4:** System shows a form with: Email; Locations, a list of every warehouse and every DC tagged Physical, with a checkbox each, plus an "All locations" option; an "Access admin" checkbox; and the buttons "Save" and "Cancel".

**Step 5:** Access admin enters the email.

**Step 6:** Access admin ticks one or more locations, or selects "All locations".

**Step 7:** Access admin ticks "Access admin" only if the person must manage users.

**Step 8:** Access admin selects "Save".

**Step 9:** System checks the email, its domain and the locations (see Use Case 2.2).

**Step 10:** All checks pass. System saves the email and its locations, returns to the Users list and shows "<email> added."

Result: the email can sign in (Use Case 1.1) and sees only the locations saved.

#### Use Case 2.2: Edge Case — the form fails a check

**Step 1:** Access admin signs in and selects "Users".

**Step 2:** System shows the Users list.

**Step 3:** Access admin selects "Add user".

**Step 4:** System shows the form.

**Step 5:** Access admin fills in the form and selects "Save".

**Step 6:** System finds that a check fails.

**Step 7:** System saves nothing, keeps the form open and shows the message for the failed check:

| Check that fails | Message |
|---|---|
| The email is malformed, or is not on an eligible domain: Truemeds, ANKW or ISPL | "Enter a valid company email address." |
| The email is already onboarded (emails that differ only in letter case are the same email) | "This email already has access. Edit it from the Users list." |
| No location is ticked and "All locations" is not selected | "Choose at least one location." |

**Step 8:** Access admin corrects the form and selects "Save" again.

#### Use Case 2.3: Edge Case — a user who is not an access admin opens Users

**Step 1:** A user who is not an access admin signs in. System does not show "Users" in their menu.

**Step 2:** The user opens the Users address directly, for example from a saved link.

**Step 3:** System does not show the Users list. It shows: "You don't have access to this page."

### Use Case 3: Change an email's locations or access admin setting

#### Use Case 3.1: Happy Case — an access admin edits an email

**Step 1:** Access admin signs in and selects "Users". System shows the Users list.

**Step 2:** Access admin selects "Edit" on the email's row.

**Step 3:** System shows the form from Use Case 2.1, with the email read-only and the saved locations and access admin setting filled in.

**Step 4:** Access admin adds or removes locations, or switches to or from "All locations".

**Step 5:** Access admin changes the "Access admin" checkbox if the person's need to manage users has changed.

**Step 6:** Access admin selects "Save".

**Step 7:** System checks that at least one location or "All locations" remains.

**Step 8:** System saves, returns to the Users list and shows "<email> updated."

**Step 9:** The change applies on that user's next action in the portal.

#### Use Case 3.2: Edge Case — no location left

**Step 1:** Access admin signs in and selects "Users". System shows the Users list.

**Step 2:** Access admin selects "Edit" on the email's row. System shows the form.

**Step 3:** Access admin clears every location, does not select "All locations", and selects "Save".

**Step 4:** System saves nothing, keeps the form open and shows: "Choose at least one location."

### Use Case 4: Remove an email's access

#### Use Case 4.1: Happy Case — an access admin removes an email

**Step 1:** Access admin signs in and selects "Users". System shows the Users list.

**Step 2:** Access admin selects "Remove access" on the email's row.

**Step 3:** System removes the email from the onboarded list and shows "<email> removed."

**Step 4:** A user who is signed in when their access is removed keeps working until their session ends, at most the session length (Use Case 1.5).

**Step 5:** The user's next sign-in with Google follows Use Case 1.2. An access admin can onboard the email again (Use Case 2.1).

Note: the System never removes access by itself, and it does not alert anyone when a leaver's access is still active. Central Logistics Ops removes the email when the person leaves.

### Use Case 5: See only the locations on your list

#### Use Case 5.1: Happy Case — a signed-in user sees their locations

**Step 1:** User signs in (Use Case 1.1).

**Step 2:** System reads the user's saved locations.

**Step 3.A:** The user has a list of locations. System shows those locations on the home screen, by name, and no others.

**Step 3.B:** The user has "All locations". System shows every warehouse and every DC tagged Physical.

**Step 4:** Every portal screen that shows data about a serving location, other than the Users screen, shows it only for the locations in Step 3.

Result: the user never sees data from a serving location outside their access.

#### Use Case 5.2: Edge Case — a serving location is created, or a DC becomes Physical, after the user was onboarded

**Step 1.A:** Network setup creates a warehouse or a DC tagged Physical.

**Step 1.B:** Network setup changes a DC's tag from Virtual to Physical.

**Step 2:** A user with "All locations" sees it on their next page load.

**Step 3:** A user with a list of locations does not see it until an access admin adds it (Use Case 3.1). A user who needs it asks Central Logistics Ops.

#### Use Case 5.3: Edge Case — the user opens a location that is not on their list

**Step 1:** User opens a page for a serving location that is not on their list, or for a Virtual DC, for example from a saved link.

**Step 2:** System shows no data for that location. It shows: "You don't have access to this location."

#### Use Case 5.4: Edge Case — a DC is tagged Virtual

**Step 1:** Central Logistics Ops creates a DC in network setup and tags it Virtual, for example "Mumbai DC".

**Step 2:** System does not show the DC in the Locations list on the Add user and Edit forms.

**Step 3:** System does not show the DC on any home screen, including for users with "All locations".

**Step 4:** An access admin cannot give anyone access to the DC.

Note: not yet defined are how a deactivated serving location appears on the home screen, what a user's saved list does when a DC changes from Physical to Virtual, and which warehouse's users see data that belongs to a Virtual DC, such as an order whose configured path names it.

### Side effects

- Until roles exist, any user can do everything the portal offers for their locations, including actions meant for one role, such as a Team Lead suspending a driver or Finance approving cash.
- If the last access admin is removed or loses the "Access admin" setting, engineering adds an access admin directly in the system.
- Every later portal screen that shows location data must follow Use Case 5.
- Central Logistics Ops takes on all onboarding, editing and removal of users.
- Network setup must require the Physical or Virtual tag when a DC is created, and every existing DC must already carry one. Assumes this is in place before implementation.

### Open points

| Question | Decides |
|---|---|
| What are the exact email domains for Truemeds, ANKW and ISPL? | Tejas |

## 4. Metrics

| Metric Type | Metric | Definition |
|---|---|---|
| Success | First-attempt sign-in success | Onboarded emails whose first sign-in attempt after onboarding reaches the portal ÷ onboarded emails with at least one sign-in attempt after onboarding |
| Success | Users who can see a location they were not tagged to | Count of distinct emails shown data of a serving location outside their access (their list, or every location if they have "All locations") |
| Lead | Sign-in attempts rejected as not onboarded | Sign-in attempts rejected because the email is not onboarded ÷ all sign-in attempts |
| Check | Access removal holds | Removed emails that sign in successfully while still removed ÷ removed emails |
| Check | New locations reach "All locations" users | "All locations" users who do not see a new serving location on their next page load after it is created ÷ "All locations" users |

## 5. Rollout & Stage Gates

| Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria |
|---|---|---|---|---|
| 1 | Prove sign-in and location scoping with a few users | Engineering adds the first few emails directly in the system, including the access admins from Central Logistics Ops, each with their locations. Those users sign in. How many users is not yet decided. | First-attempt sign-in success: target to be set from baseline. Users who can see a location they were not tagged to: 0. | Access removal holds: threshold not yet set. New locations reach "All locations" users: threshold not yet set. |
| 2 | Onboarding without engineering | Central Logistics Ops adds the users of each location through the Users screen as the location cuts over. Engineering stops adding users. | First-attempt sign-in success: target to be set from baseline. Users who can see a location they were not tagged to: 0. | Access removal holds: threshold not yet set. New locations reach "All locations" users: threshold not yet set. |

## 6. Worked Examples

**Example 1: Central Logistics Ops onboards a Dispatcher, who signs in (Use Cases 2.1 and 1.1)**

*Scenario:* Ananya adds Ravi, who works at two locations.

*Starting state (illustrative):* ananya.sharma@truemeds.in is an access admin with "All locations". ravi.kulkarni@truemeds.in is not onboarded.

*Steps:*
1. Ananya opens Users and selects "Add user".
2. She enters ravi.kulkarni@truemeds.in, ticks "Pune DC" and "Pune Warehouse", leaves "Access admin" unticked and selects "Save".
3. System shows "ravi.kulkarni@truemeds.in added."
4. Ravi opens the portal, selects "Sign in with Google" and chooses his company account.
5. System opens the home screen.

*Result:* Ravi sees Pune DC and Pune Warehouse only. His menu has no "Users".

**Example 2: A user signs in before being onboarded (Use Case 1.2)**

*Scenario:* Ravi tries to sign in on his first day before Ananya has added him.

*Starting state (illustrative):* ravi.kulkarni@truemeds.in is not onboarded.

*Steps:*
1. Ravi selects "Sign in with Google" and chooses his company account.
2. System does not find the email and shows "You don't have access to the portal. Ask Central Logistics Ops to add your email."
3. Ravi asks Ananya, who adds him with Pune DC and Pune Warehouse.
4. Ravi signs in again.

*Result:* the second attempt opens the home screen.

**Example 3: A new location reaches an "All locations" user (Use Case 5.2)**

*Scenario:* Network setup creates "Nashik DC" and tags it Physical.

*Starting state (illustrative):* meera.nair@truemeds.in has "All locations". ravi.kulkarni@truemeds.in has Pune DC and Pune Warehouse.

*Steps:*
1. Network setup creates "Nashik DC" tagged Physical.
2. Meera reloads the home screen.
3. Ravi reloads the home screen.

*Result:* Meera sees Nashik DC. Ravi does not, until an access admin adds it to his list (Use Case 3.1).

**Example 4: Access is removed while the user is signed in (Use Cases 4.1 and 1.5)**

*Scenario:* Ananya removes Ravi while he is working.

*Starting state (illustrative):* Ravi signed in at 10:00. The session length is 3 hours.

*Steps:*
1. Ananya opens Users and selects "Remove access" on Ravi's row.
2. System shows "ravi.kulkarni@truemeds.in removed."
3. Ravi keeps working.
4. At 13:00 the session length passes. System ends his session and shows "Your session has ended. Sign in again."
5. Ravi selects "Sign in with Google" and chooses his company account.
6. System does not find the email and shows "You don't have access to the portal. Ask Central Logistics Ops to add your email."

*Result:* Ravi worked until 13:00 and cannot sign in again until an access admin adds him.

**Example 5: A Virtual DC is never offered (Use Cases 5.4 and 5.3)**

*Scenario:* Mumbai WH dispatches straight to customers. "Mumbai DC" exists only in the path configuration.

*Starting state (illustrative):* "Mumbai Bhiwandi Warehouse" is a warehouse. "Mumbai DC" is a DC tagged Virtual. "Pune DC" is a DC tagged Physical. meera.nair@truemeds.in has "All locations".

*Steps:*
1. Ananya opens Users, selects "Add user" and looks at the Locations list.
2. Meera opens the home screen.
3. A user opens a saved link to Mumbai DC.

*Result:* The Locations list and Meera's home screen show Mumbai Bhiwandi Warehouse and Pune DC, and not Mumbai DC. The saved link shows "You don't have access to this location."

**Example 6: An access admin changes a user's locations (Use Cases 3.1 and 3.2)**

*Scenario:* Ananya adds a location for Suresh, then tries to clear his list.

*Starting state (illustrative):* suresh.patil@truemeds.in has "Mumbai Andheri DC".

*Steps:*
1. Ananya opens Users and selects "Edit" on Suresh's row.
2. She ticks "Thane DC" and selects "Save".
3. System shows "suresh.patil@truemeds.in updated." Suresh sees Mumbai Andheri DC and Thane DC from his next action.
4. Ananya selects "Edit" again, clears both locations and selects "Save".
5. System saves nothing, keeps the form open and shows "Choose at least one location."

*Result:* Suresh keeps Mumbai Andheri DC and Thane DC.

## 7. Ops SOPs

| SOP | Step or role affected | Change | Owner | Readiness needed |
|---|---|---|---|---|
| Portal access for joiners, movers and leavers (not yet filed) | Whenever someone joins a location, changes location or leaves | Central Logistics Ops adds, edits or removes the person's email on the Users screen | Central Logistics Ops | Access admins trained on the Users screen before Stage 2 |
| DC tagging (not yet filed) | Whenever a DC is created, or changes between virtual and real | Central Logistics Ops chooses Physical or Virtual when creating the DC, and changes it when the DC becomes real or virtual | Central Logistics Ops | Tag required in network setup before Stage 1 |
| First users (not yet filed) | Before launch | Engineering adds the first few emails, including the access admins, directly in the system | Engineering | Done before Stage 1 |
