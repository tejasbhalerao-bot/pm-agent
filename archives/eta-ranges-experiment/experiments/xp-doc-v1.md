# [PRD] ETA Ranges Experiment

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
| Experiment ID | ETA-E3 |
| Objective | Measure the effect on Summary → Order Placed conversion of displaying a ±1 day centred ETA range on the Order Summary screen, instead of the current end-anchored range. |
| Universe | 1% of eligible logged-in users with a non Today / Tomorrow ETA (sanity); scaled to 5% post-sanity |

**What this experiment is not:** This experiment changes only the *displayed* ETA range on the Order Summary screen. It does not change the actual delivery operation, courier assignment, TAT configuration, or how ETA is calculated by the system.

---

## Hypotheses

**Treatment Group 1 — Centred ETA Range on Summary**

If we display the ETA on the Order Summary screen as a ±1 day range centred on the calculated delivery date (instead of the current end-anchored range), then the Summary to Order Placed conversion rate will improve by ~1pp, because customers receive a more honest and symmetric delivery window that reduces uncertainty-driven hesitation at the point of order confirmation.

**Concept Note:** The ±1 day buffer is grounded in operational data — 85% of dispatched orders have their first delivery attempt off by only 1 day from what the system predicted. Centering the displayed range around this variance directly sharpens the promise: the customer is shown a window that accurately reflects the real distribution of outcomes, rather than one that routinely undershoots the upper bound.

---

## Metrics

| **Metric Type** | **Metric** | **Definition** | **Baseline** | **Threshold** |
| :-- | :-- | :-- | :-- | :-- |
| Success (L0) | Conversion Rate (Summary → Order Placed) | # of users placing order / # of users landing on Summary | | |
| Guardrail | Summary Bounce Rate | % of users not moving from Summary to Order Placed | | |
| Guardrail | Fulfilment Rate | Orders Delivered / Orders Placed | | |
| **[Qualitative]** | Customer Perception of Delivery Promise | Answers the thought process of customers behind delivery promises | — | — |

---

## Experiment Design

| **Parameter** | **Value** |
| :-- | :-- |
| Customer Cohort | Logged-in customers with a non Today / Tomorrow ETA (ETA > 1 day) |
| Randomisation Unit | customer\_id |
| Randomisation Strategy | hash(customer\_id + "ETA-E3") % 100 |
| Confidence | 95% |
| Power | 80% |
| MDE | 1pp |
| TG1 | 1% (sanity) → 5% (scale) |
| CG | 1% (sanity) → 5% (scale) |
| Holdout | 98% (sanity) → 90% (scale) |
| Experiment Duration | 2 weeks |

**Note:** Customers should be automatically assigned a variant (TG1 or CG) when they first land on the Order Summary screen. This assignment should persist for subsequent sessions and app visits.

**Note:** The experiment should be made live only for customers visiting the app. This experiment should not be exposed to users on the website.

---

## Pre-requisite: Experiment Setup

- The experiment is run through Firebase. Firebase should have the experiment ID "ETA-E3" configured with the following conditions:

  - Variant A: Corresponds to TG1. Set at 1% traffic for sanity; scaled to 5% post-sanity.

  - Variant B: Corresponds to CG. Set at 1% traffic for sanity; scaled to 5% post-sanity.

  - Variant C: Corresponds to Holdout. Set at 98% traffic for sanity; scaled to 90% post-sanity.

- Each variant should be mappable to each event and user in Mixpanel.

- Each variant should be mappable to a specific customer in Redshift.

---

## Functional Requirement

- The experiment must be applied only to eligible customer cohorts where the calculated ETA is > 1 day (i.e., non Today / Tomorrow).

- The system continues to calculate ETA the way it does today.

- The system maintains the existing ETA calculation logic in full. Only the display is modified for TG1.

- Holdout and CG do not experience any deviation from existing behaviour.

- **Handling for CG and Holdout:**

  - The Order Summary screen displays the ETA using the current end-anchored range logic, unchanged.

  - Today / Tomorrow ETA continues to display as a single date for all groups.

- **Handling for TG1:**

  - When the customer lands on the Order Summary screen, the displayed ETA range must be centred on the system-calculated delivery date with a ±1 day buffer.

  - Display rule: `[calculated_date − 1 day, calculated_date + 1 day]`

  - Today / Tomorrow ETA is excluded from TG1 treatment. These customers see Today / Tomorrow as a single date, identical to CG and Holdout.

  - This treatment applies on the Order Summary screen only. PDP and Cart screens are not in scope for this experiment.

---

## Instrumentation

- Existing events to be retained on behaviour:

  - Events: `order_summary_viewed`, `app_order_placed`

  - Properties: `eta_date`, `delivery_days`, `delivery_hours`

- `experiment_name`: ETA-E3 — part of experiment info list

- `experiment_variant`: A (TG1), B (CG), C (Holdout)

- The experiment name and experiment variant should be available as a breakdown property on Mixpanel.
