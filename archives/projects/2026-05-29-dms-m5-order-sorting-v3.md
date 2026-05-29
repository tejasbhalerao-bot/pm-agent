# [PRD] DMS Integration — Milestone 5: Order Sorting

**Version:** v3
**Date:** 2026-05-29
**Supersedes:** 2026-05-21-dms-m5-order-sorting-v2.md
**Author:** Tejas Bhalerao
**Status:** In Review

---

## Version History

| Version | Date | Summary of Changes |
|---|---|---|
| v1 | 2026-05-20 | Initial draft |
| v2 | 2026-05-21 | Auth matrix corrected (AWB generation is system-triggered); `.Alias` → `.name` throughout; Process Overview added; UC2 trigger corrected (Dispatch Portal only, not Driver); F2.3 removed (pickup address always present); UC3 rewritten (forward: re-scan box, reverse: portal download); UC4 removed (no AWB cancellation flow); Pass 4 and Pass 5 removed; barcode service internals removed; label disposal policy removed; all open questions resolved |
| v3 | 2026-05-29 | Clickpost replaces Shipsy throughout; serviceability update lock added for AWB-generated and rescheduled orders; Sort Identifier Code format changed to `<OrderType>_<LM_Hub>_<Delivery_Zone>`; hub alias and zone alias configuration added as M5 pre-condition; both pickup and drop address + contact now required on all AWB types; EC1.8 (warehouse_details table unavailable) removed; mid-mile hub removed from Sort Identifier Code; field references updated |

---

## RACI

| Function | R | A | C | I |
|---|---|---|---|---|
| Product | Tejas | Tejas | — | — |
| Engineering | Eng Lead | — | Tejas | Fahad |
| Ops | Ops Lead | — | Tejas | Kartik |
| Locus | Locus CSM | — | Eng Lead | — |

---

## Authorization Matrix

AWB generation is system-triggered and does not require manual authorisation. The following human-initiated actions require role-based access control:

| Action | Permitted Roles |
|---|---|
| Reprint AWB | Warehouse Logistics, HO Central Logistics |
| View AWB records | All roles |
| Modify Sort Identifier Code mapping | Tech only |
| Modify Hub Alias configuration | Tech only |
| Modify Zone Alias configuration | Tech only |

---

## Objective

Replace Clickpost's AWB generation with Locus-sourced AWBs and Sort Identifier Codes for all hyperlocal orders — enabling correct physical sorting at warehouse before dispatch.

---

## Why Now?

Every downstream milestone depends on correct Sort Identifier Code generation:
- **M6 Planning Engine** ingests orders using Locus-format identifiers
- **M7 Driver App** scans and executes trips built on these order identifiers
- **M8 Alerts** monitors deviations in AWB and Sort Identifier Code generation

AWB generation is the first physical touch point in the fulfilment cycle. An error here propagates to every subsequent scan. This milestone must be complete before M6 integration testing begins.

---

## Process Overview

**Forward AWB (no change to warehouse physical flow):**
Box scanned at warehouse → AWB generated automatically → AWB print begins immediately → physical label affixed to box before dispatch.

This is the same physical process used today with Clickpost. The change is that Locus now sources the AWB and Sort Identifier Code instead of Clickpost.

**Reverse AWB:**
Dispatcher portal login → Order ID selected → "Download AWB" clicked → AWB generated and presented as PDF → dispatcher prints and coordinates pickup.

---

## Business Rules

### Serviceability Update Lock on AWB-Generated Orders

Once an AWB has been generated for an order, serviceability updates **must not** be persisted for that order. The AWB and Sort Identifier Code are already printed; a serviceability change at this stage would create a mismatch between the physical label and the system state.

- **AWB-generated orders:** block all serviceability update persistence from the moment AWB is created
- **Orders without AWB:** serviceability updates persist as normal
- **Rescheduled orders:** same rule applies — if AWB is not yet generated, updates persist; if AWB already exists, updates are blocked
- Blocked update attempts must be logged with the Order ID and attempted update payload for audit

---

