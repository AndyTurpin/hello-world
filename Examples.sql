/* Hello Andy 21-08-2023
*/
select *
  FROM [FireServiceManager_Live].[TPD].[Incidents]
  JOIN [FireServiceManager_Live].[TPD].[IncidentVehicles] ON Incidents.Id = IncidentVehicles.IncidentId
  where CallDateTime > '20190401'

select *,
  (select min(TimeMobilised) from [FireServiceManager_Live].[TPD].[IncidentVehicles] where Incidents.Id = IncidentVehicles.IncidentId) as FirstMobilised,
  (select min(TimeMobile) from [FireServiceManager_Live].[TPD].[IncidentVehicles] where Incidents.Id = IncidentVehicles.IncidentId) as FirstMobile,
  (select min(TimeAtScene) from [FireServiceManager_Live].[TPD].[IncidentVehicles] where Incidents.Id = IncidentVehicles.IncidentId) as FirstAtScene,
  (select min(TimeAvailable) from [FireServiceManager_Live].[TPD].[IncidentVehicles] where Incidents.Id = IncidentVehicles.IncidentId) as FirstAvailable,
  (select max(TimeAvailable) from [FireServiceManager_Live].[TPD].[IncidentVehicles] where Incidents.Id = IncidentVehicles.IncidentId) as LastAvailable
  FROM [FireServiceManager_Live].[TPD].[Incidents]
  where CallDateTime > '20190401'

select *, datediff(minute, TimeMobilised, TimeMobile) as TimetoMobilise,  as TimetoArrive
  FROM [FireServiceManager_Live].[TPD].[Incidents]
  JOIN [FireServiceManager_Live].[TPD].[IncidentVehicles] ON Incidents.Id = IncidentVehicles.IncidentId
  where CallDateTime > '20191001' --and CallDateTime < '20191109' and IncidentNumber = 11618
  order by TimetoMobilise desc


  
  /* Incidents along with first attendance times */
  SELECT *,
  (select min(timeMobilised) FROM [FireServiceManager_Live].[TPD].[IncidentVehicles] where IncidentVehicles.IncidentId = Incidents.Id) as FirstMobilised,
  (select min(timeMobile) FROM [FireServiceManager_Live].[TPD].[IncidentVehicles] where IncidentVehicles.IncidentId = Incidents.Id) as FirstMobile,
  (select min(timeAtScene) FROM [FireServiceManager_Live].[TPD].[IncidentVehicles] where IncidentVehicles.IncidentId = Incidents.Id) as FirstAtScene,
  datediff(SECOND, CallDateTime, (select min(timeMobilised) FROM [FireServiceManager_Live].[TPD].[IncidentVehicles] where IncidentVehicles.IncidentId = Incidents.Id)) as Secs2Mobilise,
  datediff(SECOND, 
    (select min(timeMobilised) FROM [FireServiceManager_Live].[TPD].[IncidentVehicles] where IncidentVehicles.IncidentId = Incidents.Id),
    (select min(timeMobile) FROM [FireServiceManager_Live].[TPD].[IncidentVehicles] where IncidentVehicles.IncidentId = Incidents.Id)) as Secs2Mobile,
  datediff(SECOND, 
    (select min(timeMobile) FROM [FireServiceManager_Live].[TPD].[IncidentVehicles] where IncidentVehicles.IncidentId = Incidents.Id),
    (select min(timeAtScene) FROM [FireServiceManager_Live].[TPD].[IncidentVehicles] where IncidentVehicles.IncidentId = Incidents.Id)) as Secs2AtScene
  FROM [FireServiceManager_Live].[TPD].[Incidents]
  where calldatetime >= '20180401' 
  
  
   select FORMAT(calldatetime,'yy MMMM')
  from [FireServiceManager_Live].[TPD].Incidents
  where calldatetime > '20181101'
  group by FORMAT(calldatetime,'yy MMMM')
  order by FORMAT(calldatetime,'yy MMMM')
  
   select FORMAT(calldatetime,'yy MMMM') as "Month",
  FORMAT(calldatetime,'yy MM') as "Month Order",
  count(*) as "Total",
  (select count(*) from [FireServiceManager_Live].[TPD].Incidents i where FORMAT(i.calldatetime,'yy MMMM') = FORMAT(o.calldatetime,'yy MMMM') and i.IncidentCategory='Fire') as "Fire",
  (select count(*) from [FireServiceManager_Live].[TPD].Incidents i where FORMAT(i.calldatetime,'yy MMMM') = FORMAT(o.calldatetime,'yy MMMM') and i.IncidentCategory='False Alarm') as "False Alarm"
  from [FireServiceManager_Live].[TPD].Incidents o
  where calldatetime > '20181101'
  group by FORMAT(calldatetime,'yy MMMM'), FORMAT(calldatetime,'yy MM')
  order by FORMAT(calldatetime,'yy MM')
 
 -- To report on the past completed 12 months
  select FORMAT(calldatetime,'MMM yyyy') as "Month",
  FORMAT(calldatetime,'yy MM') as "Month Order",
  IncidentCategory,
  count(*) as "Incidents"
  from [FireServiceManager_Live].[TPD].Incidents o
  where FORMAT(calldatetime,'yy MM') >= FORMAT(Convert(date, (DATEADD(year, -1, getdate()))),'yy MM')  
     and FORMAT(calldatetime,'yy MM') < FORMAT(getdate(),'yy MM')
  group by FORMAT(calldatetime,'MMM yyyy'), FORMAT(calldatetime,'yy MM'), IncidentCategory
  order by FORMAT(calldatetime,'yy MM'), IncidentCategory
 
 
 
 -- To group by Financial Year
 select year(dateadd(month, -3, calldatetime)) as FiscalYear,
  count(*) as Incidents
  from [FireServiceManager_Live].[TPD].Incidents o
  where calldatetime < '2019-04-01' --and irsstatusid=70  --and otb=0
 group by year(dateadd(month, -3, calldatetime))
  order by year(dateadd(month, -3, calldatetime))
  
  
