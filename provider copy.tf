terraform {
    required_providers {
        nsxt = {
            source  = "terraform-providers/nsxt"
            version = "~> 2.1.0"
        }
        infoblox = {
            source  = "terraform-providers/infoblox"
            version = "~> 1.0.0"
        }
        vsphere = {
            source  = "hashicorp/vsphere"
            version = "~> 1.18.2"
        }
        aws = {
            source  = "hashicorp/aws"
            version = "~> 2.63.0"
        }
    }
}