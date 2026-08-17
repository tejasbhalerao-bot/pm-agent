# Competitor Intelligence Platform — PRD

**Version:** v4
**Date:** 2026-08-12
**Status:** Draft
**Author:** Tejas Bhalerao (Logistics PM)
**Horizon:** Phase 1 — Delivery Speed | Phase 2 — Pricing, Discounts, SKU Catalog

---

## 1. Overview

This PRD defines the requirements for building a Competitor Intelligence Platform (CIP) — an automated scraping and data pipeline system that collects, normalizes, and stores competitor data at pincode level.

**Phase 1** (this PRD, Logistics PM ownership): Competitor delivery speed promises, by pincode, refreshed hourly.
**Phase 2** (separate PRDs, other team ownership): Pricing, discounts, and SKU catalog — using the same infrastructure built in Phase 1.

The platform's output is a queryable dataset. It does not include dashboards or alerts — those are downstream consumers, defined separately.

---

## 2. Problem Statement

Truemeds competes for customers on delivery speed. For any given pincode, if a competitor promises faster delivery than Truemeds, we lose that customer before they even check out. If Truemeds is faster, we win.

Today there is no systematic, always-fresh view of what competitors promise at pincode level. Decisions about where to invest in logistics and where to focus acquisition are made without this data. We know we are missing opportunities — we do not know where or how many.

The platform resolves this by continuously collecting competitor delivery speed promises and making the data available to analysts and downstream teams.

---

## 3. Goals and Success Metrics

### Goals

| Goal | Description |
|---|---|
| Continuous data collection | Scrape competitor delivery speed promises every hour across all pincodes in Truemeds' master list |
| Normalized comparison | Convert all competitor delivery formats into a common unit (hours) so Truemeds vs competitor comparisons are possible |
| Reliable pipeline | Detect and alert on scraper failures within 15 minutes; maintain data freshness SLA of ≤1 hour |
| Extensible architecture | Design storage and pipeline so Phase 2 domains (pricing, discounts, SKU) can be added without rebuilding the foundation |

### Success Metrics

| Metric | Target | Timeframe | Why this number |
|---|---|---|---|
| Scraper uptime per competitor | ≥95% of hourly cycles complete successfully | 30 days post-launch | Below 95%, data gaps become large enough that trend analysis produces misleading results — a missed cycle creates a 2-hour blind spot |
| Pincode coverage | ≥98% of master list pincodes have a fresh record (≤1 hour old) at any given time | 30 days post-launch | 2% tolerance accounts for transient ISP/pincode-level failures; higher gaps mean logistics decisions are based on incomplete geography |
| Normalization success rate | ≥99% of `has_promise` records successfully parse to `hours_min` / `hours_max` | 30 days post-launch | Unparsed records are unusable for comparison; a 1% miss rate is ~20K records/day — acceptable for now, tracked to improve |
| Alert latency | P95 time from scraper failure to engineering alert ≤15 minutes | 30 days post-launch | A 4-hour resolution SLA only works if engineering knows about failures within 15 minutes; longer alert delay wastes the SLA window |
| Data availability | Analysts can query normalized delivery data via SQL within 1 business day of launch | Day 1 | SQL access is the only consumption path until a dashboard is built; blocking this blocks all downstream use |

**First decision this data will inform:** Q3 pincode prioritization for dark store / spoke expansion. The Logistics team will use pincode-level delivery gap data (Truemeds slower than competitor X by ≥4 hours) to identify the highest-leverage pincodes for new node placement. This decision is targeted for Q3 planning — the platform must be live and stable before that cycle starts.

---

## 4. Out of Scope

| Item | Note |
|---|---|
| Data surfacing (dashboards, alerts, reports) | Deferred to a separate initiative; no owner or timeline yet. On Day 1, consumers query raw tables via SQL |
| Scraping data that requires user login | Platform only scrapes publicly visible data |
| Pricing, discounts, SKU catalog | Phase 2; architecture must support them but Phase 1 does not build them |
| Truemeds' own delivery speed data | Although Truemeds' delivery speed data exists in internal systems, it is not ingested by this platform. However, for every competitor × pincode × SKU record scraped, the corresponding Truemeds delivery speed for that same SKU and pincode at that point in time must also be pulled from the internal system and stored alongside the competitor record. This enables direct like-for-like comparison without a separate join |

