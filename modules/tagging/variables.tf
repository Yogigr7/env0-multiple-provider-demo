variable "product" {
  type        = string
  description = "Friendly name of the application/product the infrastructure resource exists to support"
  validation {
    condition     = can(regex("^[^<>]*$", var.product))
    error_message = "The input_string must not contain '<' or '>' characters."
  }
}

variable "business_owner" {
  type        = string
  description = "Name of the owning individual or team responsible for the upkeep and funding of the resource"
  validation {
    condition     = can(regex("^[^<>]*$", var.business_owner))
    error_message = "The input_string must not contain '<' or '>' characters."
  }
}

variable "business_contact" {
  type        = string
  description = "Email of the owning individual or team (valid email is required)"
  validation {
    condition     = can(regex("@", var.business_contact))
    error_message = "Must be a valid email."
  }
}

variable "tech_owner" {
  type        = string
  description = "Name of the owning individual or team responsible for the upkeep and funding of the resource"
  default     = "none"
  validation {
    condition     = can(regex("^[^<>]*$", var.tech_owner))
    error_message = "The input_string must not contain '<' or '>' characters."
  }
}

variable "tech_contact" {
  type        = string
  description = "Email of the owning individual or team (valid email is required)"
  default     = "none"
  validation {
    condition     = can(regex("@", var.tech_contact))
    error_message = "Must be a valid email."
  }
}

variable "environment" {
  type        = string
  description = "Technically any string, most values should probably be dev, test, stage, or prod/production"
  validation {
    condition     = can(regex("^[^<>]*$", var.environment))
    error_message = "The input_string must not contain '<' or '>' characters."
  }
}

variable "code_repo" {
  type        = string
  description = "Link/URL to the infrastructure-as-code source repository"
}

variable "compliance" {
  type        = string
  description = "Regulatory frameworks that apply to the resource ('none' if none do)"
  default     = "none"
  validation {
    condition     = can(regex("^[^<>]*$", var.compliance))
    error_message = "The input_string must not contain '<' or '>' characters."
  }
}

variable "criticality" {
  type        = string
  description = "How critical to the business is the resource. Options: low, moderate, high"
  validation {
    condition     = can(regex("^(low|moderate|high)$", lower(var.criticality)))
    error_message = "Must be 'low', 'moderate', or 'high'."
  }
}

variable "public_facing" {
  type        = string
  description = "Whether or not the resource serves something to the Internet, either directly or via a load balancer. One of: <yes>, <no>"
  validation {
    condition     = can(regex("^(yes|no)$", lower(var.public_facing)))
    error_message = "Must be 'Yes' or 'No'."
  }
}

variable "retirement_date" {
  type        = string
  description = "An estimate for when the resource/app will no longer be needed. If not known, enter a far-flung date upon which to reevaluate its relevancy."
  default     = "none"
  validation {
    condition     = can(regex("^(\\d\\d\\d\\d-\\d\\d-\\d\\d|)$", var.retirement_date))
    error_message = "Must be a date of the form 'yyyy-mm-dd'."
  }
}

variable "datadog_ust" {
  type        = bool
  description = "Opt-in to Datadog UST tags (env, service, version, team). See https://docs.datadoghq.com/getting_started/tagging/unified_service_tagging/"
  default     = false
}

# Optional overrides. If unset, derive env/service from existing variables.
variable "env" {
  type        = string
  description = "Override for Datadog 'env' (defaults to var.environment when UST is enabled)."
  default     = null
  validation {
    condition     = var.env == null || can(regex("^[^<>]*$", var.env))
    error_message = "The 'env' must not contain '<' or '>' characters."
  }
}

variable "service" {
  type        = string
  description = "Override for Datadog 'service' (defaults to var.product when UST is enabled)."
  default     = null
  validation {
    condition     = var.service == null || can(regex("^[^<>]*$", var.service))
    error_message = "The 'service' must not contain '<' or '>' characters."
  }
}

# avoid Terraform's reserved 'version' argument in module blocks.
variable "dd_version" {
  type        = string
  description = "Datadog 'version' (MANDATORY when datadog_ust=true). Unique identifier to describe a deployment."
  default     = ""
  validation {
    condition     = var.dd_version == "" || can(regex("^[0-9A-Za-z._-]+$", var.dd_version))
    error_message = "The 'dd_version' may contain only letters, digits, dots, underscores, and hyphens."
  }
}

variable "team" {
  type        = string
  description = "Datadog 'team' tag. Must match the pattern 'AG-DataDog-*'."
  default     = null
  validation {
    condition     = var.team == null || can(regex("^AG-DataDog-[A-Za-z0-9._-]+$", var.team))
    error_message = "'team' must match 'AG-DataDog-*' when provided."
  }
}

resource "null_resource" "datadog_guard" {
  count = var.datadog_ust ? 1 : 0

  triggers = {
    dd_version = var.dd_version
    team       = var.team
  }

  lifecycle {
    precondition {
      condition     = length(trimspace(var.dd_version)) > 0
      error_message = "datadog_ust is true, so 'dd_version' must be set (non-empty)."
    }

    precondition {
      condition     = can(regex("^AG-DataDog-[A-Za-z0-9._-]+$", var.team))
      error_message = "datadog_ust is true, so 'team' must match the pattern 'AG-DataDog-*'."
    }
  }
}
