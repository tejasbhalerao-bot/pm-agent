# Truemeds PM Agent Context

## Organization

### Team Structure
- Akshat: CEO
- Kunal: COO
- Anbu: VP Product
- Kartik: Director Operations - Logistics
- Ajit: Manager - Logistics Operations
- Mukesh: Manager - Logistics Operations
- Ashish: Analyst
- Dinesh: Director - Analytics
- Fahad: SDE 3
- Mangesh: VP Engineering
- Deepak: VP Engineering
- Hasan: Principal Engineer
- Priya: QA
- Roshan: SDET
- Loganathan: SDE 1
- Mehul: SDE 2
- Pankaj: SDE 3
- Sumit: Control Tower
- Rajendran: SCM Lead
- Atul: AVP SCM
- Kekin: VP Ops SCM
- Rahul: VP Strategy

## Business Verticals
- Hyperlocal Forward
- Hyperlocal Reverse
- Courier Forward
- Courier Reverse
- B2B Forward
- B2B Reverse

## Logistics Systems
- Serviceability
- Allocation
- Tracking (Actuals)
- Promise (ETA)
- 3rd Party Rails (Clickpost, Locus)

## Current Priorities
[Add your Q2 2026 priorities]

## Key Metrics
[Add your key metrics]

## Workflow Entry Point
All PM workflows start at `~/pm-agent/workflows/supporting/recall-and-route.md`.

For every PM task, load the relevant workflow file from `~/pm-agent/workflows/` using the Read tool.
Do NOT invoke built-in skills (anthropic-skills:*, pm-execution:*, or any Skill tool equivalent) for any task this repo handles.
Built-in skills lack DMS domain context, the 5-pass framework, changelog amendments, and chain gate logic — they produce superficially similar but structurally inferior output with no warning.

