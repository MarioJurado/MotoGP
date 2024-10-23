create or alter view [dbo].[Races] as
SELECT
    *
FROM
    OPENROWSET(
        BULK 'https://datalakemotogp.dfs.core.windows.net/gold/api-racing-mike/motogp/races/',
        FORMAT = 'DELTA'
    ) AS [result]

create or alter view [dbo].[Circuits] as
SELECT
    *
FROM
    OPENROWSET(
        BULK 'https://datalakemotogp.dfs.core.windows.net/gold/api-racing-mike/motogp/circuits/',
        FORMAT = 'DELTA'
    ) AS [result]

create or alter view [dbo].[Events] as
SELECT
    *
FROM
    OPENROWSET(
        BULK 'https://datalakemotogp.dfs.core.windows.net/gold/api-racing-mike/motogp/events/',
        FORMAT = 'DELTA'
    ) AS [result]  

create or alter view [dbo].[Riders] as
SELECT
    *
FROM
    OPENROWSET(
        BULK 'https://datalakemotogp.dfs.core.windows.net/gold/api-racing-mike/motogp/riders/',
        FORMAT = 'DELTA'
    ) AS [result]

create or alter view [dbo].[Teams] as
SELECT
    *
FROM
    OPENROWSET(
        BULK 'https://datalakemotogp.dfs.core.windows.net/gold/api-racing-mike/motogp/teams/',
        FORMAT = 'DELTA'
    ) AS [result] 

create or alter view [dbo].[Standings] as
SELECT
    *
FROM
    OPENROWSET(
        BULK 'https://datalakemotogp.dfs.core.windows.net/gold/api-racing-mike/motogp/standings/',
        FORMAT = 'DELTA'
    ) AS [result]

create or alter view [dbo].[Date] as
SELECT
    *
FROM
    OPENROWSET(
        BULK 'https://datalakemotogp.dfs.core.windows.net/gold/api-racing-mike/motogp/date/',
        FORMAT = 'DELTA'
    ) AS [result]

-- Drop Views

drop view dbo.Circuits
drop view dbo.Date
drop view dbo.Events
drop view dbo.Races
drop view dbo.Riders
drop view dbo.Standings
drop view dbo.Teams