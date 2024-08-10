# Github Actions Workflows created for Mule APIs.

#### workflows list:
 * [mule_api_build_deploy_sandbox.yml](https://github.com/nswdcs/platform-mulesoft-sharepoint-api/blob/sandbox/.github/workflows/Readme.md#mule_api_build_deploy_sandboxyml)
 * [mule_api_build_artifact.yml](https://github.com/nswdcs/platform-mulesoft-sharepoint-api/blob/sandbox/.github/workflows/Readme.md#mule_api_build_artifactyml)
 * [mule_api_deploy_artifact.yml](https://github.com/nswdcs/platform-mulesoft-sharepoint-api/blob/sandbox/.github/workflows/Readme.md#mule_api_deploy_artifactyml)
  * [restart_mule_api.yml](https://github.com/nswdcs/platform-mulesoft-sharepoint-api/tree/restart-api-batch/.github/workflows#restart_mule_apiyml)
 

# Workflows functionality:

## mule_api_build_deploy_sandbox.yml

 This worklow auto-triggered for each pushes to sandbox and any other feature branches in this repo.

    Trigger: Auto
    Trigger-Events: Push
    Branches: sandbox and other feature branches
    Inputs: none
    Jobs: Build, Deploy
    Target Mule Environment: Sandbox

#### Jobs:  
     Build:   
       This job executes following steps.
          1. Check out code with the latest sha,
          2. Cache the dependencies if not exists in cache,
          3. Install Java 11 in agent,
          4. Execute maven package command with cached dependencies if exists in cache, 
          5. Relabel the built artifact(jar) with branch name and workflow run_number,
          6. Upload the artifact(jar) in github artifactory and retention-period is 90 days           
        
     Deploy:
      This job executes following steps.
          1.Check out code with the latest sha,
          2.Cache the dependencies if not exists in cache,
          3.Download the artifact,
          4.Either deploy or redeploy the artifact in mule Sandbox environment.


## mule_api_build_artifact.yml

This worklow manually-triggered to create a release artifact. 

    Trigger: Manual
    Branches: main
    Jobs: Build
  
#### Jobs: 
    Build:   
      This job executes following steps.
          1.Check out code with the latest sha,
          2.Cache the dependencies if not exists in cache,
          3.Install Java 11 in agent,
          4.Execute maven package command with cached dependencies if exists in cache, 
          5.Relabel the built artifact(jar) with branch name and workflow run_number,
          6.Upload the artifact(jar) in github artifactory and retention-period is 90 days
    

## mule_api_deploy_artifact.yml

This worklow is manually-triggered with below mentioned inputs to perform a deployment at mule sandbox / production runtime environment. 
    Trigger: Manual
    Branches: Any
    Inputs: 
        run_id* - Provide run_id of github actions to download artifact. Note: all workflows has run_id in its description.
        mule_environment* - Choose mule environment to deploy the artifact.
    Jobs: Deploy
    Target Mule Environment: Sandbox / Production



 #### Jobs: 
      Deploy:
        This job executes following steps.
            1.Check out code of main branch to retreive pom.xml,
            2.Cache the dependencies if not exists in cache,
            3.Download the artifact from github artifactory,
            4.Unzip the downloaded artifact
            5.Deploy the artifacts to selected mule runtime environment.

## restart_mule_api.yml

This worklow is scheduled and can be manually-triggered with below mentioned inputs to perform a mule api's restart. 
The schedule is to trigger at 8,9AM UTC  Monday for Sandbox and Tuesday for Production environment. But it restarts mule apis when local sydney time is 8PM on Monday & Tuesday to meet daylight savings time difference.


    Trigger: Manual/Schedule
    Branches: Any
    Inputs: 
        mule_environment* - Choose mule environment to restart api.
    Jobs: set-variables, Restart
    Target Mule Environment: Sandbox / Production

    
    ***** Repo Environment variables to be cognizant of*****
    MULE_API_NAMES : this contains api names that will be restarted by this script. Please incude api name that are available in the mule environment.
    Don't forget to add a space between api names.
    ACT_WAIT_TIME: this is the wait time the script waits before restarting next api.

 #### Jobs: 
      set-variables:
        GitHub Actions follows UTC format. This job is to check the current local time is at 8PM to set restart flag true 
        and to set the Mule runtime environment. This job executes following steps.
            1.Check the current trigger is workflow-dispatch/schedule,
            2.If trigger=schedule and current time is 8PM Monday, then set restart flag =True, environment as Sandbox otherwise restart flag=false,
            3.If trigger=schedule and current time is 8PM Tuesday, then set restart flag =True, environment as Production otherwise restart flag=false
            4.If trigger=workflow-dispatch, set restart flag = True and environment as selected in inputs.
      Restart:
            The purpose of this job is to restart mule api's one after one upon checking restarted api health status when the restart flag=true. 
            This job executes following steps.
                1.Check if restart flag is true, if true proceeds, otherwise skipped.
                2.if the flag is true, it iterate apis configured in environment variable and restart first one then wait for defined wait time to check its status before restarting next one. The script allows 3 more loop of the wait time for the restarted api to return healthy status . if restarted api does not come healthy after 4 loop count, then exit the exection with error.
                3. if the execution is exit with error, then it prints the error. this one is configured to print the error message until SMTP details are confirmed to send email notifications to team.

