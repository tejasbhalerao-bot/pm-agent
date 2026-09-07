---
**Document:** Mid-Mile Entity Introduction
**Type:** Executable PRD
**Version:** v1
**Date:** 2026-09-07
**Status:** Approved
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-09-07 | Initial draft. Use Cases 1–3 and the Use Case 4 skeleton carried over from the source doc; Use Case 4 completed, Use Cases 5–8 (Zone-Hub Mapping, Order-Level Instrumentation, Reverse Flow Setup, Configuration Governance) drafted new, patterned on DMS M2 Geography Setup's solution design. RACI, Authorization Matrix, Objective, Rationale, Metrics, Rollout & Stage Gates, and Future Scope added. |
---

# [PRD] Mid-Mile Entity Introduction

---

## RACI

| Function | R | A | C | I |
|---|---|---|---|---|
| Product | Tejas | Tejas | — | — |
| Engineering | Eng Lead | — | Tejas | Fahad |
| Ops | Ops Lead (Ajit / Mukesh) | — | Tejas | Kartik |
| SCM | Rajendran | — | Tejas | Atul, Kekin |
| Analytics | Dinesh | — | Tejas | — |

---

## Authorization Matrix

Mid-mile entity and mapping changes affect live order routing. Role restrictions apply to every action below.

| Action | Permitted Roles |
|---|---|
| Delivery Zone CRUD (bulk upload) | Ops, HO Central Logistics |
| Pincode-to-Delivery Zone mapping (bulk upload) | Ops, HO Central Logistics |
| DC CRUD (bulk upload) | SCM, HO Central Logistics |
| DC-to-WH/DC mapping (bulk upload) | SCM, HO Central Logistics |
| Delivery Zone-to-Hub mapping (bulk upload) | Ops, HO Central Logistics |
| Delete action — any entity or mapping | HO Central Logistics only, **Maker-Checker required** (two distinct approvers) — see Use Case 8 |
| Viewing configuration | All roles |

---

## Objective

Establish Delivery Zones and DCs — and their mappings to Pincodes, WHs, and Hubs — as canonical, governed entities within Truemeds' logistics stack, so that every mid-mile movement (forward and reverse) has a resolvable, auditable path from origin warehouse to last-mile hub, independent of and prior to any downstream system (including DMS/Locus geography) consuming this configuration.

---

## Rationale

Today, mid-mile network topology — which DC feeds which warehouse, which delivery zone is served by which hub — exists only as tribal knowledge and ad hoc spreadsheets. There is no canonical system of record, no CRUD governance, and no audit trail for changes to this topology.

This creates three concrete risks:

1. **Unroutable orders.** An order can reach a dead end mid-network with no defined path to a warehouse or hub, forcing manual intervention to fulfil it.
2. **Undetected unauthorized change.** Undocumented or unauthorized changes to mid-mile routing go undetected until an operational failure surfaces them — there is no audit trail today.
3. **Duplicated, drifting configuration.** Downstream systems that need this topology (DMS/Locus geography setup, mid-mile trip planning, reverse logistics) have no single source of truth to consume, resulting in duplicated and drifting configuration across systems.

As Truemeds' mid-mile footprint (DCs, warehouses, hubs) continues to grow, resolving this now — before network complexity compounds — prevents both operational failures and a costly downstream reconciliation problem across systems that will increasingly depend on this topology.

**Scope note:** WH (Warehouse) and Hub are entities owned and created by other systems of record — WH by the Warehouse Master, Hub by DMS/Locus Geography setup (see DMS M2). This PRD references them by ID for mapping and validation purposes only. It does not define their creation, edit, or deletion lifecycle.

**Dependency note:** All CRUD and mapping operations in this PRD are served by Truemeds-internal systems (bulk upload tool, Warehouse Master, Geography setup) — there is no third-party API in the critical path. External-system-outage analysis (retry counts, circuit breakers) does not apply to this milestone; internal-lookup failures are covered inline as validation edge cases instead.