## Alias Configuration

Sort Identifier Code segments `LM_Hub` and `Delivery_Zone` are derived from **configured aliases**, not from raw hub or zone names. Aliases must be created and verified before M5 launch.

### Hub Alias

Each Last Mile Hub in Geography setup must have a short alphanumeric alias configured:

| Hub | Alias Example |
|---|---|
| Mumbai Last Mile Hub | `MUM` |
| South Bombay Hub | `SB` |
| Pune DC | `PUN` |

- Alias: 2–6 uppercase alphanumeric characters, no spaces, no special characters
- Stored in: Hub entity alias field (Geography setup — M2)
- Managed by: Tech only (see Authorization Matrix)
- Missing alias → AWB generation blocked (see EC1.A)

### Zone Alias

Each Delivery Zone in Geography setup must have a short alias configured:

| Zone | Alias Example |
|---|---|
| Powai | `Pow` |
| Colaba | `Col` |
| Andheri West | `AnW` |

- Alias: 2–5 characters, mixed case permitted, no spaces, no special characters
- Stored in: Zone entity alias field (Geography setup — M2)
- Managed by: Tech only (see Authorization Matrix)
- Missing alias → AWB generation blocked (see EC1.B)

---

## Field Reference — Forward AWB

| Field | Source | Notes |
|---|---|---|
| Order ID | Truemeds OMS | Unique per order |
| Barcode for Order ID | Internal barcode service | Symbology: **Code 128** |
| Order Type | Derived from order | Value: `FWD` |
| LM Hub Alias | Geography Hub alias | Used in Sort Identifier Code `LM_Hub` segment |
| Delivery Zone Alias | Geography Zone alias | Used in Sort Identifier Code `Delivery_Zone` segment |
| Delivery Partner | Locus configuration | Maps to warehouse entity |
| Origin Hub | Geography setup (Hub entity) | `warehouse_details.name` column — must exist in active Locus geography |
| Delivery Pincode | OMS order record | Used to resolve Delivery Zone; not printed on label |
| Drop Address | OMS order record | Unmasked on physical label |
| Drop Contact | OMS order record | Unmasked on physical label |
| Pickup Address | OMS order record | Warehouse origin address; unmasked on physical label |
| Pickup Contact | OMS order record | Warehouse contact; unmasked on physical label |
| Sort Identifier Code | Constructed by Truemeds | See format spec below |

**Label format:** Same as current reverse AWB label format.

---

## Field Reference — Reverse AWB

| Field | Source | Notes |
|---|---|---|
| Order ID | Truemeds OMS | Unique per original forward order |
| Barcode for Order ID | Internal barcode service | Symbology: **Code 128** |
| Order Type | Derived from order | Value: `RVP` |
| LM Hub Alias | Geography Hub alias | Used in Sort Identifier Code `LM_Hub` segment |
| Pickup Zone Alias | Geography Zone alias | Used in Sort Identifier Code `Delivery_Zone` segment |
| Delivery Partner | Locus configuration | Maps to warehouse entity |
| Destination Hub | Geography setup (Hub entity) | Return warehouse |
| Pickup Pincode | OMS order record | Customer's pincode; used to resolve Pickup Zone |
| Pickup Address | OMS order record | Customer address; unmasked on physical label |
| Pickup Contact | OMS order record | Customer contact; unmasked on physical label |
| Drop Address | OMS order record | Return warehouse address; unmasked on physical label |
| Drop Contact | OMS order record | Return warehouse contact; unmasked on physical label |
| Sort Identifier Code | Constructed by Truemeds | See format spec below |

**Label format:** Same as current reverse AWB label format.

---

## Sort Identifier Code Format Specification

```
<OrderType>_<LM_Hub>_<Delivery_Zone>
```

**Examples:**

| Order | Sort Identifier Code |
|---|---|
| Forward, Mumbai LM Hub, Powai zone | `FWD_MUM_Pow` |
| Reverse pickup, South Bombay Hub, Colaba zone | `RVP_SB_Col` |

**Segment definitions:**

