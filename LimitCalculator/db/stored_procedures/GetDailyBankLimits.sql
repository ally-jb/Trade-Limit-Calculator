USE [Bank]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE GetDailyBankLimits
AS

BEGIN
select ba.bank_name, rr.rating, ta.total_assets, dl.limit_amt, dl.limit_date from 
daily_limit dl join banks ba on ba.id = dl.bank_id 
join risk_ratings rr on ba.id = rr.bank_id 
join total_assets ta on ta.bank_id = ba.id
where ba.trade_approved > 0;
--and datefromparts(datepart(year, dl.limit_date), datepart(month, dl.limit_date), datepart(day, dl.limit_date)) = datefromparts(datepart(year, getdate()), datepart(month, getdate()), datepart(day, getdate()));

END;
GO