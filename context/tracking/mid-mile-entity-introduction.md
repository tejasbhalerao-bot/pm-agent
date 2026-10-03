---
title: Mid-Mile Entity Introduction
source: https://docs.google.com/document/d/1hETlNLEX0ngk5SjI5tTJ5d_T2IQVuirsTGPv0E3CwMg/edit
type: past-prd
verticals: [hyperlocal-forward, hyperlocal-reverse]
systems: [tracking]
updated: 2026-09-10
---

# v1

# [PRD] Mid-Mile Entity Introduction

## Objective

Establish Delivery Zones and DCs — and their mappings to Pincodes, WHs, and Hubs — as canonical, governed entities within Truemeds' logistics stack, so that every mid–mile movement (forward and reverse) has a resolvable, auditable path from origin warehouse to last–mile hub, independent of and prior to any downstream system (including DMS) consuming this configuration.

## Rationale

Today, mid–mile network topology — which DC feeds which warehouse, which delivery zone is served by which hub — exists only as tribal knowledge and ad hoc spreadsheets. There is no canonical system of record, no CRUD governance, and no audit trail for changes to this topology.

As a result, whenever someone has to trace back where, when, and how, for an order, it becomes extremely difficult to establish a chain of traceability.

As Truemeds' mid–mile footprint (DCs, warehouses) continues to grow, resolving this now — before network complexity compounds — prevents both operational failures and a costly downstream reconciliation problem across systems that will increasingly depend on this topology.

Within the next 2 months, we are expected to nearly double our DC footprint – from the current 20 DCs to 50 DCs. As a result of this expansion, we are expected to reach the following milestones:

- Shipsy Order Share: 25% -> 35%

Timeline for landing this growth: September ‘26 -> March ‘27

DC Release Milestones: Open

## Network Topology

**Path Type 1:** Warehouse -> DC -> Delivery Zone -> Pincode -> Customer

**Path Type 2:** Warehouse -> Delivery Zone -> Pincode -> Customer

**Path Type 3:** Warehouse -> DC -> DC -> Delivery Zone -> Pincode -> Customer

## Use Cases

### Use Case 1: CRUD Operations to Delivery Zones

- Every zone must have the following parameters at all points in time.

| **Parameter** | **Definition** | **Data Type** |
| :-: | :-: | :-: |
| Zone ID | Unique identifier of the zone. Auto created by the system. | Integer |
| Zone Name | Unique name of the zone which will be used as the canonical identifier. | String |
| Zone Alias | Nickname with which the zone will be referenced. | String |

- CRUD operations on a zone need to happen through the existing bulk upload mechanism.
- **Zone Alias Rule:** 3 letter configuration only. Anything else gets rejected in the bulk upload.
- CRUD Rules:

| **Action** | **Does Zone Exist?** | **Note** |
| :-: | :-: | :-: |
| Insert | No | The system mandates the presence of all 3 parameters. |
| Insert | Yes | The system silently ignores insert instructions and performs updates. |
| Update | No | The system rejects the configuration and prompts reupload. |
| Update | Yes | The system performs an update action only on the parameters provided. The presence of zone ID is mandated with an update action. |
| Delete | No | The system silently ignores delete instructions. |
| Delete | Yes | The system performs a delete action. The presence of zone ID is mandated. No other parameters are mandatory to be provided. |

### Use Case 2: Pincode to Delivery Zone Mapping

- Every delivery zone is required to have pincodes mapped against it. Without this mapping, the existence of a delivery zone is meaningless.
- Similar to Use Case 1, the system accepts configurations in a bulk upload mechanism.
- For every mapping action, the system mandates the presence of both the zone ID as well as the pincode.
- There is no special mapping maintained for reverse orders. We will always assume that the mapping created in the forward leg will also be valid for the reverse leg.
- Whenever a pincode to delivery zone mapping is to be changed, then the following rules are adhered.

| **Action** | **Does Zone Exist?** | **Does Config Exist?** | **Note** |
| :-: | :-: | :-: | :-: |
| Insert | Yes | Yes | The system silently ignores the insert action. |
| Insert | Yes | No | The system performs the insert action provided zone ID and pincode are provided. Else, upload action is rejected. The upload is rejected if the pincode is already mapped to another zone. |
| Insert | No | Yes | Impossible situation. The system should have never allowed upload of such config. |
| Insert | No | No | The system rejects the upload action saying no such zone exists. |
| Delete | Yes | Yes | The system performs the delete action provided both zone ID and pincode are provided. Else, upload action is rejected. |
| Delete | Yes | No | The system silently ignores the delete action. |
| Delete | No | Yes | Impossible situation. The system should have never allowed upload of such config. |
| Delete | No | No | The system silently ignores the delete action. |

### Use Case 3: CRUD Operations to DC

- Every DC must have the following parameters at all points in time.

| **Parameter** | **Definition** | **Data Type** |
| :-: | :-: | :-: |
| DC ID | Unique identifier of the ~~zone~~ DC. Auto created by the system. | Integer |
| DC Name | Unique name of the DC which will be used as the canonical identifier. | String |
| DC Alias | Nickname with which the DC will be referenced. | String |
| DC Address | Complete text address of the DC’s physical location. | String |
| DC Pincode | Pincode where the DC is physically present. | String |

- CRUD operations on a DC need to happen through the existing bulk upload mechanism.
- **DC Alias Rule:** 3 letter configuration only. Anything else gets rejected in the bulk upload.
- CRUD Rules:

