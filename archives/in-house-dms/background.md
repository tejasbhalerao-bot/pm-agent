# Background (as told by the PM, 2026-10-24)

**Decision:** Leadership has decided to build the entire rider app and the supporting portals (CRM dashboard etc.) in house, removing the third-party dependency on Shipsy and moving everything internal.

**Why:**
- Shipsy has many more clients and much larger scale than Truemeds. When Truemeds approaches Shipsy, responsiveness, bias to action and resolution are low.
- Leadership's view is that what Shipsy offers is rudimentary and can be built internally.
- Third-party dependency hurts more as Truemeds scales. Serving locations (FCs, MFCs, DCs) are planned to grow from 39 to 150 in the next 15 months.
- Over the same 15 months, the share of orders on Shipsy is projected to grow from 30% to above 50%, from both organic order growth and the inorganic growth that follows from the expansion.

- Leadership also sees that the non-rudimentary parts of Shipsy are promises that may not be delivered. Integrating and getting them running, then finding them useless, is wasted effort. Building 0 to 1 may take longer but has a higher chance of getting it right.

**Scope:** Rider app plus supporting portals, built in house. All systems are affected and new systems will be created as the project progresses.

**Framing:** This is a completely new 0 to 1 journey. No other existing context needs to be considered or carried in.

**What Shipsy handles today (the parity baseline):**
- Rider creation
- Rider allocation to orders
- Rider execution flow via the app
- Tracking and reporting via the Shipsy portal

**Migration approach:** Build a parity version, then cut over location by location.
