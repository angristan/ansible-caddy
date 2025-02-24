# Ansible role for Caddy 2

This is a role I made for myself but I tried to make it as reusable as possible while keeping it fitted to my use.

The role will handle all basic config like creating a systemd service, a user, conf folders, conf files, log folders, etc.

Then, you can use it to add vhosts using templates. The role include one sample reverse proxy template.

The role should work on all Debian-based distributions.

## Requirements

This role does not install Caddy from APT because I want the cloudflare module. Run `build.sh` to build a caddy binary.

## Role Variables

Basic configuration:

- `caddy_bin_path`: caddy binary path (`/usr/bin/caddy`)
- `caddy_log_path`: log directory (`/var/log/caddy`)
- `caddy_config_path`: configuration directory (`/etc/caddy`)

A user will be created (`caddy_user_name`), added to a group (`caddy_group_name`) with a specific UID (`caddy_user_id`) and GID (`caddy_group_id`). The default is `caddy/caddy` and `333/333`.

Use this config to use the Cloudflare API for the DNS-01 ACME challenge:

```yaml
cloudflare_token: xxx
caddy_tls_dns_cloudflare_enabled: true
caddy_env_vars:
  - "CLOUDFLARE_API_TOKEN={{ cloudflare_token }}"
```

Otherwise, Caddy will default to HTTP-01 or TLS-ALPN-01.

Vhosts configuration:

- `caddy_vhosts`: list of vhosts. (`[]`)
- `caddy_rm_unmanaged_vhosts`: remove unmanaged vhosts (default `false`)

Example:

```yml
caddy_vhosts:
  - name: site1
    hostname: site1.domain.tld
    proxy_host: http://10.0.0.1
    gzip: compress
    security_headers: true
    responds: ["/forbidden 403"]
    rewrites: ["* /path{uri}"]
  - name: site2
    hostname: site1.domain.tld
    ansible.builtin.template: custom_template.j2
```

By default, the vhosts will use the `reverse.j2` template included in the role. Look at it and the `defaults/main.yml` file for all variables!

- `caddy_vhost_defaults`: default vhost parameters. For each vhost in `caddy_vhosts`, it will be combined with the vhost's parameters. If a vhost defines an option that exist in `caddy_vhost_defaults`, the vhost option will overwrite the default one.

## Example playbook

```yaml
---
- hosts: myhost
  roles:
    - { role: angristan.caddy, tags: caddy }
  vars:
    caddy_vhosts:
      - name: "website"
        hostname: "website.tld"
```

## Usage

Add this to `requirements.yml`:

```yml
- src: https://github.com/angristan/ansible-caddy
  name: angristan.caddy
  version: vX.X.X
```

## Author Information

See my other Ansible roles at [angristan/ansible-roles](https://github.com/angristan/ansible-roles).
