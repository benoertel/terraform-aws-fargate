data "aws_subnet_ids" "cluster" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Name"
    values = ["*-public-*"]
  }
}

data "aws_security_group" "cluster_instance" {
  name = var.sg_name
}

resource "aws_ecs_task_definition" "main" {
  cpu                      = var.cpu
  family                   = "${local.name_with_prefix}-service"
  memory                   = var.memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions    = var.container_definitions_json
}

resource "aws_ecs_service" "main" {
  name                               = "${local.name_with_prefix}-service"
  cluster                            = var.ecs_cluster_id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [data.aws_security_group.cluster_instance.id]
    subnets          = data.aws_subnet_ids.cluster.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "web"
    container_port   = var.container_port
  }
}

resource "aws_lb_target_group" "main" {
  name        = local.name_with_prefix
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    path                = "/health.html"
    port                = 80
    protocol            = "HTTP"
  }

  tags = {
    Env       = var.env
    ManagedBy = "Terraform"
    Name      = local.name_with_prefix
  }
}