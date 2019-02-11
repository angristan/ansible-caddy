# Ansible role for Caddy

This is role I made for myself but I tried to make it as reusable as possible while keeping it fitted to my use.

The role **does not** handle the Caddy installation since it's a pain. To install Caddy, go to [addyserver.com/download](https://caddyserver.com/download), choose your modules and use the download link / install script. Once it's done, you can run the role.

The role will handle all basic config like creating a systemd service, a user, conf folders, conf files, log folders, etc. 
The role will add the `cap_net_bind_service+ep` capability to the Caddy binary so that it can bind a <1024 port like 80 and 443.

Then, you can use it to add vhosts using templates. The role include one sample reverse proxy template.

The role should work on all Debian-based distributions.

## Sample playbook

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
