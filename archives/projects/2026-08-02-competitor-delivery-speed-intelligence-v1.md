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

**Learning journey defined (5 stages):**

| Stage | Topic | Goal |
|---|---|---|
| 1 | How websites work | Understand static vs dynamic pages, what an API call is |
| 2 | What scraping is | Understand HTML scraping vs browser automation vs API interception |
| 3 | Operational reality | Anti-bot, rate limiting, maintenance burden, freshness |
| 4 | Hands-on exposure | See it work once on a real competitor site |
| 5 | Product spec | Define coverage, frequency, data destination, ownership |

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
