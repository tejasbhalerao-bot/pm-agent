---
title: Performance Based Speed Calculation & Allocation
source: https://docs.google.com/document/d/1qUPko5AF-znGug9mfBTLX6ZiDiQiQyY0jK3XH6r_zck/edit
type: past-prd
verticals: [courier-forward]
systems: [eta, allocation]
updated: 2026-08-22
---

# v1

# [PRD] Performance Based Speed and Courier Allocation Calculation

## Objective

Design a self correcting system for courier allocation at all stages of the order where a courier is allocated.

## Why Now?

Here is how the current system functions:

1. Refer to the delivery TAT uploaded by the ops team and consider this value as the *“Ideal TAT”*.
2. Compare “Promise TAT” with the diff of Delivery Attempt Time and Pickup Time.
3. Use the above computation to populate the value of “*Delay Days*”.
4. Aggregate delay days at a lane x delivery partner level to compute the count of orders present in *SLABreach1day*, *SLABreach2day*, *SLABreach3day*, *SLABreach4plusday*.
5. If the count of orders not in the above SLABreach buckets is less than 80%, then the system keeps adding orders through the SLABreach days until a minimum of 80% is reached.
6. This offset (loop of addition of SLABreach days) is added to the Ideal TAT value to compute the “*Final TAT*”.
7. Adherence computation reruns daily on the Promise TAT of the orders which is nothing but Ideal TAT.
8. When an order is received for a particular lane, the system fetches adherence data at a pincode x courier level.
9. The system then compares the couriers and allocates one with the lowest value of TAT/Adherence.

Due to this, the following problems arise:

| **Problem** | **Consequence** | **Impact** |
| :-: | :-: | :-: |
| Promise TAT = Ideal TAT + Drop Buffer Days | The customer passed the TAT as Final TAT. However, the courier's performance is judged on the basis of the Ideal TAT. | 1. Changes which courier gets allocated to an order.<br>2. Indirectly impacts the promise shown to a customer. |
| Delay Days > = 0 | The system never corrects to the actual speed of the courier even though it may have become faster as per expected performance until the business team corrects the config. | 1. Changes which courier gets allocated to an order.<br>2. Directly bloats TAT for the customer resulting in earlier than projected deliveries. |
| Allocation decision at a pincode x courier level | Courier’s performance is judged only on how deliveries happen to a particular pincode instead of accounting for the entire network. | 1. Changes which courier gets allocated to an order.<br>2. Indirectly impacts the promise shown to a customer.<br>3. Impacts on-time delivery rate for the consumer. |
| Double Correction of Ideal TAT | The system applies the delay offset to the Ideal TAT after the business team has already uploaded the corrected TAT to the system. | 1. Changes which courier gets allocated to an order.<br>2. Indirectly impacts the promise shown to a customer. |
| TAT/Adherence is not a scalable mechanism for allocation | The allocation mechanism does not scale for other parameters such as cost of serving, etc. | 1. When couriers have relatively similar performance, we still allocate to the courier which has higher cost. |

## Use Case 1: Calculating Logistics TAT Based on Courier’s Speed

### Case 1: Courier with no historical orders on lane

- When a customer ETA request comes for a specific lane, the system first runs a serviceability check to fetch the list of eligible couriers on that lane.
- For these couriers, the system checks whether there are any orders present in the window of the last 7 days for that warehouse x pincode combination.
- If there are no orders present, the system concludes that this order falls under the category of no historical orders.
- In this case, the system fetches the ideal TAT as configured by the business team in pincode_delivery_tat and pincode_delivery_tat_mfc.
- In case there is no configuration in the above tables, the system uses TAT as the Supposed TAT value. The value of Supposed TAT should be 3 days.
- Once this determination of config driven speed is done, the system determines whether there is any drop buffer configuration present or not. This is done by using the existing system of determining the need for a drop buffer.
- If yes, then Logistics TAT = Ops Config + Drop Buffer.
- Else, Logistics TAT = Ops Config

### Case 2: Courier with historical orders on lane

- When a customer ETA request comes for a specific lane, the system first runs a serviceability check to fetch the list of eligible couriers on that lane.
- For these couriers, the system checks whether there are any orders present in the window of the last 7 days for that warehouse x pincode combination.
- If there are orders present, the system concludes that this order falls under the category of having historical orders.
- **Step 1:** For these lanes, the system first calculates the actual speed the courier saw for each order. To do this, the system uses the following formula,