select FORMAT(dateadd(month, -3, calldatetime),'yyyy') as FYear, IncidentNumber, CallDateTime, Callsign, datediff(minute, TimeMobilised, TimeMobile) as TimetoMobilise, datediff(minute, TimeMobile, TimeAtScene) as TimetoArrive
  FROM [FireServiceManager_Live].[TPD].[Incidents]
  JOIN [FireServiceManager_Live].[TPD].[IncidentVehicles] ON Incidents.Id = IncidentVehicles.IncidentId
  where CallDateTime > '20190101' --and CallDateTime < '20191109' and IncidentNumber = 11618
  order by CallDateTime

  
select FORMAT(dateadd(month, -3, calldatetime),'yy')+'_'+RIGHT('00000'+IncidentNumber,5) as Incident, CallDateTime, Callsign, datediff(second, TimeMobilised, TimeMobile)/60.0 as TimetoMobilise, datediff(second, TimeMobile, TimeAtScene)/60.0 as TimetoArrive
  FROM [FireServiceManager_Live].[TPD].[Incidents]
  JOIN [FireServiceManager_Live].[TPD].[IncidentVehicles] ON Incidents.Id = IncidentVehicles.IncidentId
  where CallDateTime > '20190101' --and CallDateTime < '20191109' and IncidentNumber = 11618
  order by CallDateTime
  
  
  
  
-- Find 'bad' data in IncidentVehicles
select * from [FireServiceManager_Live].[TPD].[IncidentVehicles]
where TimeMobilised is NULL or TimeMobile is NULL or TimeAtScene is NULL 
or TimeMobilised > TimeMobile or TimeMobile > TimeAtScene or TimeMobilised > TimeAtScene




  select incidents.*
      ,(select min([TimeAtScene]) from [PerformanceTeam_Play].[TPD].[IncidentVehicles] where Incidents.Id = IncidentVehicles.IncidentId) as FirstTimeAtScene
    FROM [PerformanceTeam_Play].[TPD].[Incidents]
	where calldatetime > '2019-11-01'



