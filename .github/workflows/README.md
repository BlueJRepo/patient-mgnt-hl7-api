# Github Actions Workflows created for Mule APIs.

#### workflows list:
 * [mule_api_build_deploy_sandbox.yml](https://github.com/nswdcs/platform-mulesoft-sharepoint-api/blob/sandbox/.github/workflows/Readme.md#mule_api_build_deploy_sandboxyml)


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


