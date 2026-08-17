# Competitor Intelligence Platform — PRD

**Version:** v1
**Date:** 2026-08-05
**Status:** Draft
**Author:** Tejas Bhalerao (Logistics PM)
**Horizon:** Phase 1 — Delivery Speed | Phase 2 — Pricing, Discounts, SKU Catalog

---

## 1. Overview

This PRD defines the requirements for building a Competitor Intelligence Platform — an automated scraping and data pipeline system that collects, normalizes, and stores competitor data at pincode level.

**Phase 1** (this PRD, Logistics PM ownership): Delivery speed promises by pincode.
**Phase 2** (this PRD, other team ownership): Pricing, discounts, and SKU catalog — using the same infrastructure built in Phase 1.

---

## 2. Problem Statement

Truemeds competes for customers on delivery speed. For any given pincode, if a competitor promises faster delivery, Truemeds loses that customer. If Truemeds is faster, it wins.

Today there is no systematic, always-fresh view of what competitors promise at pincode level. Decisions about where to invest in logistics and where to focus acquisition are made without this data.

The platform resolves this by continuously scraping competitor delivery speed promises and making that data available for analysis.

---

## 3. Goals

| Goal | Description |
|---|---|
| Continuous data collection | Scrape competitor delivery speed promises every hour across all serviceable pincodes |
| Normalized comparison | Convert all competitor delivery formats into a common unit (hours) so Truemeds vs competitor comparisons are possible |
| Reliable pipeline | Detect and alert on scraper failures within 15 minutes; maintain data freshness SLA of ≤1 hour |
| Extensible architecture | Design storage and pipeline so Phase 2 domains (pricing, discounts, SKU) can be added without rebuilding the foundation |

---

## 4. Out of Scope

- Data surfacing (dashboards, alerts, reports) — deferred to a separate initiative
- Scraping data that requires user login on competitor sites
- Pricing, discounts, SKU catalog — defined as Phase 2; architecture must support them but Phase 1 does not build them
- Truemeds' own delivery speed data — assumed to come from internal systems, not this platform

---

## 5. Competitors in Scope

| Competitor | Site |
|---|---|
| Tata 1mg | 1mg.com |
| Netmeds | netmeds.com |
| Apollo Pharmacy | apollopharmacy.in |
| PharmEasy | pharmeasy.in |

---

## 6. Phase 1 — Delivery Speed

### 6.1 Pincode Coverage

- **Source:** Truemeds' existing master pincode list
- **Scope:** All pincodes in the master list — not limited to Truemeds-serviceable ones
- **Engineering note:** Pincode list must be treated as a live input, not a hardcoded value. When the master list is updated, the scraper must pick up new pincodes automatically on the next run cycle

### 6.2 Benchmark Products

Delivery speed is scraped using a fixed set of benchmark products. Products are chosen to be available across all four competitors, OTC (no prescription required), not cold chain, not controlled substances, and stocked in virtually all pincodes year-round.

| Priority | Product | SKU rationale |
|---|---|---|
| Primary | Dolo 650 (Paracetamol 650mg) | Highest-selling OTC medicine in India; near-universal availability |
| Fallback 1 | Crocin 650mg Tablet | Same composition, different brand; if Dolo is out of stock |
| Fallback 2 | Limcee 500mg (Vitamin C) | OTC, widely available, non-seasonal |

**Fallback logic:** For a given pincode × competitor, attempt the primary product first. If the result is `out_of_stock`, retry with Fallback 1. If still `out_of_stock`, retry with Fallback 2. Record which product was successfully used. If all three return `out_of_stock`, record the pincode as `out_of_stock` — do not record it as `not_serviceable`.

### 6.3 Refresh Cadence

- **Frequency:** Every 1 hour
- **Rationale:** Competitor delivery promises change intraday as dispatch cutoffs pass. Hourly cadence captures these shifts
- **Distribution:** Spread scrape jobs evenly across the hour — do not batch all requests at the top of the hour (avoids traffic spikes that trigger rate limiting)

