# **[XP] ETA Framing Experiment**

## **Experiment Overview**

| **Field** | **Value** |
| :-- | :-- |
| Experiment ID | ETA-F1 |
| Objective | Measure the effect on conversion by displaying ETA as relative days ("Delivery in X–Y days") instead of an absolute date range, to test whether relative framing reduces cognitive friction and improves purchase intent. |
| Universe | 2% of eligible logged-in users at launch (1% TG1, 1% CG); scales to 10% after sanity check passes (5% TG1, 5% CG) |

**What this experiment is not:** This experiment changes only the *display format* of the delivery promise. It does not change the actual ETA calculation, courier assignment, TAT configuration, or the logic used to determine which customers are eligible to see an ETA.

---

## **Hypotheses**

**Treatment Group 1 - Relative Days Framing**

If we display ETA as relative days ("Delivery in X–Y days") instead of an absolute date range ("Delivery by DDth–DDth Month") on the Order Summary screen, then the conversion rate (Summary → Order Placed) will improve by ~1pp, because the relative framing maps directly to the customer's mental model of stock depletion urgency rather than a calendar anchor, reducing the cognitive effort required to decide whether delivery will arrive in time.

---

## **Metrics**

| **Metric Type** | **Metric** | **Definition** | **Baseline** | **Threshold** |
| :-- | :-- | :-- | :-- | :-- |
| Success (L0) | Conversion Rate (Summary → Order Placed) | \# of users placing order / \# of users landing on Summary | | |
| Guardrail | Summary Bounce Rate | % of users not moving from Summary to Order Placed | | |
| | Fulfilment Rate | Orders Delivered / Orders Placed | | |

---

## **Experiment Design**

| **Parameter** | **Value** |
| :-- | :-- |
| Customer Cohort | Logged-in customers |
| Randomisation Unit | customer\_id |
| Randomisation Strategy | hash(customer\_id + "ETA-F1") % 100 |
| Confidence | 95% |
| Power | 80% |
| MDE | 1pp |
| TG1 | 1% (sanity); scales to 5% after sanity passes |
| CG | 1% (sanity); scales to 5% after sanity passes |
| Holdout | 98% (sanity); 90% after scale |
| Experiment Duration | 2 weeks |

**Note:** Customers should be automatically assigned a variant when they first visit the Order Summary page. This assignment should persist for subsequent sessions and app visits.

---

## **Pre-requisite: Experiment Setup**

- The experiment is run through Firebase. Firebase should have the experiment ID "ETA-F1" configured with the following conditions:
  - Variant A: Corresponds to TG1. Set at 1% traffic at launch; increase to 5% after sanity check passes.
  - Variant B: Corresponds to CG. Set at 1% traffic at launch; increase to 5% after sanity check passes.
  - Variant C: Corresponds to Holdout. Set at 98% traffic at launch; 90% after scale.
- Each variant should be mappable to each event and user in Mixpanel.
- Each variant should be mappable to a specific customer in Redshift.

---

## **Functional Requirement**

- The system continues to calculate ETA the way it does today.
- Holdout and CG do not experience any deviation from existing behaviour.
- Handling for CG:
  - Customers continue to see the absolute date range format: "Delivery by DDth–DDth Month" on the Order Summary screen.
- Handling for TG1:
  - On the Order Summary screen, customers should see the relative days format: "Delivery in X–Y days".
  - X and Y follow the display mapping below. The underlying ETA window calculated by the system does not change; only the display format changes.

| Days between today and promised delivery | Current system display | TG1 display copy |
| :-- | :-- | :-- |
| 1 day | Single date | Out of scope (Today / Tomorrow — see note below) |
| 2–3 days | 2-day range | "Delivery in 1–2 days" |
| 4–5 days | 3-day range | To be confirmed with engineering |
| 6–7 days | 4-day range | "Delivery in 2–4 days" |
| More than 7 days | 5-day range | To be confirmed with engineering |

**Note:** This experiment is applicable only if the ETA being shown is not "Delivery by Today" / "Delivery by Tomorrow". For Today and Tomorrow ETAs, existing copy is retained for all groups including TG1.

**Note:** The "Delivery in X–Y days" nomenclature must be continued in the post-order-placed journey as well (e.g., order confirmation screen, order tracking screen). The relative framing should be consistent end-to-end and not revert to absolute dates after the order is placed.

---

## **Instrumentation**

- Existing events to be retained with no change in behaviour:
  - Events: `cart_viewed`, `pdp_viewed`, `order_summary_viewed`, `app_order_placed`
  - Properties: `eta_date`, `delivery_days`, `delivery_hours`
- `experiment_name`: Part of experiment info list
- `experiment_variant`: A, B, C
- The experiment name and experiment variant should be available as a breakdown property on Mixpanel.
