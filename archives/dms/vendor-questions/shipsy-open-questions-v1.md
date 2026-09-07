# Open Questions for Shipsy — DMS Capability Deep-Dive

A module-by-module question set for getting an exhaustive, verifiable read on what Shipsy's platform actually does today — built from the capability breakdown drafted for Locus, so both vendors get held to the same bar.

**Sources:**
- Locus PRD — `[PRD] DMS Integration`
- Locus Evaluation — LogiNext vs. Locus capability comparison
- Shipsy JTBD Map

94 questions across 10 modules.

---

## 01. Geography Setter

*JTBD: set up the delivery network and delivery routes. This is the foundation layer everything else (planning, driver assignment, sorting) depends on — so the questions here focus on how rigid or configurable Shipsy's model is, and what it validates versus leaves to us.*

**Cross-ref:** Locus PRD — Milestone 2 (Geography Setup); Locus Eval — Network & Path Planner, Route Former & Order Batcher

1. What is Shipsy's operational unit for grouping pincodes for planning and routing (its equivalent of a "zone")? Is it purely pincode-based, or tied to a rigid administrative hierarchy we'd have to conform to?
2. Does Shipsy enforce a naming convention for zones/hubs at the system level, or is naming left entirely to the operator with no server-side validation?
3. Can a pincode be moved from one zone to another as a single atomic action, or only via separate delete-then-insert steps? What happens to an order already in-flight for that pincode at the moment of reassignment?
4. Is pincode-to-zone mapping done via bulk CSV/API upload with per-row partial commit — i.e. do valid rows succeed even if others in the same batch fail — and what does the post-upload report look like?
5. Is hub/warehouse creation and editing available exclusively through API, or also through the dashboard? Which actions, if any, are dashboard-only?
6. When a hub is deleted, how are in-flight orders, active drivers, and in-flight mid-mile trips referencing that hub handled — is there a soft-delete or pending state, or is deletion immediate and disruptive?
7. Does Shipsy support a hub-and-spoke / distribution-centre (DC) model, including a concept of "eligible destination hubs" per hub, ahead of our planned DC expansion?
8. Does Shipsy validate hub coordinates against a valid lat/long range or against India's geography specifically? Does it block two hubs from being created at identical coordinates?
9. What is Shipsy's serviceability model — does it need to be told which pincodes are live, or does it track serviceability independently? Who ends up being the system of record?
10. Does Shipsy run a pre-activation check (e.g. "pincode must already be mapped to a zone and hub before it can go live"), or is that validation something we'd have to build ourselves?
11. What retry and backoff behaviour does Shipsy's geography API expose on failure, and is there a documented SLA for these calls?
12. Is there a full audit trail — who changed what, when — for every zone, pincode, and hub change, and is it accessible outside the dashboard (API or export) for our own reconciliation? *(Locus logs this to Redshift with action type, from/to values, user ID, and timestamp on every change.)*
13. Does route-skeleton generation use reverse geocoding, and does it return a confidence score per resolved address with the ability to self-learn and correct an address on repeat orders? **[Locus vs. LogiNext gap]** — our own evaluation found Locus offers confidence intervals + self-learning here where LogiNext doesn't; worth asking Shipsy directly rather than assuming parity.

---

## 02. Driver Manager

*JTBD: onboard drivers, manage their details, and control who is active on the platform. Emphasis here is on lifecycle integrity — what happens at the messy edges of onboarding, suspension, and termination, not just the happy path.*

**Cross-ref:** Locus PRD — Milestone 3 (Driver Module); Locus Eval — Driver Manager

1. What's the full driver data schema Shipsy captures at onboarding — identity documents, vehicle details, engagement type, eligible/blacklisted pincodes? Is at least one identity document mandatory, and can both be edited post-creation with no system lock?
2. Does Shipsy run duplicate-identity detection at both creation and edit time — e.g. blocking re-registration of an already-active driver against the same ID document?
3. Is a two-party maker-checker approval flow available for sensitive driver actions (like re-onboarding a previously terminated driver), and is it configurable per hub or only globally?
4. When a driver with an active trip is suspended or terminated, is enforcement automatically deferred until trip completion, or does it require manual ops follow-through to avoid disrupting an in-progress delivery?
5. Does Shipsy check for unreconciled COD cash before allowing a driver to be terminated?
6. Are termination, suspension, and unsuspension reason lists configurable by us, and is providing a reason mandatory for each action?
7. Is every driver lifecycle action — create, edit, suspend, unsuspend, terminate — available via API, not just the dashboard, so we can automate from our internal systems?
8. For bulk driver actions (e.g. bulk suspension), is each record processed independently so one failure doesn't block the rest of the batch?
9. Does Shipsy distinguish between a hard pincode constraint and a soft/preferred one at the driver level, or is eligibility always a strict allow-list?
10. If a driver's hub or eligible-pincode assignment changes while they have an active trip, does the change apply immediately or only from the next planning cycle?
11. Can drivers be typed separately for last-mile versus mid-mile (runner) roles, so the planning engine can route mid-mile hub-to-hub trips to a different driver pool than customer-facing deliveries?

