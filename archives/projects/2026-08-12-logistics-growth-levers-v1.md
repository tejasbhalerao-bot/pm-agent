# Logistics Annual Operating Plan — FY2026

**Date:** 2026-08-12 | **Author:** Tejas Bhalerao | **Status:** Draft v6

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
| Promise | Promise accuracy % | TBD | TBD |
| On-Time Delivery | On-time delivery rate % | TBD | TBD |
| Delivery Experience | Delivery CSAT | TBD | TBD |
| Cost | Logistics cost as % of GMV | TBD | TBD |

---

## Section 1: Promise

---

**1.1 SDD Expansion** — H1 (prioritisation) → H2 (rollout)

| Metric | Baseline | FY Target |
|---|---|---|
| SDD-eligible pincodes; SDD conversion rate | TBD | TBD |

- Score pincodes on traffic × conversion gap × customer receptivity × competitive positioning
- Map SKU eligibility for SDD
- Assess dark store readiness per priority pincode

*(In flight — SDD Expansion Strategy project)*

---

**1.2 Courier Network Optimisation** — H1

| Metric | Baseline | FY Target |
|---|---|---|
| P90 transit time by pincode cluster | TBD | TBD |

- Analyse transit leg performance by route to identify bottlenecks
- Benchmark hub throughput across courier partners
- Escalate structural bottleneck routes in courier QBRs

---

**1.3 Network Expansion** — H2 onwards

| Metric | Baseline | FY Target |
|---|---|---|
| % pincodes within 1-day reach of an FC | TBD | TBD |

- Map demand concentration in geographies currently underserved by existing FCs
- Run FC feasibility assessment for high-priority regions
- Initiate lease and infra planning for selected locations

---

**1.4 Outlier Investigation** — Q1 *(diagnostic — feeds all levers below)*

| Metric | Baseline | FY Target |
|---|---|---|
| % orders taking >4 days | TBD | TBD |

- Build outlier dashboard segmented by courier × pincode × day-of-week
- Categorise root causes (hub delay, pickup miss, serviceability error, transit leg failure)
- Escalate structural outlier routes to courier partners with SLA accountability

---

**1.5 Serviceability** — Q1–Q2

| Metric | Baseline | FY Target |
|---|---|---|
| Serviceability accuracy rate; % pincodes incorrectly tagged | TBD | TBD |

- Establish regular sync cadence with courier partners for serviceability updates
- Build alerting for any serviceability changes before they surface in customer orders
- Audit and correct incorrect tags surfaced by outlier investigation

---

**1.6 Dispatch Waves** — H1

| Metric | Baseline | FY Target |
|---|---|---|
| % orders making same-day dispatch | TBD | TBD |

- Audit actual dispatch times vs assumed cut-off times by warehouse
- Assess feasibility of an evening dispatch run with ops
- Expose cut-off-aware promise at checkout ("Order in next Xh for delivery by tomorrow")

---

**1.7 Buffer Optimisation** — H2 *(after outlier and serviceability work)*

| Metric | Baseline | FY Target |
|---|---|---|
| Buffer size vs actual P90 transit time; promise date accuracy % | TBD | TBD |

- Replace static hardcoded buffers with a data-derived P90 model by pincode cluster
- Build a dynamic buffer layer that responds to real-time capacity signals (peak, weather, strikes)

---

## Section 2: On-Time Delivery

OTD is an execution metric. The core driver is first-attempt delivery success — NDR is its inverse. Levers are ordered by where in the delivery chain they act.

---

**2.1 WH & Dispatch OTD** — Q1

| Metric | Baseline | FY Target |
|---|---|---|
| Order-to-dispatch TAT; pickup SLA compliance % | TBD | TBD |

- Instrument pickup events: track scheduled vs actual scan time by courier and warehouse
- Track order-to-dispatch TAT by shift and warehouse
- Build real-time alerting for same-day pickup misses so ops can escalate before it cascades

---

**2.2 Courier Selection Intelligence** — H1

| Metric | Baseline | FY Target |
|---|---|---|
| First-attempt delivery rate; courier NDR rate by pincode cluster | TBD | TBD |

- Build courier scorecard by pincode cluster: P50/P90 transit time, first-attempt rate, NDR rate
- Integrate scorecard into courier allocation logic, routing on reliability not just cost

---

**2.3 Address Quality** — H1 (validation) → H2 (full stack)

| Metric | Baseline | FY Target |
|---|---|---|
| Address-related NDR % | TBD | TBD |

- Checkout address validation using pincode-to-area lookup to flag probable errors at entry
- Pre-delivery outreach for flagged addresses before the DE leaves the hub
- Post-NDR address correction flow to recover delivery before reattempt

---

**2.4 Customer Availability & Intent** — H1 (OFD alerts) → H2 (slot selection)

| Metric | Baseline | FY Target |
|---|---|---|
| Genuine unavailability NDR % | TBD | TBD |

- OFD alerts with estimated delivery time window
- Delivery slot selection at checkout (morning / afternoon / evening)
- DE route scheduling optimised for predicted customer availability patterns

---

**2.5 DE Behaviour** — H1

| Metric | Baseline | FY Target |
|---|---|---|
| DE-attributed NDR %; fake attempt rate | TBD | TBD |

- Geo-validate delivery attempt events against delivery address to detect fake attempts
- Build DE scorecard per partner using NDR reason codes, complaint rate, reattempt success rate
- Review DE performance data monthly in courier QBRs

---

## Section 3: Delivery Experience

