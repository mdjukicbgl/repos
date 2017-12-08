#!/usr/bin/env bash

if [ $# -ne 3 ] ; then 
  echo "Config name, scenario id and client/organisationId required. ie: $0 localhost 101 1"
  exit 1;
fi

if [ ! -f "appSettings.$1.json" ] ; then
  echo "Config file (appSettings.$1.json) not found"
  exit 1;
fi

export ASPNETCORE_ENVIRONMENT=$1
echo Using settings from $1
 
echo -n
echo Partitioning...
echo -n
dotnet run --Program partition --ModelId 100 --ModelRunId 100 --ScenarioId $2 --OrganisationId $3 --UserId 1 --PartitionCount 2 --Calculate 0 --Upload 0 --Pause 0
if [ $? -ne 0 ]; then { exit $?; } fi

echo -n
echo Calculating Partition 1...
echo -n
dotnet run --Program calc --ModelId 100 --ModelRunId 100 --ScenarioId $2 --OrganisationId $3 --UserId 1 --PartitionId 1 --PartitionCount 2 --Upload 0 --Pause 0
if [ $? -ne 0 ]; then { exit $?; } fi

echo -n
echo Calculating Partition 2...
echo -n
dotnet run --Program calc --ModelId 100 --ModelRunId 100 --ScenarioId $2 --OrganisationId $3 --UserId 1 --PartitionId 2 --PartitionCount 2 --Upload 0 --Pause 0
if [ $? -ne 0 ]; then { exit $?; } fi

echo -n
echo Uploading Partition 1...
echo -n
dotnet run --Program upload --ScenarioId $2 --OrganisationId $3 --UserId 1 --PartitionId 1 --PartitionCount 2 --Pause 0
if [ $? -ne 0 ]; then { exit $?; } fi

echo -n
echo Uploading Partition 2...
echo -n
dotnet run --Program upload --ScenarioId $2 --OrganisationId $3 --UserId 1 --PartitionId 2 --PartitionCount 2 --Pause 0
if [ $? -ne 0 ]; then { exit $?; } fi
