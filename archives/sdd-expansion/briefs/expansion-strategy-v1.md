# SDD Expansion Strategy

**Author:** Tejas Bhalerao | **Date:** 2026-08-12 | **Status:** Draft v1

---

## Why This Matters

SDD is Truemeds' sharpest competitive weapon in hyperlocal markets. Where we offer it, we win on speed. Where we don't, we lose conversion — often silently, because the customer never checks out.

The goal is not just to expand SDD — it's to run it where it's worth running and pull back where it isn't. This doc defines the framework for making that call, pincode by pincode.

**Decision this will drive:** Pincode activation and deactivation list for Q3/Q4 ops planning.

---

## The Levers

Every expansion or scale-down decision reduces to eight signals. Each lever answers a different question about whether a pincode should be activated, held, or wound down.

| Priority | Lever | Question it answers |
|---|---|---|
| P0 | **Traffic** (orders + carts) | Is there real demand here, or just potential? |
| P0 | **Geography** (pincode) | Can we physically reach this pincode from an existing hub? |
| P0 | **Willingness to adopt** (demand experiment) | Would customers actually switch to SDD if offered? Show "today / tomorrow" options and measure conversion lift vs. baseline. |
| P1 | **Cost of expansion** | Will Truemeds be profitable here? Includes route density (delivery executive expenses) and hub setup costs if new infrastructure is needed. |
| P1 | **Competition speed** | Are competitors already offering SDD here? Informs whether expansion puts Truemeds on par or ahead — and may further lift traffic and adoption. |
| P2 | **Basket quality** | Is the demand high-margin? Margin improvement is secondary — cart team owns upsell/cross-sell to close any gap. |
| P2 | **OTD% in active pincodes** | Are we meeting the promise where we're live? Not a decision gate — a callout to ops to strengthen rigor before or during expansion. |

P0 levers are applied in sequence — Traffic → Geography → Willingness to adopt. A pincode that fails any P0 gate is not evaluated further. P1 levers determine profitability and competitive urgency. P2 levers are signals, not blockers.

---

## Execution Sequence

| Step | Work | What it needs |
|---|---|---|
| 1 | **Traffic** | Internal OMS data — pull and analyse |
| 2 | **Geography** | Hub locations + pincode distance calculation |
| 3 | **Competition speed** | CIP Phase 1 data *(external dependency — steps 4 and 5 should not wait if CIP slips)* |
| 4 | **Cost of expansion** | Ops + Finance: network design, route calculation, hub setup cost modelling |
| 5 | **Willingness to adopt** | Production experiment: show "today / tomorrow" delivery options, measure conversion lift |

Steps 1–3 are data-driven and can be executed as soon as inputs are available. Step 4 requires ops and finance involvement — network design, route calculation, and hub cost modelling. Step 5 requires a production experiment. **Steps 4 and 5 run in parallel.**

---

## Lever 1: Traffic (Orders + Carts)

**What we're trying to answer:** Does a pincode have enough real demand to justify SDD?