---

## 5. Competitors in Scope

Website URLs are to be confirmed and provided by the Logistics PM before build begins. Engineering must not hardcode any URL until the confirmed list is handed over.

| Competitor | Site |
|---|---|
| Tata 1mg | TBD |
| Netmeds | TBD |
| Apollo | TBD |
| PharmEasy | TBD |

---

## 6. Risks

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Competitor ToS violation / legal notice | Medium | High | Legal review before launch; scrape only public data; no login; document good-faith measures (robots.txt respect, IP rotation, no overloading). If a competitor sends a cease-and-desist, we stop scraping that competitor and assess |
| Scraper blocking (IP ban, CAPTCHA, bot detection) | High | Medium | IP rotation via proxy infrastructure; randomized timing; per-competitor anti-blocking strategy determined during engineering spike |
| Data normalization failures (unparseable raw text) | Medium | Low | Raw text always stored; normalization failures flagged; reprocessing possible without re-scraping |

---

## 7. Phase 1 — Delivery Speed

### 7.1 Pincode Coverage

- **Source:** To be provided by Ops. Engineering must not hardcode pincode values
- **Scope:** All pincodes in the master list — not limited to Truemeds-serviceable ones
- **Live input:** The pincode list must be treated as a live input, not a hardcoded value. When the master list is updated, the scraper automatically picks up new pincodes on the next run cycle. Engineering must confirm the feed mechanism with Ops (file, API, or database table)

### 7.2 Benchmark Products

The list of benchmark products is to be provided and maintained by Ops, based on procurement ease. Engineering does not define or hardcode the product list.

Ops will organize products into three procurement-ease buckets:

| Bucket | Description |
|---|---|
| Easy to procure | Products that are consistently available across all competitors and all pincodes |
| Slightly difficult to procure | Products that are available in most but not all pincodes or competitors |
| Difficult to procure | Products that may be unavailable in some pincodes or with some competitors |

**Rotation logic:** Each day, the system rotates through the products such that every bucket is represented in every hourly scrape cycle. The rotation schedule is determined by engineering based on the product list provided by Ops. The goal is to capture data for at least one product from each bucket per pincode × competitor per hour.

**Fallback logic (within a cycle, if the selected product is out of stock):**

```
1. Attempt the day's assigned SKU for this pincode × competitor
2. If out_of_stock → move to the next SKU in the product list (cycling through the full list in order)
3. Keep cycling until a SKU returns a delivery promise (has_promise) or not_serviceable
4. Record the SKU that successfully returned a result in product_sku
5. If the entire product list is exhausted without a result, record promise_type = scrape_failed
```

Each fallback attempt is a new HTTP request within the same scrape cycle. It is not a new queued job.

### 7.3 Refresh Cadence

- **Frequency:** Every 1 hour
- **Rationale:** Competitor delivery promises change intraday as dispatch cutoffs pass. Hourly cadence captures these shifts
- **Distribution strategy:** With ~80,000 jobs per cycle (20,000 pincodes × 4 competitors), spread jobs using a random per-job delay sampled uniformly from [0, 3600] seconds. This distributes load evenly across the hour and avoids traffic spikes that trigger rate limiting. Engineering may replace this with a queue-based scheduler — the requirement is even distribution, not the specific implementation

### 7.4 Data to Capture

For each competitor × pincode × product combination, capture the following.

#### Delivery record (one row per scrape result)

