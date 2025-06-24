

CREATE TABLE sales_data (
    Date DATE,
    Location TEXT,
    Channel TEXT,
    Sales_Rep TEXT,
    Product TEXT,
    Revenue NUMERIC,
    Conversion_Stage TEXT
);

CREATE TABLE operations (
    Date DATE,
    Process_Stage TEXT,
    TAT_Hours NUMERIC,
    Status TEXT,
    Team TEXT
);

CREATE TABLE leads (
    Lead_ID INTEGER,
    Source TEXT,
    Stage TEXT,
    Assigned_Rep TEXT,
    Follow_Up_Count INTEGER,
    Outcome TEXT
);

CREATE TABLE targets (
    Month DATE,
    Location TEXT,
    Channel TEXT,
    Target_Revenue INTEGER
);

CREATE TABLE customer_feedback (
    Date DATE,
    CSAT_Score INTEGER,
    Comment TEXT
);

SELECT
  TO_CHAR(Date, 'YYYY-MM') AS Month,
  Location,
  SUM(Revenue) AS Total_Revenue
FROM sales_data
GROUP BY Month, Location
ORDER BY Month, Location;


SELECT
  Stage,
  COUNT(*) AS Lead_Count
FROM leads
GROUP BY Stage;


WITH actuals AS (
  SELECT
    TO_CHAR(Date, 'YYYY-MM') AS Month,
    Location,
    Channel,
    SUM(Revenue) AS Actual_Revenue
  FROM sales_data
  GROUP BY Month, Location, Channel
)
SELECT
  TO_CHAR(t.Month, 'YYYY-MM') AS Month,
  t.Location,
  t.Channel,
  t.Target_Revenue,
  COALESCE(a.Actual_Revenue, 0) AS Actual_Revenue,
  (COALESCE(a.Actual_Revenue, 0) - t.Target_Revenue) AS Variance
FROM targets t
LEFT JOIN actuals a
ON TO_CHAR(t.Month, 'YYYY-MM') = a.Month
AND t.Location = a.Location
AND t.Channel = a.Channel;
