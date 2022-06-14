terraform {
  required_version = ">= 0.14"
  required_providers {
    imagefactory = {
      source  = "nordcloud/imagefactory"
      version = "1.3.1"
    }
  }
}

provider "imagefactory" {
  api_key = "03d5c51e-a76c-4d67-a233-a5830daa41d8/0cabb5fa17c8fa936f9cc332793e0a05d5b3a926fbf6313b"
  api_url = "https://api.imagefactory.nordcloudapp.com/graphql"
}

resource "imagefactory_custom_component" "build_template" {
  name            = "Install nginx"
  description     = "Install nginx on Ubuntu"
  stage           = "BUILD"
  cloud_providers = ["AWS"]
  os_types        = ["LINUX"]
  content {
    script             = <<-EOT
      apt-get update && apt-get install nginx -y
    EOT
    provisioner = "SHELL"
  }
}

# resource "imagefactory_custom_component" "test_component" {
#   name            = "Test nginx"
#   description     = "Test nginx is installed"
#   stage           = "TEST"
#   cloud_providers = ["AWS"]
#   os_types        = ["LINUX"]
#   content {
#     script             = <<-EOT
#       ps aux | grep nginx
#       systemctl is-active --quiet nginx || echo "nginx is not running"; exit 1
#     EOT
#     provisioner = "SHELL"
#   }
# }

data "imagefactory_system_component" "hardening-level-1" {
  name = "Hardening level 1"
}

data "imagefactory_distribution" "ubuntu18" {
  name           = "Ubuntu Server 18.04 LTS"
  cloud_provider = "AWS"
}

resource "imagefactory_template" "template" {
  name            = "Ubuntu1804"
  description     = "Ubuntu 18.04 on AWS"
  cloud_provider  = "AWS"
  distribution_id = data.imagefactory_distribution.ubuntu18.id
  config {
    aws {
      region = "eu-north-1"
    }
    build_components {
      id = data.imagefactory_system_component.hardening-level-1.id
    }
    build_components {
      id = imagefactory_custom_component.build_template.id
    }
    # test_components {
    #   id = imagefactory_custom_component.test_component.id
    # }
    # notifications {
    #   type = "SNS"
    #   uri  = "arn:aws:sns:eu-west-1:123456789012:Topic"
    # }
    tags {
      key   = "Name"
      value = "Test_from_Terraform_Provider"
    }
    tags {
      key   = "KEY_TWO"
      value = "VALUE_B"
    }
  }
}

output "template" {
  value = imagefactory_template.template
}