---
**Document:** User Management
**Type:** Executable PRD
**Version:** v12
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
| v7 | 2026-11-02 | Roles added: eight roles, one per email. Access admin is a privilege of a role, not a setting on an email. Only Admin adds roles and sets which role holds Access admin (new Use Case 6). Serving locations move from the home screen to a dropdown in the top bar, and the home screen is blank (Use Cases 1.1, 5). The "not onboarded" message is shortened. Use Case 1.5 (session length) is removed. |
| v8 | 2026-11-02 | Only an Admin can give the Admin role, and only an Admin can edit or remove an email whose role is Admin (new Use Case 2.4). |
| v9 | 2026-11-02 | A removed user keeps working until they sign out: accepted, so the open point is closed. Use Case 4.1 is unchanged. |
| v10 | 2026-11-02 | Table of contents added after the title block. No other change. |
| v11 | 2026-11-02 | The document is renamed from "User Management: Portal Access" to "User Management". No other change. |
| v12 | 2026-11-02 | A user whose access is removed is signed out on their next action, not left working until they sign out (Use Cases 4.1 Step 4, new 4.2). The Access removal metric counts actions as well as sign-ins. Worked Examples and Ops SOPs are removed. |
---

# [PRD] User Management

**Systems:** User Management (new, no Context) · **Verticals:** Hyperlocal Forward, Hyperlocal Reverse

**Contents**