| Field | Type | Nullable | Description |
|---|---|---|---|
| `id` | UUID | No | Primary key |
| `competitor` | enum | No | Values as per confirmed competitor list (Section 5) |
| `pincode` | string(6) | No | 6-digit pincode |
| `product_sku` | string | No | The SKU that returned a result (may be a fallback SKU, not the originally assigned one) |
| `product_category` | enum | No | Procurement-ease bucket of the SKU used: `easy`, `slightly_difficult`, `difficult` |
| `scraped_at` | timestamp (IST) | No | Exact time the scrape executed, in Indian Standard Time |
| `option_type` | enum | No | `standard`, `express` |
| `promise_type` | enum | No | See promise types below |
| `raw_text` | string | Yes | Exact text shown on the competitor's site, unmodified |
| `hours_min` | integer | Yes | Lower bound of delivery promise in hours from `scraped_at`. Null when `promise_type` ≠ `has_promise` |
| `hours_max` | integer | Yes | Upper bound of delivery promise in hours from `scraped_at`. Null when `promise_type` ≠ `has_promise` |
| `truemeds_hours_min` | integer | Yes | Truemeds' own delivery promise lower bound for this same SKU + pincode at `scraped_at`, pulled from internal systems. Null if unavailable |
| `truemeds_hours_max` | integer | Yes | Truemeds' own delivery promise upper bound for this same SKU + pincode at `scraped_at`, pulled from internal systems. Null if unavailable |

#### Promise types

| `promise_type` | Meaning | `hours_min` / `hours_max` |
|---|---|---|
| `has_promise` | Competitor showed a delivery time | Populated |
| `not_serviceable` | Competitor does not deliver to this pincode at all | Null |
| `scrape_failed` | Scrape attempt failed (blocked, timeout, parse error, product list exhausted, etc.) | Null |

**When both standard and express options are shown:** create two separate records for the same pincode × product × scrape — one with `option_type = standard`, one with `option_type = express`.

#### Normalization rules

All delivery promises must be converted to hours elapsed from `scraped_at`. The normalization step runs after the scrape, as a separate processing step (not inside the scraper itself — see Section 7.5).

| Raw text example | Scraped at (IST) | `hours_min` | `hours_max` | Notes |
|---|---|---|---|---|
| "Get it by Tomorrow, 10 PM" | 2:00 PM | 32 | 32 | Single future time — `hours_min` = `hours_max` |
| "Delivery in 2–3 days" | any | 48 | 72 | Range → store both ends separately |
| "Same day delivery" | 2:00 PM | 0 | 10 | `hours_min` = 0; `hours_max` = floor(hours until 11:59 PM that day) = 23:59 − 14:00 = ~10h |
| "Delivered by Aug 7" | Aug 5, 2:00 PM | 48 | 48 | Specific date, no time — `hours_min` = `hours_max` = hours until EOD of that date |
| "Delivery in 4 hours" | any | 4 | 4 | Precise hours — `hours_min` = `hours_max` |

**Rules:**
- **Single date or time given (no range):** `hours_min` = `hours_max`. This applies to any promise with one specific future time or date
- For ranges, store `hours_min` as the lower bound and `hours_max` as the upper bound — do not compute a midpoint
- For vague same-day promises ("Same day delivery", "Delivered today", "Order now, get today"): `hours_min` = 0; `hours_max` = number of whole hours remaining until 11:59 PM IST on the day of `scraped_at`
- If normalization logic cannot parse `raw_text`, set `promise_type = scrape_failed` and log the failure — do not silently drop the record
- Always store `raw_text` — it enables reprocessing if normalization logic has a bug

### 7.5 Processing Architecture (Two Stages)

The pipeline has two stages to keep scraping and normalization concerns separate. These are **two separately deployed services**, not two functions in the same process.

**Stage 1 — Scraper service:**
- Triggered on a schedule (once per hour per pincode × competitor job)
- Fetches the competitor page, extracts `raw_text`, determines `promise_type`
- Executes fallback SKU logic if the assigned SKU is out of stock (see Section 7.2)
- Writes a raw record to the store with `hours_min` and `hours_max` left null
- Also fetches the corresponding Truemeds delivery data from internal systems for the same SKU + pincode and writes `truemeds_hours_min` / `truemeds_hours_max`
- Does not compute competitor hours — it only knows what the page said

**Stage 2 — Normalizer service:**
- Triggered automatically after each scrape cycle completes (once per hour, after Stage 1 finishes)
- Reads all raw records from the current cycle where `hours_min` is null and `promise_type = has_promise`
- Parses `raw_text`, computes `hours_min` / `hours_max`, writes back to the record
- Can be re-run independently on historical records without re-scraping

**Why separate services:** A normalization bug can be fixed and the normalizer re-run against stored raw text. If scraping and normalization were one step, fixing a parsing bug would require re-hitting competitor sites, which burns scrape quota and risks further blocking.

