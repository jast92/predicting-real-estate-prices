USE house_price_regression;

#4. Select all the data from table house_price_data to check if the data was imported correctly.

SELECT * FROM house_price_data;

#5. Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL.
#Select all the data from the table to verify if the command worked. Limit your returned results to 10.

#Drop table date

ALTER TABLE house_price_data
DROP COLUMN date;

# Check remaining columns in table

SELECT * FROM house_price_data
LIMIT 10;

#6. Use sql query to find how many rows of data you have.

#The following query shows how many rows (excluding the row with the names of the columns) exist in the table

SELECT count(id) AS 'Number of rows in table'
FROM house_price_data;

#7. Now we will try to find the unique values in some of the categorical columns:

#7.a) What are the unique values in the column bedrooms?

SELECT DISTINCT bedrooms AS 'Unique values in bedrooms column'
FROM house_price_data
ORDER BY bedrooms;

#7.b) What are the unique values in the column bathrooms?

SELECT DISTINCT bathrooms AS 'Unique values in bathrooms column'
FROM house_price_data
ORDER BY bathrooms;

#7.c) What are the unique values in the column floors?

SELECT DISTINCT floors AS 'Unique values in floors column'
FROM house_price_data
ORDER BY floors;

#7.d) What are the unique values in the column condition?

SELECT DISTINCT `condition` AS 'Unique values in condition column'
FROM house_price_data
ORDER BY `condition`;

#7.e) What are the unique values in the column grade?

SELECT DISTINCT grade AS 'Unique values in grade column'
FROM house_price_data
ORDER BY grade;

#8. Arrange the data in a decreasing order by the price of the house.
#Return only the IDs of the top 10 most expensive houses in your data.

SELECT id
FROM house_price_data
ORDER BY price DESC
LIMIT 10;

#9. What is the average price of all the properties in your data?

SELECT round(avg(price), 2) as 'average price'
FROM house_price_data;

#10. In this exercise we will use simple group by to check the properties of some of the categorical variables in our data.

#10.a) What is the average price of the houses grouped by bedrooms?
#The returned result should have only two columns, bedrooms and Average of the prices.
#Use an alias to change the name of the second column.

SELECT bedrooms, round(avg(price), 2) AS 'avg price'
FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms;

#10.b) What is the average sqft_living of the houses grouped by bedrooms?
#The returned result should have only two columns, bedrooms and Average of the sqft_living.
#Use an alias to change the name of the second column.

SELECT bedrooms, round(avg(sqft_living), 2) AS 'avg spft_living'
FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms;

#10.c) What is the average price of the houses with a waterfront and without a waterfront?
#The returned result should have only two columns, waterfront and Average of the prices.
#Use an alias to change the name of the second column.

SELECT waterfront, round(avg(price), 2) AS 'avg price'
FROM house_price_data
GROUP BY waterfront
ORDER BY waterfront DESC;

#10.d) Is there any correlation between the columns condition and grade?
#You can analyse this by grouping the data by one of the variables and
#then aggregating the results of the other column.
#Visually check if there is a positive correlation or negative correlation or
#no correlation between the variables.

SELECT `condition`, round(avg(grade), 2) AS 'avg grade'
FROM house_price_data
GROUP BY `condition`
ORDER BY `condition`;

SELECT `condition`, sum(grade)
FROM house_price_data
GROUP BY `condition`
ORDER BY `condition`;

#It seems like that for lower values of condition there is a positive correlation between
#condition and grade. But this is not really the case for higher values of condition.
#This can be seen by comparing the averages of grade per condition value.
#We can see a rise of average values of grades when increasing the value of condition
#1 to 3 (where it reaches its peak) and similar averages of grades for values 3, 4 and 5 of condition.

#11. One of the customers is only interested in the following houses:
#Number of bedrooms either 3 or 4, Bathrooms more than 3, One Floor, No waterfront,
#Condition should be 3 at least, Grade should be 5 at least, Price less than 300000.
#Write a simple query to find what are the options available for them?

SELECT count(id) AS 'Amount of options for buyer'
FROM house_price_data
WHERE ((bedrooms BETWEEN 3 AND 4) AND (bathrooms > 3) AND (`floors` = 1) AND (waterfront = 0) AND (`condition` >= 3) AND (grade >= 5) AND (price < 300000));

#No houses are available at this price!

# If we take away the price condition, we would find 105 houses, as we can see with the query below:

SELECT count(id)
FROM house_price_data
WHERE ((bedrooms BETWEEN 3 AND 4) AND (bathrooms > 3) AND (`floors` = 1) AND (waterfront = 0) AND (`condition` >= 3) AND (grade >= 5));

#12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database.
#Write a query to show them the list of such properties. You might need to use a sub query for this problem.

SELECT *
FROM house_price_data
WHERE price > (2 * (SELECT avg(price) FROM house_price_data))
ORDER BY price;

#13. Since this is something that the senior management is regularly interested in, create a view of the same query.

CREATE OR REPLACE VIEW highend_houses AS
SELECT *
FROM house_price_data
WHERE price > (2 * (SELECT avg(price) FROM house_price_data))
ORDER BY price;

#14. Most customers are interested in properties with three or four bedrooms.
#What is the difference in average prices of the properties with three and four bedrooms?

SELECT bedrooms, round(avg(price), 2) AS 'avg price'
FROM house_price_data
WHERE bedrooms BETWEEN 3 AND 4
GROUP BY bedrooms;

#15. What are the different locations where properties are available in your database? (distinct zip codes)

SELECT DISTINCT zipcode
FROM house_price_data;

#16. Show the list of all the properties that were renovated.

#I use yr_renovated as proxy variable to find out whether a building was renovated at some time
SELECT DISTINCT yr_renovated
FROM house_price_data
ORDER BY yr_renovated;

#From my previous query I could see that there are buildings which have no information about any renovations being done (yr_renovated = 0).
#I use this information to filter out non-renovated properties with below query:

SELECT *
FROM house_price_data
WHERE yr_renovated > 0;

#17. Provide the details of the property that is the 11th most expensive property in your database.

#In order to filter the data set for the 11th most expensive property, I create a view with a ranking over price in descending order first:

CREATE OR REPLACE VIEW priceranking AS
SELECT *,
RANK() OVER (ORDER BY price DESC) AS price_ranking
FROM house_price_data;

#Then I use the view to filter for the 11th most expensive property:

SELECT *
FROM priceranking
WHERE price_ranking = 11;

select distinct floors from house_price_data;