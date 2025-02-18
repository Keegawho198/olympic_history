USE olympics;

-- use if timeout too short
-- Increase the global timeout settings
-- SET @@GLOBAL.wait_timeout = 600;  -- 10 minutes
-- SET @@GLOBAL.interactive_timeout = 600;  -- 10 minutes


SELECT COUNT(*) FROM athlete_events;
SELECT COUNT(*) FROM noc_regions;

SELECT * 
FROM athlete_events 
WHERE Medal != 'NA';

SELECT * 
FROM athlete_events a
JOIN noc_regions n 
ON a.NOC = n.NOC
WHERE Medal != 'NA' AND season = 'Summer';

# Name, Team, Sport, num_medals, season, Gold_Medals, Silver_Medals, Bronze_Medals
-- 'Michael Fred Phelps  II', 'United States', 'Swimming', '28', 'Summer', '23', '3', '2'


SELECT name, medal
FROM athlete_events a
JOIN noc_regions n 
ON a.NOC = n.NOC
WHERE Medal != 'NA'
ORDER BY medal
;

SELECT DISTINCT region 
FROM athlete_events a
JOIN noc_regions n 
ON a.NOC = n.NOC
WHERE Medal != 'NA';

SELECT NOC, region FROM noc_regions;


-- check for any values that have null , some values have not been recorded
SELECT * FROM athlete_events 
WHERE Age IS NULL 
AND Height IS NULL 
AND Weight IS NULL 
AND Name IS NULL 
AND Sex IS NULL 
AND Team IS NULL 
AND NOC IS NULL 
AND Games IS NULL 
AND Year IS NULL 
AND Season IS NULL 
AND City IS NULL 
AND Sport IS NULL 
AND Event IS NULL 
AND Medal IS NULL;

-- check for duplicates
SELECT *, COUNT(*)
FROM athlete_events
GROUP BY ID, Name, Sex, Age, Height, Weight, Team, NOC, Games, Year, Season, City, Sport, Event, Medal
HAVING COUNT(*) > 1;

-- remove comma as it moves coloumns to next coloumn in tableau
UPDATE athlete_events
SET Name = REPLACE(Name, ',', ' ');

UPDATE athlete_events
SET Event = REPLACE(Name, ',', ' ');


SELECT *
FROM athlete_events;

-- test
SELECT sex,AVG(age)
FROM athlete_events
WHERE year = 1956
GROUP BY sex;


-- remove duplicates
DELETE FROM athlete_events
WHERE ID IN (
    SELECT ID FROM (
        SELECT ID, 
               ROW_NUMBER() OVER (PARTITION BY ID, Name, Sex, Age, Height, Weight, Team, NOC, Games, Year, Season, City, Sport, Event, Medal 
                                 ORDER BY (SELECT NULL)) AS row_num
        FROM athlete_events
    ) AS duplicates
    WHERE row_num > 1
);




-- Count the total number of unique athletes in the dataset.
SELECT COUNT(DISTINCT ID) 
FROM athlete_events;




-- Medal Distribution by Country:
-- Determine the number of gold, silver, and bronze medals won by each country.
SELECT * FROM athlete_events;
SELECT * FROM noc_regions;

SELECT team, COUNT(medal) AS total_medals
FROM athlete_events
GROUP BY team;

-- use pivot to show medal distribution
-- using NOC table 
SELECT ROUND(AVG(age)) AS average_age, n.region, 
		SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS Gold,
        SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS Silver,
        SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS Bronze,
        (SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) + 
		 SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) + 
		 SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END)) AS Total_Medals_From_Athletes
FROM athlete_events a
JOIN noc_regions n 
ON a.NOC = n.NOC
GROUP BY n.region
ORDER BY Total_Medals_From_Athletes DESC;

SELECT 
    year, n.region,
    COUNT(*) AS total_athletes,
    COUNT(CASE WHEN medal != 'NA' THEN 1 END) AS medalists
FROM athlete_events a
JOIN noc_regions n 
ON a.NOC = n.NOC
GROUP BY year, n.region
ORDER BY year;

-- Note figures may be higher, in this dataset, the records are counting indidvual athletes and will count their medal even in team sports,
-- eg; if football, say AUS wins gold then 11 players get gold but offically the olypics will count this as one gold medal.



/*Average Age of Medalists:
Calculate the average age of athletes who have won medals.
*/
SELECT AVG(age)
FROM athlete_events
WHERE MEDAL != 'NA';

-- avg age per team
SELECT AVG(age), team, 
		SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS Gold,
        SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS Silver,
        SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS Bronze,
        (SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) + 
		 SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) + 
		 SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END)) AS Total_Medals_From_Athletes
FROM athlete_events
GROUP BY team
ORDER BY Total_Medals_From_Athletes DESC;

-- total medals per year
SELECT Year, 
       COUNT(*) AS Total_Medals,
       COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS Gold_Medals,
       COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS Silver_Medals,
       COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS Bronze_Medals
FROM athlete_events
WHERE Medal != 'NA'
GROUP BY Year
ORDER BY Year;

-- only summer
SELECT Year, 
       COUNT(*) AS Total_Medals,
       COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS Gold_Medals,
       COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS Silver_Medals,
       COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS Bronze_Medals
