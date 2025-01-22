locals {
  naming = (var.name == var.zone
    ? null
  : var.name)
}

# If the record is A
resource "dns_a_record_set" "a" {

  count     = var.type == "A" ? 1 : 0
  name      = local.naming
  zone      = var.zone
  ttl       = var.ttl
  addresses = var.records
}

# CNAME record
resource "dns_cname_record" "cname" {
  count = var.type == "CNAME" ? 1 : 0
  name  = local.naming
  zone  = var.zone
  ttl   = var.ttl
  cname = var.records
}

# TXT record
resource "dns_txt_record_set" "txt" {
  count = var.type == "TXT" ? 1 : 0
  name  = local.naming
  zone  = var.zone
  ttl   = var.ttl
  txt   = var.records
}

# AAAA record for ipv6
resource "dns_aaaa_record_set" "aaa" {
  count     = var.type == "AAAA" ? 1 : 0
  name      = local.naming
  zone      = var.zone
  ttl       = var.ttl
  addresses = var.records
}

# NS record
resource "dns_ns_record_set" "ns" {
  count       = var.type == "NS" ? 1 : 0
  name        = local.naming
  zone        = var.zone
  ttl         = var.ttl
  nameservers = var.records
}

# PTR record
resource "dns_ptr_record" "ptr" {
  count = var.type == "PTR" ? 1 : 0
  name  = local.naming
  zone  = var.zone
  ttl   = var.ttl
  ptr   = var.records
}

# MX record
resource "dns_mx_record_set" "mx" {
  count = var.type == "MX" ? 1 : 0
  name  = local.naming
  zone  = var.zone
  ttl   = var.ttl

  dynamic "mx" {
    for_each = var.records
    content {
      preference = mx.value.preference
      exchange   = mx.value.exchange
    }
  }
}

# SRV record
resource "dns_srv_record_set" "srv" {
  count = var.type == "SRV" ? 1 : 0
  name  = local.naming
  zone  = var.zone
  ttl   = var.ttl
  dynamic "srv" {
    for_each = var.records
    content {
      priority = srv.value.priority
      weight   = srv.value.weight
      target   = srv.value.target
      port     = srv.value.port
    }
  }
}
