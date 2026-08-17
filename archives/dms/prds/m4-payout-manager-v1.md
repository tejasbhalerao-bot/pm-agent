# DMS M4: Payout Manager

**Version:** v1
**Milestone:** 4 — Payout Manager
**Date:** 2026-05-30
**Status:** Draft

---

## 1. Overview

Milestone 4 delivers Payout Manager within the DMS-Locus integration. It covers two domains:

1. **Driver Earnings** — salary structure configuration per Vendor × Hub
2. **Incentives** — creation and management of performance-based payout programs

---

## 2. Use Case 5: Incentives

### 5.1 Create Incentive

User navigates to the Incentives section on Locus's platform.

> `<add navigation steps here>`

On the same page, the user can view all existing incentives (active and inactive) alongside the creation interface.

On clicking **"Create"**, an incentive creation form is rendered.

---

#### Incentive Types

| Incentive Type | What It Incentivises |
|---|---|
| Attendance Based | Driver presence across a minimum number of working days within the incentive window (tiered) |
| Order Based | Delivery of a minimum number of orders within the incentive window (tiered) |
| Route Specific | Availability on deliveries within a defined pincode set |
| Ad-hoc / Festival Based | Availability and delivery performance during high-demand or non-working periods — salary-based drivers only |

> **Multi-incentive eligibility:** There is no upper limit on the number of active incentives a driver can simultaneously qualify for. A driver may accrue payouts from multiple incentive programs running in parallel.

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

**Tier resolution:** Driver earns the payout for the highest tier they qualify for. Tiers are not additive.

*Example:* Tier 1 = 15 days → Rs. 100 | Tier 2 = 20 days → Rs. 200 | Tier 3 = 30 days → Rs. 300. A driver present for 22 days earns Rs. 200.

---

##### Order Based — Tiered

At least one tier is required. Multiple tiers can be configured.

| Field | Required | Rule |
|---|---|---|
| Tier Number | Mandatory | Sequential integer starting at 1. |
| # of Orders | Mandatory | Integer. Minimum orders delivered within the incentive window to qualify. Must be strictly greater than the previous tier's # of Orders. |
| Rs. (Payout) | Mandatory | Numeric (Rs.). Total payout when driver qualifies for this tier. Must be > 0. |

**Tier resolution:** Driver earns the payout for the highest tier they qualify for. Tiers are not additive.

*Example:* Tier 1 = 15 orders → Rs. 100 | Tier 2 = 20 orders → Rs. 200 | Tier 3 = 30 orders → Rs. 300. A driver delivering 25 orders earns Rs. 200.

---

##### Route Specific

| Field | Required | Rule |
|---|---|---|
| Pincode List | Mandatory | Multi-value input. At least one pincode required. Incentive applies to days on which the driver completes at least one delivery within these pincodes. |
| Rs. per Day | Mandatory | Numeric (Rs.). Daily payout for each qualifying day. Must be > 0. |

---

##### Ad-hoc / Festival Based

Applicable to **salary-based drivers only**. Locus restricts this incentive type to drivers whose active earning configuration is Salary Based for the applicable Vendor × Hub.

| Field | Required | Rule |
|---|---|---|
| Rs. per Order | Mandatory | Numeric (Rs.). Incremental payout per order delivered during the incentive window. Must be > 0. |
| Rs. per Day | Mandatory | Numeric (Rs.). Daily payout for each day the driver is active during the window. Must be > 0. |

Start Date and End Date from common fields define the festival/ad-hoc window.

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

On clicking **"Deactivate"** against an incentive record:

- Locus presents a confirmation prompt: *"Are you sure you want to deactivate this incentive? This will stop payouts for all drivers currently accruing against it."*
- On confirmation, incentive status is set to **Inactive** immediately.
- Deactivation is **not reversible**. A new incentive must be created to reinstate the payout structure.

---

> **Callout:** Incentive creation, deactivation, and list fetch must be exposed via API in addition to the UI.

---

## 3. Use Case 6: Driver Earnings

### 6.1 Create Earnings Configuration

User navigates to the driver's profile on Locus's platform.

> `<add navigation steps here>`

Driver earnings are configured on one of two salary structures. Each configuration is scoped to a **Vendor × Hub** pair.

---

#### Structure A — Per Order

| Parameter | Required | Rule |
|---|---|---|
| Vendor | Mandatory | Single-select from configured vendors. Part of the primary key. |
| Hub | Mandatory | Single-select from configured hubs. Part of the primary key. |
| MG — Minimum Guarantee (Rs.) | Mandatory | Numeric (Rs.). Minimum daily earnings guaranteed to the driver regardless of order count. Must be > 0. |
| Rs. per Order | Mandatory | Numeric (Rs.). Variable payout per order delivered in the shift. Must be ≥ 0. |

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

- On creation of a new earning configuration for a **Vendor × Hub** pair, the previous configuration for that pair is automatically marked **Inactive**.
- The new configuration is **Active** from the moment of creation (`creation_timestamp`).
- Historical inactive configurations are **retained in Redshift** and not deleted — required for financial reconciliation and audit.
- Effective date of any configuration is its `creation_timestamp`. Earnings for shifts completed before this timestamp are calculated against the previous configuration.

---

### 6.2 Calculation of Driver Earnings

At the end of each completed shift, Locus calculates the driver's total earnings and passes the computed record back to Truemeds systems for financial reconciliation.

---

#### Per Order Driver

```
Daily Earnings = max(MG, Rs./order × Orders Delivered in shift)
```

If per-order earnings exceed MG, the driver earns the higher per-order amount. If below, MG applies as the floor.

---

#### Salary Based Driver

```
Daily Earnings = Rs./day + (Rs./km × Actual Distance Travelled in shift)
```

---

#### Trigger

Odometer readings are captured at the start and end of each shift (detailed in Milestone 6). Earnings calculation fires once the final odometer reading at shift end is recorded.

---

## 4. Open Questions

| # | Question | Owner |
|---|---|---|
| 1 | Navigation path for Incentives section on Locus (UC5.1) | Locus |
| 2 | Navigation path for driver earnings config on Locus (UC6.1) | Locus |
| 3 | At the time of incentive deactivation, what happens to earnings already accrued but not yet paid out — freeze, settle, or drop? | Locus / Finance |
| 4 | After Locus passes computed earnings to Truemeds, what is the downstream reconciliation workflow — is there an approval gate before payout? | Truemeds Finance |
| 5 | Ad-hoc / Festival Based: if a driver is switched from Salary Based to Per Order mid-incentive window, does the incentive auto-terminate or remain until End Date? | Locus |
