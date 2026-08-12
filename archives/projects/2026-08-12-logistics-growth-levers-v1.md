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
| SDD Expansion | Pincodes with high traffic, low conversion, customer receptivity to faster delivery, and weak competitive positioning are where SDD moves the needle most. | SDD-eligible pincodes;<br>SDD conversion rate | — | — | H1 → H2 | • Build competitor ETA intelligence platform to establish competitive positioning by pincode<br>• Run experiments on SDD-candidate pincodes to measure customer receptivity and inform prioritisation |
| Courier Network Optimisation | Routing efficiency, hub throughput, and transit leg performance can be improved within the existing network without capital investment. | P90 transit time by pincode cluster | — | — | H1 | • Build transit performance visibility by route; surface bottlenecks to courier partners<br>• Drive SLA accountability for structural underperformers in QBRs |
| Network Expansion | Where we place new FCs and last-mile hubs determines how close inventory is to the customer — and therefore what promise we can make. | % pincodes within 1-day reach of an FC | — | — | H2 onwards | • Identify underserved geographies through demand mapping<br>• Drive FC feasibility assessment and infra planning for priority regions |
| Outlier Investigation | Orders >4 days are a signal, not just a metric — they reveal where the network is structurally failing. Findings feed every lever below. | % orders >4 days | — | — | Q1 | • Build outlier dashboard: courier × pincode × day-of-week<br>• Categorise root causes and drive partner escalations with SLA accountability |
| Serviceability | Stale serviceability data means lost orders where we could serve, or guaranteed RTOs where we can't. Fix before optimising how we serve. | Serviceability accuracy rate | — | — | Q1–Q2 | • Build alerting for serviceability changes before they impact orders<br>• Own partner sync cadence; correct incorrect tags from outlier findings |
| Dispatch Waves | The dispatch window an order falls into directly sets the promise date. Over-promising causes OTD breach; under-promising loses conversion. | % orders making same-day dispatch | — | — | H1 | • Audit cut-off assumptions vs actual dispatch times; identify gaps with ops<br>• Build cut-off-aware promise at checkout |
| Buffer Optimisation | Buffers calibrated on clean network data are the final tuning layer. Tightening them before fixing outliers and serviceability sets a tight promise on a broken foundation. | Promise date accuracy %;<br>buffer vs actual P90 | — | — | H2 | • Build data-driven P90 buffer model by pincode cluster to replace static configs<br>• Layer dynamic buffers responsive to real-time capacity signals |

---

## Section 2: On-Time Delivery

OTD is an execution metric. The core driver is first-attempt delivery success — NDR is its inverse.

| Lever | Rationale | Metric | Baseline | Target | Time Horizon | Interventions |
|---|---|---|---|---|---|---|
| WH & Dispatch OTD | Pickup misses and slow warehouse processing cascade into OTD failures regardless of how well the courier performs downstream. | Order-to-dispatch TAT;<br>pickup SLA compliance % | — | — | Q1 | • Instrument pickup events and order-to-dispatch TAT by courier, warehouse, and shift<br>• Build real-time alerting for same-day pickup misses |
| Courier Selection Intelligence | Selecting on cost over reliability is a false economy — poor first-attempt rates generate reattempts that cost more and break OTD. | First-attempt delivery rate;<br>courier NDR rate by pincode cluster | — | — | H1 | • Build courier scorecard by pincode cluster: P50/P90 transit, first-attempt rate, NDR rate<br>• Integrate scorecard into allocation logic to route on reliability over cost |
| Address Quality | Address errors account for ~15–25% of NDR. The goal is to fix bad addresses before the delivery attempt, not after failure. | Address-related NDR % | — | — | H1 → H2 | • Build checkout address validation using pincode-to-area lookup<br>• Pre-delivery outreach for flagged addresses; post-NDR correction flow |
| Customer Availability & Intent | A meaningful share of NDR exists simply because the customer didn't know delivery was coming. Acting on availability signals before the attempt prevents avoidable failures. | Genuine unavailability NDR % | — | — | H1 → H2 | • Build OFD alerts with estimated delivery time window<br>• Enable delivery slot selection at checkout; inform DE routing with availability patterns |
| DE Behaviour | Both behavioural failures (missed attempts, incorrect refusals) and fraud (fake attempts) inflate NDR and are invisible without instrumentation. | DE-attributed NDR %;<br>fake attempt rate | — | — | H1 | • Build geo-validation of attempt events to detect fake attempts<br>• Build DE scorecard per partner; drive accountability in monthly courier QBRs |

---

## Section 3: Delivery Experience

Delivery experience is broader than OTD. Being on time is necessary but not sufficient — a customer can receive an order on time and still have a poor experience.