Traffic is the first filter. We look at two signals — orders (confirmed demand) and carts (intent that didn't convert). Together they tell us both where customers are buying today and where they're showing interest but not completing.

**Data points to pull (trailing 90 days, per pincode):**

| Signal | Source | Why it matters |
|---|---|---|
| Courier Forward order count | Internal OMS | Confirmed demand — customers already buying from Truemeds |
| Cart creation count | Internal OMS | Intent signal — demand that may convert with faster delivery |
| Cart abandonment rate | Internal OMS | High abandonment in a pincode may indicate delivery speed is a blocker |
| Unique customer count | Internal OMS | Distinguishes broad demand from a few high-frequency buyers |

**Threshold:** A pincode clears the traffic gate if order volume crosses a minimum threshold (to be calibrated with Kartik — likely in the range of X orders/month to sustain route density). Carts are a supporting signal, not the primary gate.

**Output:** A ranked list of non-SDD pincodes by order volume, with cart data as a secondary column. This is the input to Lever 2 (Geography).

**Owner:** Ashish (data pull) + Tejas (analysis and threshold calibration with Kartik).

---

## Lever 2: Geography (Pincode)

**What we're trying to answer:** Can we physically serve this pincode from an existing hub within a viable time window?

Geography is a hard constraint, not a scoring lever. A pincode either falls within reach of a hub or it doesn't. This filter is applied to the traffic-qualified list from Lever 1.

**Data points to pull, per pincode:**

| Signal | Source | Why it matters |
|---|---|---|
| Distance from nearest hub (km) | Analytics — pincode centroid to hub lat/long | Primary reachability check |
| Estimated travel time to pincode | Maps API | Distance alone is misleading in dense cities; travel time is the real constraint |
| Nearest hub name + current zone coverage | Ops / Locus | Determines if pincode can slot into an existing zone or needs a new one |
| Hub capacity headroom | Ajit / Mukesh | A reachable hub that's at capacity cannot absorb new pincodes |

**Threshold:** Max hub-to-pincode travel time to be defined by Ops (expected: 30–45 mins). Pincodes within range but requiring a new zone trigger an M2 geography setup dependency before activation.

**Output:** Traffic-qualified pincodes tagged as — within reach (existing zone), within reach (new zone needed), or out of reach. Out-of-reach pincodes are moved to the invest-first backlog for future hub placement decisions.

**Owner:** Ashish (distance + travel time calculation) + Ajit/Mukesh (threshold and capacity confirmation).

---

## Lever 3: Competition Speed

**What we're trying to answer:** Are competitors already offering SDD in this pincode, and how does their promise compare to ours?

This lever adds strategic urgency to the ranked list. A pincode where a competitor offers same-day delivery and Truemeds doesn't is an active conversion loss — not a hypothetical one. These pincodes should be prioritised within the shortlist produced by Levers 1 and 2.

**Data points to pull, per pincode:**

| Signal | Source | Why it matters |
|---|---|---|
| Competitor SDD availability (Y/N) | CIP Phase 1 | Flags active competitive threat |
| Competitor promised delivery window (hours) | CIP Phase 1 | Quantifies the gap — how far behind are we? |
| Number of competitors offering SDD | CIP Phase 1 | Multiple competitors = higher urgency |

**Threshold:** No hard gate — this lever adjusts priority within the shortlist. Pincodes with ≥1 competitor offering SDD are elevated. Pincodes where Truemeds would be fastest move to the top.

**Dependency:** CIP Phase 1 must be live before this lever can be run. Steps 4 and 5 (Cost of Expansion and Willingness to Adopt) should not wait on CIP if it slips.

**Output:** Shortlist from Levers 1–2 re-ranked by competitive urgency. This feeds into the final prioritisation alongside Lever 4.

**Owner:** Tejas (analysis, once CIP data is available).

---

## Lever 4: Cost of Expansion *(runs parallel with Lever 5)*

**What we're trying to answer:** Will Truemeds be profitable in this pincode if SDD is activated?

Cost of expansion has two components: ongoing delivery costs (driven by route density) and one-time setup costs (hub infrastructure, if needed). Both must clear for a pincode to be a viable activation candidate.

**Data points to model, per pincode:**

| Signal | Source | Why it matters |
|---|---|---|
| Projected orders/shift (from traffic data) | Ashish + Finance | Route density — fewer than ~8–10 drops/shift makes SDD loss-making |
| Cost per delivery for SDD | Finance | Delivery executive cost + last-mile overhead |
| Break-even order volume | Finance | Minimum orders/month for the pincode to be unit-economically viable |
| Hub setup cost (if new hub needed) | Ops + Finance | One-time capital cost; relevant only for invest-first pincodes |
| Payback period | Finance | How long before a new-hub pincode recovers setup cost |

**Threshold:** A pincode clears this gate if projected order volume exceeds the break-even threshold at current SDD cost structure. Pincodes requiring a new hub are evaluated separately on payback period.

**Output:** Each shortlisted pincode tagged as — profitable at current volume, profitable with moderate growth, or requires infrastructure investment with X-month payback. This is the final filter before activation.

**Owner:** Kartik + Finance (unit economics, break-even modelling) + Ajit/Mukesh (route design inputs).

---

## Lever 5: Willingness to Adopt *(runs parallel with Lever 4)*

**What we're trying to answer:** If we offered SDD in this pincode today, would customers actually use it?

Traffic tells us customers are buying. This lever tests whether they would change their behaviour — convert more, abandon less — if same-day delivery were available. It's the demand validation step before committing infrastructure spend.

**Approach:** Run a controlled experiment in shortlisted pincodes. Show treatment group a "today / tomorrow" delivery choice at checkout; show control group the current courier promise. Measure behaviour delta.

**Metrics to track:**

| Metric | What a positive result looks like |
|---|---|
| Checkout conversion rate | Treatment group converts at higher rate than control |
| Cart abandonment rate | Lower abandonment in treatment group |
| SDD selection rate | % of treatment group that actively chooses same-day |
| Order volume uplift | Incremental orders in treatment pincodes during experiment window |

**Threshold:** A meaningful conversion lift (threshold to be defined — indicatively ≥5% relative uplift) confirms latent demand. Pincodes with no measurable lift are deprioritised even if traffic qualifies them.

**Dependency:** Requires engineering to ship the experiment variant (today/tomorrow prompt at checkout). Should be scoped and queued for development in parallel with the cost modelling work.

**Output:** Per-pincode demand uplift score. Combined with Lever 4 cost output, this produces the final activation recommendation: high uplift + viable cost = activate; high uplift + cost requires hub investment = invest-first; low uplift = defer.

**Owner:** Tejas (experiment design) + Engineering (implementation) + Ashish (analysis).
