# neostatsETL
This is practice assessment from Neostat for XYZ company to load their sales data to SQL Server DB and gain insights from the data

## Points to note before setting up the SSIS project:
1. Download SQL Server Express edition and install the application. This will enable SQL Server Express instance in the system. Note down the Server name provided (A).
2. Download visual studio
3. Download SQL Server Integration Services, from the extensions of visual studio
4. Download Azure Data Studio for Azure SQL Database or SSMS (SQL Server Management Studio)
5. There is a folder in this repository or main folder (neostatETL), called src. This src folder contains the csv flat file used for data ingestion and analysis.
6. Once SSMS or Azure Data Studio is installed, open it, provide the servername captured in - A and connect to the server. 
7. Create a database of your choice in the server. Note down the Database name (B)

# Steps to setup this project in your local system:

### Step1: 
1. Download this repository or project folder in your local system and unzip it in your path.
### Step2
2. Open the unzipped folder, and go to src folder. check the Sales_Data_Ingestion.csv file. Right click on the csv file and click on "Copy as Path" (C)
### Step3
3. Once SQL Server, Visual Studio and SSIS are installed, 
open the .sln ssis solution present in main folder (neostatETL) --> neostatsETL.sln (It will open in visual studio)
### Step 4:
Once the solution is opened, go to project.params and in Parameter - 
i) change the 'DBName' parameter value to "your database name" captured in point - B
ii) change the 'FilePath' parameter value to "the path in which you downloaded this repository" captured in point - C. Remove double quotations from path " "
iii) change the 'servername' parameter value to "your server name" captured in point - A.

# Once the above setup is completed, follow below process to execute the project solution
# Step1:
1. Open neostatsETL.sln solution and open AutomatedPipeline.dtsx package.
2. In the screen, in below pane, find connection managers pane -> open the connection "SQLDBConn". Click on Test Connection. Once succeeded, go to step 2.
# Step2:
1. In AutomatedPipeline.dtsx package, execute this package. Click on "Start" on top menu.

##### This package will create and setup all the required tables (Staging, Final and Lookup) in your database, in 1st step and in 2nd step, it will load the file from src folder to your database tables. LoadSalesData package is also executed as part of AutomatedPipeline package. So, we don't need to run any other steps. Once AutomatedPipeline is complete, go to Azure data studio or SSMS and do below:
Run the query to check data in staging table - Select * from dbo.SalesData_Encrypted;
Run the query to check data in final cleaned table - Select * from dbo.Final_Sales_Data;


