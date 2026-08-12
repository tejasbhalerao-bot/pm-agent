# Logistics Growth Levers: Promise & On-Time Delivery

**Date:** 2026-08-12 | **Author:** Tejas Bhalerao | **Status:** Draft v1

---

## Objective

Two things determine whether logistics drives or destroys growth:

- **Promise** — the ETA shown at checkout. Tighter promise → higher conversion.
- **OTD** — whether we deliver by that date. Broken promise → RTO, refunds, churn.

A third layer — **customer perception** — sits above both and is addressed in Section 3.

---

## Section 1: Promise

| # | Lever | Priority | Effort | Rationale |
|---|---|---|---|---|
| 1.1 | Buffer optimization | P1 | Low | Fastest win. Static buffers are set once and never revisited — data-driven tightening requires no ops change. |
| 1.2 | Carrier selection intelligence | P1 | Medium | Most selection is cost-optimised. Switching to ETA reliability as the primary signal is a promise and OTD lever simultaneously. Data already exists in courier logs. |
| 1.3 | Pincode serviceability hygiene | P1 | Low | Stale serviceability data means lost orders (un-serviceable when we can serve) or guaranteed RTOs (serviceable when we can't). Low effort, high risk if ignored. |
| 1.4 | Order cut-off time logic | P2 | Medium | Poorly calibrated cut-offs over-promise (OTD breach) or under-promise (lost conversion). Evening order volume in e-pharma is significant — worth auditing and tightening with ops. |
| 1.5 | Courier outlier investigation | P2 | Medium | Orders >4 days inflate buffers and damage CX. Root-cause segmentation (courier × pincode × DoW) informs 1.1 and 1.2. Should run in parallel with P1 work. |
| 1.6 | SDD expansion | P2 | High | SDD is a step-change in conversion, not an incremental improvement. *(In flight — SDD Expansion Strategy project.)* |
| 1.7 | Inventory positioning across FCs | P2 | High | Right SKU at the wrong FC adds transit days. For SDD, it's binary — wrong node means SDD can't be promised at all. Cross-team dependency (supply chain), but logistics must advocate for it. |
| 1.8 | Courier network design | P3 | High | Hub density and inter-hub routing set the floor on transit time. No operational fix goes below this floor. Long-lead, partner-negotiation territory — raise in QBRs off outlier findings. |
| 1.9 | Holiday / peak calendar integration | P3 | Low | Promise failures on holidays are fully predictable. One-time build, annual maintenance. High visibility when it goes wrong. |

**Key distinction for 1.1:** Separate *static buffers* (hardcoded, should be data-derived) from *dynamic buffers* (should respond to real-time capacity signals — peak season, weather, strikes).

---

## Section 2: On-Time Delivery

OTD is an execution metric. The core driver is **first-attempt delivery success** — NDR is its inverse. Levers are ordered by where in the delivery chain they act.

| # | Lever | Priority | Effort | Rationale |
|---|---|---|---|---|
| 2.1 | Pickup SLA monitoring | P1 | Low | First handoff, most invisible. A missed pickup cascades into 50–100 late deliveries. Most OTD analysis starts from dispatch — this gap hides real causes. |
| 2.2 | OFD communication | P1 | Low | Proactive "out for delivery + time window" alerts directly reduce genuine-unavailability NDR. Also a perception lever. Both jobs in one. |
| 2.3 | Fake attempt detection | P1 | Medium | DEs marking "attempted" without going = fraud, not operational failure. Fix: geo-validate attempt events against delivery address. Requires courier partner data cooperation. |
| 2.4 | Internal allocation reliability | P2 | High | Upstream failure — wrong FC assigned or dispatch not triggered. A perfect courier cannot recover an order that left late. *(In flight — separate thread.)* |
| 2.5 | NDR: Address quality | P2 | Medium | ~15–25% of NDR in e-commerce. Three layers: checkout validation (prevent) → pre-delivery outreach for flagged addresses (intercept) → post-NDR address correction flow (recover). |
| 2.6 | NDR: Genuine unavailability — slot selection | P2 | High | Letting customers pick a delivery window (morning / afternoon / evening) is the structural fix. First-attempt success on slot-selected deliveries is significantly higher. Requires courier routing integration. |
| 2.7 | NDR: Intent-based — COD mix | P2 | High | COD NDR runs 2–4x prepaid. Mix shift is the lever: prepaid discount, "pay on app" in OFD alert, UPI QR at door. Requires finance alignment on discount economics. |
| 2.8 | NDR: DE behavioural issues | P2 | Medium | Distinct from fake attempts. Signals: NDR reason codes, complaint rate, reattempt success rate. Mechanism is partner accountability — share DE scorecards in QBRs. |
| 2.9 | Warehouse processing time | P3 | Medium | Order-to-dispatch delays push orders past pickup windows. Primarily an ops problem, but logistics should own the metric and escalation path. |

---

## Section 3: Customer Perception

Metrics and perception diverge. A 2-hour-late delivery with proactive communication feels better than an on-time delivery with zero updates.

| Area | What matters |
|---|---|
| **Promise thresholds** | Delivery speed is perceived in bands, not linearly — SDD vs NDD vs 2-day vs 3-day+ are qualitatively different. Invest in crossing thresholds, not incrementally improving within one. Validate where these thresholds sit by category (chronic vs acute vs OTC). |
| **Communication cadence** | Two distinct jobs: reduce anxiety (is it coming?) and enable action (be home, prepare cash). Own every moment: confirmed → dispatched → OFD → delivered. NDR communication is typically courier-default and generic — owning it is a differentiator. |
| **Post-failure experience** | A missed delivery with clear reattempt timeline + easy reschedule preserves trust. Silence followed by a generic SMS destroys it. Define the post-NDR flow; don't inherit the courier's. |
| **Live tracking** | Reduces WISMO contacts. Native tracking (in-app) is preferable to redirecting to courier pages. Audit current fidelity — stale tracking status is often worse than no tracking. |

---

## Priority Summary

| P1 — Act now | P2 — Plan and sequence | P3 — Long lead |
|---|---|---|
| Buffer optimization | Order cut-off time logic | Courier network design |
| Carrier selection intelligence | Courier outlier investigation | Holiday/peak calendar integration |
| Pincode serviceability hygiene | SDD expansion *(in flight)* | Warehouse processing time |
| Pickup SLA monitoring | Inventory positioning | |
| OFD communication | Internal allocation reliability *(in flight)* | |
| Fake attempt detection | NDR: Address quality | |
| | NDR: Genuine unavailability — slot selection | |
| | NDR: Intent-based — COD mix | |
| | NDR: DE behavioural issues | |

**Next step:** Validate P1 levers against current data — buffer sizes, carrier SLA by pincode cluster, pickup miss rate — to size opportunity before execution.
