FROM registry.access.redhat.com/ubi9/python-312:latest

RUN pip install --upgrade pip && \
    pip install ansible

COPY --chown=1001:1001 . /app

WORKDIR /app

# Add configuration to pull from Red Hat Automation Hub
RUN cat <<EOF >> ansible.cfg
[galaxy]
server_list = automation_hub, galaxy

[galaxy_server.automation_hub]
url = https://console.redhat.com/api/automation-hub/content/published/
auth_url = https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token

[galaxy_server.galaxy]
url = https://galaxy.ansible.com/
EOF

RUN --mount=type=secret,id=ah_token,uid=1001 \
    export ANSIBLE_GALAXY_SERVER_AUTOMATION_HUB_TOKEN="$(cat /run/secrets/ah_token)" && \
    ansible-galaxy collection install -r collections/requirements.yml

CMD ["ansible-playbook", "--inventory", "inventory/bootstrap.yml", "playbooks/bootstrap.yml"]