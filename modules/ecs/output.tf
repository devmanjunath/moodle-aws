output "cluster_arn"{
    value = aws_ecs_cluster.this.arn
}

output "service_name"{
    value = aws_ecs_service.this.name
}