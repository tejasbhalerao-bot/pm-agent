# [PRD] DMS Integration — Milestone 2: Geography Setup

**Version:** v3
**Date:** 2026-05-27
**Author:** Tejas Bhalerao
**Status:** In Review
**Supersedes:** [v2 — 2026-05-21](2026-05-21-dms-m2-geography-setup-v2.md)

**Changes from v2:**
- UC 1.2 (Zone Creation via KML Upload) removed entirely. All KML references removed from document.
- UC 2 edge case 9: Corrected. Post-delete, Truemeds stops routing orders for that pincode to Locus. Fulfilled via existing courier methodology. Zone Not Found state does not arise from mapping deletes.
- UC 3 hub edit: Zone removal from hub no longer blocked by active orders. Active plan completes. Future plans blocked from routing to removed zone.
- UC 3 edge case 8: Removed. Eligible destination hubs list may be empty at hub creation. DC → Mother Hub reverse logistics note moved to hub creation informational notes.
- UC 4 pre-activation checklist upgraded from Ops SOP to system-enforced validation at Truemeds serviceability layer.
- UC 4 edge case 1: Pincode activation blocked by Truemeds if pincode not mapped to zone in Locus.
- UC 4 edge case 3: Pincode activation blocked if zone exists, hub exists, but hub has no eligible destination hubs (DC-served pincode).
- UC 4 edge case 4: Bulk activation — all pincodes validated against pre-activation checks. Incomplete setups rejected individually.
- UC 5: Zone Not Found language updated throughout. Activation-time failures eliminated by upstream blocking. Unroutable order risk confined to mid-operation geography changes on already-active pincodes.

---

## RACI

| Function | R | A | C | I |
|---|---|---|---|---|
| Product | Tejas | Tejas | — | — |
| Engineering | Eng Lead | — | Tejas | Fahad |
| Ops | Ops Lead | — | Tejas | Kartik |
| Analytics | Analytics Lead | — | Tejas | — |
| Locus | Locus CSM | — | Eng Lead | — |

---

## Authorization Matrix

Geography changes affect live planning. Role restrictions apply to every action in this milestone.

| Action | Permitted Roles |
|---|---|
| Zone creation | Ops, HO Central Logistics |
| Pincode-to-zone mapping (Truemeds bulk upload) | Ops, HO Central Logistics |
| Hub creation / edit (API) | Tech (system-driven only) |
| Hub deletion (API) | Tech (system-driven only) |
| Serviceability update (Truemeds internal) | Ops |
| Viewing geography configuration | All roles |

---

## Objective

Establish the complete geography configuration on Locus — zones, pincode mappings, and hubs — such that the planning engine has accurate, complete, and current operational boundaries for all hyperlocal forward deliveries.

---

## Why Now?

No planning engine operation is possible without geography configuration. Zones, pincode mappings, and hub definitions are the prerequisite for every downstream milestone. This milestone must be complete and stable before M3 (Driver Module) and M6 (Planning Engine) can go live.

---

## Ordering Dependencies

The following sequence is mandatory. Actions performed out of order will fail validation or produce unusable configurations.

1. Zone creation (UC 1) — zones must exist before pincode mapping
2. Pincode-to-zone mapping (UC 2) — pincodes must be mapped before hubs reference zones meaningfully
3. Hub creation (UC 3) — hubs must reference existing zones; eligible destination hubs must already exist
4. Serviceability sync (UC 4) — Truemeds enforces system-level pre-activation validation and will block activation if prerequisites are not met; Ops must ensure zone + pincode + hub configuration is complete before attempting activation

---

## Use Cases

---

### Use Case 1: Zone Creation

---

#### Use Case 1.1: Zone Creation Logic

Locus operates on zones — a zone is a named collection of pincodes treated as a single operational unit for planning, driver assignment, and routing. Truemeds does not import zones from any existing system. All zones are created fresh as part of this migration.

**Zone design principles:**
- Zones must be grouped based on pincode-level demand patterns. Pincodes with similar demand volumes and proximity are grouped together.
- Each zone must be coverable by a single driver shift within the committed delivery window. The exact pincode threshold per zone is defined by Ops in consultation with Locus based on route optimisation analysis.
- Zone boundaries must not split geographically contiguous pincodes served from the same hub.
- One pincode belongs to exactly one zone at any point in time.

**Mandatory naming convention:** `<HubCode>_<ZoneID>_<ZoneName>` (example: `Vikhroli_Z01_Powai`)

This convention is enforced by Ops discipline, not by Locus. Locus does not validate zone names against this format. Ops must adhere to the convention manually at creation time. Naming violations will not be caught by the system and will result in operational confusion in later milestones (M6 planning, M7 driver app).

