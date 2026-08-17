# DMS M4: Payout Manager

**Version:** v3
**Milestone:** 4 — Payout Manager
**Date:** 2026-05-30
**Status:** Draft

---

## Changelog — v2 → v3

| # | Change |
|---|---|
| 1 | Defined "present" for Attendance Based — driver must complete at least one delivery on that calendar day |
| 2 | Defined order counting unit for Order Based — cumulative across entire Start→End window |
| 3 | Defined "delivered" order — fully delivered to destination only; partial deliveries and failed attempts excluded |
| 4 | UC6.1: Added cross-UC linkage — config save must detect and auto-terminate active Ad-hoc incentives |
| 5 | UC6.1: Clarified mid-shift config change applies from next shift start, not current in-flight shift |
| 6 | UC6.1: Added concurrency model — last-write-wins; second write overwrites first with no error |
| 7 | UC6.2: Specced Locus→Truemeds earnings handoff — webhook mechanism, payload fields, retry policy, failure handling |
| 8 | UC6.2: Added fallback for missing odometer reading at shift end |
| 9 | UC5.1: Clarified incentive state on creation — Active immediately; no Scheduled/Pending state |
| 10 | UC5.1: Attendance window = calendar days in Start→End range (inclusive) |
| 11 | UC5.1: Route Specific pincode match = delivery address pincode, not assigned route |
| 12 | UC5.1: Decommissioned pincode mid-incentive — incentive continues to honour it until End Date |
| 13 | UC5.1: Ad-hoc Rs./day and Rs./order are additive on top of base salary |
| 14 | UC5.3: Incentive auto-expires at End Date; deactivation of an already-expired incentive is not permitted |
| 15 | UC5.3: No driver-facing notification on deactivation — backend event only |
| 16 | Added Pass 5: Authorization Matrix |
| 17 | Added Pass 5: Audit Trail |
| 18 | Added Pass 5: Metrics |
| 19 | Added Pass 5: Rollout Plan |
| 20 | Added Pass 5: PII and Concurrency notes |
| 21 | Ad-hoc payout stacking formula clarified — Rs./day is per active day, Rs./order is cumulative across window; both computed at window close |
| 22 | Ad-hoc mid-window termination: accrual cadence clarified — running day/order count tracked by Locus; partial payout formula defined |

---

## 1. Overview

Milestone 4 delivers Payout Manager within the DMS-Locus integration. It covers two domains:

1. **Driver Earnings** — salary structure configuration per Vendor × Hub
2. **Incentives** — creation and management of performance-based payout programs

---

## 2. Use Case 5: Incentives

### 5.1 Create Incentive

On the Incentives section of Locus's platform, the user can view all existing incentives (active and inactive) alongside the creation interface.

On clicking **"Create"**, an incentive creation form is rendered.

On **submission**, the incentive is created with status **Active immediately** — there is no Scheduled or Pending state. If Start Date is in the future, the incentive is Active but not yet accruing.

---

#### Incentive Types

| Incentive Type | What It Incentivises |
|---|---|
| Attendance Based | Driver presence across a minimum number of working days within the incentive window (tiered) |
| Order Based | Delivery of a minimum cumulative number of orders across the incentive window (tiered) |
| Route Specific | Availability on deliveries within a defined pincode set |
| Ad-hoc / Festival Based | Availability and delivery performance during high-demand or non-working periods — salary-based drivers only |

> **Multi-incentive eligibility:** There is no upper limit on the number of active incentives a driver can simultaneously qualify for. A driver may accrue payouts from multiple incentive programs running in parallel, including multiple incentives of the same type on the same Vendor × Hub. Payouts from all qualifying incentives are additive.

---

#### Common Fields — All Incentive Types

| Configuration | Required | Rule |
|---|---|---|
| Start Date | Mandatory | Must not be in the past. Date picker input. |
| End Date | Mandatory | Must be on or after Start Date. |
| Incentive Type | Mandatory | Single-select dropdown from four types. Renders type-specific fields. |
| Hub | Optional | Multi-select from configured hubs. If blank, applies across all hubs. |
| Vendor | Optional | Single-select from configured vendors. If blank, applies across all vendors. |

