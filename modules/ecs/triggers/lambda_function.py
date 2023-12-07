import boto3
import os

def update_ecs_service(cluster_name, service_name, new_environment_variables):
    ecs_client = boto3.client("ecs")

    response = ecs_client.describe_services(cluster=cluster_name, services=[service_name])
    current_task_definition = response['services'][0]['taskDefinition']

    task_definition = ecs_client.describe_task_definition(taskDefinition=current_task_definition)

    container_definitions = task_definition['taskDefinition']['containerDefinitions']
    for container_definition in container_definitions:
        if container_definition['name'] == 'moodle':
            container_definition['environment'] = new_environment_variables

    new_task_definition = ecs_client.register_task_definition(
        family=task_definition['taskDefinition']['family'],
        containerDefinitions=container_definitions,
        volumes=task_definition['taskDefinition']['volumes']
    )

    ecs_client.update_service(
        cluster=cluster_name,
        service=service_name,
        taskDefinition=new_task_definition['taskDefinition']['family']
    )

def get_new_environment_variables():
    return [
        {
            'name': 'NEW_ENV_VARIABLE',
            'value': 'new-value'
        }
    ]

def lambda_handler(event, _):
    cluster_name = os.environ["CLUSTER_NAME"]
    service_name = os.environ["SERVICE_NAME"]

    updated_env = get_new_environment_variables()

    if event["detail"]["eventType"] == "INFO":
        update_ecs_service(cluster_name, service_name, updated_env)
        print("ECS service updated with new environment variables")
    else:
        print("ECS service could not be updated")