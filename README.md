# Auto-Deployment
In this article you will learn how to use auto-deployment for WebSharper projects via [Azure](https://azure.microsoft.com/en-us/).
## Steps:
#### 0. Get WebSharper!
For this, all what you have to do is just running `dotnet new -i WebSharper.Templates`
#### 1. open CMD from root folder
#### 2. Log in to Azure ([create an Azure account](https://docs.microsoft.com/en-us/learn/modules/create-an-azure-account/))
```
az login --username {Username} --password {Password}
```
or you can just call
```
az login
```
That directs you to the login site.
#### 3. Run the following command
```
./auto-deploy.bat --name {AppName} --plan {Plan} --resource-group {ResourceGroup} --template {Template} --lang {Language}
```
#### 4. Congratulations! You just created your application you can use immediatly in your browser!
## Attributes

Attribute | Value
----------|------
AppName | the name of your websharper project and your web application
Plan | the plan Azure uses for your web application ([what is an azure plan?](https://docs.microsoft.com/en-us/partner-center/azure-plan-get-started))
ResourceGroup | the resource group Azure uses for your application - **IMPORTANT: you have to use an existing resource group**
Template | the WebSharper template that generates. It has two types: `web` and `asp`
Language | The programming language you project will use. There is two available languages: `C#` and `F#`

## But what does the command do exactly?
* In the first stage the command will prepare your project for deploying
  1. The .bat file will create a folder in your root directory with the name of your application. This folder will contain your project.
  2. The project will build and publish
  3. A zip file will be generated in your project folder - for deploying
* In the second stage the command will create your Azure app and deploy it
  1. firstly your plan will be created. If there is an existing plan with the same name, your application will use that instead of generating a new plan
  2. your web application will be created using the plan and the resource group
  3. the deploying will start
  4. your application will open in your default browser
## Special cases
#### If you run the .bat file with the same AppName in the same folder, you will get a short message on your console:
```
--CREATING-WS-APP--
Creating this template will make changes to existing files:
  Overwrite   ./appsettings.json
  Overwrite   ./Client.fs
  Overwrite   ./Main.html
  Overwrite   ./Remoting.fs
  Overwrite   ./Site.fs
  Overwrite   ./Startup.fs
  Overwrite   ./newWSApp.fsproj
  Overwrite   ./wsconfig.json
```
**IMPORTANT: It will overwrite your previous project so make sure you are in the good folder and you use a new appName**
#### If the following error occures you don't have a resource group with the name you used for `--resource-group`:
```
--CREATING-PLAN--
ERROR: (AuthorizationFailed) The client '{Your Username}' with object id '{Your Object ID}' does not have authorization to perform action 'Microsoft.Resources/subscriptions/resourcegroups/read' over scope '{Path of the mentioned resource group}' or the scope is invalid. If access was recently granted, please refresh your credentials.
```
**IMPORTANT: If you just get access for the resource group you only need to rerun the command with the same attributes**
#### You have to log in into your Azure account, otherwise you will get the following error:
```
--CREATING-PLAN--
ERROR: Please run 'az login' to setup account.
```
#### Your app name has to be uniqe in your region, otherwise the following error occures:
```
"--CREATING-WEBAPP--"
WARNING: Webapp '{AppName}' already exists. The command will use the existing app's settings.
ERROR: Unable to retrieve details of the existing app '{AppName}'. Please check that the app is a part of the current subscription
```
## Labels
While deploying, you can get informations where the process is going. The main stages of the deployment are highlighted in the console with upper case and `--`on the two sides of it. Example:
```
--CREATING-WS-APP--
```
# Re-building
**IMPORTANT: when you have changes on your existing project you can't use the auto-deploy command, otherwise it will overwrite your files with a new template**

If you have changes on your project you want to deploy just run the following command:
```
./re-deploy.bat --name {AppName} --resource-group {ResourceGroup}
```
Unlike auto-deploy by running this command the application won't open once again. If you closed it previously, you have to navigate to `https://{AppName}.azurewebsites.net`.

## Special cases

If you get the following error in publishing phase:
```
stdin(0,1): error FS0078: Unable to find the file '../zip.fsx' in any of
 C:\{...}\auto-deployment
```
Or the following in deploying phase:
```
ERROR: Either 'archive.zip' is not a valid local file path or you do not have permissions to access it
```
This errors indicate that you are in a wrong folder or you don't have a ws project with the given name. In this case check out your working directory and make sure you give the correct value to `--name`.

If you removed your app/plan from your resource-group after created a project with `./auto-deploy.bat` the terminal will throw the next error while deploying:
```
ERROR: (ResourceNotFound) The Resource 'Microsoft.Web/sites/{AppName}' under resource group '{ResourceGroup}' was not found. For more details please go to https://aka.ms/ARMResourceNotFoundFix
```
# 

### Still have issues? [Contact me!](https://github.com/steiner2001/auto-deployment/issues)