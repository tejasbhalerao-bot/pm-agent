# Logistics Annual Operating Plan — FY2026

**Date:** 2026-08-12 | **Author:** Tejas Bhalerao | **Status:** Draft v5

---

## Objective

Logistics contributes to growth across four dimensions:

- **Promise** — the ETA shown at checkout. Tighter and accurate promise → higher conversion. A tight promise that can't be kept is net negative.
- **OTD** — whether we deliver by the promised date. Reflects both execution quality and whether the promise itself was realistic and achievable in the first place.
- **Delivery Experience** — how the customer feels about the delivery, encompassing everything from communication to the moment the parcel is in their hands.
- **Cost** — logistics cost per order as a direct lever on margins.

---

## FY2026 Commitments

| Focus Area | Headline Metric | Baseline | FY Target |
|---|---|---|---|
| Promise | Promise accuracy % | [TBD] | [TBD] |
| On-Time Delivery | On-time delivery rate % | [TBD] | [TBD] |
| Delivery Experience | Delivery CSAT | [TBD] | [TBD] |
| Cost | Logistics cost as % of GMV | [TBD] | [TBD] |

---

## Section 1: Promise

| # | Lever | Metric | Baseline | FY Target | Key Interventions | Time Horizon |
|---|---|---|---|---|---|---|
| 1.1 | SDD expansion | SDD-eligible pincodes; SDD conversion rate | [TBD] | [TBD] | Pincode scoring on traffic × conversion gap × customer receptivity × competitive positioning; SKU eligibility mapping; dark store readiness per pincode | H1 (prioritisation) → H2 (rollout) |
| 1.2 | Courier network optimisation | P90 transit time by pincode cluster | [TBD] | [TBD] | Transit leg performance analysis by route; hub throughput benchmarking; escalate bottleneck routes to courier partners in QBRs | H1 |
| 1.3 | Network expansion | % pincodes within 1-day reach of an FC | [TBD] | [TBD] | Demand mapping for underserved geographies; FC feasibility assessment; lease and infra planning | H2 onwards |
| 1.4 | Outlier investigation | % orders >4 days | [TBD] | [TBD] | Build outlier dashboard (courier × pincode × DoW); root cause categorisation; partner SLA escalation for structural outlier routes | Q1 — diagnostic feeds all levers below |
| 1.5 | Serviceability | Serviceability accuracy rate; % pincodes incorrectly tagged | [TBD] | [TBD] | Regular sync cadence with courier partners for serviceability updates; alerting for additions and removals; audit of incorrect tags surfaced by outlier investigation | Q1–Q2 |
| 1.6 | Dispatch waves | % orders making same-day dispatch | [TBD] | [TBD] | Audit actual vs assumed cut-off times by warehouse; assess feasibility of evening dispatch run with ops; expose cut-off-aware promise at checkout | H1 |
| 1.7 | Buffer optimization | Buffer size vs actual P90 transit time; promise date accuracy % | [TBD] | [TBD] | Replace static buffers with data-derived P90 model by pincode cluster; build dynamic buffer layer for peak and capacity signals | H2 — after outlier and serviceability work |

---

## Section 2: On-Time Delivery

OTD is an execution metric. The core driver is **first-attempt delivery success** — NDR is its inverse. Levers are ordered by where in the delivery chain they act.

| # | Lever | Metric | Baseline | FY Target | Key Interventions | Time Horizon |
|---|---|---|---|---|---|---|
| 2.1 | WH & dispatch OTD | Order-to-dispatch TAT; pickup SLA compliance % | [TBD] | [TBD] | Instrument pickup events (scheduled vs actual scan time); track order-to-dispatch TAT by shift and warehouse; real-time alerting for same-day pickup misses | Q1 |
| 2.2 | Courier selection intelligence | First-attempt delivery rate; courier NDR rate by pincode cluster | [TBD] | [TBD] | Build courier scorecard (P50/P90 transit, first-attempt rate, NDR rate) by pincode cluster; integrate scorecard into courier allocation logic | H1 |
| 2.3 | Address quality | Address-related NDR % | [TBD] | [TBD] | Checkout address validation via pincode-to-area lookup; pre-delivery outreach for flagged addresses; post-NDR address correction flow | H1 (validation) → H2 (full stack) |
| 2.4 | Customer availability & intent | Genuine unavailability NDR % | [TBD] | [TBD] | OFD alerts with time window; delivery slot selection at checkout; DE route scheduling optimised for predicted availability patterns | H1 (OFD alerts) → H2 (slot selection) |
| 2.5 | DE behaviour | DE-attributed NDR %; fake attempt rate | [TBD] | [TBD] | Geo-validation of delivery attempt events; DE scorecard by partner; monthly review of DE performance data in courier QBRs | H1 |

