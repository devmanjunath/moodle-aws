      {
          "memory": "${memory}",
          "portMappings": [
              {
                  "hostPort": ${host_port},
                  "containerPort": ${container_port},
                  "protocol": "tcp"
              }
          ],
          "essential": true,
          "mountPoints": [
              {
                  "containerPath": "/var/www",
                  "sourceVolume": "efs-html"
              }
          ],
          "name": "${name}",
          "image": "${image}"
      }