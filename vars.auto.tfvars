configuration    = [
  {
    "application_name" : "INSTANCE-LINUX",
    "no_of_instances"  : "1",
    "shape"            : "VM.Standard.E3.Flex",
    "cpu_quantity"     : "2",
    "memory_quantity"  : "4",
    "bot_volume_size"  : "100",
    "volume_size"      : "200",
    "os_system"        : "Linux"
  },
  {
    "application_name" : "INSTANCE-WINDOWS",
    "no_of_instances"  : "1",
    "shape"            : "VM.Standard.E3.Flex",
    "cpu_quantity"     : "2",
    "memory_quantity"  : "4",
    "bot_volume_size"  : "100",
    "volume_size"      : "200",
    "os_system"        : "Windows"
  }
]

tenancy_id       = ""
user_id          = ""
compartment_ocid = ""
subnet_id        = ""
api_fingerprint  = ""
region           = ""
