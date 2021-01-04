USE master;  
GO  
CREATE DATABASE Bank  
Go

use Bank;
GO

DROP TABLE risk_ratings;
DROP TABLE total_assets;
DROP TABLE daily_limit;
DROP TABLE banks;
DROP TABLE risk_lookup;

create table banks (
    id bigint NOT NULL PRIMARY KEY IDENTITY(1,1),
    bank_name varchar(100) NOT NULL UNIQUE,
    trade_approved bit NOT NULL
);
go

insert into banks (bank_name, trade_approved) values  ('Bank of America', 1), 
                                                      ('Wells Fargo', 1), 
                                                      ('Bank of Nova Scotia', 0), 
                                                      ('Royal Bank of Canada', 1), 
                                                      ('Bank of Montreal', 1), 
                                                      ('Goldman Sachs', 0), 
                                                      ('CitiBank', 1), 
                                                      ('JP Morgan', 0);


create table risk_ratings (
    bank_id bigint FOREIGN KEY REFERENCES Banks(id) not null,
    rating int not null
);
go

INSERT INTO risk_ratings (bank_id, rating) values ((select id from banks where bank_name = 'Bank of America'), 7);
INSERT INTO risk_ratings (bank_id, rating) values ((select id from banks where bank_name = 'Wells Fargo'), -4);
INSERT INTO risk_ratings (bank_id, rating) values ((select id from banks where bank_name = 'Bank of Nova Scotia'), 2);
INSERT INTO risk_ratings (bank_id, rating) values ((select id from banks where bank_name = 'Royal Bank of Canada'), -1);
INSERT INTO risk_ratings (bank_id, rating) values ((select id from banks where bank_name = 'Bank of Montreal') , 9);

create table risk_lookup (
    risk_rating int not null unique,
    risk_factor numeric(3, 2)
);
go

insert into risk_lookup (risk_rating, risk_factor) values (-5, 0.88),(-4, 0.88), ( -3, 0.88), (-2, 0.91), ( -1, 0.91), ( 0, 0.91), 
( 1, 1.05), ( 2, 1.05), ( 3, 1.05), ( 4, 1.08), ( 5, 1.08), ( 6, 1.08), ( 7, 1.13) ,( 8, 1.13), ( 9, 1.13), ( 10, 1.13);

create table total_assets (
    bank_id bigint FOREIGN KEY REFERENCES Banks(id) not null,
    total_assets bigint not null
);
go

INSERT INTO total_assets (bank_id, total_assets) values ((select id from banks where bank_name = 'Bank of America'), 1234000);
INSERT INTO total_assets (bank_id, total_assets) values ((select id from banks where bank_name = 'Wells Fargo'), 5657345);
INSERT INTO total_assets (bank_id, total_assets) values ((select id from banks where bank_name = 'Bank of Nova Scotia'), 2999002);
INSERT INTO total_assets (bank_id, total_assets) values ((select id from banks where bank_name = 'Royal Bank of Canada'), 4346823);
INSERT INTO total_assets (bank_id, total_assets) values ((select id from banks where bank_name = 'Bank of Montreal'), 15342679);

USE [Bank]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE OR ALTER FUNCTION dbo.set_limit(@bank_id bigint)
 RETURNS bigint  
 AS
  BEGIN  
   DECLARE @limit bigint; 
    SELECT @limit = (SELECT IIF((select trade_approved from banks where id = @bank_id) > 0, 
                        (SELECT calcs.risk + (iif(calcs.total_assets > 3000000, calcs.risk * .23, 0)) from 
                        (select ta.total_assets, (select 2000000 * (select max(risk_factor) from risk_lookup where risk_rating = rr.rating)) risk 
                        from risk_ratings rr 
                        join total_assets ta 
                        on (rr.bank_id =  @bank_id 
                        and ta.bank_id = rr.bank_id)) as calcs)
                     , 0) 
)

    
    RETURN @limit;  
  END;
 GO
 
create table daily_limit (
    bank_id bigint FOREIGN KEY REFERENCES Banks(id) not null,
    limit_date datetime not null,
    limit_amt bigint not null default (0)
);
go

CREATE OR ALTER TRIGGER insert_limit ON daily_limit
INSTEAD OF INSERT
  AS
  BEGIN
   INSERT daily_limit
   SELECT bank_id, limit_date, dbo.set_limit(bank_id)
   FROM inserted;
  END
  GO

INSERT INTO daily_limit (bank_id, limit_date) values ((select id from banks where bank_name = 'Bank of America'), GETDATE());
INSERT INTO daily_limit (bank_id, limit_date) values ((select id from banks where bank_name = 'Wells Fargo'), GETDATE());
INSERT INTO daily_limit (bank_id, limit_date) values ((select id from banks where bank_name = 'Bank of Nova Scotia'), GETDATE());
INSERT INTO daily_limit (bank_id, limit_date) values ((select id from banks where bank_name = 'Royal Bank of Canada'), GETDATE());
INSERT INTO daily_limit (bank_id, limit_date) values ((select id from banks where bank_name = 'Bank of Montreal'), GETDATE());