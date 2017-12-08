@ECHO OFF
if [%1]==[] GOTO USAGE
if [%2]==[] GOTO USAGE
if [%3]==[] GOTO USAGE

SET ASPNETCORE_ENVIRONMENT=%1
ECHO Using settings from %1
 
ECHO.
ECHO Partitioning...
ECHO.
dotnet run --Program partition --ModelId 100 --ModelRunId 100 --ScenarioId %2 --OrganisationId %3 --UserId 1 --PartitionCount 2 --Calculate 0 --Upload 0 --Pause 0
if %errorlevel% neq 0 exit /b %errorlevel%

ECHO.
ECHO Calculating Partition 1...
ECHO.
dotnet run --Program calc --ModelId 100 --ModelRunId 100 --ScenarioId %2 --OrganisationId %3 --UserId 1 --PartitionId 1 --PartitionCount 2 --Upload 0 --Pause 0
if %errorlevel% neq 0 exit /b %errorlevel%

ECHO.
ECHO Calculating Partition 2...
ECHO.
dotnet run --Program calc --ModelId 100 --ModelRunId 100 --ScenarioId %2 --OrganisationId %3 --UserId 1 --PartitionId 2 --PartitionCount 2 --Upload 0 --Pause 0
if %errorlevel% neq 0 exit /b %errorlevel%

ECHO.
ECHO Uploading Partition 1...
ECHO.
dotnet run --Program upload --ScenarioId %2 --OrganisationId %3 --UserId 1 --PartitionId 1 --PartitionCount 2 --Pause 0
if %errorlevel% neq 0 exit /b %errorlevel%

ECHO.
ECHO Uploading Partition 2...
ECHO.
dotnet run --Program upload --ScenarioId %2 --OrganisationId %3 --UserId 1 --PartitionId 2 --PartitionCount 2 --Pause 0
if %errorlevel% neq 0 exit /b %errorlevel%

GOTO END


:USAGE
echo Config name scenario id and clientId/organisationId required. ie: %0 localhost 101 1
exit /B 1

:END

