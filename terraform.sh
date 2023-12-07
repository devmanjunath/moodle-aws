terraform destroy --auto-approve \
    --target=module.ecs \
    --target=module.asg \
    --target=module.cache \
    --target=module.efs \
    --target=module.rds \