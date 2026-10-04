/* Which motorcycles combine solid highway power (over 20 BHP) with low wear-and-tear (under 15,000 km logged) and cost less than 1,50,000 ? */

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
GROUP BY mod_name
HAVING power > 20 AND odo_read < 15_000 AND med_price <= 1_50_000
ORDER BY power DESC
LIMIT 20;

/* 
┌────────────────────────────────────┬──────────────┬──────────┬─────────┬───────────────┬────────────────┬───────────┐
│              mod_name              │ med_mod_year │ odo_read │ economy │     power     │ ownership_stat │ med_price │
│              varchar               │    double    │  double  │ double  │ decimal(15,2) │     double     │  double   │
├────────────────────────────────────┼──────────────┼──────────┼─────────┼───────────────┼────────────────┼───────────┤
│ Royal Enfield Continental GT 535cc │       2015.0 │   8000.0 │    26.0 │         29.00 │            1.0 │  135000.0 │
│ Royal Enfield Classic 500cc        │       2015.0 │  14900.0 │    32.0 │         27.00 │            1.0 │  120000.0 │
│ Mahindra Mojo Tourer Edition 300cc │       2017.0 │  11786.0 │    35.0 │         26.00 │            1.0 │  120000.0 │
│ Royal Enfield Standard 500cc       │       2016.0 │  14500.0 │    25.0 │         26.00 │            1.0 │  110000.0 │
│ KTM RC 200cc                       │       2016.0 │  13800.0 │    35.0 │         25.00 │            1.0 │  140000.0 │
│ UM Renegade Commando Classic       │       2018.0 │   9500.0 │    35.0 │         25.00 │            1.0 │  133500.0 │
│ UM Renegade Commando Mojave        │       2018.0 │   8958.0 │    35.0 │         24.00 │            1.0 │  148000.0 │
│ UM Renegade Sport S                │       2017.0 │   6500.0 │    35.0 │         24.00 │            1.0 │  125000.0 │
│ UM Renegade Commando               │       2017.0 │   8000.0 │    35.0 │         24.00 │            1.0 │  120000.0 │
│ Royal Enfield Himalayan 410cc      │       2016.5 │  13750.0 │    32.0 │         24.00 │            1.0 │  140050.0 │
│ Bajaj Pulsar ABS 220F              │       2019.0 │   6460.0 │    38.0 │         21.00 │            1.0 │   94000.0 │
└────────────────────────────────────┴──────────────┴──────────┴─────────┴───────────────┴────────────────┴───────────┘

1. Royal Enfield Continental GT 535
2. Royal Enfield Classic 500
3. Mahindra Mojo Tourer Edition
4. KTM RC 200
5. UM Renegade Commando

These are the top 5 bikes with over 20 bhp, less than 15,000 kms clocked on the odo and which cost under 1,50,000.
The Royal Enfields under 1.5L budget give a remarkable amount of performance across their machines, like their 500cc series of motorcycles. 
KTM's 200cc motorcyles second the Enfields in terms of similar price and power numnbers.
 */