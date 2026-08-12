# Logistics Annual Operating Plan — FY2026

**Date:** 2026-08-12 | **Author:** Tejas Bhalerao | **Status:** Draft v7

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

| Lever | Metric | Baseline | Target | Time Horizon |
|---|---|---|---|---|
| SDD expansion | SDD-eligible pincodes; SDD conversion rate | — | — | H1 → H2 |
| Courier network optimisation | P90 transit time by pincode cluster | — | — | H1 |
| Network expansion | % pincodes within 1-day reach of an FC | — | — | H2 onwards |
| Outlier investigation | % orders >4 days | — | — | Q1 |
| Serviceability | Serviceability accuracy rate | — | — | Q1–Q2 |
| Dispatch waves | % orders making same-day dispatch | — | — | H1 |
| Buffer optimisation | Promise date accuracy %; buffer vs actual P90 | — | — | H2 |

### Interventions

**SDD Expansion** *(In flight — SDD Expansion Strategy project)*
- Score pincodes on traffic × conversion gap × customer receptivity × competitive positioning
- Map SKU eligibility for SDD; assess dark store readiness per priority pincode

**Courier Network Optimisation**
- Analyse transit leg performance by route to identify bottlenecks
- Benchmark hub throughput; escalate structural bottleneck routes in courier QBRs

**Network Expansion**
- Map demand concentration in geographies currently underserved by existing FCs
- Run FC feasibility assessment for high-priority regions; initiate lease and infra planning

**Outlier Investigation** *(diagnostic — findings feed all levers below)*
- Build outlier dashboard: courier × pincode × day-of-week
- Categorise root causes; escalate structural routes to courier partners with SLA accountability

**Serviceability**
- Establish regular sync cadence with courier partners for serviceability updates
- Build alerting for changes; audit and correct incorrect tags surfaced by outlier investigation

**Dispatch Waves**
- Audit actual dispatch times vs assumed cut-off times by warehouse
- Assess feasibility of an evening dispatch run; expose cut-off-aware promise at checkout

**Buffer Optimisation**
- Replace static buffers with a data-derived P90 model by pincode cluster
- Build a dynamic buffer layer responsive to real-time capacity signals (peak, weather, strikes)

---

## Section 2: On-Time Delivery

OTD is an execution metric. The core driver is first-attempt delivery success — NDR is its inverse.

| Lever | Metric | Baseline | Target | Time Horizon |
|---|---|---|---|---|
| WH & dispatch OTD | Order-to-dispatch TAT; pickup SLA compliance % | — | — | Q1 |
| Courier selection intelligence | First-attempt delivery rate; courier NDR rate | — | — | H1 |
| Address quality | Address-related NDR % | — | — | H1 → H2 |
| Customer availability & intent | Genuine unavailability NDR % | — | — | H1 → H2 |
| DE behaviour | DE-attributed NDR %; fake attempt rate | — | — | H1 |

### Interventions

**WH & Dispatch OTD**
- Instrument pickup events: track scheduled vs actual scan time by courier and warehouse
- Track order-to-dispatch TAT by shift; build real-time alerting for same-day pickup misses

**Courier Selection Intelligence**
- Build courier scorecard by pincode cluster: P50/P90 transit, first-attempt rate, NDR rate
- Integrate scorecard into courier allocation logic — route on reliability, not just cost

**Address Quality**
- Checkout address validation using pincode-to-area lookup to flag errors at entry
- Pre-delivery outreach for flagged addresses; post-NDR address correction flow

**Customer Availability & Intent**
- OFD alerts with estimated delivery time window (H1); delivery slot selection at checkout (H2)
- DE route scheduling optimised for predicted customer availability patterns

**DE Behaviour**
- Geo-validate delivery attempt events against delivery address to detect fake attempts
- Build DE scorecard per partner; review monthly in courier QBRs

---

## Section 3: Delivery Experience

Delivery experience is broader than OTD. Being on time is necessary but not sufficient — a customer can receive an order on time and still have a poor experience.

