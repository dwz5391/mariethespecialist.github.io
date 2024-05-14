WITH wh AS (
    SELECT *
    FROM inventory
    ORDER BY event_datetime DESC
), days AS (
    SELECT onhandquantity,
           event_datetime,
           (event_datetime - INTERVAL 90 DAY) AS day90,
           (event_datetime - INTERVAL 180 DAY) AS day180,
           (event_datetime - INTERVAL 270 DAY) AS day270,
           (event_datetime - INTERVAL 365 DAY) AS day365
    FROM wh
    LIMIT 1
), inv_90_days as (
		select coalesce(sum(onhandquantitydelta), 0) as DaysOld_90
		from wh cross join days d
		where event_type = 'InBound'
		and wh.event_datetime >=d.day90),
    inv_90_days_final as 
		(select case when DaysOld_90 > d.onhandquantity then d.onhandquantity
					else DaysOld_90
				end DaysOld_90
        from inv_90_days
        cross join days d),
	inv_180_days as (
		select coalesce(sum(onhandquantitydelta), 0) as DaysOld_180
		from wh cross join days d
		where event_type = 'InBound'
		and wh.event_datetime between d.day180 and d.day90),
	inv_180_days_final as 
		(select case when DaysOld_180 > (d.onhandquantity - DaysOld_90) then (d.onhandquantity - DaysOld_90)
					else DaysOld_180
				end DaysOld_180
        from inv_180_days
        cross join days d
        cross join inv_90_days_final),
	inv_270_days as (
			select coalesce(sum(onhandquantitydelta),0) as DaysOld_270
			from wh cross join days d
			where event_type = 'InBound'
			and wh.event_datetime between d.day270 and d.day180),
	inv_270_days_final as 
			(select case when DaysOld_270 > (d.onhandquantity - (DaysOld_90 + DaysOld_180)) then (d.onhandquantity - (DaysOld_90 + DaysOld_180))
						else DaysOld_270
					end DaysOld_270
			from inv_270_days
			cross join days d
			cross join inv_90_days_final
			cross join inv_180_days_final),
	inv_365_days as (
				select coalesce(sum(onhandquantitydelta),0) as DaysOld_365
				from wh cross join days d
				where event_type = 'InBound'
				and wh.event_datetime between d.day365 and d.day270),
	inv_365_days_final as 
				(select case when DaysOld_365 > (d.onhandquantity - (DaysOld_90 + DaysOld_180+DaysOld_270)) then (d.onhandquantity - (DaysOld_90 + DaysOld_180+DaysOld_270))
							else DaysOld_365
						end DaysOld_365
				from inv_365_days
				cross join days d
				cross join inv_90_days_final
				cross join inv_180_days_final
                corss join inv_270_days_final)


SELECT DaysOld_90 as '0-90 days old'
, DaysOld_180 as '91-180 days old'
, DaysOld_270 as '181-270 days old'
, DaysOld_365 as '271-365 days old'
FROM inv_90_days_final
cross join inv_180_days_final
cross join inv_270_days_final
corss join inv_365_days_final
;