---

## Use Cases

---

### Use Case 1: CRUD Operations to Delivery Zones

- Every zone must have the following parameters at all points in time.

| **Parameter** | **Definition** | **Data Type** |
|---|---|---|
| Zone ID | Unique identifier of the zone. Auto created by the system. | Integer |
| Zone Name | Unique name of the zone which will be used as the canonical identifier. | String |
| Zone Alias | Nickname with which the zone will be referenced. | String |

- CRUD operations on a zone need to happen through the existing bulk upload mechanism.
- CRUD Rules:

| **Action** | **Does Zone Exist?** | **Note** |
|---|---|---|
| Insert | No | The system mandates the presence of all 3 parameters. |
| Insert | Yes | The system silently ignores insert instructions and performs updates. |
| Update | No | The system rejects the configuration and prompts reupload. |
| Update | Yes | The system performs an update action only on the parameters provided. The presence of zone ID is mandated with an update action. |
| Delete | No | The system silently ignores delete instructions. |
| Delete | Yes | The system performs a delete action. The presence of zone ID is mandated. No other parameters are mandatory to be provided. |

---

### Use Case 2: Pincode to Delivery Zone Mapping

- Every delivery zone is required to have pincodes mapped against it. Without this mapping, the existence of a delivery zone is meaningless.
- Similar to Use Case 1, the system accepts configurations in a bulk upload mechanism.
- For every mapping action, the system mandates the presence of both the zone ID as well as the pincode.
- Whenever a pincode to delivery zone mapping is to be changed, then the following rules are adhered.

| **Action** | **Does Zone Exist?** | **Does Config Exist?** | **Note** |
|---|---|---|---|
| Insert | Yes | Yes | The system silently ignores the insert action. |
| Insert | Yes | No | The system performs the insert action provided zone ID and pincode are provided. Else, upload action is rejected. |
| Insert | No | Yes | Impossible situation. The system should have never allowed upload of such config. |
| Insert | No | No | The system rejects the upload action saying no such zone exists. |
| Delete | Yes | Yes | The system performs the delete action provided both zone ID and pincode are provided. Else, upload action is rejected. |
| Delete | Yes | No | The system silently ignores the delete action. |
| Delete | No | Yes | Impossible situation. The system should have never allowed upload of such config. |
| Delete | No | No | The system silently ignores the delete action. |

---

### Use Case 3: CRUD Operations to DC

- Every DC must have the following parameters at all points in time.

| **Parameter** | **Definition** | **Data Type** |
|---|---|---|
| DC ID | Unique identifier of the DC. Auto created by the system. | Integer |
| DC Name | Unique name of the DC which will be used as the canonical identifier. | String |
| DC Alias | Nickname with which the DC will be referenced. | String |
| DC Address | Complete text address of the DC's physical location. | String |
| DC Pincode | Pincode where the DC is physically present. | String |

- CRUD operations on a DC need to happen through the existing bulk upload mechanism.
- CRUD Rules:

| **Action** | **Does DC Exist?** | **Note** |
|---|---|---|
| Insert | No | The system mandates the presence of all parameters. |
| Insert | Yes | The system silently ignores insert instructions and performs updates. |
| Update | No | The system rejects the configuration and prompts reupload. |
| Update | Yes | The system performs an update action only on the parameters provided. The presence of DC ID is mandated with an update action. |
| Delete | No | The system silently ignores delete instructions. |
| Delete | Yes | The system performs a delete action. The presence of DC ID is mandated. No other parameter is necessary to be provided. |

---

### Use Case 4: DC to WH Mapping

- Every DC needs to have WHs or other DCs mapped to it as its onward mid-mile destination(s). Without this configuration present, the existence of a DC is meaningless — there is no path for shipments to move beyond it.
- All mapping operations happen through the existing bulk upload mechanism.
- For every mapping action, the system mandates the presence of the DC ID and the Destination ID.

