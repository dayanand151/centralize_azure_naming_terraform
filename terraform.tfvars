# test config

prefix = "org"
environment = "dev"
location = "eastus"

# storage_account, private_endpoint, or virtual_machine
resource_type_name = "storage_account"

# optional - auto set if not provided
# resource_type = "st"

# needed for PE and VM
# resource_group_name = "rg-example"

instance_number = 1

# custom name if needed
# base_name = ""

check_azure_existence = true

# hyphens - auto detected if null
# use_hyphens = null

# azure sub id
subscription_id = "b7011b3e-c301-47c4-8ff4-9db059c4386a"