---

## 03. Payout Manager

*JTBD: set up the earnings structure, compute driver earnings, and launch incentives. This is currently a fully manual process for us — so the bar here is genuinely functional payout logic, not just a rate field.*

**Cross-ref:** Locus PRD — Milestone 4 (Payout Manager); Locus Eval — Driver Manager (Bonus/Earning/Payout)

1. What earning structures does Shipsy natively support — just a flat per-order or per-km rate, or does it also support a minimum-guarantee-plus-per-order model and a salary-plus-per-km model, independently configurable per vendor/hub?
2. Beyond flat bonuses, does Shipsy support tiered attendance-based, tiered order-volume-based, route/pincode-specific, and ad-hoc/festival incentive types, each with independent eligibility rules?
3. Is there a cap on how many incentives a single driver can qualify for at once, or are payouts additive across every incentive they qualify for?
4. How does Shipsy define a "shift" for earnings purposes — bounded by an odometer reading, a login/logout event, or something else? What happens if the closing reading or event never arrives?
5. Does Shipsy push a webhook to our systems at the end of every completed shift with a computed earnings breakdown? What fields does that payload carry — base earnings, incentive earnings, orders delivered, distance travelled?
6. What's the retry policy if our endpoint fails to acknowledge an earnings webhook, and is there a manual re-trigger option on Shipsy's side if all automated retries are exhausted?
7. When we change an earning configuration mid-cycle, does the new config apply only from the next shift, or does it retroactively affect an in-progress one? What happens to incentive earnings already accrued against the old config — dropped, prorated, or paid out in full?
8. Is there a role-based split between who can create/edit an earning config versus who can only view it (e.g. separating Finance's read access from an Ops Admin's write access)?
9. What audit trail does Shipsy retain for incentive and earning-config changes, and for how long? Is driver earnings data treated as restricted-access financial PII?
10. Is incentive creation, deactivation, and list retrieval exposed via API, in addition to the dashboard?
11. Can drivers see their own earnings and incentive history in-app across a meaningful historical window, and can they flag a specific line item for ops review?
12. Does Shipsy support disbursing driver payouts directly to a wallet, or does disbursement stay a manual, offline process outside the platform?

---

## 04. Allocation Engine

*JTBD: resolve the customer's delivery location, select available drivers, batch orders into optimised groups, and allocate a batch to a driver. This is the core planning brain — the questions here probe both the algorithmic depth and what happens when the plan breaks mid-execution.*

**Cross-ref:** Locus PRD — Milestone 6 (Planning Engine); Locus Eval — Route Former & Order Batcher, Pickup & Dispatch Planner, Real-time Monitoring & Mid Route Replanner

