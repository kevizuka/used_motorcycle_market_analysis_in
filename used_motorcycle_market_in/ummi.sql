SELECT 
model_name,
model_year,
TRY_CAST(REGEXP_EXTRACT(kms_driven, '[0-9]+') AS INT) AS odo_read, /* TRYCAST returns blank cells as null, helps the query not crash, returns others noramlly by converting them. */
CAST(REGEXP_EXTRACT(mileage, '[0-9]+') AS INT) AS economy,
ROUND
    (CASE /* CASE WHEN statement is used to filter through different conditions, think of it as if-else statement. */
        WHEN lower(power) LIKE '%kw%' THEN CAST(REGEXP_EXTRACT(power,'[0-9]+') AS INT)*1.341
        WHEN lower(power) LIKE '%ps%' THEN CAST(REGEXP_EXTRACT(power,'[0-9]+') AS INT)*0.9863
        ELSE CAST(REGEXP_EXTRACT(power,'[0-9]+') AS INT)*1
    END, 2) AS power,
CASE
    WHEN lower(owner) = 'first owner' THEN 1
    WHEN lower(owner) = 'second owner' THEN 2
    ELSE 3 
END AS ownership_stat,
price
FROM 'bikes.csv'
WHERE 
LOWER(kms_driven) NOT LIKE '%mileage%' /*LOWER makes the column in lowercase temporarily. */
AND
LOWER(mileage) LIKE '% kmpl'
AND 
LOWER(power) NOT LIKE '% kw'
LIMIT 20;


