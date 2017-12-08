#!/usr/bin/env bash

pushd Markdown.WebApi
ASPNETCORE_ENVIRONMENT=local dotnet run
popd
