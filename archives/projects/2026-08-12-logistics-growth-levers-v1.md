# Logistics Annual Operating Plan — FY2026

**Date:** 2026-08-12 | **Author:** Tejas Bhalerao | **Status:** Draft v9

> Baselines and targets to be confirmed against FY2025 actuals.

---

## Objective

Logistics contributes to growth across four dimensions:

- **Promise** — the ETA shown at checkout. Tighter and accurate promise → higher conversion. A tight promise that can't be kept is net negative.
- **OTD** — whether we deliver by the promised date. Reflects both execution quality and whether the promise itself was realistic and achievable in the first place.
- **Delivery Experience** — how the customer feels about the delivery, encompassing everything from communication to the moment the parcel is in their hands.
- **Cost** — logistics cost per order as a direct lever on margins.

---

## FY2026 Commitments

| Focus Area | Headline Metric | Baseline | Target |
|---|---|---|---|
| Promise | Promise accuracy % | — | — |
| On-Time Delivery | On-time delivery rate % | — | — |
| Delivery Experience | Delivery CSAT | — | — |
| Cost | Logistics cost as % of GMV | — | — |

---

## Section 1: Promise

| Lever | Rationale | Metric | Baseline | Target | Time Horizon | Interventions |
|---|---|---|---|---|---|---|
| SDD Expansion | High-traffic, low-conversion pincodes where customers want speed and competitors are ahead are the highest-leverage SDD targets. | Conversion rate;<br>average promise | — | — | H1 → H2 | • Competitor ETA intelligence platform<br>• Promise elasticity experiment |
| SDD Cutoff Rationalisation | Wave count and timing sets the fastest SDD promise we can quote — rationalising cutoffs against competitive benchmarks maximises speed. | Average promise;<br>actual speed of delivery | — | — | H1 | • Competitor ETA intelligence platform |
| Ideal and Consistent ETA | The promise shown must match customer expectations, competitive positioning, and supply capability — a gap on any one loses conversion. | Conversion rate;<br>promise accuracy % | — | — | H2 | • Competitor ETA intelligence platform<br>• Promise elasticity experiment |
| Network Optimisation | Optimal warehouse assignment for each order minimises pickup-to-delivery time and directly tightens promise. | Average promise | — | — | H1 | • ClickPost PBA data<br>• Outlier investigation |
| Network Expansion | Order distribution data and competitive benchmarks reveal where new FCs or last-mile hubs would close the biggest promise gaps. | Average promise | — | — | H2 onwards | • Competitor ETA intelligence platform<br>• Promise elasticity experiment |
| Serviceability | Two failures: not serving pincodes we should, and not communicating when coverage is lost — both cause silent drop-off. | Pincode coverage %;<br>conversion rate | — | — | H2 onwards | • Non-serviceable request capture<br>• Competitor ETA intelligence platform<br>• Serviceability loss communication |

---

## Section 2: On-Time Delivery

OTD is an execution metric. The core driver is first-attempt delivery success — NDR is its inverse.

| Lever | Rationale | Metric | Baseline | Target | Time Horizon | Interventions |
|---|---|---|---|---|---|---|
| WH & Dispatch OTD | Pickup misses, late dispatches, and early dispatches all cause OTD failures before the courier is ever involved. | Order-to-dispatch TAT;<br>pickup SLA compliance % | — | — | Q1 | • Modular payment pending flow<br>• Courier reallocation at WH fulfillment<br>• Context-aware allocation post OP *(hypothesis)* |
| Courier Selection Intelligence | Route each order to the courier with the highest on-time rate for that lane — reliability, not cost, is the primary selection criterion. | First-attempt delivery rate;<br>courier on-time rate by lane | — | — | H1 | • Performance-based speed calculation<br>• Serviceability check at soft allocation<br>• Thin lane fallback design<br>• On-time parameter in allocation |
| Address Quality | Bad addresses cause delivery failures that neither the courier nor the customer can resolve at the door. Fix upstream, not after failure. | First attempt delivery success % | — | — | H1 → H2 | • Address flow improvement<br>• Poor address migration<br>• Delivered location capture (lat/long)<br>• DMS integration *(SDD only)* |
| Customer Availability & Intent | A meaningful share of NDR exists simply because the customer didn't know delivery was coming. Acting on availability signals before the attempt prevents avoidable failures. | First attempt delivery success % | — | — | H1 → H2 | • Communication revamp (IVR, SMS, WhatsApp, in-app)<br>• Slot selection (SDD) / day selection (non-SDD) |
| DE Behaviour | Fake attempts and behavioural failures inflate NDR and are invisible without instrumentation — but can only be acted on once address quality is reliable. | First attempt delivery success % | — | — | H1 | • Geo-validated attempt detection *(post address quality improvement)*<br>• DE performance scorecard |

---

## Section 3: Delivery Experience

