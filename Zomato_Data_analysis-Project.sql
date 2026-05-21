CREATE DATABASE Zomato
use ZOMATO
select * from Zomato_Dataset
select * from [Country-Code]
----/* Q1. Get overall statistics for the Indian restaurant market. */ 

Select count (*) as  Restaurant_CNT,
COUNT (DISTINCT city) as City_CNT,
AVG (Rating) as AVG_Rating,
AVG (Average_cost_for_two) as AVG_Cost_For_Two,
AVG(votes) as AVG_Votes
from Zomato_Dataset
where CountryCode = 1;


---/* Q2. Top 10 Indian cities with number of restaurant, average rating, average cost */
Select Top 10 Upper(city) As City, 
count (*) as  Restaurant_CNT,
COUNT (DISTINCT city) as City_CNT,
Round(AVG (Rating),1) as AVG_Rating,
AVG (Average_cost_for_two) as AVG_Cost_For_Two
from Zomato_Dataset
where CountryCode = 1
group by City
order by 2 desc;



----* Q3. Understand pricing segments and their relationship with ratings in India. */
Select Price_range,
count (*) as  Restaurant_CNT,
round(AVG (Rating),1) as AVG_Rating,
Min (Average_cost_for_two) as AVG_Cost_For_Two,
Max (Average_cost_for_two) as AVG_Cost_For_Two,
COUNT(*)*100/ (Select COUNT(*) from Zomato_Dataset where CountryCode =1) as Percent_of_data
from Zomato_Dataset
where CountryCode = 1
group by Price_range
order by 2 desc;

-----/* Q4. Compare restaurant types based on service offerings in India.Online Delivery vs Dine-in Analysis */
Select Has_Online_delivery , Has_Table_booking,
count (*) as  Restaurant_CNT,
Round(AVG (Rating),1) as AVG_Rating,
AVG (Average_cost_for_two) as AVG_Cost_For_Two,
AVG(Votes) as AVG_Votes
from Zomato_Dataset
where CountryCode = 1
group by Has_Online_delivery , Has_Table_booking
order by 2 desc;



-----/* Q5. Identify top 15 most popular cuisine types and their performance metrics in India. */
Select top 15 Cuisines,
count (*) as  Restaurant_CNT,
Round(AVG (Rating),2) as AVG_Rating,
AVG (Average_cost_for_two) as AVG_Cost_For_Two,
AVG(Votes) as AVG_Votes
from Zomato_Dataset
where CountryCode = 1
group by Cuisines
order by 2 desc;



----/* Q6. Compare budget vs premium restaurant segments in India */

Select 
  case
   when Price_range in(1,2) then 'Under-Budget'
    when Price_range in(3,4) then 'Premium'
  End as Restaurant_Segment,
count (*) as  Restaurant_CNT,
Round(AVG (Rating),2) as AVG_Rating,
AVG (Average_cost_for_two) as AVG_Cost_For_Two,
AVG(Votes) as AVG_Votes,
sum(case when Has_online_delivery = 'Yes' then 1 else 0 end) as Online_Delv_CNT,
sum(case when Has_Table_booking = 'Yes' then 1 else 0 end) as Dine_in_CNT
from Zomato_dataset
where countrycode = 1
Group by
case
when Price_range in(1,2) then 'Under-Budget'
when Price_range in(3,4) then 'Premium'
End;



-----* Q7. City-wise Rating Distribution in Top 5 Indian Cities */
with TOP_CITIES As (
select top 5 City from Zomato_Dataset zd
where CountryCode = 1
group by City
order by COUNT(*) desc
)
select TC.City, COUNT(*) as Restaurant_CNT,
SUM(Case when Rating >= 4 then  1 else 0 end) As 'Excellent',
SUM(Case when Rating >= 3 then  1 else 0 end) As 'Good',
SUM(Case when Rating <3 then  1 else 0 end) As 'Poor',
SUM(Case when Rating = 0 then  1 else 0 end) As 'No_Rating'
from TOP_CITIES TC
join Zomato_Dataset zd
on TC.City = zd.City
group by TC.City
order by 2 DESC;



----Q8. Compare average dining costs across different countries */