---

#### Type-Specific Fields

##### Attendance Based — Tiered

At least one tier is required. Multiple tiers can be configured.

| Field | Required | Rule |
|---|---|---|
| Tier Number | Mandatory | Sequential integer starting at 1 (Tier 1, Tier 2, Tier 3…). |
| # of Days | Mandatory | Integer. Minimum days present within the incentive window to qualify for this tier. Must be strictly greater than the previous tier's # of Days. |
| Rs. (Payout) | Mandatory | Numeric (Rs.). Total payout when driver qualifies for this tier. Must be > 0. |

**Definition of "present":** A driver is counted as present on a calendar day if they complete at least one fully delivered order on that day. Login without delivery does not count as present.

**Window definition:** # of Days is counted across all calendar days in the Start Date → End Date range (inclusive). Non-working days are included in the window — a driver who delivers on a Sunday is counted as present for that day.

**Tier resolution:** Driver earns the payout for the highest tier they qualify for at the close of the incentive window. Tiers are not additive.

*Example:* Tier 1 = 15 days → Rs. 100 | Tier 2 = 20 days → Rs. 200 | Tier 3 = 30 days → Rs. 300. A driver present for 22 days earns Rs. 200.

---

##### Order Based — Tiered

At least one tier is required. Multiple tiers can be configured.

| Field | Required | Rule |
|---|---|---|
| Tier Number | Mandatory | Sequential integer starting at 1. |
| # of Orders | Mandatory | Integer. Minimum orders delivered within the incentive window to qualify. Must be strictly greater than the previous tier's # of Orders. |
| Rs. (Payout) | Mandatory | Numeric (Rs.). Total payout when driver qualifies for this tier. Must be > 0. |

**Definition of "delivered" order:** An order counts only if it reaches a fully delivered terminal state in Locus. Partial deliveries, failed delivery attempts, and returns do not count.

**Counting unit:** Orders are counted cumulatively across the entire Start Date → End Date window — not per shift or per day. A driver who delivers 8 orders/day across 4 days has 32 orders against the window threshold.

**Tier resolution:** Driver earns the payout for the highest tier they qualify for at the close of the incentive window. Tiers are not additive.

*Example:* Tier 1 = 15 orders → Rs. 100 | Tier 2 = 20 orders → Rs. 200 | Tier 3 = 30 orders → Rs. 300. A driver delivering 25 orders across the window earns Rs. 200.

---

##### Route Specific

| Field | Required | Rule |
|---|---|---|
| Pincode List | Mandatory | Multi-value input. At least one pincode required. |
| Rs. per Day | Mandatory | Numeric (Rs.). Daily payout for each qualifying day. Must be > 0. |

**Pincode match rule:** A delivery qualifies if the destination address pincode matches any pincode in the incentive's pincode list. Assignment to a specific route is irrelevant — the address pincode at delivery is the match criterion.

**Qualifying day:** A driver earns Rs./day for any calendar day on which they complete at least one qualifying delivery (address pincode in the list).

**Decommissioned pincodes:** If a pincode in the list is decommissioned or remapped after the incentive is created, the incentive continues to honour deliveries to that pincode for the remainder of the incentive window. No auto-update.

---

##### Ad-hoc / Festival Based

Applicable to **salary-based drivers only**. Locus restricts this incentive type to drivers whose active earning configuration is Salary Based for the applicable Vendor × Hub.

| Field | Required | Rule |
|---|---|---|
| Rs. per Order | Mandatory | Numeric (Rs.). Payout per fully delivered order during the incentive window. Must be > 0. |
| Rs. per Day | Mandatory | Numeric (Rs.). Payout per active day during the window. Must be > 0. |

Start Date and End Date from common fields define the festival/ad-hoc window.

