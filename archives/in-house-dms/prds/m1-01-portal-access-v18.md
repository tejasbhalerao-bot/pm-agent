---
**Document:** User Management
**Type:** Executable PRD
**Version:** v18
**Date:** 2026-11-04
**Status:** Approved
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v18 | 2026-11-04 | There is no Virtual DC: every DC is a physical DC, so the Physical or Virtual tag and Use Case 5.5 are removed and a serving location is any warehouse or DC. The Team Lead and Dispatcher roles are removed and DC Executive is renamed Executive, so the six roles are ranked from Admin (1) to Executive (6) (Use Cases 2.4 and 2.5). Regional Manager is now the lowest role that holds Access admin. |
---

# [PRD] User Management

**Systems:** User Management (new, no Context) · **Verticals:** Hyperlocal Forward, Hyperlocal Reverse

**Contents**

- [1. Objective](#1-objective)
- [2. Why Now](#2-why-now)
- [3. Use Cases](#3-use-cases)
  - [Use Case 1: Sign in](#use-case-1-sign-in)
  - [Use Case 2: Onboard an email](#use-case-2-onboard-an-email)
  - [Use Case 3: Change an email's role or locations](#use-case-3-change-an-emails-role-or-locations)
  - [Use Case 4: Remove an email's access](#use-case-4-remove-an-emails-access)
  - [Use Case 5: See only the locations on your list](#use-case-5-see-only-the-locations-on-your-list)
  - [Use Case 6: See only the modules your role holds](#use-case-6-see-only-the-modules-your-role-holds)
  - [Side effects](#side-effects)
  - [Open points](#open-points)
- [4. Metrics](#4-metrics)
- [5. Rollout & Stage Gates](#5-rollout--stage-gates)

## 1. Objective

Every ops user who has been given access signs in to the portal on the first attempt, sees only the serving locations assigned to them and can open only the modules their role holds.

## 2. Why Now

Executives, Regional Managers, Finance and other ops users will work in the in-house portal every day, and the portal will differ by job from the start: Finance's will look very different from an Executive's. The portal is new. Nothing lets these users sign in, nothing tells the portal which job a user does, and nothing limits which serving locations each person can see or which parts of the portal they can open. The impact is not measured: this is a new build with no baseline.

The first cutover location needs its ops users in the portal before any other portal screen can be used. Every later portal screen depends on knowing who the user is, what role they hold and which serving locations they can see. Until this ships, no other portal screen can be built or tested with real users.

## 3. Use Cases

The portal is called the Hyperlocal Fleet Management Portal. The sign-in screen and the top bar of every signed-in screen show this name. This PRD applies to every ops user of the portal, in both verticals. Drivers sign in to the rider app, not the portal; that is out of scope here.

**Terms**

- A serving location is a warehouse or a DC. This PRD assumes the warehouses and DCs already exist from network setup.
- Every onboarded email has one role and a list of serving locations. "All locations" is a choice made when an email is onboarded: it gives access to every serving location, now and in future. "All serving locations" is a dropdown choice in the top bar that covers every location the user has access to (Use Case 5).
- A module is a part of the portal that has its own item in the menu. The modules at launch are Vendor management and Driver management. Users is not a module.

**Roles**

Roles are defined in the back end and fixed in the code. The portal has no screen to add, edit or remove a role. When a new role is needed, or a role needs different permissions, engineering makes the change. A role decides three things: whether its users can open the Users screen (Access admin), which modules they can open, and its rank, which decides which roles its users can onboard. Locations stay on the email, not on the role. Engineering creates these roles before Stage 1. Rank 1 is the highest, and a role is lower than another when its rank is a bigger number:

| Rank | Role | Holds Access admin | Modules |
|---|---|---|---|
| 1 | Admin | Yes | Vendor management, Driver management |
| 2 | Central Logistics Ops | Yes | Vendor management, Driver management |
| 3 | Control Tower | Yes | Vendor management, Driver management |
| 4 | Finance | No | None |
| 5 | Regional Manager | Yes | Vendor management, Driver management |
| 6 | Executive | No | Driver management |

**Rules**

- A user whose role holds Access admin can open the Users screen and add, edit and remove emails (Use Cases 2 to 4). Access admin gives no access to any location.
- A user can give an email only a role that is lower than their own role, and can edit or remove only an email whose role is lower than their own (Use Case 2.4). A user can remove their own access (Use Case 2.5).
- A user can give only locations they have themselves, and can edit or remove only emails whose locations are all within their own (Use Case 2.5).
- A user can open only the modules their role holds (Use Case 6). Users is the only other screen that depends on the role.

### Use Case 1: Sign in

#### Use Case 1.1: Happy Case — an onboarded user signs in

Precondition: the user's email is onboarded (Use Case 2).

**Step 1:** User opens the portal.

**Step 2:** System shows the sign-in screen with one button, "Sign in with Google".

**Step 3:** User selects "Sign in with Google" and chooses their company Google account.

**Step 4:** Google confirms the user's email to the System.

**Step 5:** System looks for that email in the onboarded list, ignoring letter case.

**Step 6:** System finds the email and signs the user in.

**Step 7:** System opens the home screen. The home screen is blank.

**Step 8:** The top bar shows the portal name and the serving location dropdown (Use Case 5.1).

**Step 9:** The menu shows each module the user's role holds (Use Case 6.1), and "Users" if the user's role holds Access admin.

#### Use Case 1.2: Edge Case — the email is not onboarded, or its access was removed

**Step 1:** User opens the portal. System shows the sign-in screen with one button, "Sign in with Google".

**Step 2:** User selects "Sign in with Google" and chooses a Google account. Google confirms the email to the System.

**Step 3:** System looks for the email in the onboarded list, ignoring letter case, and does not find it. The email was never onboarded, or its access was removed.

**Step 4:** System does not sign the user in. It stays on the sign-in screen and shows: "You don't have access to the portal."

**Step 5:** User asks someone whose role holds Access admin. That person onboards the email (Use Case 2.1). The user signs in again (Use Case 1.1).

Note: a Google account on a domain that is not eligible (Use Case 2.2) is treated the same way.

#### Use Case 1.3: Edge Case — Google sign-in fails, is cancelled, or the Google account is no longer active

**Step 1:** User selects "Sign in with Google".

**Step 2:** The Google sign-in is cancelled, fails or is unavailable, or Google refuses the account because it is no longer active.

**Step 3:** System keeps the user on the sign-in screen and shows: "We couldn't sign you in with Google. Try again."

**Step 4:** User selects "Sign in with Google" again.

#### Use Case 1.4: Happy Case — a user signs out

**Step 1:** A signed-in user selects "Sign out" in the portal.

**Step 2:** System signs the user out and shows the sign-in screen with the button "Sign in with Google".

### Use Case 2: Onboard an email

Who: a user whose role holds Access admin. Engineering adds the first few users, including the first Admins, directly in the system. Until then nobody can open the Users screen.

Note: a user whose role holds Access admin has locations like any other user: at least one location, or "All locations". The Users screen lists every onboarded email.

#### Use Case 2.1: Happy Case — a user with Access admin adds an email

**Step 1:** User with Access admin signs in (Use Case 1.1) and selects "Users" in the menu.

**Step 2:** System shows the Users list: one row per onboarded email, with columns Email, Role and Locations.

**Step 3:** User selects "Add user".

**Step 4:** System shows a form with: Email; Role, a list of the roles that are lower than the user's own role (Use Case 2.4); Locations, a list of the warehouses and DCs on the user's own list, with a checkbox each, plus an "All locations" option only if the user has "All locations" (Use Case 2.5); and the buttons "Save" and "Cancel".

**Step 5:** User enters the email.

**Step 6:** User chooses the role.

**Step 7:** User ticks one or more locations, or selects "All locations".

**Step 8:** User selects "Save".

**Step 9:** System checks the email, its domain, the role and the locations (see Use Case 2.2).

**Step 10:** All checks pass. System saves the email, its role and its locations, returns to the Users list and shows "<email> added."

#### Use Case 2.2: Edge Case — the form fails a check

**Step 1:** User with Access admin signs in, selects "Users" and then "Add user". System shows the form.

**Step 2:** User fills in the form and selects "Save".

**Step 3:** System finds that a check fails.

**Step 4:** System saves nothing, keeps the form open and shows the message for the failed check:

| Check that fails | Message |
|---|---|
| The email is malformed, or is not on an eligible domain: Truemeds, ANKW or ISPL | "Enter a valid company email address." |
| The email is already onboarded (emails that differ only in letter case are the same email) | "This email already has access. Edit it from the Users list." |
| No role is chosen | "Choose a role." |
| No location is ticked and "All locations" is not selected | "Choose at least one location." |

**Step 5:** User corrects the form and selects "Save" again.

#### Use Case 2.3: Edge Case — a user whose role does not hold Access admin opens Users

**Step 1:** A user whose role does not hold Access admin signs in. System does not show "Users" in their menu.

**Step 2:** The user opens the Users address directly, for example from a saved link.

**Step 3:** System does not show the Users list. It shows: "You don't have access to this page."

#### Use Case 2.4: Edge Case — a user works with a role that is not lower than their own

**Step 1:** A user with Access admin signs in and selects "Users". System shows the Users list.

**Step 2:** System shows every email. It does not show "Edit" or "Remove access" on a row whose role is not lower than the user's own role (the table in Use Case 2.5).

**Step 3:** User selects "Add user", or "Edit" on a row that has it. System shows the form with only the roles lower than the user's own role in the Role list, as the table below says.

**Step 4:** The user cannot give a role that is not lower than their own, and cannot edit or remove an email whose role is not lower than their own. If they try it another way, for example from a saved link, System refuses and shows: "You don't have access to this page."

The roles a user can give at launch:

| The user's role | Roles the user can give |
|---|---|
| Admin | Central Logistics Ops, Control Tower, Finance, Regional Manager, Executive |
| Central Logistics Ops | Control Tower, Finance, Regional Manager, Executive |
| Control Tower | Finance, Regional Manager, Executive |
| Regional Manager | Executive |

Note: no role is higher than Admin, so nobody can give the Admin role, or edit or remove another Admin, in the portal. Engineering does that directly in the system (Side effects).

#### Use Case 2.5: Edge Case — a user works with locations outside their own

**Step 1:** User with Access admin signs in and selects "Users". System shows the Users list with every email.

**Step 2:** System shows "Edit" and "Remove access" on a row only as the table below says. A button shows only when no row of the table hides it.

| The email's row | Edit | Remove access |
|---|---|---|
| Every location on the email is on the user's own list | Shown | Shown |
| Any location on the email is outside the user's own list | Not shown | Not shown |
| The email has "All locations" and the user does not | Not shown | Not shown |
| It is the user's own row | Not shown | Shown |
| The email's role is not lower than the user's own role, and it is not the user's own row (Use Case 2.4) | Not shown | Not shown |

**Step 3:** User selects "Add user", or "Edit" on a row. System shows the form with only the locations on the user's own list, and the "All locations" option only if the user has "All locations".

**Step 4:** The user cannot give a location they do not have, cannot edit or remove an email that has a location outside their own, and cannot edit their own row. If they try it another way, for example from a saved link, System refuses and shows: "You don't have access to this page."

Note: a user with "All locations" has every warehouse and every DC on their own list.

### Use Case 3: Change an email's role or locations

#### Use Case 3.1: Happy Case — a user with Access admin edits an email

**Step 1:** User with Access admin signs in and selects "Users". System shows the Users list.

**Step 2:** User selects "Edit" on the email's row.

**Step 3:** System shows the form from Use Case 2.1, with the email read-only and the saved role and locations filled in.

**Step 4:** User changes the role if the person's job has changed.

**Step 5:** User adds or removes locations, or switches to or from "All locations".

**Step 6:** User selects "Save".

**Step 7:** System checks that a role is chosen and that at least one location or "All locations" remains.

**Step 8:** System saves, returns to the Users list and shows "<email> updated."

**Step 9:** The change applies on that user's next action in the portal (Use Case 6.3).

#### Use Case 3.2: Edge Case — no location left

**Step 1:** User with Access admin signs in, selects "Users" and selects "Edit" on the email's row. System shows the form.

**Step 2:** User clears every location, does not select "All locations", and selects "Save".

**Step 3:** System saves nothing, keeps the form open and shows: "Choose at least one location."

### Use Case 4: Remove an email's access

#### Use Case 4.1: Happy Case — a user with Access admin removes an email

**Step 1:** User with Access admin signs in and selects "Users". System shows the Users list.

**Step 2:** User selects "Remove access" on the email's row.

**Step 3:** System removes the email from the onboarded list and shows "<email> removed."

**Step 4:** A user who is signed in when their access is removed is signed out on their next action (Use Case 4.2).

**Step 5:** The user's next sign-in with Google follows Use Case 1.2. A user with Access admin can onboard the email again (Use Case 2.1).

Note: the System never removes access by itself, and it does not alert anyone when a leaver's access is still active. A user with Access admin removes the email when the person leaves.

#### Use Case 4.2: Edge Case — a signed-in user's access is removed

**Step 1:** A user with Access admin removes an email (Use Case 4.1) while its user is signed in.

**Step 2:** The removed user takes an action in the portal, such as opening a screen or selecting a button.

**Step 3:** System looks for the email in the onboarded list and does not find it. It signs the user out and shows the sign-in screen with: "You don't have access to the portal."

**Step 4:** Anything the user had not saved, such as a form being filled, is lost.

**Step 5:** The user can sign in again only after a user with Access admin onboards the email (Use Case 2.1).

### Use Case 5: See only the locations on your list

#### Use Case 5.1: Happy Case — a signed-in user sees the serving location dropdown

**Step 1:** User signs in (Use Case 1.1).

**Step 2:** System reads the user's saved locations.

**Step 3.A:** The user has one location. The top bar dropdown lists that location by name, and no other. System selects it.

**Step 3.B:** The user has a list of two or more locations. The dropdown lists "All serving locations" and then each location by name, and no others. System selects "All serving locations".

**Step 3.C:** The user has "All locations". The dropdown lists "All serving locations" and then every warehouse and every DC. System selects "All serving locations".

**Step 4:** Every portal screen that shows data about a serving location, other than the Users screen, shows it for the selection. "All serving locations" covers all of the user's locations; any other choice covers that one location.

#### Use Case 5.2: Happy Case — a user switches to one location

**Step 1:** User opens the dropdown in the top bar. System shows the options from Use Case 5.1.

**Step 2:** User selects one location, for example "Pune DC".

**Step 3:** System shows data for Pune DC only on every screen described in Use Case 5.1, Step 4.

**Step 4:** User selects "All serving locations" to see all of their locations again.

Note: the selection stays as chosen on every screen until the user changes it or signs out. The next sign-in starts with the default from Use Case 5.1.

#### Use Case 5.3: Edge Case — a serving location is created after the user was onboarded

**Step 1:** Network setup creates a warehouse or a DC.

**Step 2:** A user with "All locations" sees it in the dropdown on their next page load.

**Step 3:** A user with a list of locations does not see it until a user with Access admin who has it adds it (Use Case 3.1). A user who needs it asks such a user.

Note: how a deactivated serving location appears in the dropdown is not yet defined.

#### Use Case 5.4: Edge Case — the user opens a location that is not on their list

**Step 1:** User opens a page for a serving location that is not on their list, for example from a saved link.

**Step 2:** System shows no data for that location. It shows: "You don't have access to this location."

### Use Case 6: See only the modules your role holds

#### Use Case 6.1: Happy Case — a signed-in user sees the modules their role holds

**Step 1:** User signs in (Use Case 1.1).

**Step 2:** System reads the user's role and the modules the role holds.

**Step 3:** The menu lists "Home", then each module the role holds in the order Vendor management, Driver management, then "Users" if the role holds Access admin (Use Case 1.1). It lists no module the role does not hold.

**Step 4:** User selects a module in the menu. System opens it.

**Step 5:** Inside the module, the user sees data only for the serving locations on their own list (Use Case 5).

#### Use Case 6.2: Edge Case — the user opens a module their role does not hold

**Step 1:** User opens a module's address directly, for example from a saved link, and their role does not hold the module.

**Step 2:** System does not show the module. It shows: "You don't have access to this page."

**Step 3:** System refuses any action in the module the same way.

#### Use Case 6.3: Edge Case — a user's role or its modules change while the user is signed in

**Step 1.A:** A user with Access admin changes the email's role (Use Case 3.1).

**Step 1.B:** Engineering changes what a role holds in the back end: its modules, or Access admin.

**Step 2:** The user takes an action in the portal, such as opening a screen or selecting a button.

**Step 3:** System reads the user's role and its modules again. The menu shows the new set from this action. A user whose role no longer holds Access admin loses "Users", and their next action on the Users screen follows Use Case 2.3, Step 3.

**Step 4:** If the user is in a module the role no longer holds, System shows "You don't have access to this page." Anything the user had not saved in that module is lost.

### Side effects

- A role decides who can open Users and which modules a user can open. Inside a module, any user whose role holds it can do everything in it for their locations, including actions meant for one job, such as a Regional Manager suspending a driver or Finance approving cash. Which actions a role can take inside a module is not in this PRD.
- Every later PRD that adds a module says which roles hold it at launch, and engineering adds it to those roles.
- A role can hold no module, as Finance does at launch: its users see Home only, plus Users if the role holds Access admin.
- A module decides which screen a user can open. It does not hide records another module needs: for example, the driver form lists vendors for a user whose role does not hold Vendor management.
- Roles are not changed in the portal. A request for a new role, or for different permissions on a role, goes to engineering.
- If the last user holding the Admin role is removed or changes role, engineering adds an Admin directly in the system.
- Users with Access admin take on onboarding, editing and removal of users for the roles below their own, within their own locations. A Regional Manager can add only Executives, so a new Regional Manager is onboarded by a user ranked above Regional Manager.
- Nobody can give the Admin role, or edit or remove another Admin, in the portal. Engineering does it directly in the system. An Admin can remove their own access.
- A person who works in more than one region, or moves between regions, can be changed only by a user whose locations cover them all, such as a user with "All locations".
- Every later portal screen that shows location data must follow Use Case 5.

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
| Check | Access removal holds | Removed emails that complete a sign-in or an action after the removal ÷ removed emails |
| Check | New locations reach "All locations" users | "All locations" users who do not see a new serving location in their dropdown on their next page load after it is created ÷ "All locations" users |
| Check | Users shown a screen their role does not allow | Count of distinct emails shown the Users list when their role does not hold Access admin, or a module when their role does not hold it |
| Check | Roles given or changed outside the ladder | Count of changes (add, edit or remove) made by a user to an email whose role, before or after the change, is not lower than the user's own role, not counting a user removing their own access |
| Check | Locations changed outside the user's own | Count of changes to an email (add, edit or remove) made by a user whose own locations do not cover every location on the email, before and after the change |

## 5. Rollout & Stage Gates

| Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria |
|---|---|---|---|---|
| 1 | Prove sign-in, roles and location scoping with a few users | Engineering creates the six roles in the back end, each with its modules, and adds the first few emails directly in the system, including the Admins and users whose roles hold Access admin, each with a role and locations. The Admins hold "All locations". Those users sign in. How many users is not yet decided. | First-attempt sign-in success: target to be set from baseline. Users who can see a location they were not tagged to: 0. | Access removal holds: threshold not yet set. New locations reach "All locations" users: threshold not yet set. Users shown a screen their role does not allow: threshold not yet set. Roles given or changed outside the ladder: threshold not yet set. Locations changed outside the user's own: threshold not yet set. |
| 2 | Onboarding without engineering | Users with Access admin add the users of each location through the Users screen as the location cuts over, each with a role lower than their own. Engineering stops adding users, except Admins. | Same as Stage 1. | Same as Stage 1. |
