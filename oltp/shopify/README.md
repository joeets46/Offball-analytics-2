# `shopify` — Shopify Plus

Tier **A**. 25 base tables, owning **8** of the 153 in-scope target tables.

Named in the upstream model's `operational_systems_of_records`. See
[../../docs/05-source-systems.md](../../docs/05-source-systems.md) for how
ownership was assigned.

## Native idiom modeled here

- **IDs are platform-assigned, not `IDENTITY`.** It is SaaS: the replica receives ids it did not mint. A target column declaring `GENERATED ALWAYS AS IDENTITY` would reject the data.
- **Discount values are negative** by convention. A sign inversion on load turns a discount into a surcharge.
- **Three independent order lifecycles** -- financial, fulfilment and cancellation -- which move separately. The target has one status column.
- **Metafields** are the extension mechanism, and where every retailer puts what the platform does not model.

## Target tables it owns

| Target table | Source tables | Transform | Confidence |
|---|---|---|:--:|
| `merchandise.fulfillment_shipment` | `fulfillment`, `fulfillment_line_item`, `shipping_line` | `join` | high |
| `merchandise.merch_order` | `sales_order`, `customer`, `customer_address` | `join` | high |
| `merchandise.order_line` | `line_item`, `discount_application` | `join` | high |
| `merchandise.product_category` | `collection` | `1:1` | medium |
| `merchandise.promotion` | `price_rule`, `discount_code` | `join` | high |
| `merchandise.retail_location` | `location` | `1:1` | medium |
| `merchandise.return_request` | `return_request`, `return_line_item`, `refund` | `join` | high |
| `merchandise.sku_catalog` | `product`, `product_variant`, `metafield` | `join` | high |

## Files

| File | Contents |
|---|---|
| `ddl/00_schema.sql` | Schema creation and the schema `COMMENT` |
| `ddl/30_master.sql` | Master data |
| `ddl/40_transaction.sql` | Transactions, partitioned where volume warrants |
| `ddl/50_constraints.sql` | Foreign keys, declared last so one ordered pass loads |
| `ddl/60_indexes.sql` | Indexes serving named access paths |
| `ddl/70_audit.sql` | **GENERATED** -- watermark triggers, change log, role grants |
| `ddl/80_comments.sql` | Table descriptions, published by the data dictionary |

Numbered to load in order. `50_constraints.sql` runs after every table in
the schema exists, so a single forward pass works without deferred
constraints.

## Loading just this schema

```bash
bash tools/load.sh shopify
```

Cross-system references in this schema are business-key columns with no
`REFERENCES` clause, resolved through `common.entity_xref`. No foreign key
here crosses a schema boundary, which `offball-check` enforces.