Zone creation is owned by Analytics and Ops, with Locus providing algorithmic support on route optimisation. Only Ops and HO Central Logistics roles may create zone configurations in Locus.

---

### Use Case 2: Pincode-to-Zone Mapping

**Happy path:**

When Ops creates a CSV with two columns — Zone Name and Pincode — and uploads it via the **Truemeds internal bulk upload tool**, Truemeds processes each row and calls the Locus zone-pincode mapping API per row. Each row is processed according to its specified action (insert, update, or delete). Rows passing all validations are committed. Rows failing validation are rejected individually with specific error messages. The upload is not all-or-nothing: valid rows commit regardless of other rows' failures. Ops receives a post-upload summary showing count of successes, failures, and the rejection reason per failed row.

**Defining "update":** An update action is equivalent to a delete of the existing mapping followed by an insert of the new mapping. It is provided as a convenience to avoid requiring two separate rows. Internally, it is processed as delete + insert in that order, atomically for that row.

**Operational SOP:** All pincode-zone mapping changes must be performed during non-business hours only. Business hours are defined as 8:00 AM–10:00 PM IST. Changes during active planning windows carry a risk of affecting in-flight orders. Ops owns the scheduling discipline.

**Edge cases — validation:**

1. Pincode already mapped to another zone and action is insert → row rejected: "Pincode `<Pincode>` already mapped to Zone `<Zone Name>`. Use delete action to remove existing mapping before inserting."

2. Zone Name or Pincode column is missing or empty → row rejected: "Please enter a valid value for `<column name>`."

3. Pincode does not match 6-digit integer format → row rejected: "Invalid pincode format: `<Pincode>`. Pincode must be a 6-digit integer."

4. Zone Name does not match any existing active zone in the Truemeds Locus account → row rejected: "Zone not found: `<Zone Name>`. Verify the zone name and retry."

5. Delete action for a pincode-zone combination that does not exist → row rejected: "Mapping not found: Pincode `<Pincode>` is not currently mapped to Zone `<Zone Name>`."

6. CSV contains duplicate pincodes across multiple rows in the same file → the first valid row for that pincode is processed. Subsequent rows for the same pincode in the same upload are rejected: "Duplicate pincode in upload: `<Pincode>`. Only the first occurrence was processed."

7. CSV has incorrect column headers or wrong file format (not a valid CSV) → the entire upload is rejected before any rows are processed: "File format invalid. Expected a CSV with columns: Zone Name, Pincode."

8. Pincode exists in the CSV but is not present in Truemeds' serviceability list → the row is accepted and the mapping is created. Serviceability is managed separately (UC 4). Zone mapping does not validate pincode-level serviceability at mapping time.

**Edge cases — state intersection:**

9. Delete action submitted for a pincode that currently has active orders in the planning queue → the system does not block the delete. The delete proceeds. Any orders already in an active plan for that pincode are unaffected (in-flight continues). After the delete, Truemeds stops routing new orders for that pincode to Locus. Those orders are fulfilled via Truemeds' existing courier methodology.

   **Ops SOP:** To prevent this scenario from affecting live operations, all pincode delete actions must be performed in non-business hours when no active planning cycles are running.

10. Pincode reassignment (delete Zone A + insert Zone B) while a new order for that pincode is submitted simultaneously → the delete and insert are processed sequentially. If an order is ingested between the delete completion and the insert completion, Truemeds routes that order via existing courier methodology. The order is not cancelled in Truemeds.

    **Ops SOP:** To prevent this window of exposure, all pincode reassignments must be performed in non-business hours. Reassignment should always be submitted as a single update action (not separate delete + insert rows) to minimise the exposure window.

11. Pincode reassignment: delete and insert rows are in the wrong order in the CSV (insert before delete) → Truemeds' upload tool processes the insert first. If the pincode is already mapped, the insert is rejected. The delete then runs and succeeds, leaving the pincode unmapped. Ops must resubmit with the correct row order (delete first, then insert). **Recommendation:** always submit reassignment as a single update action to avoid ordering risk.

**Rollback:**

There is no automated rollback for CSV uploads. If an incorrect CSV is uploaded, Ops must construct and upload a reverse CSV (with opposing actions) to correct the state. For large-scale errors, Tech can restore Redshift to a prior snapshot as a recovery path if a rollback CSV is impractical.

**Audit trail:**

Every pincode-zone mapping change (insert, update, delete) is logged in Redshift with: action type, pincode, from-zone, to-zone, performing user ID, and timestamp. This log is accessible via Metabase for ops accountability and planning failure investigations.

