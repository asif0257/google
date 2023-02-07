resource "google_compute_network" "main" {
  name                    = "main"
  #credentials             = "as-new@kubectl-373710.iam.gserviceaccount.com"
  project                 = "kubectl-373710"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  #region                  = "us-west2"
  mtu                     = 1500
}
resource "google_compute_subnetwork" "private" {
  name                     = "private"
  project                  = "kubectl-373710"
  ip_cidr_range            = "10.0.1.0/24"
  region                   = "us-west2"
  network                  = "main"
  private_ip_google_access = true
}
resource "google_compute_subnetwork" "public" {
  name                     = "public"
  project                  = "kubectl-373710"
  ip_cidr_range            = "10.0.2.0/24"
  region                   = "us-west2"
  network                  = google_compute_network.main.self_link
  private_ip_google_access = true
}
resource "google_compute_router" "router" {
  name    = "quickstart-router"
  project = "kubectl-373710"
  network = "main"
  region  = "us-west2"
}
resource "google_compute_router_nat" "nat" {
  name                               = "quickstart-router-nat"
  project                            = "kubectl-373710"
  router                             = google_compute_router.router.name
  region                             = "us-west2"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
   resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "us-west2-a"
  project      = "kubectl-373710"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20221201"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  #scratch_disk {
   # interface = "SCSI"
  #}

  network_interface {
    network = "default"

    #access_config {
     # // Ephemeral public IP
  #  }
 # }

  #metadata = {
   # foo = "bar"
  #}

 # metadata_startup_script = "echo hi > /test.txt"

  #service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    #email  = google_service_account.default.email
    #scopes = ["cloud-platform"]
   }
}
resource "google_compute_firewall" "rules" {
  project     = "kubectl-373710"
  name        = "my-firewall-rule"
  network     = "main"
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["80", "8080",]
  }

  source_tags = ["foo"]
  target_tags = ["web"]
}