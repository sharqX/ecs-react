resource "aws_ecs_cluster" "ecs" {
  name = "node-cluster"
}

resource "aws_ecs_service" "service" {
  name = "node-service"
  cluster = aws_ecs_cluster.ecs.id
  launch_type = "FARGATE"
  enable_execute_command = true

  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 100
  desired_count = 1
  task_definition = aws_ecs_task_definition.td.arn
  
  network_configuration {
    assign_public_ip = true
    security_groups = [aws_security_group.node-sg.id]
    subnets = [ aws_subnet.s1.id, aws_subnet.s2.id, aws_subnet.s3.id ]
  }

   load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "node-app"
    container_port   = 80
  }
}

resource "aws_ecs_task_definition" "td" {
  container_definitions = jsonencode([
    {
        name = "node-app"
        image = "730335228785.dkr.ecr.ap-south-1.amazonaws.com/app-repo"
        cpu = 1024
        memory = 2048
        essential = true
        portMappings = [
            {
                containerPort = 80
                hostPort = 80
            }
        ]
    }
  ])
  family = "node-app"
  requires_compatibilities = ["FARGATE"]

  cpu = "1024"
  memory = "2048"
  network_mode = "awsvpc"
  task_role_arn = "arn:aws:iam::730335228785:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::730335228785:role/ecsTaskExecutionRole"

}
