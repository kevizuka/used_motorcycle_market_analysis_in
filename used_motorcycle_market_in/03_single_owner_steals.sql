/* What are the cheapest, legitimate first-owner bikes available in the dataset that aren't placeholder or zero-price entries, which are also legal to buy and have at least 5 years of legal RC? */

SELECT 
LEFT(model_name, -5) AS mod_name,
MEDIAN(model_year) AS med_mod_year,
MEDIAN(TRY_CAST(REGEXP_EXTRACT(kms_driven, '[0-9]+') AS INT)) AS odo_read, /* TRYCAST returns blank cells as null, helps the query not crash, returns others noramlly by converting them. */
MEDIAN(CAST(REGEXP_EXTRACT(mileage, '[0-9]+') AS INT)) AS economy,
MEDIAN(ROUND
    (CASE /* CASE WHEN statement is used to filter through different conditions, think of it as if-else statement. */
        WHEN lower(power) LIKE '%kw%' THEN CAST(REGEXP_EXTRACT(power,'[0-9]+') AS INT)*1.341
        WHEN lower(power) LIKE '%ps%' THEN CAST(REGEXP_EXTRACT(power,'[0-9]+') AS INT)*0.9863
        ELSE CAST(REGEXP_EXTRACT(power,'[0-9]+') AS INT)*1
    END, 2)) AS power,
MEDIAN(CASE
    WHEN lower(owner) = 'first owner' THEN 1
    WHEN lower(owner) = 'second owner' THEN 2
    ELSE 3 
END) AS ownership_stat,
MEDIAN(price) AS med_price
FROM 'bikes.csv'
WHERE 
LOWER(kms_driven) NOT LIKE '%mileage%' /*LOWER makes the column in lowercase temporarily. */
AND
LOWER(mileage) LIKE '% kmpl'
AND 
LOWER(power) NOT LIKE '% kw'
AND price > 0
AND model_year > 2010
GROUP BY mod_name
HAVING ownership_stat = 1
ORDER BY med_price 
LIMIT 20;

/* 
┌─────────────────────────────────────┬──────────────┬──────────┬─────────┬───────────────┬────────────────┬───────────┐
│              mod_name               │ med_mod_year │ odo_read │ economy │     power     │ ownership_stat │ med_price │
│               varchar               │    double    │  double  │ double  │ decimal(15,2) │     double     │  double   │
├─────────────────────────────────────┼──────────────┼──────────┼─────────┼───────────────┼────────────────┼───────────┤
│ TVS MAX 4R 110cc                    │       2014.0 │  13673.0 │    70.0 │          8.88 │            1.0 │   18000.0 │
│ Suzuki GS 150 R 150cc               │       2011.5 │  89750.0 │    56.0 │         13.00 │            1.0 │   19000.0 │
│ Hero Splendor NXG 100cc             │       2011.0 │  26000.0 │    65.0 │          7.00 │            1.0 │   19500.0 │
│ Hero Splendor+ 100cc                │       2013.0 │  25000.0 │    81.0 │          8.00 │            1.0 │   20000.0 │
│ TVS Star City 110cc                 │       2012.0 │  29521.0 │    85.0 │          8.00 │            1.0 │   20000.0 │
│ Hero Honda Splendor 100cc           │       2011.0 │  18895.0 │    45.0 │          8.05 │            1.0 │   20000.0 │
│ Hero CBZ Xtreme 150 cc              │       2012.0 │  18000.0 │    45.0 │         14.75 │            1.0 │   20000.0 │
│ Hero Passion Plus 100cc             │       2011.0 │  51000.0 │    55.0 │          7.00 │            1.0 │   20000.0 │
│ Suzuki Hayate 110cc                 │       2014.0 │  30027.5 │    69.0 │          8.00 │            1.0 │   21000.0 │
│ Bajaj Discover 100T                 │       2013.0 │  35000.0 │    56.0 │          7.89 │            1.0 │   22000.0 │
│ Hero HF Deluxe Eco 100cc            │       2018.0 │   6975.0 │    65.0 │          8.00 │            1.0 │   22500.0 │
│ Bajaj Discover 125cc                │       2013.0 │  26356.0 │    65.0 │         11.84 │            1.0 │   22825.0 │
│ Hero HF Deluxe iBS self Alloy 100cc │       2019.0 │   6750.0 │    55.0 │          8.05 │            1.0 │   23500.0 │
│ Bajaj Discover 125ST                │       2013.0 │  30000.0 │    65.0 │         11.84 │            1.0 │   25000.0 │
│ Hero CD Deluxe 100cc                │       2012.0 │  30000.0 │    65.0 │          7.00 │            1.0 │   25000.0 │
│ Suzuki Slingshot 125cc              │       2011.0 │  33693.0 │    59.0 │          8.00 │            1.0 │   25000.0 │
│ Suzuki Slingshot Plus 125cc         │       2014.0 │  32568.0 │    59.0 │          8.00 │            1.0 │   25700.0 │
│ Bajaj  Pulsar 180cc                 │       2011.0 │  55000.0 │    45.0 │         17.00 │            1.0 │   26000.0 │
│ Hero Passion Pro TR 100cc           │       2017.0 │  89999.0 │    84.0 │          7.00 │            1.0 │   26365.0 │
│ Hero Splendor 100cc                 │       2013.0 │  30768.0 │    45.0 │          8.05 │            1.0 │   26950.0 │
└─────────────────────────────────────┴──────────────┴──────────┴─────────┴───────────────┴────────────────┴───────────┘

1. TVS MAX 4R
2. Suzuki GS 150 R
3. Hero Splendor NXG 
4. Hero Splendor+
5. TVS Star City 

These are the top 5 cheapest, 1st owner, legal bikes you can own and ride for at least 5 years.
This segment is dominated by 100cc segment bikes which good reliability and economy. 

*/