`Actual speed = DATE(delivery_attempt_time) - DATE(pickup_time)`

- **Step 2:** The system adjusts the drop buffer added to the order to calculate the Buffer Adjusted Actual Speed

`Buffer Adjusted Actual Speed = Actual Speed - DAYS(Drop Buffer)`

- **Step 3:** The system now calculates the percentile value of buffer adjusted actual speed to be shown to the customer for that lane using the below formula,

`Lane TAT = ROUNDUP(PERCENTILE(Buffer Adjusted Speeds, percentile_value))`

- Roundup function is specifically applied to ensure that the Lane TAT is achieved in full integer days instead of decimal days. If the output without Roundup is already an integer, then the Roundup function has no impact on the output.
- Percentile_value is kept configurable at the following dimensions: warehouse_id, delivery_pincode, delivery_partner.
- This configurability is controlled through a bulk upload mechanism which follows the same logic of insert, update and delete as per the current bulk upload structure with complete audit trails of historical configurations.
- At least one of warehouse_id, delivery_pincode, and delivery_partner are mandatory to be present in the configuration. The system does not demand all 3 dimensions to be present for considering percentile_value.
- For example, if percentile_value = 0.8 for WH 20 x Pincode 400079, then this percentile_value is used for calculation of Lane TAT for all delivery partners in that lane TAT.
- The system always first tries to find an exact match for the percentile_value field in the available active configurations. For example,

    ```
    Config1 = (WH20, percentile_value = 0.8)
    Config2 = (WH20, Pincode400079, percentile_value = 0.85)
    Config3 = (WH20, Pincode400079, DeliveryPartner185, percentile_value = 0.9)

    For order of WH20 Pincode400079 and DeliveryPartner!=185, percentile_value = 0.85
    For order of WH20 Pincode400080, percentile_value = 0.8
    For order of WH20 Pincode400079 and DeliveryPartner=185, percentile_value = 0.9
    ```

- The above example elucidates the system’s behaviour when fetching percentile_value:
    - First fetch active configuration for WH x Pincode x Delivery Partner
    - If absent, fetch active configuration for WH x Pincode
    - If absent, fetch active configuration for WH
    - If absent, the system uses the default value of percentile_value.
- Default percentile_value = 0.8
- **Step 4:** The system now calculates the Buffer Adjusted Lane TAT using the below formula,

`Buffer Adjusted Lane TAT = Lane TAT + Drop Buffer`

- The application methodology for adding Drop Buffer to Lane TAT remains as is in the existing system.
- Step 4 ensures that the system calculates TAT accounting for the buffer configuration inputted by the business team.
- The calculated value of Buffer Adjusted Lane TAT calculated in Step 4 is used as the value of TAT in TAT/Adherence calculations downstream.

## Use Case 2: Calculating Lane x Courier Adherence on Customer TAT

- **Step 1:** For each lane x courier partner combination, the system fetches the list of orders with a delivery attempt in the last 7 days.
- **Step 2:** For each of these orders, the system fetches the Buffer Adjusted Lane TAT given to the customer.
- **Step 3:** Using these 2 values, the system then calculates the delay days parameter using the following formula,

`Delay Days = (DATE(delivery_attempt_time) - DATE(pickup_time)) - Buffer Adjusted Lane TAT`

- The system explicitly allows delay_days to have a negative value post calculation instead of limiting values to >=0.
- **Step 4:** The system now aggregates the delay days parameter in the following buckets to store the number of orders:

Early4plusday,

Early3day,

Early2day,

Early1day,

On-Time,

Late1day,

Late2day,

Late3day,

Late4plusday

- **Step 5:** The system now calculates the adherence percentage for this lane x courier combination with the following iterative formula

| **List Position** | **Field** |
| :-: | :-: |
| 0 | Early4plusday |
| 1 | Early3day |
| 2 | Early2day |
| 3 | Early1day |
| 4 | On-Time |
| 5 | Late1day |
| 6 | Late2day |
| 7 | Late3day |
| 8 | Late4plusday |

Iteratively sum through above list positions starting from position 0 till the below condition is met.

`Cumulative sum >= percentile_value`

