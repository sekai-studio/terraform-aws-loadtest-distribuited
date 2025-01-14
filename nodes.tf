resource "aws_instance" "nodes" {

  count = var.nodes_size

  ami           = "ami-09f82dbc76b71be6f"
  instance_type = var.nodes_instance_type

  associate_public_ip_address = var.nodes_associate_public_ip_address
  monitoring                  = var.nodes_monitoring

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.loadtest.id]

  iam_instance_profile = aws_iam_instance_profile.loadtest.name

  user_data = <<-EOF
          #!/bin/bash
          echo "${tls_private_key.loadtest.public_key_openssh}" >> /home/ec2-user/.ssh/authorized_keys
          chmod 600 /home/ec2-user/.ssh/authorized_keys
          chown -R ec2-user:ec2-user /home/ec2-user/.ssh
          EOF
  key_name = aws_key_pair.loadtest.key_name
  connection {
    host        = self.private_ip
    type        = "ssh"
    user        = var.ssh_user
    private_key = tls_private_key.loadtest.private_key_pem
  }


  # CONFIG FILESYSTEM AND PERMITIONS
  provisioner "remote-exec" {
    inline = [
      "echo '${tls_private_key.loadtest.private_key_pem}' > ~/.ssh/id_rsa",
      "chmod 600 ~/.ssh/id_rsa",
      "sudo mkdir -p ${var.loadtest_dir_destination} || true",
      "sudo chown ${var.ssh_user}:${var.ssh_user} ${var.loadtest_dir_destination} || true"
    ]
  }

  # PUBLISH ALL FILES
  provisioner "file" {
    destination = var.loadtest_dir_destination
    source      = var.loadtest_dir_source
  }

  tags = merge(
    var.tags,
    var.nodes_tags
  )
}

locals {

  setup_nodes_executors = {
    jmeter = {
      node_user_data_base64 = base64encode(
        templatefile(
          "${path.module}/scripts/entrypoint.node.full.sh.tpl",
          {
            JVM_ARGS = var.nodes_jvm_args
          }
        )
      )
    }
    bzt = {
      node_user_data_base64 = base64encode(
        templatefile(
          "${path.module}/scripts/entrypoint.node.full.sh.tpl",
          {
            JVM_ARGS = var.nodes_jvm_args
          }
        )
      )
    }
    locust = {
      node_user_data_base64 = base64encode(
        templatefile(
          "${path.module}/scripts/locust.entrypoint.node.full.sh.tpl",
          {}
        )
      )
    }
    k6 = {
      node_user_data_base64 = base64encode(
        templatefile(
          "${path.module}/scripts/k6.entrypoint.node.full.sh.tpl",
          {
            JVM_ARGS = var.nodes_jvm_args
          }
        )
      )
    }
  }

  setup_nodes_executor = lookup(
    local.setup_nodes_executors,
    var.executor, {
      node_user_data_base64 = var.nodes_custom_setup_base64
    }
  )

  setup_nodes_base64 = local.setup_nodes_executor.node_user_data_base64

}
