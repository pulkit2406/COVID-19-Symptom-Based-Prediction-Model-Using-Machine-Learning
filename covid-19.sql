CREATE DATABASE covid_data;

use  covid_data;

-- CLEANING THE DATA SET 

-- 1.Standardize Boolean Values
UPDATE corona_tested_006
SET 
    Cough_symptoms = UPPER(Cough_symptoms),
    Fever = UPPER(Fever),
    Sore_throat = UPPER(Sore_throat),
    Shortness_of_breath = UPPER(Shortness_of_breath),
    Headache = UPPER(Headache);
    
    -- 2. Handle 'None' Values:
    UPDATE corona_tested_006
SET
    Age_60_above = CASE WHEN Age_60_above = 'None' THEN 'Unknown' ELSE Age_60_above END,
    Sex = CASE WHEN Sex = 'None' THEN 'Unknown' ELSE Sex END;
    
    -- 3. Standardize Date Format:
    UPDATE corona_tested_006
SET Test_date = substr(Test_date, 7, 4) || '-' || substr(Test_date, 4, 2) || '-' || substr(Test_date, 1, 2)
WHERE Test_date IS NOT NULL;

-- PEROMING THE QUERIES

-- 1. Find the number of corona patients who faced shortness of breath.
SELECT COUNT(*) AS NumberOfPatients
FROM corona_tested_006
WHERE Corona = 'positive'
AND Shortness_of_breath = 'TRUE';

-- 2. Find the number of negative corona patients who have fever and sore_throat.
SELECT COUNT(*) AS NumberOfPatients
FROM corona_tested_006
WHERE Corona = 'negative'
AND Fever = 'TRUE'
AND Sore_throat = 'TRUE';

-- 3.Group the data by month and rank the number of positive cases.
SELECT 
    YEAR(Test_date) AS Year,
    MONTH(Test_date) AS Month,
    COUNT(*) AS PositiveCases,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS Rank_
FROM corona_tested_006
WHERE Corona = 'positive'
GROUP BY YEAR(Test_date), MONTH(Test_date)
ORDER BY Year, Month;

-- 4. Find the female negative corona patients who faced cough and headache.
SELECT COUNT(*) AS NumberOfPatients
FROM corona_tested_006
WHERE Corona = 'negative'
AND Sex = 'Female'
AND Cough_symptoms = 'TRUE'
AND Headache = 'TRUE';

-- 5. How many elderly corona patients have faced breathing problems?

SELECT COUNT(*) AS NumberOfElderlyPatients
FROM corona_tested_006
WHERE Corona = 'positive'
AND Age_60_above = 'TRUE'
AND Shortness_of_breath = 'TRUE';

-- 6. Which three symptoms were more common among COVID positive patients?
SELECT 
    'Cough' AS Symptom,
    COUNT(*) AS NumberOfCases
FROM corona_tested_006
WHERE Corona = 'positive' AND Cough_symptoms = 'TRUE'
UNION
SELECT 
    'Fever',
    COUNT(*)
FROM corona_tested_006
WHERE Corona = 'positive' AND Fever = 'TRUE'
UNION
SELECT 
    'Sore Throat',
    COUNT(*)
FROM corona_tested_006
WHERE Corona = 'positive' AND Sore_throat = 'TRUE'
UNION
SELECT 
    'Shortness of Breath',
    COUNT(*)
FROM corona_tested_006
WHERE Corona = 'positive' AND Shortness_of_breath = 'TRUE'
UNION
SELECT 
    'Headache',
    COUNT(*)
FROM corona_tested_006
WHERE Corona = 'positive' AND Headache = 'TRUE'
ORDER BY NumberOfCases DESC
LIMIT 3;

-- 7. Which symptom was less common among COVID negative people?
SELECT 
    'Cough' AS Symptom,
    COUNT(*) AS NumberOfCases
FROM corona_tested_006
WHERE Corona = 'negative' AND Cough_symptoms = 'TRUE'
UNION
SELECT 
    'Fever',
    COUNT(*)
FROM corona_tested_006
WHERE Corona = 'negative' AND Fever = 'TRUE'
UNION
SELECT 
    'Sore Throat',
    COUNT(*)
FROM corona_tested_006
WHERE Corona = 'negative' AND Sore_throat = 'TRUE'
UNION
SELECT 
    'Shortness of Breath',
    COUNT(*)
FROM corona_tested_006
WHERE Corona = 'negative' AND Shortness_of_breath = 'TRUE'
UNION
SELECT 
    'Headache',
    COUNT(*)
FROM corona_tested_006
WHERE Corona = 'negative' AND Headache = 'TRUE'
ORDER BY NumberOfCases ASC
LIMIT 1;

-- 8. What are the most common symptoms among COVID positive males whose known contact was abroad?
SELECT 
    'Cough' AS Symptom,
    COUNT(*) AS NumberOfCases
FROM corona_tested_006
WHERE Corona = 'positive' AND Sex = 'Male' AND Known_contact = 'Abroad' AND Cough_symptoms = 'TRUE'
UNION ALL
SELECT 
    'Fever',
    COUNT(*)
FROM corona_tested_006
WHERE Corona = 'positive' AND Sex = 'Male' AND Known_contact = 'Abroad' AND Fever = 'TRUE'
UNION ALL
SELECT 
    'Sore Throat',
    COUNT(*)
FROM corona_tested_006
WHERE Corona = 'positive' AND Sex = 'Male' AND Known_contact = 'Abroad' AND Sore_throat = 'TRUE'
UNION ALL
SELECT 
    'Shortness of Breath',
    COUNT(*)
FROM corona_tested_006
WHERE Corona = 'positive' AND Sex = 'Male' AND Known_contact = 'Abroad' AND Shortness_of_breath = 'TRUE'
UNION ALL
SELECT 
    'Headache',
    COUNT(*)
FROM corona_tested_006
WHERE Corona = 'positive' AND Sex = 'Male' AND Known_contact = 'Abroad' AND Headache = 'TRUE'
ORDER BY NumberOfCases DESC;




