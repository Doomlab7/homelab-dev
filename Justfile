deploy-signoz:
  #!/usr/bin/env bash
  pushd /home/nic/third-party/signoz/deploy/
  # DOCKER_HOST="ssh://koober" docker-compose -f /home/nic/third-party/signoz/deploy/docker/clickhouse-setup/docker-compose.yaml up -d
  docker-compose -f /home/nic/third-party/signoz/deploy/docker/clickhouse-setup/docker-compose.yaml up -d
  popd

test-ping-prd:
    ansible-playbook ./playbooks/ping.yaml -i inventory/all/hosts --limit production

test-ping-dev:
    ansible-playbook ./playbooks/ping.yaml -i inventory/all/hosts --limit development

setup-dev-server:
    ansible-playbook -bK ./playbooks/server-setup.yaml -i inventory/all/hosts --limit development -v

launch-gotify:
    ansible-playbook ./playbooks/deploy-applications.yaml -i inventory/all/hosts --limit production --tags gotify

launch-manyfold:
    ansible-playbook ./playbooks/deploy-applications.yaml -K -i inventory/all/hosts --limit production --tags manyfold -vv

launch-frigate:
    ansible-playbook ./playbooks/deploy-applications.yaml -i inventory/all/hosts --limit production --tags frigate

launch-amcrest-sync:
    ansible-playbook ./playbooks/deploy-applications.yaml -K -i inventory/all/hosts --limit production --tags amcrest-sync

get-vault-key:
    bws secret get $HOMELAB_BOT_VAULT_KEY_ID  | jq -r '.value'

encrypt:
    just get-vault-key >> key
    ansible-vault encrypt inventory/all/group_vars/all.yml --vault-password-file key
    ansible-vault encrypt inventory/all/group_vars/production.yml --vault-password-file key
    ansible-vault encrypt inventory/all/group_vars/development.yml --vault-password-file key
    rm key

decrypt:
    just get-vault-key >> key
    ansible-vault decrypt inventory/all/group_vars/all.yml --vault-password-file key
    ansible-vault decrypt inventory/all/group_vars/production.yml --vault-password-file key
    ansible-vault decrypt inventory/all/group_vars/development.yml --vault-password-file key
    rm key