---

### Use Case 3: Hub Creation

**Happy path — single hub via API:**

When Truemeds' internal system calls the Locus hub creation API with Hub Name, Hub Lat/Long, list of Zones, and list of Eligible Destination Hubs, Locus validates all inputs and creates the hub. The hub is immediately available for zone tagging and planning. All hub lifecycle actions (create, edit, delete) are system-driven via API only. Dashboard-based hub creation is not permitted for Truemeds.

**Note — reverse logistics dependency:** For DC hubs, the Mother Hub should be configured as an eligible destination hub to support reverse logistics. Return orders originating at a DC require a valid path back to the Mother Hub for processing. Ops must verify this configuration for DC hubs before the hub is used in production.

**Bulk hub creation:**

For initial migration (creating multiple hubs at once), Truemeds provides a bulk hub upload tool analogous to the pincode-to-zone CSV upload in UC 2. Ops prepares a CSV with the following columns: Hub Name, Lat, Long, Zones (pipe-separated list), Eligible Destination Hubs (pipe-separated list). The Truemeds internal tool processes each row and calls the Locus hub creation API per row. Rows passing all validations are committed. Rows failing validation are rejected individually with specific error messages. Ops receives a post-upload summary with successes, failures, and rejection reasons per failed row.

The same validation rules that apply to single hub creation apply to each row in the bulk upload. The upload is not all-or-nothing: valid rows commit regardless of other rows' failures. Ordering dependency applies: a hub listed as an eligible destination must already exist before the row referencing it is processed; rows must be ordered accordingly.

**Hub edit:**

Locus supports editing all hub fields post-creation via API. The following constraints apply during edit:
- Removing a zone from a hub is not blocked by active orders. The current active plan for that zone continues to completion. Future planning cycles are blocked from routing orders to that zone once it is removed from the hub.
- Changing hub Lat/Long is permitted. The new coordinates are validated against the same rules as creation. No dispatcher notification is required — Ops manages the operational communication.
- Removing a destination hub from the eligible list: the change is not blocked. Existing mid-mile trips in flight to the removed destination hub are not affected — they continue to completion. New orders submitted after the removal are not routed to that destination hub. If any new order cannot be routed because no eligible destination hub exists for its pincode, Truemeds' order management system detects the unroutable state and retries with an alternative courier.

**Hub deletion:**

Hub deletion is supported via API. Deletion is not blocked by active orders, active drivers, or in-flight mid-mile trips. The following in-flight continuation rules apply:

- Active orders referencing the hub as origin or destination at time of deletion: in-flight operations continue to completion against the pre-deletion hub configuration. The hub record is retained as a soft-delete (inactive) until all referencing orders reach a terminal state.
- Active drivers rostered to the hub: drivers remain on their current trips. After trip completion, driver-hub association is cleared.
- Active mid-mile trips referencing the hub: in-flight mid-mile trips continue to completion. No rerouting occurs.
- New planning cycles: once the hub is deleted (marked inactive), no new trips, routes, or plans are created that reference it. Orders whose origin or destination maps to the deleted hub enter an unroutable state. Truemeds' order management system detects this and retries with an alternative courier.

On deletion, all zone-hub assignments for that hub are cleared. Affected zones become orphaned and surface on the ops configuration dashboard (M8 alert A2.8).

**Edge cases — validation:**

1. Hub name already exists in the Truemeds Locus account → rejected: "Hub already exists: `<Hub Name>`."

2. Zone in the zones list is already tagged to another hub → rejected: "Zone `<Zone Name>` already tagged to Hub `<Hub Name>`."

3. Hub Lat/Long outside valid decimal degree range (latitude: −90 to 90, longitude: −180 to 180) → rejected: "Invalid coordinates. Provide valid decimal degree coordinates."

4. Hub Lat/Long within global range but outside India (approx. lat 6–37, long 68–97) → soft warning surfaced without blocking creation: "Coordinates appear outside India. Confirm before proceeding." Ops confirms to proceed.

5. Two hubs share identical Lat/Long → rejected: "A hub already exists at these coordinates: `<Existing Hub Name>`. Verify coordinates before proceeding."

6. A hub listed under Eligible Destination Hubs does not exist in the Truemeds Locus account → rejected: "Destination hub not found: `<Hub Name>`. Verify hub name and retry."

7. Zones list is empty → rejected: "At least one zone must be assigned to a hub." A hub with no zones is operationally useless and must not be created.

**Edge cases — system failures:**

8. Locus API returns 5xx on hub creation → Truemeds' calling system retries the creation call up to 3 times with exponential backoff. If all retries fail, the hub creation is flagged as failed in Truemeds and Tech is alerted. The hub is not considered created until Locus returns a success response.

