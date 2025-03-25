# Cloudkit Global_config Ansible Project

This repository is used to boostrap and configure globally the Ansile Automation Platform instance in the scope of cloudkit.

## Pre-requisites

### Get an access token from Red Hat Automation Hub

These set of playbooks depends on collections stored on Red Hat Automation Hub, we need a token to get access to them:

- Go on https://console.redhat.com/ansible/automation-hub/token
- Click on "Load token", and store it in a file. The rest of this documnent will assume that you stored it in `/home/myself/.ah_token`
- Download the dependencies:

```
export ANSIBLE_GALAXY_SERVER_AUTOMATION_HUB_TOKEN="$(/home/myself/.ah_token)"
ansible-galaxy collection install -r collections/requirements.yml
```

## Bootstrap playbook

The boostrap playbook is packaged as a container imag, and it is meant to be run from the kubernetes job, it has 2 main goals:

- Register AAP against Red Hat
- Create the minimal configuration requird to run the global playbook:
    - Create an organization named "global"
    - Create a project pointing to this repo
    - Create a job template with the "global_config" playbook
    - (Credentials ?)

In order to run, it requires to following credentials:

- RHSM login/password
- AAP super-admin credentials

## Global config playbook

The global config playbook configures AAP "globally", it means its configuration is mainly focus at creating the minimal resources that allows a user to configure its own organization:
- an organization
- an admin user for this organization
- a project pointing to the git repository that will define the configuration for this organization
- a job template that will point to the configuration playbook inside the project

## Build bootstrap container image

Depenant collections are downloaded at build time, Red Hat Automation Hub token is expected to be passed this way:

```
podman build . --secret id=ah_token,src=/home/myself/.ah_token -f Containerfile -t mytag
```