# Testing the Terraform Module

## Quick Start

1. Copy one of the example tfvars files:
   ```bash
   cp terraform-storage-account.tfvars terraform.tfvars
   ```

2. Update `terraform.tfvars` with your values:
   - Replace `your-subscription-id-here` with your Azure subscription ID
   - Update `resource_group_name` if testing PE or VM

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Plan to see what will be generated:
   ```bash
   terraform plan
   ```

5. Apply (this only generates names, doesn't create resources):
   ```bash
   terraform apply
   ```

## Example Files

- `terraform-storage-account.tfvars` - Test Storage Account naming
- `terraform-private-endpoint.tfvars` - Test Private Endpoint naming
- `terraform-virtual-machine.tfvars` - Test Virtual Machine naming
- `terraform-no-check.tfvars` - Test without Azure checks (faster)

## Testing Different Scenarios

### Test Storage Account
```bash
terraform plan -var-file=terraform-storage-account.tfvars
```

### Test Private Endpoint
```bash
terraform plan -var-file=terraform-private-endpoint.tfvars
```

### Test Virtual Machine
```bash
terraform plan -var-file=terraform-virtual-machine.tfvars
```

### Test Without Azure Check
```bash
terraform plan -var-file=terraform-no-check.tfvars
```

## Expected Outputs

After running `terraform apply`, you'll see outputs like:
- `generated_name` - The generated name
- `final_name` - Final name after conflict resolution
- `validation_passed` - Whether validation passed
- `conflict_detected` - Whether a conflict was found
- `validation_details` - Complete validation information

## Notes

- Make sure Azure CLI is installed and logged in if using `check_azure_existence = true`
- For PE and VM, `resource_group_name` must exist in your subscription
- The module only generates names, it doesn't create actual Azure resources
