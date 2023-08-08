# THIS IS THE UPGRADE VERSION OF THE CICD PIPELINE IN STAGING

# Path to the template
TEMPLATE=file://~/airflow-workplace/airflow-materials-aws/section-7/code-pipeline/airflow-staging-pipeline-upgrade.cfn.yml

# Update the stack
aws cloudformation create-stack --stack-name=airflow-staging-pipeline \
    --template-body=$TEMPLATE \
    --parameters ParameterKey=EksClusterName,ParameterValue=airflow \
    ParameterKey=KubectlRoleName,ParameterValue=AirflowCodeBuildServiceRole \
    ParameterKey=GitHubUser,ParameterValue=Mgmaplus \
    ParameterKey=GitHubToken,ParameterValue=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 \
    ParameterKey=GitSourceRepo,ParameterValue=airflow-eks-docker \
    ParameterKey=GitBranch,ParameterValue=staging