Select Country, Currency,
AVG (Average_cost_for_two) as AVG_Cost_For_Two
from Zomato_Dataset zd
join [Country-Code] cd
on cd.Country_Code = zd.CountryCode
group by Country, Currency
order by 2 desc;



--/* Q9. Analyze digital service adoption across Indian cities */

Select City,
count (*) as  Restaurant_CNT,
SUM(case when Has_Online_delivery = 'Yes' then 1 else 0 end) as Digital_service_Adoption
from Zomato_Dataset
where CountryCode = 1
group by City
order by 2 desc;



--/* Q10. Top Rated Restaurants in India with High Vote Count */
Select top 10 RestaurantName, City, Cuisines, Round(Rating,2) as Rating, Votes, 
Average_Cost_for_two from Zomato_Dataset
where CountryCode = 1
and
Rating >=4 And Votes >= 100
group by  RestaurantName, City, Cuisines, Rating, Votes, Average_Cost_for_two;



---/* Q11. India vs Other Countries - Service Features Comparison */

 SELECT CASE
			WHEN COUNTRY = 'INDIA' THEN 'INDIA'
			ELSE 'OTHER COUNTRIES'
		END AS REGION,
		COUNT(*) AS _RESTAURANT_CNT ,
		Round(AVG(RATING),1) AS AVG_RATING,
	   AVG(Average_Cost_for_two) AS COST_FOR_TWO,
	   AVG(VOTES) AS AVG_VOTE ,
	   SUM(CASE WHEN Has_Online_delivery ='YES' THEN 1 ELSE 0 END) AS DIGITAL_ADOPTION_CNT,
	  SUM(CASE WHEN Has_Online_delivery ='YES' THEN 1 ELSE 0 END) *100 /COUNT(*) AS DIGITAL_PERCENT
FROM ZOMATO_DATASET ZD
INNER JOIN [Country-Code] CC
ON CC.Country_Code=ZD.COUNTRYCODE
GROUP BY  CASE
			WHEN COUNTRY = 'INDIA' THEN 'INDIA'
			ELSE 'OTHER COUNTRIES'
		END;


------ 12 Market Penetration Analysis - India vs International= - 'India', 'United States', 'UAE', 'Singapore', 'Australia'

   SELECT CASE
				WHEN COUNTRY = 'INDIA' THEN 'INDIA'
					WHEN COUNTRY = 'United States' THEN 'United States'
						WHEN COUNTRY = 'UAE' THEN 'UAE'
							WHEN COUNTRY = 'Singapore' THEN 'Singapore'

			ELSE 'Australia'
		END AS REGION,
		COUNT(*) AS _RESTAURANT_CNT ,
		ROUND(AVG(RATING),1) AS AVG_RATING,
	   AVG(Average_Cost_for_two) AS COST_FOR_TWO,
	   AVG(VOTES) AS AVG_VOTE ,
	   SUM(CASE WHEN Has_Online_delivery ='YES' THEN 1 ELSE 0 END) AS DIGITAL_ADOPTION_CNT,
	  SUM(CASE WHEN Has_Online_delivery ='YES' THEN 1 ELSE 0 END) *100 /COUNT(*) AS DIGITAL_PERCENT
FROM ZOMATO_DATASET ZD
INNER JOIN [Country-Code] CC
ON CC.Country_Code=ZD.COUNTRYCODE
GROUP BY  CASE
WHEN COUNTRY = 'INDIA' THEN 'INDIA'
					WHEN COUNTRY = 'United States' THEN 'United States'
						WHEN COUNTRY = 'UAE' THEN 'UAE'
							WHEN COUNTRY = 'Singapore' THEN 'Singapore'

			ELSE 'Australia'
		END; 



----Q13. Cuisine Diversity Analysis by Indian Cities.--- Measure culinary diversity across Indian cities.
SELECT * FROM  Zomato_Dataset

Select CITY, Cuisines,
count (*) as  Restaurant_CNT,
Round(AVG (Rating),1) as AVG_Rating,
AVG (Average_cost_for_two) as AVG_Cost_For_Two,
Count(PRICE_RANGE) AS Price_range,
AVG(Votes) as AVG_Votes
from Zomato_Dataset
where CountryCode = 1
group by CITY, Cuisines
order by 3 desc;
