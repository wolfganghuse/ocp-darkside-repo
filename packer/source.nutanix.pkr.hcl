source "nutanix" "ocp_darkside" {
  nutanix_username = "${var.PC_USER}"
  nutanix_password = "${var.PC_PASS}"
  nutanix_endpoint = "${var.PC_ENDPOINT}"
  nutanix_insecure = true
  cluster_name     = "${var.CLUSTER}"
  
  vm_disks {
      image_type = "ISO_IMAGE"
      source_image_name = "CentOS-Stream-8-x86_64-202200719-dvd1.iso"
  }

  vm_disks {
      image_type = "DISK"
      disk_size_gb = 100
  }

  vm_disks {
      image_type = "ISO_IMAGE"
      source_image_name = "mirror.iso"
  }

  vm_nics {
    subnet_name      = "${var.SUBNET}"
  }
  
  cd_files         = ["scripts/stage1/ks.cfg"]
  cd_label          = "OEMDRV"
  image_name        ="ocp-darkside-{{isotime `Jan-_2-15:04:05`}}"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  shutdown_timeout = "20m"
  ssh_password     = "packer"
  ssh_username     = "root"
  cpu               = 2
  os_type           = "Linux"
  memory_mb         = "8192"
  communicator      = "ssh"
}