Delivery experience is broader than OTD. Being on time is necessary but not sufficient — a customer can receive an order on time and still have a poor experience. This section covers everything from dispatch to the moment the parcel is in the customer's hands.

---

**3.1 Delivery Milestone Communication** — Q1–Q2

| Metric | Baseline | FY Target |
|---|---|---|
| Notification coverage rate; WISMO contact rate | TBD | TBD |

- Audit current notification gaps across order stages (confirmed → dispatched → OFD → delivered)
- Build owned OFD notification with time window
- Optimise channel by customer segment: SMS, WhatsApp, push

---

**3.2 Communication Quality & Channel** — H1

| Metric | Baseline | FY Target |
|---|---|---|
| Customer engagement rate on delivery notifications | TBD | TBD |

- Redesign notification templates with actionable content: one-tap reschedule, live tracking, DE contact
- Language personalisation by customer location and preference
- A/B test channel mix by pincode and customer segment

---

**3.3 Delay & Exception Communication** — H1

| Metric | Baseline | FY Target |
|---|---|---|
| % delays proactively communicated before customer contacts support | TBD | TBD |

- Build delay detection using expected vs actual scan event comparison
- Trigger proactive customer outreach for delays beyond a defined threshold
- Own NDR communication end-to-end — do not default to courier templates

---

**3.4 Last-Mile Handover Experience** — H1–H2

| Metric | Baseline | FY Target |
|---|---|---|
| Digital POD rate; handover-related complaint rate | TBD | TBD |

- Roll out OTP-based digital proof of delivery
- Define DE courtesy standards and enforce with courier partners
- Enable flexible handover options: neighbour, security desk, designated safe drop

---

**3.5 Parcel Condition at Delivery** — H1

| Metric | Baseline | FY Target |
|---|---|---|
| Damage and tamper complaint rate | TBD | TBD |

- Audit packaging standards across product categories
- Implement tamper-evidence for medicine categories
- Track damage rate by courier partner and surface in QBRs

---

**3.6 Post-Failure Recovery** — H2

| Metric | Baseline | FY Target |
|---|---|---|
| Post-failure CSAT; recovery rate (replacement within SLA) | TBD | TBD |

- Own the post-NDR customer communication flow end-to-end
- Define replacement dispatch SLA and build the operational trigger for it
- Build a goodwill framework for egregious failures (damaged medicine, repeated NDR)

---

## Section 4: Cost

Logistics cost per order flows directly into margin. Cost inefficiencies — RTO, reattempts, split shipments — are also symptoms of failures in Promise and OTD, so fixing delivery quality and improving margins are often the same work.

---

**4.1 RTO Reduction** — H1 (analysis) → H2 (interventions)

| Metric | Baseline | FY Target |
|---|---|---|
| RTO rate %; RTO cost per order | TBD | TBD |

- Root cause analysis of RTO by NDR type to identify the highest-volume failure modes
- Address quality improvements to reduce address-driven RTOs
- Intent-signal-based screening for high-risk COD orders before dispatch

---

**4.2 NDR Reattempt Cost** — H1–H2

| Metric | Baseline | FY Target |
|---|---|---|
| Reattempt rate; cost per reattempt | TBD | TBD |

- First-attempt success improvements via OTD levers (2.3, 2.4) reduce reattempts as a by-product
- Customer-confirmed reattempt slots to avoid a second failed attempt
- Reattempt scheduling optimisation by DE route

---

**4.3 Courier Rate Optimisation** — H2 *(tied to contract cycles)*

| Metric | Baseline | FY Target |
|---|---|---|
| Cost per delivery by courier | TBD | TBD |

- Build performance-backed negotiation data from courier scorecard (2.2)
- Tie annual rate renegotiation to SLA delivery — poor performers do not get the same rates
- Enforce penalty clauses for SLA breach where contractually available

---

**4.4 Packaging Optimisation** — H2

| Metric | Baseline | FY Target |
|---|---|---|
| Packaging cost per order; damage rate (constraint, must not degrade) | TBD | TBD |

- Audit dimensional weight vs current packaging catalogue
- Pilot right-sizing for low-damage-risk categories
- Track damage rate alongside cost to ensure constraint is held

---

**4.5 COD Remittance Cycle** — H2

| Metric | Baseline | FY Target |
|---|---|---|
| Remittance days outstanding | TBD | TBD |

- Renegotiate remittance cadence with courier partners
- Pilot UPI-at-door collection as a step toward reducing COD cash-in-transit

---

**4.6 Split Shipment Reduction** — H2 *(cross-team)*

| Metric | Baseline | FY Target |
|---|---|---|
| Split shipment rate; incremental cost per split | TBD | TBD |

- Quantify split shipment frequency and cost to establish the business case
- Flag findings to supply chain for inventory positioning decisions
- Track as a shared metric between logistics and supply chain

---

## Execution Phasing

| | H1 | H2 |
|---|---|---|
| **Promise** | Outlier investigation, Serviceability, Dispatch waves, Courier network optimisation | Buffer optimisation, SDD expansion rollout, Network expansion planning |
| **OTD** | WH & dispatch OTD, Courier selection intelligence, OFD alerts, DE behaviour | Address quality full stack, Slot selection |
| **Delivery Experience** | Milestone communication, Communication quality, Delay alerts, Parcel condition | Last-mile handover, Post-failure recovery |
| **Cost** | RTO root cause analysis, NDR reattempt reduction | Courier rate renegotiation, Packaging optimisation, COD remittance, Split shipment tracking |

---

*Baselines and targets to be populated once FY2025 actuals are confirmed. H1 = Q1–Q2, H2 = Q3–Q4.*