| **Parameter** | **Definition** | **Data Type** |
|---|---|---|
| DC ID | Identifier of the DC for which a destination is being configured. | Integer |
| Destination ID | Identifier of the WH or DC that this DC routes mid-mile shipments to. | Integer |
| Destination Type | Whether Destination ID refers to a WH or another DC. | Enum (WH / DC) |
| Mapping Direction | Whether this mapping is usable for forward mid-mile flow, reverse flow, or both. See Use Case 7. | Enum (Forward / Reverse / Bidirectional) |

**CRUD Rules:**

| **Action** | **Does DC Exist?** | **Does Config Exist?** | **Note** |
|---|---|---|---|
| Insert | Yes | Yes | The system silently ignores the insert action. |
| Insert | Yes | No | The system performs the insert action provided DC ID, Destination ID, Destination Type, and Mapping Direction are all provided and the Destination ID is valid (see edge case 1). Else, upload action is rejected. |
| Insert | No | Yes | Impossible situation. The system should have never allowed upload of such config. |
| Insert | No | No | The system rejects the upload action saying no such DC exists. |
| Delete | Yes | Yes | The system performs the delete action provided both DC ID and Destination ID are provided. Else, upload action is rejected. |
| Delete | Yes | No | The system silently ignores the delete action. |
| Delete | No | Yes | Impossible situation. The system should have never allowed upload of such config. |
| Delete | No | No | The system silently ignores the delete action. |

**Edge cases — validation:**

1. Destination ID does not exist — not found as an active WH in the Warehouse Master (if Destination Type = WH) or as an active DC (if Destination Type = DC) → row rejected: "Destination not found: `<Destination ID>`. Verify the ID and type and retry."
2. DC lists itself as its own Destination → row rejected: "A DC cannot be mapped to itself."
3. The mapping being inserted would complete a cycle (DC A → DC B → … → DC A) → row rejected in full, listing every DC ID in the cycle. A cyclical mid-mile path has no terminal WH and can never resolve (see Use Case 6).
4. DC ID or Destination ID missing → row rejected: "Please enter a valid value for `<column name>`."

**Edge cases — state intersection:**

5. Mapping deleted or its Mapping Direction changed while a mid-mile trip is currently in transit along that DC–Destination edge → the change does not block. The in-flight trip continues against the mapping valid at trip creation (see Use Case 6). Trips created after the change use the updated mapping.

---

### Use Case 5: Delivery Zone to Hub Mapping

Hub records are owned and created in DMS/Locus Geography setup (see DMS M2, Use Case 3). This PRD does not create or edit Hub entities — it references Hub by ID solely to establish which Hub a Delivery Zone maps to for mid-mile purposes.

- Every delivery zone must be mapped to exactly one Hub at a time. A zone with no Hub mapping cannot resolve a mid-mile path (see Use Case 6).
- All mapping operations happen through the existing bulk upload mechanism.
- For every mapping action, the system mandates the presence of the Zone ID and the Hub ID.

| **Action** | **Does Zone Exist?** | **Does Config Exist?** | **Note** |
|---|---|---|---|
| Insert | Yes | Yes | The system silently ignores the insert action. |
| Insert | Yes | No | The system performs the insert action provided Zone ID and Hub ID are provided and the zone is not already mapped to a different Hub (see edge case 2). Else, upload action is rejected. |
| Insert | No | Yes | Impossible situation. The system should have never allowed upload of such config. |
| Insert | No | No | The system rejects the upload action saying no such zone exists. |
| Delete | Yes | Yes | The system performs the delete action provided both Zone ID and Hub ID are provided. Else, upload action is rejected. |
| Delete | Yes | No | The system silently ignores the delete action. |
| Delete | No | Yes | Impossible situation. The system should have never allowed upload of such config. |
| Delete | No | No | The system silently ignores the delete action. |

**Edge cases — validation:**

