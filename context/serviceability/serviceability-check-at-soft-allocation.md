---
title: Serviceability Check at Soft Allocation
source: https://docs.google.com/document/d/1dCje3NjwB3vC0IA-gNqnJlmCS3mMDGVLsNLzpENfiKA/edit
type: past-prd
verticals: [hyperlocal-forward, courier-forward]
systems: [allocation, serviceability]
updated: 2026-07-21
---

# [PRD] Serviceability Check at Soft Allocation

## Objective

Ensure that the system runs a serviceability check for eligible couriers at the time of promise creation at all subsequent stages post order creation.

## Why Now?

Every time a promise is created, it has 4 major components that go into its construction. These are canonically referred to as: Doctor TAT, Warehouse TAT, Dispatch TAT, and Delivery TAT.

The expectation of any promise (or ETA as it may be canonically referred to) is that it reflects as accurate a picture of on-ground realities as possible. That means, the algorithm in place to select a delivery partner must adhere to these expectations:

1. Provide the customer with the delivery partner that can provide reliability along with speed.
2. Provide the customer with the delivery partner that can provide serviceability to the customer’s location.

In the current state, the system fails to adhere to expectation #2. As a result, the system allocates a courier to an order when the courier may not actually service this order. This results in an incorrect promise to the customer during order summary which is bound to change at the time of shipping.

**What not having these blocks in a short-term horizon:** With the continued investments in courier allocation efficiency through projects like Courier Allocation Revamp, and PBA, this is a hygiene check which leads to inefficiencies in courier allocation.

**What not having these blocks in a long-term horizon:** In the long-term we will have to replicate the non-SDD model for SDD delivery partner allocation basis serviceability. If this check is not kept in place, then promises for SDD delivery partner allocation will also break.

## Use Case: Run Serviceability Check at Soft Allocation

- This check needs to be applied whenever the application or website calls the backend for ETA calculation at PDP, Cart, Summary or Order Placed.
- When ETA is requested, the system calls Clickpost for Recommendation & Serviceability check.
- Clickpost will return a list of eligible couriers who can service this customer’s pincode.
- Using this list of eligible couriers, the system runs a check on which is the best courier that can service this order - using PBA, Legacy and any other courier allocation mechanisms in place.
- Using this courier, the customer is now presented with the constructed promise - along with dispatch date and delivery date in place.
- The existing logic of using Buffer and evaluating each courier remains untouched.
- Once this allocation has run for courier selection, all relevant tables of PBA, TAT/Adherence, Legacy Flow, and Courier Partner Allocation instrumentation are populated with the above information.
- **Edge Case:** If serviceability check fails at soft allocation, system should retry with an exponential backoff to check for serviceability. If exponential backoff fails, the system defaults to the current method of courier allocation at soft allocation.

## Worked Example

- The system receives an ETA request for an app order at Cart.
- ETA system makes a call to Logistics asking for a Promised Delivery Date.
- The system resolves the warehouse and pincode for the request. WH = 20 and Pincode = 400079
- Logistics calls Clickpost for this WH and Pincode and receives the list of courier partners as {185,195,225,246}.
- For this WH and pincode, the system runs the allocation engine to determine which allocation strategy the order should flow through.
- The allocation strategy chosen is Legacy TAT/Adherence flow.
- Based on the allocation strategy, the system selects the best courier partner from 185,195,225,246.
- The selected courier becomes 195. The system calculates the promised dispatch date and promised delivery date according to courier 195.
- These dates are passed back to the ETA system for consumption.
- The above process remains the same under the following conditions:
    - Order Source: Website / Portal
    - Screen: PDP, Summary
    - Order Status: Incomplete Order, Digitised
    - Allocation Strategy: PBA, Legacy, Courier Allocation Experiments

## Metrics

| **Metric Type** | **Metric** |
| :-: | :-: |
| Success (L0) | Customer Promise Adherence |
| Success (L1) | Courier Re-Allocation Rate (Promise -> Shipping) |
| Guardrail | Courier Allocation Mix |
| Guardrail | Shipping Promise Adherence |
| Guardrail | Customer Promise |
| Guardrail | Conversion Rate (Summary -> OP) |

## Rollout & Stage Gates

| **Stage** | **Scale** | **Monitoring Period** | **Kill Criteria** |
| :-: | :-: | :-: | :-: |
| Contained Rollout | 5% | 10 days | Customer Promise Adherence: -3pp<br>Conversion Rate (Summary -> OP): -1pp<br>Customer Promise: -0.5 days |
| Full Rollout | 100% | - | - |
