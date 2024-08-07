.PHONY: help
SHELL    := /bin/bash

help:
	@echo 'Available Commands:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":"}; { if ($$3 == "") { printf " - \033[36m%-18s\033[0m %s\n", $$1, $$2 } else { printf " - \033[36m%-18s\033[0m %s\n", $$2, $$3 }}'

cluster-template: ## Kops update the cluster template only
	@./cluster-template.sh

cluster-update: ## Kops update cluster state from cluster manifest
	@./cluster-update.sh

cluster-get: ## Kops get cluster info
	@source cluster-config.sh && kops get all $$CLUSTER_NAME \
		--state $$ClUSTER_STATE

cluster-destroy-yes: ## Kops destroy cluster
	source cluster-config.sh && kops delete cluster \
		--state $$ClUSTER_STATE \
		--name $$CLUSTER_NAME \
		--unregister \
		--yes

kops-cmd: ## Kops custom cmd, eg make KOPS_CMD="get secrets" kops-cmd
	@source cluster-config.sh && kops ${KOPS_CMD} \
		--state $$ClUSTER_STATE \
		--name $$CLUSTER_NAME

kops-kubeconfig: ## Kops export kubeconfig
	source cluster-config.sh && kops export kubeconfig $$CLUSTER_NAME ${KOPS_CMD} \
		--state $$ClUSTER_STATE --kubeconfig $$CLUSTER_NAME --admin

cluster-validate: ## Kops validate cluster against the current state
	@source cluster-config.sh && kops validate cluster \
		--state $$ClUSTER_STATE \
		--name $$CLUSTER_NAME

cluster-rolling-update: ## Kops perform a rolling update on the cluster -- only dry run, no changes will be applied
	@source cluster-config.sh && kops rolling-update cluster \
		--state $$ClUSTER_STATE \
		--name $$CLUSTER_NAME

cluster-rolling-update-yes: ## Kops perform a rolling update on the cluster
	@source cluster-config.sh && kops rolling-update cluster \
		--state $$ClUSTER_STATE \
		--name $$CLUSTER_NAME \
		--yes

# #########################
#
#
#cluster-rolling-update-yes-force-masters: ## Kops perform a rolling update on the cluster masters
#	source cluster-config.sh && kops rolling-update cluster \
#		--state $$ClUSTER_STATE \
#		--name $$CLUSTER_NAME \
#		--instance-group-roles=Master \
#		--yes \
#		--force
#
#cluster-destroy: ## Kops destroy cluster -- only dry run, no changes will be applied
#	source cluster-config.sh && kops delete cluster \
#		--state $$ClUSTER_STATE \
#		--name $$CLUSTER_NAME \
#		--unregister
#
#cluster-destroy-yes: ## Kops destroy cluster
#	source cluster-config.sh && kops delete cluster \
#		--state $$ClUSTER_STATE \
#		--name $$CLUSTER_NAME \
#		--unregister \
#		--yes
#