1. Hub ID does not exist in Geography setup → row rejected: "Hub not found: `<Hub ID>`. Verify the hub ID in Geography setup before retrying."
2. Insert attempted for a zone already mapped to a different Hub → row rejected: "Zone `<Zone ID>` already mapped to Hub `<Hub ID>`. Use a delete action to remove the existing mapping before inserting, or submit as a single update."
3. Reassignment rows (delete old Hub + insert new Hub) submitted out of order in the same upload → processed in file order, which can leave the zone unmapped or reject the insert. As with pincode reassignment (Use Case 2), reassignment should always be submitted as a single update action to avoid this ordering risk.

**Edge cases — state intersection:**

4. Zone-Hub mapping deleted while last-mile plans or in-flight mid-mile trips reference that zone → the delete proceeds. In-flight operations are unaffected and continue to completion. New orders for pincodes in that zone cannot resolve a mid-mile path until the zone is remapped (see Use Case 6, "Mid-Mile Path Not Found").

---

### Use Case 6: Order Level Instrumentation

Every order that moves through the mid-mile network must have its path and progress captured at the leg level. This is a dedicated instrumentation requirement, not a metrics roll-up.

**Table:** `mid_mile_order_leg_log` (Redshift)
**Granularity:** One row per order per leg transition. An order whose path is WH → DC → Hub produces two rows (WH→DC, DC→Hub).

| Field | Type | Description |
|---|---|---|
| order_id | String | Truemeds order identifier |
| leg_sequence | Integer | 1-indexed position of this leg within the order's resolved mid-mile path |
| direction | Enum (Forward / Reverse) | Forward = outbound to last-mile Hub. Reverse = return to WH. See Use Case 7. |
| origin_entity_id / origin_entity_type | Integer / Enum (WH, DC, Hub) | Entity this leg originates from |
| destination_entity_id / destination_entity_type | Integer / Enum (WH, DC, Hub) | Entity this leg terminates at |
| leg_status | Enum (Planned, In Transit, Arrived, Failed) | Current state of this leg |
| planned_departure_ts / actual_departure_ts | Timestamp | |
| planned_arrival_ts / actual_arrival_ts | Timestamp | |

**Happy path:** At order creation, the system resolves the order's pincode → Delivery Zone (Use Case 2) → Hub (Use Case 5), then walks the DC-to-WH/DC mapping graph (Use Case 4) upstream from that Hub's serving DC to a terminal WH. One row per leg is written in `Planned` state. As physical mid-mile scans occur (existing scan-event mechanism), `leg_status` transitions to `In Transit` and `Arrived` per leg.

**Edge cases:**

1. **No path resolvable** — the zone has no Hub mapping (Use Case 5), or the resolved Hub's DC has no onward Destination mapped (Use Case 4) → the order enters a **"Mid-Mile Path Not Found"** state at creation. No leg rows are written. Ops is alerted (see Use Case 8) and must resolve the configuration gap or route the order via a fallback method before it can proceed.
2. **Mapping changes mid-transit** — the DC-to-Destination or Zone-to-Hub mapping used by an order's path is deleted or changed after that order's leg rows are already `Planned` or `In Transit` → the affected leg is unaffected and continues to completion against the path resolved at order creation (per Use Case 4 and 5 state-intersection rules). Only legs not yet started are re-resolved against the updated mapping if the order has not yet reached the entity where the change applies.
3. **Duplicate scan event** — a retry of the same physical scan event is received for a leg already in `In Transit` or `Arrived` state → the write is idempotent on `(order_id, leg_sequence, leg_status)`; no duplicate row is created.
4. **Path unresolved beyond threshold** — an order remains in "Mid-Mile Path Not Found" for longer than a defined window → escalated to Central Logistics for manual routing decision (hold vs. fallback courier). **Open item:** exact escalation window to be confirmed with Ops before launch; DMS M6's equivalent (Zone Not Found / Parked order escalation) uses a 2-hour pre-cutoff and 3-day hold pattern as a reference point.

---

### Use Case 7: Reverse Flow Setup