- The percentile_value fetched in the above formula is the same as the percentile_value in Use Case 1.
- **Step 5:** The system stores the value of adherence_percentage calculated in Step 4 along with each Early, On-Time, and Late field above.
- **Step 6:** The system runs the same logic every night at 3AM for FCs and 3:30AM for MFCs.
- **Step 7:** If there are no historical orders with a delivery attempt in the last 7 days for the lane x courier combination, the system uses the values present in tat_adherence_master as the adherence_percentage.
- This calculated value of adherence_percentage is what represents Adherence in downstream TAT/Adherence calculations.
- **Additional Handling:** The system does additional handling in the existing shadow mode experiments as well. This is subsequently covered below.
    - The existing courier allocation experiments already account for Early, On-Time, and Late computations. This needs to be retained.
    - The above logic of calculating TAT and Adherence needs to be retained across Legacy and Legacy_Hard formulas being applied.
    - The methodology of calculating TAT is applied across all types of formula_applied and n_thresholds.
    - For example, if n_threshold is 10, and pincode A does not have 10 orders, then the system should fallback to the city cascade and use data from pincode B, C, and D to calculate the adherence_percentage and buffer_adjusted_actual_speed.
    - The methodology of calculating adherence for all other types of formula_applied across n_thresholds also undergoes the above change.
    - The only difference remains where the system falls back to default value of percentile_value only after it has exhausted all other fallback approaches of city, state, warehouse, and courier.

## Use Case 3: Filtering for WH in Courier Allocation Decisions

- When an ETA request is received by the system, it has to take a decision as to which courier to allocate to compute the ETA. To do this, the following below steps are followed.
- **Step 1:** The system resolves the warehouse and delivery pincode from the ETA calculation request.
- **Step 2:** With the warehouse and delivery pincode available, the system filters the list of courier partners that service this combination of warehouse x delivery pincode.
- **Step 3:** For these serviceable couriers, the system fetches the calculated value of adherence_percentage and Buffer Adjusted Actual Speed. This fetch explicitly filters for the following dimensions: warehouse, delivery pincode, courier.
- **Step 4:** With the record of every courier at a warehouse x delivery pincode level, the system runs the existing TAT/Adherence logic to select a delivery partner. This existing logic uses the following formula,

```
tat_adherence_score_with_buffer = Buffer Adjusted Lane TAT / Adherence_percentage +
Schedule Time Adjustment (if applicable) +
Pickup Buffer (if applicable) +
Drop Buffer (if applicable)
```

- **Step 5:** Once the courier is selected for the ETA request, the Logistics TAT committed equals the value as per Use Case 1.

## Use Case 4: TAT Change Guardrails

- As part of this release, the system will not be directly blocking upload of TAT but will only emit markings of the TAT uploaded.
- On these emitted markings, the analytics team is expected to build automated alerts and monitoring to ensure that these changes if used anywhere do not impact customer experience.
- The following guardrails to be implemented. If these are not met, the configuration should be rejected.
    - Warehouse_id should be among the current active warehouses.
    - Pincode should be a 6 digit integer.
    - Delivery Days and Delivery Days in Mins should be >= 0.
    - Delivery Days <= 15.
    - If any of the above conditions are not met, the system rejects the uploaded configuration with the appropriate error message.
- For the following conditions, the system does not reject the configuration but rather populates a warning message if relevant:

| **Condition** | **Message** |
| :-: | :-: |
| \|new TAT - old TAT\| >=2 days | Delivery TAT changed by >=2 days |
| New TAT != percentile(last 7 days lane data, percentile_value) | New TAT does not match lane aggregated data for {{x}} percentile over the last 7 days. |
| New TAT != percentile(last 15 days lane data, percentile_value) | New TAT does not match lane aggregated data for {{x}} percentile over the last 15 days. |
| New TAT != percentile(last 30 days lane data, percentile_value) | New TAT does not match lane aggregated data for {{x}} percentile over the last 15 days. |

- The above messages are captured only when a configuration is updated in the system.
- One or more of the above warning messages could be triggered per row of upload. The system should be scalable to handle each warning message storage.
- Against each uploaded configuration, the system should also store the warning messages, action taken on configuration and have a full audit trail of uploaded configurations.
- In the future, other warning messages can be incorporated. The system should auto scale with the addition of those.

## Worked Example 1: Legacy System

- Imagine the following orders have been executed in the past. Before these orders, there were no other orders in the system for the lane.

| **Order** | **Ideal TAT** | **Customer TAT** | **Actuals** |
| :-: | :-: | :-: | :-: |
| O1 | 3 days | 3 days | 2 days |
| O2 | 3 days | 3 days | 2 days |
| O3 | 3 days | 3 days | 2 days |
| O4 | 3 days | 3 days | 2 days |
| O5 | 3 days | 3 days | 2 days |

