# olympic_history 1896 - 2016
Using SQL uncover insights into the evolution of the Olympics, the characteristics of successful athletes, and the progression of various sports over time.

Athens 1896 to Rio 2016

# Dataset Information

Kaggle link: https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results?select=athlete_events.csv

The file athlete_events.csv contains 271116 rows and 15 columns

## Athlete_events.csv
ID - Unique number for each athlete

Name - Athlete's name

Sex - M or F

Age - Integer

Height - In centimeters

Weight - In kilograms

Team - Team name

NOC - National Olympic Committee 3-letter code

Games - Year and season

Year - Integer

Season - Summer or Winter

City - Host city

Sport - Sport

Event - Event

Medal - Gold, Silver, Bronze, or NA





## Noc_regions.csv
NOC - (National Olympic Committee 3 letter code)

Country name - (matches with regions in map_data("world"))

Notes


# Steps to Check and Clean Data:

Check for Missing Values:
Identify columns or rows with missing values (NULL).
Hint: Use the IS NULL condition to find missing values.

Remove Duplicates:
Ensure there are no duplicate rows.
Hint: Use the DISTINCT keyword or GROUP BY clause to identify duplicates.

Check for Consistency:
Ensure data across related columns is consistent (e.g., Age and Year should make sense together).


# Questions to answer using SQL

Total Number of Athletes:
Count the total number of unique athletes in the dataset.

Medal Distribution:
Find out the total number of each type of medal (Gold, Silver, Bronze) awarded in the history of the Olympics.

Average Age of Medalists:
Calculate the average age of athletes who have won medals.

Top 10 Countries by Medals:
Determine which countries have won the most medals overall.

Height and Weight Analysis:
Find the average height and weight of athletes by sport.

Most Successful Olympians:
Identify the athletes who have won the most medals.

Changes in Athlete Characteristics:
Analyze how the average height and weight of athletes have changed over the years.

Host City Analysis:
Find out which cities have hosted the Olympics the most times.

Gender Participation Over Time:
Compare the number of male and female athletes over different Olympic years.

Event Analysis:
Determine which events have the highest number of participants.