### 6.4 Data to Capture

For each competitor × pincode × product combination, capture the following:

#### Raw record

| Field | Type | Description |
|---|---|---|
| `id` | UUID | Primary key |
| `competitor` | enum | `1mg`, `netmeds`, `apollo`, `pharmeasy` |
| `pincode` | string | 6-digit pincode |
| `product_sku` | string | Which benchmark product was used (primary or fallback) |
| `scraped_at` | timestamp (UTC) | Exact time the scrape executed |
| `option_type` | enum | `standard`, `express` |
| `promise_type` | enum | See promise types below |
| `raw_text` | string | Exact text shown on the competitor's site, unmodified |
| `hours_min` | integer (nullable) | Lower bound of delivery promise in hours from `scraped_at` |
| `hours_max` | integer (nullable) | Upper bound of delivery promise in hours from `scraped_at` |
| `scrape_job_id` | UUID | FK to scrape job that produced this record |

#### Promise types

| `promise_type` | Meaning |
|---|---|
| `has_promise` | Competitor showed a delivery time; `hours_min` and `hours_max` are populated |
| `out_of_stock` | Product shown but not available for delivery at this pincode |
| `not_serviceable` | Competitor does not deliver to this pincode at all |
| `scrape_failed` | Scrape attempt failed (blocked, timeout, error); no delivery data available |

#### Normalization rules

All delivery promises must be converted to hours from `scraped_at`. Both ends of any range must be stored separately.

| Raw text example | `hours_min` | `hours_max` |
|---|---|---|
| "Get it by Tomorrow, 10 PM" (scraped at 2 PM) | 32 | 32 |
| "Delivery in 2–3 days" | 48 | 72 |
| "Same day delivery" | 4 | 8 |
| "Delivered by Aug 7" (scraped Aug 5 at 2 PM) | 48 | 48 |
| "Delivery in 4 hours" | 4 | 4 |

**Rules:**
- When a single date/time is given (no range), set `hours_min` = `hours_max`
- For ranges, set `hours_min` to the lower bound and `hours_max` to the upper bound — do not compute a midpoint
- When express and standard options are both shown, create **two separate records** for the same pincode × product × scrape, one with `option_type = standard` and one with `option_type = express`
- Always store `raw_text` regardless of whether normalization succeeds — if normalization logic has a bug, raw text enables reprocessing without re-scraping

### 6.5 Scrape Jobs

Each scrape attempt must be logged independently of whether it succeeds.

| Field | Type | Description |
|---|---|---|
| `id` | UUID | Primary key |
| `competitor` | enum | Which competitor was scraped |
| `pincode` | string | Target pincode |
| `product_sku` | string | Target benchmark product |
| `scheduled_at` | timestamp | When this job was scheduled to run |
| `started_at` | timestamp | When scraping actually began |
| `completed_at` | timestamp | When scraping completed (success or failure) |
| `status` | enum | `success`, `blocked`, `timeout`, `parse_error`, `unknown_error` |
| `http_status_code` | integer (nullable) | HTTP response code received |
| `error_message` | string (nullable) | Error detail if status is not `success` |

### 6.6 Scraping Approach

