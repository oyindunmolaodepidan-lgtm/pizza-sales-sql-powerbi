
# Pizza Place Sales Analysis (SQL Server + Power BI)

## Business problem
Understand when, what and how customers buy, to guide staffing, menu and promotion decisions.

## Dataset
Maven Analytics Pizza Place Sales (2015) from Kaggle: 21,350 orders, 48,620 order lines, 4 tables.

## Tools
SQL Server (SSMS 22), T-SQL (joins, CTEs, window functions), Power BI, DAX.

## Data model
![ERD](images/erd.png)

Relationships: `orders → order_details → pizzas → pizza_types`

## Dashboard
![Dashboard](images/dashboard.png)

## Key insights
- Total revenue was $817,860 across 21,350 orders, with an average order value of $38.31.
- Lunch (12-2pm) and dinner (5-8pm) generate about 55% of all orders.
- Friday is the busiest day (3,538 orders); Sunday is the slowest, with about 26% fewer.
- Large pizzas earn 46% of revenue; XL and XXL together are under 2%.
- Chicken pizzas hold the top 3 spots by revenue, though the four categories are evenly balanced (24-27% each).
- Monthly revenue is flat at about $68K, so growth must come from upselling and off-peak promotions.

## Recommendations
- Concentrate staffing and prep at lunch and dinner peaks.
- Run promotions on Sundays and early-week days.
- Upsell Small and Medium customers to Large.
- Review the XL and XXL offering.

## Limitations
Only one year of data, so seasonality can't be confirmed. No customer IDs, so repeat-purchase analysis isn't possible.

## Files
- `sql/pizza_analysis.sql`: setup, joins and analysis queries
- `powerbi/Pizza_Dashboard.pbix`: Power BI dashboard

## How to run
1. Import the CSVs into SQL Server using Import Flat File.
2. Run `pizza_analysis.sql`.
3. Open the `.pbix` file and point it to your SQL Server.
