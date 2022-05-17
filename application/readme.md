
# HELM version : >= v3.8.2

That is complete solution to deploy application into kubernetes and which can be used inside cicd tools like Jenkins or something like that.

| key | value |
|--|--|
| bu | Business Unit |
| project | The name of application or service |
| env | Environment |
| version | Docker image version |

**TYPE OF DEPLOYMENT**
- dryRunHelmChart = To check yaml file to validate whether it's correct or not
- deployHelmChart = To deploy application
- rollBackHelmChart = To rollback previous version

## **How to deploy applications into kubernetes**

    ./deploy [DEPLOYMENT-TYPE] $BU $PROJECT $ENV $VERSION


**Here is to deploy with real world variable**

    ./deploy 'finance' 'gl-report' 'sit' 'v0.1.0'

**Here is to rollback**

    ./deploy 'finance' 'gl-report' 'sit'