| Lever | Metric | Baseline | Target | Time Horizon |
|---|---|---|---|---|
| Delivery milestone communication | Notification coverage rate; WISMO contact rate | — | — | Q1–Q2 |
| Communication quality & channel | Engagement rate on delivery notifications | — | — | H1 |
| Delay & exception communication | % delays proactively communicated | — | — | H1 |
| Last-mile handover experience | Digital POD rate; handover complaint rate | — | — | H1–H2 |
| Parcel condition at delivery | Damage and tamper complaint rate | — | — | H1 |
| Post-failure recovery | Post-failure CSAT; recovery rate | — | — | H2 |

### Interventions

**Delivery Milestone Communication**
- Audit notification gaps across order stages (confirmed → dispatched → OFD → delivered)
- Build owned OFD notification with time window; optimise channel by customer segment

**Communication Quality & Channel**
- Redesign templates with actionable content: one-tap reschedule, live tracking, DE contact
- Language personalisation; A/B test channel mix by pincode and segment

**Delay & Exception Communication**
- Build delay detection using expected vs actual scan event comparison
- Trigger proactive outreach for delays beyond threshold; own NDR communication end-to-end

**Last-Mile Handover Experience**
- Roll out OTP-based digital proof of delivery
- Define DE courtesy standards with courier partners; enable flexible handover options (neighbour, security desk)

**Parcel Condition at Delivery**
- Audit packaging standards; implement tamper-evidence for medicine categories
- Track damage rate by courier partner and surface in QBRs

**Post-Failure Recovery**
- Own the post-NDR customer communication flow end-to-end
- Define replacement dispatch SLA; build goodwill framework for egregious failures

---

## Section 4: Cost

Logistics cost per order flows directly into margin. Cost inefficiencies — RTO, reattempts, split shipments — are symptoms of failures in Promise and OTD, so fixing delivery quality and improving margins are often the same work.

| Lever | Metric | Baseline | Target | Time Horizon |
|---|---|---|---|---|
| RTO reduction | RTO rate %; RTO cost per order | — | — | H1 → H2 |
| NDR reattempt cost | Reattempt rate; cost per reattempt | — | — | H1–H2 |
| Courier rate optimisation | Cost per delivery by courier | — | — | H2 |
| Packaging optimisation | Packaging cost per order; damage rate | — | — | H2 |
| COD remittance cycle | Remittance days outstanding | — | — | H2 |
| Split shipment reduction | Split shipment rate; incremental cost per split | — | — | H2 |

### Interventions

**RTO Reduction**
- Root cause analysis of RTO by NDR type to identify highest-volume failure modes
- Address quality improvements; intent-signal-based screening for high-risk COD orders

**NDR Reattempt Cost**
- First-attempt success improvements via OTD levers reduce reattempts as a by-product
- Customer-confirmed reattempt slots; reattempt scheduling optimisation by DE route

**Courier Rate Optimisation**
- Build performance-backed negotiation data from courier scorecard
- Tie rate renegotiation to SLA delivery; enforce penalty clauses for breach

**Packaging Optimisation**
- Dimensional weight audit vs current packaging catalogue
- Pilot right-sizing for low-damage-risk categories; hold damage rate as a hard constraint

**COD Remittance Cycle**
- Renegotiate remittance cadence with courier partners
- Pilot UPI-at-door collection as a step toward reducing cash-in-transit

**Split Shipment Reduction**
- Quantify split shipment frequency and cost to establish the business case
- Flag to supply chain for inventory positioning decisions; track as a shared metric

---

## Execution Phasing

| | H1 | H2 |
|---|---|---|
| **Promise** | Outlier investigation, Serviceability, Dispatch waves, Courier network optimisation | Buffer optimisation, SDD expansion rollout, Network expansion planning |
| **OTD** | WH & dispatch OTD, Courier selection intelligence, OFD alerts, DE behaviour | Address quality full stack, Slot selection |
| **Delivery Experience** | Milestone communication, Communication quality, Delay alerts, Parcel condition | Last-mile handover, Post-failure recovery |
| **Cost** | RTO root cause analysis, NDR reattempt reduction | Courier rate renegotiation, Packaging, COD remittance, Split shipment tracking |
