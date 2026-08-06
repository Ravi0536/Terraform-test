resource "aws_ecr_repository" "tos_dev_agentic" {
  name                 = "tos-dev-agentic"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    cost-center = "tos-dev"
    env         = "dev"
    managed-by  = "terraform"
    owner       = "ravindra.kande@gmail.com"
    service     = "tos"
  }
}

import {
  to = aws_ecr_repository.tos_dev_agentic
  id = "tos-dev-agentic"
}
