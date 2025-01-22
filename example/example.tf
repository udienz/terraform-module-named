variable "dns_records" {
  type        = any
  description = "List of the DNS records"
  default     = null
}

variable "bind_dns_server" {
  type        = string
  description = "The hostname or IP address of the DNS server to send updates to. Value can also be sourced from the DNS_UPDATE_SERVER environment variable."
}

variable "bind_dns_key_name" {
  type        = string
  description = "The name of the TSIG key used to sign the DNS update messages. Value can also be sourced from the DNS_UPDATE_KEYNAME environment variable."
}

variable "bind_dns_key_secret" {
  type        = string
  description = "Required if key_name is set A Base64-encoded string containing the shared secret to be used for TSIG. Value can also be sourced from the DNS_UPDATE_KEYSECRET environment variable."
}

variable "bind_dns_key_algorithm" {
  type        = string
  description = "Required if key_name is set. When using TSIG authentication, the algorithm to use for HMAC. Valid values are hmac-md5, hmac-sha1, hmac-sha256 or hmac-sha512. Value can also be sourced from the DNS_UPDATE_KEYALGORITHM environment variable."
}

module "named_dns" {
  source   = "../"
  # use below if you connected to internet
  # source = "github.com/udienz/terraform-module-named"
  for_each = { for dns_records in var.dns_records : "${dns_records.zone}_${dns_records.name}_${dns_records.type}" => dns_records }

  zone    = each.value.zone
  name    = lookup(each.value, "name", null)
  type    = lookup(each.value, "type", "A")
  ttl     = lookup(each.value, "ttl", 60)
  records = each.value.records
}

provider "dns" {
  update {
    server        = var.bind_dns_server
    key_name      = var.bind_dns_key_name
    key_secret    = var.bind_dns_key_secret
    key_algorithm = var.bind_dns_key_algorithm
  }
} 