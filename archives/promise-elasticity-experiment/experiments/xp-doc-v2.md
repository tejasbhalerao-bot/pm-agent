---
**Document:** Promise Elasticity Experiment
**Type:** XP Doc
**Version:** v2
**Date:** 2026-08-25
**Status:** Approved
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | 2026-08-24 | Initial draft. NFC-specific, node-catchment framing with guardrails, early stopping, decision criteria, and interaction-effects sections. |
| v2 | 2026-08-25 | Rewritten to match established house format (plain tables, terse If/Then/Because, no callout boxes). Scope narrowed: logged-in customers only (guests out), Non-SDD pincodes only, surfaces reduced to PDP/Cart/Summary. Metrics reduced to Traffic and Conversion Rate only — guardrails, early stopping rules, decision criteria, and interaction-effects sections removed. Randomisation unit changed to customer_id (device_id no longer needed with guests excluded). Power 80%, MDE 1pp, TG1/CG 50/50 with no holdout. Framework-inputs/node-coverage-radius/candidate-list-methodology content removed. Added an explicit reusability requirement: the experiment must be built so future runs (new pincode sets, new cutoff times) launch within 1 day via configuration, without an app release. |
---

# **[PRD] Promise Elasticity Experiment**

[Experiment Overview](#experiment-overview)

[Hypotheses](#hypotheses)

[Metrics](#metrics)

[Experiment Design](#experiment-design)

[Pre-requisite: Experiment Setup](#pre-requisite-experiment-setup)

[Functional Requirement](#functional-requirement)

[Instrumentation](#instrumentation)

---

## **Experiment Overview**

| **Field** | **Value** |
| :-- | :-- |
| Experiment ID | PROM-EL1 |
| Objective | Measure the effect on Traffic and Conversion Rate of displaying an accelerated delivery promise (Today/Tomorrow) instead of the system-calculated ETA, for customers in Non-SDD pincodes. |
| Universe | 100% of eligible logged-in customers in Non-SDD pincodes (50% TG1, 50% CG) |

**What this experiment is not:** This experiment changes only the *displayed* delivery promise. It does not change the actual delivery operation, courier assignment, TAT configuration, or fulfilment timeline.

**This is not a one-time experiment.** It must be built to run repeatedly — on new pincode sets, new cutoff times — with each subsequent run launchable within 1 day, without a new app release.

---

## **Hypotheses**

**Treatment Group 1 - Simulated Fast Promise**

If we display the ETA as "Today" (before cutoff) or "Tomorrow" (at/after cutoff) instead of the system-calculated ETA on PDP, Cart, and Summary for customers in Non-SDD pincodes, then Traffic and Conversion Rate will improve, because these customers are currently constrained by a slow delivery promise rather than by price, assortment, or trust.

---

## **Metrics**

| **Metric Type** | **Metric** | **Definition** | **Baseline** | **Threshold** |
| :-- | :-- | :-- | :-- | :-- |
| Success (L0) | Traffic | # of sessions from customers in Non-SDD pincodes | | |
| Success (L0) | Conversion Rate | # of users placing order / # of users landing on PDP | | |

---

## **Experiment Design**

| **Parameter** | **Value** |
| :-- | :-- |
| Customer Cohort | Logged-in customers in Non-SDD pincodes |
| Randomisation Unit | customer\_id |
| Randomisation Strategy | hash(customer\_id + "PROM-EL1") % 100 |
| Confidence | 95% |
| Power | 80% |
| MDE | 1pp |
| TG1 | 50% |
| CG | 50% |
| Experiment Duration | 2 weeks |

**Note:** Customers should be automatically assigned a variant (TG1 or CG) when they first land on PDP. This assignment should persist for subsequent sessions and app visits.

---

## **Pre-requisite: Experiment Setup**

- The experiment is run through Firebase. Firebase should have the experiment ID "PROM-EL1" configured with the following conditions:
  - Variant A: Corresponds to TG1. Set at 50% traffic.
  - Variant B: Corresponds to CG. Set at 50% traffic.
- Each variant should be mappable to each event and user in Mixpanel.
- Each variant should be mappable to a specific customer in Redshift.

---

## **Functional Requirement**

- The experiment must be applied only to eligible customer cohorts in Non-SDD pincodes.
- The system continues to calculate ETA the way it does today, for all groups, without exception.
- CG does not experience any deviation from existing behaviour.
- **Handling for TG1:**
  - On PDP, Cart, and Summary, the displayed ETA is overridden: request time before cutoff → "Today"; at/after cutoff → "Tomorrow". This is independent of what the system actually calculates.
  - The cutoff is evaluated at the time of each page load.
  - Order confirmation and tracking screens are not part of the override — they display the true system-calculated ETA, unmodified, exactly as CG.
  - Actual fulfilment, courier assignment, and delivery timeline are entirely unaffected.
- **Reusability:** The pincode set and the Today/Tomorrow cutoff time must be configurable (e.g. via a remote config or lookup table), not hardcoded, so that a new run — a different pincode set or cutoff — can be launched by updating configuration alone, within 1 day, without an app release.

---

## **Instrumentation**

- Existing events to be retained on behaviour:
  - Events: `pdp_viewed`, `cart_viewed`, `order_summary_viewed`, `app_order_placed`
  - Properties: `eta_date`, `delivery_days`, `delivery_hours`
- `experiment_name`: PROM-EL1 — part of experiment info list
- `experiment_variant`: A (TG1), B (CG)
- The experiment name and experiment variant should be available as a breakdown property on Mixpanel.
