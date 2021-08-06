echo off

:parse
if not "%1"=="" (
    if "%1"=="--name" (
        set appName=%2
    )
    if "%1"=="--resource-group" (
            set resourceGroup=%2
        )
    shift
    shift
    goto :parse
)

cd %appName%
ECHO "--BUILDING--" && dotnet build
ECHO "--PUBLISHING--" && dotnet publish
dotnet fsi ../zip.fsx bin/Debug/net5.0/publish

ECHO "--DEPLOYING--" && az webapp deploy -g %resourceGroup% -n %appName% --src-path archive.zip --type zip