**Payout stacking:** Both components are additive on top of the driver's base salary earnings (Structure B: Rs./day + Rs./km). Payout is calculated at window close as follows:

```
Ad-hoc Incentive Payout = (Rs./day × Active Days in window) + (Rs./order × Total Orders Delivered in window)
Total Payout = Base Salary Earnings (summed across window) + Ad-hoc Incentive Payout
```

Rs./day is applied once per calendar day the driver is active (at least one delivery). Rs./order is applied to cumulative fully delivered orders across the entire window — not evaluated on a per-day basis.

**Mid-window salary structure switch:** If a driver's earning configuration is changed from Salary Based to Per Order during an active Ad-hoc / Festival Based incentive window, the incentive accrues earnings up to and including the day before the configuration change takes effect. All remaining days in the window are dropped. No retroactive clawback of amounts already accrued.

---

#### Validations

| Rule | Error Message |
|---|---|
| All mandatory fields must be filled on submission | "Please enter a valid value." (inline, against specific field) |
| Start Date cannot be in the past | "Start Date must be today or a future date." |
| End Date cannot be before Start Date | "End Date must be on or after Start Date." |
| All Rs. and numeric fields must be ≥ 0 | "Field accepts only positive numeric values." |
| Tier thresholds (# of Days / # of Orders) must be strictly increasing across tiers | "Tier threshold must be greater than the previous tier." |
| Ad-hoc / Festival Based incentive can only target Vendor × Hub combinations where the active earning config is Salary Based | "This incentive type applies only to salary-based earning configurations." |

---

### 5.2 View Incentive List

On the same page as incentive creation, all incentives (active and inactive) are visible.

- Filterable by: **Incentive Type, Hub, Vendor, Status**
- Default view: **Active** incentives sorted by **Start Date descending**

---

### 5.3 Deactivate Incentive

A user can manually deactivate an Active incentive before its End Date.

**Auto-expiry:** When End Date passes, the incentive status automatically moves to Inactive. Manual deactivation of an already-expired incentive is not permitted.

On clicking **"Deactivate"** against an Active incentive record:

- Locus presents a confirmation prompt: *"Are you sure you want to deactivate this incentive? This will stop payouts for all drivers currently accruing against it."*
- On confirmation, incentive status is set to **Inactive** immediately.
- **All earnings accrued against this incentive that have not yet been paid out are dropped.** No partial payout is made for the current incentive window.
- Deactivation is a **backend event only** — no driver-facing notification is generated.
- Deactivation is **not reversible**. A new incentive must be created to reinstate the payout structure.

---

> **Callout:** Incentive creation, deactivation, and list fetch must be exposed via API in addition to the UI.

---

## 3. Use Case 6: Driver Earnings

### 6.1 Create Earnings Configuration

Driver earnings are configured on one of two salary structures. Each configuration is scoped to a **Vendor × Hub** pair.

---

#### Structure A — Per Order

| Parameter | Required | Rule |
|---|---|---|
| Vendor | Mandatory | Single-select from configured vendors. Part of the primary key. |
| Hub | Mandatory | Single-select from configured hubs. Part of the primary key. |
| MG — Minimum Guarantee (Rs.) | Mandatory | Numeric (Rs.). Minimum daily earnings guaranteed to the driver regardless of order count. Must be > 0. |
| Rs. per Order | Mandatory | Numeric (Rs.). Variable payout per fully delivered order in the shift. Must be ≥ 0. |

---

#### Structure B — Salary Based

| Parameter | Required | Rule |
|---|---|---|
| Vendor | Mandatory | Single-select from configured vendors. Part of the primary key. |
| Hub | Mandatory | Single-select from configured hubs. Part of the primary key. |
| Rs. per Day | Mandatory | Numeric (Rs.). Fixed daily payout regardless of distance or orders. Must be > 0. |
| Rs. per Km | Mandatory | Numeric (Rs.). Variable payout per km driven in the shift. Must be ≥ 0. |

---

#### Versioning Behaviour

- On creation of a new earning configuration for a **Vendor × Hub** pair, the previous configuration is automatically marked **Inactive**.
- The new configuration is **Active** from `creation_timestamp`.
- **Mid-shift changes:** If a config change occurs while a driver is in an active shift, the new config takes effect from the **next shift start**. The current in-flight shift is calculated against the previous config.
- **Concurrency:** If two admins create a new config for the same Vendor × Hub simultaneously, the last write wins. No error is raised on the second write; the second config becomes Active and the first is immediately deprecated.
- Historical inactive configurations are **retained in Redshift** and not deleted — required for financial reconciliation and audit.
- Effective date of any configuration is its `creation_timestamp`. Earnings for shifts completed before this timestamp are calculated against the previous configuration.

#### Ad-hoc Incentive Linkage

When a new Per Order configuration is saved for a Vendor × Hub pair, Locus must check for any active Ad-hoc / Festival Based incentives targeting that Vendor × Hub. For each such incentive found:

- The incentive accrual is stopped as of the day before the config change `creation_timestamp`.
- Locus computes a partial payout at the point of termination: `(Rs./day × Active Days accrued so far) + (Rs./order × Orders Delivered so far)`. This amount is retained and included in the driver's payout.
- The remaining incentive window is dropped. No further accrual occurs.

**Accrual cadence:** Ad-hoc / Festival Based incentives do not accrue daily — payout is computed as a lump sum at window close (or at early termination as above). Locus must track active day count and order count on a running basis to enable mid-window termination calculation.

This check runs at config-save time, not at end-of-shift.

---

### 6.2 Calculation of Driver Earnings

At the end of each completed shift, Locus calculates the driver's total earnings and passes the computed record to Truemeds via webhook.

**Definition of "shift":** A shift is the time window bounded by the driver's odometer start reading and odometer end reading as captured in Locus. All order counts, distance, and time calculations in this milestone reference this window.

---

#### Per Order Driver

```
Shift Earnings = max(MG, Rs./order × Fully Delivered Orders in shift)
```

MG is applied **per shift**, not per day. If a driver completes two shifts in a single day, MG applies independently to each shift.

If per-order earnings exceed MG, the driver earns the higher per-order amount. If below, MG applies as the floor.

---

#### Salary Based Driver

```
Shift Earnings = Rs./day + (Rs./km × Actual Distance Travelled in shift)
```

---

#### Trigger

Odometer readings are captured at the start and end of each shift (detailed in Milestone 6). Earnings calculation fires once the final odometer reading at shift end is recorded.

**Missing odometer reading:** If the end-of-shift odometer reading is not recorded within 2 hours of the expected shift end time, Locus raises an alert to the Hub Manager. Earnings calculation for that shift is held pending. The Hub Manager must manually confirm or enter the closing odometer reading to unblock calculation. No earnings are calculated or passed to Truemeds until this is resolved.

---

#### Locus → Truemeds Earnings Handoff

On successful earnings calculation, Locus fires a webhook to the Truemeds earnings endpoint.

**Payload fields:**

| Field | Type | Description |
|---|---|---|
| `driver_id` | String | Locus driver identifier |
| `vendor_id` | String | Vendor for this shift |
| `hub_id` | String | Hub for this shift |
| `shift_start` | ISO 8601 timestamp | Shift start time |
| `shift_end` | ISO 8601 timestamp | Shift end time |
| `earning_structure` | Enum: `per_order` / `salary_based` | Active structure for this shift |
| `base_earnings_rs` | Numeric | Calculated base earnings (before incentives) |
| `incentive_earnings_rs` | Numeric | Total incentive payouts accrued for this shift |
| `total_earnings_rs` | Numeric | `base_earnings_rs` + `incentive_earnings_rs` |
| `orders_delivered` | Integer | Fully delivered orders in this shift |
| `distance_km` | Numeric | Odometer distance for this shift |

**Retry policy:** If the Truemeds endpoint does not return a 2xx response, Locus retries 3 times with exponential backoff (30s, 2m, 10m). After 3 failures, the record is flagged as **Delivery Failed** and an alert is sent to the Truemeds integration ops channel. No further automatic retries. Manual re-trigger available via Locus ops dashboard.

**No approval gate:** Truemeds consumes the webhook payload directly for reconciliation. There is no human approval step between calculation and record acceptance.

---

## 4. Pass 5 — Cross-Cutting Concerns

### 4.1 Authorization Matrix

| Action | Permitted Roles |
|---|---|
| Create incentive | Hub Manager, Operations Admin |
| Deactivate incentive | Hub Manager, Operations Admin |
| View incentive list | Hub Manager, Operations Admin, Finance |
| Create earning configuration | Operations Admin only |
| View earning configurations | Hub Manager, Operations Admin, Finance |

**Unauthorised access:** If a user without the required role attempts any of the above actions via UI, Locus blocks the action and displays: *"You do not have permission to perform this action."* If attempted via API, Locus returns HTTP 403.

---

### 4.2 Audit Trail

The following events must be logged by Locus with the fields specified:

| Event | Fields Logged |
|---|---|
| Incentive Created | `incentive_id`, `type`, `created_by` (user ID), `created_at`, full config snapshot |
| Incentive Deactivated | `incentive_id`, `deactivated_by`, `deactivated_at`, `accrued_earnings_dropped_rs` |
| Incentive Auto-Expired | `incentive_id`, `expired_at` |
| Ad-hoc Incentive Auto-Terminated (mid-window) | `incentive_id`, `terminated_at`, `reason: earning_config_change`, `accrued_earnings_retained_rs` |
| Earning Config Created | `config_id`, `vendor_id`, `hub_id`, `structure_type`, `created_by`, `created_at`, full config snapshot |
| Previous Config Deprecated | `config_id`, `deprecated_at`, `replaced_by_config_id` |

**Retention:** Audit logs retained for 3 years in Redshift. Not deletable via UI.

---

### 4.3 Metrics

| Metric | Definition | Alert Threshold |
|---|---|---|
| Earnings calculation failure rate | % of shifts where earnings calculation did not fire within 2h of shift end | > 2% in any 24h window → alert to ops |
| Webhook delivery failure rate | % of earnings webhook calls that exhausted retries without 2xx | > 0 in any 24h window → alert to integration ops |
| Missing odometer reading rate | % of shifts with no end odometer reading within 2h of expected shift end | > 5% in any 24h window → alert to Hub Manager |
| Incentive participation rate | % of active drivers accruing against at least one incentive | Baseline to be established in first 4 weeks of production |
| Average incentive payout per driver per week | Rs. | Baseline to be established in first 4 weeks of production |

---

### 4.4 Rollout Plan

| Phase | Description |
|---|---|
| Pre-launch | Ops Admin creates earning configurations for all active Vendor × Hub pairs in Locus before go-live. No driver shifts processed until at least one config exists per pair. |
| Go-live | Locus earnings calculation activates for new shifts. Existing payout process runs in parallel for any shifts that started before go-live. |
| Parallel run | First 2 weeks: Locus-computed earnings are cross-checked against existing payout records by Finance. Discrepancies escalated to ops before Truemeds consumes Locus records. |
| Cutover | After parallel run sign-off by Finance, Truemeds decommissions legacy payout calculation. Locus webhook becomes the sole source of shift earnings records. |
| Decommission trigger | Finance sign-off on parallel run results with < 1% discrepancy rate across 2 consecutive weeks. |

---

### 4.5 PII and Data Retention

Driver earnings records contain financial PII (driver identity + daily income). Records are retained in Redshift for 7 years per financial compliance requirements. Access restricted to Finance and Operations Admin roles. No PII is written to application logs.

---

### 4.6 Concurrency

Earning configuration creation follows last-write-wins (documented in UC6.1). Incentive creation has no concurrency constraint — two simultaneous creates for the same Vendor × Hub are both accepted as independent incentives. Audit trail captures both with separate `incentive_id` values.
