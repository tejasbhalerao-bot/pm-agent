---
**Document:** Mid-Mile Entity — Alert Spec
**Type:** Alert Spec (companion to PRD)
**Version:** v1
**Date:** 2026-09-15
**Status:** Approved
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-09-15 | Initial draft. Derived from [Mid-Mile Entity Introduction](mid-mile-entity-introduction-v1.md) (Use Cases 1–6, current Google Doc version), styled on [DMS M8 Alert Spec](../../dms/prds/m8-alerts-v2.md). |
---

# Mid-Mile Entity — Alert Spec

**Scope:** Use Cases 1–6 of the Mid-Mile Entity Introduction PRD.
**Definition:** Alert = deviation from desired operating behaviour. Not error logs — actionable signals to a human.
**Source PRD:** [Mid-Mile Entity Introduction](https://docs.google.com/document/d/1hETlNLEX0ngk5SjI5tTJ5d_T2IQVuirsTGPv0E3CwMg/edit) (Google Doc, current version as of 2026-09-15).

---

## A1 — Delivery Zone (UC1)

| # | Alert | Trigger | Severity |
|---|---|---|---|
| A1.1 | Zone deleted with live pincode mappings | Zone deleted while ≥1 Pincode→Zone mapping (UC2) still references it | P0 |
| A1.2 | Zone deleted with live hub mapping | Zone deleted while a Zone→Hub mapping (UC5) still references it | P0 |
| A1.3 | Duplicate zone identity | Two zones share the same Zone Name or the same Zone Alias | P1 |
| A1.4 | Zone Alias rule violated | Alias inserted that isn't exactly 3 letters (validation bypass) | P1 |
| A1.5 | Zone "repaired" but mappings still dead | A deleted zone is re-inserted under the same name, gets a new system-generated Zone ID, and old mappings (still pointing at the deleted ID) don't reattach — zone looks fine, routing is still broken | P0 |

---

## A2 — Pincode to Delivery Zone Mapping (UC2)

| # | Alert | Trigger | Severity |
|---|---|---|---|
| A2.1 | Pincode mapped to multiple zones | A pincode has more than one active zone mapping (concurrent uploads racing past the single-zone insert check) | P0 |
| A2.2 | Serviceable pincode unmapped | Pincode is live/serviceable with zero zone mapping | P0 |
| A2.3 | Mapping references a deleted zone | Pincode→Zone mapping still active after the zone itself was deleted (see A1.1) | P0 |
| A2.4 | Duplicate pincode in one upload | Same pincode appears twice in a single file with conflicting actions | P1 |
| A2.5 | Malformed pincode accepted | Pincode value isn't 6-digit numeric but the row wasn't rejected | P2 |
| A2.6 | Mid-mile / Serviceability mismatch | Mid-mile config treats a pincode's chain as valid, but Truemeds Serviceability has independently deactivated it | P0 |

---

## A3 — DC (UC3)

| # | Alert | Trigger | Severity |
|---|---|---|---|
| A3.1 | DC deleted while it's someone's Destination | DC deleted while still referenced as a Destination in a DC↔WH mapping (UC4) | P0 |
| A3.2 | DC deleted with live zone mapping | DC deleted while still referenced by a Zone→Hub mapping (UC5), if Hub resolves to DC | P0 |
| A3.3 | Duplicate DC identity | Two DCs share the same DC Name or the same DC Alias | P1 |
| A3.4 | DC Alias rule violated | Alias inserted that isn't exactly 3 letters | P1 |
| A3.5 | Duplicate physical location | Two DCs share the same DC Pincode or DC Address | P2 |
| A3.6 | DC's own pincode unmapped | A DC's own DC Pincode has no Delivery Zone mapping | P2 |

---

## A4 — DC ↔ WH Mapping (UC4)

| # | Alert | Trigger | Severity |
|---|---|---|---|
| A4.1 | Upstream DC broken by downstream delete | DC deleted while it's itself configured as another DC's Destination — breaks every path routed through it, not just its own | P0 |
| A4.2 | Destination WH deactivated | WH deactivated in Warehouse Master while still referenced as a Destination by ≥1 DC | P0 |
| A4.3 | DC has two active Destinations | The 1:1 DC→Destination rule is bypassed by concurrent uploads | P0 |
| A4.4 | Rejected insert not surfaced | A second-Destination insert is correctly rejected, but the uploader isn't told — Ops believes a change went live | P1 |
| A4.5 | Destination Type mismatch | An ID tagged `WH` actually belongs to an active DC, or vice versa | P1 |
| A4.6 | Cyclical mapping | DC A→DC B→…→DC A — no terminal WH; no cycle check exists today | P0 |
| A4.7 | Chain doesn't terminate in a WH | A multi-hop chain's intermediate DC has its own mapping removed — every path upstream dead-ends silently | P0 |
| A4.8 | Cross-layer cycle | A DC's own DC Pincode (UC3) sits inside a Zone (UC2) whose Hub mapping (UC5) resolves back through that same DC — invisible if you only cycle-check UC4 | P0 |

---

## A5 — Delivery Zone to Hub Mapping (UC5)

| # | Alert | Trigger | Severity |
|---|---|---|---|
| A5.1 | Orphaned zone | Zone has zero Hub mapping | P0 |
| A5.2 | Hub reference invalid | Mapping references a Hub ID that doesn't exist / has been deleted | P0 |
| A5.3 | Reassignment left zone unmapped | Delete-old-Hub + insert-new-Hub rows processed out of order in one upload | P1 |

---

## A6 — Order-Level & Reverse Flow (UC6)

| # | Alert | Trigger | Severity |
|---|---|---|---|
| A6.1 | Order allocated with no resolvable path | Order allocated to Shipsy before Zone→DC(s)→WH resolves end-to-end | P0 |
| A6.2 | Mid-flight config change, no continuity rule | A leg's mapping changes after an order has already started that leg — no stated "in-flight continues" principle | P1 |
| A6.3 | Reverse leg has no valid path | Return triggered after the forward mapping it depends on (reused per the "reverse = forward" rule) has since been deleted or changed | P0 |

---

## A7 — Cross-Cutting

| # | Alert | Trigger | Severity |
|---|---|---|---|
| A7.1 | Malformed upload file | Wrong headers/file type — unclear if rejected wholesale or partially applied | P2 |
| A7.2 | Concurrent upload conflict | Two uploads touch the same entity/mapping at once — last-write-wins, no detection | P1 |
| A7.3 | No change attribution | No `changed_by` / `changed_at` captured anywhere — every alert above is detectable but not diagnosable without this | P0 (foundational — build this first) |

---

## Summary

| Section | P0 | P1 | P2 | Total |
|---|---|---|---|---|
| A1 — Delivery Zone | 3 | 2 | 0 | 5 |
| A2 — Pincode-Zone Mapping | 4 | 1 | 1 | 6 |
| A3 — DC | 2 | 2 | 2 | 6 |
| A4 — DC↔WH Mapping | 6 | 2 | 0 | 8 |
| A5 — Zone-Hub Mapping | 2 | 1 | 0 | 3 |
| A6 — Order-Level & Reverse Flow | 2 | 1 | 0 | 3 |
| A7 — Cross-Cutting | 1 | 1 | 1 | 3 |
| **Total** | **20** | **10** | **4** | **34** |

---

## Open Questions — Not Alertable Yet

| # | Question | Affects |
|---|---|---|
| Q1 | **Path Type 2** (`WH → Delivery Zone → Pincode`, no DC) has no defined mapping mechanism. UC5 only defines Zone→Hub, and the PRD never confirms whether "Hub" can resolve to a WH ID directly. As written, no zone using Path Type 2 can be configured at all — there is nothing for an alert to check until this is resolved. | A5.1, A5.2 will misfire on every Path-Type-2 zone until closed |
| Q2 | Whether "Hub" (UC5) and "DC" (UC3/UC4) refer to the same underlying entity, or two distinct entities that happen to share the network diagram — affects A1.2, A3.2, A4.8 detection logic directly | A1.2, A3.2, A4.8 |
