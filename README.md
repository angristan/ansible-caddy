# Ansible role for Caddy 

![travis build](https://api.travis-ci.org/angristan/ansible-caddy.svg?branch=master)

This is a role I made for myself but I tried to make it as reusable as possible while keeping it fitted to my use.

The role will handle all basic config like creating a systemd service, a user, conf folders, conf files, log folders, etc. 
The role will add the `cap_net_bind_service+ep` capability to the Caddy binary so that it can bind a <1024 port like 80 and 443.

Then, you can use it to add vhosts using templates. The role include one sample reverse proxy template.

The role should work on all Debian-based distributions.

## Requirements

The role **does not** handle the Caddy installation since it's a pain. To install Caddy, go to [caddyserver.com/download](https://caddyserver.com/download), choose your modules and use the download link / install script. Once it's done, you can run the role.

## Role Variables

Basic configuration:

- `caddy_bin_path`: caddy binary path (`/usr/local/bin/caddy`)
- `caddy_log_path`: log directory (`/var/log/caddy`)
- `caddy_config_path`: configuration directory (`/etc/caddy`)
- `caddy_ssl_path`: certificates directory (`/etc/ssl/caddy`)
- `caddy_quic_enabled`: Enable QUIC (true)

A user will be created (`caddy_user_name`), added to a group (`caddy_group_name`) with a specific UID (`caddy_user_id`) and GID (`caddy_group_id`). The default is `www-data/www-data` and `33/33`.

TLS configuration:

- `caddy_tls_key_type`: key algorithm that will be used to sign the certificates (`p256`)
- `caddy_tls_ciphers`: the cipher suite. This role's defaults remove unsecure ciphers. (`ECDHE-ECDSA-WITH-CHACHA20-POLY1305 ECDHE-ECDSA-AES128-GCM-SHA256 ECDHE-ECDSA-AES256-GCM-SHA384 ECDHE-ECDSA-AES128-CBC-SHA ECDHE-ECDSA-AES256-CBC-SHA`)
- `caddy_tls_curves`: ECDHE curves (`X25519 p521 p384 p256`)
- `caddy_tls_dns_enabled`: enabled the DNS ACME challenged to get certificates. (`false`)
- `caddy_tls_dns_provider`: if `caddy_tls_dns_enabled` is true, set the DNS provider to use.

If you're using a DNS provider, you have to specify the API keys. Example:

```yaml
caddy_tls_dns_enabled: true
caddy_tls_dns_provider: 'cloudflare'
caddy_env_vars:
  - "CLOUDFLARE_EMAIL={{ vault.cloudflare.email }}"
  - "CLOUDFLARE_API_KEY={{ vault.cloudflare.api_key }}"
```

Vhosts configuration:

- `caddy_vhosts`: list of vhosts. (`[]`)

Example:

```yml
caddy_vhosts:
  - name: site1
    hostname: site1.domain.tld
    proxy_host: 10.0.0.1
    gzip: true
    security_headers: true
    proxy_websocket: true
  - name: site2
    hostname: site1.domain.tld
    template: custom_template.j2
```

By default, the vhosts will use the `reverse.j2` template included in the role.

- `caddy_vhost_defaults`: default vhost parameters. For each vhost in `caddy_vhosts`, it will be combined with the vhost's parameters. If a vhost defines an option that exist in `caddy_vhost_defaults`, the vhost option will overwrite the default one.

## Example playbook

```yaml
---

- hosts: myhost
  roles: caddy
  vars:
    caddy_tls_dns_enabled: true
    caddy_tls_dns_provider: 'cloudflare'
    caddy_tls_key_type: 'p256'
    caddy_env_vars:
      - "ENV_VAR=value"
    caddy_vhosts:
      - name: 'website'
        template: 'custom_template.j2'
        hostname: 'website.tld'
        custom_var: 'custom_value'
```

## License

MIT

## Author Information

See my other Ansible roles at [angristan/ansible-roles](https://github.com/angristan/ansible-roles).
