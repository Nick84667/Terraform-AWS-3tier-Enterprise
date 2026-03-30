data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

data "aws_iam_policy" "ssm_managed_instance_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "app_instance" {
  name = "${var.name_prefix}-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app-role"
    Tier = "app"
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.app_instance.name
  policy_arn = data.aws_iam_policy.ssm_managed_instance_core.arn
}

resource "aws_iam_instance_profile" "app_instance" {
  name = "${var.name_prefix}-app-instance-profile"
  role = aws_iam_role.app_instance.name

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app-instance-profile"
    Tier = "app"
  })
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.name_prefix}-app-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.security_group_id]

  iam_instance_profile {
    name = aws_iam_instance_profile.app_instance.name
  }

  user_data = base64encode(<<-EOF2
    #!/bin/bash
    set -euo pipefail

    dnf update -y
    dnf install -y python3

    INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id || echo "unknown-instance")
    AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone || echo "unknown-az")

    mkdir -p /opt/app
    cat > /opt/app/index.html <<HTML
    <html>
      <head><title>App Tier</title></head>
      <body>
        <h1>App Tier - ${var.name_prefix}</h1>
        <p>Instance ID: $${INSTANCE_ID}</p>
        <p>Availability Zone: $${AZ}</p>
        <p>Listening Port: ${var.app_port}</p>
      </body>
    </html>
    HTML

    cat > /etc/systemd/system/app-tier.service <<SERVICE
    [Unit]
    Description=Simple App Tier HTTP Service
    After=network.target

    [Service]
    User=root
    WorkingDirectory=/opt/app
    ExecStart=/usr/bin/python3 -m http.server ${var.app_port} --bind 0.0.0.0
    Restart=always
    RestartSec=5

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable app-tier
    systemctl start app-tier
  EOF2
  )

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name = "${var.name_prefix}-app"
      Tier = "app"
    })
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(var.tags, {
      Name = "${var.name_prefix}-app-volume"
      Tier = "app"
    })
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app-lt"
    Tier = "app"
  })
}

resource "aws_autoscaling_group" "app" {
  name                      = "${var.name_prefix}-app-asg"
  min_size                  = var.min_capacity
  max_size                  = var.max_capacity
  desired_capacity          = var.desired_capacity
  health_check_type         = "ELB"
  health_check_grace_period = var.health_check_grace_period
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-app"
    propagate_at_launch = true
  }

  tag {
    key                 = "Tier"
    value               = "app"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
