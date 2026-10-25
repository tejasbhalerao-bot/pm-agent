# Entities

The things actors act on.

1. Order
2. Shipment (carries the AWB)
3. Barcode (Shipments and Consignments can carry different barcodes)
4. Sorting Bin
5. Manifest
6. Consignment
7. Serving Location
8. Serviced Location
9. Vehicle
10. Device
11. People
12. Money
13. Ticket
14. Vendor
15. Payout
16. Incentive
17. Zone

Serving Location is where an order is served from, and Serviced Location is where it is served to. In Forward, Serving Locations are warehouses and DCs, and Serviced Locations are the Customers' pincodes. In Reverse, they flip.

Zone groups the pincodes a hub covers. Each zone is mapped to a hub (a Serving Location), so the chain runs hub, zone, pincode.

Money covers the reconciliation of cash and payments. Payout is the pay a driver earns and what is paid out for it. Incentive is what a driver earns on top of salary.
