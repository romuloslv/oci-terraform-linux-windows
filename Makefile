cnf ?= .env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## Esta Ajuda(help).
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

terraform-init: ## Executa terraform init para download de todos os plugins necessários
	  terraform init

terraform-plan: ## Executado terraform plan e colocando tudo em um arquivo chamado tfplan
	  terraform plan

terraform-apply: ## Usando o arquivo tfplan para aplicar as alterações
	  terraform apply tfplan
	  
