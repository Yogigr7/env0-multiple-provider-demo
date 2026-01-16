<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.datadog_guard](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_uuid.stack_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_business_contact"></a> [business\_contact](#input\_business\_contact) | Email of the owning individual or team (valid email is required) | `string` | n/a | yes |
| <a name="input_business_owner"></a> [business\_owner](#input\_business\_owner) | Name of the owning individual or team responsible for the upkeep and funding of the resource | `string` | n/a | yes |
| <a name="input_code_repo"></a> [code\_repo](#input\_code\_repo) | Link/URL to the infrastructure-as-code source repository | `string` | n/a | yes |
| <a name="input_compliance"></a> [compliance](#input\_compliance) | Regulatory frameworks that apply to the resource ('none' if none do) | `string` | `"none"` | no |
| <a name="input_criticality"></a> [criticality](#input\_criticality) | How critical to the business is the resource. Options: low, moderate, high | `string` | n/a | yes |
| <a name="input_datadog_ust"></a> [datadog\_ust](#input\_datadog\_ust) | Opt-in to Datadog UST tags (env, service, version, team). See https://docs.datadoghq.com/getting_started/tagging/unified_service_tagging/ | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | Override for Datadog 'env' (defaults to var.environment when UST is enabled). | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Technically any string, most values should probably be dev, test, stage, or prod/production | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Friendly name of the application/product the infrastructure resource exists to support | `string` | n/a | yes |
| <a name="input_public_facing"></a> [public\_facing](#input\_public\_facing) | Whether or not the resource serves something to the Internet, either directly or via a load balancer. One of: <yes>, <no> | `string` | n/a | yes |
| <a name="input_retirement_date"></a> [retirement\_date](#input\_retirement\_date) | An estimate for when the resource/app will no longer be needed. If not known, enter a far-flung date upon which to reevaluate its relevancy. | `string` | `"none"` | no |
| <a name="input_service"></a> [service](#input\_service) | Override for Datadog 'service' (defaults to var.product when UST is enabled). | `string` | `null` | no |
| <a name="input_team"></a> [team](#input\_team) | Optional Datadog 'team' tag value. | `string` | `null` | no |
| <a name="input_tech_contact"></a> [tech\_contact](#input\_tech\_contact) | Email of the owning individual or team (valid email is required) | `string` | `"none"` | no |
| <a name="input_tech_owner"></a> [tech\_owner](#input\_tech\_owner) | Name of the owning individual or team responsible for the upkeep and funding of the resource | `string` | `"none"` | no |
| <a name="input_version"></a> [version](#input\_version) | Datadog 'version' (MANDATORY when datadog\_ust=true). Unique identifier to describe a deployment. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_value"></a> [value](#output\_value) | n/a |
<!-- END_TF_DOCS -->