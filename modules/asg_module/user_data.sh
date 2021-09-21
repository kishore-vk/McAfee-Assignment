#! /bin/bash

set -euxo pipefail

cat << EOF >> /etc/ecs/ecs.config
ECS_CLUSTER=${app_name}-cluster
EOF

sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_arm64/amazon-ssm-agent.rpm