**Scope note:** What triggers a reverse order (RTO, customer return, quality hold, etc.) is owned by existing OMS/reverse-logistics flows and is out of scope here. This use case defines only how a reverse order, once triggered, is routed through the mid-mile entities defined in this PRD.

Reverse (RTO / return) orders move backward through the same network — Hub → DC → WH — using the DC-to-WH/DC mappings established in Use Case 4. Reverse paths are **not assumed to be symmetric** with forward paths: a mapping must be explicitly marked `Reverse` or `Bidirectional` (Use Case 4) to be usable in this direction. A `Forward`-only mapping does not imply a valid return path.

**Happy path:** When a reverse order originates at a Hub, the system looks up DC-to-WH/DC mappings on the reverse path filtered to `Mapping Direction` ∈ {Reverse, Bidirectional}. Leg rows are written to `mid_mile_order_leg_log` (Use Case 6) with `direction = Reverse`, one per hop back to a terminal WH.

**Edge cases:**

1. **No reverse mapping configured** — a DC on the reverse path has only `Forward` mappings and no `Reverse`/`Bidirectional` counterpart → the reverse order is held at that DC. Ops is alerted (Use Case 8) to configure a reverse-eligible mapping before the return can proceed. This mirrors the DMS M2 requirement that DC-serving hubs explicitly configure a return path to their Mother Hub — reverse connectivity is never inferred.
2. **Forward-side config changed after original delivery** — the Zone-to-Hub mapping (Use Case 5) used on the original forward delivery has since been deleted or changed, and a return is now initiated for that order → the reverse path is resolved using the Hub ID captured on the order's original forward leg log (Use Case 6), not the current Zone-to-Hub mapping. This prevents reverse flow from breaking due to unrelated forward-side configuration changes made after delivery.
3. **Partial reverse completion** — the return only travels as far as the DC (e.g., held for quality check) before continuing to the WH → each leg is independently marked `Arrived` or `Failed`. The order is not required to complete its full reverse path in one continuous movement; the next leg is initiated as a separate, later leg row.

---

### Use Case 8: Configuration Governance

**Role-based access:** All Insert/Update actions on any entity or mapping defined in this PRD follow the Authorization Matrix at the top of this document. **Delete actions carry outsized blast radius** — a single deleted DC or mapping can orphan every zone and order path routed through it — and therefore require **Maker-Checker**: the uploading user (Maker) and a second, distinct HO Central Logistics user (Checker) must both approve before a delete action commits. A delete submitted without a distinct Checker is held in a pending state and does not take effect.

**Orphan and invalid-state detection:** A daily batch job scans configuration and surfaces the following on the ops configuration dashboard:

| Condition | Meaning |
|---|---|
| Orphaned DC | DC has zero Destination mappings (forward or reverse) — Use Case 4 |
| Orphaned Zone | Zone has zero Hub mapping — Use Case 5 |
| Cyclical DC mapping | A DC-to-DC mapping chain loops back on itself without reaching a terminal WH (should be blocked at insert per Use Case 4 edge case 3; this is a backstop check) |
| Dead-end Hub | Zone resolves to a Hub whose DC has no onward mapping — path cannot terminate at a WH |
| No reverse path | A DC has Forward mappings only, with no Reverse/Bidirectional counterpart — flags upcoming Use Case 7 gaps before a return order actually needs the path |

**Audit trail:** Every entity CRUD and mapping change (Use Cases 1–5) is logged with: action type, entity type, entity/mapping IDs affected, changed fields, performing user ID, timestamp, and — for delete actions — both the Maker's and Checker's user IDs. Logs are retained for 90 days active, then archived per data retention policy.

**Change window SOP:** Delivery Zone and Zone-to-Hub changes (Use Cases 1, 2, 5) follow the same non-business-hours discipline as Locus geography changes, since they affect live order routing directly. DC and DC-mapping changes (Use Cases 3, 4) are lower order-volume-sensitive but must still avoid overlapping with an active mid-mile trip settlement window on the affected DC.

