---
**Document:** Promise Elasticity Experiment
**Type:** XP Doc
**Version:** v1
**Date:** 2026-08-24
**Status:** Approved
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-08-24 | Initial draft. Passed 2-pass review (7 findings fixed: sample size calc, early stopping rules, decision criteria, guardrail thresholds, statistical test type, ETA-E3/F1 interaction effects, SRM check plan). Signed off with 2 open P2s (MDE-vs-capex check, shared-device contamination risk) acknowledged, not blocking. |
---

# [PRD] Promise Elasticity Experiment

[Experiment Overview](#experiment-overview)
[Hypotheses](#hypotheses)
[Metrics](#metrics)
[Experiment Design](#experiment-design)
[Pre-requisite: Experiment Setup](#pre-requisite-experiment-setup)
[Functional Requirement](#functional-requirement)
[Instrumentation](#instrumentation)

---

## Experiment Overview

| **Field** | **Value** |
| :-- | :-- |
| Experiment ID | PROM-EL1 |
| Objective | Measure the incremental effect on conversion and traffic of displaying an accelerated ETA ("Today" / "Tomorrow") to customers in NFC-candidate catchment pincodes, irrespective of the system-calculated ETA, in order to quantify promise elasticity and inform the return assumption behind NFC site-selection investment decisions. |
| Universe | Non-SDD pincodes within 10 km of a Very-High-tier NFC recommended placement pincode (top 30 districts, per the NFC Site Selection methodology in `data-agent/archives/nano-fulfilment-centres/`). All customers in scope — first-time and repeat, logged-in and guest. |

**What this experiment is not:** This experiment does not build, open, or operationalise any Nano Fulfilment Centre. It does not change the actual ETA calculation, courier assignment, TAT configuration, or fulfilment timeline in any way. It is a presentation-layer override only — the system continues to calculate and act on the true ETA throughout; only what the customer is shown, pre-purchase, changes for the treatment group.

---

## Hypotheses

**Treatment Group 1 — Simulated Fast Promise**

If we display the ETA as "Today" (before cutoff) or "Tomorrow" (at/after cutoff) instead of the system-calculated ETA, on Home, Search Results, PDP, Cart, and Order Summary, to customers in NFC-candidate catchment pincodes, then First-Exposure Session → Order Placed conversion will improve by ~3pp, because these pincodes carry organic, unconverted demand that is currently constrained by a slow displayed promise rather than by price, assortment, or trust — and removing that constraint converts previously latent intent into orders.

**Concept Note:** The NFC Site Selection model weights conversion at 25% (inverted) on the assumption that low conversion alongside high views signals fulfilment friction rather than weak intent. That assumption has never been tested directly — this experiment is the direct test. The result recalibrates the NFC ranking from an ordinal, assumption-driven score into one grounded in a measured elasticity, and — stratified by displayed-vs-calculated ETA gap — can support a lift-per-day-of-promise curve rather than a single blended number.

---

## Metrics

| **Metric Type** | **Metric** | **Definition** | **Baseline** | **Threshold** |
| :-- | :-- | :-- | :-- | :-- |
| Success (L0) | First-Exposure Conversion Rate | Orders placed in a customer's first eligible session post-assignment / customers exposed in that first session | | |
| Success (L1) | Summary → Order Placed Conversion | Orders placed / customers reaching Order Summary | | |
| Success (L1) | Add-to-Cart Rate | Customers adding ≥1 item to cart / customers exposed | | |
| Guardrail | CS Contact Rate (WISMO) | % of placed orders generating a delivery-status support contact within the displayed promise window | | TG1 exceeds CG by > 2pp absolute → hard kill |
| Guardrail | Cancellation Rate | % of placed orders cancelled before delivery | | TG1 exceeds CG by > 2pp absolute → hard kill |
| Guardrail | Doorstep Refusal / RTO Rate | % of delivery attempts refused or returned | | TG1 exceeds CG by > 1.5pp absolute → pause & investigate |
| Guardrail | 30-Day Repeat Rate | % of first-time customers placing a second order within 30 days | | TG1 trails CG by > 3pp at 30-day mark → diagnostic flag, not gating |
| **[Qualitative]** | Cancellation Reason (Promise-Driven) | Reason-code/free-text capture on cancellation, tagged by variant, to isolate promise-driven cancellations from unrelated ones | — | — |

**Note:** CS Contact Rate and Cancellation Rate thresholds are relative to CG (not an absolute baseline) since baseline ops data for the candidate pincode set has not yet been pulled — proposed, pending ops sign-off before launch.
**Note:** 30-Day Repeat Rate and Cancellation Reason are trailing/diagnostic — too slow to gate the in-flight decision, reported at experiment close to size the promise-dependent share of any observed lift.

---

## Experiment Design

| **Parameter** | **Value** |
| :-- | :-- |
| Customer Cohort | All customers — first-time and repeat, logged-in and guest — with delivery pincode in the Promise Elasticity candidate set |
| Randomisation Unit | device\_id |
| Randomisation Strategy | hash(device\_id + "PROM-EL1") % 100 |
| Confidence | 95% |
| Power | 90% |
| MDE | 3pp (assumption — pending confirmation against the minimum lift needed to justify NFC capex; requires sign-off before lock) |
| TG1 | 5% |
| CG | 5% |
| Holdout | 90% |
| Experiment Duration | TBD — depends on baseline conversion rate and daily eligible session volume for the candidate pincode set (not yet pulled) |

**Note:** Unlike ETA-F1/ETA-E3, this experiment does not ramp sanity → scale. Given the welfare cost of a false delivery promise, TG1/CG are fixed at 5%/5% for the full run; scaling beyond this requires a fresh review checkpoint, not an automatic increase.
**Note:** device\_id is the randomisation unit, not customer\_id, because first-time/guest customers — whose elasticity is explicitly in scope — have no customer\_id at first exposure. On login/signup, the existing device\_id-based assignment is retained; customers are not re-bucketed by customer\_id. Shared-device households (e.g. a family sharing one phone) carry a residual cross-contamination risk under this scheme — acknowledged, not mitigated in v1.
**Note:** Assignment locks at the customer's first eligible session (pincode resolves into the candidate set) and persists regardless of later pincode changes.
**Note:** Today vs. Tomorrow within TG1 is not part of hash-based randomisation. It is a deterministic display rule keyed to request time relative to an empirically derived cutoff (see Functional Requirement) — it mirrors how a real SDD/NDD node would actually behave, it does not add a second experimental arm.

### Statistical Design

**Sample size (conservative bound):** Baseline conversion (p₀) for the candidate pincode set is not yet available. Using the conservative worst-case p₀ = 0.5 (maximizes variance — a mathematical upper bound, not a guess at the real value):

n = 2 × (z₀.₀₂₅ + z₀.₁₀)² × p₀(1−p₀) / MDE² = 2 × (1.96 + 1.2816)² × 0.25 / 0.03² ≈ **5,839 per variant** (TG1, CG)

This is an upper bound and will tighten once real baseline conversion is pulled (see Pre-requisite: Experiment Setup). Duration cannot be finalised until daily eligible session volume for the candidate set is known.

**Test type:** Two-proportion z-test (primary metric is a conversion rate).

### Early Stopping Rules

| Condition | Action |
| :-- | :-- |
| CS Contact Rate or Cancellation Rate breaches its guardrail threshold | Kill immediately |
| Doorstep Refusal/RTO Rate breaches its threshold | Pause and investigate |
| Primary metric regresses > 2× MDE in the wrong direction, sustained ≥ 3 days | Kill |
| Pre-registered interim analysis at 50% of target sample (Bonferroni-corrected α/2 = 0.025) | Check guardrails and futility only — not a win/loss call |
| "It's already winning," "traffic is lower than expected," "ship before sprint ends" | Not acceptable grounds to stop early |

### Decision Criteria

| Decision | Criteria |
| :-- | :-- |
| Ship | Primary metric ≥ MDE in expected direction at α = 0.05, no guardrail breached |
| Iterate | Positive but < MDE, or an L1 metric shows a meaningful signal worth exploring |
| Kill | Primary metric moves the wrong way at significance, or any guardrail breached beyond threshold |
| Inconclusive | No significance reached — extend if traffic allows, widen MDE, or kill |

Accountable for the final call within 5 business days of close: **PM + Analytics** (individual owner TBD — confirm before launch).

---

## Pre-requisite: Experiment Setup

- The experiment is run through Firebase. Firebase should have experiment ID "PROM-EL1" configured with:
  - Variant A: TG1, 5% traffic.
  - Variant B: CG, 5% traffic.
  - Variant C: Holdout, 90% traffic.
- Each variant should be mappable to each event and device/customer in Mixpanel and Redshift.
- The candidate pincode set (non-SDD pincodes within 10 km of the 30 Very-High-tier NFC placement pincodes) must be loaded as a frozen allowlist before launch, sourced from the NFC Site Selection output in `data-agent/archives/nano-fulfilment-centres/`. Mid-experiment changes to this list are not permitted — they would break eligibility integrity.
- The Today/Tomorrow cutoff time must be derived empirically from dispatch-time analysis on the same 28 dense-urban SDD hub reference class used to derive the NFC brief's 10 km radius. Do not default to a round-number cutoff without this pull.
- Baseline conversion rate and daily eligible session volume for the candidate pincode set must be pulled before sample size and duration can be locked.

**Interaction Effects:** ETA-E3's eligible population is "logged-in users with a non-Today/Tomorrow ETA" — this overlaps heavily with the Promise Elasticity candidate set, since non-SDD pincodes are precisely the ones carrying slow ETAs. Both experiments move Summary → Order Placed conversion on the same screens. **Resolution: mutual exclusion required** — customers in the PROM-EL1 candidate pincode allowlist must be excluded from ETA-E3 eligibility (and vice versa), enforced at assignment. ETA-F1 (framing) carries lower but non-zero overlap risk on the same screens; the same exclusion is recommended. No live experiments tracker was found to check for other overlaps — recommend filing one.

---

## Functional Requirement

- Eligibility is evaluated on the customer's delivery pincode at first in-scope session. Pincode in the candidate set → customer is eligible and assigned a variant.
- The system continues to calculate the true ETA exactly as it does today, for all groups, without exception.
- Holdout and CG do not experience any deviation from existing behaviour — the true system-calculated ETA is displayed everywhere, exactly as today.
- **Handling for CG and Holdout:**
  - All surfaces display ETA using existing logic, unchanged.
- **Handling for TG1:**
  - On Home, Search Results, PDP, Cart, and Order Summary, the displayed ETA is overridden:
    - Request time before cutoff → display "Today".
    - Request time at/after cutoff → display "Tomorrow".
  - This override is fully independent of what the system actually calculates for that pincode.
  - The cutoff is evaluated fresh on every page load using current server time. There is no session-level lock and no countdown/degradation UI for the transition — a customer's displayed promise can change from Today to Tomorrow within a single browsing session if it spans the cutoff. This is an accepted, explicitly out-of-scope risk for this phase.
  - Order confirmation and order tracking screens are **not** part of the override. They display the true system-calculated ETA, unmodified, exactly as CG/Holdout. The override applies only pre-purchase, at the point of the buying decision.
  - Actual fulfilment, courier assignment, and delivery timeline are entirely unaffected in all groups. No additional dispatch capacity is required to run this experiment — the risk is customer-facing (a broken promise), not operational load.
- First-time and guest customers follow the same device\_id-based assignment and display rules as returning customers.

---

## Instrumentation

- Existing events retained: `home_viewed`, `search_results_viewed`, `pdp_viewed`, `cart_viewed`, `order_summary_viewed`, `app_order_placed`, `order_cancelled`, `order_delivered`
  - Properties: `eta_date` (system-calculated, always true), `displayed_eta_date` (what the customer actually saw), `delivery_days`, `delivery_hours`
- New properties:
  - `promise_elasticity_variant`: A (TG1) / B (CG) / C (Holdout)
  - `displayed_vs_calculated_gap_days`: system-calculated ETA minus displayed ETA — supports stratifying lift by size of promise acceleration
  - `is_first_time_customer`: boolean — separates first-time vs. repeat elasticity in analysis
  - `cutoff_relative_flag`: pre-cutoff / post-cutoff at request time — supports the Today vs. Tomorrow discontinuity read
- `order_cancelled` carries a `cancellation_reason` property (reason-code or free text) so promise-driven cancellations can be isolated from unrelated ones, by variant.
- `experiment_name`: PROM-EL1 — part of experiment info list.
- `experiment_variant`: A (TG1), B (CG), C (Holdout).
- Both available as breakdown properties on Mixpanel.
- **SRM check:** performed at the pre-registered interim (50% sample) and at close, via chi-squared goodness-of-fit on device_id counts across A/B/C against the expected 5/5/90 split. p < 0.001 triggers pause pending investigation before any result is trusted.