alter table [PerformanceTeam_Play].[TPD].[Incidents]
add FirstTimeAtScene date,
TimeToScene decimal (10,2);

select top (10) * from [PerformanceTeam_Play].[TPD].[Incidents]

update [PerformanceTeam_Play].[TPD].[Incidents]
set FirstTimeAtScene = (select min([TimeAtScene]) from [PerformanceTeam_Play].[TPD].[IncidentVehicles] where Incidents.Id = IncidentVehicles.IncidentId)
where calldatetime > '2014-04-01'


update [PerformanceTeam_Play].[TPD].[Incidents]
set TimeToScene = datediff(second, CallDateTime, FirstTimeAtScene)/60.0
where calldatetime > '2014-04-01'


select * 
from [PerformanceTeam_Play].[TPD].[Incidents]
where calldatetime > '2018-11-01'

alter table [PerformanceTeam_Play].[TPD].[Incidents]
alter column FirstTimeAtScene datetime

select distinct propertytypelevel1
from [PerformanceTeam_Play].[TPD].[Incidents]

select FORMAT(dateadd(month, -3, calldatetime),'yyyy') as FYear, count(*)
from [PerformanceTeam_Play].[TPD].[Incidents]
where calldatetime > '2017-04-01' and propertytypelevel1 = 'Building'
group by FORMAT(dateadd(month, -3, calldatetime),'yyyy')

select FORMAT(dateadd(month, -3, calldatetime),'yyyy') as FYear, count(*), sum(case when TimeToScene <=11 then 1 else 0 end), sum(case when TimeToScene <=11 then 1 else 0 end)*100.0 / count(*)
from [PerformanceTeam_Play].[TPD].[Incidents]
where calldatetime > '2014-04-01' and propertytypelevel1 = 'Building' and IRSStatusId >=70
group by FORMAT(dateadd(month, -3, calldatetime),'yyyy')

-- Populate second arrival time
update [PerformanceTeam_Play].[TPD].[Incidents]
set SecondTimeAtScene = (select TimeAtScene
from [PerformanceTeam_Play].[TPD].[IncidentVehicles]
where incidentid=Incidents.Id
order by timeatscene asc
offset 1 rows
fetch next 1 rows only)
where calldatetime > '2014-01-01'


/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Id]
      ,[IrsSystemId]
      ,[IRSVendor]
      ,[IncidentNumber]
      ,[CallDateTime]
      ,[StopDateTime]
      ,[ClosedDateTime]
      ,[DateofCallId]
      ,[DateofStopId]
      ,[DateofCloseId]
      ,[TimeofCallId]
      ,[TimeofStopId]
      ,[TimeofCloseId]
      ,[OperationalStationId]
      ,[IncidentCategory]
      ,[MobiliseIncidentType]
      ,[SpecialServiceType]
      ,[Easting]
      ,[Northing]
      ,[UPRN]
      ,[IRSStatusId]
      ,[OTB]
      ,[IsPrimaryFire]
      ,[IsRTC]
      ,[IsChimney]
      ,[NumberOfVehiclesDeployed]
      ,[EquipmentUsed]
      ,[VictimsInvolved]
      ,[HazardousMaterialsInvolved]
      ,[Extrication]
      ,[LocationAdministrativeArea]
      ,[NumberofCrew]
      ,[SmallestCrew]
      ,[TotalEquipmentUsed]
      ,[PropertyTypeCode]
      ,[PropertyTypeLevel1]
      ,[PropertyTypeLevel2]
      ,[PropertyTypeLevel3]
      ,[MobilisedIncidentTypeCode]
      ,[FalseAlarmReasonCode]
      ,[FireCauseCode]
      ,[OIC]
  FROM [FireServiceManager_Live].[TPD].[Incidents]


  select year(dateadd(month, -3, calldatetime)) as FYear, *
  select distinct irsstatusid, count(8)
  from [FireServiceManager_Live].[TPD].[Incidents]
  where year(dateadd(month, -3, calldatetime)) = 2018
  group by irsstatusid

  select *
  from [FireServiceManager_Live].[TPD].[Incidents]
  where year(dateadd(month, -3, calldatetime)) = 2018
  and irsstatusid = 70

  select year(dateadd(month, -3, calldatetime)) as FYear, *
  from [PerformanceTeam_Play].[TPD].[Incidents]
  where year(dateadd(month, -3, calldatetime)) = 2018
  and irsstatusid=70
  and IsPrimaryFire <> 0
  and FirstTimeToScene is not null
  and FirstTimeToScene >11
  order by FirstTimeToScene 


