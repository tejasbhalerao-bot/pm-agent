# Logistics Growth Levers: Promise & On-Time Delivery

**Date:** 2026-08-12 | **Author:** Tejas Bhalerao | **Status:** Draft v2

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
| 1.1 | Buffer optimization | P1 | Low | Fastest win. Static buffers are set once and never revisited — data-driven tightening requires no ops change. Separate static (hardcoded) from dynamic (capacity-signal-driven). |
| 1.2 | Carrier selection intelligence | P1 | Medium | Most selection is cost-optimised. Switching to ETA reliability as the primary signal is a promise and OTD lever simultaneously. Data already exists in courier logs. |
| 1.3 | Order cut-off time logic | P2 | Medium | Poorly calibrated cut-offs over-promise (OTD breach) or under-promise (lost conversion). Evening order volume in e-pharma is significant — worth auditing and tightening with ops. |
| 1.4 | Courier outlier investigation | P2 | Medium | Orders >4 days inflate buffers and damage CX. Root-cause segmentation (courier × pincode × DoW) informs 1.1, 1.2, and feeds 1.6. |
| 1.5 | SDD investigation | P2 | Medium | Understand current SDD performance — coverage gaps, SKU eligibility, pincode-level demand — before expanding. Feeds 1.6. |
| 1.6 | SDD expansion | P2 | High | SDD is a step-change in conversion, not an incremental improvement. *(In flight — SDD Expansion Strategy project.)* |
| 1.7 | Courier network design | P3 | High | Hub density and inter-hub routing set the floor on transit time. No operational fix goes below it. Long-lead, partner-negotiation territory — raise in QBRs using outlier investigation findings. |

---

## Section 2: On-Time Delivery

OTD is an execution metric. The core driver is **first-attempt delivery success** — NDR is its inverse. Levers are ordered by where in the delivery chain they act.

| # | Lever | Priority | Effort | Rationale |
|---|---|---|---|---|
| 2.1 | Pickup SLA monitoring | P1 | Low | First handoff, most invisible. A missed pickup cascades into 50–100 late deliveries. Most OTD analysis starts from dispatch — this gap hides real causes. |
| 2.2 | Carrier selection intelligence | P1 | Medium | Same scorecard as 1.2 (P50/P90 transit, first-attempt rate, NDR rate by pincode cluster) but applied to OTD: route to the courier most likely to deliver on first attempt, not just fastest ETA. |
| 2.3 | Fake attempt detection | P1 | Medium | DEs marking "attempted" without going = fraud, not operational failure. Fix: geo-validate attempt events against delivery address. Requires courier partner data cooperation. |
| 2.4 | Address quality | P2 | Medium | ~15–25% of NDR in e-commerce. Three layers: checkout validation (prevent) → pre-delivery outreach for flagged addresses (intercept) → post-NDR address correction (recover). |
| 2.5 | Customer unavailability detection | P2 | High | Identify signals that predict unavailability — time of day, historical attempt patterns, OFD response — and act before the attempt fails. Downstream fix is slot selection; upstream fix is smarter scheduling. |
| 2.6 | DE behavioural issues | P2 | Medium | Distinct from fake attempts. Signals: NDR reason codes, complaint rate, reattempt success rate. Mechanism is partner accountability — DE scorecards shared in QBRs. |
| 2.7 | Warehouse processing time | P3 | Medium | Order-to-dispatch delays push orders past pickup windows. Primarily an ops problem, but logistics should own the metric and escalation path. |

---

## Section 3: Customer Perception

Metrics and perception diverge. A 2-hour-late delivery with proactive communication feels better than an on-time delivery with zero updates.

| Area | What matters |
|---|---|
| **Promise thresholds** | Delivery speed is perceived in bands — SDD vs NDD vs 2-day vs 3-day+ are qualitatively different. Invest in crossing thresholds, not incrementally improving within one. Validate by category (chronic vs acute vs OTC). |
| **Communication cadence** | Two jobs: reduce anxiety (is it coming?) and enable action (be home, prepare cash). Own every moment: confirmed → dispatched → OFD → delivered. NDR communication is typically courier-default and generic — owning it is a differentiator. |
| **Post-failure experience** | A missed delivery with clear reattempt timeline + easy reschedule preserves trust. Silence followed by a generic SMS destroys it. Define the post-NDR flow; don't inherit the courier's. |
| **Live tracking** | Reduces WISMO contacts. Native in-app tracking is preferable to redirecting to courier pages. Stale tracking status is often worse than no tracking. |

---

## Priority Summary

| P1 — Act now | P2 — Plan and sequence | P3 — Long lead |
|---|---|---|
| Buffer optimization | Order cut-off time logic | Courier network design |
| Carrier selection intelligence | Courier outlier investigation | Warehouse processing time |
| Pickup SLA monitoring | SDD investigation | |
| Fake attempt detection | SDD expansion *(in flight)* | |
| | Address quality | |
| | Customer unavailability detection | |
| | DE behavioural issues | |

**Next step:** Validate P1 levers against current data — buffer sizes, carrier SLA by pincode cluster, pickup miss rate — to size opportunity before execution.