**Handling new unparseable delivery phrases:**
When the normalizer encounters a `raw_text` string it cannot parse, it must:
1. Log the unparseable string and flag the record as `promise_type = scrape_failed`
2. Write the raw text to a dedicated `unparseable_phrases` log table (fields: `raw_text`, `competitor`, `first_seen_at`, `occurrence_count`)
3. Generate a weekly summary report (or alert if occurrence count exceeds 500 in a single cycle) for Product to review

Product reviews unparseable phrases and adds the interpretation to the normalizer's convention table — this is not an engineering-only decision, as the mapping involves business interpretation. Engineering does not invent mappings unilaterally.

### 7.6 Scrape Jobs Table

Every scrape attempt is logged as a job, independently of whether it succeeds. This is the primary observability surface for the pipeline.

| Field | Type | Nullable | Description |
|---|---|---|---|
| `id` | UUID | No | Primary key |
| `competitor` | enum | No | Which competitor was scraped |
| `pincode` | string(6) | No | Target pincode |
| `product_sku` | string | No | Originally assigned benchmark product (before any fallback) |
| `scheduled_at` | timestamp (IST) | No | When this job was scheduled to run |
| `started_at` | timestamp (IST) | Yes | When scraping actually began |
| `completed_at` | timestamp (IST) | Yes | When scraping completed (success or failure) |
| `status` | enum | No | `success`, `blocked`, `timeout`, `parse_error`, `unknown_error` |
| `http_status_code` | integer | Yes | HTTP response code received |
| `error_message` | string | Yes | Error detail if status is not `success` |

### 7.7 Scraping Approach — General Guidelines

Engineering determines per-competitor whether to use **API interception** (calling the competitor's internal API directly) or **browser automation** (controlling a headless browser). API interception is preferred — it is faster, cheaper, and more stable. Browser automation is the fallback.

Engineering must complete a spike (≤1 week) confirming which approach works per competitor before the scraper is built.

**Constraints that apply regardless of approach:**
- Never scrape from Truemeds' own IP ranges — use dedicated proxy or cloud infrastructure
- Rotate IP addresses to reduce rate-limit-based blocking risk
- Randomize request timing within each hourly window (see Section 7.3)
- Scrape only publicly visible data — never authenticate or log in to competitor sites
- Respect each competitor's `robots.txt` as a good-faith measure

### 7.8 Scale

| Parameter | Value |
|---|---|
| Competitors | As per confirmed list (Section 5) |
| Pincodes | Per Ops-provided master list (est. ~20,000) |
| Jobs per cycle | Pincodes × Competitors |
| Cycles per day | 24 |
| Estimated scrape operations | ~2M/day (happy path); higher with fallback SKU retries |
| Estimated new rows per month | ~60–75M (subject to final competitor and pincode count) |

### 7.9 Failure Handling and SLAs

| Scenario | Required behaviour |
|---|---|
| Individual scrape job fails | Log job as failed with status detail; do not retry in the same cycle; automatically retries in the next hourly cycle |
| A competitor's scraper fails for an entire cycle (>10% failure rate) | Alert engineering within 15 minutes of the cycle completing |
| Data for a pincode × competitor is older than 2 hours | Mark as stale in the jobs table; engineering to investigate |
| Normalization fails to parse `raw_text` | Log the raw text; set `promise_type = scrape_failed`; do not silently drop the record |
| Engineering SLA to restore a broken scraper | 4 hours during business hours (9 AM – 9 PM IST) |

---

## 8. Non-Functional Requirements

| Requirement | Specification |
|---|---|
| Data freshness | ≤1 hour for all active pincodes under normal operation |
| Storage | Append-only; must retain historical records; minimum 12 months retention; SQL-queryable |
| Observability | Per-competitor, per-cycle success/failure rates must be queryable in the jobs table |
| Data access | Normalized delivery records must be accessible to analysts via SQL from Day 1 |
| Legal compliance | No login credentials stored or used; no Truemeds IP ranges used for scraping; legal review required before production launch |
| **Launch gate** | **The platform does not go to production until written legal sign-off is received and documented. Engineering must not deploy to production without it.** |
