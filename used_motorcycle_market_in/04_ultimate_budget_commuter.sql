/* Which bikes offer high fuel efficiency (over 50 kmpl) while staying under a strict budget of ₹60,000? */

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
HAVING economy > 50 AND med_price <= 60_000
ORDER BY economy DESC, med_price DESC
LIMIT 20;

/* 
┌──────────────────────────────────────┬──────────────┬───────────┬─────────┬───────────────┬────────────────┬───────────┐
│               mod_name               │ med_mod_year │ odo_read  │ economy │     power     │ ownership_stat │ med_price │
│               varchar                │    double    │  double   │ double  │ decimal(15,2) │     double     │  double   │
├──────────────────────────────────────┼──────────────┼───────────┼─────────┼───────────────┼────────────────┼───────────┤
│ TVS Sport Electric Start             │       2017.5 │   15633.5 │    95.0 │          7.00 │            1.0 │   44000.0 │
│ TVS Sport KS LONG SEAT SBT           │       2020.0 │    2000.0 │    95.0 │          7.00 │            1.0 │   40800.0 │
│ TVS Sport KS Spoke                   │       2018.0 │    8000.0 │    95.0 │          7.00 │            1.0 │   30000.0 │
│ TVS Sport 100cc                      │       2015.5 │   27000.0 │    95.0 │          7.00 │            1.0 │   26500.0 │
│ TVS Star Sport 100cc                 │       2013.0 │   49865.0 │    95.0 │          7.00 │            1.0 │   16550.0 │
│ Bajaj Platina Alloy ES 100cc         │       2018.0 │    9423.0 │    90.0 │          8.00 │            1.0 │   52000.0 │
│ Bajaj Platina 100cc ComforTec Alloy  │       2018.0 │   24063.0 │    90.0 │          8.00 │            1.0 │   39500.0 │
│ Bajaj CT 100 100cc                   │       2017.0 │   17089.0 │    89.0 │          8.00 │            1.0 │   29500.0 │
│ TVS Star City Plus Dual Tone 110cc   │       2018.0 │   14680.0 │    85.0 │          8.00 │            1.0 │   52000.0 │
│ TVS Star City Plus Dual Tone SBT     │       2018.0 │   25000.0 │    85.0 │          8.00 │            1.0 │   40000.0 │
│ TVS Star City Plus 110cc             │       2015.5 │   21056.0 │    85.0 │          8.00 │            1.0 │   28000.0 │
│ TVS Star City 110cc                  │       2011.5 │   29521.0 │    85.0 │          8.00 │            1.0 │   19000.0 │
│ Hero Passion Pro i3S Alloy 100cc     │       2018.0 │   12500.0 │    84.0 │          8.00 │            1.0 │   49750.0 │
│ Hero Passion Pro i3S Alloy 100cc IBS │       2019.0 │   19600.0 │    84.0 │          8.00 │            1.0 │   44400.0 │
│ Hero Passion Pro i3S Disc 100cc      │       2017.0 │   22000.0 │    84.0 │          8.00 │            1.0 │   41000.0 │
│ Honda Dream Yuga 110cc               │       2015.0 │   24000.0 │    84.0 │          8.00 │            1.0 │   35145.0 │
│ Hero Passion Pro TR 100cc            │       2017.0 │   89999.0 │    84.0 │          7.00 │            1.0 │   26365.0 │
│ Hero HF Deluxe 100cc                 │       2016.0 │   21511.0 │    83.0 │          7.00 │            1.0 │   34000.0 │
│ Honda CD 110 Dream                   │       2014.0 │   40000.0 │    83.0 │          8.00 │            1.0 │   27000.0 │
│ Hero HF Dawn 100cc                   │       2003.0 │ 1000000.0 │    83.0 │          7.00 │            1.0 │   23500.0 │
└──────────────────────────────────────┴──────────────┴───────────┴─────────┴───────────────┴────────────────┴───────────┘

1. TVS Sport
2. Bajaj Platina
3. Bajaj CT 100
4. TVS Star City
5. Hero Passion Pro
6. Honda Dream Yuga
7. Hero HF Deluxe

These are some of the best notable bikes which deliver economy above 50kmpl without breaking the bank and staying just under 60k.
This segment is dominated by commuter 100cc bikes, which provide high economy within budget. With most bikes far exceeding the 50kmpl economy and pushing high 80s and mid 90s while also being under 60k budget.

*/
