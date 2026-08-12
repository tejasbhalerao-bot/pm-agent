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
| WH & Dispatch OTD | Pickup misses, late dispatches, and early dispatches all cause OTD failures before the courier is ever involved. | Dispatch on-time % | — | — | Q1 | • Modular payment pending flow<br>• Courier reallocation at WH fulfillment<br>• Context-aware allocation post OP *(hypothesis)* |
| Courier Selection Intelligence | Route each order to the courier with the highest on-time rate for that lane — reliability, not cost, is the primary selection criterion. | On-time delivery % | — | — | Q2–Q3 | • Performance-based speed calculation<br>• Serviceability check at soft allocation<br>• Thin lane fallback design<br>• On-time parameter in allocation |
| Address Quality | Bad addresses cause delivery failures that neither the courier nor the customer can resolve at the door. Fix upstream, not after failure. | First attempt delivery success % | — | — | H2 | • Address flow improvement<br>• Poor address migration<br>• Delivered location capture (lat/long)<br>• DMS integration *(SDD only)* |
| Customer Availability & Intent | A meaningful share of NDR exists simply because the customer didn't know delivery was coming. Acting on availability signals before the attempt prevents avoidable failures. | First attempt delivery success % | — | — | H2 | • Communication revamp (IVR, SMS, WhatsApp, in-app)<br>• Slot selection (SDD) / day selection (non-SDD) |
| DE Behaviour | Fake attempts and behavioural failures inflate NDR and are invisible without instrumentation — but can only be acted on once address quality is reliable. | First attempt delivery success % | — | — | H2 | • Geo-validated attempt detection *(post address quality improvement)* |

---

## Section 3: Delivery Experience

Logistics owns the handover and the signals that enable it — not customer communication. The charter is to ensure the DE can reach the customer, execute the handover correctly, and that the right status is visible to CX at the right time. What CX does with those signals is outside scope.

| Lever | Rationale | Metric | Baseline | Target | Time Horizon | Interventions |
|---|---|---|---|---|---|---|
| Last-Mile Handover Experience | The DE executes under logistics control. A successful handover requires the right delivery signals flowing in, accurate status published before the attempt, and the right tools at the door — reachability, identity verification, and proof of delivery. All enabled through DMS. | Digital POD rate;<br>mis-delivery rate | — | — | H2 | • Delivery signal capture<br>• Proactive status publishing<br>• OTP-based digital POD *(DMS)*<br>• Call masking *(DMS)*<br>• DE-customer connect *(DMS)* |
| Post-Failure Recovery | Failed deliveries generate NDR. Re-engaging the customer quickly and closing the loop is logistics execution — not CX communication. Speed of recovery determines whether the order is ever delivered. | NDR resolution rate;<br>% NDR recovered within SLA | — | — | H2 | • NDR chatbot optimisation<br>• NDR communication workflow |

---

## Section 4: Cost

Cost optimization in FY2026 is scoped to SDD. Non-SDD logistics cost is not a priority this year. The three levers — route planning, supply planning, and driver utilization — are all enabled through DMS.

| Lever | Rationale | Metric | Baseline | Target | Time Horizon | Interventions |
|---|---|---|---|---|---|---|
| Route Planning | Optimising delivery routes reduces distance per order and time per drop — the most direct cost lever in SDD operations. | Cost per SDD delivery;<br>km per delivery | — | — | H2 | • DMS |
| Supply Planning | Right-sizing fleet capacity to demand reduces idle supply costs without compromising SDD coverage. | Supply utilisation rate;<br>cost per SDD delivery | — | — | H2 | • DMS |
| Driver Utilisation | Maximising drops per DE per hour drives down unit cost. Idle time, single-drop runs, and poor zone allocation are the primary inefficiencies. | Drops per DE per hour;<br>cost per SDD delivery | — | — | H2 | • DMS |

---

## Execution Phasing

| | H1 | H2 |
|---|---|---|
| **Promise** | SDD expansion, SDD cutoff rationalisation, Network optimisation | Ideal and consistent ETA, Network expansion, Serviceability |
| **OTD** | WH & dispatch OTD (Q1), Courier selection intelligence (Q2–Q3) | Address quality, Customer availability & intent, DE behaviour |
| **Delivery Experience** | — | Last-mile handover experience, Post-failure recovery |
| **Cost** | — | Route planning, Supply planning, Driver utilisation |
