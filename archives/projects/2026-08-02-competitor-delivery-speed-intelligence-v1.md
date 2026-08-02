# Competitor Intelligence Platform — Delivery Speed (Primary)

**Version:** v1
**Date:** 2026-08-02
**Status:** Exploration

---

## 1. Problem Statement

Truemeds competes on delivery speed. For any given pincode, if a competitor promises faster delivery than Truemeds, Truemeds loses the customer. If Truemeds is faster, it wins.

To make informed offensive and defensive decisions — where to invest in logistics, where to ramp marketing — Truemeds needs to know competitor delivery promises at pincode level.

The same scraping infrastructure, once built for delivery speed, can be extended by other functions at Truemeds to capture pricing, discounts, and SKU catalog data — making this the foundation for a broader competitive intelligence capability.

---

## 2. Hypothesis

Systematically scraping competitor delivery speed promises (by pincode, by product) will allow Truemeds to:

1. **Offensively** — identify pincodes where Truemeds is faster and double down on acquisition there
2. **Defensively** — identify pincodes where Truemeds is slower and either fix logistics or deprioritize spend

The architecture will be designed to be extensible — once delivery speed is validated, other teams can layer in their own data domains (pricing, discounts, SKU catalog) without rebuilding the foundation.

---

## 3. Data Domains in Scope

### Primary — Logistics PM ownership

| Domain | Strategic question it answers |
|---|---|
| Delivery speed promise by pincode | For any pincode, is Truemeds faster or slower than each competitor? |

### Extended — Other functions, not current ownership

| Domain | Strategic question it answers | Likely owner |
|---|---|---|
| Pricing (MRP, selling price, effective price) | Is Truemeds more or less expensive than competitors per SKU? | Pricing / Revenue team |
| Discounts (% off, categories, timing) | What are competitor promotional patterns? Are they discounting strategically? | Category / Growth team |
| SKU catalog | Which products do competitors carry that Truemeds doesn't? Where are catalog gaps? | Merchandising / Category team |

*Extended domains will use the same scraping infrastructure. Respective teams to define their own data definitions, refresh cadence, and specs when ready.*

---

## 4. Competitors in Scope

- Tata 1mg
- Netmeds
- Apollo Pharmacy
- PharmEasy

---

## 5. Learning Log

### 2026-08-02 — Session 1: Conceptual Framing

**What we discussed:**

- Established the core competitive positioning logic: delivery speed advantage/disadvantage is pincode-level, not national
- Identified that to act on this, Truemeds needs structured competitor speed data by pincode
- Agreed that web scraping is the mechanism to get there
- Tejas (PM) has no prior scraping experience — learning journey planned before building
- Scope expanded during session from delivery speed only to a broader competitive intelligence platform; delivery speed remains primary domain under Logistics PM ownership; pricing, discounts, and SKU catalog identified as extended domains for other functions

**Learning journey defined (8 stages):**

| Stage | Topic | Key questions covered |
|---|---|---|
| 1 | How websites work | Static vs dynamic pages, what an API call is, DevTools exercise on a live competitor site |
| 2 | Legal, ToS, and competitive risk | Can we legally scrape? What does each competitor's ToS say? What's the risk of being blocked or retaliated against? |
| 3 | Data definition and benchmark methodology | What does each competitor show for delivery speed? How is it displayed differently across sites? Which product do we use as a proxy? How do we normalize across competitors? |
| 4 | Scraping approaches and tradeoffs | HTML scraping vs browser automation vs API interception — what each is and when to use which |
| 5 | Scale, operations, and data quality | Infra cost at ~2M ops/day, anti-bot measures, maintenance burden, failure detection, stale data policy |
| 6 | Hands-on exposure | See a real scrape on one competitor, one pincode — observe what raw output actually looks like |
| 7 | Data pipeline: raw to structured | Parsing messy text into numbers, normalization to a common unit, schema design, time-series storage, handling nulls and failure states |
| 8 | Product spec | Coverage, refresh frequency, ownership, failure SLAs, data destination (deferred) |

*Stages revised from original 5 after two rethinking loops. Key additions: Stage 2 (Legal/ToS, was entirely missing), Stage 3 (Data definition, PM-owned decision), Stage 7 (Data pipeline, gap identified during session).*

**Next step:** Stage 1 — DevTools exercise on a live competitor site

---

## 6. Open Questions

- Where does this data surface — internal dashboard, input to logistics team, marketing team? *(deferred)*
- Which extended data domain (pricing, discounts, SKU catalog) should be picked up first after delivery speed is validated, and by which team?

---

## 7. Decisions Log

### 2026-08-02

| Decision | Choice | Rationale |
|---|---|---|
| Competitors in scope | Tata 1mg, Netmeds, Apollo Pharmacy, PharmEasy | The four primary online pharmacy competitors |
| Pincode coverage | All serviceable pincodes across all competitors, not just Truemeds-serviceable ones | Truemeds may expand to pincodes where competitors already operate; need full picture |
| Refresh frequency | Every 1 hour | Competitors have dispatch cutoffs that shift delivery promises intraday; hourly captures these changes |
| Build vs buy | Build the scraping infrastructure | — |
| Data surfacing | Deferred | Not in scope for now |
| Primary data domain | Delivery speed | Logistics PM ownership; closest to the original problem statement |
| Extended data domains | Pricing, discounts, SKU catalog | Valid additions but owned by other functions; will reuse the same infra when ready |
