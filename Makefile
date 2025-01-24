PROVISION_PATH=terraform/main
PACKER_PATH=packer
DEPLOY_PATH=ansible
include .env
export

.PHONY: provision deploy all destroy re build_ami

all: build_ami provision deploy

build_ami: packer
	packer init $(PACKER_PATH)/database.pkr.hcl
	@PKR_VAR_AWS_REGION=$(AWS_REGION) \
	PKR_VAR_MYSQL_USER=$(MYSQL_USER) \
	PKR_VAR_MYSQL_PASSWORD=$(MYSQL_PASSWORD) \
	PKR_VAR_DATABASE_NAME=$(DATABASE_NAME) \
	PKR_VAR_MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) \
	packer build $(PACKER_PATH)/database.pkr.hcl

provision: terraform
	terraform -chdir=$(PROVISION_PATH) init
	@TF_VAR_AWS_REGION=$(AWS_REGION) \
	TF_VAR_SERVER_INSTANCE_COUNT=$(SERVER_INSTANCE_COUNT) \
	TF_VAR_SSH_IP=$(SSH_IP) \
	TF_VAR_SSH_PUBLIC_KEY_PATH=$(SSH_PUBLIC_KEY_PATH) \
	terraform -chdir=$(PROVISION_PATH) apply -auto-approve

deploy: ansible
	@DB_PRIVATE_IP="$(shell terraform -chdir=$(PROVISION_PATH) output -json db_private_ip | jq -r '.[]' | tr '\n' ' ')" \
	ANSIBLE_HOST_KEY_CHECKING=False \
	ANSIBLE_REMOTE_USER=ubuntu \
	AWS_DEFAULT_REGION=$(AWS_REGION) \
	ANSIBLE_PYTHON_INTERPRETER=auto_silent \
	ansible-playbook \
	-i $(DEPLOY_PATH)/inventories \
	--private-key=$(SSH_PRIVATE_KEY_PATH) \
	$(DEPLOY_PATH)/server.yml 

destroy: terraform
	@TF_VAR_AWS_REGION=$(AWS_REGION) \
	TF_VAR_SERVER_INSTANCE_COUNT=$(SERVER_INSTANCE_COUNT) \
	TF_VAR_SSH_IP=$(SSH_IP) \
	TF_VAR_SSH_PUBLIC_KEY_PATH=$(SSH_PUBLIC_KEY_PATH) \
	terraform -chdir=$(PROVISION_PATH) destroy -auto-approve

re: destroy all