| Segment | Value | Source |
|---|---|---|
| `OrderType` | `FWD` (forward) or `RVP` (reverse pickup) | Derived from OMS order type |
| `LM_Hub` | Hub alias from Geography Hub entity | Configured alias — see Alias Configuration |
| `Delivery_Zone` | Zone alias from Geography Zone entity | Configured alias — see Alias Configuration; resolved via pincode → zone mapping |

**Rules:**
- Delimiter: underscore `_` only
- No spaces, no special characters outside underscore
- `OrderType` must be exactly `FWD` or `RVP`
- `LM_Hub`: 2–6 uppercase alphanumeric characters
- `Delivery_Zone`: 2–5 alphanumeric characters, mixed case permitted
- Zone resolution: Delivery Pincode (forward) or Pickup Pincode (reverse) → zone entity → zone alias

**Validation:** Generated code must match regex `^(FWD|RVP)_[A-Z0-9]{2,6}_[A-Za-z0-9]{2,5}$`

---

## Use Case 1: Forward AWB Generation

**Trigger:** OMS dispatches a forward hyperlocal order for physical fulfilment. AWB generation is automatic — no manual action required.

**Pre-conditions:**
- Order ID exists in OMS with status = Ready for Dispatch
- Delivery Pincode exists in active zone-pincode mapping and maps to a zone with a configured alias
- Origin Hub exists in Geography setup with `warehouse_details.name` populated and hub alias configured
- No existing AWB for this Order ID

### Happy Path

1. OMS triggers AWB generation request with `order_id`, `delivery_pincode`, `drop_address`, `drop_contact`, `pickup_address`, `pickup_contact`
2. System resolves LM Hub alias from Geography Hub entity for the dispatching warehouse
3. System queries zone-pincode mapping to resolve Delivery Zone from Delivery Pincode
4. System resolves Delivery Zone alias from Geography Zone entity
5. Construct Sort Identifier Code: `FWD_<LM_Hub_alias>_<Zone_alias>`
6. Validate Sort Identifier Code against regex
7. Generate Code 128 barcode for Order ID
8. Assemble AWB with all required fields including both pickup and drop address + contact
9. Return AWB payload; print trigger sent to warehouse printer automatically
10. Physical label printed and affixed to order package
11. Order flagged as AWB-generated; serviceability update lock applied

### Edge Cases

**EC1.1 — LM Hub alias missing for dispatching warehouse**
- System cannot construct `LM_Hub` segment; Sort Identifier Code construction blocked
- Outcome: AWB generation blocked; error returned to OMS
- Response: Alert A5.2 fired; order enters "AWB Generation Failed" state; Ops + Tech notified
- Resolution: Tech configures hub alias in Geography setup; trigger re-generation

**EC1.2 — Delivery Pincode not in zone-pincode mapping**
- System cannot resolve Delivery Zone; `Delivery_Zone` segment is null
- Outcome: AWB generation blocked
- Response: Alert A5.2 fired; check serviceability-geography sync (M2 A2.6)
- Resolution: Geography team adds pincode to correct zone; re-generate

**EC1.A — Delivery Zone alias missing in Geography**
- Zone exists and pincode maps to it, but zone alias field is blank
- Outcome: AWB generation blocked to prevent malformed Sort Identifier Code
- Response: Alert A5.4 fired; Tech notified
- Resolution: Tech configures zone alias; re-generate

**EC1.B — LM Hub alias blank in Geography (hub exists, alias not set)**
- Hub exists and is active but alias field is blank
- Outcome: AWB generation blocked
- Response: Alert A5.4 fired; Tech notified
- Resolution: Tech populates hub alias; re-generate

**EC1.4 — Order ID not resolvable in OMS**
- OMS sends `order_id` that doesn't exist or is in wrong status
- Outcome: AWB generation rejected at validation
- Response: OMS integration error logged; no alert fired (OMS-side issue)
- Resolution: OMS team investigates order state