with IncidentsFirstAtScene as
( 
  Select IncidentId, min(TimeAtScene) as [FirstTimeAtScene]
  from [FireServiceManager_Live].[TPD].[IncidentVehicles]
  group by IncidentId
),
IncidentsSecondAtScene as
(
  Select IncidentId, min(TimeAtScene) as [FirstTimeAtScene]
  from [FireServiceManager_Live].[TPD].[IncidentVehicles]
  group by IncidentId
)


select id
from common.DateLookups
order by id desc
offset 1 rows
fetch next 1 rows only

Select IncidentId, min(TimeAtScene) as [FirstTimeAtScene]
  from [FireServiceManager_Live].[TPD].[IncidentVehicles]
  where timeatscene > '2019-11-01'
  group by IncidentId


select top (10) * from [PerformanceTeam_Play].[TPD].[Incidents]
order by vehicles desc

select * from [PerformanceTeam_Play].[TPD].[Incidentvehicles]
where incidentid = 351494230
order by timeatscene asc

select
  IncidentId
  ,count(callsign) over(partition by incidentid) as Vehicles
  ,callsign
  ,min(TimeAtScene) over(partition by IncidentId) as FirstTimeAtScene 
from [PerformanceTeam_Play].[TPD].[Incidentvehicles]
where timeatscene > '2019-09-19' and timeatscene < '2019-09-21'
--group by incidentid



-- List of incidents, together with the time and id of first appliance on scene
with cteatscene as
(SELECT t.incidentid, t.callsign, t.timeatscene
FROM [PerformanceTeam_Play].[TPD].[IncidentVehicles] t
JOIN (SELECT incidentid, min(timeatscene) as mi FROM [PerformanceTeam_Play].[TPD].[IncidentVehicles] GROUP BY incidentid) j ON
  t.timeatscene = j.mi AND
  t.incidentid  = j.incidentid
--where timeatscene >= '2019-11-01'
--ORDER BY incidentid
)
select i.incidentnumber, i.calldatetime, v.callsign as [FirstCSatScene], v.timeatscene as [FirstTimeAtScene], datediff(second, CallDateTime, TimeAtScene)/60.0 as [TimeToScene]
from [PerformanceTeam_Play].[TPD].[Incidents] i
join cteatscene v on i.id=v.incidentid
where calldatetime >= '2019-11-01' and callsign = 'FGS03P3'
order by calldatetime asc

with cteatscene as
(SELECT t.incidentid, t.callsign, t.timeatscene
FROM [FireServiceManager_Live].[TPD].[IncidentVehicles] t
JOIN (SELECT incidentid, min(timeatscene) as mi FROM [FireServiceManager_Live].[TPD].[IncidentVehicles] GROUP BY incidentid) j ON
  t.timeatscene = j.mi AND
  t.incidentid  = j.incidentid
)
-- Note that the above returns multiple rows for single incident when two appliances arrive within the same second
select i.*, v.callsign as [FirstCallsignAtScene], v.timeatscene as [FirstTimeAtScene], datediff(second, CallDateTime, TimeAtScene)/60.0 as [TimeToScene]
from [FireServiceManager_Live].[TPD].[Incidents] i
left join cteatscene v on i.id=v.incidentid
where calldatetime >= '2018-04-01' and calldatetime<'2019-04-01'
--where calldatetime >= '2019-11-01' and callsign = 'FGS03P3'
order by calldatetime asc

alter table [PerformanceTeam_Play].[TPD].[Incidents]
add FirstCallsignAtScene [nvarchar](7),
SecondCallsignAtScene [nvarchar](7)