| Lever | Rationale | Metric | Baseline | Target | Time Horizon | Interventions |
|---|---|---|---|---|---|---|
| Delivery Milestone Communication | Gaps in the update chain generate WISMO contacts and anxiety. The OFD notification with a time window is the most critical moment — it enables the customer to be available. | Notification coverage rate;<br>WISMO contact rate | — | — | Q1–Q2 | • Build end-to-end notification ownership: confirmed → dispatched → OFD (with window) → delivered<br>• Channel optimisation by segment: SMS, WhatsApp, push |
| Communication Quality & Channel | Sending a message is not the same as communicating. Channel, language, and actionability determine whether communication actually changes customer behaviour. | Engagement rate on delivery notifications | — | — | H1 | • Redesign templates with actionable content: reschedule, tracking, DE contact<br>• Language personalisation; A/B test channel mix by segment |
| Delay & Exception Communication | Most logistics failures that generate complaints are ones where the customer found out on their own. Proactive outreach turns a trust breakdown into managed disappointment. | % delays proactively communicated before customer contacts support | — | — | H1 | • Build delay detection via expected vs actual scan events; trigger proactive outreach<br>• Own NDR communication end-to-end |
| Last-Mile Handover Experience | The handover is the only face-to-face moment between the customer and TrueMeds. A poor experience drives negative perception even for on-time deliveries. | Digital POD rate;<br>handover complaint rate | — | — | H1–H2 | • Roll out OTP-based digital POD<br>• Define DE standards with partners; enable flexible handover options |
| Parcel Condition at Delivery | A damaged or tampered parcel is a trust failure regardless of delivery speed — especially critical for medicines where condition directly affects safety perception. | Damage and tamper complaint rate | — | — | H1 | • Implement tamper-evidence packaging for medicine categories<br>• Track damage rate by courier; surface in QBRs |
| Post-Failure Recovery | How quickly and easily a customer gets resolution after a failure determines whether they churn. Owning this moment rather than leaving it to courier defaults is a retention lever. | Post-failure CSAT;<br>recovery rate within SLA | — | — | H2 | • Own post-NDR communication and define replacement dispatch SLA<br>• Build goodwill framework for egregious failures |

---

## Section 4: Cost

Logistics cost per order flows directly into margin. Cost inefficiencies — RTO, reattempts, split shipments — are symptoms of failures in Promise and OTD, so fixing delivery quality and improving margins are often the same work.

| Lever | Rationale | Metric | Baseline | Target | Time Horizon | Interventions |
|---|---|---|---|---|---|---|
| RTO Reduction | Every RTO carries a double cost: forward logistics + return logistics + processing. Reducing RTO is simultaneously a cost and a revenue lever — every recovered delivery is a sale that stays. | RTO rate %;<br>RTO cost per order | — | — | H1 → H2 | • Root cause RTO by NDR type; prioritise highest-volume failure modes<br>• Build intent-signal screening for high-risk COD orders |
| NDR Reattempt Cost | A failed first attempt generates a reattempt costing ~60–80% of the original delivery. The OTD levers and cost levers are the same interventions — cost savings are a by-product of fixing delivery. | Reattempt rate;<br>cost per reattempt | — | — | H1–H2 | • OTD lever improvements reduce reattempts as a by-product<br>• Build customer-confirmed reattempt slots |
| Courier Rate Optimisation | Performance-backed negotiation is more defensible than pure volume negotiation. Partners with poor OTD should not command the same rates as high performers. | Cost per delivery by courier | — | — | H2 | • Use courier scorecard to back rate negotiations with performance data<br>• Enforce penalty clauses for SLA breach |
| Packaging Optimisation | Right-sizing packaging reduces material cost and dimensional weight charges from couriers. Damage rate is the hard constraint — cost cannot be reduced at its expense. | Packaging cost per order;<br>damage rate (must not degrade) | — | — | H2 | • Pilot right-sizing for low-damage-risk categories based on dimensional weight audit<br>• Hold damage rate as a hard constraint alongside cost reduction |
| COD Remittance Cycle | Cash collected from COD orders sitting with courier partners is a working capital drag — typically 7–10 day cycles on high COD volume. | Remittance days outstanding | — | — | H2 | • Renegotiate remittance cadence with partners<br>• Pilot UPI-at-door to reduce cash-in-transit |
| Split Shipment Reduction | Orders fulfilled from multiple nodes incur multiple shipment costs. Logistics should quantify the drag and advocate for inventory positioning decisions that reduce splits. | Split shipment rate;<br>incremental cost per split | — | — | H2 | • Quantify split shipment cost and flag to supply chain for inventory positioning<br>• Track as a shared metric |

---

## Execution Phasing

| | H1 | H2 |
|---|---|---|
| **Promise** | Outlier investigation, Serviceability, Dispatch waves, Courier network optimisation | Buffer optimisation, SDD expansion rollout, Network expansion planning |
| **OTD** | WH & dispatch OTD, Courier selection intelligence, OFD alerts, DE behaviour | Address quality full stack, Slot selection |
| **Delivery Experience** | Milestone communication, Communication quality, Delay alerts, Parcel condition | Last-mile handover, Post-failure recovery |
| **Cost** | RTO root cause analysis, NDR reattempt reduction | Courier rate renegotiation, Packaging, COD remittance, Split shipment tracking |