Engineering must determine per-competitor whether to use **API interception** (calling the competitor's internal API directly) or **browser automation** (controlling a headless browser). API interception is preferred where possible — it is faster, cheaper, and more stable. Browser automation is the fallback.

**Constraints that apply regardless of approach:**
- Never scrape from Truemeds' own IP ranges — use a separate proxy or cloud infrastructure
- Rotate IP addresses to avoid rate-limit-based blocking
- Randomize request timing within each hourly window — do not fire all requests simultaneously
- Scrape only publicly visible data — never authenticate or log in to competitor sites
- Respect each competitor's `robots.txt` as a good-faith measure

### 6.7 Scale

| Parameter | Value |
|---|---|
| Competitors | 4 |
| Pincodes | ~20,000 (Truemeds master list) |
| Products per pincode | 1 primary (+ up to 2 fallback retries) |
| Delivery options per product | Up to 2 (standard + express) |
| Refresh frequency | 24 times/day |
| Estimated scrape operations | ~2M/day (happy path); ~2.5M/day with fallback retries |

### 6.8 Failure Handling and SLAs

| Scenario | Required behaviour |
|---|---|
| Individual scrape job fails | Log job as `scrape_failed`; do not retry in the same cycle; retry in the next hourly cycle |
| A competitor's scraper is blocked for an entire cycle | Alert engineering within 15 minutes of the cycle completing with >10% failure rate for that competitor |
| Data for a pincode × competitor is older than 2 hours | Flag as stale in the jobs table; engineering to investigate |
| Normalization fails to parse `raw_text` | Log the raw text; set `promise_type = scrape_failed`; do not silently drop the record |
| Engineering SLA to fix a broken scraper | 4 hours during business hours (9 AM – 9 PM IST) |

---

## 7. Phase 2 — Extended Domains (Future)

Phase 2 uses the same scraping infrastructure to collect additional competitor data. Phase 1 engineering must design the architecture to accommodate these without requiring a rebuild.

| Domain | Strategic question | Likely owner |
|---|---|---|
| Pricing (MRP, selling price, effective price) | Is Truemeds more or less expensive than competitors per SKU? | Pricing / Revenue team |
| Discounts (% off, categories, promotional timing) | What are competitor promotional patterns? | Category / Growth team |
| SKU catalog (which products each competitor carries) | Where are Truemeds' catalog gaps vs competitors? | Merchandising / Category team |

**Architecture requirement for Phase 1:** The data pipeline and storage layer must be designed so adding a new data domain requires only adding new scraping logic and a new schema — not restructuring the existing delivery speed pipeline.

Phase 2 teams will write their own PRDs defining their specific data definitions, normalization rules, benchmark products, and refresh cadence.

---

## 8. Non-Functional Requirements

| Requirement | Specification |
|---|---|
| Data freshness | ≤1 hour for all active pincodes under normal operation |
| Storage | Time-series capable; must retain historical records (not overwrite); minimum 12 months retention |
| Observability | Per-competitor, per-cycle success/failure rates must be queryable |
| Data access | Raw and normalized tables must be accessible to analysts via SQL |
| Compliance | No login credentials stored or used; no Truemeds IP ranges used for scraping |

---

## 9. Open Questions for Engineering

| Question | Context |
|---|---|
| Which scraping approach (API interception vs browser automation) works for each competitor? | Needs per-competitor investigation; 1mg and PharmEasy were observed to block automated browsers immediately |
| What is the target data warehouse / storage layer? | Needs confirmation from data engineering; must support time-series queries and 12-month retention |
| How is the Truemeds master pincode list accessed and kept in sync? | Engineering needs the feed mechanism — file, API, database table |
| What proxy/IP rotation infrastructure will be used? | Determines cost and anti-blocking resilience |

---

## 10. Decisions Log

| Decision | Choice | Rationale |
|---|---|---|
| Range handling | Store `hours_min` and `hours_max` separately | Preserves full information; downstream consumers can decide which end to use |
| Express vs standard | Capture both as separate records | A customer picks the fastest option; capturing only standard would understate competitor capability |
| Pincode source | Truemeds master pincode list | Already exists; Phase 2 can expand to competitor-discovered pincodes if needed |
| Extended domains in PRD | Included as Phase 2 | Ensures Phase 1 architecture is designed for extensibility from day one |
| Benchmark product | Dolo 650 primary; Crocin 650mg and Limcee 500mg as fallbacks | Universal availability, OTC, not cold chain, stable year-round |
| Data surfacing | Deferred | Out of scope for this initiative |
| Build vs buy | Build | Full control over scraping logic and data pipeline |