- As can be seen from above, since there were no orders in the past, the system directly took the ideal TAT as the customer TAT for the lane. Now imagine that the percentile_value = 0.8
- For this percentile_value, actual speed comes out to be 2 days. Since no drop buffer was added to the orders, buffer adjustment to actual speed changes nothing. Lane TAT = 2 days = Buffer Adjusted Lane TAT.
- Since all the orders were early by 1 day, all fields of Early, On-Time and Late were 0 in order count except for Early1day = 5.
- The condition for the adherence calculation that gets executed is (Early4plusday + Early 3day + Early2day + Early1day) / Total Orders >= 0.8
- The adherence_percentage gets stored as 100%.
- Now when an ETA request comes for this warehouse x pincode combination, the system uses TAT = 2 days and Adherence = 100%.

## Worked Example 2: Courier Allocation Experiments

- Consider that the following configurations are present:

| **Config** | **Value** |
| :-: | :-: |
| N_threshold | 10 |
| Formula | Early_On_Time |

- For this, assume that when a warehouse x pincode order is received, then this pincode A has only 5 orders. 5 is below the N_threshold, so the system decides to fallback to city level calculations.
- At a city level, the following pincode to order count distribution is present:

| **Pincode** | **Order Count** |
| :-: | :-: |
| Pincode A | 0 |
| Pincode B | 10 |
| Pincode C | 10 |
| Pincode D | 10 |

- 30 > N_threshold. The system confirms that City level fallback can be used.
- For all city orders, the system calculates the buffer adjusted actual speed.
- Once this is calculated, the system uses the above logic to calculate the buffer adjusted lane TAT. This is used as the TAT in TAT/Adherence calculations.
- In a similar manner, for the city, the system calculates the adherence percentage.
- This gets used in the TAT/Adherence logic as per the formula applied.
- Similar logic applies to other cascade levels (state, warehouse, courier and default).
- Similar logic applies to other formulas (compute_early_to_breach).

## Worked Example 3: Legacy System with Drop Buffers

- Imagine the following orders have been executed in the past. Before these orders, there were no other orders in the system for the lane.

| **Order** | **Ideal TAT** | **Customer TAT** | **Actuals** | **Drop Buffer** |
| :-: | :-: | :-: | :-: | :-: |
| O1 | 3 days | 4 days | 3 days | 1 day |
| O2 | 3 days | 3 days | 2 days | 0 days |
| O3 | 3 days | 3 days | 2 days | 0 days |
| O4 | 3 days | 3 days | 2 days | 0 days |
| O5 | 3 days | 3 days | 2 days | 0 days |

- As can be seen from above, since there were no orders in the past, the system directly took the ideal TAT as the customer TAT for the lane with the exception for 1 order where a drop buffer was added. Now imagine that the percentile_value = 0.8
- For this percentile_value, Lane TAT = 2 days for all orders except O1. Lane TAT for O1 = 3 days. For O1, Buffer Adjusted Lane TAT = 2 days. For O2 to O5, Buffer Adjusted Lane TAT = Lane TAT = 2 days.
- Since all the orders were early by 1 day, all fields of Early, On-Time and Late were 0 in order count except for Early1day = 5.
- The condition for the adherence calculation that gets executed is (Early4plusday + Early 3day + Early2day + Early1day) / Total Orders >= 0.8
- The adherence_percentage gets stored as 100%.
- Now when an ETA request comes for this warehouse x pincode combination, the system uses TAT = 2 days and Adherence = 100%.

## Metrics

| **Metric Type** | **Metric** |
| :-: | :-: |
| Success (L0) | Average Customer Promise |
| Success (L0) | On-Time Delivery % |
| Success (L1) | Courier Allocation Mix |
| Guardrail | Delayed Orders % |
| Guardrail | Average Customer Promise |

## Rollout & Stage Gates

| **Rollout** | **Rollout Strategy** | **Scale** | **Kill Criteria** |
| :-: | :-: | :-: | :-: |
| A/B Test | 1. Select WH x Pincode combinations for rollout<br>2. Divide orders of that lane into hash based randomisation to the 2 strategies: existing and new. | 20% high traffic lanes | 1. Customer Promise degrades by 0.5 days<br>2. Adherence degrades by 3pp. |
| Full Rollout | - | 100% lanes | - |
