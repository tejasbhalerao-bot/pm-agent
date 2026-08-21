# **[XP] ETA Framing Experiment**

## **Experiment Overview**

| **Field** | **Value** |
| :-- | :-- |
| Experiment ID | ETA-F1 |
| Objective | Measure the effect on conversion by displaying ETA as relative days ("Arrives in X–Y days") instead of an absolute date range, to test whether relative framing reduces cognitive friction and improves purchase intent. |
| Universe | 40% of eligible logged-in users |

**What this experiment is not:** This experiment changes only the *display format* of the delivery promise. It does not change the actual ETA calculation, courier assignment, TAT configuration, or the logic used to determine which customers are eligible to see an ETA.

---

## **Hypotheses**

**Treatment Group 1 - Relative Days Framing**

If we display ETA as relative days ("Arrives in X–Y days") instead of an absolute date range ("Delivery by DDth–DDth Month"), then the overall conversion rate (PDP → Order Placed) will improve by ~1pp, because the relative framing maps directly to the customer's mental model of stock depletion urgency rather than a calendar anchor, reducing the cognitive effort required to assess whether delivery will arrive in time.

---

## **Metrics**

| **Metric Type** | **Metric** | **Definition** | **Baseline** | **Threshold** |
| :-- | :-- | :-- | :-- | :-- |
| Success (L0) | Conversion Rate (PDP → Order Placed) | \# of users placing order / \# of users landing on PDP | | |
| Success (L1) | Conversion Rate (Summary → Order Placed) | \# of users placing order / \# of users landing on Summary | | |
| | Conversion Rate (Cart → Summary) | \# of users landing on Summary / \# of users landing on Cart | | |
| | Conversion Rate (PDP → Add to Cart) | \# of users performing Add to Cart / \# of users landing on PDP | | |
| Guardrail | PDP Bounce Rate | % of PDP sessions where Add to Cart did not happen | | |
| | Cart Bounce Rate | % of users not moving from Cart to Summary | | |
| | Summary Bounce Rate | % of users not moving from Summary to Order Placed | | |
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
| TG1 | 20% |
| CG | 20% |
| Holdout | 60% |
| Experiment Duration | 2 weeks |

**Note:** Customers should be automatically assigned a variant when they first land on the PDP. This assignment should persist for subsequent sessions and app visits.

**Note:** The experiment should be made live only for customers visiting the app. This experiment should not be exposed to users on the website.

**Group Allocation Strategy:**

- TG1 = hash(customer\_id + "ETA-F1") % 100 ε [00–19]
- CG = hash(customer\_id + "ETA-F1") % 100 ε [20–39]
- Holdout = hash(customer\_id + "ETA-F1") % 100 ε [40–99]

---

## **Pre-requisite: Experiment Setup**

- The experiment is run through Firebase. Firebase should have the experiment ID "ETA-F1" configured with the following conditions:
  - Variant A: Corresponds to TG1. Set at 20% traffic.
  - Variant B: Corresponds to CG. Set at 20% traffic.
  - Variant C: Corresponds to Holdout. Set at 60% traffic.
- Each variant should be mappable to each event and user in Mixpanel.
- Each variant should be mappable to a specific customer in Redshift.

---

## **Functional Requirement**

- The experiment must be applied to eligible customer cohorts only if ETA is calculated as <= 5 days.
- The system continues to calculate ETA the way it does today.
- Holdout and CG do not experience any deviation from existing behaviour.
- Handling for CG:
  - Customers continue to see the absolute date range format: "Delivery by DDth–DDth Month".
  - This applies on PDP, Cart, and Summary screens.
- Handling for TG1:
  - Wherever ETA is currently displayed (PDP, Cart, Summary), customers should instead see the relative days format: "Arrives in X–Y days".
  - X and Y are derived from the same ETA window already calculated by the system; only the display format changes.
  - This applies across all ETA types: Today / Tomorrow as well as non Today / Tomorrow ETAs.

**Note:** For Today and Tomorrow ETAs in TG1, the copy should read "Arrives Today" and "Arrives Tomorrow" respectively — preserving the urgency signal while keeping the format consistent with the relative framing direction.

---

## **Instrumentation**

- Existing events to be retained with no change in behaviour:
  - Events: `cart_viewed`, `pdp_viewed`, `order_summary_viewed`, `app_order_placed`
  - Properties: `eta_date`, `delivery_days`, `delivery_hours`
- New property to be added: `eta_display_format` — values: `absolute_date_range` (CG/Holdout), `relative_days` (TG1)
- `experiment_name`: Part of experiment info list
- `experiment_variant`: A, B, C
- The experiment name and experiment variant should be available as a breakdown property on Mixpanel.
