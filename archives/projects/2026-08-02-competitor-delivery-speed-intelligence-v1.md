# Competitor Delivery Speed Intelligence

**Version:** v1
**Date:** 2026-08-02
**Status:** Exploration

---

## 1. Problem Statement

Truemeds competes on delivery speed. For any given pincode, if a competitor promises faster delivery than Truemeds, Truemeds loses the customer. If Truemeds is faster, it wins.

To make informed offensive and defensive decisions — where to invest in logistics, where to ramp marketing — Truemeds needs to know competitor delivery promises at pincode level.

---

## 2. Hypothesis

Systematically scraping competitor delivery speed promises (by pincode, by product) will allow Truemeds to:

1. **Offensively** — identify pincodes where Truemeds is faster and double down on acquisition there
2. **Defensively** — identify pincodes where Truemeds is slower and either fix logistics or deprioritize spend

---

## 3. Competitors in Scope

- Tata 1mg
- Netmeds
- Apollo Pharmacy
- PharmEasy

---

## 4. Learning Log

### 2026-08-02 — Session 1: Conceptual Framing

**What we discussed:**

- Established the core competitive positioning logic: delivery speed advantage/disadvantage is pincode-level, not national
- Identified that to act on this, Truemeds needs structured competitor speed data by pincode
- Agreed that web scraping is the mechanism to get there
- Tejas (PM) has no prior scraping experience — learning journey planned before building

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

## 5. Open Questions

- Where does this data surface — internal dashboard, input to logistics team, marketing team? *(deferred)*

---

## 6. Decisions Log

### 2026-08-02

| Decision | Choice | Rationale |
|---|---|---|
| Competitors in scope | Tata 1mg, Netmeds, Apollo Pharmacy, PharmEasy | The four primary online pharmacy competitors |
| Pincode coverage | All serviceable pincodes across all competitors, not just Truemeds-serviceable ones | Truemeds may expand to pincodes where competitors already operate; need full picture |
| Refresh frequency | Every 1 hour | Competitors have dispatch cutoffs that shift delivery promises intraday; hourly captures these changes |
| Build vs buy | Build the scraping infrastructure | — |
| Data surfacing | Deferred | Not in scope for now |
