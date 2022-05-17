Terraform v1.1.9
on darwin_amd64
+ provider registry.terraform.io/hashicorp/aws v3.75.1
+ provider registry.terraform.io/hashicorp/cloudinit v2.2.0
+ provider registry.terraform.io/hashicorp/kubernetes v2.11.0
+ provider registry.terraform.io/hashicorp/local v2.2.2
+ provider registry.terraform.io/terraform-aws-modules/http v2.4.1

That is complete solution to deploy application into kubernetes and which can be used inside cicd tools like Jenkins or something like that.

**Services to be provisioned**
- EKS
- CloudWatch
- Fluentd to collect logs and store into CloudWatch

**All strings should included [A-Z and space]**

| key | value |
|--|--|
| bu | Business Unit |
| project | Project |
| env | Environment |

**TYPE OF DEPLOYMENT**
- infraPlan = To check whether all terraform scripts are valid or not including existing state, new state and so on.
- infraApply = To provision services cloud
- infraDestroyPlan = It is same as **InfraPlan** however it is especially for remove services state
- infraDestroy = To remove every services that we have created based on **infraApply**

**HELP SECTION**

    ./deploy --help
    

**How to provision services into AWS with DRY-RUN**

    ./deploy infraPlan <bu> <project> <env>


**How to deploy applications into AWS**

    ./deploy infraApply <bu> <project> <env>
    
    
**How to destroy services in AWS with DRY-RUN**

    ./deploy infraDestroyPlan <bu> <project> <env>
    
    
**How to destroy services in AWS with**

    ./deploy infraDestroy <bu> <project> <env>

**How to deploy applications into AWS with actual data**

    ./deploy infraPlan digital sre sit
