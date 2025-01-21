module "named_dns" {
  source = "../"
  for_each = { for dns_records in local.dns_records_list : dns_records.name => dns_records }

  
}