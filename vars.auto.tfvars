configuration    = [
  {
    "application_name" : "CONTROLM920EM",
    "no_of_instances"  : "2",
    "shape"            : "VM.Standard.E3.Flex",
    "cpu_quantity"     : "16",
    "memory_quantity"  : "64",
    "bot_volume_size"  : "100",
    "volume_size"      : "500",
    "os_system"        : "Linux"
  },
  {
    "application_name" : "CONTROLM920SRV",
    "no_of_instances"  : "3",
    "shape"            : "VM.Standard.E3.Flex",
    "cpu_quantity"     : "12",
    "memory_quantity"  : "48",
    "bot_volume_size"  : "100",
    "volume_size"      : "500",
    "os_system"        : "Linux"
  },
  {
    "application_name" : "CONTROLM920CLT",
    "no_of_instances"  : "1",
    "shape"            : "VM.Standard.E3.Flex",
    "cpu_quantity"     : "4",
    "memory_quantity"  : "16",
    "bot_volume_size"  : "100",
    "volume_size"      : "300",
    "os_system"        : "Windows"
  }
]

tenancy_id       = ""
user_id          = ""
compartment_ocid = ""
subnet_id        = ""
api_fingerprint  = ""