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

