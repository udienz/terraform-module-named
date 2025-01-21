# If the record are A
resource "dns_a_record_set" "a" {
  for_each = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "A" }

  name      = each.value.name
  zone      = var.zone
  ttl       = each.value.ttl
  addresses = each.value.records
}

resource "dns_cname_record" "cname" {
  for_each = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "CNAME" }

  name  = each.value.name
  zone  = var.zone
  ttl   = each.value.ttl
  cname = each.value.records
}

resource "dns_txt_record_set" "txt" {
  for_each = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "TXT" }
  name     = each.value.name
  zone     = var.zone
  ttl      = each.value.ttl
  txt      = each.value.records
}

resource "dns_aaaa_record_set" "aaa" {
  for_each  = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "AAAA" }
  name      = each.value.name
  zone      = var.zone
  ttl       = each.value.ttl
  addresses = each.value.records
}

resource "dns_ns_record_set" "ns" {
  for_each = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "NS" }

  name        = each.value.name
  zone        = var.zone
  ttl         = each.value.ttl
  nameservers = each.value.records
}

resource "dns_ptr_record" "ptr" {
  or_each = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "PTR" }

  name = each.value.name
  zone = var.zone
  ttl  = each.value.ttl
  ptr  = each.value.records
}

resource "dns_mx_record_set" "mx" {
  for_each = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "MX" }
  name     = each.value.name
  zone     = var.zone
  ttl      = each.value.ttl

  dynamic "mx" {
    for_each = var.records
    content {
      preference = each.value.preference
      exchange   = each.value.exchange
    }
  }
}

resource "dns_srv_record_set" "srv" {
  or_each = { for key, value in var.dns_records : value.dns_records.name => value if value.type == "SRV" }

  name = each.value.name
  zone = var.zone
  ttl  = each.value.ttl
  dynamic "srv" {
    for_each = var.records
    content {
      priority = each.value.priority
      weight   = each.value.weight
      target   = each.value.target
      port     = each.value.port
    }
  }
}