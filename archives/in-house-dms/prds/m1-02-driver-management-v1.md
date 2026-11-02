---
**Document:** Driver Management
**Type:** Executable PRD
**Version:** v1
**Date:** 2026-11-03
**Status:** Under Review
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-11-03 | Initial draft |
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
    - [Use Case 3.3: Edge Case — a pincode file or the hub fails a check](#use-case-33-edge-case--a-pincode-file-or-the-hub-fails-a-check)
    - [Use Case 3.4: Edge Case — there is no vendor or vehicle category to choose](#use-case-34-edge-case--there-is-no-vendor-or-vehicle-category-to-choose)
    - [Use Case 3.5: Edge Case — something changes between page 1 and "Create driver"](#use-case-35-edge-case--something-changes-between-page-1-and-create-driver)
    - [Use Case 3.6: Edge Case — the user goes back, cancels or leaves](#use-case-36-edge-case--the-user-goes-back-cancels-or-leaves)
  - [Use Case 4: See and find drivers](#use-case-4-see-and-find-drivers)
    - [Use Case 4.1: Happy Case — a user opens Driver management](#use-case-41-happy-case--a-user-opens-driver-management)
    - [Use Case 4.2: Happy Case — a user searches and filters](#use-case-42-happy-case--a-user-searches-and-filters)
    - [Use Case 4.3: Edge Case — no driver to show](#use-case-43-edge-case--no-driver-to-show)
    - [Use Case 4.4: Edge Case — the user opens a driver of a hub that is not on their list](#use-case-44-edge-case--the-user-opens-a-driver-of-a-hub-that-is-not-on-their-list)
  - [Use Case 5: Edit a driver](#use-case-5-edit-a-driver)
    - [Use Case 5.1: Happy Case — a user opens a driver's profile](#use-case-51-happy-case--a-user-opens-a-drivers-profile)
    - [Use Case 5.2: Happy Case — a user edits one tab](#use-case-52-happy-case--a-user-edits-one-tab)
    - [Use Case 5.3: Edge Case — the driver's name or mobile number is changed](#use-case-53-edge-case--the-drivers-name-or-mobile-number-is-changed)
    - [Use Case 5.4: Edge Case — an edit fails a check](#use-case-54-edge-case--an-edit-fails-a-check)
    - [Use Case 5.5: Edge Case — the driver was changed by someone else](#use-case-55-edge-case--the-driver-was-changed-by-someone-else)
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
- A vendor is the company a driver works through. It has a name and a hub.
- A vehicle category is the type of vehicle a driver uses, for example a bike or a van. It has a name and a hub.
- Every driver has a status: Active, Suspended or Terminated. A driver created here is Active. Changing a status is not in this PRD.
- The System gives every driver a unique driver ID. It never changes and is never given to another driver.
- A message in quotes is shown on the screen. A message with <name> shows the name of the record.
- The limits in this PRD are fixed values: 100 characters for a name, 1 MB and 2,000 pincodes for a file, 50 drivers to a page.

### Use Case 1: Vendor management

Who: any user with at least one hub on their own list.

#### Use Case 1.1: Happy Case — a user creates a vendor

**Step 1:** User selects "Vendor management" in the menu.

**Step 2:** System shows the vendors list: one row per vendor, with columns Vendor and Hub, and the button "Create new vendor".

**Step 3:** User selects "Create new vendor".

**Step 4:** System shows a form with: Vendor name; Hub, a list of the hubs on the user's own list; and the buttons "Submit" and "Cancel".

**Step 5:** User enters the vendor's name and chooses the hub.

**Step 6:** User selects "Submit".

**Step 7:** System checks the name and the hub (see Use Case 1.2).

**Step 8:** All checks pass. System saves the vendor, returns to the vendors list and shows "<vendor> added."

Result: the vendor can be chosen on the driver form (Use Case 3).

#### Use Case 1.2: Edge Case — the vendor form fails a check

**Step 1:** User fills in the form (Use Case 1.1, or Use Case 1.3) and selects "Submit".

**Step 2:** System saves the name without leading and trailing spaces and finds that a check fails.

**Step 3:** System saves nothing, keeps the form open with what the user typed, and shows the message for each failed check under its field:

| Check that fails | Message |
|---|---|
| The vendor name is empty | "Enter the vendor's name." |
| The vendor name is longer than 100 characters | "Vendor name can have at most 100 characters." |
| No hub is chosen (create only) | "Choose a hub." |
| A vendor with this name already exists at this hub, other than the one being edited. Names that differ only in letter case or extra spaces are the same name. | "A vendor with this name already exists at this hub." |

**Step 4:** User corrects the form and selects "Submit" again.

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

**Step 3:** System checks that no driver is tagged to the vendor. The check counts drivers of every status and of every hub, including hubs the user cannot see.

**Step 4:** No driver is tagged. System deletes the vendor without asking for confirmation, and shows "<vendor> deleted."

**Step 5:** The vendor leaves the list. Its name can be used again at that hub.

#### Use Case 1.5: Edge Case — a vendor that has drivers cannot be deleted

**Step 1:** User selects "Delete" next to a vendor that has at least one driver tagged to it.

**Step 2:** System deletes nothing and shows: "This vendor has drivers tagged to it, so it can't be deleted."

**Step 3:** User changes the vendor on each of those drivers (Use Case 5), then deletes the vendor.

#### Use Case 1.6: Edge Case — the vendor was deleted by someone else

**Step 1:** User selects "Edit" or "Delete", or "Submit" on an open form, for a vendor that someone else has deleted since the list was shown.

**Step 2:** System changes nothing, shows "This vendor no longer exists." and refreshes the list.

### Use Case 2: Vehicle management

Who: any user with at least one hub on their own list. A vehicle category works like a vendor: it has a name and a hub, and a driver is tagged to one.

#### Use Case 2.1: Happy Case — a user creates a vehicle category

**Step 1:** User selects "Vehicle management" in the menu.

**Step 2:** System shows the vehicle categories list: one row per category, with columns Vehicle category and Hub, and the button "Create new vehicle category".

**Step 3:** User selects "Create new vehicle category".

**Step 4:** System shows a form with: Vehicle category name; Hub, a list of the hubs on the user's own list; and the buttons "Submit" and "Cancel".

**Step 5:** User enters the category's name and chooses the hub.

**Step 6:** User selects "Submit".

**Step 7:** System checks the name and the hub (see Use Case 2.2).

**Step 8:** All checks pass. System saves the category, returns to the list and shows "<category> added."

Result: the category can be chosen on the driver form (Use Case 3).

#### Use Case 2.2: Edge Case — the vehicle category form fails a check

**Step 1:** User fills in the form (Use Case 2.1, or Use Case 2.3) and selects "Submit".

**Step 2:** System saves the name without leading and trailing spaces and finds that a check fails.

**Step 3:** System saves nothing, keeps the form open with what the user typed, and shows the message for each failed check under its field:

| Check that fails | Message |
|---|---|
| The category name is empty | "Enter the vehicle category's name." |
| The category name is longer than 100 characters | "Vehicle category name can have at most 100 characters." |
| No hub is chosen (create only) | "Choose a hub." |
| A category with this name already exists at this hub, other than the one being edited. Names that differ only in letter case or extra spaces are the same name. | "A vehicle category with this name already exists at this hub." |

**Step 4:** User corrects the form and selects "Submit" again.

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

**Step 3:** System checks that no driver is tagged to the category. The check counts drivers of every status and of every hub, including hubs the user cannot see.

**Step 4:** No driver is tagged. System deletes the category without asking for confirmation, and shows "<category> deleted."

**Step 5:** The category leaves the list. Its name can be used again at that hub.

#### Use Case 2.5: Edge Case — a vehicle category that has drivers cannot be deleted

**Step 1:** User selects "Delete" next to a category that has at least one driver tagged to it.

**Step 2:** System deletes nothing and shows: "This vehicle category has drivers tagged to it, so it can't be deleted."

**Step 3:** User changes the category on each of those drivers (Use Case 5), then deletes the category.

#### Use Case 2.6: Edge Case — the vehicle category was deleted by someone else

**Step 1:** User selects "Edit" or "Delete", or "Submit" on an open form, for a category that someone else has deleted since the list was shown.

**Step 2:** System changes nothing, shows "This vehicle category no longer exists." and refreshes the list.

### Use Case 3: Create a driver

Who: any user with at least one hub on their own list. The driver form offers the vendors and vehicle categories of every hub on the user's own list, not only those of the driver's hub. Each option shows the name and then the hub, for example "Bike · Pune DC".

#### Use Case 3.1: Happy Case — a user creates a driver

**Step 1:** User selects "Driver management" in the menu. System shows the drivers list (Use Case 4).

**Step 2:** User selects "Create driver".

**Step 3:** System shows page 1, Driver and vehicle details, with these fields: Driver name; Mobile number; Vehicle number; Vehicle category, a list; Vendor, a list. It shows the buttons "Next" and "Cancel".

**Step 4:** User fills in the five fields and selects "Next".

**Step 5:** System checks the five fields (see Use Case 3.2).

**Step 6:** All checks pass. System shows page 2, Engagement details, with: Work type, a list of "Full time" and "Part time"; Engagement category, a list of "Temporary" and "Permanent". It shows the buttons "Back", "Next" and "Cancel".

**Step 7:** User chooses a work type and an engagement category and selects "Next".

**Step 8:** System checks that both are chosen (see Use Case 3.2).

**Step 9:** Both are chosen. System shows page 3, Location details, with: Serviceable pincodes, a file upload that is required; Blacklisted pincodes, a file upload that is optional; a link "Download template"; Hub, a list of the hubs on the user's own list. It shows the buttons "Back", "Create driver" and "Cancel".

**Step 10:** User uploads the serviceable pincodes file, uploads the blacklisted pincodes file if there is one, and chooses the hub.

**Step 11:** User selects "Create driver".

**Step 12:** System checks the files and the hub (see Use Case 3.3). It then checks the mobile number, the vehicle number, the vendor and the vehicle category again (see Use Case 3.5).

**Step 13:** All checks pass. System creates the driver with a new driver ID and the status Active, and saves the serviceable and blacklisted pincodes.

**Step 14:** System returns to the drivers list and shows "<driver name> created." The new driver is in the list when its hub is covered by the serving location dropdown.

Result: the driver is in the System with a vendor, a vehicle, an engagement and serviceable pincodes. The driver is Active.

#### Use Case 3.2: Edge Case — a field on page 1 or page 2 fails a check

**Step 1:** User selects "Next" on page 1 or page 2.

**Step 2:** System finds that a check fails.

**Step 3:** System stays on the page, keeps what the user entered, and shows the message for each failed check under its field:

| Check that fails | Message |
|---|---|
| The driver name is empty | "Enter the driver's name." |
| The driver name has anything other than letters, spaces, full stops, apostrophes and hyphens, or is longer than 100 characters | "Driver name can have letters, spaces, full stops, apostrophes and hyphens only, up to 100 characters." |
| The mobile number is empty, or is not 10 digits starting with 6, 7, 8 or 9 (spaces are ignored) | "Enter a valid 10-digit mobile number." |
| Another driver, of any status at any hub, has this mobile number | "A driver with this mobile number already exists." |
| The vehicle number is empty, or is not an Indian vehicle registration number (see the note below) | "Enter a valid vehicle number, for example MH12AB1234." |
| Another driver whose status is Active or Suspended has this vehicle number | "This vehicle number is already on another driver." |
| No vehicle category is chosen | "Choose a vehicle category." |
| No vendor is chosen | "Choose a vendor." |
| No work type is chosen | "Choose a work type." |
| No engagement category is chosen | "Choose an engagement category." |

**Step 4:** User corrects the page and selects "Next" again.

Note: the System removes spaces and hyphens from the vehicle number and saves it in capital letters. A valid number is 2 letters, 2 digits, 1 to 3 letters and 4 digits (for example MH12AB1234), or 2 digits, "BH", 4 digits and 1 or 2 letters (for example 22BH1234AA). The driver name is saved with single spaces. The mobile number is saved as 10 digits.

#### Use Case 3.3: Edge Case — a pincode file or the hub fails a check

**Step 1:** User selects "Create driver" on page 3 (or "Submit" on the Location details edit, Use Case 5.2).

**Step 2:** System reads each file that was uploaded. It reads the first sheet and column A only, skips blank rows, removes spaces around each value, accepts a value stored as a number or as text, and counts a pincode that appears more than once as one.

**Step 3:** System finds that a check fails. It creates or saves nothing, and uses nothing from a file that fails.

**Step 4:** System stays on the page, keeps the hub and the other file, and shows the message for each failed check next to its file or field:

| Check that fails | Message |
|---|---|
| No serviceable pincodes file is uploaded | "Upload the serviceable pincodes file." |
| A file is not an .xlsx file, is larger than 1 MB, or cannot be opened | "We couldn't read this file. Upload an .xlsx file of 1 MB or less, made from the template." |
| Cell A1 of the first sheet does not say Pincode | "The first cell must say Pincode. Use the template." |
| A value in column A is not a number from 100000 to 999999 | "Row <n>: <value> is not a valid pincode." |
| A pincode is not in the System's list of pincodes | "Row <n>: <pincode> is not a pincode the System serves." |
| A file has no pincodes | "The file has no pincodes." |
| A file has more than 2,000 different pincodes | "The file has more than 2,000 pincodes." |
| Every serviceable pincode is also in the blacklisted file | "Every serviceable pincode is blacklisted. The driver would serve no pincodes." |
| No hub is chosen | "Choose a hub." |

**Step 5:** When a file has row errors, System lists the first 10, then shows "<k> more rows have errors." if there are more. A row number is the row number in Excel, where the header is row 1.

**Step 6:** User corrects the file and uploads it again.

Note: a pincode that is in both files is not served: the blacklist wins. The driver serves the serviceable pincodes less the blacklisted pincodes. The template is an .xlsx file whose cell A1 says Pincode.

#### Use Case 3.4: Edge Case — there is no vendor or vehicle category to choose

**Step 1:** User opens the Vendor list on page 1 and it has no vendor, or opens the Vehicle category list and it has no category.

**Step 2:** System shows under the list: "No vendors yet. Create one in Vendor management." or "No vehicle categories yet. Create one in Vehicle management."

**Step 3:** User cannot select "Next" past page 1 without choosing one (Use Case 3.2). User selects "Cancel", creates the vendor or category (Use Case 1 or 2) and starts again. Nothing entered is kept (Use Case 3.6).

#### Use Case 3.5: Edge Case — something changes between page 1 and "Create driver"

**Step 1:** User selects "Create driver" on page 3.

**Step 2:** System finds that the vendor or vehicle category chosen on page 1 has been deleted, or that another driver now has the mobile number or the vehicle number.

**Step 3:** System creates nothing, returns the user to page 1 with the other fields kept, and shows the message under the field: "This vendor no longer exists. Choose another." or "This vehicle category no longer exists. Choose another." or the mobile number or vehicle number message from Use Case 3.2.

**Step 4:** User corrects page 1 and goes through pages 2 and 3 again. The files on page 3 are kept.

#### Use Case 3.6: Edge Case — the user goes back, cancels or leaves

**Step 1:** User selects "Back" on page 2 or page 3. System shows the previous page with what the user entered, and any uploaded file, kept.

**Step 2:** User selects "Cancel" on any page. System returns to the drivers list and creates nothing.

**Step 3:** User closes the tab, refreshes the page, signs out, or is signed out by the System. Everything entered is lost.

**Step 4:** Nothing is saved until "Create driver" passes every check. If "Create driver" is selected twice, System creates one driver: the second attempt fails the mobile number check.

### Use Case 4: See and find drivers

Who: any user with at least one hub on their own list.

#### Use Case 4.1: Happy Case — a user opens Driver management

**Step 1:** User selects "Driver management" in the menu.

**Step 2:** System shows the drivers list: one row per driver, for the hubs on the user's own list that the serving location dropdown covers.

**Step 3:** Each row shows: Driver ID, Driver name, Hub and Status, and a chevron.

**Step 4:** The list shows the newest drivers first, 50 to a page. Above it are a search box, a Status filter and the button "Create driver".

Result: the user sees only the drivers of their hubs.

#### Use Case 4.2: Happy Case — a user searches and filters

**Step 1:** User types in the search box.

**Step 2:** System shows the drivers whose driver ID, driver name, mobile number, hub name or vendor name contains the text, ignoring letter case and spaces.

**Step 3:** User chooses a status in the Status filter: "All", "Active", "Suspended" or "Terminated". The filter starts on "All".

**Step 4:** System shows the drivers that match the search and the status together.

**Step 5:** User clears the search box. System shows the drivers for the chosen status again.

Note: the list does not show the mobile number, the vendor or the vehicle. They are searchable and shown on the driver's profile (Use Case 5.1).

#### Use Case 4.3: Edge Case — no driver to show

**Step 1:** The user's hubs have no driver and the search box and filter are empty. System shows "No drivers yet." and the button "Create driver".

**Step 2:** A search or a filter matches no driver. System shows "No drivers found."

#### Use Case 4.4: Edge Case — the user opens a driver of a hub that is not on their list

**Step 1:** User opens a driver's page, for example from a saved link, and the driver's hub is not on the user's own list.

**Step 2:** System shows no data about the driver and shows: "You don't have access to this location."

### Use Case 5: Edit a driver

Who: any user with the driver's hub on their own list. Deleting a driver and changing a status are not in this PRD.

#### Use Case 5.1: Happy Case — a user opens a driver's profile

**Step 1:** User finds the driver (Use Case 4.2) and selects the chevron on the row.

**Step 2:** System shows the driver's profile with four tabs: "Driver details", "Vehicle details", "Engagement details" and "Location details". "Driver details" opens first. Each tab has an "Edit" button.

**Step 3:** System shows these fields on the tabs:

| Tab | Fields shown |
|---|---|
| Driver details | Driver ID, Driver name, Mobile number, Vendor (name and hub), Status |
| Vehicle details | Vehicle number, Vehicle category (name and hub) |
| Engagement details | Work type, Engagement category |
| Location details | Hub; the number of serviceable pincodes and the number of blacklisted pincodes, each with a link "Download" |

**Step 4:** User selects "Back" to return to the drivers list.

#### Use Case 5.2: Happy Case — a user edits one tab

**Step 1:** User opens a tab and selects "Edit".

**Step 2:** System shows the fields of that tab as the creation pages show them, filled with the driver's current values, with the buttons "Submit" and "Cancel". Only the tab's editable fields are open:

| Tab | Fields the user can change |
|---|---|
| Driver details | Vendor. The driver's name and mobile number cannot be changed. |
| Vehicle details | Vehicle number, Vehicle category |
| Engagement details | Work type, Engagement category |
| Location details | Serviceable pincodes file, Blacklisted pincodes file, Hub. The files replace the driver's lists, so the serviceable file is required each time, and no blacklisted file means no blacklist. "Download" gives the current lists. |

**Step 3:** User changes the fields and selects "Submit".

**Step 4:** System runs the same checks as creation for those fields (Use Cases 3.2, 3.3 and 3.5). The vehicle number check ignores the driver being edited.

**Step 5:** All checks pass. System saves that tab only. The driver's other tabs do not change.

**Step 6:** System shows the tab with the new values and shows the message for the tab: "Driver details updated.", "Vehicle details updated.", "Engagement details updated." or "Location details updated."

**Step 7:** User selects "Back" to return to the drivers list.

#### Use Case 5.3: Edge Case — the driver's name or mobile number is changed

**Step 1:** User tries to change the driver's name or mobile number another way, for example from a saved link.

**Step 2:** System refuses and shows: "Driver name and mobile number can't be changed."

#### Use Case 5.4: Edge Case — an edit fails a check

**Step 1:** User selects "Submit" on an edit and a check fails (Use Case 5.2, Step 4).

**Step 2:** System saves nothing, keeps the form open with what the user entered, and shows the messages from Use Case 3.2, 3.3 or 3.5 under the fields.

**Step 3:** User corrects the form and selects "Submit" again.

#### Use Case 5.5: Edge Case — the driver was changed by someone else

**Step 1:** User selects "Submit" on an edit of a driver that someone else has changed since the user selected "Edit".

**Step 2:** System saves nothing and shows: "This driver was changed by someone else. Open it again."

**Step 3:** User opens the driver again and repeats the edit.

### Side effects

- Until suspension and exit are built, every driver is Active. The Status column and filter are ready for them.
- Deleting a driver is not in this PRD, so no driver can be deleted. A Terminated driver, once the status exists, still blocks the deletion of their vendor and vehicle category.
- A driver's mobile number is unique across the System, whatever the driver's status. A driver who has left and returns cannot be created again.
- A driver's profile shows the vendor and vehicle category by name even when their hub is not on the user's own list. The user cannot choose such a vendor or category on a form.
- A driver moves with their hub: when a user changes the hub, users of the old hub no longer see the driver and users of the new hub do.
- Every later feature that reads a driver's serviceability uses the serviceable pincodes less the blacklisted pincodes.
- Driver documents and device assignment are not in this PRD.
- Assumes the System holds the list of pincodes from network setup before implementation.

### Open points

| Question | Decides |
|---|---|
| Which roles can open and use Vehicle management and Driver management? This PRD lets every role, as the PM stated for vendors. | Tejas |
| Must every driver have a vendor? This PRD requires one. | Tejas |
| Is a pincode that is in both files meant to be served? This PRD lets the blacklist win. | Tejas |
| Must a serviceable pincode be inside the hub's own serviceable area from network setup, or is any pincode in the System's list enough? This PRD checks the System's list only. | Tejas |
| Are vehicle categories kept per hub, with a Hub field on the form, as vendors are? This PRD says yes. | Tejas |

## 4. Metrics

| Metric Type | Metric | Definition |
|---|---|---|
| Success | Median time to create a driver | Median, over created drivers, of the time from the user selecting "Create driver" on the drivers list to the System saving the driver |
| Success | Creation completion | Drivers created ÷ times a user selects "Create driver" on the drivers list |
| Lead | Pincode files accepted on the first upload | Pincode file uploads with no check failed ÷ all pincode file uploads |
| Lead | Pages passed on the first "Next" | Times a user selects "Next" and the page passes ÷ all times a user selects "Next" |
| Check | Drivers sharing a mobile number | Count of mobile numbers on more than one driver |
| Check | Drivers with no serviceable pincode | Drivers whose serviceable pincodes, less the blacklisted pincodes, number zero ÷ all drivers |
| Check | Drivers tagged to a vendor or vehicle category that does not exist | Count of drivers whose vendor or vehicle category has been deleted |
| Check | Changes outside the user's hubs | Count of creates, edits and deletes of a vendor, vehicle category or driver made by a user whose own list does not include the record's hub |

## 5. Rollout & Stage Gates

| Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria |
|---|---|---|---|---|
| 1 | Prove vendor, vehicle category and driver setup at the first cutover location | Ops at the first cutover location creates its vendors and vehicle categories, then its drivers, in the portal before the location cuts over. | Median time to create a driver: target to be set from baseline. Creation completion: target to be set from baseline. | Drivers sharing a mobile number: threshold not yet set. Drivers with no serviceable pincode: threshold not yet set. Drivers tagged to a vendor or vehicle category that does not exist: threshold not yet set. Changes outside the user's hubs: threshold not yet set. |
| 2 | Every cutover location | Ops at each location creates its vendors, vehicle categories and drivers as the location cuts over. | Median time to create a driver: target to be set from baseline. Creation completion: target to be set from baseline. | Drivers sharing a mobile number: threshold not yet set. Drivers with no serviceable pincode: threshold not yet set. Drivers tagged to a vendor or vehicle category that does not exist: threshold not yet set. Changes outside the user's hubs: threshold not yet set. |
