![motogp9058-removebg-preview](https://github.com/user-attachments/assets/7d1aae2c-053c-448c-b45f-9618c4ee14d7)

**Analysis of MotoGP data from 1949 to the present**, developed as part of my final project for a Master of Business Intelligence & Advanced Analytics.
# Why MotoGP?
+ First of all, I want to provide an **analytical tool** that can help people, whether professionals or individuals, to draw out conclusions about events that have ocurred in this sport.
+ Also, I would like this to be **my presentation as Data Engineer**, showing my skills and having it in a Git repo, available to anyone interested.
+ And last but not least, **my father is a big fan of this sport**, and I'm motivated to give him a tool that he can dive in, and use to extract information that may be relevant for him.
# Data Source
I extract all the data from the Racing Mike's API as single data source, which ingest data from the official MotoGP's API.
Endpoints overview:
+ **Seasons**: seasons of a given year.
+ **Events**: information about all events in a year, each event contains a series of sessions.
+ **Category**: existing categories, for this analysis only data from the MotoGP category will be used.
+ **Sessions**: information about the existing sessions of a given event.
+ **Full Results**: all information related to a race, results of riders, teams, circuit, etc.
+ **World Standing Riders**: results of the global classification of a given year.
+ **Calendar**: information about the next event.

# ETL

Most of the services used are from Azure Synapse Analytics environment, you can see the full architecture below.

The ETL(Extract, Transform, Load) follows a **Medallion Architecture**, designed to divide, organize and manage the data processing tasks. Data is ingested and stored in  Azure Data Lake Storage Gen 2 while Spark notebooks are used to transform it between layers.  
The architecture consists of three layers:
+ Bronze Layer: Stores raw and unprocessed data from the API, in JSON format.  
+ Silver Layer: Contains cleaned, validated, and deduplicated data.  
+ Gold Layer: Holds dimensional tables based on the clean data from the Silver layer, optimized for analytics and reporting.

![MotoGP TFM Architecture](https://github.com/user-attachments/assets/c7914bdc-c7ec-4476-9488-d44a437c3528)

1. Following the architecture above, the data is **extracted** using **Synapse Pipelines**, with a bunch of **nested pipelines** that orchestrate calls to the API.
To understand the logic of this calls, the bulk of the relevant data is located in the Full Results endpoint, but it need some key parameters
to get the correct data. These parameters are obtained through a sequence of calls to an specific API endpoint, which provides the ID's 
needed to form the final call to Full Results endpoint. This is the sequence to follow:
    1. **Year**: First, we choose the year for which we want to get the data.
    2. **Event ID**: We use the obtained year to make the next call and get the ID of the Events for that year.
    3. **Session ID**: With the Event ID and the year, we make a call to get the Session ID of the race of this event.
    4. **Full Results**: With the Session ID, the Event ID and the year, we make the final call to the Full Results endpoint to get the full data.
       
    ![Pipelines](https://github.com/user-attachments/assets/40fbb437-ee59-4e9a-8eb6-1e3e18695591)

    + Just the entities **Events**, **World Standing Riders** and **Full Results** have the relevant data to analyze. The data from the first two entities is ingested in the Entities Loop pipeline, using a Copy Data activity, those two entities dont need any key parameters so it's not needed to nest any more pipeline.
    + However, the other entity does need it so there is four nested pipelines inside the folder Getting_Full_Results with the sole task of retrieve the correct ID's to form the final call to Full Results endpoint. 
    + The calls runs in parallel using the Batch Count option at 10, extracting 5 years of data in less than 30 minutes.
    + After ingest all the data with the pipelines, we have it ready in the Bronze layer, stored in a Azure Data Lake Storage Gen 2.

2. **Data transformation** is performed using two Spark notebooks: 
    + **Silver_Orchestrator**: Notebook that orchestrates the loading of data from the Bronze layer, removing **unwanted values** ​​and **deduplicating records**. It keeps the relevant columns and adds some necessary **metadata**, such as the loading date. Finally, the data is stored in **Delta** format, merging with the existing data or creating the tables if they do not exist. This data is partitioned by year and month and stored in an ADLS container exclusive to the **Silver** layer.
    + **Gold_Orchestrator**: Notebook is responsible of creating all the **fact and dimension tables** by **joining the curated tables** in the Silver layer. Additionally, some columns are renamed to easily identify them during the analysis. The data is saved in **Delta** format, executing a merge with the existing data or creating a new table, and is stored in an ADLS container dedicated to the **Gold** layer.

3. **Data load** for analysis:
    + Data loading is done through **SQL views**, which expose the data from the Gold layer in a **Synapse Serverless SQL database**. This database and these views provide Power BI with a connection point to import the stored data using the Serverles SQL endpoint, simplifying its querying and analysis.

# Power BI Report

> ### Races page:
> 
![PBICarreras](https://github.com/user-attachments/assets/7fd00ec2-0956-4363-b84e-5764216d5ad4)

> ### Riders page:
> 
![PBIPilotos](https://github.com/user-attachments/assets/7d4f512e-66b7-49c5-bcd5-2bad6eb1bd78)

> ### Stadistics page:
> 
![PBIStatics](https://github.com/user-attachments/assets/1537f4ea-3790-4eab-bbf5-9ad3823c2916)

> ### Standings page:

![PBIStandings](https://github.com/user-attachments/assets/42ee19d3-1e69-4022-ac8f-8906f4f868cf)

> ### Semantic Model
 
![Semantic Model](https://github.com/user-attachments/assets/6ecea468-9cbc-48f8-83db-e83997aa4fc7)

# CONTACT

> If you are interested in my work, or want to contact me for anything else, feel free to write me by email at:  
***mariojuradogalan@gmail.com***  
or via LinkedIn  
***www.linkedin.com/in/mariojuradogalan***

![marc-marquez-gresini-racing-removebg-preview](https://github.com/user-attachments/assets/c0f9fb70-dc36-4a85-9f83-86c779ef21f7)
