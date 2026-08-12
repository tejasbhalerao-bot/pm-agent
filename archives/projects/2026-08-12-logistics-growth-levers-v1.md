# Logistics Growth Levers

**Date:** 2026-08-12 | **Author:** Tejas Bhalerao | **Status:** Draft v4

---

## Objective

Logistics contributes to growth across four dimensions:

- **Promise** — the ETA shown at checkout. Tighter and accurate promise → higher conversion. A tight promise that can't be kept is net negative.
- **OTD** — whether we deliver by the promised date. Reflects both execution quality and whether the promise itself was realistic and achievable in the first place.
- **Delivery Experience** — how the customer feels about the delivery, encompassing everything from communication to the moment the parcel is in their hands.
- **Cost** — logistics cost per order as a direct lever on margins.

---

## Section 1: Promise

| # | Lever | Rationale |
|---|---|---|
| 1.1 | SDD expansion | Identify pincodes where demand is high but conversion is low, customers are open to a faster promise, and we are behind competitors on delivery speed. These are the pincodes where offering same-day delivery will move conversion the most. *(In flight — SDD Expansion Strategy project.)* |
| 1.2 | Courier network design | Two levers in one: how we route deliveries through the existing courier network, and where we open new fulfillment centers. The closer our inventory is to the customer, the faster and cheaper it is to deliver. Both decisions determine the promise we can make to any given pincode. |
| 1.3 | Buffer optimization | Fastest operational win. Static buffers are set once and never revisited — data-driven tightening requires no ops change. Separate static (hardcoded) from dynamic (capacity-signal-driven). |
| 1.4 | Dispatch waves | The dispatch window an order falls into directly determines the promise date. Poorly calibrated cut-offs over-promise (OTD breach) or under-promise (lost conversion). Evening order volume in e-pharma is significant. |
| 1.5 | Serviceability | Which pincodes we can serve and by which couriers is the foundation of promise. Stale data means lost orders (un-serviceable when we can serve) or guaranteed RTOs (serviceable when we can't). |
| 1.6 | Outlier investigation | Orders >4 days inflate buffers and damage CX. Root-cause segmentation (courier × pincode × DoW) informs buffer calibration and feeds network design decisions. |

---

## Section 2: On-Time Delivery

OTD is an execution metric. The core driver is **first-attempt delivery success** — NDR is its inverse. Levers are ordered by where in the delivery chain they act.

| # | Lever | Rationale |
|---|---|---|
| 2.1 | WH & dispatch OTD | Covers two upstream handoffs: warehouse order-to-dispatch time and courier pickup SLA. Delays here cascade into OTD failures regardless of courier performance downstream. |
| 2.2 | Courier selection intelligence | Route to the courier most likely to deliver on first attempt by pincode cluster — scored on P50/P90 transit time, first-attempt rate, and NDR rate. Data already exists in courier logs. |
| 2.3 | Address quality | ~15–25% of NDR in e-commerce. Three layers: checkout validation (prevent) → pre-delivery outreach for flagged addresses (intercept) → post-NDR address correction (recover). |
| 2.4 | Customer availability & intent | Identify signals predicting unavailability or low intent — time of day, historical patterns, payment mode — and act before the attempt fails. Downstream fix is slot selection; upstream fix is smarter DE scheduling. |
| 2.5 | DE behaviour | Covers both behavioural failures (missed attempts, incorrect refusals) and fraud (fake attempts). Signals: NDR reason codes, complaint rate, geo-validation of attempt events. Mechanism is partner accountability via DE scorecards in QBRs. |

---

## Section 3: Delivery Experience

Delivery experience is broader than OTD. Being on time is necessary but not sufficient — a customer can receive an order on time and still have a poor experience (no updates, a rude DE, a damaged box). This section covers everything from the moment the order is dispatched to the moment the customer has the product in their hands.

| # | Lever | Rationale |
|---|---|---|
| 3.1 | Delivery milestone communication | Customers expect updates at every meaningful stage: order confirmed, dispatched, out for delivery (with time window), delivered. Gaps in this chain generate WISMO contacts and anxiety. The OFD notification with a delivery window is the most critical moment — it enables the customer to be available and reduces first-attempt failure. |
| 3.2 | Communication quality & channel | Sending a message is not the same as communicating. The right channel (SMS for low-data pincodes, WhatsApp for others, push for app users), the right language, and actionable content (one-tap reschedule, live tracking link, DE contact) determine whether the communication actually changes customer behaviour. NDR communication in particular is typically courier-generic — owning and redesigning this moment is a differentiation opportunity. |
| 3.3 | Delay & exception communication | When something goes wrong — pickup miss, transit delay, failed attempt — proactive outreach before the customer notices is the difference between managed disappointment and a trust breakdown. Most logistics failures that generate complaints are ones where the customer found out on their own. |
| 3.4 | Last-mile handover experience | The physical handover is the only moment in the entire order journey where the customer has a face-to-face interaction with TrueMeds (via the DE). This covers DE courtesy and professionalism, OTP-based digital proof of delivery, flexible handover options (leave with neighbour, security desk), and contactless delivery. A poor handover experience — even for an on-time delivery — drives negative perception and review. |
| 3.5 | Parcel condition at delivery | The customer expects to receive the product in the state they ordered it. This covers packaging adequacy (protection during transit), tamper-evidence (critical for medicines), temperature integrity for cold-chain SKUs, and pick accuracy (right product, right quantity). A damaged or tampered parcel is a trust failure regardless of how fast it arrived. |
| 3.6 | Post-failure recovery | When a delivery fails — damaged product, missed delivery, wrong item — how quickly and easily the customer gets a resolution determines whether they churn. Easy return initiation, fast replacement dispatch, and goodwill gestures for egregious failures convert a negative experience into a retention moment. The post-failure flow is currently courier-default for most players; owning it is an opportunity. |

---

## Section 4: Cost

Logistics cost per order flows directly into margin. Cost inefficiencies — RTO, reattempts, split shipments — are also symptoms of failures in Promise and OTD, so fixing delivery quality and improving margins are often the same work. Levers are ordered by their connection to customer-facing outcomes.

| # | Lever | Rationale |
|---|---|---|
| 4.1 | RTO reduction | Every RTO carries a double cost: forward logistics (paid) + return logistics + processing + inventory write-off risk. RTO rate is also a direct symptom of promise accuracy, OTD, and intent-based NDR. Reducing RTO is simultaneously a cost and a revenue lever — every recovered delivery is a sale that stays. |
| 4.2 | NDR reattempt cost | A failed first attempt generates a reattempt, which costs ~60–80% of the original delivery cost. Improving first-attempt success (via address quality, availability detection, OFD communication) is also the most direct cost lever. The OTD levers and cost levers are the same interventions — cost savings are a by-product of fixing delivery. |
| 4.3 | Courier rate optimisation | Courier contracts are negotiated on volume and SLA commitments. A courier scorecard (from 2.2) gives leverage to renegotiate — partners with poor OTD should not be paid the same as high performers. Rate optimisation backed by performance data is more defensible than pure volume negotiation. |
| 4.4 | Packaging optimisation | Right-sizing packaging to product dimensions reduces material cost and dimensional weight charges from couriers (who price on volumetric weight). Maintaining parcel integrity standards (3.5) is the constraint — packaging cost reduction cannot come at the expense of damage rates. |
| 4.5 | COD remittance cycle | Cash collected from COD orders sits with the courier partner before being remitted, typically on a 7–10 day cycle. For high COD volume, this is a working capital drag. Faster remittance cadence or digital collection (UPI at door) reduces this exposure. |
| 4.6 | Split shipment reduction | Orders fulfilled from multiple nodes incur multiple shipment costs. Better inventory positioning (ensuring high-velocity SKUs are stocked at the right FC) reduces the frequency of splits. This is a cross-team lever (supply chain owns positioning) but logistics should flag and quantify the cost impact. |

---

## Priority Summary

| P1 — Act now | P2 — Plan and sequence | P3 — Long lead |
|---|---|---|
| Buffer optimization | Outlier investigation | Courier network design |
| Dispatch waves | SDD expansion *(in flight)* | Split shipment reduction |
| Serviceability | Address quality | |
| WH & dispatch OTD | Customer availability & intent | |
| Courier selection intelligence | DE behaviour | |
| Delivery milestone communication | Last-mile handover experience | |
| Delay & exception communication | Parcel condition at delivery | |
| RTO reduction | Post-failure recovery | |
| NDR reattempt cost | Communication quality & channel | |
| | Courier rate optimisation | |
| | Packaging optimisation | |
| | COD remittance cycle | |

**Next step:** Validate P1 levers against current data — buffer sizes, dispatch wave cut-offs, serviceability gaps, pickup miss rate — to size opportunity before execution.
