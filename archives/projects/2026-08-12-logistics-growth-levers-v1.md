# Logistics Growth Levers: Promise & On-Time Delivery

**Date:** 2026-08-12 | **Author:** Tejas Bhalerao | **Status:** Draft v3

---

## Objective

Two things determine whether logistics drives or destroys growth:

- **Promise** — the ETA shown at checkout. Tighter promise → higher conversion.
- **OTD** — whether we deliver by that date. Broken promise → RTO, refunds, churn.

A third layer — **customer perception** — sits above both and is parked for later.

---

## Section 1: Promise

| # | Lever | Priority | Effort | Rationale |
|---|---|---|---|---|
| 1.1 | Buffer optimization | P1 | Low | Fastest win. Static buffers are set once and never revisited — data-driven tightening requires no ops change. Separate static (hardcoded) from dynamic (capacity-signal-driven). |
| 1.2 | Dispatch waves | P1 | Medium | The dispatch window an order falls into directly determines the promise date. Poorly calibrated cut-offs over-promise (OTD breach) or under-promise (lost conversion). Evening order volume in e-pharma is significant. |
| 1.3 | Serviceability | P1 | Low | Which pincodes we can serve and by which couriers is the foundation of promise. Stale data means lost orders (un-serviceable when we can serve) or guaranteed RTOs (serviceable when we can't). |
| 1.4 | Outlier investigation | P2 | Medium | Orders >4 days inflate buffers and damage CX. Root-cause segmentation (courier × pincode × DoW) informs buffer calibration and feeds network design decisions. |
| 1.5 | SDD expansion | P2 | High | SDD is a step-change in conversion, not an incremental improvement. *(In flight — SDD Expansion Strategy project.)* |
| 1.6 | Courier network design | P3 | High | Hub density and inter-hub routing set the floor on transit time. No operational fix goes below it. Raise in courier QBRs using outlier investigation findings. |

---

## Section 2: On-Time Delivery

OTD is an execution metric. The core driver is **first-attempt delivery success** — NDR is its inverse. Levers are ordered by where in the delivery chain they act.

| # | Lever | Priority | Effort | Rationale |
|---|---|---|---|---|
| 2.1 | WH & dispatch OTD | P1 | Low | Covers two upstream handoffs: warehouse order-to-dispatch time and courier pickup SLA. Delays here cascade into OTD failures regardless of courier performance downstream. |
| 2.2 | Courier selection intelligence | P1 | Medium | Route to the courier most likely to deliver on first attempt by pincode cluster — scored on P50/P90 transit time, first-attempt rate, and NDR rate. Data already exists in courier logs. |
| 2.3 | Address quality | P2 | Medium | ~15–25% of NDR in e-commerce. Three layers: checkout validation (prevent) → pre-delivery outreach for flagged addresses (intercept) → post-NDR address correction (recover). |
| 2.4 | Customer availability & intent | P2 | High | Identify signals predicting unavailability or low intent — time of day, historical patterns, payment mode — and act before the attempt fails. Downstream fix is slot selection; upstream fix is smarter DE scheduling. |
| 2.5 | DE behaviour | P2 | Medium | Covers both behavioural failures (missed attempts, incorrect refusals) and fraud (fake attempts). Signals: NDR reason codes, complaint rate, geo-validation of attempt events. Mechanism is partner accountability via DE scorecards in QBRs. |

---

## Priority Summary

| P1 — Act now | P2 — Plan and sequence | P3 — Long lead |
|---|---|---|
| Buffer optimization | Outlier investigation | Courier network design |
| Dispatch waves | SDD expansion *(in flight)* | |
| Serviceability | Address quality | |
| WH & dispatch OTD | Customer availability & intent | |
| Courier selection intelligence | DE behaviour | |

**Next step:** Validate P1 levers against current data — buffer sizes, dispatch wave cut-offs, serviceability gaps, pickup miss rate — to size opportunity before execution.