9. Race condition — two concurrent API calls attempt to create hubs with the same name → Locus must enforce uniqueness at the database level. The second call is rejected with the duplicate name error regardless of timing. Truemeds' system must handle this rejection as a terminal error and surface it for ops review.

10. Network connection drops mid-API call → Truemeds retries the call as per the retry logic in edge case 8. If the hub was partially created on Locus's side before the connection dropped, Locus must surface the hub in a "Creation Pending" state. Tech investigates and resolves the partial state before the hub is used.

**Audit trail:**

Every hub creation, edit, and deletion is logged in Redshift with: action type, hub name, changed fields, performing system/user, and timestamp.

---

### Use Case 4: Serviceability and Zone Readiness

**Sync model:**

There is no webhook-based serviceability sync between Truemeds and Locus. Serviceability is managed entirely within Truemeds' internal systems. When a pincode is active in Truemeds, Truemeds automatically routes orders for that pincode to Locus. When a pincode is deactivated, Truemeds stops sending orders for that pincode to Locus. Locus has no awareness of Truemeds' serviceability state — it only processes orders it receives.

**Consequence:** Truemeds' system-level pre-activation validation ensures orders are never routed to Locus for pincodes with incomplete zone or hub configuration. Activation is blocked at the Truemeds serviceability layer before orders can flow.

**System-enforced pre-activation validation:**

Before activating a pincode in Truemeds, the system automatically validates:
1. Pincode is mapped to a zone in Locus (UC 2)
2. The zone is assigned to an active hub (UC 3)
3. The hub has eligible destination hubs configured (if DC-served pincode)

If any of these checks fail, the activation is blocked and an error is surfaced to Ops. Ops must resolve the configuration gap before the activation can proceed.

**Happy path:**

When Ops activates a new pincode in Truemeds (after passing all pre-activation validations above), Truemeds begins routing orders for that pincode to Locus from the next ingestion cycle. No Locus-side action is required. Orders flow to planning normally.

When Ops deactivates a pincode in Truemeds, Truemeds stops routing orders for that pincode. No new orders are sent to Locus for that pincode. In-flight orders already in Locus planning are unaffected.

**Edge cases:**

1. Pincode activation attempted in Truemeds but pincode not mapped to any zone in Locus → activation blocked: "Pincode `<Pincode>` cannot be activated. Map pincode to a zone in Locus before activation (UC 2)." No orders flow to Locus until mapping is complete.

2. Pincode deactivated in Truemeds while active orders for that pincode exist in the current planning cycle → deactivation applies to new ingestions only. Orders already in the planning queue for that pincode are not affected and must be fulfilled or cancelled through the normal ops process. No in-flight orders are automatically cancelled by a serviceability deactivation event.

3. Pincode activation attempted but zone exists, hub exists, and hub has no eligible destination hubs configured (DC-served pincode) → activation blocked: "Pincode `<Pincode>` cannot be activated. Hub `<Hub Name>` has no eligible destination hubs configured. Complete hub configuration before activation (UC 3)."

4. Bulk activation (many pincodes activated simultaneously in Truemeds) → each pincode is validated against the same pre-activation checks above. Pincodes with incomplete zone or hub configuration are rejected individually. Ops receives a summary of blocked activations with reason per pincode. Only pincodes passing all checks are activated.

5. Pincode deactivated in Truemeds while a serviceability sync mismatch exists (Redshift shows active, Locus-internal state is stale) → Truemeds stops sending orders regardless of Locus-internal state. The Redshift-Locus mismatch is flagged by M8 alert A1.3. Tech reconciles independently.

**Audit trail:**

Every serviceability change (pincode activation or deactivation) in Truemeds is logged in Redshift with: pincode, new status, changed by user ID, and timestamp. This log is the source of truth for reconciliation when planning failures are traced to missing zone configuration.

---

### Use Case 5: Geography Change Impact on In-Flight Operations

This cross-cutting use case defines behaviour when geography configuration is modified while orders or trips are active. It applies across UC 1–4.

**Governing principle:** Geography changes are never blocked by in-flight operations. In-flight trips and orders always continue to completion against the configuration that was valid when they were created. Geography changes take effect for new planning cycles only.

**What happens to new orders when their pincode's geography changes mid-operation:** Pre-activation validation (UC 4) ensures orders are never sent to Locus for pincodes with incomplete configuration at activation time. However, if geography is changed after a pincode is already active (zone deleted, pincode removed from zone, hub deleted), orders for that pincode may enter an unroutable state in Locus. Truemeds' order management system detects this state and attempts fulfilment via an alternative delivery partner. The order is not cancelled in Truemeds — it is rerouted internally.