1. How does Shipsy resolve a raw address into a deliverable location — what confidence tiers does it return, and what happens automatically to an order that resolves with low confidence?
2. Is there a configurable timeout on address resolution, and what state does an order sit in if resolution doesn't complete in time?
3. What happens to an order whose pincode isn't mapped to any zone — is it rejected before it ever enters the system, or does it enter and get parked/flagged afterward?
4. Does Shipsy support a distinct mid-mile leg (hub-to-DC) orchestrated separately from last-mile, with its own batching and runner assignment? How is a mid-mile batch that's only partially received at the destination hub handled?
5. Is driver-order matching based purely on hard eligibility rules, or does the engine also optimise for efficiency signals like orders-per-driver, rather than a fixed per-driver capacity cap?
6. Does Shipsy support configurable driver capacity limits by vehicle type, and are per-driver overrides possible — or is capacity fixed and uniform per vehicle type? *(Relevant internally: we're leaning toward a cost-optimisation model — higher orders/driver — rather than a fixed capacity model, so it's worth understanding how flexible Shipsy's model is on this axis specifically.)*
7. What happens when there are no eligible or available drivers for a zone at planning time — does the system block plan creation and alert ops, or degrade some other way?
8. Can dispatchers manually override the engine's plan after it's created — reassign a trip, add or remove an order, resequence stops — and is every override logged?
9. Is there a hard SLA-risk check at plan-creation time that flags a trip which mathematically can't complete within the promised delivery window before it's finalised?
10. What's the edit-lock model on a created plan — can orders still be added, removed, or resequenced after the driver has started, or only up to a certain trip milestone (first handover, departure)?
11. How is order cancellation handled at different trip stages — before departure, after departure, and whole-trip cancellation — and does the driver app reflect the change in real time without a restart?
12. Does Shipsy support real-time replanning — emergency mid-trip order injection by a dispatcher, or reassigning a driver's remaining stops if they report a breakdown mid-trip?
13. Is order ingestion idempotent — will Shipsy reject a duplicate `order_id`, and is every duplicate attempt traceable for reconciliation?
14. What retry/backoff behaviour applies if Shipsy is temporarily unavailable when we try to ingest an order, and what state does the order sit in on our side until ingestion succeeds?

---

## 05. Driver App

*JTBD: accept tasks, validate handover, start and end tasks, navigate, reschedule and resequence, collect cash payments, and view net earnings. This is the module with the most real-world failure surface — connectivity loss, crashes, refused payments — so the questions lean heavily on edge-case handling.*

**Cross-ref:** Locus PRD — Milestone 7 (Driver App & Execution Setup); Locus Eval — Driver Executor

1. How does the app validate handover from dispatcher to driver — barcode/QR scan, with a manual fallback (e.g. manual AWB entry) if the barcode is damaged or unreadable?
2. If a driver scans a box that resolves to an order not on their assigned trip, is that hard-blocked, or is there a dispatcher-discretion override for exigent circumstances?
3. Does the app enforce that trip start can't happen until every order in the plan is accepted, or can a dispatcher force departure with unaccepted orders left behind? Is that gated by an explicit warning and acknowledgement?
4. Does navigation only unlock for the next order in sequence, or can a driver navigate to any order regardless of planned order? What happens if the mapped location differs from the address ops has on file?
5. What's the default behaviour when a customer is unreachable at the door — is there a configurable hold period before the app automatically triggers a reschedule, and does a rescheduled order block trip completion?
6. Are resequencing and rescheduling distinct actions, each with independently configurable and mandatory reason codes, and is every such event logged and visible to ops in real time?
7. What proof-of-delivery methods does Shipsy support — photo capture, OTP, or both? Is there a fallback (e.g. a dispatcher-side manual skip) if a driver repeatedly can't complete POD, and is that skip event auditable?
8. If OTP-based POD is used, how is the OTP delivered to the customer, and what's the fallback if generation or delivery fails?
9. What payment gateways does Shipsy natively integrate with for COD/prepaid collection, and can it fall back to an externally-generated (Truemeds-issued) dynamic QR if a direct gateway integration isn't available for a given provider?
10. How is a prepaid order that's still unpaid by the time the driver marks "Arrived" handled — does it auto-convert to a COD flow, and is that conversion visible in the order record?
11. Is there a defined cash-reconciliation flow at trip completion — driver hands cash to a hub agent, reconciled against the app's COD order list — with discrepancies automatically flagged?
12. What real-time visibility does the dispatcher dashboard get into an active trip — live location, ETA per remaining stop, device battery level? What thresholds trigger a "stale location" or "route deviation" flag?
13. If a driver loses connectivity mid-trip, are in-progress actions (scans, delivery marks, POD capture) queued locally and synced automatically on reconnection? How are conflicts handled if the order's state changed on the server in the meantime — e.g. it was cancelled while the driver was offline?
14. On an app crash or forced restart mid-trip, does the app restore the last confirmed state from the server, with server state always treated as authoritative over anything cached locally?
15. Can drivers view a rolling window of past earnings in-app and flag a specific line item for ops review?
16. What's the suspended or terminated driver's exact in-app experience — is read-only access to earnings preserved after suspension, and how immediately is access revoked after termination?

---

## 06. Control Tower

*JTBD: configure custom alerts to monitor operational health, and fire alerts when thresholds are breached. Folded in here: exception classification and resolution routing, since it's a distinct capability in our broader taxonomy but doesn't have its own line in Shipsy's current module map.*

**Cross-ref:** Locus PRD — cross-references throughout M2–M7; Locus Eval — Exception Detector & Resolutor

1. What's the full catalogue of out-of-the-box alerts Shipsy can surface — location staleness, route deviation, SLA risk, unreconciled cash, orphaned zones/hubs — versus what would need custom configuration or isn't supported at all?
2. Can alert thresholds be configured per metric — e.g. "flag if location hasn't updated in over N minutes," or "flag a route deviation beyond X metres for Y minutes"?
3. Does Shipsy classify exceptions into pre-defined categories and offer configurable resolution playbooks per type, or is exception handling purely "surface it and let ops resolve manually"?
4. How are escalations routed — can we configure who's notified for which exception type or severity, and is there an SLA timer or auto-escalation if something goes unacknowledged?
5. Is there a single dashboard view that surfaces every unresolved configuration state — orphaned zones, hubs pending deletion, unresolved address failures — so ops isn't piecing it together across screens?
6. What's Shipsy's own alerting model for platform-side failures on their end — do we get proactively notified, or do we only find out when our own monitoring catches a symptom?
7. Are all alerts and their resolution actions logged and queryable for post-incident review?

---

## 07. Communications

> **Gap flagged:** this module doesn't have a line in our current Shipsy JTBD map, but it's a distinct capability in the broader taxonomy (Communications Manager) and a P0 item for Locus. Worth confirming explicitly whether it's a Shipsy capability or something we own end-to-end.

**Cross-ref:** Locus Eval — Communications Manager (Event Driven Messenger, Promise Aware Messenger, Audience Targeting, Channel Orchestration)

1. Does Shipsy send any customer- or driver-facing notifications natively — SMS, WhatsApp, push — on order-lifecycle events like dispatch, arrival, delivery, or reschedule? Or does it only fire webhooks for us to handle all outbound communication ourselves?
2. If Shipsy does send messages, can we configure the audience (customer vs. driver vs. internal ops) and the channel independently per event type?
3. Is there any concept of promise-aware messaging — cadence or content that adapts based on the delivery promise or current ETA — or is everything simply event-triggered with no promise awareness?
4. If Shipsy has no native messaging capability, does it expose enough event-level granularity via webhooks for us to build all customer and driver communications entirely on our own stack?

---

## 08. CRM & Access Control

*JTBD: access every module above, create roles with specific accesses, and control who can view, edit, or act on individual modules.*

**Cross-ref:** Locus PRD — Milestone 1 (Access Controls); Locus Eval — Personnel Manager

1. What's the full set of role-based access controls Shipsy exposes — can access be scoped down to a single warehouse or hub for a given user, preventing cross-warehouse visibility?
2. Can custom roles be created with granular, per-module view/edit/action permissions, or are roles limited to a small set of predefined templates?
3. Does every access grant, role change, and revocation fire a webhook or audit event — grantor, grantee, role, timestamp — that's queryable or exportable for our own audit systems?
4. Can we configure our own alerting on top of access changes, e.g. notifying a fixed distribution list whenever a role is upgraded or downgraded?
5. Does Shipsy support a "team" concept, letting multiple users at the same warehouse share visibility distinct from individual role assignment? **[Locus vs. LogiNext gap]** — our evaluation found this to be a clear Locus advantage over LogiNext; worth a direct comparison ask.
6. What happens to an access grant when the underlying user is off-boarded elsewhere — is there an automated deprovisioning hook, or is this fully manual on our side?

---

## 09. Integration & Data

*Cross-cutting: how Shipsy behaves as an integration partner, independent of any single module.*

1. Is full functional parity available via API for every module — driver management, payout, geography, planning — or are some actions dashboard-only? Which ones, specifically?
2. What retry/backoff behaviour does Shipsy apply when calling out to our systems (e.g. webhook delivery), and what's exposed to us when a call to Shipsy's API fails — standard error codes, documented rate limits, idempotency guarantees?
3. What's Shipsy's data retention policy for operational and audit-trail data — driver earnings records, access logs, order-level history — and does it meet financial/compliance retention requirements?
4. Does Shipsy support a sandbox or staging environment for us to test integration changes before they go live in production?
5. What uptime/SLA commitment does Shipsy offer, and what does their incident-response and status-communication process look like?
6. Can we pull historical or operational data out of Shipsy in bulk — export or warehouse-level access — for our own analytics, rather than relying solely on real-time webhooks?

---

## 10. Governance & Commercials

*Cross-cutting: support model, delivery timeline, and pricing structure — plus the one question specific to Shipsy's history with us.*

1. What does the standard support and escalation model look like — is there a named CSM or account manager, and what SLA applies to P0 versus lower-severity issues?
2. What's Shipsy's typical implementation timeline for a migration of this scope — a multi-module DMS rollout phased across zones and warehouses — and what's expected of us versus them during setup?
3. How is pricing structured — per order, per driver, per module, or blended — and does cost scale predictably as we expand from non-DC to DC pincodes and grow order volume?
4. Are there capabilities in this document that would require a custom build or a separate paid add-on rather than being included out of the box?
5. We previously ran production hyperlocal volume on Shipsy and moved away citing manual batching, weak address resolution, no execution monitoring, and no handover validation. What's changed on the platform since then, specifically in those four areas?
