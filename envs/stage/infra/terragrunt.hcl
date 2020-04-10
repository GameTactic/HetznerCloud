terraform {
  source = "../../../modules//infra"
}

inputs = {
  hcloud_worker_count = 2
  hcloud_manager = "cx11"
  hcloud_worker = "cx11"
  gt_cluster = "stage"
}
