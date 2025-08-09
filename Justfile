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

launch-chatgpt-telegram-bot:
    ansible-playbook ./playbooks/deploy-applications.yaml -K -i inventory/all/hosts --limit production --tags chatgpt_telegram_bot

launch-gotify:
    ansible-playbook ./playbooks/deploy-applications.yaml -i inventory/all/hosts --limit production --tags gotify

launch-manyfold:
    ansible-playbook ./playbooks/deploy-applications.yaml -K -i inventory/all/hosts --limit production --tags manyfold

launch-frigate:
    ansible-playbook ./playbooks/deploy-applications.yaml -i inventory/all/hosts --limit production --tags frigate

launch-jellystat:
    ansible-playbook ./playbooks/deploy-applications.yaml -i inventory/all/hosts --limit production --tags jellystat

launch-amcrest-sync:
    ansible-playbook ./playbooks/deploy-applications.yaml -K -i inventory/all/hosts --limit production --tags amcrest-sync

launch-container-registry:
    ansible-playbook ./playbooks/deploy-applications.yaml -K -i inventory/all/hosts --limit production --tags container-registry

launch-vocal-remover-app:
    ansible-playbook ./playbooks/deploy-applications.yaml -K -i inventory/all/hosts --limit production --tags vocal-remover-app

launch-archivebox:
    ansible-playbook ./playbooks/deploy-applications.yaml -K -i inventory/all/hosts --limit production --tags archivebox

launch-stirlingtools:
    ansible-playbook ./playbooks/deploy-applications.yaml -K -i inventory/all/hosts --limit production --tags stirlingtools

# launching remote ML container just with compose - translating to ansible feels not worth it right now
launch-immich:
    ansible-playbook ./playbooks/deploy-applications.yaml -K -i inventory/all/hosts --limit production --tags immich
    echo "make sure remote ML container is started with compose"
    # cd ./docker-composes/immich-remote-ml
    # docker compose up -d
    # cd -

launch-memes:
    ansible-playbook ./playbooks/deploy-applications.yaml -K -i inventory/all/hosts --limit production --tags immich-memes

get-vault-key:
    bws secret get $HOMELAB_BOT_VAULT_KEY_ID  | jq -r '.value'

encrypt:
    just get-vault-key > key
    ansible-vault encrypt inventory/all/group_vars/all.yml --vault-password-file key
    ansible-vault encrypt inventory/all/group_vars/production.yml --vault-password-file key
    ansible-vault encrypt inventory/all/group_vars/development.yml --vault-password-file key
    rm key

decrypt:
    just get-vault-key > key
    ansible-vault decrypt inventory/all/group_vars/all.yml --vault-password-file key
    ansible-vault decrypt inventory/all/group_vars/production.yml --vault-password-file key
    ansible-vault decrypt inventory/all/group_vars/development.yml --vault-password-file key
    rm key