---

## Section 3: Delivery Experience

Delivery experience is broader than OTD. Being on time is necessary but not sufficient — a customer can receive an order on time and still have a poor experience. This section covers everything from dispatch to the moment the parcel is in the customer's hands.

| # | Lever | Metric | Baseline | FY Target | Key Interventions | Time Horizon |
|---|---|---|---|---|---|---|
| 3.1 | Delivery milestone communication | Notification coverage rate; WISMO contact rate | [TBD] | [TBD] | Audit current notification gaps across order stages; build owned OFD notification with time window; channel optimisation by customer segment (SMS / WhatsApp / push) | Q1–Q2 |
| 3.2 | Communication quality & channel | Customer engagement rate on delivery notifications | [TBD] | [TBD] | Redesign notification templates with actionable content (reschedule, track, contact DE); language personalisation; A/B test channel mix by pincode and segment | H1 |
| 3.3 | Delay & exception communication | % delays proactively communicated before customer contacts support | [TBD] | [TBD] | Build delay detection using expected vs actual scan event comparison; proactive outreach trigger for delays beyond threshold; own NDR communication template end-to-end | H1 |
| 3.4 | Last-mile handover experience | Digital POD rate; handover-related complaint rate | [TBD] | [TBD] | OTP-based digital proof of delivery rollout; DE courtesy standards defined and enforced with courier partners; flexible handover options (neighbour, security desk) | H1–H2 |
| 3.5 | Parcel condition at delivery | Damage and tamper complaint rate | [TBD] | [TBD] | Packaging standards audit; tamper-evidence implementation for medicine categories; damage rate tracking by courier partner | H1 |
| 3.6 | Post-failure recovery | Post-failure CSAT; recovery rate (replacement dispatched within SLA) | [TBD] | [TBD] | Own post-NDR customer communication flow; define recovery SLA (replacement dispatch within X hours); build goodwill framework for egregious failures | H2 |

---

## Section 4: Cost

Logistics cost per order flows directly into margin. Cost inefficiencies — RTO, reattempts, split shipments — are also symptoms of failures in Promise and OTD, so fixing delivery quality and improving margins are often the same work.

| # | Lever | Metric | Baseline | FY Target | Key Interventions | Time Horizon |
|---|---|---|---|---|---|---|
| 4.1 | RTO reduction | RTO rate %; RTO cost per order | [TBD] | [TBD] | RTO root cause analysis by NDR type; address quality improvements to reduce address-driven RTOs; intent-signal-based screening for high-risk COD orders | H1 (analysis) → H2 (interventions) |
| 4.2 | NDR reattempt cost | Reattempt rate; cost per reattempt | [TBD] | [TBD] | First-attempt success improvements via OTD levers (2.3, 2.4); customer-confirmed reattempt slots; reattempt scheduling optimisation by DE route | H1–H2 |
| 4.3 | Courier rate optimisation | Cost per delivery by courier | [TBD] | [TBD] | Build performance-backed negotiation data from courier scorecard; annual rate renegotiation tied to SLA delivery; penalty clause enforcement for breach | H2 — tied to contract cycles |
| 4.4 | Packaging optimisation | Packaging cost per order; damage rate (constraint) | [TBD] | [TBD] | Dimensional weight audit vs current packaging catalogue; right-sizing pilot for low-damage-risk categories; ensure damage rate does not degrade as a constraint | H2 |
| 4.5 | COD remittance cycle | Remittance days outstanding | [TBD] | [TBD] | Renegotiate remittance cadence with courier partners; pilot UPI-at-door as a step toward reducing COD volume | H2 |
| 4.6 | Split shipment reduction | Split shipment rate; incremental cost per split | [TBD] | [TBD] | Quantify split shipment frequency and cost; flag to supply chain for inventory positioning decisions; track as a shared metric | H2 — cross-team |

---

## Execution Phasing

| | H1 | H2 |
|---|---|---|
| **Promise** | Outlier investigation, Serviceability audit, Dispatch wave calibration, Courier network optimisation | Buffer optimization, SDD expansion rollout, Network expansion planning |
| **OTD** | WH & dispatch OTD instrumentation, Courier selection intelligence, OFD alerts, DE behaviour monitoring | Address quality full stack, Slot selection, Ongoing scorecard reviews |
| **Delivery Experience** | Milestone communication, Communication quality, Delay & exception alerts, Parcel condition standards | Last-mile handover, Post-failure recovery |
| **Cost** | RTO root cause analysis, NDR reattempt reduction | Courier rate renegotiation, Packaging optimisation, COD remittance, Split shipment tracking |

---

*Baselines and targets to be populated once FY2025 actuals are confirmed. Time horizons assume H1 = Q1–Q2, H2 = Q3–Q4.*
