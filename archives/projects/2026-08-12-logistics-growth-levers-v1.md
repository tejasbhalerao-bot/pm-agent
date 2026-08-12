# Logistics Annual Operating Plan — FY2026

**Date:** 2026-08-12 | **Author:** Tejas Bhalerao | **Status:** Draft v8

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

| Lever | Metric | Baseline | Target | Time Horizon | Interventions |
|---|---|---|---|---|---|
| SDD Expansion | SDD-eligible pincodes;<br>SDD conversion rate | — | — | H1 → H2 | • Score pincodes on traffic × conversion gap × customer receptivity × competitive positioning<br>• Map SKU eligibility for SDD<br>• Assess dark store readiness per priority pincode |
| Courier Network Optimisation | P90 transit time by pincode cluster | — | — | H1 | • Analyse transit leg performance by route to identify bottlenecks<br>• Benchmark hub throughput across courier partners<br>• Escalate structural bottleneck routes in courier QBRs |
| Network Expansion | % pincodes within 1-day reach of an FC | — | — | H2 onwards | • Map demand concentration in geographies underserved by existing FCs<br>• Run FC feasibility assessment for high-priority regions<br>• Initiate lease and infra planning for selected locations |
| Outlier Investigation | % orders >4 days | — | — | Q1 | • Build outlier dashboard: courier × pincode × day-of-week<br>• Categorise root causes (hub delay, pickup miss, serviceability error, transit leg failure)<br>• Escalate structural outlier routes with SLA accountability |
| Serviceability | Serviceability accuracy rate | — | — | Q1–Q2 | • Establish regular sync cadence with courier partners for serviceability updates<br>• Build alerting for any serviceability changes before they surface in orders<br>• Audit and correct incorrect tags surfaced by outlier investigation |
| Dispatch Waves | % orders making same-day dispatch | — | — | H1 | • Audit actual dispatch times vs assumed cut-off times by warehouse<br>• Assess feasibility of an evening dispatch run with ops<br>• Expose cut-off-aware promise at checkout |
| Buffer Optimisation | Promise date accuracy %;<br>buffer vs actual P90 | — | — | H2 | • Replace static buffers with a data-derived P90 model by pincode cluster<br>• Build a dynamic buffer layer responsive to real-time capacity signals |

---

## Section 2: On-Time Delivery

OTD is an execution metric. The core driver is first-attempt delivery success — NDR is its inverse.

| Lever | Metric | Baseline | Target | Time Horizon | Interventions |
|---|---|---|---|---|---|
| WH & Dispatch OTD | Order-to-dispatch TAT;<br>pickup SLA compliance % | — | — | Q1 | • Instrument pickup events: track scheduled vs actual scan time by courier and warehouse<br>• Track order-to-dispatch TAT by shift and warehouse<br>• Build real-time alerting for same-day pickup misses |
| Courier Selection Intelligence | First-attempt delivery rate;<br>courier NDR rate by pincode cluster | — | — | H1 | • Build courier scorecard by pincode cluster: P50/P90 transit, first-attempt rate, NDR rate<br>• Integrate scorecard into allocation logic — route on reliability, not just cost |
| Address Quality | Address-related NDR % | — | — | H1 → H2 | • Checkout address validation using pincode-to-area lookup to flag errors at entry<br>• Pre-delivery outreach for flagged addresses before DE leaves the hub<br>• Post-NDR address correction flow to recover delivery before reattempt |
| Customer Availability & Intent | Genuine unavailability NDR % | — | — | H1 → H2 | • OFD alerts with estimated delivery time window<br>• Delivery slot selection at checkout (morning / afternoon / evening)<br>• DE route scheduling optimised for predicted availability patterns |
| DE Behaviour | DE-attributed NDR %;<br>fake attempt rate | — | — | H1 | • Geo-validate delivery attempt events against delivery address to detect fake attempts<br>• Build DE scorecard per partner using NDR reason codes, complaint rate, reattempt success<br>• Review DE performance monthly in courier QBRs |

---

## Section 3: Delivery Experience

Delivery experience is broader than OTD. Being on time is necessary but not sufficient — a customer can receive an order on time and still have a poor experience.

