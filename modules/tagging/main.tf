terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

resource "random_uuid" "stack_id" {

}

locals {
  base_tags = {
    Product               = lower(try(var.product == null || var.product == "" || lower(var.product) == "none", true) ? "None" : var.product)
    ManagedBy             = lower("terraform")
    BusinessOwner         = lower(try(var.business_owner == null || var.business_owner == "" || lower(var.business_owner) == "none", true) ? "None" : var.business_owner)
    BusinessContact       = lower(try(var.business_contact == null || var.business_contact == "" || lower(var.business_contact) == "none", true) ? "None" : var.business_contact)
    TechOwner             = lower(try(var.tech_owner == null || var.tech_owner == "" || lower(var.tech_owner) == "none", true) ? "None" : var.tech_owner)
    TechContact           = lower(try(var.tech_contact == null || var.tech_contact == "" || lower(var.tech_contact) == "none", true) ? "None" : var.tech_contact)
    Environment           = lower(try(var.environment == null || var.environment == "" || lower(var.environment) == "none", true) ? "None" : var.environment)
    CodeRepo              = lower(try(var.code_repo == null || var.code_repo == "" || lower(var.code_repo) == "none", true) ? "None" : var.code_repo)
    Compliance            = lower(try(var.compliance == null || var.compliance == "" || lower(var.compliance) == "none", true) ? "None" : var.compliance)
    Criticality           = lower(try(var.criticality == null || var.criticality == "" || lower(var.criticality) == "none", true) ? "None" : var.criticality)
    PublicFacing          = lower(try(var.public_facing == null || var.public_facing == "" || lower(var.public_facing) == "none", true) ? "None" : var.public_facing)
    RetirementDate        = lower(formatdate("YYYY-MM-DD", "${var.retirement_date}T00:00:00Z"))
    "terraform.workspace" = lower(try(terraform.workspace == null || terraform.workspace == "" || lower(terraform.workspace) == "none", true) ? "None" : terraform.workspace)
    StackId               = random_uuid.stack_id.id
  }

  # Required, but will default to `Environment` when not explicitly set
  dd_env     = lower(trimspace(coalesce(var.env, local.base_tags.Environment)))
  # Required, but will default to `product` when not explicitly set
  dd_service = lower(trimspace(coalesce(var.service, local.base_tags.Product)))
  dd_version = lower(trimspace(var.dd_version))
  dd_team    = try(trimspace(var.team), "")

  # Only add UST keys when opted in.
  dd_tags = var.datadog_ust ? {
    env     = local.dd_env
    service = local.dd_service
    version = local.dd_version
    team    = local.dd_team
  } : {}

  tags = merge(local.base_tags, local.dd_tags)
}