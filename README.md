# Terraform module named/bind

This module are designed to be used to manage dns record while using bind/named

## Install
To make this module work, please make sure:
1. You have rndc key and configured in named.conf. Please edit with your setup.
   ```/etc/rndc.key
   key "rndc-key" {
     algorithm hmac-sha256;
     secret "Y1PkZgy10ett0pmb0+KAueE1MyI9aPBZzrc76flKEmw=";
   };
   options {
     default-key "rndc-key";
     default-server 127.0.0.1;
     default-port 953;
   };

   ```
1. Configure domain as primary and allow the key.
   ```
    key "rndc-key" {
       algorithm hmac-sha256;
       secret "Y1PkZgy10ett0pmb0+KAueE1MyI9aPBZzrc76flKEmw=";
    };
    #
    controls {
          inet 127.0.0.1 port 953
                   allow { 127.0.0.1; } keys { "rndc-key"; };
    };
    .... //some domains
    zone "example.com." IN {
        type master;
        file "/var/cache/bind/example.com.db";
        zone-statistics yes;
        allow-update { key rndc-key; };
    };
   ```
1. Save and restart the named daemon
1. Crete base directory and create terraform file to load the module. See [example/example.tf](example/example.tf)
1. Create a files that contain variables to support the terraform file. See [example/input.auto.tfvars.json](example/input.auto.tfvars.json) and subtitute source with `source = "github.com/udienz/terraform-module-named"`
1. See below for the directory contents
   ```
   $ ls -1
   example.tf
   input.auto.tfvars.json
   ```
1. Run terraform plan, review and apply