- [1. Objective](#1-objective)
- [2. Why Now](#2-why-now)
- [3. Use Cases](#3-use-cases)
  - [Use Case 1: Sign in](#use-case-1-sign-in)
    - [Use Case 1.1: Happy Case — an onboarded user signs in](#use-case-11-happy-case--an-onboarded-user-signs-in)
    - [Use Case 1.2: Edge Case — the email is not onboarded, or its access was removed](#use-case-12-edge-case--the-email-is-not-onboarded-or-its-access-was-removed)
    - [Use Case 1.3: Edge Case — Google sign-in fails, is cancelled, or the Google account is no longer active](#use-case-13-edge-case--google-sign-in-fails-is-cancelled-or-the-google-account-is-no-longer-active)
    - [Use Case 1.4: Happy Case — a user signs out](#use-case-14-happy-case--a-user-signs-out)
  - [Use Case 2: Onboard an email](#use-case-2-onboard-an-email)
    - [Use Case 2.1: Happy Case — a user with Access admin adds an email](#use-case-21-happy-case--a-user-with-access-admin-adds-an-email)
    - [Use Case 2.2: Edge Case — the form fails a check](#use-case-22-edge-case--the-form-fails-a-check)
    - [Use Case 2.3: Edge Case — a user whose role does not hold Access admin opens Users](#use-case-23-edge-case--a-user-whose-role-does-not-hold-access-admin-opens-users)
    - [Use Case 2.4: Edge Case — a user whose role is not Admin works with the Admin role](#use-case-24-edge-case--a-user-whose-role-is-not-admin-works-with-the-admin-role)
  - [Use Case 3: Change an email's role or locations](#use-case-3-change-an-emails-role-or-locations)
    - [Use Case 3.1: Happy Case — a user with Access admin edits an email](#use-case-31-happy-case--a-user-with-access-admin-edits-an-email)
    - [Use Case 3.2: Edge Case — no location left](#use-case-32-edge-case--no-location-left)
  - [Use Case 4: Remove an email's access](#use-case-4-remove-an-emails-access)
    - [Use Case 4.1: Happy Case — a user with Access admin removes an email](#use-case-41-happy-case--a-user-with-access-admin-removes-an-email)
    - [Use Case 4.2: Edge Case — a signed-in user's access is removed](#use-case-42-edge-case--a-signed-in-users-access-is-removed)
  - [Use Case 5: See only the locations on your list](#use-case-5-see-only-the-locations-on-your-list)
    - [Use Case 5.1: Happy Case — a signed-in user sees the serving location dropdown](#use-case-51-happy-case--a-signed-in-user-sees-the-serving-location-dropdown)
    - [Use Case 5.2: Happy Case — a user switches to one location](#use-case-52-happy-case--a-user-switches-to-one-location)
    - [Use Case 5.3: Edge Case — a serving location is created, or a DC becomes Physical, after the user was onboarded](#use-case-53-edge-case--a-serving-location-is-created-or-a-dc-becomes-physical-after-the-user-was-onboarded)
    - [Use Case 5.4: Edge Case — the user opens a location that is not on their list](#use-case-54-edge-case--the-user-opens-a-location-that-is-not-on-their-list)
    - [Use Case 5.5: Edge Case — a DC is tagged Virtual](#use-case-55-edge-case--a-dc-is-tagged-virtual)
  - [Use Case 6: Manage roles](#use-case-6-manage-roles)
    - [Use Case 6.1: Happy Case — an Admin adds a role](#use-case-61-happy-case--an-admin-adds-a-role)
    - [Use Case 6.2: Edge Case — the role form fails a check](#use-case-62-edge-case--the-role-form-fails-a-check)
    - [Use Case 6.3: Happy Case — an Admin changes whether a role holds Access admin](#use-case-63-happy-case--an-admin-changes-whether-a-role-holds-access-admin)
    - [Use Case 6.4: Edge Case — a user who is not an Admin opens Roles](#use-case-64-edge-case--a-user-who-is-not-an-admin-opens-roles)
  - [Side effects](#side-effects)
  - [Open points](#open-points)
- [4. Metrics](#4-metrics)
- [5. Rollout & Stage Gates](#5-rollout--stage-gates)

## 1. Objective

Every ops user who has been given access signs in to the portal on the first attempt and sees only the serving locations assigned to them.

## 2. Why Now

Dispatchers, DC Executives, Team Leads, Finance and other ops users will work in the in-house portal every day, and the portal will differ by job from the start: Finance's will look very different from a Dispatcher's. The portal is new. Nothing lets these users sign in, nothing tells the portal which job a user does, and nothing limits which serving locations each person can see. The impact is not measured: this is a new build with no baseline.

The first cutover location needs its ops users in the portal before any other portal screen can be used. Every later portal screen depends on knowing who the user is, what role they hold and which serving locations they can see. Until this ships, no other portal screen can be built or tested with real users.

## 3. Use Cases

The portal is called the Hyperlocal Fleet Management Portal. The sign-in screen and the top bar of every signed-in screen show this name. This PRD applies to every ops user of the portal, in both verticals. Drivers sign in to the rider app, not the portal; that is out of scope here. This PRD assumes the warehouses and DCs already exist from network setup, and that every DC carries a tag, Physical or Virtual. A Virtual DC has no physical location. It exists only in the path configuration. Warehouses carry no tag.

In this PRD, a serving location is a warehouse or a DC tagged Physical. A Virtual DC is never shown in any list or choice, and nobody can be given access to it.

Every onboarded email has one role and a list of serving locations. "All locations" is a choice made when an email is onboarded: it gives access to every serving location, now and in future. "All serving locations" is a dropdown choice in the top bar that covers every location the user has access to (Use Case 5).

Access admin is a privilege that a role holds, not a setting on an email. A user whose role holds Access admin can open the Users screen and add, edit and remove emails (Use Cases 2 to 4). Only a user whose role is Admin can open the Roles screen, add roles and set which role holds Access admin (Use Case 6). Only an Admin can give the Admin role, and only an Admin can edit or remove an email whose role is Admin (Use Case 2.4). These are the only two screens in this PRD that depend on the role.

Engineering creates these roles before Stage 1:

| Role | Holds Access admin at launch |
|---|---|
| Dispatcher | No |
| DC Executive | No |
| Team Lead | Yes |
| Regional Manager | Yes |
| Central Logistics Ops | Yes |
| Control Tower | Yes |
| Finance | No |
| Admin | Yes |

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

**Step 9:** The menu shows "Users" if the user's role holds Access admin, and "Roles" if the user's role is Admin.

Result: the user is signed in and sees only their serving locations.

#### Use Case 1.2: Edge Case — the email is not onboarded, or its access was removed

**Step 1:** User opens the portal.

**Step 2:** System shows the sign-in screen with one button, "Sign in with Google".

**Step 3:** User selects "Sign in with Google" and chooses a Google account.

**Step 4:** Google confirms the email to the System.

**Step 5:** System looks for the email in the onboarded list, ignoring letter case, and does not find it. The email was never onboarded, or its access was removed.

**Step 6:** System does not sign the user in. It stays on the sign-in screen and shows: "You don't have access to the portal."

**Step 7:** User asks someone whose role holds Access admin. That person onboards the email (Use Case 2.1). The user signs in again (Use Case 1.1).

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

Note: Access admin only lets a person open the Users screen. It gives no access to any location. A user whose role holds it has locations like any other user: at least one location, or "All locations". The Users screen lists every onboarded email, and the form offers every serving location and every role, whatever the user's own locations. The exception is the Admin role (Use Case 2.4).

#### Use Case 2.1: Happy Case — a user with Access admin adds an email

**Step 1:** User with Access admin signs in (Use Case 1.1) and selects "Users" in the menu.

**Step 2:** System shows the Users list: one row per onboarded email, with columns Email, Role and Locations.

**Step 3:** User selects "Add user".

**Step 4:** System shows a form with: Email; Role, a list of every role (Use Case 2.4 for Admin); Locations, a list of every warehouse and every DC tagged Physical, with a checkbox each, plus an "All locations" option; and the buttons "Save" and "Cancel".

**Step 5:** User enters the email.

**Step 6:** User chooses the role.

**Step 7:** User ticks one or more locations, or selects "All locations".

**Step 8:** User selects "Save".

**Step 9:** System checks the email, its domain, the role and the locations (see Use Case 2.2).

**Step 10:** All checks pass. System saves the email, its role and its locations, returns to the Users list and shows "<email> added."

Result: the email can sign in (Use Case 1.1) and sees only the locations saved. Its role decides whether its menu has "Users" or "Roles".

#### Use Case 2.2: Edge Case — the form fails a check

**Step 1:** User with Access admin signs in and selects "Users".

**Step 2:** System shows the Users list.

**Step 3:** User selects "Add user".

**Step 4:** System shows the form.

**Step 5:** User fills in the form and selects "Save".

**Step 6:** System finds that a check fails.

**Step 7:** System saves nothing, keeps the form open and shows the message for the failed check:

| Check that fails | Message |
|---|---|
| The email is malformed, or is not on an eligible domain: Truemeds, ANKW or ISPL | "Enter a valid company email address." |
| The email is already onboarded (emails that differ only in letter case are the same email) | "This email already has access. Edit it from the Users list." |
| No role is chosen | "Choose a role." |
| No location is ticked and "All locations" is not selected | "Choose at least one location." |

**Step 8:** User corrects the form and selects "Save" again.

#### Use Case 2.3: Edge Case — a user whose role does not hold Access admin opens Users

**Step 1:** A user whose role does not hold Access admin signs in. System does not show "Users" in their menu.

**Step 2:** The user opens the Users address directly, for example from a saved link.

**Step 3:** System does not show the Users list. It shows: "You don't have access to this page."

#### Use Case 2.4: Edge Case — a user whose role is not Admin works with the Admin role

**Step 1:** A user whose role is not Admin signs in and selects "Users". System shows the Users list.

**Step 2:** System shows every email, including emails whose role is Admin. It does not show "Edit" or "Remove access" on a row whose role is Admin.

**Step 3:** User selects "Add user", or "Edit" on another row. System shows the form with every role in the Role list except Admin.

**Step 4:** The user cannot give the Admin role to an email, and cannot edit or remove an email whose role is Admin. If they try it another way, for example from a saved link, System refuses and shows: "You don't have access to this page."

Note: a user whose role is Admin sees every role and every row's actions.

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

**Step 9:** The change applies on that user's next action in the portal. A user whose new role does not hold Access admin loses "Users" in their menu, and their next action on the Users screen follows Use Case 2.3, Step 3.

#### Use Case 3.2: Edge Case — no location left

**Step 1:** User with Access admin signs in and selects "Users". System shows the Users list.

**Step 2:** User selects "Edit" on the email's row. System shows the form.

**Step 3:** User clears every location, does not select "All locations", and selects "Save".

**Step 4:** System saves nothing, keeps the form open and shows: "Choose at least one location."

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

**Step 3.C:** The user has "All locations". The dropdown lists "All serving locations" and then every warehouse and every DC tagged Physical. System selects "All serving locations".

**Step 4:** Every portal screen that shows data about a serving location, other than the Users screen, shows it for the selection. "All serving locations" covers all of the user's locations; any other choice covers that one location.

Result: the user never sees data from a serving location outside their access.

#### Use Case 5.2: Happy Case — a user switches to one location

**Step 1:** User opens the dropdown in the top bar. System shows the options from Use Case 5.1.

**Step 2:** User selects one location, for example "Pune DC".

**Step 3:** System shows data for Pune DC only on every screen described in Use Case 5.1, Step 4.

**Step 4:** User selects "All serving locations" to see all of their locations again.

Note: the selection stays as chosen on every screen until the user changes it or signs out. The next sign-in starts with the default from Use Case 5.1.

#### Use Case 5.3: Edge Case — a serving location is created, or a DC becomes Physical, after the user was onboarded

**Step 1.A:** Network setup creates a warehouse or a DC tagged Physical.

**Step 1.B:** Network setup changes a DC's tag from Virtual to Physical.

**Step 2:** A user with "All locations" sees it in the dropdown on their next page load.

**Step 3:** A user with a list of locations does not see it until a user with Access admin adds it (Use Case 3.1). A user who needs it asks someone whose role holds Access admin.

#### Use Case 5.4: Edge Case — the user opens a location that is not on their list

**Step 1:** User opens a page for a serving location that is not on their list, or for a Virtual DC, for example from a saved link.

**Step 2:** System shows no data for that location. It shows: "You don't have access to this location."

#### Use Case 5.5: Edge Case — a DC is tagged Virtual

**Step 1:** Central Logistics Ops creates a DC in network setup and tags it Virtual, for example "Mumbai DC".

**Step 2:** System does not show the DC in the Locations list on the Add user and Edit forms.

**Step 3:** System does not show the DC in the dropdown, including for users with "All locations".

**Step 4:** A user with Access admin cannot give anyone access to the DC.

Note: not yet defined are how a deactivated serving location appears in the dropdown, what a user's saved list does when a DC changes from Physical to Virtual, and which warehouse's users see data that belongs to a Virtual DC, such as an order whose configured path names it.

### Use Case 6: Manage roles

Who: a user whose role is Admin. Engineering adds the first Admins directly in the system.

#### Use Case 6.1: Happy Case — an Admin adds a role

**Step 1:** Admin signs in (Use Case 1.1) and selects "Roles" in the menu.

**Step 2:** System shows the Roles list: one row per role, with columns Role and Access admin (Yes or No).

**Step 3:** Admin selects "Add role".

**Step 4:** System shows a form with: Role name; an "Access admin" checkbox; and the buttons "Save" and "Cancel".

**Step 5:** Admin enters the role name.

**Step 6:** Admin ticks "Access admin" only if users with this role must manage users.

**Step 7:** Admin selects "Save".

**Step 8:** System checks the role name (see Use Case 6.2).

**Step 9:** The check passes. System saves the role, returns to the Roles list and shows "<role> added."

Result: a user with Access admin can choose the role when onboarding an email (Use Case 2.1).

#### Use Case 6.2: Edge Case — the role form fails a check

**Step 1:** Admin signs in, selects "Roles" and selects "Add role". System shows the form.

**Step 2:** Admin fills in the form and selects "Save".

**Step 3:** System saves nothing, keeps the form open and shows the message for the failed check:

| Check that fails | Message |
|---|---|
| The role name is empty | "Enter a role name." |
| The role already exists (role names that differ only in letter case are the same role) | "This role already exists." |

**Step 4:** Admin corrects the form and selects "Save" again.

#### Use Case 6.3: Happy Case — an Admin changes whether a role holds Access admin

**Step 1:** Admin signs in and selects "Roles". System shows the Roles list.

**Step 2:** Admin selects "Edit" on the role's row.

**Step 3:** System shows the form from Use Case 6.1, with the role name read-only and the saved Access admin setting filled in.

**Step 4:** Admin ticks or unticks "Access admin".

**Step 5:** Admin selects "Save".

**Step 6:** System saves, returns to the Roles list and shows "<role> updated."

**Step 7:** The change applies to every user with that role on their next action in the portal. A user whose role no longer holds Access admin loses "Users" in their menu, and their next action on the Users screen follows Use Case 2.3, Step 3.

#### Use Case 6.4: Edge Case — a user who is not an Admin opens Roles

**Step 1:** A user whose role is not Admin signs in. System does not show "Roles" in their menu.

**Step 2:** The user opens the Roles address directly, for example from a saved link.

**Step 3:** System does not show the Roles list. It shows: "You don't have access to this page."

Note: renaming and removing a role are not in this PRD.

### Side effects

- Role decides only who can open Users and who can open Roles. Until other PRDs set what each role can do on other screens, any user can use those screens for their locations, including actions meant for one role, such as a Team Lead suspending a driver or Finance approving cash. Every later portal screen must state which roles can open it.
- If the last user holding the Admin role is removed or changes role, engineering adds an Admin directly in the system.
- If an Admin switches Access admin off for every role, nobody can open Users until an Admin switches it on again on the Roles screen.
- Users with Access admin (Team Lead, Regional Manager, Central Logistics Ops, Control Tower and Admin at launch) take on all onboarding, editing and removal of users. Only Admins take on roles and everything to do with the Admin role.
- Every later portal screen that shows location data must follow Use Case 5.
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
| Check | Access removal holds | Removed emails that complete a sign-in or an action after the removal ÷ removed emails |
| Check | New locations reach "All locations" users | "All locations" users who do not see a new serving location in their dropdown on their next page load after it is created ÷ "All locations" users |
| Check | Users shown a screen their role does not allow | Count of distinct emails shown the Users list when their role does not hold Access admin, or the Roles list when their role is not Admin |
| Check | Admin role changed by a user who is not an Admin | Count of changes that give the Admin role to an email, or edit or remove an email whose role is Admin, made by a user whose role is not Admin |

## 5. Rollout & Stage Gates

| Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria |
|---|---|---|---|---|
| 1 | Prove sign-in, roles and location scoping with a few users | Engineering creates the eight roles and adds the first few emails directly in the system, including the Admins and users whose roles hold Access admin, each with a role and locations. Those users sign in. How many users is not yet decided. | First-attempt sign-in success: target to be set from baseline. Users who can see a location they were not tagged to: 0. | Access removal holds: threshold not yet set. New locations reach "All locations" users: threshold not yet set. Users shown a screen their role does not allow: threshold not yet set. Admin role changed by a user who is not an Admin: threshold not yet set. |
| 2 | Onboarding without engineering | Users with Access admin add the users of each location through the Users screen as the location cuts over. Engineering stops adding users. | First-attempt sign-in success: target to be set from baseline. Users who can see a location they were not tagged to: 0. | Access removal holds: threshold not yet set. New locations reach "All locations" users: threshold not yet set. Users shown a screen their role does not allow: threshold not yet set. Admin role changed by a user who is not an Admin: threshold not yet set. |
