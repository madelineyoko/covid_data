# COVID-19 Dataset
### Alex the Analyst Portfolio Series  
  
## Project Overview
Alex Freberg created a Portfolio Project Series on his youtube channel, Alex the Analyst. The playlist for these tutorials can be found [here](https://www.youtube.com/watch?v=qfyynHBFOsM&list=PLUaB-1hjhk8H48Pj32z4GZgGWyylqv85f&ab_channel=AlexTheAnalyst).  
  
This repo is storing the results of myself following along to 3/4 videos, exploring and visualizing Covid-19 data using SQL and Tableau, as well as cleaning data with SQL using a nashville housing dataset. I will be storing the queries I reproduced from Alex's videos as well as some of my own which I used for further exploration and viz's on the COVID-19 data.  
  
## EDA Queries
The queries in Alex's videos walked through using basic arithmetic in SQL to see the percent of the population that had been infected by Covid, as well as the death percentage for those infected. We made use of the `MAX()` function to identify the locations where the percent of infection and death had been the highest, and the `CAST()` function to transform certain variables into integers. The `SUM()` function was used in order to explore some global statistics.  
  
Temporary tables, table joins and window functions were used in order to measure the sum of cases, deaths and vaccinations over time, as well as the percent of the population that was populated at a given time.  
  
In my own interest, I explored the statistics for Canada specifically in further queries. My main interest was whether the vaccine would show to slow any of the new deaths, and so I used table joins and window functions to explore the total number of deaths against the total number of vaccinations.  
  
## Visualizations
The visualization I built based solely on Alex's videos can be found on [here](https://public.tableau.com/app/profile/madeline.yoko.lownie/viz/CovidDashboard_16279640860270/Dashboard1).
![image](https://user-images.githubusercontent.com/87314229/128212294-6ad83246-7688-4d8f-ac4c-546ce3d2ec48.png)
  
This dashboard shows the Global Numbers for Covid cases, deaths, and death percentage. You can also see a bar graph of the deaths, and a line graph of percent of the population infected both separated by continent. Finally there is a map which also represents the percent of the population infected for each country.  
  
Following this video I built two versions of a dashboard to focus on the impact of vaccinations on death over time.  
[Version 1](https://public.tableau.com/app/profile/madeline.yoko.lownie/viz/Covid-19DeathsvsVaccines/Dashboard1) 
![image](https://user-images.githubusercontent.com/87314229/128216442-1c37f340-b02f-4f8d-b9e2-871c4f2f2429.png)  
  
[Version 2](https://public.tableau.com/app/profile/madeline.yoko.lownie/viz/COVID-19_v2_16280494209220/Dashboard3)
![image](https://user-images.githubusercontent.com/87314229/128216527-365bce67-502d-4635-9402-d5283f5de74b.png)  
  
Both visualizations hold the same graphs; a map which represents the death count as growing black circles, and shades of green which grow stronger as more people recieve vaccinations, a line chart representing two lines, number of deaths and number of vaccines, and a bar chart showing totals for cases, deaths, vaccinations, and people fully vaccinated. Each graph begins with the latest data, but can be filtered by Country and by Date, or seen as a timelapse from when the data began to where it ends. In the second visualization I wanted to experiment with making use of Figma objects and templates inside Tableau.  
  

## Cleaning in SQL
In the third of Alex's videos we focused on cleaning a nashville housing dataset. I have uploaded all the cleaning queries to this repo, 
