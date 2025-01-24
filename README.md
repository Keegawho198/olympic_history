# olympic_history
Using SQL uncover insights into the evolution of the Olympics, the characteristics of successful athletes, and the progression of various sports over time.

Athens 1896 to Rio 2016


Steps to Check and Clean Data:

Check for Missing Values:
Identify columns or rows with missing values (NULL).
Hint: Use the IS NULL condition to find missing values.

Remove Duplicates:
Ensure there are no duplicate rows.
Hint: Use the DISTINCT keyword or GROUP BY clause to identify duplicates.

Validate Data Types:
Ensure each column has the correct data type (e.g., integer, float, varchar).
Hint: Use the CAST or CONVERT functions to convert data types.

Check for Outliers:
Identify and handle outliers in numerical columns (e.g., unusually high or low values).
Hint: Use statistical functions like AVG, STDDEV, and comparisons.

Standardize Categorical Data:
Ensure categorical columns (e.g., Sex, Medal) use consistent values (e.g., 'M'/'F' for Sex).
Hint: Use the REPLACE or UPDATE statements to standardize values.

Normalize Text Data:
Ensure consistency in text columns (e.g., trimming extra spaces, converting to lowercase).
Hint: Use the TRIM, LOWER, and UPPER functions for text manipulation.

Check for Consistency:
Ensure data across related columns is consistent (e.g., Age and Year should make sense together).
Hint: Use conditional statements to check for logical consistency.



Questions to answer

Total Number of Athletes:
Count the total number of unique athletes in the dataset.
Hint: Use the COUNT function along with DISTINCT.

Medal Distribution:
Find out the total number of each type of medal (Gold, Silver, Bronze) awarded in the history of the Olympics.
Hint: Use the GROUP BY clause along with the COUNT function.

Average Age of Medalists:
Calculate the average age of athletes who have won medals.
Hint: Use the AVG function and filter results where the Medal column is not 'NA'.

Top 10 Countries by Medals:
Determine which countries have won the most medals overall.
Hint: Use the SUM function in combination with GROUP BY and ORDER BY.

Height and Weight Analysis:
Find the average height and weight of athletes by sport.
Hint: Use the AVG function and GROUP BY the Sport column.

Most Successful Olympians:
Identify the athletes who have won the most medals.
Hint: Use the COUNT function and GROUP BY the Name column, then sort the results.

Changes in Athlete Characteristics:
Analyze how the average height and weight of athletes have changed over the years.
Hint: Use the AVG function with GROUP BY Year.

Host City Analysis:
Find out which cities have hosted the Olympics the most times.
Hint: Use the COUNT function and GROUP BY the City column.

Gender Participation Over Time:
Compare the number of male and female athletes over different Olympic years.
Hint: Use the COUNT function and GROUP BY the Sex and Year columns.

Event Analysis:
Determine which events have the highest number of participants.
Hint: Use the COUNT function and GROUP BY the Event column.
