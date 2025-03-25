FROM registry.access.redhat.com/ubi9/python-312:latest

RUN pip install --upgrade pip && \
    pip install ansible

COPY . /app

WORKDIR /app

RUN --mount=type=secret,id=ah_token,uid=1001 \
    export ANSIBLE_GALAXY_SERVER_AUTOMATION_HUB_TOKEN="$(cat /run/secrets/ah_token)" && \
    ansible-galaxy collection install -r collections/requirements.yml

CMD ["ansible-playbook", "--inventory", "inventory/bootstrap.yml", "playbooks/bootstrap.yml"]