# Trade-Limit-Calculator
Read-only web application that displays approved banks trade limits


This application was built with .NET core and the React template from Visual Studio and has a SQL Server Express data layer. 

It is a read only application that reads Bank Trade Limits from a stored procedure.

When importing the solution file (LimitCalculator.sln) into Visual Studio and running in debug this should initiate the command for npm install on the client side. 
If not you will need to navigate to the ClientApp directory in the console and run npm install

If you happen upon build errors you may also need to run the command Update-Package -reinstall in the package manager console in Visual Studio

### SQL Server Express Data Layer

In the root of the LimitCalculator directory you will see the db directory. Run initDB.sql in a desired location to setup the 'Bank' database.
This creates the trigger that handles logic for determining Bank Trade Limits.

In db/stored_procedures you will find GetDailyBankLimits. Compile this as this is how data is retrieved.

NOTE: Also present is a commented out piece of this procedure that only pulls back data for the current date. 
This will pull back all entries for trade approved banks if this comment is left, which may be fine.

Finally the limit_calculator_db_diagram.png is the diagram for the database as requested.
