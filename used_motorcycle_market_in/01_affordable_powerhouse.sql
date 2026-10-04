/* Which bikes deliver genuine performance (over 20 BHP) while keeping the price tag below ₹1,00,000? */

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
GROUP BY mod_name
HAVING power > 20 AND med_price <= 1_00_000
ORDER BY power DESC, med_price DESC
LIMIT 30;

/*

┌───────────────────────────┬──────────────┬──────────┬─────────┬───────────────┬────────────────┬───────────┐
│         mod_name          │ med_mod_year │ odo_read │ economy │     power     │ ownership_stat │ med_price │
│          varchar          │    double    │  double  │ double  │ decimal(15,2) │     double     │  double   │
├───────────────────────────┼──────────────┼──────────┼─────────┼───────────────┼────────────────┼───────────┤
│ Honda CBR 250R            │       2011.0 │  30101.0 │    29.0 │         26.00 │            1.5 │   50000.0 │
│ Bajaj Pulsar NS200        │       2015.0 │  26250.0 │    40.0 │         24.00 │            1.0 │   62500.0 │
│ Bajaj Pulsar 200 NS 200cc │       2014.0 │  24000.0 │    40.0 │         24.00 │            1.0 │   51000.0 │
│ Bajaj Pulsar NS 200       │       2014.0 │  19662.0 │    40.0 │         24.00 │            1.0 │   48350.0 │
│ Bajaj Pulsar ABS 220F     │       2019.0 │   6460.0 │    38.0 │         21.00 │            1.0 │   94000.0 │
│ Bajaj Pulsar 220F         │       2017.0 │  28994.5 │    38.0 │         21.00 │            1.0 │   60000.0 │
│ Bajaj Pulsar 220cc        │       2015.0 │  31773.0 │    38.0 │         21.00 │            1.0 │   48000.0 │
└───────────────────────────┴──────────────┴──────────┴─────────┴───────────────┴────────────────┴───────────┘

1. Honda CBR 250R
2. Bajaj Pulsar NS200
3. Bajaj Pulsar 220F

These remain the only options under 1L which have 20+ bhp.
The Bajaj Pulsar's remain the undisputed budget powerhouses in the second hand market, as they are the cheapest options with the most power.

*/