**EC1.5 — Duplicate AWB generation attempt**
- AWB already exists for this Order ID
- Outcome: Request rejected; existing AWB returned
- Response: Alert A5.9 fired; no new AWB created
- Resolution: Warehouse must verify order state before re-triggering

**EC1.6 — Sort Identifier Code format validation failure**
- Code constructed but fails regex `^(FWD|RVP)_[A-Z0-9]{2,6}_[A-Za-z0-9]{2,5}$`
- Outcome: AWB generation blocked; validation error returned
- Response: Alert A5.3 fired; Tech investigates alias data quality (illegal characters, alias length out of bounds)
- Resolution: Fix alias values; re-generate

**EC1.7 — Printer offline**
- AWB generated successfully but print job fails
- Outcome: AWB exists in system (retrievable) but no physical label
- Response: Warehouse Logistics notified; printer alert triggered
- Resolution: Reprint via UC3

**EC1.9 — Zone-pincode mapping table unavailable**
- Cannot resolve zone from pincode
- Response: Fail fast; block generation; Tech P0

**EC1.10 — Locus Geography API unavailable**
- Response: Fallback to local cached mapping if cache age < 30 minutes; else block generation
- Cache staleness threshold: configurable, default 30 minutes

**EC1.11 — Print service timeout**
- AWB created in system; print fails
- Response: Return success to OMS for AWB creation; fire separate printer alert to Ops; do not block order flow; serviceability lock still applied

---

## Use Case 2: Reverse AWB Generation

**Trigger:** Dispatch Portal generates a reverse AWB for a hyperlocal reverse order.

**Pre-conditions:**
- Original forward order exists or return is a standalone reverse order
- Pickup Pincode exists in active zone-pincode mapping and maps to a zone with a configured alias
- Destination Hub (return warehouse) exists in Geography setup with hub alias configured

### Happy Path

1. Dispatcher logs into Dispatch Portal, selects Order ID, clicks "Download AWB"
2. System resolves LM Hub alias for the Destination Hub (return warehouse)
3. System queries zone-pincode mapping to resolve Pickup Zone from Pickup Pincode
4. System resolves Pickup Zone alias from Geography Zone entity
5. Construct Sort Identifier Code: `RVP_<LM_Hub_alias>_<Zone_alias>`
6. Validate Sort Identifier Code against regex
7. Generate Code 128 barcode for Order ID
8. Assemble Reverse AWB with all required fields including both pickup and drop address + contact
9. AWB presented to Dispatcher as PDF for download and print
10. Order flagged as AWB-generated; serviceability update lock applied

### Edge Cases

**EC2.1 — Dispatch Portal unavailable**
- Reverse AWB cannot be triggered
- Response: Alert A5.1 equivalent for reverse; Ops + Tech notified; orders queued pending portal recovery
- Note: Forward AWB unaffected (different trigger path)

**EC2.2 — Duplicate reverse AWB generation**
- Reverse AWB already exists for this Order ID
- Response: Alert A5.9 fired; request rejected; existing AWB returned
- Resolution: Dispatcher downloads existing AWB instead of generating new one

**EC2.3 — AWB type mismatch (forward AWB generated for reverse order or vice versa)**
- Response: Alert A5.7 fired (P0); generation blocked at type validation
- Resolution: Correct order type in trigger; re-generate

---

## Use Case 3: AWB Reprint

**Trigger:** Warehouse Logistics or Dispatcher requests reprint of an existing AWB (damaged label, printer failure, download needed).

### Forward AWB Reprint

1. Warehouse staff scans the box again at warehouse
2. System detects existing active AWB for the scanned Order ID
3. Print job re-triggered to warehouse printer
4. Physical label reprinted and affixed

### Reverse AWB Reprint

1. Dispatcher logs into Dispatch Portal, selects Order ID
2. Clicks "Download AWB"
3. AWB PDF served again (same AWB, not a new generation)

### Edge Cases

**R1 — Reprint for a cancelled/invalid AWB**
- Response: Request rejected; error shown to Dispatcher

**R2 — Printer offline during forward reprint**
- Response: Reprint job queued; retry when printer comes online; Ops notified

