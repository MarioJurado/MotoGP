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

I build a Medallion architecture in order to divide and organize the data processing tasks, using Azure Data Lake Storage Gen 2 to store the data 
and Spark notebooks to process it between layers.  
This layers are Bronze to store raw data, Silver for cleaned and deduplicated data and Gold for dimensional tables built from Silver outcome.

![MotoGP TFM Architecture](https://github.com/user-attachments/assets/25a6319e-80bb-4fd8-9b72-60535d9dca99)

1. Following the architecture above, the data is ingested using **Synapse Pipelines**, with a bunch of **nested pipelines** that orchestrate calls to the API.
To understand the logic of this calls, the bulk of the relevant data is located in the Full Results endpoint, but it need some key parameters
to get the correct data. These parameters are obtained through a sequence of calls to an specific API endpoint, which provides the ID's 
needed to form the final call to Full Results endpoint. This is the sequence to follow:
    1. **Year**: First, we choose the year for which we want to get the data.
    2. **Event ID**: We use the obtained year to make the next call and get the ID of the Events for that year.
    3. **Session ID**: With the Event ID and the year, we make a call to get the Session ID of the race of this event.
    4. **Full Results**: With the Session ID, the Event ID and the year, we make the final call to the Full Results endpoint to get the full data.
2. This extracted data is deposited in a Azure Data Lake Storage Gen 2 

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

> If you are interested in my work, or want to contact me for anything else, feel free to write me at:  
***mariojuradogalan@gmail.com***

![marc-marquez-gresini-racing-removebg-preview](https://github.com/user-attachments/assets/c0f9fb70-dc36-4a85-9f83-86c779ef21f7)
