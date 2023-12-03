terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "tocken"
  cloud_id  = "cloud"
  folder_id = "folder"
}

#----------------- WWW -----------------------------
resource "yandex_compute_instance" "nginx-1" {
  name        = "vm-nginx-1"
  hostname    = "nginx-1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd89cudngj3s2osr228p"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.inner-nginx-1.id
    security_group_ids = [yandex_vpc_security_group.inner.id]
    ip_address         = "10.0.1.3"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}

resource "yandex_compute_instance" "nginx-2" {
  name        = "vm-nginx-2"
  hostname    = "nginx-2"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd89cudngj3s2osr228p"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.inner-nginx-2.id
    security_group_ids = [yandex_vpc_security_group.inner.id]
    ip_address         = "10.0.2.3"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}

#----------------- bastion -----------------------------
resource "yandex_compute_instance" "bastion" {
  name        = "vm-bastion"
  hostname    = "bastion"
  zone        = "ru-central1-c"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd89cudngj3s2osr228p" 
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.inner.id, yandex_vpc_security_group.public-bastion.id]
    ip_address         = "10.0.4.4"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}


#----------------- zabbix -----------------------------
resource "yandex_compute_instance" "zabbix" {
  name        = "vm-zabbix"
  hostname    = "zabbix"
  zone        = "ru-central1-c"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd89cudngj3s2osr228p"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.inner.id, yandex_vpc_security_group.public-zabbix.id]
    ip_address         = "10.0.4.5"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}

#----------------- elastic -----------------------------
resource "yandex_compute_instance" "elastic" {
  name        = "vm-elastic"
  hostname    = "elastic"
  zone        = "ru-central1-c"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd89cudngj3s2osr228p"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.inner-services.id
    security_group_ids = [yandex_vpc_security_group.inner.id]
    ip_address         = "10.0.3.4"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}

#----------------- kibana -----------------------------
resource "yandex_compute_instance" "kibana" {
  name        = "vm-kibana"
  hostname    = "kibana"
  zone        = "ru-central1-c"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd89cudngj3s2osr228p"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.inner.id, yandex_vpc_security_group.public-kibana.id]
    ip_address         = "10.0.4.3"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {  
    preemptible = true
  }
}