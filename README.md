# homelab-dev


# Production

> homelab-mono is where my applications are deployed from


## Assumptions

- ZFS datasets are created
- Any encryption is automatically decrypted
- Systemd is setup with dependencies such that docker doesn't start until ZFS datasets are mounted
- Bitwarden Secrets CLI is set. I'm using my .envrc file (ignored) to set my access token as well as an environment variable for the ansible vault key value in my vault.
- `just encrypt` before commit - I vault the entire inventory file out of simplicity

### Env Setup

Here's an example `.envrc` file you can use with direnv to automatically setup your shell so that `just <command> can use bitwarden secrets in deployment and you don't have to keep sensitive info all over the place

```bash
#!/bin/bash

source .venv/bin/activate || (uv venv && source .venv/bin/activate)

# For Bitwarden Secrets Manager
# bitwarden login -> secrets manager -> projects -> <whatever project> -> machine accounts
export BWS_ACCESS_TOKEN=YOUR-BWS-ACCESS-TOKEN
export HOMELAB_BOT_VAULT_KEY_ID=KEY_ID_FOR_ANSIBLE_VAULT_KEY_IN_BWS
```