Delivery experience is broader than OTD. Being on time is necessary but not sufficient — a customer can receive an order on time and still have a poor experience.

| Lever | Rationale | Metric | Baseline | Target | Time Horizon | Interventions |
|---|---|---|---|---|---|---|
| Delivery Milestone Communication | Gaps in the update chain generate WISMO contacts and anxiety. The OFD notification with a time window is the most critical moment — it enables the customer to be available. | Notification coverage rate;<br>WISMO contact rate | — | — | Q1–Q2 | • End-to-end notification ownership<br>• Channel optimisation by segment |
| Communication Quality & Channel | Sending a message is not the same as communicating. Channel, language, and actionability determine whether communication actually changes customer behaviour. | Engagement rate on delivery notifications | — | — | H1 | • Actionable notification redesign<br>• Channel mix A/B testing |
| Delay & Exception Communication | Most logistics failures that generate complaints are ones where the customer found out on their own. Proactive outreach turns a trust breakdown into managed disappointment. | % delays proactively communicated before customer contacts support | — | — | H1 | • Delay detection and proactive outreach<br>• NDR communication ownership |
| Last-Mile Handover Experience | The handover is the only face-to-face moment between the customer and TrueMeds. A poor experience drives negative perception even for on-time deliveries. | Digital POD rate;<br>handover complaint rate | — | — | H1–H2 | • OTP-based digital POD<br>• Flexible handover options |
| Parcel Condition at Delivery | A damaged or tampered parcel is a trust failure regardless of delivery speed — especially critical for medicines where condition directly affects safety perception. | Damage and tamper complaint rate | — | — | H1 | • Tamper-evidence packaging<br>• Courier damage tracking |
| Post-Failure Recovery | How quickly and easily a customer gets resolution after a failure determines whether they churn. Owning this moment rather than leaving it to courier defaults is a retention lever. | Post-failure CSAT;<br>recovery rate within SLA | — | — | H2 | • Post-NDR recovery flow<br>• Goodwill framework |

---

## Section 4: Cost

Logistics cost per order flows directly into margin. Cost inefficiencies — RTO, reattempts, split shipments — are symptoms of failures in Promise and OTD, so fixing delivery quality and improving margins are often the same work.

| Lever | Rationale | Metric | Baseline | Target | Time Horizon | Interventions |
|---|---|---|---|---|---|---|
| RTO Reduction | Every RTO carries a double cost: forward logistics + return logistics + processing. Reducing RTO is simultaneously a cost and a revenue lever — every recovered delivery is a sale that stays. | RTO rate %;<br>RTO cost per order | — | — | H1 → H2 | • RTO root cause analysis<br>• High-risk COD screening |
| NDR Reattempt Cost | A failed first attempt generates a reattempt costing ~60–80% of the original delivery. The OTD levers and cost levers are the same interventions — cost savings are a by-product of fixing delivery. | Reattempt rate;<br>cost per reattempt | — | — | H1–H2 | • OTD-led reattempt reduction<br>• Customer-confirmed reattempt slots |
| Courier Rate Optimisation | Performance-backed negotiation is more defensible than pure volume negotiation. Partners with poor OTD should not command the same rates as high performers. | Cost per delivery by courier | — | — | H2 | • Performance-backed rate negotiation<br>• SLA breach penalty enforcement |
| Packaging Optimisation | Right-sizing packaging reduces material cost and dimensional weight charges from couriers. Damage rate is the hard constraint — cost cannot be reduced at its expense. | Packaging cost per order;<br>damage rate (must not degrade) | — | — | H2 | • Right-sizing pilot<br>• Damage rate guardrail |
| COD Remittance Cycle | Cash collected from COD orders sitting with courier partners is a working capital drag — typically 7–10 day cycles on high COD volume. | Remittance days outstanding | — | — | H2 | • Remittance cadence renegotiation<br>• UPI-at-door pilot |
| Split Shipment Reduction | Orders fulfilled from multiple nodes incur multiple shipment costs. Logistics should quantify the drag and advocate for inventory positioning decisions that reduce splits. | Split shipment rate;<br>incremental cost per split | — | — | H2 | • Split shipment cost quantification<br>• Supply chain inventory positioning advocacy |

---

## Execution Phasing

| | H1 | H2 |
|---|---|---|
| **Promise** | SDD expansion, SDD cutoff rationalisation, Ideal and consistent ETA, Network optimisation, Serviceability | Network expansion planning |
| **OTD** | WH & dispatch OTD, Courier selection intelligence, OFD alerts, DE behaviour | Address quality full stack, Slot selection |
| **Delivery Experience** | Milestone communication, Communication quality, Delay alerts, Parcel condition | Last-mile handover, Post-failure recovery |
| **Cost** | RTO root cause analysis, NDR reattempt reduction | Courier rate renegotiation, Packaging, COD remittance, Split shipment tracking |