---

## Metrics

| Metric | Target | Notes |
|---|---|---|
| AWB generation success rate | ≥ 99.5% | Measured per dispatch window |
| AWB generation latency (p95) | < 3 seconds | From OMS trigger to AWB ready |
| Sort Identifier Code format validation failure rate | < 0.1% | Indicates alias data quality issue |
| Duplicate AWB alert rate | < 0.05% | A5.9 should be near-zero in steady state |
| Alias coverage (hubs and zones with alias configured) | 100% before cutover | Pre-launch gate |
| Printer failure rate | Baseline (establish in first 2 weeks) | — |
| Re-print rate | Baseline | Elevated reprint = label quality problem |
| Serviceability update blocks on AWB-generated orders | Monitor from cutover | Unexpected spikes indicate OMS sequencing issue |

---

## Rollout

**Phase 1 — Pre-launch (T-14 days):**
- Configure hub aliases for all active LM Hubs in Geography setup
- Configure zone aliases for all active Delivery Zones in Geography setup
- Verify alias coverage is 100% before proceeding
- Populate `warehouse_details.name` for all active warehouses
- Configure and test Code 128 barcode output
- Confirm label format (both pickup + drop address/contact) at all warehouse locations
- Confirm serviceability update lock logic deployed and tested in staging

**Phase 2 — Parallel run (T-7 to T-0):**
- Generate both Clickpost AWBs and Locus AWBs for same orders
- Compare Sort Identifier Codes; validate format and alias resolution
- Do NOT use Locus AWBs for physical sorting during parallel run
- Validate that both pickup and drop address/contact fields are populated correctly on all labels

**Phase 3 — Cutover (T-0):**
- Switch OMS to Locus AWB generation exclusively
- Disable Clickpost AWB generation path
- Activate serviceability update lock on AWB-generated orders
- Ops confirm Sort Identifier Code scan success rate in first 2 dispatch windows

**Phase 4 — Clickpost decommission (T+30 days):**
- After 30 days stable operation, remove Clickpost AWB generation code
- Archive Clickpost AWB records per data retention policy

---

## Appendix A — Sample Forward AWB Layout

```
┌─────────────────────────────────────────────────────┐
│  TRUEMEDS HYPERLOCAL — FORWARD DELIVERY             │
│                                                     │
│  Sort Code: FWD_MUM_Pow                             │
│  ─────────────────────────────────────────────────  │
│  [██████████████████████████████████████]           │
│  TM9988776                                          │
│  ─────────────────────────────────────────────────  │
│  Pickup From:                                       │
│  Truemeds Warehouse, Andheri East, Mumbai 400069    │
│  Contact: +91-9000000001                            │
│  ─────────────────────────────────────────────────  │
│  Deliver To:                                        │
│  123, Sharma Building, Andheri West, Mumbai 400001  │
│  Contact: +91-9876543210                            │
│  ─────────────────────────────────────────────────  │
│  LM Hub: MUM    Zone: Pow    Partner: Locus         │
└─────────────────────────────────────────────────────┘
```

---

## Appendix B — Sample Reverse AWB Layout

```
┌─────────────────────────────────────────────────────┐
│  TRUEMEDS HYPERLOCAL — REVERSE / RETURN             │
│                                                     │
│  Sort Code: RVP_SB_Col                              │
│  ─────────────────────────────────────────────────  │
│  [██████████████████████████████████████]           │
│  TM9988776-REV                                      │
│  ─────────────────────────────────────────────────  │
│  Pickup From:                                       │
│  456, Patel Colony, Colaba, Mumbai 400005           │
│  Contact: +91-9123456780                            │
│  ─────────────────────────────────────────────────  │
│  Return To:                                         │
│  Truemeds Return Hub, Fort, Mumbai 400001           │
│  Contact: +91-9000000002                            │
│  ─────────────────────────────────────────────────  │
│  LM Hub: SB    Zone: Col    Partner: Locus          │
└─────────────────────────────────────────────────────┘
```