**Specific scenarios:**

1. Zone polygon boundary updated while a driver is mid-trip assigned to that zone → the in-flight trip continues against the old zone boundaries. The new boundaries take effect from the next planning cycle. No re-routing of the active trip occurs.

2. Zone deleted while a driver has an active trip assigned to it → zone deletion proceeds. The in-flight trip continues to completion unaffected. New planning cycles after the deletion will not route orders to that zone. Orders submitted after the zone deletion whose pincode was previously in that zone enter an unroutable state — Truemeds retries with an alternative delivery partner. The zone is retained as a soft-delete (inactive) until all referencing active trips reach a terminal state.

3. Pincode removed from a zone (delete action in UC 2) while an order for that pincode is in an active plan → the delete proceeds. The active plan is unaffected — the order in the plan continues to completion. New orders for that pincode submitted after the delete are routed by Truemeds via existing courier methodology.

4. Hub decommissioned (deleted) while a mid-mile trip is in flight to or from it → hub deletion proceeds per UC 3 hub deletion rules. The in-flight mid-mile trip continues to completion. New orders that would have routed through this hub enter an unroutable state — Truemeds retries with an alternative delivery partner.

5. Serviceability deactivation for a pincode while a driver is mid-delivery to that pincode → the in-flight delivery is unaffected. The deactivation applies to new ingestions only. See UC 4 edge case 2.

6. Zone polygon update creates a new overlap with an adjacent zone → Locus rejects the upload. The existing zone boundaries remain unchanged. No in-flight operations are affected.

7. Order submitted for an already-active pincode after a mid-operation geography change makes its routing configuration invalid (zone mapping removed, hub deleted, etc.) → the order enters an unroutable state in Locus at plan creation time. Locus cannot assign the order to any plan. Truemeds' order management system detects the unroutable state and retries with an alternative delivery partner. This is the primary recovery path for geography configuration gaps that affect live order flow on already-active pincodes. Note: this scenario does not arise from activation-time configuration failures — those are blocked upstream by UC 4 pre-activation validation.

---

## Metrics

| Metric | Definition | Baseline | Target | Timeframe |
|---|---|---|---|---|
| Pincode Mapping Coverage | % of serviceable pincodes mapped to a zone in Locus | 0% at M2 start | 100% | Before Stage 1 |
| Orphaned Zone Count | # of zones with no hub assignment | 0 (target) | 0 | Ongoing |
| Unroutable Order Rate (Geography-Caused) | % of ingested orders entering unroutable state due to mid-operation geography changes on already-active pincodes | Unknown — baseline at Stage 1 | 0 after Stage 2 | Stage 2 onwards |
| Geography Config Errors Post-Upload | # of planning failures attributable to geography misconfiguration | Unknown — baseline at Stage 1 | 0 after Stage 2 | Stage 2 |
| Alternative Courier Retry Rate (Geography-Caused) | # of orders rerouted to alternative courier due to Locus geography failures | Unknown | Baseline in first 2 weeks; reduce to 0 | Ongoing |
| Blocked Activation Attempts | # of pincode activations blocked by pre-activation validation | Unknown — baseline at Stage 1 | 0 (target: config always complete before activation attempt) | Ongoing |

---

## Rollout & Stage Gates

| Stage | Entry Criteria | Success Criteria | Action on Failure |
|---|---|---|---|
| Stage 1 — Config Complete | M2 UC 1–3 executed for at least 1 hub, 1 zone, non-DC pincodes | 100% of non-DC pincodes for Stage 1 hub mapped to zones. Hub creation confirmed via API. Pre-activation validation passing for at least 5 test pincodes | Fix geography gaps before handing to M6 planning engine |
| Stage 2 — Minimal Rollout | Stage 1 passed. 1 zone, 1 hub, low order volume | Zero unroutable orders in ingestion logs. Pincode Mapping Coverage = 100% for Stage 2 scope | Do not expand zones until coverage is verified |
| Stage 3a — Phased Non-DC Expansion | Stage 2 passed. Ops training complete per zone | All non-DC zones and hubs live. Zero geography-caused courier retries | Pause expansion. Investigate geography config before proceeding |
| Stage 3b — DC Expansion | Stage 3a stable | All DC hubs and zones created. Mid-mile destination hub configuration verified including reverse logistics (DC → Mother Hub) | Pause DC expansion. Fix hub configuration before proceeding |
| Stage 4 — Full | All pincodes and hubs live | Pincode Mapping Coverage = 100% across all hubs. Zero orphaned zones | — |