**PII:** None of the entities or mappings in this PRD carry personal data. No retention or disposal policy beyond the standard audit-log retention above is required.

---

## Metrics

| Metric | Definition | Baseline | Target | Timeframe |
|---|---|---|---|---|
| Delivery Zone Coverage | % of serviceable pincodes mapped to a Delivery Zone | 0% at launch | 100% | Before Stage 1 |
| DC Mapping Completeness | % of active DCs with at least one valid onward Destination mapped | 0% at launch | 100% | Before Stage 1 |
| Zone-Hub Mapping Completeness | % of active Delivery Zones mapped to a Hub | 0% at launch | 100% | Before Stage 1 |
| Orphaned Entity Count | # of Zones or DCs flagged by Use Case 8 orphan detection | Unknown — baseline at Stage 1 | 0 | Ongoing |
| Mid-Mile Unroutable Order Rate | % of orders entering "Mid-Mile Path Not Found" at creation | Unknown — baseline at Stage 1 | 0 after Stage 2 | Stage 2 onwards |
| Reverse Path Coverage | % of DCs with a valid Reverse/Bidirectional mapping to their WH | Unknown — baseline at Stage 1 | 100% | Stage 3 |
| Delete Actions Missing Checker Approval | # of delete attempts held pending due to no distinct Checker | Unknown — baseline at Stage 1 | Trend to 0 (indicates SOP adoption) | Ongoing |

---

## Rollout & Stage Gates

| Stage | Entry Criteria | Success Criteria | Action on Failure |
|---|---|---|---|
| Stage 1 — Config Complete | Use Cases 1–5 executed for at least 1 WH, 1 DC, 1 Hub, 1 Zone | 100% Delivery Zone Coverage, DC Mapping Completeness, and Zone-Hub Mapping Completeness for Stage 1 scope. Zero orphan flags for in-scope entities | Fix configuration gaps before any order is routed through the new entities |
| Stage 2 — Minimal Rollout | Stage 1 passed. Low order volume routed through Stage 1 scope | Zero orders enter "Mid-Mile Path Not Found". Mid-Mile Unroutable Order Rate = 0 for Stage 2 scope | Do not expand DC/Zone count until unroutable rate is verified at 0 |
| Stage 3 — Reverse Flow Enablement | Stage 2 stable | Reverse Path Coverage = 100% for Stage 2 scope. At least one live reverse order routed successfully end-to-end | Pause reverse order routing through new entities; fall back to existing reverse process until mappings are complete |
| Stage 4 — Phased Network Expansion | Stage 3 passed | All target DCs, WHs, Hubs, and Zones live. Zero orphaned entities. Delete Maker-Checker SOP observed for 100% of delete actions in the expansion window | Pause expansion. Investigate configuration gaps before proceeding |
| Stage 5 — Full | All DCs, WHs, Hubs, and Zones live | Delivery Zone Coverage, DC Mapping Completeness, Zone-Hub Mapping Completeness all at 100%. Mid-Mile Unroutable Order Rate at 0 | — |

---

## Future Scope

- Dashboard-based direct CRUD for Ops/SCM, replacing bulk-upload-only entry once entity volume and change frequency justify the investment.
- API/webhook-based real-time sync of entity and mapping changes to downstream consumers (DMS/Locus geography, mid-mile trip planning), replacing manual bulk uploads on both sides.
- Automated orphan and cycle remediation suggestions, rather than detection-only (Use Case 8).
- Dynamic mid-mile path optimization — selecting the lowest-cost or fastest DC-to-WH route when multiple valid `Bidirectional`/`Forward` mappings exist for a DC. Out of scope for v1, which assumes a single deterministic onward path per DC.
- Multi-level hierarchy support beyond WH → DC → Hub (e.g., regional consolidation hubs), if network depth increases.
- Extending the Configuration Governance Maker-Checker model (Use Case 8) from a held-pending-approval mechanism into a full in-product approval workflow, rather than a CSV re-upload by the Checker.
