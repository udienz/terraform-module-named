locals {
  naming = (var.name == var.zone
    ? null
  : var.name)
  # indexing = (
  #  dns_records.name == ""
  #  ? "root_${dns_records.zone}"
  #  : dns_records.name
}
# If the record are A
resource "dns_a_record_set" "a" {
  #for_each = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "A" }

  count     = var.type == "A" ? 1 : 0
  name      = local.naming
  zone      = var.zone
  ttl       = var.ttl
  addresses = var.records
}

resource "dns_cname_record" "cname" {
  # for_each = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "CNAME" }
  count = var.type == "CNAME" ? 1 : 0
  name  = local.naming
  zone  = var.zone
  ttl   = var.ttl
  cname = var.records
}

resource "dns_txt_record_set" "txt" {
  # for_each = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "TXT" }
  count = var.type == "TXT" ? 1 : 0
  # name  = var.name
  name = local.naming
  zone = var.zone
  ttl  = var.ttl
  txt  = var.records
}

resource "dns_aaaa_record_set" "aaa" {
  # for_each  = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "AAAA" }
  count     = var.type == "AAAA" ? 1 : 0
  name      = local.naming
  zone      = var.zone
  ttl       = var.ttl
  addresses = var.records
}

resource "dns_ns_record_set" "ns" {
  #for_each = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "NS" }
  count       = var.type == "NS" ? 1 : 0
  name        = local.naming
  zone        = var.zone
  ttl         = var.ttl
  nameservers = var.records
}

resource "dns_ptr_record" "ptr" {
  #for_each = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "PTR" }
  count = var.type == "PTR" ? 1 : 0
  name  = local.naming
  zone  = var.zone
  ttl   = var.ttl
  ptr   = var.records
}

resource "dns_mx_record_set" "mx" {
  #for_each = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "MX" }
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

resource "dns_srv_record_set" "srv" {
  #for_each = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "SRV" }

  count = var.type == "SRV" ? 1 : 0

  name = local.naming
  zone = var.zone
  ttl  = var.ttl
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