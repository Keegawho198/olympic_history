USE olympics;

-- Increase the global timeout settings
SET @@GLOBAL.wait_timeout = 600;  -- 10 minutes
SET @@GLOBAL.interactive_timeout = 600;  -- 10 minutes


SELECT COUNT(*) FROM athlete_events;
SELECT COUNT(*) FROM noc_regions;

SELECT * FROM athlete_events
WHERE Medal != 'NA';

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


SELECT *
FROM athlete_events
WHERE Name = 'William Truman Aldrich';


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
-- Hint: Use GROUP BY with NOC and Medal, and use COUNT.
SELECT * FROM athlete_events;
SELECT * FROM noc_regions;

SELECT team, COUNT(medal) AS total_medals
FROM athlete_events
GROUP BY team;

-- use pivot to show medal distribution
SELECT team, 
		SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS Gold,
        SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS Silver,
        SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS Bronze,
        (SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) + 
		 SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) + 
		 SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END)) AS Total_Medals_From_Athletes
FROM athlete_events
GROUP BY team
ORDER BY Total_Medals_From_Athletes DESC;

-- Note figures may be higher, in this dataset, the records are counting indidvual athletes and will count their medal even in team sports,
-- eg; if football, say AUS wins gold then 11 players get gold but offically the olypics will count this as one gold medal.



/*Average Age of Medalists:
Calculate the average age of athletes who have won medals.
Hint: Filter the Medal column for non-NA values and use AVG.*/
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
WHERE Medal IS NOT NULL
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
Hint: Use GROUP BY with Name and COUNT.*/
SELECT Name, Team, Sport, COUNT(Medal) AS num_medals
FROM athlete_events
WHERE Medal != 'NA'
GROUP BY Name, Team, Sport
ORDER BY num_medals DESC
LIMIT 10;

/*Average Height and Weight by Sport:
Find the average height and weight of athletes for each sport.
Hint: Use GROUP BY with Sport, and AVG.*/

/*Trend in Athlete Participation Over Time:
Analyze how athlete participation has changed over the years.
Hint: Use GROUP BY with Year and COUNT.*/

/*Gender Participation Over Time:
Compare the number of male and female athletes over different Olympic years.
Hint: Use GROUP BY with Sex and Year.*/

/*Host Cities Analysis:
Find out which cities have hosted the Olympics the most times.
Hint: Use GROUP BY with City and COUNT.*/

/*Age Distribution of Athletes:
Analyze the age distribution of athletes.
Hint: Use GROUP BY with Age and COUNT.*/

/*Medals by Sport:
Determine which sports have the highest number of medals.
Hint: Use GROUP BY with Sport and COUNT.*/

/*Comparison of Summer and Winter Olympics:
Compare the number of events and athletes in Summer and Winter Olympics.
Hint: Use GROUP BY with Season and COUNT.*/

/*Team Performance Over Time:
Analyze how the performance of specific teams has changed over the years.
Hint: Use GROUP BY with Team and Year.*/