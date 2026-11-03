---
**Document:** Driver Management
**Type:** Executable PRD
**Version:** v11
**Date:** 2026-11-03
**Status:** Under Review
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-11-03 | Initial draft |
| v2 | 2026-11-03 | Review comments applied. A vendor or vehicle category can be created for several hubs at once, with a Review screen; deleting asks for confirmation. A driver's hub is chosen first, and the vendor and vehicle category are limited to that hub. Pincodes are added and removed by a CSV file with Insert and Delete actions; valid rows are used and errors can be downloaded; blacklisting is removed. The driver list gains Vendor and Vehicle category columns, filters and a page size; Status is removed. The change saved last is kept. The open points are settled. |
| v3 | 2026-11-03 | A driver's hub can be changed (new Use Case 5.4). The user also chooses a vendor and a vehicle category of the new hub and uploads the pincodes the new hub serves. The hub is shown on Location details. No open points remain. |
| v4 | 2026-11-03 | Pincode rows are processed in the order of the file. An Insert of a pincode the driver already serves, a Delete of one it does not serve, and a repeated row with the same action are ignored without an error. A repeated row with a different action is performed. |
| v5 | 2026-11-03 | The Vendor and Vehicle category filters list each name once, for example "Bike" and "Scooter", not each name with its hub. A filter matches the drivers tagged to any vendor or vehicle category of that name at the hubs the dropdown covers. |
| v6 | 2026-11-03 | A vehicle category is no longer tagged to a hub. Vehicle management is one list for every user and can only create a category: there is no edit, no delete and no review screen. A driver can be tagged to any vehicle category. The hub change no longer asks for a vehicle category. The vehicle category filter lists every category. |
| v7 | 2026-11-03 | A vehicle category can be edited again (new Use Case 2.3): the user changes its name and every driver tagged to it shows the new name. A vehicle category still cannot be deleted. |
| v8 | 2026-11-03 | A vendor's hub can be changed while no driver is tagged to the vendor (Use Cases 1.3 and 1.7). The Hubs list on the create vendor form has an "All locations" checkbox that ticks every hub on the user's own list. |
| v9 | 2026-11-03 | Each tab is a module. A user sees and opens only the tabs whose module their role holds (new Use Case 6, from the User Management PRD). "Every role can use them" is removed. Every role holds all three modules at launch. |
| v10 | 2026-11-03 | A vendor is one record that works at one or more hubs, not one record for each hub. Edit has the same Hubs list as create, so hubs can be added and removed; a hub with drivers tagged to the vendor cannot be unticked. The vendor name is unique across the System. A user changes only hubs on their own list. A refusal of an action, such as deleting a vendor that has drivers, shows as a toast. |
| v11 | 2026-11-03 | The tabs each role holds at launch are set: Dispatcher and DC Executive hold Driver management; Team Lead adds Vendor management; Regional Manager, Central Logistics Ops and Control Tower add Vehicle management; Finance holds none; Admin holds all. "Every role holds all three" is removed. The two messages that said "Create one in Vendor management" and "Create one in Vehicle management" now tell the user to ask a user who has the module, because a Dispatcher or DC Executive creates drivers but not vendors or vehicle categories. |
---

# [PRD] Driver Management

**Systems:** Driver Management (new, no Context) · User Management · **Verticals:** Hyperlocal Forward, Hyperlocal Reverse

**Contents**