| Lever | Metric | Baseline | Target | Time Horizon | Interventions |
|---|---|---|---|---|---|
| Delivery Milestone Communication | Notification coverage rate;<br>WISMO contact rate | — | — | Q1–Q2 | • Audit notification gaps across order stages: confirmed → dispatched → OFD → delivered<br>• Build owned OFD notification with time window<br>• Optimise channel by customer segment: SMS, WhatsApp, push |
| Communication Quality & Channel | Engagement rate on delivery notifications | — | — | H1 | • Redesign templates with actionable content: one-tap reschedule, live tracking, DE contact<br>• Language personalisation by customer location and preference<br>• A/B test channel mix by pincode and segment |
| Delay & Exception Communication | % delays proactively communicated before customer contacts support | — | — | H1 | • Build delay detection using expected vs actual scan event comparison<br>• Trigger proactive outreach for delays beyond defined threshold<br>• Own NDR communication end-to-end — do not default to courier templates |
| Last-Mile Handover Experience | Digital POD rate;<br>handover complaint rate | — | — | H1–H2 | • Roll out OTP-based digital proof of delivery<br>• Define DE courtesy standards and enforce with courier partners<br>• Enable flexible handover: neighbour, security desk, designated safe drop |
| Parcel Condition at Delivery | Damage and tamper complaint rate | — | — | H1 | • Audit packaging standards across product categories<br>• Implement tamper-evidence for medicine categories<br>• Track damage rate by courier partner and surface in QBRs |
| Post-Failure Recovery | Post-failure CSAT;<br>recovery rate within SLA | — | — | H2 | • Own the post-NDR customer communication flow end-to-end<br>• Define replacement dispatch SLA and build the operational trigger for it<br>• Build a goodwill framework for egregious failures |

---

## Section 4: Cost

Logistics cost per order flows directly into margin. Cost inefficiencies — RTO, reattempts, split shipments — are symptoms of failures in Promise and OTD, so fixing delivery quality and improving margins are often the same work.

| Lever | Metric | Baseline | Target | Time Horizon | Interventions |
|---|---|---|---|---|---|
| RTO Reduction | RTO rate %;<br>RTO cost per order | — | — | H1 → H2 | • Root cause analysis of RTO by NDR type to identify highest-volume failure modes<br>• Address quality improvements to reduce address-driven RTOs<br>• Intent-signal-based screening for high-risk COD orders |
| NDR Reattempt Cost | Reattempt rate;<br>cost per reattempt | — | — | H1–H2 | • First-attempt success improvements via OTD levers reduce reattempts as a by-product<br>• Customer-confirmed reattempt slots to avoid second failed attempts<br>• Reattempt scheduling optimisation by DE route |
| Courier Rate Optimisation | Cost per delivery by courier | — | — | H2 | • Build performance-backed negotiation data from courier scorecard<br>• Tie rate renegotiation to SLA delivery — poor performers do not get the same rates<br>• Enforce penalty clauses for SLA breach where contractually available |
| Packaging Optimisation | Packaging cost per order;<br>damage rate (must not degrade) | — | — | H2 | • Dimensional weight audit vs current packaging catalogue<br>• Pilot right-sizing for low-damage-risk categories<br>• Track damage rate alongside cost — holds as a hard constraint |
| COD Remittance Cycle | Remittance days outstanding | — | — | H2 | • Renegotiate remittance cadence with courier partners<br>• Pilot UPI-at-door collection as a step toward reducing cash-in-transit |
| Split Shipment Reduction | Split shipment rate;<br>incremental cost per split | — | — | H2 | • Quantify split shipment frequency and cost to establish the business case<br>• Flag to supply chain for inventory positioning decisions<br>• Track as a shared metric between logistics and supply chain |

---

## Execution Phasing

| | H1 | H2 |
|---|---|---|
| **Promise** | Outlier investigation, Serviceability, Dispatch waves, Courier network optimisation | Buffer optimisation, SDD expansion rollout, Network expansion planning |
| **OTD** | WH & dispatch OTD, Courier selection intelligence, OFD alerts, DE behaviour | Address quality full stack, Slot selection |
| **Delivery Experience** | Milestone communication, Communication quality, Delay alerts, Parcel condition | Last-mile handover, Post-failure recovery |
| **Cost** | RTO root cause analysis, NDR reattempt reduction | Courier rate renegotiation, Packaging, COD remittance, Split shipment tracking |
