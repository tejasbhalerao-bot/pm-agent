# Background

## Decision
Leadership has decided to build the rider app and its supporting portals (such as the CRM dashboard) in house, and to end the dependency on Shipsy.

## Why
- Shipsy serves many larger clients. When Truemeds raises an issue, responsiveness, bias to action and resolution are low.
- What Shipsy offers is largely rudimentary and can be built internally.
- Its more advanced capabilities are promises that may not be delivered. Integrating them and then finding them useless wastes effort. A 0-to-1 build takes longer but is more likely to get it right.
- The dependency will hurt more as Truemeds scales. Serving locations (FCs, MFCs and DCs) grow from 39 to 150 in the next 15 months, and the share of orders on Shipsy is projected to rise from 30% to above 50%, through organic and inorganic growth.

## What we are replacing
Shipsy handles today:
- Rider creation
- Allocation of riders to orders
- The rider's execution flow in the app
- Tracking and reporting through its portal

## Approach
- Build 0 to 1, with no dependence on existing systems.
- Build a parity version, then cut over location by location.
- Cover Hyperlocal Forward and Hyperlocal Reverse.