FROM athlete_events
WHERE Medal != 'NA' AND Season = "Summer"
GROUP BY Year
ORDER BY Year;

SELECT 
    Medal,
    AVG(Age) AS Avg_Age
FROM athlete_events
WHERE Medal IS NOT NULL
GROUP BY Medal;

-- avg medal type by year
SELECT 
    Year,
    Medal,
    AVG(Age) AS Avg_Age
FROM athlete_events
WHERE Medal IS NOT NULL AND MEDAL != 'NA'
GROUP BY Year, Medal
ORDER BY Year, Medal;


/*Top 10 Most Successful Athletes:
Identify athletes with the highest number of medals.
*/
SELECT Name, Team, Sport, COUNT(Medal) AS num_medals, season,
		COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS Gold_Medals,
       COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS Silver_Medals,
       COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS Bronze_Medals
FROM athlete_events
WHERE Medal != 'NA'
GROUP BY Name, Team, Sport,season
ORDER BY num_medals DESC;
-- LIMIT 10;

/*Average Height and Weight by Sport:
Find the average height and weight of athletes for each sport. */
SELECT sport, 
ROUND(AVG(height),2) AS average_height, 
ROUND(AVG(weight),2) AS average_weight
FROM athlete_events
GROUP BY sport;

-- filter out incorrect values
SELECT 
    sport, 
    ROUND(AVG(height), 2) AS average_height, 
    ROUND(AVG(weight), 2) AS average_weight
FROM athlete_events
WHERE height BETWEEN 100 AND 250  -- Exclude unrealistic heights
AND weight BETWEEN 30 AND 200     -- Exclude unrealistic weights
GROUP BY sport;

-- adding yearly avg
SELECT 
    sport, 
    Year,
    ROUND(AVG(height), 2) AS average_height, 
    ROUND(AVG(weight), 2) AS average_weight
FROM athlete_events
WHERE height BETWEEN 100 AND 250  -- Exclude unrealistic heights
AND weight BETWEEN 30 AND 200     -- Exclude unrealistic weights
GROUP BY year, sport
ORDER BY year, sport;

/*Trend in Athlete Participation Over Time:
Analyze how athlete participation has changed over the years.
*/
SELECT 
    year, COUNT(*) AS total_athletes
FROM athlete_events
GROUP BY year
ORDER BY year;

-- include people who got medals
SELECT 
    year, COUNT(*) AS total_athletes,
    COUNT(CASE WHEN medal != 'NA' THEN 1 END) AS medalists
FROM athlete_events
GROUP BY year
ORDER BY year;


/*Gender Participation Over Time:
Compare the number of male and female athletes over different Olympic years.
*/
SELECT 
    year,
    sex,
    COUNT(*) AS total_athletes,
    COUNT(CASE WHEN medal != 'NA' THEN 1 END) AS medalists
FROM athlete_events
GROUP BY year, sex
ORDER BY year;



-- Find out which cities have hosted the Olympics the most times.
SELECT 
    year,
    city,
    sex,
    COUNT(*) AS total_athletes,
    COUNT(CASE WHEN medal != 'NA' THEN 1 END) AS medalists
FROM athlete_events
GROUP BY year, sex, city
ORDER BY year;

/*Age Distribution of Athletes:
Analyze the age distribution of athletes.
*/
SELECT 
    year, season, city, sex,
    ROUND(AVG(age)) AS average_age,
    COUNT(*) AS total_athletes,
    COUNT(CASE WHEN medal != 'NA' THEN 1 END) AS medalists
FROM athlete_events
GROUP BY year, sex, city, season
ORDER BY year;
-- Eliza pollock in 1904 was 64

/*Medals by Sport:
Determine which sports have the highest number of medals.
*/
SELECT 
    sport,
    COUNT(*) AS total_athletes,
    COUNT(CASE WHEN medal != 'NA' THEN 1 END) AS medalists
FROM athlete_events
GROUP BY sport
ORDER BY medalists DESC;


/*Comparison of Summer and Winter Olympics:
Compare the number of events and athletes in Summer and Winter Olympics.
*/
SELECT 
    season,
    COUNT(*) AS total_athletes,
    COUNT(CASE WHEN medal != 'NA' THEN 1 END) AS medalists
FROM athlete_events
GROUP BY season
ORDER BY medalists DESC;

/*Team Performance Over Time:
Analyze how the performance of specific teams has changed over the years.
*/

-- Use NOC table to join as many countrys were duplicated making the output too large. Used noc as it put each code into one country.
SELECT 
    year, n.region,
    COUNT(*) AS total_athletes,
    COUNT(CASE WHEN medal != 'NA' THEN 1 END) AS medalists
FROM athlete_events a
JOIN noc_regions n 
ON a.NOC = n.NOC
GROUP BY year, n.region
ORDER BY year;

-- summer only
SELECT 
    year, n.region,
    COUNT(*) AS total_athletes,
    COUNT(CASE WHEN medal != 'NA' THEN 1 END) AS medalists
FROM athlete_events a
JOIN noc_regions n 
ON a.NOC = n.NOC
WHERE season = 'Summer'
GROUP BY year, n.region
ORDER BY year;

SELECT * FROM noc_regions;
SELECT * FROM athlete_events LIMIT 10;