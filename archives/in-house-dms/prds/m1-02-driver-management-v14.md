---
**Document:** Driver Management
**Type:** Executable PRD
**Version:** v14
**Date:** 2026-11-05
**Status:** Approved
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v14 | 2026-11-05 | The driver profile is one page of five cards, not four tabs: Driver details, Vehicle details and Engagement details, then Hub and Serviceability, each with its own button (Use Case 4.1). Edit hub and Edit serviceability each open a page for that workflow only, in three steps (Use Cases 4.3 and 4.4). The page does not list the driver's pincodes: they are a download. The save buttons are Save changes, Save serviceability and Move driver, and are not offered until the page can be saved. Because of that, "There is nothing to apply." is removed, and the message after saving pincodes is "Serviceability updated." Decisions 11 and 12 record the change. |
---

# [PRD] Driver Management

**Systems:** Driver Management (new, no Context) · User Management · **Verticals:** Hyperlocal Forward, Hyperlocal Reverse

**Contents**

- [1. Objective](#1-objective)
- [2. Why Now](#2-why-now)
- [3. Use Cases](#3-use-cases)
  - [Use Case 1: Vendor management](#use-case-1-vendor-management)
  - [Use Case 2: Create a driver](#use-case-2-create-a-driver)
  - [Use Case 3: See and find drivers](#use-case-3-see-and-find-drivers)
  - [Use Case 4: Edit a driver](#use-case-4-edit-a-driver)
  - [Use Case 5: Module access](#use-case-5-module-access)
  - [Side effects](#side-effects)
- [4. Metrics](#4-metrics)
- [5. Rollout & Stage Gates](#5-rollout--stage-gates)
- [6. Decisions](#6-decisions)

## 1. Objective

Every driver who works from a hub is in the System, with a vendor, a vehicle and the pincodes they serve, before they take their first order.

## 2. Why Now

Shipsy holds Truemeds' riders today. The in-house system has nowhere to create a driver, to record which vendor the driver comes from and which vehicle they use, or to say which pincodes they serve. No driver can use the in-house rider app, and no order can be given to a driver, until the driver is in the System with this information. How long it takes to create a driver, and how many are set up correctly, is not measured.

The first cutover location needs all of its drivers in the System before it cuts over from Shipsy. Serving locations grow from 39 to 150 in the next 15 months, so drivers will be created at every location as it cuts over. Until this ships, nothing that depends on a driver can be built or tested: driver login, order assignment, allocation and payouts.

## 3. Use Cases

This PRD adds two tabs to the Hyperlocal Fleet Management Portal: Vendor management and Driver management. Each tab is a module of the portal (User Management PRD). It applies to every ops user whose role holds the module, in both verticals. The rider app is out of scope.

**Terms**

- A hub is a serving location: a warehouse or a DC (see User Management). A user's own list is the list of hubs set for their email in User Management. A user with "All locations" has every hub on their own list.
- A vendor is the company a driver works through. A vendor is one record that works at one or more hubs, and its name is unique across the System.
- A vehicle category is the type of vehicle a driver uses, for example a bike or a van. Vehicle categories are kept in the System by engineering: the portal has no screen to create, edit or delete one, and engineering adds one when it is needed.
- A vehicle category belongs to no hub, and a driver of any hub can be tagged to any of them. Wherever a vehicle category is chosen, the list shows every vehicle category, whatever the serving location dropdown says.
- A driver belongs to one hub and can be tagged only to a vendor that works at that hub. The System gives every driver a unique driver ID. It never changes and is never given to another driver.
- A driver serves a set of pincodes, at least one and at most 100, and the driver's hub serves every one of them. The set is always a full list: each upload replaces it (Use Case 2.3).
- Regional Manager or above means Regional Manager and every role ranked above it in the User Management PRD: Admin, Central Logistics Ops, Control Tower and Finance. Executive is below it.

**What a user sees and changes**

- The drivers list shows only drivers of hubs on the user's own list, narrowed by the serving location dropdown in the top bar: all of the user's hubs when "All serving locations" is selected, otherwise the one hub selected. The vendors list shows a vendor that works at a hub the dropdown covers, and shows only the hubs of the vendor that are on the user's own list.
- A Hub field on a form offers only the hubs on the user's own list.
- A user can add or remove only hubs on their own list. The hubs of a vendor that are outside the user's own list are not shown to them and stay as they are when the user edits the vendor. A user can delete a vendor only when every hub of the vendor is on their own list.
- After a create or an edit of a vendor or a driver, the message shows even when none of the record's hubs is covered by the dropdown. The record then does not show in the list.
- The menu shows a tab only if the user's role holds its module, and a user can open only those tabs (Use Case 5). Inside a tab, the System restricts by role in one place only: changing a driver's name and mobile number (Use Case 4.2). Any user who can open the tab can do everything else in it for their hubs.
- When two users change the same record or field at the same time, the change the System saves last is the one kept.

**Messages and limits**

- A message in quotes is shown on the screen. A message about a field shows under the field. A message that refuses an action, such as deleting a vendor that has drivers, shows as a toast that clears after about 4 seconds. A message with <name> shows the name of the record.
- The limits are fixed values: 100 characters for a name, 1 MB for a file, 100 pincodes for a file and for a driver, and 10, 20, 50 or 100 drivers to a page.

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

#### Use Case 1.2: Edge Case — the vendor form fails a check

**Step 1:** User selects "Review" on the form (Use Case 1.1), or "Submit" on the review screen or on the edit form (Use Case 1.3).

**Step 2:** System saves the name without leading and trailing spaces and finds that a check fails.

**Step 3:** System saves nothing, shows the form with what the user typed, and shows the message for each failed check under its field:

| Check that fails | Message |
|---|---|
| The vendor name is empty | "Enter the vendor's name." |
| The vendor name is longer than 100 characters | "Vendor name can have at most 100 characters." |
| The vendor would work at no hub: no hub is ticked, and the vendor has no hub outside the user's own list | "Choose at least one hub." |
| Another vendor, at any hub, has this name. Names that differ only in letter case or extra spaces are the same name. | "A vendor with this name already exists." |

**Step 4:** User corrects the form and selects "Review" or "Submit" again.

#### Use Case 1.3: Happy Case — a user edits a vendor's name or hubs

**Step 1:** User selects "Vendor management". System shows the vendors list.

**Step 2:** User selects "Edit" next to the vendor.

**Step 3:** System shows the form with the name filled in and the Hubs list as on the create form, with the hubs the vendor works at ticked.

**Step 4:** A hub where a driver is tagged to this vendor stays ticked and cannot be unticked. When there is one, System shows under Hubs: "A hub with drivers tagged to this vendor can't be unticked."

**Step 5:** User changes the name, and ticks or unticks hubs. Unticking "All locations" unticks every hub that can be unticked. User selects "Submit".

**Step 6:** System checks the name and the hubs (see Use Case 1.2), and checks again that no hub unticked has a driver tagged to this vendor (see Use Case 1.7).

**Step 7:** System saves the name and the hubs. The hubs of the vendor that are not on the user's own list stay as they are. Every driver tagged to this vendor shows the new name from this moment.

**Step 8:** System returns to the vendors list and shows "<vendor> updated."

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

**Step 3:** User changes the vendor on each of those drivers (Use Case 4), then deletes the vendor.

#### Use Case 1.6: Edge Case — the vendor was deleted by someone else

**Step 1:** User selects "Edit" or "Delete", or "Submit" on an open form, for a vendor that someone else has deleted since the list was shown.

**Step 2:** System changes nothing, shows the toast "This vendor no longer exists." and refreshes the list.

#### Use Case 1.7: Edge Case — a hub is given drivers while the form is open

**Step 1:** User opens the edit form (Use Case 1.3) and unticks a hub where no driver is tagged to the vendor. Someone then tags a driver at that hub to the vendor.

**Step 2:** User selects "Submit".

**Step 3:** System saves nothing. It keeps the form open with the name the user typed, ticks the hub again and does not let it be unticked, and shows the toast: "Drivers are tagged to this vendor at <hubs>, so it can't be removed there."

**Step 4:** User selects "Submit" again, or first changes the vendor on those drivers (Use Case 4).

Note: <hubs> lists the names of the hubs, separated by commas.

### Use Case 2: Create a driver

Who: any user whose role holds Driver management and who has at least one hub on their own list.

#### Use Case 2.1: Happy Case — a user creates a driver

**Step 1:** User selects "Driver management" in the menu. System shows the drivers list (Use Case 3).

**Step 2:** User selects "Create driver".

**Step 3:** System shows page 1, Driver and vehicle details, with these fields: Hub, a list; Driver name; Mobile number; Vehicle number; Vehicle category, a list; Vendor, a list. It shows the buttons "Next" and "Cancel".

**Step 4:** User chooses the hub. The Vendor list shows only the vendors that work at that hub. Until a hub is chosen, it is empty. The Vehicle category list shows every vehicle category.

**Step 5:** User fills in the other five fields and selects "Next".

**Step 6:** System checks the six fields (see Use Case 2.2).

**Step 7:** All checks pass. System shows page 2, Engagement details, with: Work type, a list of "Full time" and "Part time"; Engagement category, a list of "Temporary" and "Permanent". It shows the buttons "Back", "Next" and "Cancel".

**Step 8:** User chooses a work type and an engagement category and selects "Next".

**Step 9:** System checks that both are chosen (see Use Case 2.2).

**Step 10:** Both are chosen. System shows page 3, Location details, with: Serviceable pincodes, a file upload; a link "Download hub pincodes"; and the buttons "Back", "Create driver" and "Cancel".

**Step 11:** User selects "Download hub pincodes" to get a .csv file of every pincode the hub serves, removes the rows of the pincodes the driver does not serve, so that at most 100 remain, and uploads the file.

**Step 12:** System checks the file as soon as it is uploaded and shows the result (see Use Case 2.3).

**Step 13:** User selects "Create driver".

**Step 14:** System checks everything again (see Use Case 2.5).

**Step 15:** All checks pass. System creates the driver with a new driver ID, saves the pincodes in the file, returns to the drivers list and shows "<driver name> created." The new driver is in the list when its hub is covered by the serving location dropdown.

Result: the driver is in the System with a hub, a vendor, a vehicle, an engagement and serviceable pincodes.

#### Use Case 2.2: Edge Case — a field on page 1 or page 2 fails a check

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
| The vehicle number is empty, or has a lowercase letter or a space | "Enter the vehicle number in capital letters and without spaces, for example MH12AB1234." |
| No vehicle category is chosen | "Choose a vehicle category." |
| No vendor is chosen | "Choose a vendor." |
| The vendor chosen has been deleted | "This vendor no longer exists. Choose another." |
| The vendor chosen is not at the driver's hub. This happens when someone else removed the hub from the vendor after the user chose it. | "This vendor is not at the driver's hub. Choose another." |
| No work type is chosen | "Choose a work type." |
| No engagement category is chosen | "Choose an engagement category." |

**Step 4:** User corrects the page and selects "Next" again. The user cannot go on to the next page until every check passes.

System saves the driver name with single spaces and the mobile number as 10 digits. The vehicle number has no other check and is saved as entered.

#### Use Case 2.3: Edge Case — the pincode file has errors

**Step 1:** User uploads a pincode file on page 3 (Use Case 2.1), on Edit serviceability (Use Case 4.3) or on Edit hub (Use Case 4.4). The file is the driver's full list of pincodes: it replaces whatever the driver serves.

**Step 2:** System reads the whole file. If a file check fails, System uses nothing from the file, shows the message and waits for another file:

| File check that fails | Message |
|---|---|
| The file is not a .csv file, is larger than 1 MB, or cannot be read | "We couldn't read this file. Upload a .csv file of 1 MB or less, made from a downloaded pincode file." |
| The first row does not have the column Pincode | "The first row must have the column Pincode. Use a downloaded pincode file." |
| The file has no row below the first | "The file has no pincodes." |
| The Pincode column has more than 100 different values (blank rows and repeats are not counted) | "A driver can serve at most 100 pincodes." |

**Step 3:** System goes through the rows in the order of the file, skipping blank rows and removing spaces around each value. A row that fails a row check is set aside with its reason:

| Row check that fails | Reason shown for the row |
|---|---|
| The pincode is not a number from 100000 to 999999 | "Not a valid pincode." |
| The hub the driver is in, or is moving to, does not serve the pincode | "<hub> does not serve this pincode." |

**Step 4:** The pincodes of the rows that pass are the pincodes the driver will serve. A pincode that appears more than once counts once, with no error.

**Step 5:** System shows the result before anything is saved. Let n be the different pincodes the rows that pass give, and m the rows with an error.

| System shows | When |
|---|---|
| "<n> pincodes will be saved. <m> rows have errors." | Always |
| The first 10 rows with errors, each as "Row <r>: <pincode> — <reason>" | m is more than zero |
| The link "Download success file" | n is more than zero |
| The link "Download error file" | m is more than zero |
| "No pincode can be saved." and no "Create driver", "Save serviceability" or "Move driver" until a file with a pincode that passes is uploaded | n is zero |

**Step 6:** User uploads a corrected file, which replaces the earlier file (nothing from it is kept), or continues, and the driver serves the n pincodes. Rows with errors are never saved.

The four files, all .csv:

| File | Columns | One line for | How the user gets it |
|---|---|---|---|
| Hub pincode file | Pincode | Each pincode the hub serves | "Download hub pincodes", on page 3, on Edit serviceability and on Edit hub |
| Current pincode file | Pincode | Each pincode the driver serves now | "Download current pincodes", on the Serviceability card, on Edit serviceability and on Edit hub |
| Error file | Row, Pincode, Error | Each row that failed | "Download error file", when m is more than zero |
| Success file | Row, Pincode | Each pincode that will be saved, at the first row it appears | "Download success file", when n is more than zero |

Note: Row is the row in the file, where the header is row 1.

#### Use Case 2.4: Edge Case — there is no vendor to choose

**Step 1:** User chooses a hub on page 1 and the Vendor list has nothing in it.

**Step 2:** System shows under the list: "No vendors at this hub yet. Ask a user who has Vendor management to add one."

**Step 3:** User cannot go past page 1 without choosing a vendor (Use Case 2.2). User selects "Cancel", asks a user whose role holds Vendor management to create the vendor (Use Case 1), and starts again. Nothing entered is kept (Use Case 2.6).

#### Use Case 2.5: Edge Case — something changes before "Create driver"

**Step 1:** User selects "Create driver" on page 3, some time after selecting "Next" on page 1.

**Step 2:** System checks pages 1 and 2 again and checks each pincode in the file again. It finds that the vendor has been deleted or no longer works at the hub, that another driver now has the mobile number, or that a pincode no longer passes.

**Step 3:** System creates nothing.

**Step 3.A:** For a problem on page 1, System takes the user to page 1 with the other fields kept and shows the message from Use Case 2.2 under the field. The user cannot go on until it is resolved.

**Step 3.B:** For a pincode, System stays on page 3 and shows the new result (Use Case 2.3).

#### Use Case 2.6: Edge Case — the user moves between pages, cancels or leaves

**Step 1:** User moves to another page with "Back" or "Next". What the user entered on the page they leave is kept, and the page shows it again when they come back. This includes the uploaded file and its result on page 3.

**Step 2:** User changes the hub on page 1. System clears the Vendor and the uploaded file with its result, because they belong to the hub. Everything else is kept.

**Step 3:** User selects "Cancel" on any page. System returns to the drivers list and creates nothing.

**Step 4:** User closes the tab, refreshes the page, signs out, or is signed out by the System. Everything entered is lost.

**Step 5:** Nothing is saved until "Create driver" passes every check. If "Create driver" is selected twice, System creates one driver: the second attempt fails the mobile number check.

### Use Case 3: See and find drivers

Who: any user whose role holds Driver management and who has at least one hub on their own list.

#### Use Case 3.1: Happy Case — a user opens Driver management

**Step 1:** User selects "Driver management" in the menu.

**Step 2:** System shows the drivers list: one row per driver, for the hubs on the user's own list that the serving location dropdown covers.

**Step 3:** Each row shows: Driver ID, Driver name, Hub, Vendor and Vehicle category, and a chevron.

**Step 4:** The list shows the newest drivers first. Above it are three filters, Name, Mobile number and Hub, a choice of drivers to a page (10, 20, 50 or 100, starting on 20), and the button "Create driver".

#### Use Case 3.2: Happy Case — a user filters the list

**Step 1:** User types in the Name filter or the Mobile number filter, or chooses a hub in the Hub filter. Name and Mobile number start empty, and Hub starts on "All".

**Step 2:** System shows the drivers that match every filter that has a value, together:

| Filter | Matches |
|---|---|
| Name | Drivers whose name contains the text, ignoring letter case and spaces |
| Mobile number | Drivers whose mobile number contains the text, ignoring spaces |
| Hub | Drivers of that hub. The filter lists the hubs the serving location dropdown covers. |

**Step 3:** User clears a filter, or sets Hub back to "All". System widens the list again.

Note: the list does not show the mobile number or the vehicle number. The mobile number can be filtered, and both are shown on the driver's profile (Use Case 4.1).

#### Use Case 3.3: Edge Case — no driver to show

**Step 1:** The hubs the dropdown covers have no driver at all. System shows only "No drivers yet." and the button "Create driver", with no filters or page size.

**Step 2:** A filter matches no driver. System shows "No drivers found." and keeps the filters.

#### Use Case 3.4: Edge Case — the user opens a driver of a hub that is not on their list

**Step 1:** User opens a driver's page, for example from a saved link, and the driver's hub is not on the user's own list.

**Step 2:** System shows no data about the driver and shows: "You don't have access to this location."

### Use Case 4: Edit a driver

Who: any user whose role holds Driver management and who has the driver's hub on their own list. Deleting a driver is not in this PRD.

#### Use Case 4.1: Happy Case — a user opens a driver's profile

**Step 1:** User finds the driver (Use Case 3.2) and selects the chevron on the row.

**Step 2:** System shows the driver's profile as one page. At the top are the driver's name, the driver ID and a "Back" button. Below are two groups of cards. The Driver group has the cards "Driver details", "Vehicle details" and "Engagement details". The Location group has the cards "Hub" and "Serviceability". Each card has one button: "Edit" on the three Driver cards, "Edit hub" on Hub and "Edit serviceability" on Serviceability.

**Step 3:** System shows these fields on the cards:

| Card | Fields shown |
|---|---|
| Driver details | Driver ID, Driver name, Mobile number, Vendor |
| Vehicle details | Vehicle number, Vehicle category |
| Engagement details | Work type, Engagement category |
| Hub | Hub, Vendor at this hub |
| Serviceability | The number of pincodes the driver serves, as "<n> pincodes" with "of 100 allowed" beside it, and the link "Download current pincodes" |

**Step 4:** User selects "Back" to return to the drivers list.

Note: the page does not list the driver's pincodes. The link "Download current pincodes" is the only way to see them.

#### Use Case 4.2: Happy Case — a user edits Driver details, Vehicle details or Engagement details

**Step 1:** User selects "Edit" on the "Driver details", "Vehicle details" or "Engagement details" card.

**Step 2:** System opens a page for that card only, titled "Edit driver details", "Edit vehicle details" or "Edit engagement details". It shows the fields of that card as the creation pages show them, filled with the driver's current values, with the buttons "Save changes" and "Cancel". Only these fields are open:

| Card | Fields the user can change |
|---|---|
| Driver details | Vendor, from the vendors that work at the driver's hub. A user whose role is Regional Manager or above can also change Driver name and Mobile number (the table in Use Case 5.1). For any other user they show but cannot be changed. |
| Vehicle details | Vehicle number; Vehicle category, from every vehicle category |
| Engagement details | Work type, Engagement category |

**Step 3:** User changes the fields and selects "Save changes".

**Step 4:** System runs the same checks as creation for those fields (Use Case 2.2), the checks in Use Case 4.5 and, when the name or mobile number has changed, the role check in Use Case 4.7. The mobile number check ignores the driver being edited.

**Step 5:** All checks pass. System saves that card only. The driver's other cards do not change.

**Step 6:** System shows the profile with the new values and shows the message for the card: "Driver details updated.", "Vehicle details updated." or "Engagement details updated."

**Step 7:** User selects "Back" to return to the drivers list.

#### Use Case 4.3: Happy Case — a user changes a driver's pincodes

**Step 1:** User selects "Edit serviceability" on the "Serviceability" card.

**Step 2:** System opens a page for the driver's serviceability only. It shows, in this order: the links "Download current pincodes" and "Download hub pincodes"; a file upload; the result of the file, which shows "Upload a file to see what will be saved." until a file is uploaded; and the buttons "Save serviceability" and "Cancel". "Save serviceability" is not offered until a file with a pincode that passes has been uploaded (Use Case 2.3, Step 5).

**Step 3:** User downloads the driver's current pincodes, adds the pincodes the driver now serves, which they can take from the hub's pincodes, removes the ones it no longer serves, so that at most 100 remain, and uploads the file.

**Step 4:** System checks the file as soon as it is uploaded and shows the result (see Use Case 2.3). When the file has a pincode that passes, the result also shows "Compared with the driver's current pincodes" and, under it, "<n> stay", "<n> added" and "<n> removed: <pincodes>".

**Step 5:** User selects "Save serviceability".

**Step 6:** System checks each pincode again (see Use Case 2.3).

**Step 7:** System replaces the driver's pincodes with the pincodes in the file. A pincode of the driver that is not in the file is removed.

**Step 8:** System shows the profile with the new number of pincodes on the Serviceability card and shows "Serviceability updated."

#### Use Case 4.4: Happy Case — a user changes a driver's hub

**Step 1:** User selects "Edit hub" on the "Hub" card.

**Step 2:** System opens a page for moving the driver only. It shows the note "Moving a driver replaces their pincodes with the file you upload. Users of <hub> will no longer see this driver, and users of the new hub will." with <hub> the driver's current hub. Under it are three steps, in this order: the new hub and the vendor; the driver's serviceability at the new hub; and a review of the move. It shows the buttons "Move driver" and "Cancel". "Move driver" is not offered until a file with a pincode that passes has been uploaded (Use Case 2.3, Step 5).

**Step 3:** In the first step, User chooses a hub other than the driver's current hub, from a list of the hubs on the user's own list. The Vendor list shows only the vendors that work at that hub. Until a hub is chosen, it is empty.

**Step 4:** User chooses a vendor. The second step, which was locked, now shows the links "Download hub pincodes" and "Download current pincodes" and a file upload. The third step stays locked.

**Step 5:** User selects "Download hub pincodes" to get the pincodes of the new hub, removes the rows of the pincodes the driver will not serve there, so that at most 100 remain, and uploads the file.

**Step 6:** System checks the file as soon as it is uploaded and shows the result (see Use Case 2.3). It judges each pincode against the new hub. The third step then opens and shows a table with the rows Hub, Vendor and Pincodes and the columns Now and After the move.

**Step 7:** User selects "Move driver".

**Step 8:** System checks the hub and the vendor (see Use Case 4.5), and checks each pincode again.

**Step 9:** All checks pass. System saves the new hub and vendor, and replaces the driver's pincodes with the pincodes in the file. The driver ID, name, mobile number, vehicle number, vehicle category and engagement do not change.

**Step 10:** System shows the profile with the new hub on the Hub card and shows "<driver name> moved to <hub>."

Result: users of the old hub no longer see the driver, and users of the new hub do.

On this page:

| Case | What System does |
|---|---|
| The user has not chosen a hub and a vendor | Keeps the second step locked, shows "Choose a hub and a vendor first." and does not show "Download hub pincodes" |
| The user has not uploaded a file that passes | Keeps the third step locked and shows "Upload the file to review the move." |
| The user selects "Download hub pincodes" | Gives the pincode file of the hub chosen on this page (Use Case 2.3) |
| The user selects "Download current pincodes" | Gives the pincode file of the driver's current pincodes. They belong to the current hub, so a pincode the new hub does not serve is set aside when the file is uploaded |
| A row is for a pincode the new hub does not serve | Sets the row aside with its reason (Use Case 2.3) |
| No pincode passes | Shows "No pincode can be saved." and does not offer "Move driver" (Use Case 2.3, Step 5) |
| The new hub has no vendor | Shows the message from Use Case 2.4, and the user cannot go on |

#### Use Case 4.5: Edge Case — an edit fails a check

**Step 1:** User selects "Save changes", "Save serviceability" or "Move driver" and a check fails (Use Case 4.2, Step 4, Use Case 4.3, Step 6, or Use Case 4.4, Step 8).

**Step 2:** System saves nothing, keeps the page open with what the user entered, and shows the messages from Use Case 2.2 or 2.3 under the fields, or from this table:

| Check that fails | Message |
|---|---|
| On "Edit hub", the hub chosen is the driver's current hub | "Choose a different hub." |
| The vendor chosen is not at the driver's hub. This happens when someone else changed the driver's hub, or removed the hub from the vendor, after the user opened the edit page. | "This vendor is not at the driver's hub. Choose another." |

**Step 3:** User corrects the page and selects the button again. When the driver's hub was changed by someone else, the user opens the driver again first.

#### Use Case 4.6: Edge Case — two users change the same driver

**Step 1:** Two users open the edit page of the same card and make a change.

**Step 2:** Each selects the save button of the page. System saves the changes in the order it receives them, and the change saved last is the one kept. The earlier change is overwritten. System shows no message, except as Use Case 4.5 says.

**Step 3:** A pincode file replaces the whole set of pincodes, so the file saved last is the one kept, and a pincode that only the earlier file had is removed.

#### Use Case 4.7: Edge Case — a user whose role cannot change the name or mobile number tries to

**Step 1:** A user whose role is below Regional Manager selects "Edit" on the "Driver details" card. System shows the driver's name and mobile number as they are and does not let the user change them.

**Step 2:** The user tries to change either of them another way, or the user's role was changed after "Edit" was selected and the user selects "Save changes" with a changed name or mobile number.

**Step 3:** System saves nothing, including the other fields on the page, and shows: "You don't have access to this page."

### Use Case 5: Module access

Who: any user.

#### Use Case 5.1: Happy Case — a user sees the tabs their role holds

**Step 1:** User signs in to the portal.

**Step 2:** System reads the modules the user's role holds.

**Step 3:** The menu shows "Vendor management" and "Driver management", in this order, each only if the role holds that module.

**Step 4:** User selects a tab. System opens it as Use Cases 1 to 4 say.

Note: the roles are fixed in the System (User Management PRD). At launch they hold these tabs, and these roles can change a driver's name and mobile number (Use Case 4.2):

| Roles | Tabs at launch | Can change a driver's name and mobile number |
|---|---|---|
| Executive | Driver management | No |
| Regional Manager, Central Logistics Ops, Control Tower, Admin | Vendor management, Driver management | Yes |
| Finance | None | Not applicable: no tab |

#### Use Case 5.2: Edge Case — the user opens a tab their role does not hold

**Step 1:** User opens the address of a tab whose module their role does not hold, for example from a saved link. The same happens when engineering takes the module off the role while the user is in the tab, and the user takes an action (the User Management PRD describes this change).

**Step 2:** System does not show the tab. It shows: "You don't have access to this page."

**Step 3:** Anything the user had not saved in the tab, such as a form being filled, is lost.

### Side effects

- A tab is a module. A role's modules decide which tab a user can open. They do not hide what another tab needs: a user whose role holds Driver management but not Vendor management still chooses from the vendors on the driver form.
- A vendor that works only at hubs a user cannot see is not shown to that user, and they cannot reuse its name. A user who has one of its hubs edits it.
- A driver's mobile number is unique across all drivers, and a driver who has left and returns cannot be created again. Two drivers can have the same vehicle number.
- A user whose role is below Regional Manager cannot correct a driver's name or mobile number. A Regional Manager or above does it.
- A hub that serves more than 100 pincodes needs more than one driver to serve all of them.
- Deleting a driver is not in this PRD, so no driver can be deleted.
- A driver has no status in this PRD. The status, its column and its filter are added with suspension and exit.
- Vehicle categories are kept in the System by engineering, not in the portal. Assumes the categories a driver can have exist before implementation.
- Every later feature that reads a driver's serviceability uses the driver's serviceable pincodes.
- Driver documents and device assignment are not in this PRD.
- Assumes the System knows which pincodes each hub serves, from network setup, before implementation. The hub pincode file is made from them.

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
| Check | Name or mobile number changed by a role that cannot | Count of changes to a driver's name or mobile number made by a user whose role is below Regional Manager |

## 5. Rollout & Stage Gates

| Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria |
|---|---|---|---|---|
| 1 | Prove vendor and driver setup at the first cutover location | A user whose role holds Vendor management creates the first cutover location's vendors in the portal. Executives then create its drivers in the portal, starting well before the location cuts over so they have time to be trained and onboarded to the portal. There is no bulk upload. | Median time to create a driver: target to be set from baseline. Creation completion: target to be set from baseline. | Drivers sharing a mobile number: threshold not yet set. Drivers with no serviceable pincode: threshold not yet set. Drivers tagged to a vendor that does not exist: threshold not yet set. Changes outside the user's hubs: threshold not yet set. Name or mobile number changed by a role that cannot: threshold not yet set. |
| 2 | Every cutover location | Each location's vendors are created by users whose role holds Vendor management and its drivers by Executives, in the portal, starting well before the location cuts over. | Same as Stage 1. | Same as Stage 1. |

## 6. Decisions

| # | Decision | Where in this PRD |
|---|---|---|
| 1 | Vehicle number has no validation except that letters are in capitals and there are no spaces. | Use Case 2.2 |
| 2 | Role creation and vehicle management have no screen in the portal. Both are hardcoded in the System. | Terms; User Management PRD |
| 3 | Bulk upload of driver creation is not supported. For the cutover from Shipsy, Executives create drivers through the portal only. This starts well before go-live, so they have time to be trained and onboarded to the portal. | Rollout |
| 4 | Driver serviceability is a full upload of pincodes each time, on creation and on edit. A driver can have at most 100 pincodes. Executives see the hub's pincodes and the driver's current pincodes through a CSV download. | Use Cases 2.1, 2.3, 4.3, 4.4 |
| 5 | Hub pincodes that are not mapped to a driver are flagged through email alerts that analytics enables. | Not in this PRD |
| 6 | Virtual DCs, the ones with no physical location, for example Vikhroli and Lucknow FC, are removed from the System. | Terms |
| 7 | Team Lead and Dispatcher are not roles of this portal. The portal has Regional Managers and Executives, along with Admin, Central Logistics Ops, Control Tower and Finance (User Management PRD). | Use Case 5.1 |
| 8 | Editing a driver's name and mobile number is restricted by role. Only Regional Manager and the roles above it can do it. | Use Cases 4.2, 4.7, 5.1 |
| 9 | The filters on Driver management are Hub, Name and Mobile number only. | Use Case 3.2 |
| 10 | KYC of drivers is not required. Vendors or HR take care of it, depending on where the driver is sourced from. | Not in this PRD |
| 11 | The driver profile is one page of cards, not tabs. Hub and Serviceability each have their own button and their own workflow page. | Use Cases 4.1, 4.3, 4.4 |
| 12 | The profile page does not list a driver's pincodes. They are a download. | Use Case 4.1 |
