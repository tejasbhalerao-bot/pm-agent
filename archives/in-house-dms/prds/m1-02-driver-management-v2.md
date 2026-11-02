---
**Document:** Driver Management
**Type:** Executable PRD
**Version:** v2
**Date:** 2026-11-03
**Status:** Under Review
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-11-03 | Initial draft |
| v2 | 2026-11-03 | Review comments applied. A vendor or vehicle category can be created for several hubs at once, with a Review screen; deleting asks for confirmation. A driver's hub is chosen first, and the vendor and vehicle category are limited to that hub. Pincodes are added and removed by a CSV file with Insert and Delete actions; valid rows are used and errors can be downloaded; blacklisting is removed. The driver list gains Vendor and Vehicle category columns, filters and a page size; Status is removed. The change saved last is kept. The open points are settled. |
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
    - [Use Case 1.3: Happy Case — a user edits a vendor's name](#use-case-13-happy-case--a-user-edits-a-vendors-name)
    - [Use Case 1.4: Happy Case — a user deletes a vendor that has no driver](#use-case-14-happy-case--a-user-deletes-a-vendor-that-has-no-driver)
    - [Use Case 1.5: Edge Case — a vendor that has drivers cannot be deleted](#use-case-15-edge-case--a-vendor-that-has-drivers-cannot-be-deleted)
    - [Use Case 1.6: Edge Case — the vendor was deleted by someone else](#use-case-16-edge-case--the-vendor-was-deleted-by-someone-else)
  - [Use Case 2: Vehicle management](#use-case-2-vehicle-management)
    - [Use Case 2.1: Happy Case — a user creates a vehicle category](#use-case-21-happy-case--a-user-creates-a-vehicle-category)
    - [Use Case 2.2: Edge Case — the vehicle category form fails a check](#use-case-22-edge-case--the-vehicle-category-form-fails-a-check)
    - [Use Case 2.3: Happy Case — a user edits a vehicle category's name](#use-case-23-happy-case--a-user-edits-a-vehicle-categorys-name)
    - [Use Case 2.4: Happy Case — a user deletes a vehicle category that has no driver](#use-case-24-happy-case--a-user-deletes-a-vehicle-category-that-has-no-driver)
    - [Use Case 2.5: Edge Case — a vehicle category that has drivers cannot be deleted](#use-case-25-edge-case--a-vehicle-category-that-has-drivers-cannot-be-deleted)
    - [Use Case 2.6: Edge Case — the vehicle category was deleted by someone else](#use-case-26-edge-case--the-vehicle-category-was-deleted-by-someone-else)
  - [Use Case 3: Create a driver](#use-case-3-create-a-driver)
    - [Use Case 3.1: Happy Case — a user creates a driver](#use-case-31-happy-case--a-user-creates-a-driver)
    - [Use Case 3.2: Edge Case — a field on page 1 or page 2 fails a check](#use-case-32-edge-case--a-field-on-page-1-or-page-2-fails-a-check)
    - [Use Case 3.3: Edge Case — the pincode file has errors](#use-case-33-edge-case--the-pincode-file-has-errors)
    - [Use Case 3.4: Edge Case — there is no vendor or vehicle category at the hub](#use-case-34-edge-case--there-is-no-vendor-or-vehicle-category-at-the-hub)
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
    - [Use Case 5.4: Edge Case — an edit fails a check](#use-case-54-edge-case--an-edit-fails-a-check)
    - [Use Case 5.5: Edge Case — two users change the same driver](#use-case-55-edge-case--two-users-change-the-same-driver)
  - [Side effects](#side-effects)
  - [Open points](#open-points)
- [4. Metrics](#4-metrics)
- [5. Rollout & Stage Gates](#5-rollout--stage-gates)

## 1. Objective

Every driver who works from a hub is in the System, with a vendor, a vehicle and the pincodes they serve, before they take their first order.

## 2. Why Now

Shipsy holds Truemeds' riders today. The in-house system has nowhere to create a driver, to record which vendor the driver comes from and which vehicle they use, or to say which pincodes they serve. No driver can use the in-house rider app, and no order can be given to a driver, until the driver is in the System with this information. How long it takes to create a driver, and how many are set up correctly, is not measured.

The first cutover location needs all of its drivers in the System before it cuts over from Shipsy. Serving locations grow from 39 to 150 in the next 15 months, so drivers will be created at every location as it cuts over. Until this ships, nothing that depends on a driver can be built or tested: driver login, order assignment, allocation and payouts.

## 3. Use Cases

This PRD adds three tabs to the Hyperlocal Fleet Management Portal: Vendor management, Vehicle management and Driver management. It applies to every ops user of the portal, in both verticals. The rider app is out of scope.

In this PRD, a hub is a serving location: a warehouse or a DC tagged Physical (see User Management). A user's own list is the list of hubs set for their email in User Management. A user with "All locations" has every hub on their own list.

- Every list in the three tabs shows only records of hubs on the user's own list, narrowed by the serving location dropdown in the top bar: all of the user's hubs when "All serving locations" is selected, otherwise the one hub selected.
- A Hub field on a form offers only the hubs on the user's own list.
- After a create or an edit, the message shows even when the record's hub is not covered by the dropdown. The record then does not show in the list.
- The menu shows all three tabs to every role, and every role can use them. The System does not restrict by role. Finance does not create, edit or delete vendors today; Ops enforces that by SOP, and the System does not stop it.
- A vendor is the company a driver works through. A vendor belongs to one hub. A vehicle category is the type of vehicle a driver uses, for example a bike or a van. A vehicle category belongs to one hub.
- When a user creates a vendor or a vehicle category for several hubs at once, the System creates one record for each hub. Each record is then edited and deleted on its own.
- A driver belongs to one hub and can be tagged only to a vendor and a vehicle category of that hub.
- The System gives every driver a unique driver ID. It never changes and is never given to another driver.
- When two users change the same record or field at the same time, the change the System saves last is the one kept.
- A message in quotes is shown on the screen. A message with <name> shows the name of the record.
- The limits in this PRD are fixed values: 100 characters for a name, 1 MB and 2,000 rows for a file, and 10, 20, 50 or 100 drivers to a page.

### Use Case 1: Vendor management

Who: any user with at least one hub on their own list.

#### Use Case 1.1: Happy Case — a user creates a vendor

**Step 1:** User selects "Vendor management" in the menu.

**Step 2:** System shows the vendors list: one row per vendor, with columns Vendor and Hub, and the button "Create new vendor".

**Step 3:** User selects "Create new vendor".

**Step 4:** System shows a form with: Vendor name; Hubs, the hubs on the user's own list with a checkbox each; and the buttons "Review" and "Cancel".

**Step 5:** User enters the vendor's name and ticks one or more hubs.

**Step 6:** User selects "Review".

**Step 7:** System checks the name and the hubs (see Use Case 1.2).

**Step 8:** All checks pass. System shows the review screen with the vendor name and the hubs ticked, and the buttons "Back" and "Submit".

**Step 9:** User checks the screen and selects "Submit". "Back" returns to the form with what the user entered kept.

**Step 10:** System checks again (see Use Case 1.2). All checks pass. System creates one vendor for each hub ticked, returns to the vendors list and shows "<vendor> added."

Result: each vendor can be chosen on the driver form (Use Case 3) for drivers of its hub.

#### Use Case 1.2: Edge Case — the vendor form fails a check

**Step 1:** User selects "Review" on the form (Use Case 1.1), or "Submit" on the review screen or on the edit form (Use Case 1.3).

**Step 2:** System saves the name without leading and trailing spaces and finds that a check fails.

**Step 3:** System saves nothing, shows the form with what the user typed, and shows the message for each failed check under its field:

| Check that fails | Message |
|---|---|
| The vendor name is empty | "Enter the vendor's name." |
| The vendor name is longer than 100 characters | "Vendor name can have at most 100 characters." |
| No hub is ticked (create only) | "Choose at least one hub." |
| A vendor with this name already exists at a hub ticked, other than the one being edited. Names that differ only in letter case or extra spaces are the same name. | "A vendor with this name already exists at <hubs>." |

**Step 4:** User corrects the form and selects "Review" or "Submit" again.

Note: <hubs> lists the names of the hubs where the vendor exists, separated by commas. Nothing is created for the other hubs ticked.

#### Use Case 1.3: Happy Case — a user edits a vendor's name

**Step 1:** User selects "Vendor management". System shows the vendors list.

**Step 2:** User selects "Edit" next to the vendor.

**Step 3:** System shows the form with the name filled in and the hub shown but not editable.

**Step 4:** User changes the name and selects "Submit".

**Step 5:** System checks the name (see Use Case 1.2).

**Step 6:** System saves the name. Every driver tagged to this vendor shows the new name from this moment.

**Step 7:** System returns to the vendors list and shows "<vendor> updated."

#### Use Case 1.4: Happy Case — a user deletes a vendor that has no driver

**Step 1:** User selects "Vendor management". System shows the vendors list.

**Step 2:** User selects "Delete" next to the vendor.

**Step 3:** System checks that no driver is tagged to the vendor.

**Step 4:** No driver is tagged. System shows the confirmation "Delete <vendor> at <hub>? This can't be undone." with the buttons "Delete" and "Cancel".

**Step 5:** User selects "Delete".

**Step 6:** System checks again that no driver is tagged, deletes the vendor and shows "<vendor> deleted."

**Step 7:** The vendor leaves the list. Its name can be used again at that hub. "Cancel" on the confirmation changes nothing.

#### Use Case 1.5: Edge Case — a vendor that has drivers cannot be deleted

**Step 1:** User selects "Delete" next to a vendor that has at least one driver tagged to it, or selects "Delete" on the confirmation after a driver has been tagged.

**Step 2:** System deletes nothing and shows: "This vendor has drivers tagged to it, so it can't be deleted."

**Step 3:** User changes the vendor on each of those drivers (Use Case 5), then deletes the vendor.

#### Use Case 1.6: Edge Case — the vendor was deleted by someone else

**Step 1:** User selects "Edit" or "Delete", or "Submit" on an open form, for a vendor that someone else has deleted since the list was shown.

**Step 2:** System changes nothing, shows "This vendor no longer exists." and refreshes the list.

### Use Case 2: Vehicle management

Who: any user with at least one hub on their own list.

#### Use Case 2.1: Happy Case — a user creates a vehicle category

**Step 1:** User selects "Vehicle management" in the menu.

**Step 2:** System shows the vehicle categories list: one row per category, with columns Vehicle category and Hub, and the button "Create new vehicle category".

**Step 3:** User selects "Create new vehicle category".

**Step 4:** System shows a form with: Vehicle category name; Hubs, the hubs on the user's own list with a checkbox each; and the buttons "Review" and "Cancel".

**Step 5:** User enters the category's name and ticks one or more hubs.

**Step 6:** User selects "Review".

**Step 7:** System checks the name and the hubs (see Use Case 2.2).

**Step 8:** All checks pass. System shows the review screen with the category name and the hubs ticked, and the buttons "Back" and "Submit".

**Step 9:** User checks the screen and selects "Submit". "Back" returns to the form with what the user entered kept.

**Step 10:** System checks again (see Use Case 2.2). All checks pass. System creates one category for each hub ticked, returns to the list and shows "<category> added."

Result: each category can be chosen on the driver form (Use Case 3) for drivers of its hub.

#### Use Case 2.2: Edge Case — the vehicle category form fails a check

**Step 1:** User selects "Review" on the form (Use Case 2.1), or "Submit" on the review screen or on the edit form (Use Case 2.3).

**Step 2:** System saves the name without leading and trailing spaces and finds that a check fails.

**Step 3:** System saves nothing, shows the form with what the user typed, and shows the message for each failed check under its field:

| Check that fails | Message |
|---|---|
| The category name is empty | "Enter the vehicle category's name." |
| The category name is longer than 100 characters | "Vehicle category name can have at most 100 characters." |
| No hub is ticked (create only) | "Choose at least one hub." |
| A category with this name already exists at a hub ticked, other than the one being edited. Names that differ only in letter case or extra spaces are the same name. | "A vehicle category with this name already exists at <hubs>." |

**Step 4:** User corrects the form and selects "Review" or "Submit" again.

Note: <hubs> lists the names of the hubs where the category exists, separated by commas. Nothing is created for the other hubs ticked.

#### Use Case 2.3: Happy Case — a user edits a vehicle category's name

**Step 1:** User selects "Vehicle management". System shows the list.

**Step 2:** User selects "Edit" next to the category.

**Step 3:** System shows the form with the name filled in and the hub shown but not editable.

**Step 4:** User changes the name and selects "Submit".

**Step 5:** System checks the name (see Use Case 2.2).

**Step 6:** System saves the name. Every driver tagged to this category shows the new name from this moment.

**Step 7:** System returns to the list and shows "<category> updated."

#### Use Case 2.4: Happy Case — a user deletes a vehicle category that has no driver

**Step 1:** User selects "Vehicle management". System shows the list.

**Step 2:** User selects "Delete" next to the category.

**Step 3:** System checks that no driver is tagged to the category.

**Step 4:** No driver is tagged. System shows the confirmation "Delete <category> at <hub>? This can't be undone." with the buttons "Delete" and "Cancel".

**Step 5:** User selects "Delete".

**Step 6:** System checks again that no driver is tagged, deletes the category and shows "<category> deleted."

**Step 7:** The category leaves the list. Its name can be used again at that hub. "Cancel" on the confirmation changes nothing.

#### Use Case 2.5: Edge Case — a vehicle category that has drivers cannot be deleted

**Step 1:** User selects "Delete" next to a category that has at least one driver tagged to it, or selects "Delete" on the confirmation after a driver has been tagged.

**Step 2:** System deletes nothing and shows: "This vehicle category has drivers tagged to it, so it can't be deleted."

**Step 3:** User changes the category on each of those drivers (Use Case 5), then deletes the category.

#### Use Case 2.6: Edge Case — the vehicle category was deleted by someone else

**Step 1:** User selects "Edit" or "Delete", or "Submit" on an open form, for a category that someone else has deleted since the list was shown.

**Step 2:** System changes nothing, shows "This vehicle category no longer exists." and refreshes the list.

### Use Case 3: Create a driver

Who: any user with at least one hub on their own list.

#### Use Case 3.1: Happy Case — a user creates a driver

**Step 1:** User selects "Driver management" in the menu. System shows the drivers list (Use Case 4).

**Step 2:** User selects "Create driver".

**Step 3:** System shows page 1, Driver and vehicle details, with these fields: Hub, a list; Driver name; Mobile number; Vehicle number; Vehicle category, a list; Vendor, a list. It shows the buttons "Next" and "Cancel".

**Step 4:** User chooses the hub. The Vehicle category and Vendor lists show only the categories and vendors of that hub. Until a hub is chosen, they are empty.

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

**Step 15:** All checks pass. System creates the driver with a new driver ID, saves the pincodes from the rows that passed, returns to the drivers list and shows "<driver name> created." The new driver is in the list when its hub is covered by the serving location dropdown.

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
| The vehicle category chosen has been deleted | "This vehicle category no longer exists. Choose another." |
| No vendor is chosen | "Choose a vendor." |
| The vendor chosen has been deleted | "This vendor no longer exists. Choose another." |
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

**Step 3:** The file is readable. System checks each row. A row that passes is kept. A row that fails is set aside with its reason:

| Row check that fails | Reason shown for the row |
|---|---|
| The pincode is not a number from 100000 to 999999 | "Not a valid pincode." |
| The action is not Insert or Delete (letter case is ignored) | "Action must be Insert or Delete." |
| The action is Insert and the driver's hub does not serve the pincode | "<hub> does not serve this pincode." |
| The action is Insert and the driver already serves the pincode | "The driver already serves this pincode." |
| The action is Delete and the driver does not serve the pincode | "The driver does not serve this pincode." |
| The pincode is in more than one row of the file | "This pincode appears more than once in the file." |

**Step 4:** System shows the result before anything is saved: "<n> rows will be applied. <m> rows have errors." Under it, System lists the first 10 rows with errors as "Row <r>: <pincode> — <reason>", and, when <n> is more than zero, shows the link "Download success file". When <m> is more than zero it also shows "Download error file".

**Step 5:** User can upload a corrected file. The new file replaces the earlier one, and nothing from the earlier file is kept. Or the user continues with the rows that passed. Rows with errors are never applied.

**Step 6:** If no row passes, System shows "No row can be applied." and does not offer "Create driver" or "Submit" until a file with a passing row is uploaded.

Note: the error file is a .csv file with the columns Row, Pincode, Action and Error, one line for each row that failed. The success file has the columns Row, Pincode and Action, one line for each row that passed. System makes the error file only when a row failed and the success file only when a row passed. A row number is the row in the file, where the header is row 1. System skips blank rows and removes spaces around each value. The sample file is a .csv file with the columns Pincode and Action and one example row of each action. When a driver is being created, every Delete row fails, because the driver serves no pincode yet.

#### Use Case 3.4: Edge Case — there is no vendor or vehicle category at the hub

**Step 1:** User chooses a hub on page 1 and the Vendor list or the Vehicle category list has nothing in it.

**Step 2:** System shows under the list: "No vendors at this hub yet. Create one in Vendor management." or "No vehicle categories at this hub yet. Create one in Vehicle management."

**Step 3:** User cannot go past page 1 without choosing one (Use Case 3.2). User selects "Cancel", creates the vendor or category (Use Case 1 or 2) and starts again. Nothing entered is kept (Use Case 3.6).

#### Use Case 3.5: Edge Case — something changes before "Create driver"

**Step 1:** User selects "Create driver" on page 3, some time after selecting "Next" on page 1.

**Step 2:** System checks pages 1 and 2 again and checks each pincode row again. It finds that the vendor or vehicle category has been deleted, that another driver now has the mobile number or the vehicle number, or that a pincode row no longer passes.

**Step 3:** System creates nothing. For a problem on page 1, it takes the user to page 1 with the other fields kept and shows the message from Use Case 3.2 under the field. The user cannot go on until it is resolved. For a pincode row, it stays on page 3 and shows the new result (Use Case 3.3).

#### Use Case 3.6: Edge Case — the user moves between pages, cancels or leaves

**Step 1:** User moves to another page with "Back" or "Next". What the user entered on the page they leave is kept, and the page shows it again when they come back. This includes the uploaded file and its result on page 3.

**Step 2:** User changes the hub on page 1. System clears the Vehicle category, the Vendor and the uploaded file with its result, because they belong to the hub. Everything else is kept.

**Step 3:** User selects "Cancel" on any page. System returns to the drivers list and creates nothing.

**Step 4:** User closes the tab, refreshes the page, signs out, or is signed out by the System. Everything entered is lost.

**Step 5:** Nothing is saved until "Create driver" passes every check. If "Create driver" is selected twice, System creates one driver: the second attempt fails the mobile number check.

### Use Case 4: See and find drivers

Who: any user with at least one hub on their own list.

#### Use Case 4.1: Happy Case — a user opens Driver management

**Step 1:** User selects "Driver management" in the menu.

**Step 2:** System shows the drivers list: one row per driver, for the hubs on the user's own list that the serving location dropdown covers.

**Step 3:** Each row shows: Driver ID, Driver name, Hub, Vendor and Vehicle category, and a chevron.

**Step 4:** The list shows the newest drivers first. Above it are a search box, the filters Hub, Vendor and Vehicle category, a choice of drivers to a page (10, 20, 50 or 100, starting on 20), and the button "Create driver".

Result: the user sees only the drivers of their hubs.

#### Use Case 4.2: Happy Case — a user searches and filters

**Step 1:** User types in the search box.

**Step 2:** System shows the drivers whose name or mobile number contains the text, ignoring letter case and spaces.

**Step 3:** User chooses a hub, a vendor or a vehicle category in a filter. Each filter starts on "All". The Hub filter lists the hubs the dropdown covers. The Vendor and Vehicle category filters list the vendors and categories of those hubs, each with its hub.

**Step 4:** System shows the drivers that match the search and every filter together.

**Step 5:** User clears the search box or sets a filter back to "All". System widens the list again.

Note: the list does not show the mobile number or the vehicle number. The mobile number is searchable, and both are shown on the driver's profile (Use Case 5.1).

#### Use Case 4.3: Edge Case — no driver to show

**Step 1:** The hubs the dropdown covers have no driver at all. System shows only "No drivers yet." and the button "Create driver", with no search box, filters or page size.

**Step 2:** A search or a filter matches no driver. System shows "No drivers found." and keeps the search box and filters.

#### Use Case 4.4: Edge Case — the user opens a driver of a hub that is not on their list

**Step 1:** User opens a driver's page, for example from a saved link, and the driver's hub is not on the user's own list.

**Step 2:** System shows no data about the driver and shows: "You don't have access to this location."

### Use Case 5: Edit a driver

Who: any user with the driver's hub on their own list. Deleting a driver is not in this PRD.

#### Use Case 5.1: Happy Case — a user opens a driver's profile

**Step 1:** User finds the driver (Use Case 4.2) and selects the chevron on the row.

**Step 2:** System shows the driver's profile with four tabs: "Driver details", "Vehicle details", "Engagement details" and "Location details". "Driver details" opens first. Each tab has an "Edit" button.

**Step 3:** System shows these fields on the tabs:

| Tab | Fields shown |
|---|---|
| Driver details | Driver ID, Driver name, Mobile number, Hub, Vendor |
| Vehicle details | Vehicle number, Vehicle category |
| Engagement details | Work type, Engagement category |
| Location details | The number of serviceable pincodes, with a link "Download current pincodes" |

**Step 4:** User selects "Back" to return to the drivers list.

#### Use Case 5.2: Happy Case — a user edits Driver details, Vehicle details or Engagement details

**Step 1:** User opens one of these tabs and selects "Edit".

**Step 2:** System shows the fields of that tab as the creation pages show them, filled with the driver's current values, with the buttons "Submit" and "Cancel". Only these fields are open:

| Tab | Fields the user can change |
|---|---|
| Driver details | Vendor, from the vendors of the driver's hub. The driver's name, mobile number and hub cannot be changed. |
| Vehicle details | Vehicle number; Vehicle category, from the categories of the driver's hub |
| Engagement details | Work type, Engagement category |

**Step 3:** User changes the fields and selects "Submit".

**Step 4:** System runs the same checks as creation for those fields (Use Case 3.2). The mobile number and vehicle number checks ignore the driver being edited.

**Step 5:** All checks pass. System saves that tab only. The driver's other tabs do not change.

**Step 6:** System shows the tab with the new values and shows the message for the tab: "Driver details updated.", "Vehicle details updated." or "Engagement details updated."

**Step 7:** User selects "Back" to return to the drivers list.

#### Use Case 5.3: Happy Case — a user adds and removes pincodes

**Step 1:** User opens "Location details" and selects "Edit".

**Step 2:** System shows: Pincode changes, a file upload; the links "Download current pincodes" and "Download sample file"; and the buttons "Submit" and "Cancel".

**Step 3:** User fills in one row for each pincode to change. The action Insert adds the pincode to the driver. The action Delete removes it. The user uploads the file.

**Step 4:** System checks the file as soon as it is uploaded and shows the result (see Use Case 3.3).

**Step 5:** User selects "Submit".

**Step 6:** System checks each row again, applies the rows that passed and leaves every other pincode of the driver as it was.

**Step 7:** System shows the tab with the new number of pincodes and shows "Location details updated."

Note: if the rows that passed would leave the driver with no pincode, System applies nothing and shows "A driver must serve at least one pincode." If the user selects "Submit" with no row that passed, System shows "There is nothing to apply."

#### Use Case 5.4: Edge Case — an edit fails a check

**Step 1:** User selects "Submit" on an edit and a check fails (Use Case 5.2, Step 4, or Use Case 5.3, Step 6).

**Step 2:** System saves nothing, keeps the form open with what the user entered, and shows the messages from Use Case 3.2 or 3.3 under the fields.

**Step 3:** User corrects the form and selects "Submit" again.

#### Use Case 5.5: Edge Case — two users change the same driver

**Step 1:** Two users open the same tab and select "Edit".

**Step 2:** Each selects "Submit". System saves the changes in the order it receives them, and the change saved last is the one kept. The earlier change is overwritten. System shows no message.

**Step 3:** Pincode changes are applied one row at a time on top of the pincodes the driver has when the file is applied, so two files that change different pincodes both take effect.

### Side effects

- A driver's hub is chosen when the driver is created and cannot be changed, because the driver's vendor and vehicle category belong to the hub.
- A vendor or vehicle category belongs to one hub. The same name can exist at several hubs as separate records.
- A driver's mobile number and vehicle number are unique across all drivers. A driver who has left and returns cannot be created again.
- Deleting a driver is not in this PRD, so no driver can be deleted. A vendor or vehicle category that has a driver can never be deleted.
- A driver has no status in this PRD. The status, its column and its filter are added with suspension and exit.
- Every later feature that reads a driver's serviceability uses the driver's serviceable pincodes.
- Driver documents and device assignment are not in this PRD.
- Assumes the System knows which pincodes each hub serves, from network setup, before implementation.

### Open points

| Question | Decides |
|---|---|
| Can a driver be moved to another hub later? This PRD fixes the hub at creation. | Tejas |

## 4. Metrics

| Metric Type | Metric | Definition |
|---|---|---|
| Success | Median time to create a driver | Median, over created drivers, of the time from the user selecting "Create driver" on the drivers list to the System saving the driver |
| Success | Creation completion | Drivers created ÷ times a user selects "Create driver" on the drivers list |
| Lead | Pincode files with no rejected row | Pincode file uploads in which every row passes ÷ all pincode file uploads |
| Lead | Pages passed on the first "Next" | Times a user selects "Next" and the page passes ÷ all times a user selects "Next" |
| Check | Drivers sharing a mobile number | Count of mobile numbers on more than one driver |
| Check | Drivers with no serviceable pincode | Drivers who serve no pincode ÷ all drivers |
| Check | Drivers tagged to a vendor or vehicle category that does not exist | Count of drivers whose vendor or vehicle category has been deleted |
| Check | Changes outside the user's hubs | Count of creates, edits and deletes of a vendor, vehicle category or driver made by a user whose own list does not include the record's hub |

## 5. Rollout & Stage Gates

| Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria |
|---|---|---|---|---|
| 1 | Prove vendor, vehicle category and driver setup at the first cutover location | Ops at the first cutover location creates its vendors and vehicle categories, then its drivers, in the portal before the location cuts over. | Median time to create a driver: target to be set from baseline. Creation completion: target to be set from baseline. | Drivers sharing a mobile number: threshold not yet set. Drivers with no serviceable pincode: threshold not yet set. Drivers tagged to a vendor or vehicle category that does not exist: threshold not yet set. Changes outside the user's hubs: threshold not yet set. |
| 2 | Every cutover location | Ops at each location creates its vendors, vehicle categories and drivers as the location cuts over. | Median time to create a driver: target to be set from baseline. Creation completion: target to be set from baseline. | Drivers sharing a mobile number: threshold not yet set. Drivers with no serviceable pincode: threshold not yet set. Drivers tagged to a vendor or vehicle category that does not exist: threshold not yet set. Changes outside the user's hubs: threshold not yet set. |
