terraform{
  required_providers{
    nutanix = {
      source = "nutanix/nutanix"
      version = "1.3.0"
    }
  }
}
provider "nutanix" {
  username  = var.PC_USER
  password  = var.PC_PASS
  endpoint  = var.PC_ENDPOINT
  insecure  = true
  port      = 9440
}

variable "registry_ip" {
  type = string
}

variable "PC_PASS" {
  type = string
}

variable "PC_USER" {
  type = string
}

variable "PC_ENDPOINT" {
  type = string
}

variable "packer_source_image" {
  type = string
}

variable "nutanix_subnet" {
  type = string
}

variable "nutanix_cluster" {
  type = string
}

variable "registry_fqdn" {
  type = string
}

variable "registry_name" {
  type = string
}

data "nutanix_cluster" "cluster" {
  name = var.nutanix_cluster
}

data "nutanix_subnet" "net" {
  subnet_name = var.nutanix_subnet
}


resource "nutanix_virtual_machine" "registry" {
  name                 = var.registry_name
  num_vcpus_per_socket = 4
  num_sockets          = 1
  memory_size_mib      = 8192

  cluster_uuid = data.nutanix_cluster.cluster.id

  nic_list {
    subnet_uuid = data.nutanix_subnet.net.id
    ip_endpoint_list {
      ip   = var.registry_ip
      type = "ASSIGNED"
    }
  }

  disk_list {
    data_source_reference = {
        kind = "image"
        uuid = var.packer_source_image
      }
  
    device_properties {
      disk_address = {
        device_index = 0
        adapter_type = "SCSI"
      }

      device_type = "DISK"
    }
  }

  guest_customization_cloud_init_user_data = base64encode(templatefile("./cloud-config.tftpl", {
    machine_name = var.registry_fqdn
    ssh_key = file("~/.ssh/hpoc.pub")
  }))

  connection {
    user     = "centos"  
    type     = "ssh"
    host    = self.nic_list_status[0].ip_endpoint_list[0].ip
  }

  provisioner "file" {
    source      = "cert"
    destination = "."
  }

  provisioner "remote-exec" {
    script = "files/registry.sh"
  }

}

# Show IP address
output "ip_address" {
  value = nutanix_virtual_machine.registry.nic_list_status[0].ip_endpoint_list[0].ip
}
