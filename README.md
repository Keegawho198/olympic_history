# Olympic History (1896 - 2016)

Using SQL, I explored insights into the evolution of the Olympics, characteristics of successful athletes, and the progression of various sports over time.

## Dataset Information

**Kaggle Source:** [120 Years of Olympic History - Athletes and Results](https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results?select=athlete_events.csv)

The primary dataset, `athlete_events.csv`, contains **271,116 rows** and **15 columns**.

### `athlete_events.csv`

- **ID** - Unique identifier for each athlete
- **Name** - Athlete's name
- **Sex** - M (Male) or F (Female)
- **Age** - Age of the athlete
- **Height** - Height in centimeters
- **Weight** - Weight in kilograms
- **Team** - Name of the team or country
- **NOC** - National Olympic Committee 3-letter code
- **Games** - Year and season of the Olympic event
- **Year** - Year of the Olympics
- **Season** - Summer or Winter
- **City** - Host city
- **Sport** - Sport category
- **Event** - Specific event within the sport
- **Medal** - Gold, Silver, Bronze, or NA (no medal)

### `noc_regions.csv`

- **NOC** - National Olympic Committee 3-letter code
- **Country name** - Official country name
- **Notes** - Additional information related to the country

---

## Data Cleaning and Preparation (SQL)

### Steps Taken:

1. **Handling Missing Values**

   - Identified and addressed missing values in key columns such as `Age`, `Height`, and `Weight`.

2. **Removing Duplicates**

   - Ensured data consistency by removing duplicate records using the following SQL query:

   ```sql
   SELECT *, COUNT(*)
   FROM athlete_events
   GROUP BY ID, Name, Sex, Age, Height, Weight, Team, NOC, Games, Year, Season, City, Sport, Event, Medal
   HAVING COUNT(*) > 1;
   ```

   - Deleting duplicates:

   ```sql
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
   ```

3. **Ensuring Data Consistency**

   - Checked for logical inconsistencies (e.g., age, height, weight relative to the year of participation).

4. **Filtering for Summer Olympics**

   - Since the visualizations focused on Summer Olympics, I filtered out Winter Olympics data where it was needed using:

   ```sql
   SELECT * FROM athlete_events WHERE Season = 'Summer';
   ```

5. \*\*Joining with \*\*\`\`

   - Used a `JOIN` to connect the NOC codes to country names for better consistency in country-related queries:

   ```sql
   SELECT ae.*, nr.region AS country_name
   FROM athlete_events ae
   LEFT JOIN noc_regions nr ON ae.NOC = nr.NOC;
   ```

   - This helped unify country names and avoid multiple representations of the same country.

---

## SQL Analysis Questions

1. **Total Number of Athletes**

   - Count the total number of unique athletes:

   ```sql
   SELECT COUNT(DISTINCT ID) AS total_athletes FROM athlete_events;
   ```


2. **Medal Distribution**

   - Count the number of Gold, Silver, and Bronze medals:

   ```sql
   SELECT Medal, COUNT(*) AS total FROM athlete_events WHERE Medal != 'NA' GROUP BY Medal;
   ```


3. **Average Age of Medalists**

   - Find the average age of athletes who won medals:

   ```sql
   SELECT ROUND(AVG(Age), 2) AS avg_medalist_age FROM athlete_events WHERE Medal != 'NA';
   ```


4. **Top 10 Countries by Medals**

   - Identify the countries with the most medals:

   ```sql
   SELECT nr.region AS country, COUNT(*) AS total_medals
   FROM athlete_events ae
   LEFT JOIN noc_regions nr ON ae.NOC = nr.NOC
   WHERE Medal != 'NA'
   GROUP BY nr.region
   ORDER BY total_medals DESC
   LIMIT 10;
   ```


5. **Height and Weight Analysis**

   - Calculate the average height and weight by sport:

   ```sql
   SELECT Sport, ROUND(AVG(Height), 2) AS avg_height, ROUND(AVG(Weight), 2) AS avg_weight
   FROM athlete_events
   WHERE Height IS NOT NULL AND Weight IS NOT NULL
   GROUP BY Sport;
   ```


6. **Most Successful Olympians**

   - Identify the athletes who have won the most medals:

   ```sql
   SELECT Name, COUNT(*) AS total_medals
   FROM athlete_events
   WHERE Medal != 'NA'
   GROUP BY Name
   ORDER BY total_medals DESC
   LIMIT 10;
   ```


7. **Changes in Athlete Characteristics Over Time**

   - Analyze how the average height and weight of athletes have changed:

   ```sql
   SELECT Year, ROUND(AVG(Height), 2) AS avg_height, ROUND(AVG(Weight), 2) AS avg_weight
   FROM athlete_events
   WHERE Height IS NOT NULL AND Weight IS NOT NULL
   GROUP BY Year
   ORDER BY Year;
   ```


8. **Host City Analysis**

   - Find which cities have hosted the Olympics the most times:

   ```sql
   SELECT City, COUNT(DISTINCT Year) AS num_of_times_hosted
   FROM athlete_events
   GROUP BY City
   ORDER BY num_of_times_hosted DESC;
   ```


9. **Gender Participation Over Time**

   - Compare the number of male and female athletes over the years:

   ```sql
   SELECT Year, Sex, COUNT(*) AS num_athletes
   FROM athlete_events
   GROUP BY Year, Sex
   ORDER BY Year;
   ```


10. **Event Participation Analysis**

- Identify the events with the highest number of participants:

```sql
SELECT Event, COUNT(*) AS num_participants
FROM athlete_events
GROUP BY Event
ORDER BY num_participants DESC
LIMIT 10;
```

---


Visualizations




## Next Steps

- **Exporting Query Results to CSV**: After cleaning and analyzing the data in SQL, I exported relevant queries into CSV files.

- **Creating Visualizations in Tableau**: I used the CSV files to create insightful visualizations. These visualisations are to be improved in the future.

Link to tableau: https://public.tableau.com/views/InteractiveOlympics/Story1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link


![Story 1](Visualization%20screenshots/Improved%Story%201.png)
![Story 2](Visualization%20screenshots/Improved%Story%202.png)

![Story 3](Visualization%20screenshots/Story%201.png)
![Story 4](Visualization%20screenshots/Story%202.png)
![Story 5](Visualization%20screenshots/Story%203.png)