- [1. Objective](#1-objective)
- [2. Why Now](#2-why-now)
- [3. Use Cases](#3-use-cases)
  - [Use Case 1: Vendor management](#use-case-1-vendor-management)
    - [Use Case 1.1: Happy Case — a user creates a vendor](#use-case-11-happy-case--a-user-creates-a-vendor)
    - [Use Case 1.2: Edge Case — the vendor form fails a check](#use-case-12-edge-case--the-vendor-form-fails-a-check)
    - [Use Case 1.3: Happy Case — a user edits a vendor's name or hubs](#use-case-13-happy-case--a-user-edits-a-vendors-name-or-hubs)
    - [Use Case 1.4: Happy Case — a user deletes a vendor that has no driver](#use-case-14-happy-case--a-user-deletes-a-vendor-that-has-no-driver)
    - [Use Case 1.5: Edge Case — a vendor that has drivers cannot be deleted](#use-case-15-edge-case--a-vendor-that-has-drivers-cannot-be-deleted)
    - [Use Case 1.6: Edge Case — the vendor was deleted by someone else](#use-case-16-edge-case--the-vendor-was-deleted-by-someone-else)
    - [Use Case 1.7: Edge Case — a hub is given drivers while the form is open](#use-case-17-edge-case--a-hub-is-given-drivers-while-the-form-is-open)
  - [Use Case 2: Vehicle management](#use-case-2-vehicle-management)
    - [Use Case 2.1: Happy Case — a user creates a vehicle category](#use-case-21-happy-case--a-user-creates-a-vehicle-category)
    - [Use Case 2.2: Edge Case — the vehicle category form fails a check](#use-case-22-edge-case--the-vehicle-category-form-fails-a-check)
    - [Use Case 2.3: Happy Case — a user edits a vehicle category's name](#use-case-23-happy-case--a-user-edits-a-vehicle-categorys-name)
  - [Use Case 3: Create a driver](#use-case-3-create-a-driver)
    - [Use Case 3.1: Happy Case — a user creates a driver](#use-case-31-happy-case--a-user-creates-a-driver)
    - [Use Case 3.2: Edge Case — a field on page 1 or page 2 fails a check](#use-case-32-edge-case--a-field-on-page-1-or-page-2-fails-a-check)
    - [Use Case 3.3: Edge Case — the pincode file has errors](#use-case-33-edge-case--the-pincode-file-has-errors)
    - [Use Case 3.4: Edge Case — there is no vendor or vehicle category to choose](#use-case-34-edge-case--there-is-no-vendor-or-vehicle-category-to-choose)
    - [Use Case 3.5: Edge Case — something changes before "Create driver"](#use-case-35-edge-case--something-changes-before-create-driver)
    - [Use Case 3.6: Edge Case — the user moves between pages, cancels or leaves](#use-case-36-edge-case--the-user-moves-between-pages-cancels-or-leaves)
  - [Use Case 4: See and find drivers](#use-case-4-see-and-find-drivers)
    - [Use Case 4.1: Happy Case — a user opens Driver management](#use-case-41-happy-case--a-user-opens-driver-management)
    - [Use Case 4.2: Happy Case — a user searches and filters](#use-case-42-happy-case--a-user-searches-and-filters)
    - [Use Case 4.3: Edge Case — no driver to show](#use-case-43-edge-case--no-driver-to-show)
    - [Use Case 4.4: Edge Case — the user opens a driver of a hub that is not on their list](#use-case-44-edge-case--the-user-opens-a-driver-of-a-hub-that-is-not-on-their-list)
  - [Use Case 5: Edit a driver](#use-case-5-edit-a-driver)
    - [Use Case 5.1: Happy Case — a user opens a driver's profile](#use-case-51-happy-case--a-user-opens-a-drivers-profile)
    - [Use Case 5.2: Happy Case — a user edits Driver details, Vehicle details or Engagement details](#use-case-52-happy-case--a-user-edits-driver-details-vehicle-details-or-engagement-details)
    - [Use Case 5.3: Happy Case — a user adds and removes pincodes](#use-case-53-happy-case--a-user-adds-and-removes-pincodes)
    - [Use Case 5.4: Happy Case — a user changes a driver's hub](#use-case-54-happy-case--a-user-changes-a-drivers-hub)
    - [Use Case 5.5: Edge Case — an edit fails a check](#use-case-55-edge-case--an-edit-fails-a-check)
    - [Use Case 5.6: Edge Case — two users change the same driver](#use-case-56-edge-case--two-users-change-the-same-driver)
  - [Use Case 6: Module access](#use-case-6-module-access)
    - [Use Case 6.1: Happy Case — a user sees the tabs their role holds](#use-case-61-happy-case--a-user-sees-the-tabs-their-role-holds)
    - [Use Case 6.2: Edge Case — the user opens a tab their role does not hold](#use-case-62-edge-case--the-user-opens-a-tab-their-role-does-not-hold)
  - [Side effects](#side-effects)
- [4. Metrics](#4-metrics)
- [5. Rollout & Stage Gates](#5-rollout--stage-gates)

## 1. Objective

Every driver who works from a hub is in the System, with a vendor, a vehicle and the pincodes they serve, before they take their first order.

## 2. Why Now

Shipsy holds Truemeds' riders today. The in-house system has nowhere to create a driver, to record which vendor the driver comes from and which vehicle they use, or to say which pincodes they serve. No driver can use the in-house rider app, and no order can be given to a driver, until the driver is in the System with this information. How long it takes to create a driver, and how many are set up correctly, is not measured.

The first cutover location needs all of its drivers in the System before it cuts over from Shipsy. Serving locations grow from 39 to 150 in the next 15 months, so drivers will be created at every location as it cuts over. Until this ships, nothing that depends on a driver can be built or tested: driver login, order assignment, allocation and payouts.

## 3. Use Cases

This PRD adds three tabs to the Hyperlocal Fleet Management Portal: Vendor management, Vehicle management and Driver management. Each tab is a module of the portal. A role's modules are set on the Roles screen (User Management PRD). It applies to every ops user whose role holds the module, in both verticals. The rider app is out of scope.

In this PRD, a hub is a serving location: a warehouse or a DC tagged Physical (see User Management). A user's own list is the list of hubs set for their email in User Management. A user with "All locations" has every hub on their own list.

- The drivers list shows only drivers of hubs on the user's own list, narrowed by the serving location dropdown in the top bar: all of the user's hubs when "All serving locations" is selected, otherwise the one hub selected. The vendors list shows a vendor that works at a hub the dropdown covers, and shows only the hubs of the vendor that are on the user's own list. The vehicle categories list is the same for every user: it shows every vehicle category, whatever the dropdown says.
- A Hub field on a form offers only the hubs on the user's own list.
- After a create or an edit of a vendor or a driver, the message shows even when none of the record's hubs is covered by the dropdown. The record then does not show in the list.
- The menu shows a tab only if the user's role holds its module, and a user can open only those tabs (Use Case 6). The roles hold the tabs in the table in Use Case 6.1 at launch, and an Admin can change them on the Roles screen. Inside a tab, the System does not restrict by role: any user who can open it can do everything in it for their hubs.
- A vendor is the company a driver works through. A vendor is one record that works at one or more hubs, and its name is unique across the System. A vehicle category is the type of vehicle a driver uses, for example a bike or a van. A vehicle category belongs to no hub: it is one list for all hubs, and a driver of any hub can be tagged to any of them.
- A user can add or remove only hubs on their own list. The hubs of a vendor that are outside the user's own list are not shown to them and stay as they are when the user edits the vendor. A user can delete a vendor only when every hub of the vendor is on their own list.
- A driver belongs to one hub and can be tagged only to a vendor that works at that hub. It can be tagged to any vehicle category.
- The System gives every driver a unique driver ID. It never changes and is never given to another driver.
- When two users change the same record or field at the same time, the change the System saves last is the one kept.
- A message in quotes is shown on the screen. A message about a field shows under the field. A message that refuses an action, such as deleting a vendor that has drivers, shows as a toast that clears after about 4 seconds. A message with <name> shows the name of the record.
- The limits in this PRD are fixed values: 100 characters for a name, 1 MB and 2,000 rows for a file, and 10, 20, 50 or 100 drivers to a page.

### Use Case 1: Vendor management

Who: any user whose role holds Vendor management and who has at least one hub on their own list.

#### Use Case 1.1: Happy Case — a user creates a vendor

**Step 1:** User selects "Vendor management" in the menu.

**Step 2:** System shows the vendors list: one row per vendor, with columns Vendor and Hubs, and the button "Create new vendor". A row shows the hubs of the vendor that are on the user's own list, and the buttons "Edit" and "Delete". "Delete" shows only when every hub of the vendor is on the user's own list.

**Step 3:** User selects "Create new vendor".

**Step 4:** System shows a form with: Vendor name; Hubs, a checkbox "All locations" followed by a checkbox for each hub on the user's own list; and the buttons "Review" and "Cancel".

**Step 5:** User enters the vendor's name and ticks one or more hubs, or ticks "All locations".

**Step 6:** User selects "Review".

**Step 7:** System checks the name and the hubs (see Use Case 1.2).

**Step 8:** All checks pass. System shows the review screen with the vendor name and the hubs ticked, and the buttons "Back" and "Submit".

**Step 9:** User checks the screen and selects "Submit". "Back" returns to the form with what the user entered kept.

**Step 10:** System checks again (see Use Case 1.2). All checks pass. System creates the vendor with the hubs ticked, returns to the vendors list and shows "<vendor> added."

Note: Ticking "All locations" ticks every hub on the user's own list, and unticking it unticks them all. It shows ticked while every hub is ticked, and unticks itself when any hub is unticked.

Result: the vendor can be chosen on the driver form (Use Case 3) for drivers of each of its hubs.

#### Use Case 1.2: Edge Case — the vendor form fails a check

**Step 1:** User selects "Review" on the form (Use Case 1.1), or "Submit" on the review screen or on the edit form (Use Case 1.3).

**Step 2:** System saves the name without leading and trailing spaces and finds that a check fails.

**Step 3:** System saves nothing, shows the form with what the user typed, and shows the message for each failed check under its field:

| Check that fails | Message |
|---|---|
| The vendor name is empty | "Enter the vendor's name." |
| The vendor name is longer than 100 characters | "Vendor name can have at most 100 characters." |
| The vendor would work at no hub: no hub is ticked, and the vendor has no hub outside the user's own list | "Choose at least one hub." |
| Another vendor has this name. Names that differ only in letter case or extra spaces are the same name. | "A vendor with this name already exists." |

**Step 4:** User corrects the form and selects "Review" or "Submit" again.

Note: the name is unique across the System, including vendors at hubs the user cannot see (Side effects).

#### Use Case 1.3: Happy Case — a user edits a vendor's name or hubs

**Step 1:** User selects "Vendor management". System shows the vendors list.

**Step 2:** User selects "Edit" next to the vendor.

**Step 3:** System shows the form with the name filled in and the Hubs list as on the create form, with the hubs the vendor works at ticked. A hub where a driver is tagged to this vendor stays ticked and cannot be unticked. When there is one, System shows under Hubs: "A hub with drivers tagged to this vendor can't be unticked."

**Step 4:** User changes the name, and ticks or unticks hubs. Unticking "All locations" unticks every hub that can be unticked. User selects "Submit".

**Step 5:** System checks the name and the hubs (see Use Case 1.2), and checks again that no hub unticked has a driver tagged to this vendor (see Use Case 1.7).

**Step 6:** System saves the name and the hubs. The hubs of the vendor that are not on the user's own list stay as they are. Every driver tagged to this vendor shows the new name from this moment.

**Step 7:** System returns to the vendors list and shows "<vendor> updated."

Result: the vendor can be chosen on the driver form for drivers of each of its hubs now, and no longer for drivers of a hub that was unticked.

#### Use Case 1.4: Happy Case — a user deletes a vendor that has no driver

**Step 1:** User selects "Vendor management". System shows the vendors list.

**Step 2:** User selects "Delete" next to the vendor.

**Step 3:** System checks that no driver is tagged to the vendor.

**Step 4:** No driver is tagged. System shows the confirmation "Delete <vendor>? This can't be undone." with the buttons "Delete" and "Cancel".

**Step 5:** User selects "Delete".

**Step 6:** System checks again that no driver is tagged, deletes the vendor and shows "<vendor> deleted."

**Step 7:** The vendor leaves the list. Its name can be used again. "Cancel" on the confirmation changes nothing.

#### Use Case 1.5: Edge Case — a vendor that has drivers cannot be deleted

**Step 1:** User selects "Delete" next to a vendor that has at least one driver tagged to it, or selects "Delete" on the confirmation after a driver has been tagged.

**Step 2:** System deletes nothing and shows the toast: "This vendor has drivers tagged to it, so it can't be deleted."

**Step 3:** User changes the vendor on each of those drivers (Use Case 5), then deletes the vendor.

#### Use Case 1.6: Edge Case — the vendor was deleted by someone else

**Step 1:** User selects "Edit" or "Delete", or "Submit" on an open form, for a vendor that someone else has deleted since the list was shown.

**Step 2:** System changes nothing, shows the toast "This vendor no longer exists." and refreshes the list.

#### Use Case 1.7: Edge Case — a hub is given drivers while the form is open

**Step 1:** User opens the edit form (Use Case 1.3) and unticks a hub where no driver is tagged to the vendor. Someone then tags a driver at that hub to the vendor.

**Step 2:** User selects "Submit".

**Step 3:** System saves nothing. It keeps the form open with the name the user typed, ticks the hub again and does not let it be unticked, and shows the toast: "Drivers are tagged to this vendor at <hubs>, so it can't be removed there."

**Step 4:** User selects "Submit" again, or first changes the vendor on those drivers (Use Case 5).

Note: <hubs> lists the names of the hubs, separated by commas.

### Use Case 2: Vehicle management

Who: any user whose role holds Vehicle management and who has at least one hub on their own list.

#### Use Case 2.1: Happy Case — a user creates a vehicle category

**Step 1:** User selects "Vehicle management" in the menu.

**Step 2:** System shows the vehicle categories list: one row per category, with the column Vehicle category and the button "Edit" in the row, and the button "Create new vehicle category". The list is the same for every user.

**Step 3:** User selects "Create new vehicle category".

**Step 4:** System shows a form with: Vehicle category name; and the buttons "Submit" and "Cancel".

**Step 5:** User enters the category's name and selects "Submit".

**Step 6:** System checks the name (see Use Case 2.2).

**Step 7:** All checks pass. System creates the vehicle category, returns to the list and shows "<category> added."

Result: the category can be chosen on the driver form (Use Case 3) for a driver of any hub.

#### Use Case 2.2: Edge Case — the vehicle category form fails a check

**Step 1:** User selects "Submit" on the form (Use Case 2.1) or on the edit form (Use Case 2.3).

**Step 2:** System saves the name without leading and trailing spaces and finds that a check fails.

**Step 3:** System saves nothing, shows the form with what the user typed, and shows the message for the failed check under the field:

| Check that fails | Message |
|---|---|
| The category name is empty | "Enter the vehicle category's name." |
| The category name is longer than 100 characters | "Vehicle category name can have at most 100 characters." |
| A vehicle category with this name already exists, other than the one being edited. Names that differ only in letter case or extra spaces are the same name. | "A vehicle category with this name already exists." |

**Step 4:** User corrects the form and selects "Submit" again.

#### Use Case 2.3: Happy Case — a user edits a vehicle category's name

**Step 1:** User selects "Vehicle management". System shows the list.

**Step 2:** User selects "Edit" next to the category.

**Step 3:** System shows the form with the name filled in and the buttons "Submit" and "Cancel".

**Step 4:** User changes the name and selects "Submit".

**Step 5:** System checks the name (see Use Case 2.2).

**Step 6:** System saves the name. Every driver tagged to this category shows the new name from this moment.

**Step 7:** System returns to the list and shows "<category> updated."

Note: a vehicle category can be created and edited. It cannot be deleted in this PRD, so a category created by mistake stays in the list.

### Use Case 3: Create a driver

Who: any user whose role holds Driver management and who has at least one hub on their own list.

#### Use Case 3.1: Happy Case — a user creates a driver

**Step 1:** User selects "Driver management" in the menu. System shows the drivers list (Use Case 4).

**Step 2:** User selects "Create driver".

**Step 3:** System shows page 1, Driver and vehicle details, with these fields: Hub, a list; Driver name; Mobile number; Vehicle number; Vehicle category, a list; Vendor, a list. It shows the buttons "Next" and "Cancel".

**Step 4:** User chooses the hub. The Vendor list shows only the vendors that work at that hub. Until a hub is chosen, it is empty. The Vehicle category list shows every vehicle category.

**Step 5:** User fills in the other five fields and selects "Next".

**Step 6:** System checks the six fields (see Use Case 3.2).

**Step 7:** All checks pass. System shows page 2, Engagement details, with: Work type, a list of "Full time" and "Part time"; Engagement category, a list of "Temporary" and "Permanent". It shows the buttons "Back", "Next" and "Cancel".

**Step 8:** User chooses a work type and an engagement category and selects "Next".

**Step 9:** System checks that both are chosen (see Use Case 3.2).

**Step 10:** Both are chosen. System shows page 3, Location details, with: Serviceable pincodes, a file upload; a link "Download sample file"; and the buttons "Back", "Create driver" and "Cancel".

**Step 11:** User downloads the sample file if needed, fills in one row for each pincode the driver serves with the action Insert, and uploads the file.

**Step 12:** System checks the file as soon as it is uploaded and shows the result (see Use Case 3.3).

**Step 13:** User selects "Create driver".

**Step 14:** System checks everything again (see Use Case 3.5).

**Step 15:** All checks pass. System creates the driver with a new driver ID, saves the pincodes the rows add, returns to the drivers list and shows "<driver name> created." The new driver is in the list when its hub is covered by the serving location dropdown.

Result: the driver is in the System with a hub, a vendor, a vehicle, an engagement and serviceable pincodes.

#### Use Case 3.2: Edge Case — a field on page 1 or page 2 fails a check

**Step 1:** User selects "Next" on page 1 or page 2.

**Step 2:** System finds that a check fails.

**Step 3:** System stays on the page, keeps what the user entered, and shows the message for each failed check under its field:

| Check that fails | Message |
|---|---|
| No hub is chosen | "Choose a hub." |
| The driver name is empty | "Enter the driver's name." |
| The driver name has anything other than letters, spaces, full stops, apostrophes and hyphens, or is longer than 100 characters | "Driver name can have letters, spaces, full stops, apostrophes and hyphens only, up to 100 characters." |
| The mobile number is empty, or is not 10 digits starting with 6, 7, 8 or 9 (spaces are ignored) | "Enter a valid 10-digit mobile number." |
| Another driver has this mobile number | "A driver with this mobile number already exists." |
| The vehicle number is empty, or is not an Indian vehicle registration number (see the note below) | "Enter a valid vehicle number, for example MH12AB1234." |
| Another driver has this vehicle number | "This vehicle number is already on another driver." |
| No vehicle category is chosen | "Choose a vehicle category." |
| No vendor is chosen | "Choose a vendor." |
| The vendor chosen has been deleted | "This vendor no longer exists. Choose another." |
| The vendor chosen is not at the driver's hub. This happens when someone else removed the hub from the vendor after the user chose it. | "This vendor is not at the driver's hub. Choose another." |
| No work type is chosen | "Choose a work type." |
| No engagement category is chosen | "Choose an engagement category." |

**Step 4:** User corrects the page and selects "Next" again. The user cannot go on to the next page until every check passes.

Note: the System removes spaces and hyphens from the vehicle number and saves it in capital letters. A valid number is 2 letters, 2 digits, 1 to 3 letters and 4 digits (for example MH12AB1234), or 2 digits, "BH", 4 digits and 1 or 2 letters (for example 22BH1234AA). The driver name is saved with single spaces. The mobile number is saved as 10 digits.

#### Use Case 3.3: Edge Case — the pincode file has errors

**Step 1:** User uploads a pincode file on page 3 (Use Case 3.1), or on the Location details edit (Use Case 5.3).

**Step 2:** System reads the whole file. If the file fails a file check, System uses nothing from it, shows the message and waits for another file:

| File check that fails | Message |
|---|---|
| The file is not a .csv file, is larger than 1 MB, or cannot be read | "We couldn't read this file. Upload a .csv file of 1 MB or less, made from the sample file." |
| The first row does not have the columns Pincode and Action | "The first row must have the columns Pincode and Action. Use the sample file." |
| The file has no row below the first | "The file has no pincodes." |
| The file has more than 2,000 rows | "The file has more than 2,000 rows." |

**Step 3:** The file is readable. System goes through the rows in the order of the file. A row that fails a check is set aside with its reason:

| Row check that fails | Reason shown for the row |
|---|---|
| The pincode is not a number from 100000 to 999999 | "Not a valid pincode." |
| The action is not Insert or Delete (letter case is ignored) | "Action must be Insert or Delete." |
| The action is Insert and the driver's hub does not serve the pincode | "<hub> does not serve this pincode." |

**Step 4:** System processes every other row against the pincodes the driver has at that point, including the changes made by the rows above it:

| Row | What System does |
|---|---|
| Insert, and the driver does not serve the pincode | Adds the pincode |
| Insert, and the driver already serves the pincode | Ignores the row. No error |
| Delete, and the driver serves the pincode | Removes the pincode |
| Delete, and the driver does not serve the pincode | Ignores the row. No error |

**Step 5:** System shows the result before anything is saved: "<n> rows will be applied. <m> rows have errors." A row that changes a pincode counts in <n>. A row with an error counts in <m>. An ignored row counts in neither. Under it, System lists the first 10 rows with errors as "Row <r>: <pincode> — <reason>", and, when <n> is more than zero, shows the link "Download success file". When <m> is more than zero it also shows "Download error file".

**Step 6:** User can upload a corrected file. The new file replaces the earlier one, and nothing from the earlier file is kept. Or the user continues with the rows that can be applied. Rows with errors are never applied.

**Step 7:** If no row can be applied, System shows "No row can be applied." and does not offer "Create driver" or "Submit" until a file with a row that can be applied is uploaded.

Note: the error file is a .csv file with the columns Row, Pincode, Action and Error, one line for each row that failed. The success file has the columns Row, Pincode and Action, one line for each row that changes a pincode. System makes the error file only when a row failed and the success file only when a row changes a pincode. A row number is the row in the file, where the header is row 1. System skips blank rows and removes spaces around each value. The sample file is a .csv file with the columns Pincode and Action and one example row of each action. A pincode that is in more than one row follows the same rules: the first row acts, a later row with the same action is ignored, and a later row with a different action is performed. When a driver is being created, or its hub is being changed, the rows are processed starting from no pincodes. An ignored row is in neither file.

#### Use Case 3.4: Edge Case — there is no vendor or vehicle category to choose

**Step 1:** User chooses a hub on page 1 and the Vendor list has nothing in it, or no vehicle category has been created yet.

**Step 2:** System shows under the list: "No vendors at this hub yet. Ask a user who has Vendor management to add one." or "No vehicle categories yet. Ask a user who has Vehicle management to add one."

**Step 3:** User cannot go past page 1 without choosing one (Use Case 3.2). User selects "Cancel", asks a user whose role holds Vendor management or Vehicle management to create the vendor or category (Use Case 1 or 2), and starts again. Nothing entered is kept (Use Case 3.6).

#### Use Case 3.5: Edge Case — something changes before "Create driver"

**Step 1:** User selects "Create driver" on page 3, some time after selecting "Next" on page 1.

**Step 2:** System checks pages 1 and 2 again and checks each pincode row again. It finds that the vendor has been deleted or no longer works at the hub, that another driver now has the mobile number or the vehicle number, or that a pincode row no longer passes.

**Step 3:** System creates nothing. For a problem on page 1, it takes the user to page 1 with the other fields kept and shows the message from Use Case 3.2 under the field. The user cannot go on until it is resolved. For a pincode row, it stays on page 3 and shows the new result (Use Case 3.3).

#### Use Case 3.6: Edge Case — the user moves between pages, cancels or leaves

**Step 1:** User moves to another page with "Back" or "Next". What the user entered on the page they leave is kept, and the page shows it again when they come back. This includes the uploaded file and its result on page 3.

**Step 2:** User changes the hub on page 1. System clears the Vendor and the uploaded file with its result, because they belong to the hub. Everything else is kept.

**Step 3:** User selects "Cancel" on any page. System returns to the drivers list and creates nothing.

**Step 4:** User closes the tab, refreshes the page, signs out, or is signed out by the System. Everything entered is lost.

**Step 5:** Nothing is saved until "Create driver" passes every check. If "Create driver" is selected twice, System creates one driver: the second attempt fails the mobile number check.

### Use Case 4: See and find drivers

Who: any user whose role holds Driver management and who has at least one hub on their own list.

#### Use Case 4.1: Happy Case — a user opens Driver management

**Step 1:** User selects "Driver management" in the menu.

**Step 2:** System shows the drivers list: one row per driver, for the hubs on the user's own list that the serving location dropdown covers.

**Step 3:** Each row shows: Driver ID, Driver name, Hub, Vendor and Vehicle category, and a chevron.

**Step 4:** The list shows the newest drivers first. Above it are a search box, the filters Hub, Vendor and Vehicle category, a choice of drivers to a page (10, 20, 50 or 100, starting on 20), and the button "Create driver".

Result: the user sees only the drivers of their hubs.

#### Use Case 4.2: Happy Case — a user searches and filters

**Step 1:** User types in the search box.

**Step 2:** System shows the drivers whose name or mobile number contains the text, ignoring letter case and spaces.

**Step 3:** User chooses a hub, a vendor or a vehicle category in a filter. Each filter starts on "All". The Hub filter lists the hubs the dropdown covers. The Vendor filter lists the vendors that work at a hub the dropdown covers, each once, in alphabetical order. The Vehicle category filter lists every vehicle category.

**Step 4:** System shows the drivers that match the search and every filter together. A Vendor filter matches the drivers tagged to that vendor, so one vendor chosen can match drivers of several hubs. The Hub filter narrows them to one hub.

**Step 5:** User clears the search box or sets a filter back to "All". System widens the list again.

Note: the list does not show the mobile number or the vehicle number. The mobile number is searchable, and both are shown on the driver's profile (Use Case 5.1).

#### Use Case 4.3: Edge Case — no driver to show

**Step 1:** The hubs the dropdown covers have no driver at all. System shows only "No drivers yet." and the button "Create driver", with no search box, filters or page size.

**Step 2:** A search or a filter matches no driver. System shows "No drivers found." and keeps the search box and filters.

#### Use Case 4.4: Edge Case — the user opens a driver of a hub that is not on their list

**Step 1:** User opens a driver's page, for example from a saved link, and the driver's hub is not on the user's own list.

**Step 2:** System shows no data about the driver and shows: "You don't have access to this location."

### Use Case 5: Edit a driver

Who: any user whose role holds Driver management and who has the driver's hub on their own list. Deleting a driver is not in this PRD.

#### Use Case 5.1: Happy Case — a user opens a driver's profile

**Step 1:** User finds the driver (Use Case 4.2) and selects the chevron on the row.

**Step 2:** System shows the driver's profile with four tabs: "Driver details", "Vehicle details", "Engagement details" and "Location details". "Driver details" opens first. Each tab has an "Edit" button. "Location details" also has a "Change hub" button.

**Step 3:** System shows these fields on the tabs:

| Tab | Fields shown |
|---|---|
| Driver details | Driver ID, Driver name, Mobile number, Vendor |
| Vehicle details | Vehicle number, Vehicle category |
| Engagement details | Work type, Engagement category |
| Location details | Hub; the number of serviceable pincodes, with a link "Download current pincodes" |

**Step 4:** User selects "Back" to return to the drivers list.

#### Use Case 5.2: Happy Case — a user edits Driver details, Vehicle details or Engagement details

**Step 1:** User opens one of these tabs and selects "Edit".

**Step 2:** System shows the fields of that tab as the creation pages show them, filled with the driver's current values, with the buttons "Submit" and "Cancel". Only these fields are open:

| Tab | Fields the user can change |
|---|---|
| Driver details | Vendor, from the vendors that work at the driver's hub. The driver's name and mobile number cannot be changed. |
| Vehicle details | Vehicle number; Vehicle category, from every vehicle category |
| Engagement details | Work type, Engagement category |

**Step 3:** User changes the fields and selects "Submit".

**Step 4:** System runs the same checks as creation for those fields (Use Case 3.2), and the checks in Use Case 5.5. The mobile number and vehicle number checks ignore the driver being edited.

**Step 5:** All checks pass. System saves that tab only. The driver's other tabs do not change.

**Step 6:** System shows the tab with the new values and shows the message for the tab: "Driver details updated.", "Vehicle details updated." or "Engagement details updated."

**Step 7:** User selects "Back" to return to the drivers list.

#### Use Case 5.3: Happy Case — a user adds and removes pincodes

**Step 1:** User opens "Location details" and selects "Edit".

**Step 2:** System shows: Pincode changes, a file upload; the links "Download current pincodes" and "Download sample file"; and the buttons "Submit" and "Cancel".

**Step 3:** User fills in one row for each pincode to change. The action Insert adds the pincode to the driver. The action Delete removes it. The user uploads the file.

**Step 4:** System checks the file as soon as it is uploaded and shows the result (see Use Case 3.3).

**Step 5:** User selects "Submit".

**Step 6:** System checks each row again and processes the rows in the order of the file (Use Case 3.3). Every other pincode of the driver stays as it was.

**Step 7:** System shows the tab with the new number of pincodes and shows "Location details updated."

Note: if the rows would leave the driver with no pincode, System applies nothing and shows "A driver must serve at least one pincode." If the user selects "Submit" before uploading a file, System shows "There is nothing to apply."

#### Use Case 5.4: Happy Case — a user changes a driver's hub

**Step 1:** User opens "Location details" and selects "Change hub".

**Step 2:** System shows a page with: Hub, a list of the hubs on the user's own list; Vendor, a list; Pincode changes, a file upload; the links "Download current pincodes" and "Download sample file"; and the buttons "Submit" and "Cancel". It shows the note "The driver's current pincodes will be replaced by the pincodes in this file."

**Step 3:** User chooses a hub other than the driver's current hub. The Vendor list shows only the vendors that work at that hub. Until a hub is chosen, it is empty.

**Step 4:** User chooses a vendor, fills in one Insert row for each pincode the driver will serve at the new hub, and uploads the file.

**Step 5:** System checks the file as soon as it is uploaded and shows the result (see Use Case 3.3). It judges each pincode against the new hub and processes the rows starting from no pincodes, so a Delete row changes nothing and is ignored.

**Step 6:** User selects "Submit".

**Step 7:** System checks the hub and the vendor (see Use Case 5.5), and checks each row again.

**Step 8:** All checks pass. System saves the new hub and vendor, and replaces the driver's pincodes with the pincodes the rows add. The driver ID, name, mobile number, vehicle number, vehicle category and engagement do not change.

**Step 9:** System shows the Location details tab with the new hub and shows "<driver name> moved to <hub>."

Result: users of the old hub no longer see the driver, and users of the new hub do.

Note: "Download current pincodes" gives a .csv file with the columns Pincode and Action and the action Insert on every row, so it can be uploaded as it is. Rows for pincodes the new hub does not serve are set aside with their reason. If no row passes, System shows "No row can be applied." and does not offer "Submit" (Use Case 3.3, Step 7). If the new hub has no vendor, System shows the message from Use Case 3.4 and the user cannot submit.

#### Use Case 5.5: Edge Case — an edit fails a check

**Step 1:** User selects "Submit" on an edit and a check fails (Use Case 5.2, Step 4, Use Case 5.3, Step 6, or Use Case 5.4, Step 7).

**Step 2:** System saves nothing, keeps the form open with what the user entered, and shows the messages from Use Case 3.2 or 3.3 under the fields, or from this table:

| Check that fails | Message |
|---|---|
| On "Change hub", the hub chosen is the driver's current hub | "Choose a different hub." |
| The vendor chosen is not at the driver's hub. This happens when someone else changed the driver's hub, or removed the hub from the vendor, after the user selected "Edit". | "This vendor is not at the driver's hub. Choose another." |

**Step 3:** User corrects the form and selects "Submit" again. When the driver's hub was changed by someone else, the user opens the driver again first.

#### Use Case 5.6: Edge Case — two users change the same driver

**Step 1:** Two users open the same tab and select "Edit".

**Step 2:** Each selects "Submit". System saves the changes in the order it receives them, and the change saved last is the one kept. The earlier change is overwritten. System shows no message, except as Use Case 5.5 says.

**Step 3:** Pincode changes are applied one row at a time on top of the pincodes the driver has when the file is applied, so two files that change different pincodes both take effect.

### Use Case 6: Module access

Who: any user.

#### Use Case 6.1: Happy Case — a user sees the tabs their role holds

**Step 1:** User signs in to the portal.

**Step 2:** System reads the modules the user's role holds.

**Step 3:** The menu shows "Vendor management", "Vehicle management" and "Driver management", in this order, each only if the role holds that module.

**Step 4:** User selects a tab. System opens it as Use Cases 1 to 5 say.

Result: the user never sees or opens a tab their role does not hold.

Note: at launch the roles hold these tabs. Each role holds what the role below it holds, and one more.

| Role | Tabs at launch |
|---|---|
| Dispatcher | Driver management |
| DC Executive | Driver management |
| Team Lead | Vendor management, Driver management |
| Regional Manager | Vendor management, Vehicle management, Driver management |
| Central Logistics Ops | Vendor management, Vehicle management, Driver management |
| Control Tower | Vendor management, Vehicle management, Driver management |
| Finance | None |
| Admin | Vendor management, Vehicle management, Driver management |

#### Use Case 6.2: Edge Case — the user opens a tab their role does not hold

**Step 1:** User opens the address of a tab whose module their role does not hold, for example from a saved link. The same happens when an Admin takes the module off the role while the user is in the tab, and the user takes an action (the User Management PRD describes this change).

**Step 2:** System does not show the tab. It shows: "You don't have access to this page."

**Step 3:** Anything the user had not saved in the tab, such as a form being filled, is lost.

Note: a user who cannot open a tab can still be tagged by it: the driver form lists vendors and vehicle categories (Side effects).

### Side effects

- A tab is a module. A role's modules decide which tab a user can open. They do not hide what another tab needs: a user whose role holds Driver management but not Vendor management or Vehicle management still chooses from the vendors and vehicle categories on the driver form and in the driver list filters.
- A driver's hub can be changed. The driver's vendor and pincodes are then replaced with ones of the new hub (Use Case 5.4). The vehicle category stays.
- A vendor works at one or more hubs. A hub can be removed from a vendor only while no driver at that hub is tagged to it. The vendor name is unique across the System, so a vendor that works only at hubs a user cannot see is not shown to that user, and they cannot reuse its name. A user who has one of its hubs edits it. A vehicle category belongs to no hub.
- A driver's mobile number and vehicle number are unique across all drivers. A driver who has left and returns cannot be created again.
- Deleting a driver is not in this PRD, so no driver can be deleted. A vendor that has a driver can never be deleted. A vehicle category can be created and edited but not deleted, so a category created by mistake stays in the list; its name can be changed.
- A driver has no status in this PRD. The status, its column and its filter are added with suspension and exit.
- Every later feature that reads a driver's serviceability uses the driver's serviceable pincodes.
- Driver documents and device assignment are not in this PRD.
- Assumes the System knows which pincodes each hub serves, from network setup, before implementation.

## 4. Metrics

| Metric Type | Metric | Definition |
|---|---|---|
| Success | Median time to create a driver | Median, over created drivers, of the time from the user selecting "Create driver" on the drivers list to the System saving the driver |
| Success | Creation completion | Drivers created ÷ times a user selects "Create driver" on the drivers list |
| Lead | Pincode files with no rejected row | Pincode file uploads in which no row has an error ÷ all pincode file uploads |
| Lead | Pages passed on the first "Next" | Times a user selects "Next" and the page passes ÷ all times a user selects "Next" |
| Check | Drivers sharing a mobile number | Count of mobile numbers on more than one driver |
| Check | Drivers with no serviceable pincode | Drivers who serve no pincode ÷ all drivers |
| Check | Drivers tagged to a vendor that does not exist | Count of drivers whose vendor has been deleted |
| Check | Changes outside the user's hubs | Count of creates, edits and deletes of a driver made by a user whose own list does not include the driver's hub, where for a change of hub the old hub and the new hub are both the driver's hub, and of changes to a vendor that add or remove a hub outside the user's own list or delete a vendor that has one. |

## 5. Rollout & Stage Gates

| Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria |
|---|---|---|---|---|
| 1 | Prove vendor, vehicle category and driver setup at the first cutover location | Ops at the first cutover location creates its vendors and vehicle categories, then its drivers, in the portal before the location cuts over. | Median time to create a driver: target to be set from baseline. Creation completion: target to be set from baseline. | Drivers sharing a mobile number: threshold not yet set. Drivers with no serviceable pincode: threshold not yet set. Drivers tagged to a vendor that does not exist: threshold not yet set. Changes outside the user's hubs: threshold not yet set. |
| 2 | Every cutover location | Ops at each location creates its vendors, vehicle categories and drivers as the location cuts over. | Median time to create a driver: target to be set from baseline. Creation completion: target to be set from baseline. | Drivers sharing a mobile number: threshold not yet set. Drivers with no serviceable pincode: threshold not yet set. Drivers tagged to a vendor that does not exist: threshold not yet set. Changes outside the user's hubs: threshold not yet set. |
