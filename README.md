# Pharmaceutical Supply Chain Analysis Using MySQL

SQL-based analysis of orders, delivery performance, shipping patterns, and profitability.


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

* 53,184      Unique Orders          
* 122,632     Records
* 3.47 days   Actual Shipping
* 2.87 days   Scheduled Shipping

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Business Questions

- What regions generate the most orders?
- Which shipping modes are used most?
- How is delivery performance distributed?
- Which categories have stronger profit ratios?
- How does activity vary over time?

## Orders by Region

![Orders by Region](assets/01_orders_by_region.png.png)

## Orders by Shipping Mode

![Orders by Shipping Mode](assets/02_shipping_modes.png)

## Orders by Product Category

![Orders by Product Category](assets/03_top_categories.png)

## Delivery Status

![Delivery Status](assets/04_delivery_status.png)

## Shipping Time by Mode

![Shipping Time by Mode](assets/05_shipping_time_by_mode.png)

## Profitability

| Regional Profitability | Category Profitability |
| :---: | :---: |
| ![Profit by Region](assets/08_profit_by_region.png) | ![Profit by Category](assets/07_profit_by_category.png) |

## Monthly Trend

![Monthly Trend](assets/09_monthly_order_trends.png)

## Key Findings

- **Regional Concentration:** Order volume is heavily concentrated in high-demand regions, creating focal points for regional inventory stocking.
- **Fulfillment Bottlenecks:** A noticeable gap exists between scheduled shipping days and actual transit days across specific delivery channels.
- **Profit Drivers:** Specialized product categories like Golf Bags & Carts and Fitness Accessories yield the highest average profit margins, outperforming general merchandise.
- **Late Risk Factors:** Specific shipping routes account for disproportionate delivery delays, signaling a need for carrier re-evaluation.

## SQL Techniques

- `GROUP BY`
- `ORDER BY`
- `COUNT(DISTINCT)`
- `AVG`
- `SUM`
- `YEAR`
- `MONTH`
- Subqueries
- Views

## Project Structure

```text
supply-chain-sql-analysis/
│
├── assets/                  # Exported Excel visualization charts (.png)
├── queries/                 # Cleaned and organized SQL scripts
├── dataset/                 # Raw and cleaned CSV data files
└── README.md                # Project documentation
