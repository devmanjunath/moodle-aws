import boto3
import os

def update_ecs_service(cluster_name, service_name, commands=[]):
    ecs_client = boto3.client("ecs")
    print(commands)
    response = ecs_client.describe_services(cluster=cluster_name, services=[service_name])
    current_task_definition = response['services'][0]['taskDefinition']

    task_definition = ecs_client.describe_task_definition(taskDefinition=current_task_definition)

    container_definitions = task_definition['taskDefinition']['containerDefinitions']
    for container_definition in container_definitions:
        if container_definition['name'] == 'moodle':
            container_definition['command'] = commands
    new_task_definition = ecs_client.register_task_definition(
        family=task_definition['taskDefinition']['family'],
        containerDefinitions=container_definitions,
        volumes=task_definition['taskDefinition']['volumes'],
        taskRoleArn=task_definition['taskDefinition']['taskRoleArn'],
        executionRoleArn=task_definition['taskDefinition']['executionRoleArn'],
        networkMode=task_definition['taskDefinition']['networkMode']
    )

    ecs_client.update_service(
        cluster=cluster_name,
        service=service_name,
        taskDefinition=new_task_definition['taskDefinition']['family']
    )

def get_update_command():
    host_name = os.environ["HOST_NAME"]
    db_host = os.environ["DB_HOST"]
    db_user = os.environ["DB_USER"]
    db_pass = os.environ["DB_PASS"]
    admin_user = os.environ["ADMIN_USER"]
    admin_pass = os.environ["ADMIN_PASS"]
    site_name = os.environ["SITE_NAME"]

    return [
        "/bin/bash",
        "-c", 
        " ".join([
            "/opt/entrypoint.sh",
            "--skip-bootstrap",
        f"--host-name '{host_name}'",
          "--db-type mysqli",
          f"--db-host '{db_host}'",
          f"--db-user '{db_user}'",
          f"--db-pass '{db_pass}'",
          f"--site-name '{site_name}'",
          f"--admin-user '{admin_user}'",
          f"--admin-pass '{admin_pass}'"
          ])
    ]

def lambda_handler(event, _):
    cluster_name = os.environ["CLUSTER_NAME"]
    service_name = os.environ["SERVICE_NAME"]

    print(f"Events coming from {cluster_name}:\n")
    print(event)

    if event["detail"]["lastStatus"] == "PROVISIONING" and len(event["detail"]["containers"]) == 0:
        update_ecs_service(cluster_name, service_name, get_update_command())
        print("ECS service updated with new environment variables")
    else:
        print("ECS service need not be updated at the moment")
        print(event["detail"]["lastStatus"])
        print(event["detail"]["containers"])