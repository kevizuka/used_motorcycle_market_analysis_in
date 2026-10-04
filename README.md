# Exploratory Data Analysis w/ SQL: Second Hand Bike Market Analysis

**Welcome to my Motorcycle Data Analysis Project. This repository explores second hand Indian Motorcyle market using data of second hand market till 2021 to uncover different patterns which lead a consumer to purchase a second hand bike.**

**Instead of relying on subjective and biased opinions, this project focuses on objective and unbiased data to find the best motorcyle fit for anyone and everyone in hunt for a second hand motorcycle.**

---

## Executive Summary

- **The Goal:** Build an end-to-end SQL pipeline in DuckDB to clean, standardize, and analyze thousands of messy secondhand motorcycle listings.
- **Data Cleanup:** Used regular expressions and safe type-casting to pull usable numbers out of messy text fields (like odometers and fuel economy), while stripping year tags so multi-year listings could be grouped cleanly.
- **Unified Horsepower:** Standardized mixed manufacturer units (converting kilowatts and metric horsepower into uniform BHP) using conditional logic.
- **Outlier Defense:** Grouped models together and used **`MEDIAN()`** instead of simple averages to prevent typo listings and ₹0 placeholders from ruining the math.

Review these for a clearer understanding:

1. [`01_affordable_powerhouse.sql`](../Data_projects/used_motorcycle_market_in/01_affordable_powerhouse.sql) - True performance bikes (>20 BHP) priced for accessible enthusiast budgets.
2. [`02_low_mileage.sql`](../Data_Projects/used_motorcycle_market_in/02_low_mileage.sql) - Low-wear garage finds with barely any kilometers on the clock.
3. [`03_single_owner_steals.sql`](../Data_Projects/used_motorcycle_market_in/03_single_owner_steals.sql) - Well-kept first-owner bikes ranked by realistic entry prices.
4. [`04_ultimate_budget_commuter.sql`](../Data_Projects/used_motorcycle_market_in/04_ultimate_budget_commuter.sql) - High-mileage workhorses (>50 kmpl) under a strict ₹60,000 cap.

---

## Problem & Context

Web-scraped vehicle listings are full of data traps that break standard queries:

1. **Text Trapped in Numbers:** Fields like mileage and odometer readings weren't stored as pure numbers; they had strings attached like `'17000 km'` or `'55 kmpl'`. Trying to do math on them crashed standard conversions.
2. **Duplicate Spam:** Popular bikes like the Pulsar 220 or Passion Pro appeared dozens of times. Worse, because sellers baked the model year into the name (e.g., `'Pulsar 220cc 2011'` vs `'Pulsar 220cc 2012'`), standard grouping treated them as completely different motorcycles.
3. **Joke Listings & Clickbait:** Sellers regularly list bikes for ₹0 or post liter-class machines at pocket change prices, making mathematical averages (`AVG`) useless.

This project handles all of those issues directly in SQL—scrubbing the inputs, standardizing units, and aggregating identical bikes so real pricing trends stand out clearly.

---
## How the Pipe-line works

**(Messy text strings, mixed power units, duplicate listings, ₹0 prices)**


v

 **1. Clean & Extract** 
- Pull raw digits using REGEXP_EXTRACT
- Safely convert to INT using TRY_CAST (null on error)
- Strip trailing 4-digit years using LEFT(model_name, -5)


v

 **2. Standardize & Filter** 
- Normalize kW and PS to BHP using CASE WHEN math
- Kick out ₹0 placeholders and malformed rows using WHERE


v

 **3. Group & Calculate Medians** 
- GROUP BY clean model name to kill duplicate spam
- Use MEDIAN() on price and mileage to dodge outlier skew
- Filter final group targets using HAVING


v

**Clean Market Insights**
(Budget Commuters | Affordable Powerhouses | Single-Owner Finds)
---

## Tech Stack

- **SQL:** The entire analysis and cleaning pipeline is written in pure SQL.
- **DuckDB:** Fast, lightweight in-process analytical engine used to run SQL directly on raw CSV files without needing to configure a heavy database server.
- **VS Code:** Development environment for query editing, Git management, and testing.
- **Git & GitHub:** Version control and portfolio hosting.
---

## The 4 Market Analyses

### 1. The Affordable Powerhouse
* **File:** [`01_affordable_powerhouse.sql`](../Data_projects/used_motorcycle_market_in/01_affordable_powerhouse.sql)
* **The Question:** Where can an enthusiast get real highway performance (>20 BHP) for a sensible price?
* **What the Data Showed:** Models like the Royal Enfield Classic 500, Continental GT 535, Mahindra Mojo Tourer, and KTM RC 200 deliver strong performance numbers at reachable second-hand price points once duplicate spam is filtered out.

### 2. Low-Mileage Garage Finds
* **File:** [`02_low_mileage.sql`](../Data_Projects/used_motorcycle_market_in/02_low_mileage.sql)
* **The Question:** Which motorcycles have spent more time sitting in a garage than being ridden?
* **What the Data Showed:** Pinpointed machines with under 15,000 km logged, matching low wear-and-tear against solid build years and realistic asking prices.

### 3. The Single-Owner Steals
* **File:** [`03_single_owner_steals.sql`](../Data_Projects/used_motorcycle_market_in/03_single_owner_steals.sql)
* **The Question:** What are the lowest entry prices for bikes being sold by their original first owners?
* **What the Data Showed:** Filtering strictly for single-owner bikes weeded out heavily passed-around bikes and highlighted clean entry-level machines at genuine floor prices.

### 4. The Ultimate Budget Commuter
* **File:** [`04_ultimate_budget_commuter.sql`](../Data_Projects/used_motorcycle_market_in/04_ultimate_budget_commuter.sql)
* **The Question:** Which bikes deliver high fuel economy (>50 kmpl) without exceeding ₹60,000?
* **What the Data Showed:** Reliable daily runners like the TVS Apache 150, Hero Passion, and Bajaj Avenger 200 comfortably beat the 50 kmpl threshold while keeping typical median asking prices well within budget.
---

## SQL Concepts Applied

* **Extracting Numbers from Strings (`REGEXP_EXTRACT`):** Stripped away text labels like `km` and `kmpl` so raw numbers could actually be queried.
* **Defensive Casting (`TRY_CAST`):** Swapped out fragile `CAST` statements for `TRY_CAST`, letting DuckDB turn corrupted cells into `NULL` instead of terminating the query.
* **Unit Standardization (`CASE WHEN`):** Handled conditional unit conversions on the fly to get an apples-to-apples horsepower comparison.
* **String Trimming (`LEFT`):** Sliced off 5 characters from the end of model names to merge year-split listings back into single models.
* **Median vs. Average (`MEDIAN`):** Used the true middle value of each bike group so scam prices and typos couldn't warp the market benchmarks.
* **Knowing Where to Filter (`WHERE` vs. `HAVING`):** Cleaned bad rows and zero-prices upfront with `WHERE`, then set metric thresholds on the calculated medians using `HAVING`.