variable "zone" {
  type        = string
  description = "DNS zone the record set belongs to. It must be an FQDN, that is, include the trailing dot."
}

variable "ttl" {
  type        = number
  description = "(Number) The TTL of the record set. Defaults to 60"
  default     = 60
}

variable "name" {
  type        = string
  description = "The name of the record set. The zone argument will be appended to this value to create the full record path."
  default     = null
  nullable    = true
}

variable "records" {
  type        = any
  description = "Record(s) of the DNS"
}

variable "type" {
  type        = string
  description = "Type of the record"
}