| **Action** | **Does DC Exist?** | **Note** |
| :-: | :-: | :-: |
| Insert | No | The system mandates the presence of all parameters. |
| Insert | Yes | The system silently ignores insert instructions and performs updates. |
| Update | No | The system rejects the configuration and prompts reupload. |
| Update | Yes | The system performs an update action only on the parameters provided. The presence of DC ID is mandated with an update action. |
| Delete | No | The system silently ignores delete instructions. |
| Delete | Yes | The system performs a delete action. The presence of DC ID is mandated. No other parameter is necessary to be provided. |

### Use Case 4: DC <-> WH Mapping

- Every DC needs to have WHs or other DCs mapped to it. Without this configuration present, the existence of a DC is meaningless — there is no path for shipments to move beyond it.
- All mapping operations happen through a bulk upload mechanism.
- For every mapping action, the system mandates the presence of both the DC IDs.
- There is no special mapping maintained for reverse orders. We will always assume that the mapping created in the forward leg will also be valid for the reverse leg.

| **Parameter** | **Definition** | **Data type** |
| :-: | :-: | :-: |
| DC ID | Identifier of the DC for which a destination is being configured. | Integer |
| Destination ID | Identifier of the WH or DC that this DC routes mid–mile shipments to. | Integer |
| Destination Type | Whether Destination ID refers to a WH or another DC. | Enum (WH / DC) |

- CRUD Rules:

| **Action** | **Does DC Exist?** | **Does Config Exist?** | **Note** |
| :-: | :-: | :-: | :-: |
| Insert | Yes | Yes | The system silently ignores the insert operation. |
| Insert | Yes | No | The system performs the insert action provided DC ID, Destination ID, Destination Type, are all provided and the Destination ID is valid (see edge case 1). Else, upload action is rejected. The upload is rejected if DC is already mapped to another hub (DC / Hub). |
| Insert | No | Yes | Impossible situation. The system should have never allowed upload of such config. |
| Insert | No | No | The system rejects the upload action saying no such DC exists. |
| Delete | Yes | Yes | The system performs the delete action provided both DC ID and Destination ID are provided. Else, upload action is rejected. |
| Delete | Yes | No | The system silently ignores the delete action. |
| Delete | No | Yes | Impossible situation. The system should have never allowed upload of such config. |
| Delete | No | No | The system silently ignores the delete action. |

**Edge cases — validation**

- Destination ID does not exist — not found as an active WH in the Warehouse Master (if Destination Type = WH) or as an active DC (if Destination Type = DC) → row rejected: “Destination not found: \<Destination ID\>. Verify the ID and type and retry.”
- DC lists itself as its own Destination → row rejected: “A DC cannot be mapped to itself.”
- DC ID or Destination ID missing → row rejected: “Please enter a valid value for \<column name\>.”

**Edge cases — state intersection**

- Mapping deleted while a mid–mile trip is currently in transit along that DC–Destination edge → the change does not block.
- The in–flight trip continues against the mapping valid at trip creation (see Use Case 6). Trips created after the change use the updated mapping.

### Use Case 5: Delivery Zone to Hub Mapping

- Every delivery zone must be mapped to exactly one Hub at a time. A zone with no Hub mapping cannot resolve a mid–mile path (see Use Case 6).
- All mapping operations happen through the existing bulk upload mechanism.
- For every mapping action, the system mandates the presence of the Zone ID and the Hub ID.
- There is no special mapping maintained for reverse orders. We will always assume that the mapping created in the forward leg will also be valid for the reverse leg.

| **Action** | **Zone exists?** | **Config exists?** | **Note** |
| :-: | :-: | :-: | :-: |
| Insert | Yes | Yes | The system silently ignores the insert action. |
| Insert | Yes | No | The system performs the insert action provided Zone ID and Hub ID are provided and the zone is not already mapped to a different Hub (see edge case 2). Else, upload action is rejected. |
| Insert | No | Yes | Impossible situation. The system should have never allowed upload of such config. |
| Insert | No | No | The system rejects the upload action saying no such zone exists. |
| Delete | Yes | Yes | The system performs the delete action provided both Zone ID and Hub ID are provided. Else, upload action is rejected. |
| Delete | Yes | No | The system silently ignores the delete action. |
| Delete | No | Yes | Impossible situation. The system should have never allowed upload of such config. |
| Delete | No | No | The system silently ignores the delete action. |

**Edge cases — validation**

- Hub ID does not exist in Geography setup → row rejected: “Hub not found: \<Hub ID\>. Verify the hub ID in Geography setup before retrying.”
- Insert attempted for a zone already mapped to a different Hub → row rejected: “Zone \<Zone ID\> already mapped to Hub \<Hub ID\>. Use a delete action to remove the existing mapping before inserting, or submit as a single update.”
- Reassignment rows (delete old Hub + insert new Hub) submitted out of order in the same upload → processed in file order, which can leave the zone unmapped or reject the insert. As with pincode reassignment (Use Case 2), reassignment should always be submitted as a single update action to avoid this ordering risk.

**Edge cases — state intersection**

- Zone–Hub mapping deleted while last–mile plans or in–flight mid–mile trips reference that zone → the delete proceeds. In–flight operations are unaffected and continue to completion. New orders for pincodes in that zone cannot resolve a mid–mile path until the zone is remapped (see Use Case 6, “Mid–Mile Path Not Found”).

### Use Case 6: Order Level Instrumentation

- For every order created, if it is allocated to Shipsy, then the path of the order must be uniquely resolvable.
- Depending on the order type, the path may be forward / reverse which is uniquely identifiable.

## Metrics

| **Metric Type** | **Metric** |
| :-: | :-: |
| Success (L0) | Order Growth |
| Success (L1) | Shipsy Order Share % |
|   | Conversion % |
|   | RTO % |
| Guardrails | Configuration Error % |
