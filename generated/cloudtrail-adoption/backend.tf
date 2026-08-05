terraform {
  backend "s3" {
    bucket       = "tos-tf-test123-state-c3c993b3"
    key          = "terraform-state/v1/organization=34b78008-12f3-4719-980b-069f58c9f8dd/workspace=4c49812c-b6cf-46b6-b069-6c69c5640385/environment=test/root=root_3fd38383-8d54-4e80-b760-9f8691a249f5/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