update [PerformanceTeam_Play].[TPD].[Incidents]
set FirstCallsignAtScene = (select top 1 callsign 
                            from [PerformanceTeam_Play].[TPD].[IncidentVehicles] 
                            where [PerformanceTeam_Play].[TPD].[Incidents].id = [PerformanceTeam_Play].[TPD].[IncidentVehicles].incidentid 
							and [PerformanceTeam_Play].[TPD].[Incidents].FirstTimeAtScene = [PerformanceTeam_Play].[TPD].[IncidentVehicles].TimeAtScene)
where FirstTimeAtScene is not null

update [PerformanceTeam_Play].[TPD].[Incidents]
set SecondCallsignAtScene = (select top 1 callsign 
                            from [PerformanceTeam_Play].[TPD].[IncidentVehicles] 
                            where [PerformanceTeam_Play].[TPD].[Incidents].id = [PerformanceTeam_Play].[TPD].[IncidentVehicles].incidentid 
							and [PerformanceTeam_Play].[TPD].[Incidents].SecondTimeAtScene = [PerformanceTeam_Play].[TPD].[IncidentVehicles].TimeAtScene)
where SecondTimeAtScene is not null


select year(dateadd(month, -3, calldatetime)) as FYear, count(*) as [All Incs], count(case when FirstTimeToScene <= 11 then 1 else null end) as [In Time]
from [PerformanceTeam_Play].[TPD].[Incidents]
--where calldatetime > '2019-11-01'
group by year(dateadd(month, -3, calldatetime))
order by year(dateadd(month, -3, calldatetime)) 

select year(dateadd(month, -3, calldatetime)) as FYear
, FirstCallsignAtScene
, count(*) as [All Incs]
, count(case when FirstTimeToScene <= 11 then 1 else null end) as [In Time]
, count(case when FirstTimeToScene <= 11 then 1 else null end)*100.0/count(*) as [PC inTime]
from [PerformanceTeam_Play].[TPD].[Incidents]
--where calldatetime > '2019-11-01'
group by year(dateadd(month, -3, calldatetime)), FirstCallsignAtScene
order by year(dateadd(month, -3, calldatetime)), FirstCallsignAtScene



alter table [PerformanceTeam_Play].[TPD].[Incidents]
add FirstCallsignMobilised [nvarchar](7),
SecondCallsignMobile [nvarchar](7)

select FYear
, count(*) as [All Incs]
, count(case when datediff(second, FirstTimeMobilised, FirstTimeAtScene) <= (11*60.0) then 1 else null end) as [In Time]
, count(case when datediff(second, FirstTimeMobilised, FirstTimeAtScene) <= (11*60.0) then 1 else null end)*100.0/count(*) as [PC inTime]
, count(case when datediff(second, CallDateTime, FirstTimeAtScene) <= (11*60.0) then 1 else null end) as [In Time]
, count(case when datediff(second, CallDateTime, FirstTimeAtScene) <= (11*60.0) then 1 else null end)*100.0/count(*) as [PC inTime]
from [PerformanceTeam_Play].[TPD].[Incidents]
where calldatetime > '2014-04-01'
and IRSStatusId = 70
and IsPrimaryFire = 1
and otb = 0
AND FirstTimeAtScene IS NOT NULL
group by FYear
order by FYear

  select year(dateadd(month, -3, DateLookupId))
, count(*) as [All Incs]
, count(case when Standard1='MET' then 1 else null end) as [MET]
--, count(case when datediff(second, FirstTimeMobilised, FirstTimeAtScene) <= (11*60.0) then 1 else null end)*100.0/count(*) as [PC inTime]
, count(case when Standard1='FAILED' then 1 else null end) as [FAILED]
--, count(case when datediff(second, CallDateTime, FirstTimeAtScene) <= (11*60.0) then 1 else null end)*100.0/count(*) as [PC inTime]
from [FireServiceManager_Live].[TPD].[ResponseStandards]
where DateLookupId > '2014-04-01'
group by year(dateadd(month, -3, DateLookupId))
order by year(dateadd(month, -3, DateLookupId))


