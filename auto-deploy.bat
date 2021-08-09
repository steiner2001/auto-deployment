echo off

:parse
if not "%1"=="" (
    if "%1"=="--name" (
        set appName=%2
    )
    if "%1"=="--lang" (
            set lang=%2
        )
    if "%1"=="--template" (
            set template=%2
        )
    if "%1"=="--plan" (
            set plan=%2
        )
    if "%1"=="--resource-group" (
            set resourceGroup=%2
        )
    shift
    shift
    goto :parse
)

ECHO --CREATING-WS-APP-- && dotnet new WebSharper-%template% -lang %lang% -o %appName%
cd %appName%
ECHO --BUILDING-- && dotnet build
ECHO --PUBLISHING-- && dotnet publish
dotnet fsi ../zip.fsx bin/Debug/net5.0/publish

ECHO --CREATING-PLAN-- && az appservice plan create -g %resourceGroup% -n %plan% && ECHO "--CREATING-WEBAPP--" && az webapp create -g %resourceGroup% -p %plan% -n %appName% && ECHO "--DEPLOYING--" && az webapp deploy -g %resourceGroup% -n %appName% --src-path archive.zip --type zip && start https://%appName%.azurewebsites.net
